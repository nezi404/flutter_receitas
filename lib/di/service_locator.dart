import 'package:app4_receitas/data/repository/auth_repository.dart';
import 'package:app4_receitas/data/repository/recipe_repository.dart';
import 'package:app4_receitas/data/services/auth_service.dart';
import 'package:app4_receitas/data/services/recipe_service.dart';
import 'package:app4_receitas/ui/auth/auth_view.dart';
import 'package:app4_receitas/ui/auth/auth_view_model.dart';
import 'package:app4_receitas/ui/favourite_recipes/favourite_recipes_view.dart';
import 'package:app4_receitas/ui/favourite_recipes/favourite_recipes_view_model.dart';
import 'package:app4_receitas/ui/profile/profile_view_model.dart';
import 'package:app4_receitas/ui/recipedetail/recipe_detail_view.dart';
import 'package:app4_receitas/ui/recipedetail/recipe_detail_view_model.dart';
import 'package:app4_receitas/ui/recipes/recipes_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);

  //Recipe service
  getIt.registerLazySingleton<RecipeService>(() => RecipeService());
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  
  //Repository 
  getIt.registerLazySingleton<RecipeRepository>(()=> RecipeRepository());
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());

  // get viewmodel receita de um prato
  getIt.registerLazySingleton<RecipesViewModel>(()=> RecipesViewModel());
  getIt.registerLazySingleton<RecipeDetailViewModel>(()=> RecipeDetailViewModel());
  getIt.registerLazySingleton<FavouriteRecipesViewModel>(()=> FavouriteRecipesViewModel());
  getIt.registerLazySingleton<AuthViewModel>(() => AuthViewModel());
  getIt.registerLazySingleton<ProfileViewModel>(() => ProfileViewModel());
}