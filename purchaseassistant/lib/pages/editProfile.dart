import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/add_profile.dart';
import '../utils/pickerimg.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

TextEditingController nameController = TextEditingController();
TextEditingController lastnameController = TextEditingController();
TextEditingController roomController = TextEditingController();
TextEditingController stdidController = TextEditingController();
TextEditingController dormController = TextEditingController();
TextEditingController genderController = TextEditingController();
TextEditingController phoneController = TextEditingController();

List<String> list = <String>['ชาย', 'หญิง'];

String dropdownValue = list.first; // Default value for dropdown

class _EditProfileState extends State<EditProfile> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final _formKey = GlobalKey<FormState>();

  void valueItem(value) {
    setState(() {
      dropdownValue = value;
    });
  }

  Uint8List? _image;
  void selectImage() async {
    Uint8List img = await pickerImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void saveFile() async {
    String name = nameController.text;
    String room = roomController.text;
    String stdid = stdidController.text;
    String dorm = dormController.text;
    String gender = genderController.text;
    String phone = phoneController.text;
    String lname = lastnameController.text;

    await AddProfile().saveProfile(
      name: name,
      room: room,
      file: _image!,
      stdid: stdid,
      dorm: dorm,
      gender: gender,
      phone: phone,
      lname: lname,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: firebase,
        builder: (context, snap) {
          if (snap.hasError) {
            return Scaffold(
              appBar: AppBar(title: Text("Error")),
              body: Center(child: Text("${snap.error}")),
            );
          } else if (snap.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(),
              body: Container(
                width: double.infinity,
                height: double.infinity,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListView(
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            _image != null
                                ? CircleAvatar(
                                    radius: 64,
                                    backgroundImage: MemoryImage(_image!),
                                  )
                                : CircleAvatar(
                                    radius: 64,
                                    backgroundImage: NetworkImage(
                                        'https://i.pinimg.com/564x/37/c6/ee/37c6ee12369d470152c3cbe592477703.jpg'),
                                  ),
                            Positioned(
                              child: IconButton(
                                onPressed: () {
                                  selectImage();
                                },
                                icon: Icon(
                                  Icons.add_a_photo,
                                  size: 28,
                                ),
                              ),
                              bottom: -10,
                              left: 210,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _buildTextFieldOrder(
                                      context, "รหัสนักศึกษา", valueItem),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildTextFieldOrder(
                                      context, "ชื่อ", valueItem),
                                  _buildTextFieldOrder(
                                      context, "นามสกุล", valueItem),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildTextFieldOrder(
                                      context, "หอ", valueItem),
                                  _buildTextFieldOrder(
                                      context, "หมายเลขห้อง", valueItem),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildTextFieldOrder(
                                      context, "เพศ", valueItem),
                                  _buildTextFieldOrder(
                                      context, "โทรศัพท์", valueItem),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 150,
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                saveFile();
                              }
                            },
                            child: Text("Save profile"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildTextFieldOrder(
    context, String title, Function(String) valueItemCallback) {
  if (title == 'รหัสนักศึกษา') {
    return Container(
      width: 390,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: title),
        controller: lastnameController,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return "กรุณาใส่ข้อมูล";
          }
          return null;
        },
      ),
    );
  }
  if (title == 'ชื่อ') {
    return Container(
      width: 190,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: title),
        controller: stdidController,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return "กรุณาใส่ข้อมูล";
          }
          return null;
        },
      ),
    );
  }
  if (title == 'นามสกุล') {
    return Container(
      width: 190,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: title),
        controller: nameController,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return "กรุณาใส่ข้อมูล";
          }
          return null;
        },
      ),
    );
  }

  if (title == 'หอ') {
    return Container(
      width: 190,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: title),
        controller: dormController,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return "กรุณาใส่ข้อมูล";
          }
          return null;
        },
      ),
    );
  }
  if (title == 'หมายเลขห้อง') {
    return Container(
      width: 190,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: title),
        controller: roomController,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return "กรุณาใส่ข้อมูล";
          }
          return null;
        },
      ),
    );
  }
  if (title == 'เพศ') {
    return Container(
      width: 140,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: DropdownButton<String>(
        value: dropdownValue,
        elevation: 10,
        isExpanded: true,
        onChanged: (String? value) {
          if (value != null) {
            valueItemCallback(value);
            print(
                list.indexOf(value).toString()); // You don't need to use ! here
          }
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
  if (title == 'โทรศัพท์') {
    return Container(
      width: 190,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: title),
        controller: phoneController,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return "กรุณาใส่ข้อมูล";
          }
          return null;
        },
      ),
    );
  }
  return Container();
}