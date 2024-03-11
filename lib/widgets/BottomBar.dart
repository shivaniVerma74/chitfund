import 'package:chitfund/screen/AuctionResult.dart';
import 'package:chitfund/screen/HomeScreen.dart';
import 'package:chitfund/screen/UpcomingAuctions.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/images_url.dart';



class BottomBar extends StatefulWidget {

  BottomBar({ Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;


  void onItemTapped(int index) {
    setState(() {
      print('pressed $_selectedIndex index');
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: [
         HomeScreen(),
          UpcomingAuctions(fromDashboard: true,),
          AuctionResult(fromDashboard: true,)
        ].elementAt(_selectedIndex),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 15.0, // soften the shadow
                spreadRadius: 5.0, //extend the shadow
                offset: Offset(
                  5.0, // Move to right 5  horizontally
                  5.0, // Move to bottom 5 Vertically
                ),
              )
            ]
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 10,
          elevation: 0,
          unselectedFontSize: 10,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Dashboard',
              icon: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.home)
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(Icons.home, color: MyColors.primaryColor,)
                ),
              ),
              backgroundColor:MyColors.whiteColor,
            ),
            BottomNavigationBarItem(
              label: 'Upcoming Auction',
              icon: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.local_fire_department)
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.local_fire_department, color: MyColors.primaryColor,)
              ),
              backgroundColor:MyColors.whiteColor,
            ),


            BottomNavigationBarItem(
              label: 'Auction Result',
              icon: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.book, )
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.all(5.0),
                child:Icon(Icons.book, color: MyColors.primaryColor,)
              ),
              backgroundColor:MyColors.whiteColor,
            ),


          ],
          currentIndex: _selectedIndex,
          selectedItemColor:  MyColors.primaryColor,
          onTap: onItemTapped,
        ),
      ),
    );

  }
}