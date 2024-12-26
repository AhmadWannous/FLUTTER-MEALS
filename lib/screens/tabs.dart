import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';

import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeal = [];
  final List<Meal> _notInterested = [];
  Map<Filter, bool> _selectedFilters = kInitialFilters;

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggelMealFavoritesStatus(Meal meal) {
    final isExisting = _favoriteMeal.contains(meal);

    if (isExisting) {
      setState(() {
        _favoriteMeal.remove(meal);
      });
      _showInfoMessage('Meal is no longer a favorite.');
    } else {
      setState(() {
        _favoriteMeal.add(meal);
      });
      _showInfoMessage('Marked as a favorite.');
    }
  }

  void _toggelMealNotInterestedStatus(Meal meal) {
    final isNotInterest = _notInterested.contains(meal);
    if (isNotInterest) {
      setState(() {
        _notInterested.remove(meal);
      });
      _showInfoMessage('Meal is no longer a not interested.');
    } else {
      setState(() {
        _notInterested.add(meal);
      });
      _showInfoMessage('Marked as a not interested.');
    }
  }

  void _selectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentFilter: _selectedFilters,
          ),
        ),
      );
      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
    Widget activePage = CategoriesScreen(
      onToggelFavorite: _toggelMealFavoritesStatus,
      onToggelNotInterested: _toggelMealNotInterestedStatus,
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeal,
        onToggelFavorite: _toggelMealFavoritesStatus,
        onToggelNotInterested: _toggelMealNotInterestedStatus,
      );
      activePageTitle = 'Your Favorites';
    }

    if (_selectedPageIndex == 2) {
      activePage = MealsScreen(
        meals: _notInterested,
        onToggelFavorite: _toggelMealFavoritesStatus,
        onToggelNotInterested: _toggelMealNotInterestedStatus,
      );
      activePageTitle = 'Not Interested';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectedPage,
        currentIndex: _selectedPageIndex, //Which tap will be highlighted
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.not_interested_sharp),
            label: 'Not Interested',
          ),
        ],
      ),
    );
  }
}
