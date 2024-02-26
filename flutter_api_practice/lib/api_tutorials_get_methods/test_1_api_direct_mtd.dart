import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_practice/models/text.dart';

class Test1 extends StatefulWidget {
  const Test1({super.key});

  @override
  State<Test1> createState() => _Test1State();
}

class _Test1State extends State<Test1> {
  // Direct Method
  List dataList = [];

  Future fetchDataFromApi() async {
    Dio dio = Dio();

    try {
      var response =
          await dio.get('https://jsonplaceholder.typicode.com/posts');

      if (response.statusCode == 200) {
        log(response.statusCode.toString());
        log(response.data.length.toString(), name: 'Response Data');

        dataList.clear();

        for (int i = 0; i < response.data.length; i++) {
          log(i.toString());
          Map<String, dynamic> data = response.data[i];
          log(data.toString(), name: 'APi Data');

          dataList.add(data);
        }
        log(dataList.toString(), name: 'Data List');
        return dataList;
      } else {
        log(response.statusCode.toString(), name: 'Status code Not Valid');
      }
    } catch (e) {
      log(e.toString(), name: 'Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text(
          'Test 1 Api Direct Method',
          fontSize: 20,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchDataFromApi(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: text((index + 1).toString()),
                    title: text('Title :- ${dataList[index]['title']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text('Body :- ${dataList[index]['body']}}'),
                        // text('Email-id :- ${apiData[index]['email']}'),
                        // text('Phone-No. :- ${apiData[index]['phone']}'),
                        // text('City :- ${apiData[index]['address']['city']}'),
                      ],
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
