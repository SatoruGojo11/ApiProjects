import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_graph_ql_prac/models/text.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Test4 extends StatefulWidget {
  const Test4({super.key});

  @override
  State<Test4> createState() => _Test4State();
}

class _Test4State extends State<Test4> {
  Future createUser(
    String? name,
    String? username,
    String? email,
  ) async {
    GraphQLClient graphQLClient = GraphQLClient(
      link: HttpLink("https://graphqlzero.almansi.me/api"),
      cache: GraphQLCache(),
    );

    QueryResult queryResult = await graphQLClient.mutate(
      MutationOptions(
        document: gql(r"""
    mutation create($name :String!, $uname : String!,$email :String!){
      createUser(input : {
        email : $email
        name : $name,
        username : $uname
      }){
        name
        id
        __typename
        email
        username
      }
    }"""),
        variables: {"name": name, "uname": username, "email": email},
      ),
    );

    log(queryResult.data.toString(), name: 'Data');
    return queryResult.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: text('Test 4 Page'),
      ),
      body: FutureBuilder(
        future: createUser('Jaydip', 'Jd01', "jd@gmail.com"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(
              color: Colors.black,
            );
          } else if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              // return Container(
              //   height: 100,
              //   width: double.maxFinite,
              //   color: Colors.red,
              //   child: Column(
              //     children: [
              //       text('Name :- ${snapshot.data['createUser']['name']}'),
              //       text(
              //           'Username :- ${snapshot.data['createUser']['username']}'),
              //       text(
              //           'Email-id :- ${snapshot.data['createUser']['email']}'),
              //       text(snapshot.data['createUser']['id'])
              //     ],
              //   ),
              // );

              // return ListView.builder(
              //   itemCount: 1,
              //   itemBuilder: (context, index) => ListTile(
              //     tileColor: Colors.amber,
              //     title:
              //         text('Name :- ${snapshot.data['createUser']['name']}'),
              //     subtitle: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         text(
              //             'Username :- ${snapshot.data['createUser']['username']}'),
              //         text(
              //             'Email-id :- ${snapshot.data['createUser']['email']}'),
              //       ],
              //     ),
              //     leading: text(snapshot.data['createUser']['id']),
              //   ),
              // );
              // return listview(
              //   child: ListTile(
              //     tileColor: Colors.amber,
              //     title: text(
              //         'Name :- ${snapshot.data['createUser']['name']}'),
              //     subtitle: Column(
              //       mainAxisSize: MainAxisSize.min,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         text(
              //             'Username :- ${snapshot.data['createUser']['username']}'),
              //         text(
              //             'Email-id :- ${snapshot.data['createUser']['email']}'),
              //       ],
              //     ),
              //     leading: Center(
              //         child: text(snapshot.data['createUser']['id'])),
              //   ),
              // );
            }
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        },
      ),
    );
  }
}


/*
return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) => ListTile(
                    tileColor: Colors.amber,
                    title:
                        text('Name :- ${snapshot.data['createUser']['name']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(
                            'Username :- ${snapshot.data['createUser']['username']}'),
                        text(
                            'Email-id :- ${snapshot.data['createUser']['email']}'),
                      ],
                    ),
                    leading: text(snapshot.data['createUser']['id']),
                  ),
                );

*/