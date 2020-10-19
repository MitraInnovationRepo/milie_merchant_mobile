import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class TabNotifier extends ChangeNotifier{
  PersistentTabController tabController;
  int currentOrderTab = 0;

  TabNotifier.empty();

  setOrderTab(int tab){
    this.currentOrderTab = tab;
    notifyListeners();
  }

  setTabController(PersistentTabController tabController){
    this.tabController = tabController;
  }
}