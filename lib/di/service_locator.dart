import 'package:app4_receitas/data/services/recipe_service.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);

  //Recipe service
  getIt.registerLazySingleton<RecipeService>(() => RecipeService());
}