import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_flutter/components/app_bar/task_app_bar.dart';
import 'package:task_flutter/components/dialog/app_dialog.dart';
import 'package:task_flutter/models/task_model.dart';
import 'package:task_flutter/resources/app_color.dart';
import 'package:task_flutter/services/local/shared_prefs.dart';

class TaskSharedPrefs extends StatefulWidget {
  const TaskSharedPrefs({super.key, required this.title});

  final String title;

  @override
  State<TaskSharedPrefs> createState() => _TaskSharedPrefsState();
}

class _TaskSharedPrefsState extends State<TaskSharedPrefs> {
  TextEditingController searchController = TextEditingController();
  TextEditingController addController = TextEditingController();
  TextEditingController editingController = TextEditingController();
  FocusNode addFocus = FocusNode();
  List<TaskModel> tasks = [];
  List<TaskModel> searchTasks = [];
  bool showAddBox = false;
  SharedPrefs prefs = SharedPrefs();

  @override
  void initState() {
    super.initState();
    _getTasks();
  }

  void _getTasks() {
    prefs.getTasks().then((value) {
      tasks = value ?? tasksA;
      searchTasks = [...tasks];
      setState(() {});
    });
  }

  void _search(String searchText) {
    searchText = searchText.toLowerCase();
    searchTasks = tasks
        .where((e) => (e.text ?? '').toLowerCase().contains(searchText))
        .toList();
    setState(() {});
  }

  Future<void> _addTask(TaskModel task) async {
    tasks.add(task);
    searchTasks = [...tasks];
    await prefs.addTasks(tasks);
    addController.clear();
    searchController.clear();
    addFocus.unfocus();
    showAddBox = false;
    setState(() {});
  }

  Future<void> _updateTask(String id, {String? text, bool? isDone}) async {
    // for (int i = 0; i < tasks.length; i++) {
    //   if (tasks[i].id == id) {
    //     tasks[i].text = text ?? tasks[i].text;
    //     tasks[i].isDone = isDone ?? tasks[i].isDone;
    //   }
    // }

    for (var e in tasks) {
      if (e.id == id) {
        e.text = text ?? e.text;
        e.isDone = isDone ?? e.isDone;
      }
    }

    tasks.where((e) => e.id == id).forEach((e) {
      e.text = text ?? e.text;
      e.isDone = isDone ?? e.isDone;
    });

    await prefs.addTasks(tasks);
    setState(() {});
  }

  Future<void> _deleteTask(String id) async {
    tasks.removeWhere((e) => e.id == id);
    searchTasks.removeWhere((e) => e.id == id);
    await prefs.addTasks(tasks);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.bgColor,
        appBar: TaskAppBar(
          rightPressed: () => AppDialog.dialog(
            context,
            title: '😍',
            content: 'Do you want to exit app?',
            action: () =>
                SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          ),
          title: widget.title,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0)
                      .copyWith(top: 0.0, bottom: 14.0),
                  child: _searchBox(
                    controller: searchController,
                    onChanged: _search,
                  ),
                ),
                const Divider(
                  height: 1.2,
                  thickness: 1.2,
                  indent: 20.0,
                  endIndent: 20.0,
                  color: AppColor.orange,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0)
                          .copyWith(top: 16.0, bottom: 98.0),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true, // kich thuoc nho nhat cua list
                      reverse: true,
                      itemBuilder: (context, idx) {
                        final task = searchTasks[idx];
                        return _taskItem(
                          task,
                          onTap: () => _updateTask(task.id ?? '',
                              isDone: !(task.isDone ?? false)),
                          onEditing: () => AppDialog.editingDialog(
                            context,
                            title: '😍',
                            content: task.text ?? '-:-',
                            controller: editingController,
                            action: () => _updateTask(
                              task.id ?? '',
                              text: editingController.text.trim(),
                            ),
                          ),
                          onDeleted: () => AppDialog.dialog(
                            context,
                            title: '😐',
                            content: 'Do you want to delete task?',
                            action: () => _deleteTask(task.id ?? ''),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 18.0),
                      itemCount: searchTasks.length,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 20.0,
              right: 20.0,
              bottom: 18.0,
              child: Row(
                children: [
                  Expanded(
                    child: Visibility(
                      visible: showAddBox,
                      child: _addBox(controller: addController),
                    ),
                  ),
                  const SizedBox(width: 16.8),
                  _addButton(onPressed: () {
                    if (!showAddBox) {
                      showAddBox = true;
                      setState(() {});
                      addFocus.requestFocus();
                      return;
                    }

                    String text = addController.text.trim();
                    if (text.isEmpty) {
                      addFocus.unfocus();
                      showAddBox = false;
                      setState(() {});
                      return;
                    }

                    final task = TaskModel()
                      ..id = '${DateTime.now().millisecondsSinceEpoch}'
                      ..text = text
                      ..isDone = false;
                    _addTask(task);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addButton({Function()? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppColor.orange,
          border: Border.all(color: AppColor.red),
          borderRadius: BorderRadius.circular(9.6),
          boxShadow: boxShadow,
        ),
        child: const Icon(Icons.add, size: 34.0, color: AppColor.white),
      ),
    );
  }

  TextFormField _addBox({TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      focusNode: addFocus,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColor.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
        enabledBorder: inputBorderAdd,
        focusedBorder: inputBorderAdd,
        border: inputBorderAdd,
        hintText: 'Add a new task',
        hintStyle: const TextStyle(color: AppColor.grey),
      ),
    );
  }

  Widget _taskItem(
    TaskModel task, {
    Function()? onTap,
    Function()? onEditing,
    Function()? onDeleted,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0)
            .copyWith(left: 14.0, right: 9.6),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: boxShadow,
        ),
        child: Row(
          children: [
            Icon(
              task.isDone == true
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank,
              size: 18.0,
              color: AppColor.blue,
            ),
            const SizedBox(width: 6.0),
            Expanded(
              child: Text(
                task.text ?? '-:-',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  decoration: () {
                    if (task.isDone == true) {
                      return TextDecoration.lineThrough;
                    }
                    return TextDecoration.none;
                  }(),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            InkWell(
              onTap: onEditing,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(4.6),
                child: CircleAvatar(
                  radius: 12.8,
                  backgroundColor: AppColor.green.withOpacity(0.8),
                  child:
                      const Icon(Icons.edit, size: 14.6, color: AppColor.white),
                ),
              ),
            ),
            InkWell(
              onTap: onDeleted,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: const Padding(
                padding: EdgeInsets.all(4.6),
                child: CircleAvatar(
                  radius: 12.8,
                  backgroundColor: AppColor.orange,
                  child: Icon(Icons.delete, size: 14.6, color: AppColor.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _searchBox(
      {TextEditingController? controller, Function(String)? onChanged}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: boxShadow,
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColor.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          enabledBorder: inputBorderSearch,
          focusedBorder: inputBorderSearch,
          border: inputBorderSearch,
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Icon(Icons.search, color: AppColor.orange),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 36.0),
          hintText: 'Search',
          hintStyle: const TextStyle(color: AppColor.grey),
        ),
      ),
    );
  }

  final inputBorderSearch = OutlineInputBorder(
    borderSide: const BorderSide(color: AppColor.orange),
    borderRadius: BorderRadius.circular(20.0),
  );

  final inputBorderAdd = OutlineInputBorder(
    borderSide: const BorderSide(
      color: AppColor.red,
    ),
    borderRadius: BorderRadius.circular(9.6),
  );

  final boxShadow = [
    const BoxShadow(
      color: AppColor.shadow,
      offset: Offset(0.0, 3.0),
      blurRadius: 6.0,
    ),
  ];
}
