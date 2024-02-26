// import 'dart:io';

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_graph_ql_prac/models/text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gql_dio_link/gql_dio_link.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Test2 extends StatefulWidget {
  const Test2({super.key});

  @override
  State<Test2> createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  bool loading = true;
  List<dynamic> apiData = [];

  fetchData() async {
    setState(() {
      loading = false;
    });

    try {
      final Link link = DioLink(
        "https://graphqlzero.almansi.me/api",
        client: Dio(),
      );

      // HttpLink httpLink = HttpLink("https://graphqlzero.almansi.me/api");

      GraphQLClient graphQLClient = GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      );

      QueryResult queryResult = await graphQLClient.query(
        QueryOptions(
          document: gql("""
          query{
  photos{
    data{
      id
      title
      thumbnailUrl
    }
  }
}
        """),
        ),
      );

      setState(() {
        apiData = queryResult.data?['photos']['data'] ?? [];
        log(apiData.toString(), name: 'Api Data Set State');
        loading = true;
      });

      if (apiData.isEmpty) {
        Fluttertoast.showToast(msg: 'List is Empty.');
      } else if (apiData.isNotEmpty) {
        Fluttertoast.showToast(msg: 'List is not Empty.');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text('Test 2 Page'),
      ),
      body: loading
          ? apiData.isEmpty
              ? Center(
                  child: ElevatedButton(
                      onPressed: fetchData, child: text('Fetch Data')),
                )
              : ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(apiData[index]['thumbnailUrl']),
                      ),
                      title: text('Title :- ${apiData[index]['id']}'),
                      subtitle: text('Title :- ${apiData[index]['title']}'),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 5,
                  ),
                  itemCount: apiData.length,
                )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
