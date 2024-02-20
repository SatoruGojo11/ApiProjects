import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_practice/model_classes/model_class_products.dart';
import 'package:flutter_api_practice/models/text.dart';

class Test3 extends StatefulWidget {
  const Test3({super.key});

  @override
  State<Test3> createState() => _Test3State();
}

class _Test3State extends State<Test3> {
  Dio dio = Dio();

  Future<Products> fetchDataFromApi() async {
    final response = await dio
        .get('https://webhook.site/f844d3b2-247a-491c-b969-ed7637c82c88');
    var data = jsonDecode(response.data);
    if (response.statusCode == 200) {
      return Products.fromJson(data);
    } else {
      return Products.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text('Test 3 Api Model Mapping Method'),
      ),
      body: Center(
        child: FutureBuilder<Products>(
          future: fetchDataFromApi(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.data.length,
                itemBuilder: (context, index) {
                  var h1 = MediaQuery.of(context).size.height;
                  var w1 = MediaQuery.of(context).size.width;
                  return Column(
                    children: [
                      SizedBox(
                        height: h1 * .3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.data[index].images.length,
                            itemBuilder: (context, position) {
                              return Container(
                                height: h1 * .25,
                                width: w1 * .5,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: NetworkImage(
                                      snapshot.data!.data[index]
                                          .images[position].url,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
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
