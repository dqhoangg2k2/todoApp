import 'package:flutter/material.dart';
import 'package:task_flutter/resources/app_color.dart';

class AppDialog {
  AppDialog._();

  static void dialog(
    BuildContext context, {
    required String title,
    required String content,
    Function()? action,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Row(
          children: [
            Expanded(
              child: Text(
                content,
                style: const TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              action?.call();
              Navigator.pop(context, true);
            },
            child: const Text('Yes', style: TextStyle(fontSize: 16.0)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No', style: TextStyle(fontSize: 16.0)),
          ),
        ],
      ),
    );
  }

  static void editingDialog(
    BuildContext context, {
    required String title,
    required String content,
    TextEditingController? controller,
    Function()? action,
  }) {
    controller?.text = content;
    FocusNode editingNode = FocusNode();
    editingNode.requestFocus();
    bool textEmpty = false;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(title),
              content: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      focusNode: editingNode,
                      onChanged: (val) =>
                          setState(() => textEmpty = val.isEmpty),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: textEmpty
                      ? null
                      : () {
                          action?.call();
                          Navigator.pop(context);
                        },
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: textEmpty ? AppColor.grey : null,
                        fontSize: 16.0),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(fontSize: 16.0)),
                ),
              ],
            );
          });
        });
  }
}
