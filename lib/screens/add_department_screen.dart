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
  int sectionNumber = 1;
  final picker = ImagePicker();
  List<File?> images = [];
  List<String?> titles = [];
  List<String?> descriptions = [];

  // Variables for radio buttons
  List<bool?> isUnderGraduateList = [];
  List<bool?> isPostGraduateList = [];

  @override
  void initState() {
    super.initState();
    // Initialize the lists with default values
    isUnderGraduateList.add(false);

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
            isUnderGraduateList = [];
            isUnderGraduateList = [];
            error = false;
          });
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return SingleChildScrollView(
          child: Column(
            children: [
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
              SizedBox(
                height: 10.0,
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
                    // Add new items to the lists when adding a new section
                    images.add(null);
                    titles.add(null);
                    descriptions.add(null);
                    isUnderGraduateList.add(false);
                    isPostGraduateList.add(false);
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              if (sectionNumber > 1)
                reusableElevatedButton(
                  label: 'delete section',
                  backColor: Colors.red,
                  function: () {
                    setState(() {
                      sectionNumber--;
                      // Remove the last items from the lists when deleting a section
                      images.removeLast();
                      titles.removeLast();
                      descriptions.removeLast();
                      isUnderGraduateList.removeLast();
                      isPostGraduateList.removeLast();
                    });
                  },
                ),
              const SizedBox(
                height: 10,
              ),
              // Radio buttons for undergraduates and postgraduates

              const SizedBox(
                height: 10,
              ),
              reusableElevatedButton(
                label: 'Save',
                function: () async {
                  await uploadDepartments();
                },
              ),
            ],
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
      isUnderGraduateList.add(false);
      isPostGraduateList.add(false);
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
                images;
              });
            },
            child: const Text('Pick Image'),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const SizedBox(
          height: 10,
        ),
        reusableTextFormField(
          label: 'Department Name',
          onChanged: (value) {
            titles[index] = value;
            return null;
          },
          controller: departmentNameController,
          keyboardType: TextInputType.text,
          onTap: () {},
        ),
        const SizedBox(
          height: 10,
        ),
        reusableTextFormField(
          label: 'Department Description',
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
        Row(
          children: [
            Checkbox(
              value: isUnderGraduateList[index] ?? false,
              onChanged: (value) {
                setState(() {
                  isUnderGraduateList[index] = value;
                  if (value == true) {
                    isPostGraduateList[index] = false;
                  }
                });
              },
            ),
            Text('Undergraduate'),
            Checkbox(
              value: isPostGraduateList[index] ?? false,
              onChanged: (value) {
                setState(() {
                  isPostGraduateList[index] = value;
                  if (value == true) {
                    isUnderGraduateList[index] = false;
                  }
                });
              },
            ),
            Text('Postgraduate'),
          ],
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
        'name': titles,
        'description': descriptions,
      });

      // Create a batch to perform multiple writes atomically
      WriteBatch batch = firestore.batch();

      // Upload and attach images to the department document (similar to your existing code)
      for (int i = 0; i < images.length; i++) {
        final imageFile = images[i];
        if (imageFile == null) {
          continue;
        }

        final storageRef = storage.ref().child(
            'Departments/${departmentRef.id}/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = storageRef.putFile(imageFile);
        final snapshot = await uploadTask;
        if (snapshot.state == firebase_storage.TaskState.success) {
          final imageUrl = await storageRef.getDownloadURL();

          // Update the department data with the image URL
          batch.update(departmentRef, {
            'images': FieldValue.arrayUnion([imageUrl]),
            'name': FieldValue.arrayUnion([titles[i]]),
            'description': FieldValue.arrayUnion([descriptions[i]]),
            'isUndergraduate': FieldValue.arrayUnion([!isPostGraduateList[i]!]),
            'isPostgraduate': FieldValue.arrayUnion([isPostGraduateList[i]]),

          });
        } else {
          print('Error uploading image: ');
        }
      }

      // Commit the batch to execute all writes atomically
      await batch.commit();

      // Reset form and state as needed
      setState(() {
        isUploading = false;
        nameController.clear();
        departmentController.clear();
        // ... Reset other form fields and states ...
      });
    } catch (error) {
      print('Error uploading department: $error');
    }
  }


}

//listner
// if (state is CreateAdminSuccessState) {
// if (state is CreateDepartmentSuccessState) {
//   AppCubit.get(context).image = null;
//   nameController.clear();
//   departmentController.clear();
//   setState(() {
//     AppCubit.get(context).image;
//     nameController;
//     departmentController;
//   });
// }
// if (state is AppChangeNavBarState) {
//   AppCubit.get(context).image = null;
//   nameController.clear();
//   departmentController.clear();
//   setState(() {
//     AppCubit.get(context).image;
//     nameController;
//     departmentController;
//     underGraduateCheckbox = false;
//     postGraduateCheckbox = false;
//     error = false;
//   });
// }
