import 'package:flutter/material.dart';
import 'package:flutter_graph_ql_prac/screens/graph_ql_usersapi_mutation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();

  // Both the Above lines are recommended for graphql_flutter GraphCache()

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Test4(),
    ),
  );
}
