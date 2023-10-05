import 'package:flutter/material.dart';
import 'package:admin_alex_uni/screens/view_images_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants.dart';
import '../cubit/app_cubit.dart';
import '../cubit/app_states.dart';
import '../models/post_model.dart';
import '../reusable_widgets.dart';
import 'comments/comments_screen.dart';
class showAllPosts extends StatefulWidget {
  const showAllPosts({super.key});

  @override
  State<showAllPosts> createState() => _showAllPostsState();
}


class _showAllPostsState extends State<showAllPosts> {
  @override
  void initState() {
    // TODO: implement initState
    AppCubit.get(context).getPosts();
    AppCubit.get(context).getAdminData();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text('All posts'),
          ),
          body:  SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          90,
                        ),
                      ),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => buildPostItem(
                            AppCubit.get(context).posts,
                            AppCubit.get(context).post[index],
                            index,
                            context),

                        itemCount: AppCubit.get(context).posts.length,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget? buildPostItem(List posts, PostModel model, index, context) => Card(
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
                        const Spacer(),

                          IconButton(
                            onPressed: () {
                              AppCubit.get(context).deletePost(
                                  AppCubit.get(context).postsId[index]);
                            },
                            icon: const Icon(
                              Icons.delete,
                              size: 20,
                              color: Colors.grey,
                            ),
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
                  Container(
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.6),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          if (isGuest == false)
                            InkWell(
                              onTap: () {

                                AppCubit.get(context).updateAdminPostLikes(
                                  AppCubit.get(context).posts[index],

                                );
                              },
                              child: const Icon(
                                Icons.favorite_outline_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10,),

                            Text(
                              '${posts[index].values.single.likes.length}',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                        const SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              AppCubit.get(context).getComments(
                                  postId:
                                  AppCubit.get(context).postsId[index]);
                              navigateTo(
                                context: context,
                                screen: CommentsScreen(
                                  postId:
                                  AppCubit.get(context).postsId[index],
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.comment_outlined,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          if (isGuest == false)
                            InkWell(
                              onTap: () {
                                AppCubit.get(context).addSharedPosts(
                                    postId: AppCubit.get(context)
                                        .postsId[index],
                                    index: index,
                                    context: context);
                              },
                              child: const Icon(
                                Icons.share_outlined,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (posts[index].values.single.image.isEmpty)
            Container(
              width: double.infinity,
              color: Colors.black.withOpacity(0.6),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    if (isGuest == false)
                      InkWell(
                        onTap: () {
                          // AppCubit.get(context).updatePostLikes(
                          //   AppCubit.get(context).posts[index],
                          // );
                        },
                        child: const Icon(
                          Icons.favorite_outline_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    if (isGuest == false)
                      const SizedBox(
                        width: 5,
                      ),
                    if (isGuest == false)
                      Text(
                        '${posts[index].values.single.likes.length}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    if (isGuest == false)
                      const SizedBox(
                        width: 20,
                      ),
                    InkWell(
                      onTap: () {
                        // AppCubit.get(context).getComments(
                        //     postId: AppCubit.get(context).postsId[index]);
                        // navigateTo(
                        //   context: context,
                        //   screen: CommentsScreen(
                        //     postId: AppCubit.get(context).postsId[index],
                        //   ),
                        // );
                      },
                      child: const Icon(
                        Icons.comment_outlined,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    if (isGuest == false)
                      InkWell(
                        onTap: () {},
                        child: const Icon(
                          Icons.share_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    if (isGuest == false) const SizedBox(width: 20),
                    if (isGuest == false)
                      InkWell(
                        onTap: () {
                          // AppCubit.get(context).addSavePosts(
                          //     postId: AppCubit.get(context).postsId[index],
                          //     index: index);
                        },
                        child: const Icon(
                          Icons.bookmark_border_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
