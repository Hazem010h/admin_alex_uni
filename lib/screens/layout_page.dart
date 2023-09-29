import 'package:admin_alex_uni/constants.dart';
import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:admin_alex_uni/reusable_widgets.dart';
import 'package:admin_alex_uni/screens/all_posts_screen.dart';
import 'package:admin_alex_uni/screens/rejected_posts_screen.dart';
import 'package:admin_alex_uni/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/app_cubit.dart';
import '../models/admin_model.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    AppCubit.get(context).getAdminData();
    AppCubit.get(context).getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              title: const Text('Layout Page'),
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
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeNavBar(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'University',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'Department',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'News',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper),
                  label: 'Review Posts',
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
                            screen: const showAllPosts(),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'posts' ,
                              ),
                              Spacer(),
                              Icon(
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
                          navigateTo(context: context, screen: rejectedPostsPage());
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
                                'rejected Posts',
                              ),
                              Spacer(),
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
                      SizedBox(
                        height: 100,
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
      ),
    );
  }
}
