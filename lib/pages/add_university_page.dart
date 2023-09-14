import 'package:admin_alex_uni/cubit/app_cubit.dart';
import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:admin_alex_uni/reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUniversityPage extends StatelessWidget {
  AddUniversityPage({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state) {

        AppCubit cubit = AppCubit.get(context);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(child: Text('University Image'),),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.add_a_photo,
                      size: 50,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'University Name',
              ),
              const SizedBox(
                height: 10,
              ),
              reusableTextFormField(
                label: 'University Name',
                onTap: () {},
                controller: nameController,
                keyboardType: TextInputType.text,
                borderRadius: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'University Description',
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: TextFormField(
                  controller: descController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'University Description',
                    hintText: 'University Description',
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: reusableElevatedButton(
                      backColor: Colors.grey,
                      label: 'Clear',
                      function: () {
                        nameController.clear();
                        descController.clear();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: reusableElevatedButton(
                      label: 'Add University',
                      function: () {
                        cubit.createUniversity(
                          name: nameController.text,
                          description: descController.text,
                          context: context,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}