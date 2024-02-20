import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_practice/models/text.dart';
import 'package:flutter_api_practice/models/textformfield.dart';

class Test1Post extends StatefulWidget {
  const Test1Post({super.key});

  @override
  State<Test1Post> createState() => _Test1PostState();
}

class _Test1PostState extends State<Test1Post> {
  final _validationkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Dio dio = Dio();
  loginMethod(String email, String password) async {
    try {
      Response response = await dio.post('https://reqres.in/api/users', data: {
        "email": email,
        "password": password,
      });
      if (response.statusCode == 201) {
        log('Data Added');
        // var data = response.data['token'];

        log(response.data.toString(), name: 'Data');

        if (context.mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ));
        }
      } else {
        log('Registration Not Successful');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        log(e.response!.data.toString(), name: 'If Part 1');
        log(e.response!.headers.toString(), name: 'If Part 2');
        log(e.response!.requestOptions.toString(), name: 'If Part 3');
      } else {
        log(e.requestOptions.toString(), name: 'Else Part 1');
        log(e.message.toString(), name: 'Else Part 2');
        log(e.error.toString(), name: 'Else Part 3');
      }
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text('Test 1 Post Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _validationkey,
              child: Column(
                children: [
                  textformfield(
                    emailController,
                    "Enter your Email-id",
                    "Email-id",
                    prefixicn: const Icon(Icons.email),
                    keyboardtype: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter your Email-id";
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return "Please Enter valid Email-id";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  textformfield(
                    passwordController,
                    "Enter your Password",
                    "Password",
                    prefixicn: const Icon(Icons.account_circle),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter your Password";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[500],
                  elevation: 10,
                  shadowColor: Colors.green,
                  fixedSize: const Size(100, 50)),
              onPressed: () {
                log('Button clicked');
                if (_validationkey.currentState!.validate()) {
                  loginMethod(
                    emailController.text.toString(),
                    passwordController.text.toString(),
                  );
                }
              },
              child: text(
                'Submit',
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future fetchDataFromApi() async {
    final response = await Dio().get('https://reqres.in/api/users');

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text('Home Page'),
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchDataFromApi(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title:
                        text('Email :- ${snapshot.data['total'].toString()}'),
                    subtitle: text(
                        'Password :- ${snapshot.data['total'].toString()}'),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
