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

  int sectionNumber = 1;

  final picker = ImagePicker();

  File? headlineImage;

  TextEditingController articleTitleController = TextEditingController();
  TextEditingController headlineController = TextEditingController();

  List<File?> images = [];
  List<String?> titles = [];
  List<String?> descriptions = [];
  List<String?> imagesDescriptions = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              label: 'Headline',
              onTap: () {},
              controller: headlineController,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 10,
            ),
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
            const SizedBox(
              height: 10,
            ),
            Center(
              child: TextButton(
                onPressed: ()async {
                  headlineImage = await pickImage();
                  setState((){
                    headlineImage;
                  });
                },
                child: const Text('Pick Image'),
              ),
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
                    titles.removeLast();
                    descriptions.removeLast();
                    imagesDescriptions.removeLast();
                  });
                },
              ),
            const SizedBox(
              height: 10,
            ),
            reusableElevatedButton(
              label: 'Save',
              function: () async {
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
    TextEditingController sectionTitleController = TextEditingController();
    TextEditingController sectionDescriptionController =
        TextEditingController();
    TextEditingController sectionImageDescriptionController =
        TextEditingController();

    if (sectionNumber > images.length) {
      images.add(null);
      descriptions.add(null);
      titles.add(null);
      imagesDescriptions.add(null);
    }

    sectionDescriptionController.text = descriptions[index] ?? '';
    sectionTitleController.text = titles[index] ?? '';
    sectionImageDescriptionController.text = imagesDescriptions[index] ?? '';

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
            onPressed: ()async {
              images[index] = await pickImage();
              setState((){
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
          label: 'Image Description',
          onTap: () {},
          onChanged: (value) {
            imagesDescriptions[index] = value;
            return null;
          },
          controller: sectionImageDescriptionController,
          keyboardType: TextInputType.text,
        ),
        const SizedBox(
          height: 10,
        ),
        reusableTextFormField(
          label: 'Section Title',
          onTap: () {},
          onChanged: (value) {
            titles[index] = value;
            return null;
          },
          controller: sectionTitleController,
          keyboardType: TextInputType.text,
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
      final newsDocRef = await firestore.collection('News').add({
        'title': articleTitleController.text,
        'headline': headlineController.text,
        'headlineImage': null,
        'sectionTitles':[],
        'images': [],
        'imageDescription': [],
        'descriptions': [],
      });

      List<String?> imageUrls = []; // Collect image URLs

      if(headlineImage != null){
        final storageRef = storage
            .ref()
            .child('News/${newsDocRef.id}/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = storageRef.putFile(headlineImage!);
        final snapshot = await uploadTask;
        if (snapshot.state == firebase_storage.TaskState.success) {
          final imageUrl = await storageRef.getDownloadURL();

          await newsDocRef.update({
            'headlineImage': imageUrl,
          });

        } else {
          print('Error uploading image: ');
        }
      }

      for (int i = 0; i < images.length; i++) {
        final imageFile = images[i];
        if(imageFile == null){
          imageUrls.add(null);
          continue;
        }
        final storageRef = storage
            .ref()
            .child('News/${newsDocRef.id}/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = storageRef.putFile(imageFile);
        final snapshot = await uploadTask;
        if (snapshot.state == firebase_storage.TaskState.success) {
          final imageUrl = await storageRef.getDownloadURL();

          imageUrls.add(imageUrl); // Add image URL to the list// Add description to the list
        } else {
          print('Error uploading image: ');
        }
      }

      await newsDocRef.update({
        'images': FieldValue.arrayUnion(imageUrls),
        'descriptions': FieldValue.arrayUnion(descriptions),
        'sectionTitles': FieldValue.arrayUnion(titles),
        'imageDescription': FieldValue.arrayUnion(imagesDescriptions),
      });

    } catch (error) {
      print('Error uploading news: $error');
    }
  }

}
