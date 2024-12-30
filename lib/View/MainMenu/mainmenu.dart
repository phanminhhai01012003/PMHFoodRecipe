import 'package:flutter/material.dart';
import 'package:pmhfoodrecipe/Model/nav_model.dart';
import 'package:pmhfoodrecipe/View/MainMenu/add_food.dart';
import 'package:pmhfoodrecipe/View/MainMenu/category_item.dart';
import 'package:pmhfoodrecipe/View/MainMenu/home_item.dart';
import 'package:pmhfoodrecipe/View/MainMenu/profile_item.dart';
import 'package:pmhfoodrecipe/View/MainMenu/save_food.dart';
import 'package:pmhfoodrecipe/Widget/nav_bar.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final homeNavKey = GlobalKey<NavigatorState>();
  final categoryNavKey = GlobalKey<NavigatorState>();
  final addFoodNavKey = GlobalKey<NavigatorState>();
  final saveNavkey = GlobalKey<NavigatorState>();
  final profileNavKey = GlobalKey<NavigatorState>();
  int selectedIndex = 0;
  List<NavModel> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = [
      NavModel(
          page: HomeItem(),
          navKey: homeNavKey
      ),
      NavModel(
          page: CategoryItem(),
          navKey: categoryNavKey
      ),
      NavModel(
          page: AddFood(),
          navKey: addFoodNavKey
      ),
      NavModel(
          page: SaveFood(),
          navKey: saveNavkey
      ),
      NavModel(
          page: ProfileItem(),
          navKey: profileNavKey
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: selectedIndex,
        children: items.map((page) => Navigator(
          key: page.navKey,
          onGenerateInitialRoutes: (navigator, initialRoute){
            return [
              MaterialPageRoute(builder: (context) => page.page)
            ];
          },
        )).toList(),
      ),
      bottomNavigationBar: NavBar(
        selectIndex: selectedIndex,
        onTap: (index){
          if (index == selectedIndex){
            items[index].navKey.currentState?.popUntil(
                (route) => route.isFirst
            );
          }else{
            setState(() {
              selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}
