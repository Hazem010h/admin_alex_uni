import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/app_cubit.dart';

class LayoutPage extends StatelessWidget {
  const LayoutPage({super.key});

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
            ),
            body: Row(
              children: [
                NavigationRail(
                  elevation: 5,
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.add),
                      selectedIcon: Icon(Icons.add),
                      label: Text('Add University'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.add),
                      selectedIcon: Icon(Icons.add),
                      label: Text('Add Department'),
                    ),
                  ],
                  selectedIndex: cubit.currentIndex,
                  onDestinationSelected: (index) {
                    cubit.changeNavBar(index);
                  },
                ),
                Expanded(
                  child: cubit.screens[cubit.currentIndex],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
