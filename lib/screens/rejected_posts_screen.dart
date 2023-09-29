import 'package:admin_alex_uni/screens/view_images_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../comments/comments_screen.dart';
import '../constants.dart';
import '../cubit/app_cubit.dart';
import '../cubit/app_states.dart';
import '../models/post_model.dart';
import '../reusable_widgets.dart';

class rejectedPostsPage extends StatefulWidget {
  const rejectedPostsPage({super.key});

  @override
  State<rejectedPostsPage> createState() => _rejectedPostsPageState();
}

class _rejectedPostsPageState extends State<rejectedPostsPage> {
  @override
  void initState() {
AppCubit.get(context).getRejectedPosts();

  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {

        return Scaffold(
          appBar: AppBar(
            title: Text('rejected posts'),
          ),
          body:  ConditionalBuilder(
            condition: state is! GetPostsLoadingState ,
            builder:(context)=> Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      90,
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => buildPostItem(
                        AppCubit.get(context).rejectedposts,
                        AppCubit.get(context).rejectedpost[index],
                        index,
                        context),

                    itemCount: AppCubit.get(context).rejectedposts.length,
                  ),
                ),
            fallback: (context)=>Center(child: CircularProgressIndicator(color: defaultColor,),),


          ),
        );
      },
    );
  }

  Widget buildPostItem(List posts, PostModel model, index, context) => Card(
    color: const Color(0xffE6EEFA),
    clipBehavior: Clip.none,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  '${posts[index].values.single.userImage}',
                ),
                radius: 25,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {

                                  },
                                  child: Text(
                                    '${posts[index].values.single.userName}',
                                    style: const TextStyle(
                                      height: 1.4,
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.verified,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                            Text(
                              '${posts[index].values.single.date}',
                              style: const TextStyle(
                                height: 1.4,
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(
              color: Colors.grey[350],
              height: 1,
            ),
          ),
          Text(
            '${posts[index].values.single.text}',
          ),
          const SizedBox(
            height: 10,
          ),
          if (posts[index].values.single.image.isNotEmpty)
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  GridView.count(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1 / 1,
                    children: List.generate(
                      AppCubit.get(context)
                          .rejectedposts[index]
                          .values
                          .single
                          .image!
                          .length >
                          4
                          ? 4
                          : AppCubit.get(context)
                          .rejectedposts[index]
                          .values
                          .single
                          .image!
                          .length,
                          (index1) => Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  navigateTo(
                                      context: context,
                                      screen: ViewImagesScreen(
                                          view: AppCubit.get(context).rejectedposts,
                                          index1: index,
                                          index2: index1,
                                          id: AppCubit.get(context)
                                              .rejectedpostsIds));
                                },
                                child: AppCubit.get(context)
                                    .rejectedposts[index]
                                    .values
                                    .single
                                    .image!
                                    .length >
                                    4
                                    ? index1 == 3
                                    ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.network(
                                      AppCubit.get(context)
                                          .rejectedposts[index]
                                          .values
                                          .single
                                          .image![index1],
                                      width: double.infinity,
                                    ),
                                    Text(
                                      '${AppCubit.get(context).rejectedposts[index].values.single.image!.length - 4}+',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                                    : Image.network(
                                  AppCubit.get(context)
                                      .rejectedposts[index]
                                      .values
                                      .single
                                      .image![index1],
                                  width: double.infinity,
                                )
                                    : Image.network(
                                  AppCubit.get(context)
                                      .rejectedposts[index]
                                      .values
                                      .single
                                      .image![index1],
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: (){
                    AppCubit.get(context).addReviewPost(
                      id: AppCubit.get(context).rejectedpostsIds[index],
                      showPost: true,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5,),

              const SizedBox(width: 5,),
              Expanded(
                child: InkWell(
                  onTap: () {
                    AppCubit.get(context).deleteRejectedPost(
                        AppCubit.get(context).rejectedpostsIds[index]);
                    AppCubit.get(context).rejectedpostsIds[index]='';
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.red,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ]
  ),
    ),
  );
}
