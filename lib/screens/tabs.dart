import 'package:flutter/material.dart';

import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/meals.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeal = [];
  final List<Meal> _notInterested = [];

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

  @override
  Widget build(BuildContext context) {
    Widget activePage = CategoriesScreen(
      onToggelFavorite: _toggelMealFavoritesStatus,
      onToggelNotInterested: _toggelMealNotInterestedStatus,
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
