import 'package:flutter/material.dart';
import 'package:student_task_tracker/screen/calebndra.dart';
import 'package:student_task_tracker/screen/home_screen.dart';
import 'package:student_task_tracker/screen/taskscheduleScreen.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> pages = [HomeScreen(), Taskschedulescreen(), Calebndra()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(
              context,
            ).colorScheme.onSurface.withOpacity(0.6),
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color:
                        _selectedIndex == 0
                            ? Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.2)
                            : Colors.transparent,
                  ),
                  child: Icon(
                    _selectedIndex == 0
                        ? Icons.home_filled
                        : Icons.home_outlined,
                    size: 24,
                  ),
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color:
                        _selectedIndex == 1
                            ? Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.2)
                            : Colors.transparent,
                  ),
                  child: Icon(
                    _selectedIndex == 1
                        ? Icons.schedule
                        : Icons.schedule_outlined,
                    size: 24,
                  ),
                ),
                label: "Schedule",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color:
                        _selectedIndex == 2
                            ? Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.2)
                            : Colors.transparent,
                  ),
                  child: Icon(
                    _selectedIndex == 2
                        ? Icons.calendar_month
                        : Icons.calendar_month_outlined,
                    size: 24,
                  ),
                ),
                label: "Calendra",
              ),
            ],
          ),
        ),
      ),
      body: pages[_selectedIndex],
    );
  }
}
