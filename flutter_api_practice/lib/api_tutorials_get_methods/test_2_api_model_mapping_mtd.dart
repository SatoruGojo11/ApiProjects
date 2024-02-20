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
  Dio dio = Dio();
  List<PostData> posts = [];

  Future<List<PostData>> fetchDataFromApi() async {
    final response =
        await dio.get('https://jsonplaceholder.typicode.com/posts');
    var data = response.data;

    try {
      if (response.statusCode == 200) {
        for (Map<String, dynamic> i in data) {
          posts.add(PostData.fromJson(i));
        }

        return posts;
      } else {
        const Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        );
        return posts;
      }
    } catch (e) {
      throw e.toString();
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
        child: FutureBuilder(
          future: fetchDataFromApi(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: text((index + 1).toString()),
                    title: text(
                        'Title :- ${snapshot.data![index].title.toString()}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(
                            'Body :- ${snapshot.data![index].body.toString()}'),
                      ],
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
