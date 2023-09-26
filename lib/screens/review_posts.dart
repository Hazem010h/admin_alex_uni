import 'package:admin_alex_uni/cubit/app_cubit.dart';
import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:admin_alex_uni/screens/view_images_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/post_model.dart';
import '../reusable_widgets.dart';

class ReviewPostsScreen extends StatefulWidget {
  const ReviewPostsScreen({super.key});

  @override
  State<ReviewPostsScreen> createState() => _ReviewPostsScreenState();
}

class _ReviewPostsScreenState extends State<ReviewPostsScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppCubit.get(context).reviewPosts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        return ConditionalBuilder(
          condition: state is GetPostsSuccessState,
          builder: (context)=>ListView.builder(
            itemBuilder: (context, index) {
              return buildPostItem(
                AppCubit.get(context).posts,
                AppCubit.get(context).posts[index].values.single,
                index,
                context,
              );
            },
            itemCount: AppCubit.get(context).posts.length,
          ),
          fallback: (context)=>const Center(child: CircularProgressIndicator(),),
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
                                    // print(posts[index].values.single.userId);
                                    // navigateTo(
                                    //   context: context,
                                    //   screen: ChatDetailsScreen(
                                    //     chatUserModel:
                                    //     posts[index].values.single,
                                    //   ),
                                    // );
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
                          .posts[index]
                          .values
                          .single
                          .image!
                          .length >
                          4
                          ? 4
                          : AppCubit.get(context)
                          .posts[index]
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
                                          view: AppCubit.get(context).posts,
                                          index1: index,
                                          index2: index1,
                                          id: AppCubit.get(context)
                                              .postsId));
                                },
                                child: AppCubit.get(context)
                                    .posts[index]
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
                                          .posts[index]
                                          .values
                                          .single
                                          .image![index1],
                                      width: double.infinity,
                                    ),
                                    Text(
                                      '${AppCubit.get(context).posts[index].values.single.image!.length - 4}+',
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
                                      .posts[index]
                                      .values
                                      .single
                                      .image![index1],
                                  width: double.infinity,
                                )
                                    : Image.network(
                                  AppCubit.get(context)
                                      .posts[index]
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
                  // Container(
                  //   width: double.infinity,
                  //   color: Colors.black.withOpacity(0.6),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Row(
                  //       children: [
                  //
                  //           InkWell(
                  //             onTap: () {
                  //               AppCubit.get(context).updatePostLikes(
                  //                 AppCubit.get(context).posts[index],
                  //               );
                  //             },
                  //             child: const Icon(
                  //               Icons.favorite_outline_rounded,
                  //               size: 18,
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //         const SizedBox(width: 5),
                  //           Text(
                  //             '${posts[index].values.single.likes.length}',
                  //             style: const TextStyle(
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //          const SizedBox(width: 20),
                  //         InkWell(
                  //           onTap: () {
                  //             AppCubit.get(context).getComments(
                  //                 postId:
                  //                 AppCubit.get(context).postsId[index]);
                  //             // navigateTo(
                  //             //   context: context,
                  //             //   screen: CommentsScreen(
                  //             //     postId:
                  //             //     AppCubit.get(context).postsId[index],
                  //             //   ),
                  //             // );
                  //           },
                  //           child: const Icon(
                  //             Icons.comment_outlined,
                  //             size: 18,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //         const Spacer(),
                  //
                  //           InkWell(
                  //             onTap: () {
                  //               AppCubit.get(context).addSharedPosts(
                  //                   postId: AppCubit.get(context)
                  //                       .postsId[index],
                  //                   index: index,
                  //                   context: context);
                  //             },
                  //             child: const Icon(
                  //               Icons.share_outlined,
                  //               size: 18,
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //          const SizedBox(width: 20),
                  //
                  //           InkWell(
                  //             onTap: () {
                  //               // AppCubit.get(context).addSavePosts(
                  //               //     postId: AppCubit.get(context)
                  //               //         .postsId[index],
                  //               //     index: index);
                  //             },
                  //             child: const Icon(
                  //               Icons.bookmark_border_outlined,
                  //               size: 18,
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          // if (posts[index].values.single.image.isEmpty)
          //   Container(
          //     width: double.infinity,
          //     color: Colors.black.withOpacity(0.6),
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(
          //         children: [
          //             InkWell(
          //               onTap: () {
          //                 AppCubit.get(context).updatePostLikes(
          //                   AppCubit.get(context).posts[index],
          //                 );
          //               },
          //               child: const Icon(
          //                 Icons.favorite_outline_rounded,
          //                 size: 18,
          //                 color: Colors.white,
          //               ),
          //             ),
          //             const SizedBox(
          //               width: 5,
          //             ),
          //
          //             Text(
          //               '${posts[index].values.single.likes.length}',
          //               style: const TextStyle(
          //                 color: Colors.white,
          //               ),
          //             ),
          //
          //             const SizedBox(
          //               width: 20,
          //             ),
          //           InkWell(
          //             onTap: () {
          //               AppCubit.get(context).getComments(
          //                   postId: AppCubit.get(context).postsId[index]);
          //               navigateTo(
          //                 context: context,
          //                 screen: CommentsScreen(
          //                   postId: AppCubit.get(context).postsId[index],
          //                 ),
          //               );
          //             },
          //             child: const Icon(
          //               Icons.comment_outlined,
          //               size: 18,
          //               color: Colors.white,
          //             ),
          //           ),
          //           const Spacer(),
          //
          //             InkWell(
          //               onTap: () {},
          //               child: const Icon(
          //                 Icons.share_outlined,
          //                 size: 18,
          //                 color: Colors.white,
          //               ),
          //             ),
          //            const SizedBox(width: 20),
          //
          //             InkWell(
          //               onTap: () {
          //                 AppCubit.get(context).addSavePosts(
          //                     postId: AppCubit.get(context).postsId[index],
          //                     index: index);
          //               },
          //               child: const Icon(
          //                 Icons.bookmark_border_outlined,
          //                 size: 18,
          //                 color: Colors.white,
          //               ),
          //             ),
          //         ],
          //       ),
          //     ),
          //   ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: (){
                    AppCubit.get(context).addReviewPost(
                        id: AppCubit.get(context).postsId[index],
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
              Expanded(
                child: InkWell(
                  onTap: (){
                    AppCubit.get(context).addReviewPost(
                      id: AppCubit.get(context).postsId[index],
                      showPost: false,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5,),
              Expanded(
                child: InkWell(
                  onTap: () {
                    AppCubit.get(context).deletePost(
                        AppCubit.get(context).postsId[index]);
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
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
  );
}
