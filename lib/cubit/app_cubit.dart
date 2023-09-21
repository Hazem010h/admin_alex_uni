import 'dart:io';

import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:admin_alex_uni/models/university_model.dart';
import 'package:admin_alex_uni/pages/add_admin_screen.dart';
import 'package:admin_alex_uni/pages/add_department_screen.dart';
import 'package:admin_alex_uni/pages/add_university_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../models/admin_model.dart';
import '../models/department_model.dart';


class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState()){
    getUniversities();

  }

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  UniversityModel? currentSelectedUniversity=null;
  DepartmentModel? currentSelectedDepartment=null;

  List<Widget> screens = [
    AddUniversityScreen(),
    AddDepartmentScreen(),
    AddAdminScreen()
  ];

  changeNavBar(int index)async{
    currentIndex = index;
    emit(AppChangeNavBarState());
  }

  createUniversity({
    required String name,
  }) {
    emit(CreateUniversityLoadingState());

    UniversityModel universityModel = UniversityModel(
      name: name,
      image: uploadedImageLink,
    );

    FirebaseFirestore.instance
        .collection('Universities')
        .add(universityModel.toMap())
        .then((value) {
      getUniversities();
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

  List<UniversityModel> universities = [];
  void getUniversities() {
    universities = [];
    emit(GetUniversitiesLoadingState());
    FirebaseFirestore.instance.collection('Universities').orderBy('name').get().then((value) {
      value.docs.forEach((element) {
        UniversityModel currentUniversity = UniversityModel.fromJson(element.data());
        currentUniversity.uId = element.id;
        universities.add(currentUniversity);
      });
      currentSelectedUniversity = universities[0]??null;
      emit(GetUniversitiesSuccessState());
    }).catchError((onError) {
      emit(GetUniversitiesErrorState(onError.toString()));
    });
  }
  

  createDepartment({
    required String name,
    required bool underGraduate,
    required bool postGraduate,
  }) {
    emit(CreateDepartmentLoadingState());

    DepartmentModel departmentModel = DepartmentModel(
      name: name,
      universityId: currentSelectedUniversity!.uId,
      underGraduate: underGraduate,
      postGraduate: postGraduate,
    );

    FirebaseFirestore.instance
        .collection('Universities')
        .doc(currentSelectedUniversity!.uId)
        .collection('Departments')
        .add(departmentModel.toMap())
        .then((value) {
      emit(CreateDepartmentSuccessState());
    });
  }
  // List<DepartmentModel> departments = [];
  // void getDepartments() {
  //   if (currentSelectedUniversity == null) {
  //
  //
  //     // No university selected, so return an empty list of departments.
  //     emit(GetDepartmentsLoadingState());
  //     return;
  //   }
  //   if(currentSelectedUniversity!.uId==null){
  //     emit(GetDepartmentsLoadingState());
  //     return;
  //   }
  //   departments = [];
  //
  //
  //
  //   emit(GetDepartmentsLoadingState());
  //
  //
  //   FirebaseFirestore.instance
  //       .collection('Universities')
  //       .doc(currentSelectedUniversity!.uId)
  //       .collection('Departments')
  //       .orderBy('name')
  //       .get()
  //       .then((value) {
  //
  //
  //
  //
  //     value.docs.forEach((element) {
  //
  //       DepartmentModel currentDepartment =
  //       DepartmentModel.fromJson(element.data());
  //
  //       currentDepartment.id = element.id;
  //       departments.add(currentDepartment);
  //     });
  //     currentSelectedDepartment = departments[0]??null;
  //     emit(GetDepartmentsSuccessState());
  //   }).catchError((onError) {
  //     emit(GetDepartmentsErrorState(onError.toString()));
  //   });
  // }
  List<DepartmentModel> departments = [];
  void displaydepartments(){
    currentSelectedDepartment=null;
    departments = [];

    emit(GetDepartmentsLoadingState());
    FirebaseFirestore.instance
        .collection('Universities')
        .doc(currentSelectedUniversity!.uId)
        .collection('Departments')
        .orderBy('name')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        DepartmentModel currentDepartment =
        DepartmentModel.fromJson(element.data());
        currentDepartment.id = element.id;
        departments.add(currentDepartment);


      });


      emit(GetDepartmentsSuccessState());
    }).catchError((onError) {
      emit(GetDepartmentsErrorState(onError.toString()));
    });
  }


  createAdmin({
    required String name,
    required String password,
    required String phone,
    required String email,
    required bool underGraduate,
    required bool postGraduate,



  }) {
    emit(CreateAdminLoadingState());

    AdminModel adminModel = AdminModel(
      name: name,
      password: password,
      phone: phone,
      email: email,
      universityId: currentSelectedUniversity!.uId,
      departmentId: currentSelectedDepartment!.id,
      underGraduate: underGraduate,
      postGraduate: postGraduate,
    );

    FirebaseFirestore.instance
        .collection('Admins')
        .add(adminModel.toMap())
        .then((value) {
      emit(CreateAdminSuccessState());
    });


  }
}