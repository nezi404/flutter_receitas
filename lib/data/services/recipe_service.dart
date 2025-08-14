import 'package:app4_receitas/di/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeService {
  final SupabaseClient _supabaseClient = getIt<SupabaseClient>();

  Future<List<Map<String, dynamic>>> fetchRecipes() async {
    return await _supabaseClient
    .from('recipes')
    .select()
    .order('id', ascending: true);
  }

  Future<Map<String, dynamic>?> fetchRecipesById(String id) async {
    return await _supabaseClient.from('recipes').select().eq('id', id).single();
  }

  Future<List<Map<String, dynamic>>> fetchFavouriteRecipesById( String userId) async {
    return await _supabaseClient
    .from('favorites')
    .select('''
  recipes(
      id, 
      name,
      ingredient,
      intructions,
      prep_time_minutes,
      cook_time_minutes,
      servings,
      difficulty,
      cuisine,
      calories_per_serving,
      tags,
      user_id,
      image,
      rating,
      review_count,
      meal_type
      
  )'''
  );
  }
}