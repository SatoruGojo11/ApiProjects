import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_practice/model_classes/model_class_postdata.dart';
import 'package:flutter_api_practice/models/text.dart';

class Test2 extends StatefulWidget {
  const Test2({super.key});

  @override
  State<Test2> createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com/posts',
      connectTimeout: const Duration(milliseconds: 40000),
      receiveTimeout: const Duration(milliseconds: 40000),
    ),
  );
  List<PostData> posts = [];
  String baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  // ignore: prefer_typing_uninitialized_variables
  var data;

  Stream<List<PostData>> fetchDataFromApi() async* {
    final responseGet = await dio.get(baseUrl);
    data = responseGet.data;

    try {
      if (responseGet.statusCode == 200) {
        for (Map<String, dynamic> i in data) {
          posts.add(PostData.fromJson(i));
        }
        yield posts;
      } else {
        const Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        );
        yield posts;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteData(int id) async {
    final responseDel =
        await dio.delete('https://jsonplaceholder.typicode.com/posts/$id');

    try {
      if (responseDel.statusCode == 200) {
        log(data.toString(), name: 'Response Data after deletion');
        log(responseDel.data.toString(), name: 'Response Data at $id');
      } else {
        log(responseDel.statusCode.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text(
          'Test 2 Api Model Mapping Method',
          fontSize: 20,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder(
          stream: fetchDataFromApi(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  height: 5,
                  color: Colors.black,
                ),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      tileColor: Colors.blue,
                      leading: text((index + 1).toString()),
                      title: text(
                          'Title :- ${snapshot.data?[index].title.toString() ?? ''}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(
                              'Body :- ${snapshot.data?[index].body.toString() ?? ''}'),
                        ],
                      ),
                      trailing: IconButton(
                          onPressed: () async {
                            await deleteData(index);
                          },
                          icon: const Icon(Icons.delete)),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          },
        ),
      ),
    );
  }
}
