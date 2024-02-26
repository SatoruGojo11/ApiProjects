// ignore_for_file: unused_local_variable, unnecessary_import

import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_graph_ql_prac/models/text.dart';
// import 'package:gql_dio_link/gql_dio_link.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Test1 extends StatefulWidget {
  const Test1({super.key});

  @override
  State<Test1> createState() => _Test1State();
}

class _Test1State extends State<Test1> {
  bool loading = false;
  List characters = [];

  Dio dio = Dio();

  fetchData() async {
    setState(() {
      loading = true;
    });
    try {
      // final Link link =
      //     DioLink("https://rickandmortyapi.com/graphql", client: Dio());

      HttpLink httpLink = HttpLink("https://rickandmortyapi.com/graphql");

      GraphQLClient graphQLClient = GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(),
      );

      QueryResult queryResult = await graphQLClient.query(
        QueryOptions(
          document: gql("""
              query {
                characters(){
                  results{
                    name
                    image
                  status
                  gender
                  }
                }
              }
          """),
        ),
      );

      setState(() {
        characters = queryResult.data?['characters']['results'] ?? '';
        loading = false;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text('Graph QL Practice Page of Rick and Morty api'),
      ),
      body: Center(
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : characters.isEmpty
                ? Center(
                    child: ElevatedButton(
                        onPressed: fetchData, child: text('Fetch Data')),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 5,
                      ),
                      itemCount: characters.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          tileColor: Colors.amber,
                          title: text('Name :- ${characters[index]['name']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text('Status :- ${characters[index]['status']}'),
                              text('Gender :- ${characters[index]['gender']}'),
                            ],
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.red,
                            maxRadius: 29,
                            backgroundImage: NetworkImage(
                              characters[index]['image'],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
