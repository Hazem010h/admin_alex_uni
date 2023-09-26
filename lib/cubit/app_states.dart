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

class AdminRegesterLoadingState extends AppStates {}
class AdminRegesterSuccessState extends AppStates {
  final String uId;
  AdminRegesterSuccessState(this.uId);
}
class AdminRegesterErrorState extends AppStates {
  final String error;

  AdminRegesterErrorState({required this.error});
}

class AppLogoutLoadingState extends AppStates {}

class AppLogoutSuccessState extends AppStates {}

class AppLogoutErrorState extends AppStates {
  final String error;

  AppLogoutErrorState(this.error);
}

class GetAdminDataLoadingState extends AppStates {}
class GetAdminDataSuccessState extends AppStates {}
class GetAdminDataErrorState extends AppStates {
  final String error;

  GetAdminDataErrorState(this.error);
}

class UpdateUserDataLoadingState extends AppStates {}
class UpdateUserDataSuccessState extends AppStates {}
class UpdateUserDataErrorState extends AppStates {
  final String error;

  UpdateUserDataErrorState(this.error);
}

class UploadNewsSuccessState extends AppStates {}
class UploadNewsErrorState extends AppStates {}

class GetSettingsLoadingState extends AppStates {}
class GetSettingsSuccessState extends AppStates {}
class GetSettingsErrorState extends AppStates {
  final String error;

  GetSettingsErrorState(this.error);
}

class GetPostsLoadingState extends AppStates {}
class GetPostsSuccessState extends AppStates {}
class GetPostsErrorState extends AppStates {
  final String error;

  GetPostsErrorState(this.error);
}

class DeletePostSuccessState extends AppStates {}

class GetCommentsLoadingState extends AppStates {}

class GetCommentsSuccessState extends AppStates {}

class GetCommentsErrorState extends AppStates {
  final String error;

  GetCommentsErrorState(this.error);
}
