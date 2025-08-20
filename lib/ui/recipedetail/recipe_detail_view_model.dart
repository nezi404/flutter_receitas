import 'package:app4_receitas/data/models/recipe.dart';
import 'package:app4_receitas/data/repository/auth_repository.dart';
import 'package:app4_receitas/data/repository/recipe_repository.dart';
import 'package:app4_receitas/di/service_locator.dart';
import 'package:either_dart/either.dart';
import 'package:get/get.dart';

class RecipeDetailViewModel extends GetxController {
  
  final _repository = getIt<RecipeRepository>();
  final _authRepository = getIt<AuthRepository>();

  // estados
  final Rxn<Recipe> _recipe = Rxn<Recipe>();
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxBool _isFavorite = false.obs;

  // getters
  Recipe? get recipe => _recipe.value;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;
  bool get isFavorite => _isFavorite.value;

  Future<void> loadRecipe(String id) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      _recipe.value = await _repository.getRecipeById(id);

      var userId = "";
      await _authRepository.currentUser.fold(
        (left) => _errorMessage.value = _errorMessage.value,
        (right) => userId = right.id
      );

      _isFavorite.value = await isRecipeFavorite(id, userId);

    } catch(e) {
      _errorMessage.value = 'Falha ao buscar receita: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> isRecipeFavorite(String recipeId, String userId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = "";

      final favRecipes = await _repository.getFavouriteRecipes(userId);    
      return favRecipes.any((recipe) => recipe.id == recipeId);
    } catch(e) {
        _errorMessage.value = 'Falha ao buscar receita favorita: ${e.toString()}';
      } finally {
        _isLoading.value = false;
      }

      return false;
}

  Future<void> toggleFavorite() async {

    var userId = "";
      await _authRepository.currentUser.fold(
        (left) => _errorMessage.value = _errorMessage.value,
        (right) => userId = right.id
      );
    final recipeId = recipe!.id;

    if (_isFavorite.value) {

      await removeFromFavourites(recipeId, userId);

    } else {

      await addToFavourites(recipeId, userId);
    }

  }

  Future<void> addToFavourites(String recipeId, String userId) async {

    try {

      _isLoading.value = true;
      _errorMessage.value = "";
      await _repository.insertFavouriteRecipe(recipeId, userId);
      _isFavorite.value = true;
    } catch (e) {
      _errorMessage.value = "Falha ao adicionar aos favoritos: ${e.toString()}";
    } finally {
      _isLoading.value = false;
    }

  }

  Future<void> removeFromFavourites(String recipeId, String userId) async {

    try {

      _isLoading.value = true;
      _errorMessage.value = "";
      await _repository.deleteFavouriteRecipe(recipeId, userId);
      _isFavorite.value = false;
    } catch (e) {
      _errorMessage.value = "Falha ao adicionar aos favoritos: ${e.toString()}";
    } finally {
      _isLoading.value = false;
    }
    
  }

}


