import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:admin_alex_uni/reusable_widgets.dart';
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
    // TODO: implement initState
    AppCubit.get(context).getAdminData();
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
                IconButton(onPressed: (){
                  navigateTo(context: context, screen: SettingScreen(),);
                }, icon: Icon(Icons.settings),),
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

              ],
            )
          );
        },
      ),
    );
  }
}
