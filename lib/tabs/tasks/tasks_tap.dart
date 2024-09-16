import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_list/tabs/tasks/task_item.dart';

import '../../app_theme.dart';
import '../../auth/user_provider.dart';
import '../settings/settings_provider.dart';
import 'tasks_provider.dart';

class TasksTap extends StatefulWidget {
  const TasksTap({super.key});

  @override
  State<TasksTap> createState() => _TasksTapState();
}

class _TasksTapState extends State<TasksTap> {
  bool shouldGetTasks = true;

  @override
  Widget build(BuildContext context) {
    TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    if (shouldGetTasks) {
      final userId = Provider.of<UserProvider>(context).currentUser!.id;
      tasksProvider.getTasks(userId);
      shouldGetTasks = false;
    }

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            backgroundColor: settingsProvider.isDark
                ? AppTheme.primaryDark
                : AppTheme.primaryLight,
            title: Padding(
              padding: const EdgeInsetsDirectional.only(start: 20, bottom: 49),
              child: Text(
                AppLocalizations.of(context)!.appname,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: settingsProvider.isDark ? Colors.black : Colors.white,
                ),
              ),
            ),
            toolbarHeight: MediaQuery.of(context).size.height * 0.16,
          ),
        ),
        Positioned(
          top: 111,
          left: 0,
          right: 0,
          child: EasyInfiniteDateTimeLine(
            selectionMode: const SelectionMode.autoCenter(),
            firstDate: DateTime.now().subtract(const Duration(days: 18250)),
            focusDate: tasksProvider.selectedDate,
            lastDate: DateTime.now().add(const Duration(days: 18250)),
            showTimelineHeader: false,
            onDateChange: (selectedDate) {
              tasksProvider.changeSelectedDate(selectedDate);
              final userId = Provider.of<UserProvider>(context, listen: false)
                  .currentUser!
                  .id;

              tasksProvider.getTasks(userId);
            },
            dayProps: EasyDayProps(
              todayHighlightStyle: TodayHighlightStyle.withBackground,
              todayHighlightColor:
                  settingsProvider.isDark ? Colors.white : Colors.black,
              dayStructure: DayStructure.monthDayNumDayStr,

              inactiveDayStyle: DayStyle(
                decoration: BoxDecoration(
                  color: settingsProvider.isDark ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                dayNumStyle: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: settingsProvider.isDark ? Colors.white : Colors.black,
                ),
                dayStrStyle: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: settingsProvider.isDark ? Colors.white : Colors.black,
                ),
                monthStrStyle: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: settingsProvider.isDark ? Colors.white : Colors.black,
                ),
              ),
              //
              activeDayStyle: DayStyle(
                decoration: BoxDecoration(
                  color: settingsProvider.isDark ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                dayNumStyle: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryLight,
                ),
                dayStrStyle: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryLight,
                ),
                monthStrStyle: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryLight,
                ),
              ),
            ),
            locale: settingsProvider.language,
          ),
        ),
        Positioned.fill(
          top: 180,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (_, index) =>
                      TaskItem(tasksProvider.tasks[index]),
                  itemCount: tasksProvider.tasks.length,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
