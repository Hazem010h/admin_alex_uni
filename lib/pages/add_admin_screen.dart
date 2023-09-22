import 'package:admin_alex_uni/cubit/app_cubit.dart';
import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:admin_alex_uni/models/department_model.dart';
import 'package:admin_alex_uni/pages/add_university_screen.dart';
import 'package:admin_alex_uni/pages/layout_page.dart';
import 'package:admin_alex_uni/reusable_widgets.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;
import 'package:intl_phone_field/intl_phone_field.dart';

import '../cache_helper.dart';
import '../constants.dart';

class AddAdminScreen extends StatefulWidget {
  AddAdminScreen({super.key});

  @override
  State<AddAdminScreen> createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isUploading = false;
  String? phone;
  bool error = false;
  bool underGraduateCheckbox = false;
  bool postGraduateCheckbox = false;
  String? nameError;
  String? emailError;
  String? passwordError;
  String? phoneError;

  String? universityError;
  String? departmentError;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AdminRegesterErrorState) {
          showFlushBar(context: context,message: state.error,);
        } else if (state is AdminRegesterSuccessState) {
          CacheHelper.saveData(key: 'uId', value: uId).then((value){
            navigateAndFinish(context: context, screen:  const LayoutPage());
          });
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // CircleAvatar(
                    //   radius: MediaQuery.of(context).size.width * 0.15,
                    //   backgroundColor: cubit.image == null
                    //       ? Colors.grey[350]
                    //       : Theme.of(context).scaffoldBackgroundColor,
                    //   child: cubit.image == null
                    //       ? IconButton(
                    //     onPressed: () {
                    //       cubit.pickImage();
                    //     },
                    //     icon: Icon(
                    //       Icons.add_a_photo,
                    //       color: Colors.black,
                    //       size: MediaQuery.of(context).size.width * 0.1,
                    //     ),
                    //   )
                    //       : Image.file(
                    //     cubit.image!,
                    //     width: MediaQuery.of(context).size.width * 0.3,
                    //     height: MediaQuery.of(context).size.width * 0.3,
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10.0,
                    // ),
                    // if (cubit.image == null)
                    //   TextButton(
                    //     onPressed: () {
                    //       cubit.pickImage();
                    //     },
                    //     child: Text(
                    //       'Pick Image',
                    //       style: TextStyle(
                    //         color: Colors.blue,
                    //         fontSize: 16.0,
                    //       ),
                    //     ),
                    //   ),
                    // if (cubit.image != null)
                    //   TextButton(
                    //     onPressed: () {
                    //       cubit.pickImage();
                    //     },
                    //     child: Text(
                    //       'Change Image',
                    //       style: TextStyle(
                    //         color: Colors.blue,
                    //         fontSize: 16.0,
                    //       ),
                    //     ),
                    //   ),
                    // SizedBox(
                    //   height: 10.0,
                    // ),
                    const  Row(
                      children: [
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('name',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),),
                        ),
                      ],
                    ),
                    reusableTextFormField(
                        label: 'Name',
                        onTap: (){},
                        controller: nameController,
                        keyboardType: TextInputType.text),
                    if (nameError != null) // Display error message if name is empty
                      Text(
                        nameError!,
                        style:const TextStyle(
                          color: Colors.red,
                          fontSize: 12.0,
                        ),
                      ),
                    const  Row(
                      children: [
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('email',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),),
                        ),
                      ],
                    ),
                    reusableTextFormField(
                        label: 'email',
                        onTap: (){},
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress),
                    if (emailError != null) // Display error message if name is empty
                      Text(
                        emailError!,
                        style:const TextStyle(
                          color: Colors.red,
                          fontSize: 12.0,
                        ),
                      ),

                    const  Row(
                      children: [
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('password',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),),
                        ),
                      ],
                    ),
                    reusableTextFormField(
                        label: 'password',
                        onTap: (){},
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword),
                    if (passwordError != null) // Display error message if name is empty
                      Text(
                        passwordError!,
                        style:const TextStyle(
                          color: Colors.red,
                          fontSize: 12.0,
                        ),
                      ),
                    const  Row(
                      children: [
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('phone',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),),
                        ),
                      ],
                    ),
                    IntlPhoneField(
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      initialCountryCode: 'EG',
                      onChanged: (data) {

                        phone = data.completeNumber ;



                      },
                    ),



                    const   Row(
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
                    const    SizedBox(
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
                        padding:const EdgeInsets.symmetric(horizontal: 20.0),
                        underline:const SizedBox(),
                        alignment: Alignment.center,
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(25.0),
                        iconSize: 35,
                        icon:const Icon(
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
                            cubit.displaydepartments();

                            // Clear the university error when a selection is made
                            universityError = null;
                          });
                        },
                      ),
                    ),
                    if (universityError != null) // Display error message if no university is selected
                      Text(
                        universityError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12.0,
                        ),
                      ),
                    const  SizedBox(
                      height: 10.0,
                    ),
                    if(cubit.departments.isNotEmpty && cubit.currentSelectedUniversity!=null)
                      const    Row(
                        children: [
                          Padding(
                            padding:EdgeInsets.symmetric(horizontal: 8.0),
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
                    if (cubit.departments.isNotEmpty && cubit.currentSelectedUniversity != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        child: DropdownButton(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          underline:const SizedBox(),
                          alignment: Alignment.center,
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(25.0),
                          iconSize: 35,
                          icon:const Icon(
                            Icons.arrow_drop_down_sharp,
                            size: 28,
                          ),
                          value: cubit.currentSelectedDepartment,
                          items: cubit.departments
                              .map(
                                (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name!),
                            ),
                          )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              cubit.currentSelectedDepartment = value;

                              // Clear the department error when a selection is made
                              departmentError = null;
                            });
                          },
                        ),
                      ),
                    if (departmentError != null) // Display error message if no department is selected
                      Text(
                        departmentError!,
                        style:const TextStyle(
                          color: Colors.red,
                          fontSize: 12.0,
                        ),
                      ),

                    const  SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if(cubit.currentSelectedDepartment!=null && cubit.currentSelectedDepartment!.underGraduate==true)
                            const   Text('Under Graduate'),
                          if(cubit.currentSelectedDepartment!=null && cubit.currentSelectedDepartment!.underGraduate==true)
                            Checkbox(
                              value: underGraduateCheckbox,
                              onChanged: (value) {
                                setState(() {
                                  underGraduateCheckbox = value!;
                                });
                              },
                            ),
                          if(cubit.currentSelectedDepartment!=null && cubit.currentSelectedDepartment!.postGraduate==true)

                            const   Text('Post Graduate'),
                          if(cubit.currentSelectedDepartment!=null && cubit.currentSelectedDepartment!.postGraduate==true)

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
                    const   SizedBox(
                      height: 10.0,
                    ),
                    // if (error)
                    //   Text(
                    //     'please fill all fields',
                    //     style: TextStyle(
                    //       color: Colors.red,
                    //       fontSize: 16.0,
                    //     ),
                    //   ),
                    // if (error)
                    //   SizedBox(
                    //     height: 10.0,
                    //   ),
                    ConditionalBuilder(
                      condition: isUploading == false ||
                          state is! CreateDepartmentLoadingState,
                      builder: (context) => Row(
                        children: [
                          Expanded(
                            child: reusableElevatedButton(
                              label: 'Save',
                              function: () {
                                universityError = null;
                                departmentError = null;
                                nameError = null;
                                emailError = null;
                                passwordError = null;
                                phoneError = null;
                                if (cubit.currentSelectedUniversity == null) {
                                  universityError = 'Select a university';
                                }

                                // Check if no department is selected
                                if (cubit.departments.isNotEmpty &&
                                    cubit.currentSelectedUniversity != null &&
                                    cubit.currentSelectedDepartment == null) {
                                  departmentError = 'Select a department';
                                }
                                if (nameController.text.isEmpty) {
                                  nameError = 'Name is required';
                                }
                                if (emailController.text.isEmpty) {
                                  emailError = 'Email is required';
                                }
                                if (passwordController.text.isEmpty) {
                                  passwordError = 'Password is required';
                                }
                                if (phoneController.text.isEmpty) {
                                  phoneError = 'Phone is required';
                                }
                                if (
                                nameController.text.isNotEmpty &&
                                    cubit.currentSelectedUniversity != null &&
                                    (underGraduateCheckbox || postGraduateCheckbox)
                                    && passwordController.text.isNotEmpty
                                    && emailController.text.isNotEmpty
                                    && phone!.isNotEmpty
                                ) {
                                  setState(() {
                                    isUploading = true;
                                  });
                                  cubit.AdminRegester(
                                      name: nameController.text,
                                      password: passwordController.text,
                                      phone: phone!,
                                      email: emailController.text,
                                      underGraduate: underGraduateCheckbox,
                                      postGraduate: postGraduateCheckbox);



                                  // cubit.createAdmin(
                                  //   name: nameController.text,
                                  //   email: emailController.text,
                                  //   password: passwordController.text,
                                  //   phone: phoneController.text,
                                  //   underGraduate: underGraduateCheckbox,
                                  //   postGraduate: postGraduateCheckbox,
                                  // );
                                } else {
                                  setState(() {
                                    error = true; // Set the error flag to true
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(
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
                                  passwordController.clear();
                                  emailController.clear();
                                  error = false; // Reset the error flag
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      fallback: (context) =>const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
