import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;
import 'package:http/http.dart' as http;

class AddUniversityPage extends StatefulWidget {
  @override
  State<AddUniversityPage> createState() => _AddUniversityPageState();
}

class _AddUniversityPageState extends State<AddUniversityPage> {
  String selectedFile = '';
  Uint8List? selectedImageInBytes;
  String imageUrl = '';
  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _UniversityphoneController = TextEditingController();
  bool isItemSaved = false;

  @override
  void initState() {
    //deleteVegetable();
    super.initState();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _UniversityphoneController.dispose();
    super.dispose();
  }

  _selectFile(bool imageFrom) async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();

    if (fileResult != null) {
      selectedFile = fileResult.files.first.name;
      setState(() {
        selectedImageInBytes = fileResult.files.first.bytes;
      });
    }
    print(selectedFile);
  }

  Future<String> _uploadImage(String itemName) async {
    String imageUrl = '';
    try {
      firabase_storage.UploadTask uploadTask;

      firabase_storage.Reference ref = firabase_storage.FirebaseStorage.instance
          .ref()
          .child('Universities')
          .child('/' + itemName + '_' + DateTime.now().toIso8601String());

      final metadata =
          firabase_storage.SettableMetadata(contentType: 'image/jpeg');

      //uploadTask = ref.putFile(File(file.path));
      uploadTask = ref.putData(selectedImageInBytes!, metadata);
      await uploadTask.whenComplete(() => null);
      imageUrl = await ref.getDownloadURL();
      setState(() {
        this.imageUrl = imageUrl;
      });
    } catch (e) {
      print(e);
    }
    return imageUrl;
  }

  saveItem() async {
    setState(() {
      isItemSaved = true;
    });

    await _uploadImage(_itemNameController.text);
    await FirebaseFirestore.instance.collection('Universities').add({
      'description': _descriptionController.text,
      'name': _itemNameController.text,
      'phone': _UniversityphoneController.text,
      'Image': imageUrl,
      'createdOn': DateTime.now().toIso8601String(),
    }).then((value) {
      setState(() {
        isItemSaved = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              if (selectedFile.isEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.add_a_photo,
                        size: 50,
                      ),
                    ),
                  ],
                ),
              if (selectedFile.isNotEmpty)
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: Container(
                    child: Image.memory(selectedImageInBytes!),
                  ),
                ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _selectFile(true);
                  },
                  icon: const Icon(
                    Icons.add_a_photo,
                  ),
                  label: const Text(
                    'Pick Image',
                    style: TextStyle(),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              if (isItemSaved)
                Container(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25,
                  ),
                ),
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      borderSide: new BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    labelText: 'University Name',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  controller: _itemNameController,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25,
                  ),
                ),
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      borderSide: new BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    labelText: 'University description',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  controller: _descriptionController,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25,
                  ),
                ),
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      borderSide: new BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    labelText: 'University phone',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  controller: _UniversityphoneController,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.08,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.02,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(
                    25,
                  ),
                  // border: Border.all(
                  //   width: 1,
                  //   //color: Colors.black,
                  // ),
                ),
                child: TextButton(
                  onPressed: () {
                    saveItem();
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
