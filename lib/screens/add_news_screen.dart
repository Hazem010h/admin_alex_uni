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
  TextEditingController articleTitleController = TextEditingController();

  List<File?> images = [];
  // List<String?>imagesUrls = [];

  List<String?> titles = [];
  List<String?> descriptions = [];
  List<String?> ImagesDescriptions = [];

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
            SizedBox(
              height: 10,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => buildSectionItem(
                context: context,
                index: index,
              ),
              separatorBuilder: (context, index) => SizedBox(
                height: 10,
              ),
              itemCount: sectionNumber,
            ),
            SizedBox(
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
            SizedBox(
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
                    ImagesDescriptions.removeLast();
                  });
                },
              ),
            SizedBox(
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
      ImagesDescriptions.add(null);
    }

    sectionDescriptionController.text = descriptions[index] ?? '';
    sectionTitleController.text = titles[index] ?? '';
    sectionImageDescriptionController.text = ImagesDescriptions[index] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Section: ${index + 1}',
            style: TextStyle(
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
        SizedBox(
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
            child: Text('Pick Image'),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        reusableTextFormField(
          label: 'Image Description',
          onTap: () {},
          onChanged: (value) {
            ImagesDescriptions[index] = value;
            return null;
          },
          controller: sectionImageDescriptionController,
          keyboardType: TextInputType.text,
        ),
        SizedBox(
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
        SizedBox(
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

  // upload images list to firebase storage and return list of urls
  // uploadImages(){
  //   for(int i = 0; i < images.length; i++){
  //     if(images[i] != null){
  //       uploadImage(images[i]!).then((value) {
  //         imagesUrls.add(value);
  //       });
  //     }else{
  //       imagesUrls.add(null);
  //     }
  //   }
  //   return imagesUrls;
  // }
  //
  // // upload image to firebase storage and return url
  // Future<String> uploadImage(File image) async {
  //   String imageUrl = '';
  //   await FirebaseStorage.instance
  //       .ref()
  //       .child('News/${Uri.file(image.path).pathSegments.last}')
  //       .putFile(image)
  //       .then((value) async {
  //     await value.ref.getDownloadURL().then((value) {
  //       imageUrl = value;
  //     });
  //   });
  //   print (imageUrl);
  //   return imageUrl;
  // }
  //
  // // upload news to firebase firestore
  // uploadNews() async {
  //   print(imagesUrls);
  //   FirebaseFirestore.instance.collection('News').add({
  //     'title': articleTitleController.text,
  //     'newsSections': [
  //       for(int i = 0; i < sectionNumber; i++)
  //         {
  //           'image': imagesUrls[i],
  //           'title': titles[i],
  //           'description': descriptions[i],
  //           'imageDescription': ImagesDescriptions[i],
  //         }
  //     ],
  //   });
  // }
  Future<void> uploadNews() async {
    final firestore = FirebaseFirestore.instance;
    final storage = firebase_storage.FirebaseStorage.instance;

    try {
      final newsDocRef = await firestore.collection('News').add({
        'title': articleTitleController.text,
        'sectionTitles':[],
        'images': [],
        'imageDescription': [],
        'descriptions': [],
      });

      List<String?> imageUrls = []; // Collect image URLs
      // List<String> imageDescriptions = []; // Collect descriptions

      for (int i = 0; i < images.length; i++) {
        final imageFile = images[i];
        if(imageFile == null){
          imageUrls.add(null);
          continue;
        }
        // final description = descriptions[i];
        final storageRef = storage
            .ref()
            .child('News/${newsDocRef.id}/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = storageRef.putFile(imageFile!);
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
        'imageDescription': FieldValue.arrayUnion(ImagesDescriptions),
      });

    } catch (error) {
      print('Error uploading news: $error');
    }
  }

}
