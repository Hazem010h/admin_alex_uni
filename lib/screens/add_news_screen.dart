import 'dart:io';
import 'package:admin_alex_uni/reusable_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddNewsScreen extends StatefulWidget {
  const AddNewsScreen({super.key});

  @override
  State<AddNewsScreen> createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {
  int sectionNumber = 0;

  final picker = ImagePicker();

  File? headlineImage;

  TextEditingController articleTitleController = TextEditingController();
  TextEditingController mainDescription = TextEditingController();

  List<File?> images = [];
  List<String?> descriptions = [];
  bool showErrors = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                child: const Text('Pick Image'),
              ),
            ),
            reusableTextFormField(
              label: 'Article title',
              onTap: () {},
              controller: articleTitleController,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 10,
            ),
            reusableTextFormField(
              label: 'Main Description',
              onTap: () {},
              controller: mainDescription,
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
            const SizedBox(
              height: 10,
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
            if (sectionNumber > 1)
              reusableElevatedButton(
                label: 'delete section',
                backColor: Colors.red,
                function: () {
                  setState(() {
                    sectionNumber--;
                    images.removeLast();
                    descriptions.removeLast();
                  });
                },
              ),
            const SizedBox(
              height: 10,
            ),
            if (showErrors)
              const Text(
                'Please fill all fields',
                style: TextStyle(color: Colors.red),
              ),
            if (showErrors)
              const SizedBox(
                height: 10,
              ),
            reusableElevatedButton(
              label: 'Save',
              function: () async {
                if (articleTitleController.text.isEmpty ||
                    mainDescription.text.isEmpty ||
                    headlineImage == null) {
                  setState(() {
                    showErrors = true;
                  });
                  return;
                }
                for(int i = 0; i < images.length; i++){
                  if(images[i] == null){
                    setState(() {
                      showErrors = true;
                    });
                    return;
                  }
                }
                for(int i = 0; i < descriptions.length; i++){
                  if(descriptions[i] == null){
                    setState(() {
                      showErrors = true;
                    });
                    return;
                  }
                }
                setState(() {
                  showErrors = false;
                });
                await uploadNews();
              },
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

    if (sectionNumber > images.length) {
      images.add(null);
      descriptions.add(null);
    }

    if(descriptions[index]!=null)
    sectionDescriptionController.text = descriptions[index]!;

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
        reusableTextFormField(
          label: 'Section Description',
          onTap: () {},
          onChanged: (value) {
            descriptions[index] = value;
            return null;
          },
          controller: sectionDescriptionController,
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
      final newRef = firestore
          .collection('News')
          .doc();

      // Set the initial department data
      await newRef.set({
        'title': articleTitleController.text,
        'mainDescription': mainDescription.text,
        'headlineImage': null,
        'images': [],
        'descriptions': [],

      });

      // Create a batch to perform multiple writes atomically
      WriteBatch batch = firestore.batch();

      if (headlineImage != null) {
        final storageRef = storage.ref().child(
            'News/${newRef.id}/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = storageRef.putFile(headlineImage!);
        final snapshot = await uploadTask;
        if (snapshot.state == firebase_storage.TaskState.success) {
          final imageUrl = await storageRef.getDownloadURL();

          // Update the department data with the image URL
          batch.update(newRef, {
            'headlineImage': imageUrl,
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
        }else{
          imageUrl = null;
        }

        batch.update(newRef, {
          'images': FieldValue.arrayUnion([imageUrl]),
          'descriptions': FieldValue.arrayUnion([descriptions[i]==''?null:descriptions[i]]),
        });
      }

      await batch.commit();
      setState(() {
        sectionNumber = 1;
        headlineImage = null;
        articleTitleController.clear();
        mainDescription.clear();
        images = [];
        descriptions = [];
      });
    } catch (error) {
      print('Error uploading department: $error');
    }
  }
}
