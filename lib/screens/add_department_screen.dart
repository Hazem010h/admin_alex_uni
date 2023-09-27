import 'dart:io';

import 'package:admin_alex_uni/cubit/app_cubit.dart';
import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:admin_alex_uni/reusable_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class AddDepartmentScreen extends StatefulWidget {
  AddDepartmentScreen({Key? key});

  @override
  State<AddDepartmentScreen> createState() => _AddDepartmentScreenState();
}

class _AddDepartmentScreenState extends State<AddDepartmentScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  bool isUploading = false;
  bool error = false;
  int sectionNumber = 0;
  final picker = ImagePicker();
  List<File?> images = [];
  File? mainImage;
  List<String?> titles = [];
  String? mainTitle;
  String? mainDescription;
  List<String?> descriptions = [];
  TextEditingController departmentNameController = TextEditingController();
  TextEditingController departmentdescriptionsController =
      TextEditingController();

  bool? isUnderGraduateList = false;
  bool? isPostGraduateList = false;

  bool showErrorMessage = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppCubit.get(context).getUniversities();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is CreateDepartmentSuccessState) {
          AppCubit.get(context).image = null;
          nameController.clear();
          departmentController.clear();
          setState(() {
            AppCubit.get(context).image;
            nameController;
            departmentController;
          });
        }
        if (state is AppChangeNavBarState) {
          AppCubit.get(context).image = null;
          nameController.clear();
          departmentController.clear();
          setState(() {
            AppCubit.get(context).image;
            nameController;
            departmentController;
            isUnderGraduateList = false;
            isUnderGraduateList = false;
            error = false;
          });
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.15,
                    backgroundColor: mainImage == null
                        ? Colors.grey[350]
                        : Theme.of(context).scaffoldBackgroundColor,
                    child: mainImage == null
                        ? IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.black,
                              size: MediaQuery.of(context).size.width * 0.1,
                            ),
                          )
                        : Image.file(mainImage!),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      mainImage = await pickImage();
                      setState(() {
                        mainImage;
                      });
                    },
                    child: const Text('Pick Image'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Choose Faculty',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  child: DropdownButton(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    underline: SizedBox(),
                    alignment: Alignment.center,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(25.0),
                    iconSize: 35,
                    icon: const Icon(
                      Icons.arrow_drop_down_sharp,
                      size: 28,
                    ),
                    value: cubit.currentSelectedUniversity,
                    items: cubit.universities
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name!),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        cubit.currentSelectedUniversity = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                reusableTextFormField(
                  label: 'Department Name (required)',
                  onChanged: (value) {
                    mainTitle = value;
                    return null;
                  },
                  controller: departmentNameController,
                  keyboardType: TextInputType.text,
                  onTap: () {},
                ),
                reusableTextFormField(
                  label: 'Department Description (required)',
                  onChanged: (value) {
                    mainDescription = value;
                    return null;
                  },
                  controller: departmentdescriptionsController,
                  keyboardType: TextInputType.text,
                  onTap: () {},
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Choose Department Type\n(required one or both)',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Undergraduate'),
                      Checkbox(
                        value: isUnderGraduateList ?? false,
                        onChanged: (value) {
                          setState(() {
                            isUnderGraduateList = value;
                          });
                        },
                      ),
                      Text('Postgraduate'),
                      Checkbox(
                        value: isPostGraduateList ?? false,
                        onChanged: (value) {
                          setState(() {
                            isPostGraduateList = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.0,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return buildDepartmentItem(context: context, index: index);
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      thickness: 1.0,
                    );
                  },
                  itemCount: sectionNumber,
                ),
                reusableElevatedButton(
                  label: 'add section',
                  backColor: Colors.green,
                  function: () {
                    setState(() {
                      sectionNumber++;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                if (sectionNumber > 0)
                  reusableElevatedButton(
                    label: 'delete section',
                    backColor: Colors.red,
                    function: () {
                      setState(() {
                        sectionNumber--;
                        images.removeLast();
                        titles.removeLast();
                        descriptions.removeLast();
                      });
                    },
                  ),
                if (sectionNumber > 0)
                  const SizedBox(
                    height: 10,
                  ),
                if (showErrorMessage)
                  const Text(
                    'Please fill all required fields',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                if (showErrorMessage)
                  const SizedBox(
                    height: 10,
                  ),
                reusableElevatedButton(
                  label: 'Save',
                  function: () async {
                    if (mainTitle == null ||
                        mainDescription == null ||
                        mainImage == null ||
                        (isUnderGraduateList == false &&
                            isPostGraduateList == false)) {
                      setState(() {
                        showErrorMessage = true;
                      });
                      return;
                    }
                    setState(() {
                      showErrorMessage = false;
                    });
                    await uploadDepartments();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildDepartmentItem({
    required BuildContext context,
    required int index,
  }) {
    TextEditingController departmentNameController = TextEditingController();
    TextEditingController departmentDescriptionController =
        TextEditingController();

    if (sectionNumber > images.length) {
      images.add(null);
      descriptions.add(null);
      titles.add(null);
    }

    departmentDescriptionController.text = descriptions[index] ?? '';
    departmentNameController.text = titles[index] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Section: ${index + 1}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Center(
          child: CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.15,
            backgroundColor: images[index] == null
                ? Colors.grey[350]
                : Theme.of(context).scaffoldBackgroundColor,
            child: images[index] == null
                ? IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add_a_photo,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.width * 0.1,
                    ),
                  )
                : Image.file(images[index]!),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: TextButton(
            onPressed: () async {
              images[index] = await pickImage();
              setState(() {
                images[index];
              });
            },
            child: const Text('Pick Image'),
          ),
        ),
        reusableTextFormField(
          label: 'Section Title',
          onChanged: (value) {
            titles[index] = value;
            return null;
          },
          controller: departmentNameController,
          keyboardType: TextInputType.text,
          onTap: () {},
        ),
        reusableTextFormField(
          label: 'Section Description',
          onChanged: (value) {
            descriptions[index] = value;
            return null;
          },
          controller: departmentDescriptionController,
          keyboardType: TextInputType.text,
          onTap: () {},
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Future<File?> pickImage() async {
    File? image;
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      return image;
    } else {
      print('No image selected.');
      return null;
    }
  }

  Future<void> uploadDepartments() async {
    final firestore = FirebaseFirestore.instance;
    final storage = firebase_storage.FirebaseStorage.instance;
    final cubit = AppCubit.get(context);

    try {
      final universityId = cubit.currentSelectedUniversity?.uId;
      if (universityId == null) {
        print('University not selected.');
        return;
      }

      // Create a reference to the department document
      final departmentRef = firestore
          .collection('Universities')
          .doc(universityId)
          .collection('Departments')
          .doc(); // Generate a new document ID for the department

      // Set the initial department data
      await departmentRef.set({
        'name': mainTitle,
        'description': mainDescription,
        'isUndergraduate': isUnderGraduateList,
        'isPostgraduate': isPostGraduateList,
        'sectionImages': [],
        'sectionTitles': [],
        'sectionDescriptions': [],
        'universityId': universityId,
      });

      // Create a batch to perform multiple writes atomically
      WriteBatch batch = firestore.batch();

      if (mainImage != null) {
        final storageRef = storage.ref().child(
            'Departments/${departmentRef.id}/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = storageRef.putFile(mainImage!);
        final snapshot = await uploadTask;
        if (snapshot.state == firebase_storage.TaskState.success) {
          final imageUrl = await storageRef.getDownloadURL();

          // Update the department data with the image URL
          batch.update(departmentRef, {
            'mainImage': imageUrl,
          });
        } else {
          print('Error uploading image: ');
        }
      }
      String? imageUrl;
      for (int i = 0; i < images.length; i++) {
        final imageFile = images[i];
        if (imageFile != null) {
          final storageRef = storage.ref().child(
              'Departments/${departmentRef.id}/${DateTime.now().millisecondsSinceEpoch}');
          final uploadTask = storageRef.putFile(imageFile);
          final snapshot = await uploadTask;
          if (snapshot.state == firebase_storage.TaskState.success) {
            imageUrl = await storageRef.getDownloadURL();
          }
        }else{
            imageUrl = null;
          }

          batch.update(departmentRef, {
            'sectionImages': FieldValue.arrayUnion([imageUrl]),
            'sectionTitles': FieldValue.arrayUnion([titles[i]]),
            'sectionDescriptions': FieldValue.arrayUnion([descriptions[i]]),
          });
      }

      // Commit the batch to execute all writes atomically
      await batch.commit();

      setState(() {
        isUploading = false;
        nameController.clear();
        departmentController.clear();
      });
    } catch (error) {
      print('Error uploading department: $error');
    }
  }
}
