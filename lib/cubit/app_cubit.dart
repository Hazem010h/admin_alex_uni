import 'dart:io';
import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:admin_alex_uni/models/settings_model.dart';
import 'package:admin_alex_uni/models/university_model.dart';
import 'package:admin_alex_uni/screens/review_posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../cache_helper.dart';
import '../constants.dart';
import '../models/admin_model.dart';
import '../models/department_model.dart';
import '../models/post_model.dart';
import '../reusable_widgets.dart';
import '../screens/Admin_login_screen.dart';
import '../screens/add_department_screen.dart';
import '../screens/add_university_screen.dart';
import '../screens/add_news_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState()) {
    getUniversities();
    getAdminData();
    print(adminModel);
    print(uId);
  }

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  UniversityModel? currentSelectedUniversity = null;
  DepartmentModel? currentSelectedDepartment = null;

  List<Widget> screens = [
    AddUniversityScreen(),
    AddDepartmentScreen(),
    AddNewsScreen(),
    ReviewPostsScreen(),
  ];

  changeNavBar(int index) async {
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
   pickImage() async {
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
    firebase_storage.Reference ref = storage
        .ref()
        .child('Universities/${Uri.file(image!.path).pathSegments.last}');
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
    FirebaseFirestore.instance
        .collection('Universities')
        .orderBy('name')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        UniversityModel currentUniversity =
            UniversityModel.fromJson(element.data());
        currentUniversity.uId = element.id;
        universities.add(currentUniversity);
      });
      currentSelectedUniversity = universities[0] ?? null;
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
  void displaydepartments() {
    currentSelectedDepartment = null;
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
  }) {
    emit(AdminRegesterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      uId = value.user!.uid;
      createAdmin(
        id: value.user!.uid,
        name: name,
        email: email,
        phone: phone,
        underGraduate: underGraduate,
        postGraduate: postGraduate,
      );
      emit(AdminRegesterSuccessState(value.user!.uid));
    }).catchError((error) {
      if (error is FirebaseAuthException) {
        if (error.code == 'weak-password') {
          emit(AdminRegesterErrorState(
            error: 'كلمه السر ضعيفه',
          ));
        } else if (error.code == 'email-already-in-use') {
          emit(AdminRegesterErrorState(
              error: 'هذا البريد الالكتروني مسجل بالفعل'));
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
    required String phone,
    required String email,
    required bool underGraduate,
    required bool postGraduate,
  }) {
    emit(CreateAdminLoadingState());

    AdminModel adminModel = AdminModel(
      id: id,
      name: name,
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
    departmentRef
        .collection('Admins')
        .doc(id)
        .set(adminModel.toMap())
        .then((value) {
      emit(CreateAdminSuccessState());
    });
  }

  AdminModel? adminModel;
  getAdminData() {
    emit(GetAdminDataLoadingState());
    FirebaseFirestore.instance
        .collection('Admins')
        .doc(uId)
        .get()
        .then((value) {
      adminModel = AdminModel.fromJson(value.data()!);
      emit(GetAdminDataSuccessState());
    }).catchError((onError) {
      emit(GetAdminDataErrorState(onError.toString()));
    });
  }

  updateUserData({
    required String phone,
    required bool available,
  }) {
    emit(UpdateUserDataLoadingState());
    adminModel!.phone = phone;
    adminModel!.isAvailable = available;
    FirebaseFirestore.instance
        .collection('Admins')
        .doc(uId)
        .update(adminModel!.toMap())
        .then((value) async {
      await FirebaseFirestore.instance
          .collection('Universities')
          .doc(adminModel!.universityId)
          .collection('Departments')
          .doc(adminModel!.departmentId)
          .collection('Admins')
          .doc(adminModel!.id)
          .update(adminModel!.toMap());
      emit(UpdateUserDataSuccessState());
    }).catchError((onError) {
      emit(UpdateUserDataErrorState(onError.toString()));
    });
  }

  logout(context) {
    emit(AppLogoutLoadingState());
    FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData(key: 'uId').then((value) {
        currentIndex = 0;
        uId = null;
        navigateAndFinish(
          context: context,
          screen: const AdminloginScreen(),
        );
      });
      emit(AppLogoutSuccessState());
    }).catchError((onError) {
      emit(AppLogoutErrorState(onError.toString()));
    });
  }

  SettingsModel? settings;

  getSettings(){
    emit(GetSettingsLoadingState());
    FirebaseFirestore.instance
        .collection('Settings')
        .doc('settings')
        .get()
        .then((value) {
      settings = SettingsModel.fromJson(value.data()!);
      print(settings!.reviewPosts);
      emit(GetSettingsSuccessState());
    }).catchError((onError) {
      emit(GetSettingsErrorState(onError.toString()));
    });
  }

  updateSettings({
    required bool reviewPosts,
  }) {
    emit(UpdateUserDataLoadingState());
    settings!.reviewPosts = reviewPosts;
    FirebaseFirestore.instance
        .collection('Settings')
        .doc('settings')
        .update(settings!.toMap())
        .then((value) async {
      emit(UpdateUserDataSuccessState());
    }).catchError((onError) {
      emit(UpdateUserDataErrorState(onError.toString()));
    });
  }

  List<Map<String, PostModel>> posts = [];
  List<PostModel> post = [];
  List postsId = [];
  getPosts() {
    posts = [];
    postsId = [];
    emit(GetPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        post.add(PostModel.fromJson(element.data()));
        posts.add({
          element.reference.id: PostModel.fromJson(element.data()),
        });
        postsId.add(element.id);
      }
    }).then((value) {
      print(postsId);
      emit(GetPostsSuccessState());
    }).catchError((error) {
      emit(GetPostsErrorState(error.toString()));
    });
  }

  reviewPosts(){
    posts = [];
    postsId = [];
    emit(GetPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .where('showPost', isEqualTo: false)
        .where('isReviewed', isEqualTo: false)
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        post.add(PostModel.fromJson(element.data()));
        posts.add({
          element.reference.id: PostModel.fromJson(element.data()),
        });
        postsId.add(element.id);
      }
    }).then((value) {
      emit(GetPostsSuccessState());
    }).catchError((error) {
      emit(GetPostsErrorState(error.toString()));
    });
  }

  addReviewPost({
    required String id,
    required bool showPost,
  }) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(id)
        .update({
      'showPost': showPost,
      'isReviewed': true,
    }).then((value) {
      reviewPosts();
      emit(DeletePostSuccessState());
    });
  }

  deletePost(String id) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(id)
        .delete()
        .then((value) {
      getPosts();
      emit(DeletePostSuccessState());
    });
  }

  List<CommentDataModel> comments = [];
  getComments({
    required String postId,
  }){
    emit(GetCommentsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get()
        .then((value) {
      comments = [];
      for (var element in value.data()!['comments']) {
        comments.add(CommentDataModel.fromJson(element));
      }
      emit(GetCommentsSuccessState());
    }).catchError((error) {
      emit(GetCommentsErrorState(error.toString()));
    });
  }

}
