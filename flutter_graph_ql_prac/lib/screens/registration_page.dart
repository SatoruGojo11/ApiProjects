import 'package:flutter/material.dart';
import 'package:flutter_graph_ql_prac/models/text.dart';
import 'package:flutter_graph_ql_prac/models/textformfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _validationkey = GlobalKey<FormState>();

  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: text(
          'Login Page',
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 25,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Login Page',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Welcome to the Register Page...',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _validationkey,
                    child: Column(
                      children: [
                        textformfield(
                          usernamecontroller,
                          "Enter your name",
                          "Username",
                          RegExp('[a-zA-z1-90]'),
                          prefixicn: const Icon(Icons.account_circle),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter your name";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        textformfield(
                          emailcontroller,
                          "Enter your Email-id",
                          "Email-id",
                          RegExp('[a-zA-z@.1-90]'),
                          prefixicn: const Icon(Icons.email),
                          keyboardtype: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter your Email-id";
                            } else if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return "Please Enter valid Email-id";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        textformfield(
                          phonecontroller,
                          "Enter your Phone-no",
                          "Phone No.",
                          RegExp('[1-90]'),
                          prefixicn: const Icon(Icons.phone),
                          maxLength: 10,
                          keyboardtype: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter your Phone-no.";
                            } else if (value.length < 10) {
                              return "Please Enter valid Phone-no.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[500],
                        elevation: 10,
                        shadowColor: Colors.green,
                        fixedSize: const Size(100, 50)),
                    onPressed: () {},
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
          ),
        ),
      ),
    );
  }
}

/*

type User {
id: ID
name: String
username: String
email: String
address: Address
phone: String
website: String
company: Company
posts(...): PostsPage
albums(...): AlbumsPage
todos(...): TodosPage
}

*/