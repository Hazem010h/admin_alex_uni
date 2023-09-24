import 'dart:io';
import 'package:admin_alex_uni/cubit/app_cubit.dart';
import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNewsScreen extends StatefulWidget {
  const AddNewsScreen({Key? key}) : super(key: key);

  @override
  State<AddNewsScreen> createState() => _AddNewsScreenState();
}
class NewsItem {
  File image;
  TextEditingController descriptionController = TextEditingController();

  NewsItem({
    required this.image,
    required String description,
  }) {
    descriptionController.text = description;
  }
}

class _AddNewsScreenState extends State<AddNewsScreen> {
  List<NewsItem> newsItems = [];
TextEditingController descriptionController = TextEditingController();
// List to hold image-description pairs
  // Function to pick an image from the device's gallery


  // Function to upload all the news items


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is UploadNewsSuccessState) {
          // clear the selected images and descriptions
          AppCubit.get(context).selectedImages.clear();
          AppCubit.get(context).descriptions.clear();
        }
      },
      builder: (context, state) {
        final cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Admin Page'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: cubit.pickNewsImage,
                  child: Text('Add Image'),
                ),
                Expanded(
              child:
                  ListView.builder(
                    itemCount: cubit.selectedImages.length,
                    itemBuilder: (context, index) {
                      final imageFile = cubit.selectedImages[index];
                      return Column(
                        children: [
                          // Display selected image in a circular avatar
                          Center(
                            child: CircleAvatar(
                              radius: 50, // You can adjust the radius as needed
                              backgroundImage: FileImage(imageFile),
                            ),
                          ),

                          // Text input for description using TextFormField
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextFormField(
                              onChanged: (text) {
                                cubit.descriptions[index] = text;
                                descriptionController.text = text;
                              },
                              decoration: const InputDecoration(

                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                // Remove both the image and description at the specified index
                                cubit.selectedImages.removeAt(index);
                                cubit.descriptions.removeAt(index);
                              });
                            },
                            child: Text('Delete'),
                          ),

                        ],
                      );
                    },
                  ),
// ...

                ),
                ElevatedButton(
                  onPressed: cubit.uploadNews,
                  child: const Text('Upload News'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}