import 'dart:io';

import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:admin_alex_uni/models/university_model.dart';
import 'package:admin_alex_uni/pages/add_department_page.dart';
import 'package:admin_alex_uni/pages/add_university_page.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';


class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    AddUniversityPage(),
    AddDepartmentPage(),
  ];

  void changeNavBar(int index){
    currentIndex = index;
    emit(AppChangeNavBarState());
  }

  createUniversity({
    required String name,
    required String description,
    required String image, // Add this parameter
    context,
  }) {
    emit(CreateUniversityLoadingState());

    UniversityModel universityModel = UniversityModel(
      name: name,
      description: description,
      image: image, // Assign the image URL here
    );

    FirebaseFirestore.instance
        .collection('Universities')
        .add(universityModel.toMap())
        .then((value) {
      emit(CreateUniversitySuccessState());
    });
  }

  File? image;
  final picker = ImagePicker();
  void pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      emit(PickImageSuccessState());
    } else {
      print('No image selected.');
      emit(PickImageErrorState());
    }
  }

  String uploadedImageLink = '';
  Future uploadImage() async {
    emit(PickImageLoadingState());
    firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;
    firebase_storage.Reference ref = storage.ref().child('Universities/${Uri.file(image!.path).pathSegments.last}');
    firebase_storage.UploadTask uploadTask = ref.putFile(image!);
    await uploadTask.whenComplete(() async {
      uploadedImageLink = await ref.getDownloadURL();
      emit(PickImageSuccessState());
    }).catchError((onError) {
      emit(PickImageErrorState());
      print(onError.toString());
    });
  }
}