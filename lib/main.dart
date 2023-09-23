import 'package:admin_alex_uni/screens/Admin_login_screen.dart';
import 'package:admin_alex_uni/screens/layout_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cache_helper.dart';
import 'constants.dart';
import 'cubit/app_cubit.dart';
import 'cubit/bloc_observer.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  uId = await CacheHelper.getData(key: 'uId');
  lang = await CacheHelper.getData(key: 'lang');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Widget startPage;

    if (uId == null) {
      startPage = const AdminloginScreen();
    } else {
      startPage = const LayoutScreen();
    }

  runApp(MyApp(
    startPage: startPage,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.startPage,
  }) : super(key: key);

  final Widget startPage;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {





  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AppCubit()..getAdminData(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
            ),
            backgroundColor: Colors.white,
            elevation: 2,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
        ),

        routes: {

          AdminloginScreen.id: (context) => const AdminloginScreen(),

          // ... define other named routes if needed ...
        },
        home: widget.startPage,
      ),
    );
  }
}
