import 'package:admin_alex_uni/cubit/app_cubit.dart';
import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:admin_alex_uni/reusable_widgets.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;

class AddDepartmentScreen extends StatefulWidget {
  AddDepartmentScreen({super.key});

  @override
  State<AddDepartmentScreen> createState() => _AddDepartmentScreenState();
}

class _AddDepartmentScreenState extends State<AddDepartmentScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  bool isUploading = false;
  bool error = false;
  bool underGraduateCheckbox = false;
  bool postGraduateCheckbox = false;

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
            underGraduateCheckbox = false;
            postGraduateCheckbox = false;
            error = false;
          });
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.15,
                    backgroundColor: cubit.image == null
                        ? Colors.grey[350]
                        : Theme.of(context).scaffoldBackgroundColor,
                    child: cubit.image == null
                        ? IconButton(
                            onPressed: () {
                              cubit.pickImage();
                            },
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.black,
                              size: MediaQuery.of(context).size.width * 0.1,
                            ),
                          )
                        : Image.file(
                            cubit.image!,
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.3,
                          ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  if (cubit.image == null)
                    TextButton(
                      onPressed: () {
                        cubit.pickImage();
                      },
                      child: Text(
                        'Pick Image',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  if (cubit.image != null)
                    TextButton(
                      onPressed: () {
                        cubit.pickImage();
                      },
                      child: Text(
                        'Change Image',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 10.0,
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
                      icon: Icon(
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
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Department Name',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  reusableTextFormField(
                    label: 'Department Name',
                    onTap: () {},
                    controller: nameController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Department description',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  reusableTextFormField(
                    label: 'Department description',
                    onTap: () {},
                    controller: departmentController,
                    keyboardType: TextInputType.text,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Under Graduate'),
                        Checkbox(
                          value: underGraduateCheckbox,
                          onChanged: (value) {
                            setState(() {
                              underGraduateCheckbox = value!;
                            });
                          },
                        ),
                        Text('Post Graduate'),
                        Checkbox(
                          value: postGraduateCheckbox,
                          onChanged: (value) {
                            setState(() {
                              postGraduateCheckbox = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  if (error)
                    Text(
                      'Select Image and Enter University Name',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.0,
                      ),
                    ),
                  if (error)
                    SizedBox(
                      height: 10.0,
                    ),
                  ConditionalBuilder(
                    condition: isUploading == false ||
                        state is! CreateDepartmentLoadingState,
                    builder: (context) => Row(
                      children: [
                        Expanded(
                          child: reusableElevatedButton(
                            label: 'Save',
                            function: () {
                              if (cubit.image != null &&
                                  nameController.text.isNotEmpty &&
                                  cubit.currentSelectedUniversity != null &&
                                  (underGraduateCheckbox ||
                                      postGraduateCheckbox) &&
                                  departmentController.text.isNotEmpty) {
                                setState(() {
                                  isUploading = true;
                                });
                                cubit.uploadImage().then((value) {
                                  cubit.createDepartment(
                                    departmentImage: cubit.uploadedImageLink,
                                    name: nameController.text,
                                    underGraduate: underGraduateCheckbox,
                                    postGraduate: postGraduateCheckbox,
                                    description: departmentController.text,
                                  );
                                });
                              } else {
                                setState(() {
                                  error = true;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: reusableElevatedButton(
                            label: 'Cancel',
                            backColor: Colors.white70,
                            textColor: Colors.blue,
                            function: () {
                              setState(() {
                                cubit.image = null;
                                nameController.clear();
                                departmentController.clear();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    fallback: (context) => Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
