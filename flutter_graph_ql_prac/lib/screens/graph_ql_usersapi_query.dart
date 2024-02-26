import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_graph_ql_prac/models/text.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Test3 extends StatefulWidget {
  const Test3({super.key});

  @override
  State<Test3> createState() => _Test3State();
}

class _Test3State extends State<Test3> {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: ValueNotifier(
        GraphQLClient(
          link: HttpLink("https://graphqlzero.almansi.me/api"),
          cache: GraphQLCache(),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: text('Test 3 Page'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Query(
              options: QueryOptions(
//                 document: gql("""
// query {
//   user(id: 1) {
//     id
//     username
//     name
//     email
//     address{
//       city
//     }
//     phone
//   }
// }"""),
//               ),
                document: gql("""
query{
  users{
    data{
      id
      username
      name
      email
      address{
          city
        }
      phone
    }
  }
}"""),
              ),
              builder: (QueryResult result, {fetchMore, refetch}) {
                if (result.data != null) {
                  final apiData = result.data?['users']['data'];
                  return ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 5,
                    ),
                    itemCount: apiData.length,
                    itemBuilder: (context, index) {
                      var phone = apiData[index]['phone'].toString();
                      if (phone.contains(' ')) {
                        phone = phone.split(' ').first.toString();
                      }
                      return ListTile(
                        tileColor: Colors.amber,
                        title:
                            text('Username :- ${apiData[index]['username']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text('Name :- ${apiData[index]['name']}'),
                            text('Email-id :- ${apiData[index]['email']}'),
                            text('Phone-No :- $phone'),
                            text(
                                'City :- ${apiData[index]['address']['city']}'),
                          ],
                        ),
                        leading: text(apiData[index]['id']),
                      );
                    },
                  );
                } else if (result.hasException) {
                  log(result.exception.toString(),
                      name: 'Result has Exception');
                  return Center(
                    child: text('Something not Correct'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
