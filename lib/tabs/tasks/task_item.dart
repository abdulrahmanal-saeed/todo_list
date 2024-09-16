import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../app_theme.dart';
import '../../auth/user_provider.dart';
import '../../firebase_funcations.dart';
import '../../models/task_model.dart';
import '../settings/settings_provider.dart';
import 'edit_task_page.dart';
import 'tasks_provider.dart';

class TaskItem extends StatefulWidget {
  const TaskItem(this.task, {super.key});
  final TaskModel task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late bool isDone;

  @override
  void initState() {
    super.initState();
    isDone = widget.task.isDone;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    bool isDarkMode = Provider.of<SettingsProvider>(context).isDark;
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 10),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                final userId = Provider.of<UserProvider>(context, listen: false)
                    .currentUser!
                    .id;

                FirebaseFuncations.deleteTaskFirestore(widget.task.id, userId)
                    .then(
                  (_) => Provider.of<TasksProvider>(context, listen: false)
                      .getTasks(userId),
                )
                    .catchError((error) {
                  Fluttertoast.showToast(
                    msg: "Something Went Wrong!",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 5,
                  );
                });
              },
              backgroundColor: AppTheme.red,
              foregroundColor: AppTheme.white,
              icon: Icons.delete,
              label: AppLocalizations.of(context)!.delete,
              borderRadius: isArabic
                  ? const BorderRadius.only(
                      bottomRight: Radius.circular(0),
                      topRight: Radius.circular(0))
                  : const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      topLeft: Radius.circular(15)),
            ),
            SlidableAction(
              onPressed: (context) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => edit_task_page(task: widget.task),
                  ),
                );
              },
              backgroundColor: AppTheme.primaryDark,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: AppLocalizations.of(context)!.edit,
              borderRadius: isArabic
                  ? const BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      topRight: Radius.circular(15))
                  : const BorderRadius.only(
                      bottomRight: Radius.circular(0),
                      topRight: Radius.circular(0)),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsetsDirectional.all(20),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF141922) : AppTheme.white,
            borderRadius: const BorderRadiusDirectional.only(
                topEnd: Radius.circular(15), bottomEnd: Radius.circular(15)),
          ),
          child: Row(
            children: [
              Container(
                color: isDone ? AppTheme.green : AppTheme.primaryLight,
                width: 4,
                height: 62,
                margin: const EdgeInsetsDirectional.only(end: 30),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    style: themeData.textTheme.titleMedium?.copyWith(
                        color:
                            isDone ? AppTheme.green : themeData.primaryColor),
                  ),
                  Text(
                    widget.task.decerption,
                    style: themeData.textTheme.titleSmall,
                  ),
                ],
              ),
              const Spacer(),
              isDone
                  ? Text(
                      AppLocalizations.of(context)!.done,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Container(
                      height: 50,
                      width: 69,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isDone ? Colors.green : AppTheme.primaryLight,
                      ),
                      child: Center(
                        child: IconButton(
                          icon: const Icon(
                            Icons.check,
                            color: AppTheme.white,
                            size: 32,
                          ),
                          onPressed: () {
                            final userId = Provider.of<UserProvider>(context,
                                    listen: false)
                                .currentUser!
                                .id;

                            setState(() {
                              isDone = true;
                            });

                            // تحديث حالة المهمة في Firestore
                            FirebaseFuncations.updateTaskStatus(
                                widget.task.id, userId, true);
                          },
                          color: AppTheme.primaryLight,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
