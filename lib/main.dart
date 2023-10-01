import 'package:admin_alex_uni/screens/Admin_login_screen.dart';
import 'package:admin_alex_uni/screens/layout_page.dart';
import 'package:admin_alex_uni/screens/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cache_helper.dart';
import 'constants.dart';
import 'cubit/app_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

  if(lang != null) {
    if (uId == null) {
      startPage = const AdminloginScreen();
    } else {
      startPage = const LayoutScreen();
    }
  }else{
    startPage = const SplashScreen();
  }

  runApp(MyApp(startPage: startPage,));
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.startPage,
  }) : super(key: key);

  final Widget startPage;

  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late Locale _selectedLocale;

  _MyAppState() {
    _selectedLocale = Locale(lang ?? 'en');
  }

  void setLocale(Locale newLocale) {
    setState(() {
      _selectedLocale = newLocale;
    });
  }

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
        locale: _selectedLocale,
        supportedLocales: const [
          Locale('en', ''),
          Locale('ar', ''),
        ],
        localizationsDelegates:  const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
        ],
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
        },
        home: widget.startPage,
      ),
    );
  }
}
