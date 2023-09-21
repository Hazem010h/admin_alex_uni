abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeNavBarState extends AppStates {}

class CreateUniversityLoadingState extends AppStates {}

class CreateUniversitySuccessState extends AppStates {}

class CreateUniversityErrorState extends AppStates {
  final String error;

  CreateUniversityErrorState(this.error);
}

class PickImageSuccessState extends AppStates {}
class PickImageLoadingState extends AppStates {}
class PickImageErrorState extends AppStates {}

class CreateDepartmentLoadingState extends AppStates {}
class CreateDepartmentSuccessState extends AppStates {}

class GetUniversitiesLoadingState extends AppStates {}
class GetUniversitiesSuccessState extends AppStates {}
class GetUniversitiesErrorState extends AppStates {
  final String error;

  GetUniversitiesErrorState(this.error);
}

class GetDepartmentsLoadingState extends AppStates {}
class GetDepartmentsSuccessState extends AppStates {}
class GetDepartmentsErrorState extends AppStates {
  final String error;

  GetDepartmentsErrorState(this.error);
}



class CreateAdminLoadingState extends AppStates {}
class CreateAdminSuccessState extends AppStates {}
class CreateAdminErrorState extends AppStates {}