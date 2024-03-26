import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/home/home_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/signup/signup_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/account/account_screen.dart'; // import your home screen

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarWidget> createState() {
    return _BottomNavigationBarWidgetState();
  }
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Trips'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box), label: 'Account'),
        ],
        onTap: _onTabTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen(); // Define your HomeScreen widget
      case 1:
        return const SignUpScreen(); // Define your TripsScreen widget
      case 2:
        return const AccountScreenWidget(); // Define your AccountScreen widget
      default:
        return Container(); // Return an empty container by default
    }
  }
}
