import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../app_theme.dart';
import '../../auth/user_provider.dart';
import '../../firebase_funcations.dart';
import '../../models/task_model.dart';
import '../settings/settings_provider.dart';
import 'default_elevated_button.dart';
import 'default_text_form_field.dart';
import 'tasks_provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateFormat dateFormat = DateFormat('MM/dd/yyyy');
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool isDarkMode = Provider.of<SettingsProvider>(context).isDark;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsetsDirectional.all(20),
        height: MediaQuery.of(context).size.height * 0.55,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.addNewTask,
                style: textTheme.titleMedium?.copyWith(
                  color: isDarkMode ? Colors.black : Colors.black,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              DefaultTextFormField(
                  controller: titleController,
                  hintText: AppLocalizations.of(context)!.taskTitle,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.notEmpty;
                    }
                    return null;
                  }),
              const SizedBox(
                height: 3,
              ),
              DefaultTextFormField(
                controller: descriptionController,
                hintText: AppLocalizations.of(context)!.taskDesc,
                maxLines: 5,
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    AppLocalizations.of(context)!.date,
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w400),
                  ),
                  InkWell(
                    onTap: () async {
                      DateTime? dateTime = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 18250)),
                        initialDate: selectedDate,
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                      );
                      if (dateTime != null) {
                        selectedDate = dateTime;
                        setState(() {});
                      }
                    },
                    child: Text(dateFormat.format(selectedDate)),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              DefaultElevatedButton(
                  label: AppLocalizations.of(context)!.submit,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      addTask();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  void addTask() {
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;
    FirebaseFuncations.addTaskFirestore(
      TaskModel(
        title: titleController.text,
        decerption: descriptionController.text,
        date: selectedDate,
      ),
      userId,
    ).then(
      (_) {
        Navigator.of(context).pop();
        Provider.of<TasksProvider>(context, listen: false).getTasks(userId);
        Fluttertoast.showToast(
            msg: "Task Added Successfuly",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: AppTheme.green,
            textColor: Colors.white,
            fontSize: 16.0);
      },
    ).catchError((error) {
      Fluttertoast.showToast(
          msg: "Something Went Wrong!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }
}
