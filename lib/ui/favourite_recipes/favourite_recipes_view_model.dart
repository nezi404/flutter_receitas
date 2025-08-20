import 'package:app4_receitas/data/models/recipe.dart';
import 'package:app4_receitas/data/repository/auth_repository.dart';
import 'package:app4_receitas/data/repository/recipe_repository.dart';
import 'package:app4_receitas/di/service_locator.dart';
import 'package:either_dart/either.dart';
import 'package:get/get.dart';

class FavouriteRecipesViewModel extends GetxController {

  final _repository = getIt<RecipeRepository>();
  final _authRepository = getIt<AuthRepository>();

  final RxList<Recipe> _favRecipes = <Recipe>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  List<Recipe> get favRecipes => _favRecipes;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;
  
  Future<void> getFavouriteRecipes() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = "";

      var userId = "";
      await _authRepository.currentUser.fold(
        (left) => _errorMessage.value = _errorMessage.value,
        (right) => userId = right.id
      );
      _favRecipes.value = await _repository.getFavouriteRecipes(userId);
    } catch (e) {
      _errorMessage.value = "Falha ao encontrar receita!!! ❌🗒️\n${e.toString()}";
    } finally {
      _isLoading.value = false;
    }
  }

}