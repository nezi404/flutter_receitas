import 'package:app4_receitas/data/models/user_profile.dart';
import 'package:app4_receitas/data/repository/auth_repository.dart';
import 'package:app4_receitas/di/service_locator.dart';
import 'package:get/get.dart';

class ProfileViewModel extends GetxController{
  
  final _repository = getIt<AuthRepository>();

  final _profile = Rxn<UserProfile>();
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;

  Rxn<UserProfile> get profile => _profile;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  
  Future<void> getCurrentUser() async {

    _isLoading.value = true;
    
    final result = await _repository.currentUser;
    result.fold(
      (left) => _errorMessage.value = left.message,
      (right) => _profile.value = right,
      );

      _isLoading.value = false;
    }

    // fazer logout
}