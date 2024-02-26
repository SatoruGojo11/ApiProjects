import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:flutter_api_practice/models/text.dart';
import 'package:flutter_api_practice/models/textformfield.dart';

import 'package:http_parser/http_parser.dart';

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

  Future<void> addImage() async {
    try {
      final XFile? pickImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      log(pickImage?.path ?? '', name: 'Pick image Data');

      log('try part');
      if (pickImage != null) {
        setState(() {
          image = File(pickImage.path);
        });
        log('Image Selected');
        log(image?.path.toString() ?? '');
      } else {
        Fluttertoast.showToast(
          msg: 'File not found',
          backgroundColor: Colors.red,
        );
      }
    } on PlatformException catch (e) {
      log('Failed to Load Image $e');
    } catch (e) {
      log(e.toString());
    }
  }

  Future uploadData(email, password) async {
    setState(() {
      showSpinner = true;
    });

    final fileName = image?.path.split('/').last;
    FormData formData = FormData.fromMap({
      'Email-id': email,
      'Password': password,
      'Photo': await MultipartFile.fromFile(
        image?.path ?? '',
        filename: fileName,
        contentType: MediaType("image", "jpeg"),
      ),
    });

    try {
      var responsePOST = await Dio().post(
        'https://webhook.site/212c0cf0-a9b3-4850-8a83-46ecf063f2cb',
        data: formData,
        onSendProgress: (count, total) {
          log(count.toString());
          log(total.toString());
        },
      );

      if (responsePOST.statusCode == 200) {
        log(responsePOST.statusCode.toString(), name: 'If Part');
        log('Data sended Successfully');
        log(responsePOST.data.toString(), name: 'responsePOST Data');
        setState(() {
          showSpinner = false;
        });
      } else {
        log(responsePOST.statusCode.toString(), name: 'Else Part');
        setState(() {
          showSpinner = false;
        });
      }
    } catch (e) {
      log(e.toString(), name: 'Post Data Catch method');
    }

    Dio().interceptors.add(InterceptorsWrapper(
      onError: (DioException error, handler) {
        log(error.toString());
        return handler.next(error);
      },
    ));

    var responseGET = await Dio()
        .get('https://webhook.site/212c0cf0-a9b3-4850-8a83-46ecf063f2cb');

    if (responseGET.statusCode == 200) {
      log(responseGET.statusCode.toString(), name: 'If Part');
      log('Getting Data Successfully');
      log(responseGET.data.toString(), name: 'responseGET Data');
    } else {
      log(responseGET.statusCode.toString(), name: 'Else Part');
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
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                  ElevatedButton(
                    onPressed: addImage,
                    child: image == null
                        ? Center(
                            child: text('Add Photo'),
                          )
                        : Image.file(
                            File(image?.path ?? ''),
                            height: 800,
                            width: 800,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      log('Button Clicked');
                      await uploadData(
                        emailController.text.toString(),
                        passwordController.text.toString(),
                      );
                    },
                    child: text('Submit'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      log('Button Clicked');
                      // deleteData();
                    },
                    child: text('Delete Data'),
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
