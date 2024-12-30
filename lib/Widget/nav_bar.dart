import 'dart:io';
import 'package:flutter/material.dart';
class NavBar extends StatelessWidget {
  final int selectIndex;
  final Function(int) onTap;
  const NavBar({
    super.key,
    required this.selectIndex,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: Platform.isAndroid ? 16 : 0
      ),
      child: BottomAppBar(
        elevation: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Container(
              height: 60,
              color: Colors.green.shade400,
              child: Row(
                children: [
                  navItem(
                      Icons.home_outlined,
                      selectIndex == 0,
                      onTap: () => onTap(0)
                  ),
                  navItem(
                      Icons.category_outlined,
                      selectIndex == 1,
                      onTap: () => onTap(1)
                  ),
                  navItem(
                    Icons.add,
                    selectIndex == 2,
                    onTap: () => onTap(2)
                  ),
                  navItem(
                      Icons.bookmark_border_outlined,
                      selectIndex == 3,
                      onTap: () => onTap(3)
                  ),
                  navItem(
                      Icons.person,
                      selectIndex == 4,
                      onTap: () => onTap(4)
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
  Widget navItem(IconData icon, bool selected, {Function()? onTap}){
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: selected ? Colors.white : Colors.white.withOpacity(0.6),
        ),
      ),
    );
  }
}
