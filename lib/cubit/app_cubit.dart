import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:admin_alex_uni/models/university_model.dart';
import 'package:admin_alex_uni/pages/add_department_page.dart';
import 'package:admin_alex_uni/pages/add_university_page.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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
    context,
  }) {
    emit(CreateUniversityLoadingState());

    UniversityModel universityModel = UniversityModel(
      name: name,
      description: description,
    );

    FirebaseFirestore.instance
        .collection('Universities')
        .add(universityModel.toMap())
        .then((value) {
      emit(CreateUniversitySuccessState());
    });
  }

  // List<Map<String, PostModel>> posts = [];
  // List<PostModel> post = [];
  // List postsId = [];
  // getPosts() {
  //   posts = [];
  //   postsId = [];
  //   emit(GetPostsLoadingState());
  //   FirebaseFirestore.instance
  //       .collection('posts')
  //       .orderBy('date', descending: true)
  //       .get()
  //       .then((value) {
  //     for (var element in value.docs) {
  //       post.add(PostModel.fromJson(element.data()));
  //       posts.add({
  //         element.reference.id: PostModel.fromJson(element.data()),
  //       });
  //       postsId.add(element.id);
  //     }
  //   }).then((value) {
  //     emit(GetPostsSuccessState());
  //   }).catchError((error) {
  //     emit(GetPostsErrorState());
  //   });
  // }
}