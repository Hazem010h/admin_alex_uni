import 'dart:io';
import 'package:admin_alex_uni/constants.dart';
import 'package:admin_alex_uni/reusable_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';

class AddBothNewsScreen extends StatefulWidget {
  const AddBothNewsScreen({super.key});

  @override
  State<AddBothNewsScreen> createState() => _AddBothNewsScreenState();
}

class _AddBothNewsScreenState extends State<AddBothNewsScreen> {
  int sectionNumber = 0;

  final picker = ImagePicker();

  File? headlineImage;

  TextEditingController articleTitleController = TextEditingController();
  TextEditingController articleArabicTitleController = TextEditingController();
  TextEditingController mainDescription = TextEditingController();
  TextEditingController mainArabicDescription = TextEditingController();

  List<File?> images = [];
  List<String?> descriptions = [];
  List<String?> arabicDescriptions = [];
  bool showErrors = false;

  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lang == 'en'
            ? 'Add Arabic and English News'
            : 'اضافة خبر باللغة العربية و الانجليزية'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.15,
                  backgroundColor: headlineImage == null
                      ? Colors.grey[350]
                      : Theme.of(context).scaffoldBackgroundColor,
                  child: headlineImage == null
                      ? IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add_a_photo,
                            color: Colors.black,
                            size: MediaQuery.of(context).size.width * 0.1,
                          ),
                        )
                      : Image.file(headlineImage!),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () async {
                    headlineImage = await pickImage();
                    setState(() {
                      headlineImage;
                    });
                  },
                  child: Text(lang == 'en' ? 'Pick Image' : 'اختر صورة'),
                ),
              ),
              reusableTextFormField(
                label: lang == 'en'
                    ? 'Article English Title'
                    : 'عنوان المقالة بالانجليزية',
                onTap: () {},
                controller: articleTitleController,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              reusableTextFormField(
                label: lang == 'en'
                    ? 'Article Arabic Title'
                    : 'عنوان المقالة بالعربية',
                onTap: () {},
                controller: articleArabicTitleController,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              reusableTextFormField(
                label: lang == 'en'
                    ? 'Main English Description'
                    : 'الوصف الرئيسي بالانجليزية',
                onTap: () {},
                controller: mainDescription,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              reusableTextFormField(
                label: lang == 'en'
                    ? 'Main Arabic Description'
                    : 'الوصف الرئيسي بالعربية',
                onTap: () {},
                controller: mainArabicDescription,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => buildSectionItem(
                  context: context,
                  index: index,
                ),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemCount: sectionNumber,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: !isUploading
          ? Padding(
              padding: EdgeInsets.fromLTRB(
                  8, 8, 8, MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showErrors)
                    Text(
                      lang == 'en'
                          ? 'Please fill all fields'
                          : 'من فضلك املأ جميع الحقول',
                      style: const TextStyle(color: Colors.red),
                    ),
                  if (showErrors)
                    const SizedBox(
                      height: 10,
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: reusableElevatedButton(
                          label: lang == 'en' ? 'Add section' : 'اضافة قسم',
                          backColor: Colors.green,
                          function: () {
                            setState(() {
                              sectionNumber++;
                            });
                          },
                        ),
                      ),
                      if (sectionNumber > 0)
                        const SizedBox(
                          width: 5,
                        ),
                      if (sectionNumber > 0)
                        Expanded(
                          child: reusableElevatedButton(
                            label: lang == 'en' ? 'Remove section' : 'حذف قسم',
                            backColor: Colors.red,
                            function: () {
                              setState(() {
                                sectionNumber--;
                                images.removeLast();
                                descriptions.removeLast();
                              });
                            },
                          ),
                        ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: reusableElevatedButton(
                          label: lang == 'en' ? 'Save' : 'حفظ',
                          function: () async {
                            if (articleTitleController.text.isEmpty ||
                                mainDescription.text.isEmpty ||
                                articleArabicTitleController.text.isEmpty ||
                                mainArabicDescription.text.isEmpty ||
                                headlineImage == null) {
                              setState(() {
                                showErrors = true;
                              });
                              return;
                            }
                            for (int i = 0; i < images.length; i++) {
                              if (images[i] == null) {
                                setState(() {
                                  showErrors = true;
                                });
                                return;
                              }
                            }
                            for (int i = 0; i < descriptions.length; i++) {
                              if (descriptions[i] == null) {
                                setState(() {
                                  showErrors = true;
                                });
                                return;
                              }
                            }
                            for (int i = 0;
                                i < arabicDescriptions.length;
                                i++) {
                              if (arabicDescriptions[i] == null) {
                                setState(() {
                                  showErrors = true;
                                });
                                return;
                              }
                            }
                            setState(() {
                              showErrors = false;
                            });
                            isUploading = true;
                            await uploadNews();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: defaultColor,
                  ),
                ],
              ),
            ),
    );
  }

  Widget? buildSectionItem({
    required BuildContext context,
    required int index,
  }) {
    TextEditingController sectionDescriptionController =
        TextEditingController();
    TextEditingController sectionArabicDescriptionController =
        TextEditingController();

    if (sectionNumber > images.length) {
      images.add(null);
      descriptions.add(null);
      arabicDescriptions.add(null);
    }

    if (descriptions[index] != null) {
      sectionDescriptionController.text = descriptions[index]!;
    }
    if (arabicDescriptions[index] != null) {
      sectionArabicDescriptionController.text = arabicDescriptions[index]!;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            lang == 'en' ? 'Section: ${index + 1}' : 'القسم: ${index + 1}',
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
        Center(
          child: TextButton(
            onPressed: () async {
              images[index] = await pickImage();
              setState(() {
                images;
              });
            },
            child: Text(lang == 'en' ? 'Pick Image' : 'اختر صورة'),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        reusableTextFormField(
          label: lang == 'en' ? 'Section Description' : 'وصف القسم',
          onTap: () {},
          onChanged: (value) {
            descriptions[index] = value;
            return null;
          },
          controller: sectionDescriptionController,
          keyboardType: TextInputType.text,
        ),
        reusableTextFormField(
          label: lang == 'en'
              ? 'Section Arabic Description'
              : 'وصف القسم بالعربية',
          onTap: () {},
          onChanged: (value) {
            arabicDescriptions[index] = value;
            return null;
          },
          controller: sectionArabicDescriptionController,
          keyboardType: TextInputType.text,
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

  Future<void> uploadNews() async {
    final firestore = FirebaseFirestore.instance;
    final storage = firebase_storage.FirebaseStorage.instance;

    try {
      final newRef = firestore.collection('News').doc();

      DateTime now = DateTime.now();
      String formatter = DateFormat('yyyy-MM-dd').format(now);

      await newRef.set({
        'title': articleTitleController.text,
        'arabicTitle': articleArabicTitleController.text,
        'type': 'both',
        'date': formatter,
        'images': [],
        'descriptions': [
          mainDescription.text,
        ],
        'arabicDescriptions': [
          mainArabicDescription.text,
        ],
      });

      WriteBatch batch = firestore.batch();

      if (headlineImage != null) {
        final storageRef = storage.ref().child(
            'News/${newRef.id}/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = storageRef.putFile(headlineImage!);
        final snapshot = await uploadTask;
        if (snapshot.state == firebase_storage.TaskState.success) {
          final imageUrl = await storageRef.getDownloadURL();
          batch.update(newRef, {
            'images': FieldValue.arrayUnion([imageUrl]),
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
              'News/${newRef.id}/${DateTime.now().millisecondsSinceEpoch}');
          final uploadTask = storageRef.putFile(imageFile);
          final snapshot = await uploadTask;
          if (snapshot.state == firebase_storage.TaskState.success) {
            imageUrl = await storageRef.getDownloadURL();
          }
        } else {
          imageUrl = null;
        }

        batch.update(newRef, {
          'images': FieldValue.arrayUnion([imageUrl]),
          'descriptions': FieldValue.arrayUnion(
              [descriptions[i] == '' ? null : descriptions[i]]),
          'arabicDescriptions': FieldValue.arrayUnion(
              [arabicDescriptions[i] == '' ? null : arabicDescriptions[i]]),
        });
      }

      await batch.commit();
      setState(() {
        sectionNumber = 0;
        headlineImage = null;
        articleTitleController.clear();
        articleArabicTitleController.clear();

        mainDescription.clear();
        images = [];
        descriptions = [];
        mainArabicDescription.clear();
        arabicDescriptions = [];
        isUploading = false;
      });
    } catch (error) {
      print('Error uploading department: $error');
    }
  }
}
