part of 'admin_login_cubit.dart';

@immutable
abstract class AdminLoginState {}

class AdminLoginInitial extends AdminLoginState {}

class LoginInitialState extends AdminLoginState{}
class LoginLoadingState extends AdminLoginState{}
class LoginSuccessState extends AdminLoginState{
  final String uId;
  LoginSuccessState(this.uId);
}
class LoginErrorState extends AdminLoginState{
  String error;
  LoginErrorState({required this.error});
}



class CreateUserLoginLoadingState extends AdminLoginState{}

class CreateUserLoginSuccessState extends AdminLoginState{}

class CreateUserLoginErrorState extends AdminLoginState{}