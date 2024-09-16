import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_list/app_theme.dart';
import 'package:todo_list/auth/user_provider.dart';
import 'package:todo_list/tabs/settings/settings_provider.dart';
import 'package:todo_list/tabs/settings/settings_tab.dart';
import 'package:todo_list/tabs/tasks/add_task_bottom_sheet.dart';
import 'package:todo_list/tabs/tasks/tasks_provider.dart';
import 'package:todo_list/tabs/tasks/tasks_tap.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTabIndex = 0;
  List<Widget> tabs = [const TasksTap(), const SettingsTab()];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = Provider.of<UserProvider>(context).currentUser!.id;
      Provider.of<TasksProvider>(context, listen: false).getTasks(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              Provider.of<SettingsProvider>(context).backgroundImagePath),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        body: tabs[currentTabIndex],
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          padding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: AppTheme.white,
          child: BottomNavigationBar(
            currentIndex: currentTabIndex,
            onTap: (index) {
              setState(() {
                currentTabIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                label: AppLocalizations.of(context)!.tasks,
                icon: const Icon(
                  Icons.list,
                  size: 32,
                ),
              ),
              BottomNavigationBarItem(
                label: AppLocalizations.of(context)!.settings,
                icon: const Icon(Icons.settings_outlined, size: 32),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const AddTaskBottomSheet()),
          child: const Icon(Icons.add, size: 32),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
