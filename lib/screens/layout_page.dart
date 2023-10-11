import 'package:admin_alex_uni/constants.dart';
import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:admin_alex_uni/reusable_widgets.dart';
import 'package:admin_alex_uni/screens/add_department_screen/add_department_screen.dart';
import 'package:admin_alex_uni/screens/add_news_screen/choose_language_screen.dart';
import 'package:admin_alex_uni/screens/all_posts_screen.dart';
import 'package:admin_alex_uni/screens/rejected_posts_screen.dart';
import 'package:admin_alex_uni/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/app_cubit.dart';


class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  void initState() {
    super.initState();
    AppCubit.get(context).getAdminData();
    AppCubit.get(context).getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title:  Text(cubit.homeTitle),
            actions: [
              IconButton(
                onPressed: () async {
                  navigateTo(
                    context: context,
                    screen: SettingScreen(),
                  );
                },
                icon: const Icon(
                  Icons.settings,
                ),
              ),
              IconButton(
                onPressed: () {
                  cubit.logout(context);
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: defaultColor,
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeNavBar(index);
            },
            items:  [
              BottomNavigationBarItem(
                icon:const Icon(Icons.add),
                label: lang == 'ar' ? 'الكليات' : 'Universities',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.newspaper),
                label: lang == 'ar' ? 'مراجعه المنشورات' : 'Review Posts',
              ),
            ],
          ),
          drawer: isGuest==false? Drawer(
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        navigateTo(
                          context: context,
                          screen:  AddDepartmentScreen(),
                        );
                      },
                      child:  Padding(
                        padding:const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add,
                            ),
                            const  SizedBox(
                              width: 10,
                            ),
                            Text(
                              lang=='en'? 'Add Department':'اضافة قسم',
                            ),
                            const   Spacer(),
                            const   Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        navigateTo(
                          context: context,
                          screen: const showAllPosts(),
                        );
                      },
                      child:  Padding(
                        padding:const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person,
                            ),
                            const  SizedBox(
                              width: 10,
                            ),
                            Text(
                             lang=='en'? 'posts':'المنشورات' ,
                            ),
                            const   Spacer(),
                            const   Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    InkWell(
                      onTap: () {
                        navigateTo(context: context, screen: const rejectedPostsPage());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.inbox,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              lang=='en'? 'Rejected Posts':'المنشورات المرفوضة',

                            ),
                           const  Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    InkWell(
                      onTap: () {
                        navigateTo(context: context, screen: const ChooseLanguageScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.newspaper,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              lang=='en'? 'Add News':'اضافة خبر',

                            ),
                            const  Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: reusableElevatedButton(
                        label: lang == 'ar' ? 'تسجيل الخروج' : 'Logout',
                        backColor: defaultColor,
                        height: 40,
                        function: () {
                          AppCubit.get(context).logout(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ): null,
        );
      },
    );
  }
}
