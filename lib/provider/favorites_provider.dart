import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals/models/meal.dart';

class FavoritesProviderNotifire extends StateNotifier<List<Meal>> {
  FavoritesProviderNotifire() : super([]);

  bool toggleMealFavoriteStatus(Meal meal) {
    final mealIsFavorite = state.contains(meal);

    if (mealIsFavorite) {
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

final favoriteMealsProvider =
    StateNotifierProvider<FavoritesProviderNotifire, List<Meal>>((ref) {
  return FavoritesProviderNotifire();
});
