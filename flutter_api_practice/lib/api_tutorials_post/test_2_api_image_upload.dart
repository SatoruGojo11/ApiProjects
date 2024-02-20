import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_practice/models/text.dart';
import 'package:flutter_api_practice/models/textformfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Test2ImageUploadPost extends StatefulWidget {
  const Test2ImageUploadPost({super.key});

  @override
  State<Test2ImageUploadPost> createState() => _Test2ImageUploadPostState();
}

class _Test2ImageUploadPostState extends State<Test2ImageUploadPost> {
  final _validationkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showSpinner = false;
  File? image;
  final _picker = ImagePicker();

  // loginUser(email, password) async {
  //   Response response =
  //       await Dio().post('https://fakestoreapi.com/products', data: {
  //     'Email-id': email,
  //     'Password': password,
  //   });

  //   if (response.statusCode == 200) {
  //     log(response.data.toString());
  //     log('Data Posted Successfully');
  //   } else {
  //     log(response.statusCode.toString());
  //     log(response.statusMessage.toString());
  //     log('Data Not Posted Successfully');
  //   }
  // }

  Future addImage() async {
    final pickImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickImage != null) {
      image = File(pickImage.path);
      log('Image Selected');
    } else {
      log('Image not Selected');
    }
  }

  Future uploadData(email, password) async {
    setState(() {
      showSpinner = true;
    });

    FormData formData = FormData.fromMap({
      'Email-id': email,
      'Password': password,
      'Photo': MultipartFile.fromFile(image!.path, filename: 'image.png'),
    });

    Dio().interceptors.add(InterceptorsWrapper(
      onError: (DioException error, handler) {
        log(error.toString());
        return handler.next(error);
      },
    ));

    var response =
        await Dio().post('https://fakestoreapi.com/products', data: formData);

    if (response.statusCode == 200) {
      log(response.statusCode.toString(), name: 'If Part');
      log('Data sended Successfully');
    } else {
      log(response.statusCode.toString(), name: 'Else Part');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: text('Test 2 Image Upload using Api Post Method'),
        ),
        body: Center(
          child: Padding(
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
                Container(
                    child: image == null
                        ? Center(
                            child: ElevatedButton(
                              onPressed: addImage,
                              child: text('Add Photo'),
                            ),
                          )
                        : Center(
                            child: Image.file(
                              File(image!.path).absolute,
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          )),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    log('Button Clicked');
                    uploadData(
                      emailController.text.toString(),
                      passwordController.text.toString(),
                    );
                  },
                  child: text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}