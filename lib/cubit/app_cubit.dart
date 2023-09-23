import 'dart:io';
import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:admin_alex_uni/models/university_model.dart';
import 'package:admin_alex_uni/pages/add_department_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../constants.dart';
import '../models/admin_model.dart';
import '../models/department_model.dart';
import '../pages/add_university_screen.dart';


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
    required String departmentImage,
    required String description,
  }) {
    emit(CreateDepartmentLoadingState());

    DepartmentModel departmentModel = DepartmentModel(
      name: name,
      universityId: currentSelectedUniversity!.uId,
      underGraduate: underGraduate,
      postGraduate: postGraduate,
      departmentImage: departmentImage,
      description: description,

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

  void AdminRegester({
    required String name,
    required String password,
    required String phone,
    required String email,
    required bool underGraduate,
    required bool postGraduate,
}){
    emit(AdminRegesterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      uId= value.user!.uid;
      createAdmin(
        id: value.user!.uid,
        name: name,
        email: email,
        phone: phone,
        password: password,
        underGraduate: underGraduate,
        postGraduate: postGraduate,
      );
      emit(AdminRegesterSuccessState(value.user!.uid));
    }).catchError((error) {
      if (error is FirebaseAuthException) {
        if (error.code == 'weak-password') {
          emit(AdminRegesterErrorState( error: 'كلمه السر ضعيفه',));
        } else if (error.code == 'email-already-in-use') {
          emit(AdminRegesterErrorState(error: 'هذا البريد الالكتروني مسجل بالفعل'));
        } else {
          emit(AdminRegesterErrorState(error: 'حدث خطأ ما,حاول مره اخري'));
        }
      } else {
        emit(AdminRegesterErrorState(error: 'An error occurred: $error'));
      }
    });
  }


  createAdmin({
    required String id,
    required String name,
    required String password,
    required String phone,
    required String email,
    required bool underGraduate,
    required bool postGraduate,
  }) {
    emit(CreateAdminLoadingState());

    AdminModel adminModel = AdminModel(
      id: id,
      name: name,
      password: password,
      phone: phone,
      email: email,
      universityId: currentSelectedUniversity!.uId,
      departmentId: currentSelectedDepartment!.id,
      underGraduate: underGraduate,
      postGraduate: postGraduate,
    );
    emit(CreateAdminLoadingState());



    FirebaseFirestore.instance
        .collection('Admins')
        .doc(id)
        .set(adminModel.toMap())
        .then((value) {
      emit(CreateAdminSuccessState());
    });
    // Get a reference to the department within the university
    DocumentReference departmentRef = FirebaseFirestore.instance
        .collection('Universities')
        .doc(currentSelectedUniversity!.uId)
        .collection('Departments')
        .doc(currentSelectedDepartment!.id);

    // Add the admin to the department's subcollection
    departmentRef.collection('Admins').doc(id).set(adminModel.toMap()).then((value) {
      emit(CreateAdminSuccessState());
    });
  }

}