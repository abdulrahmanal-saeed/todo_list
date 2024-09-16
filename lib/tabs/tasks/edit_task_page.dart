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

// ignore: camel_case_types
class edit_task_page extends StatefulWidget {
  final TaskModel task;

  const edit_task_page({super.key, required this.task});

  @override
  // ignore: library_private_types_in_public_api
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<edit_task_page> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime selectedDate;
  DateFormat dateFormat = DateFormat('MM/dd/yyyy');
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(text: widget.task.decerption);
    selectedDate = widget.task.date;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool isDarkMode = Provider.of<SettingsProvider>(context).isDark;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: isDarkMode ? AppTheme.backgroundDark : AppTheme.backgroundLight,
        child: Form(
          key: formKey,
          child: Stack(
            children: [
              Container(
                height: screenHeight * 0.16,
                width: double.infinity,
                color: Colors.blue,
              ),
              PositionedDirectional(
                top: 50,
                start: 20,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: isDarkMode ? Colors.black : Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(
                        width: 10), // لإضافة مسافة بين الأيقونة والنص
                    Text(
                      AppLocalizations.of(context)!.appname,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: isDarkMode ? Colors.black : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    top: 100, start: 30, end: 30),
                child: Column(
                  children: [
                    Container(
                      height: screenHeight * 0.68,
                      padding: const EdgeInsetsDirectional.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(children: [
                        SizedBox(height: screenHeight * .01),
                        Text(
                          AppLocalizations.of(context)!.edittask,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(height: screenHeight * .01),
                        DefaultTextFormField(
                          controller: titleController,
                          hintText: AppLocalizations.of(context)!.taskTitle,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppLocalizations.of(context)!.notEmpty;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: screenHeight * .01),
                        DefaultTextFormField(
                          controller: descriptionController,
                          hintText: AppLocalizations.of(context)!.taskDesc,
                          maxLines: 5,
                        ),
                        SizedBox(height: screenHeight * .03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.date,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                DateTime? dateTime = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 18250)),
                                  initialDate: selectedDate,
                                  initialEntryMode:
                                      DatePickerEntryMode.calendarOnly,
                                );
                                if (dateTime != null) {
                                  setState(() {
                                    selectedDate = dateTime;
                                  });
                                }
                              },
                              child: Text(
                                dateFormat.format(selectedDate),
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * .03),
                        DefaultElevatedButton(
                          label: AppLocalizations.of(context)!.save,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              updateTask();
                            }
                          },
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateTask() {
    widget.task.title = titleController.text;
    widget.task.decerption = descriptionController.text;
    widget.task.date = selectedDate;
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;

    FirebaseFuncations.updateTaskFirestore(widget.task, userId).then((_) {
      Navigator.of(context).pop();
      Provider.of<TasksProvider>(context, listen: false).getTasks(userId);
      Fluttertoast.showToast(
        msg: "Task Updated Successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: AppTheme.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: "Something Went Wrong!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: AppTheme.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }
}
