abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeNavBarState extends AppStates {}

class CreateUniversityLoadingState extends AppStates {}

class CreateUniversitySuccessState extends AppStates {}

class CreateUniversityErrorState extends AppStates {
  final String error;

  CreateUniversityErrorState(this.error);
}