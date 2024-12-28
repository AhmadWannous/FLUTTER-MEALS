import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals/models/meal.dart';

class NotFavoritesProviderNotifire extends StateNotifier<List<Meal>> {
  NotFavoritesProviderNotifire() : super([]);

  toggleMealNotFavoriteStatus(Meal meal) {
    final mealIsNotFavorite = state.contains(meal);

    if (mealIsNotFavorite) {
      state = state.where((mn) => mn.id != meal.id).toList();
    } else {
      state = [...state, meal];
    }
  }
}

final notFavoriteMealsProvider =
    StateNotifierProvider<NotFavoritesProviderNotifire, List<Meal>>((ref) {
  return NotFavoritesProviderNotifire();
});
