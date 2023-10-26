import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:task_flutter/resources/app_color.dart';

class TaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  TaskAppBar({
    super.key,
    this.rightPressed,
    Icon? icon,
    required this.title,
    this.color = AppColor.bgColor,
  }) : icon = icon ??
            Icon(
              Icons.logout,
              size: 22.0,
              color: AppColor.brown.withOpacity(0.98),
            );

  final Function()? rightPressed;
  final Icon icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(
          top: MediaQuery.of(context).padding.top + 6.0, bottom: 10.6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4.6, bottom: 4.6),
                child: Container(
                  padding: const EdgeInsets.all(1.0),
                  decoration: const BoxDecoration(
                      color: AppColor.red, shape: BoxShape.circle),
                  child: const CircleAvatar(
                    radius: 24.0,
                    backgroundImage: AssetImage('assets/images/nhu_anh.png'),
                  ),
                ),
              ),
              const Positioned(
                right: 0.0,
                bottom: 0.0,
                child: Icon(Icons.favorite, color: AppColor.red),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              title,
              style: const TextStyle(color: AppColor.blue, fontSize: 20.0),
            ),
          ),
          GestureDetector(
            onTap: rightPressed,
            child: Transform.rotate(
              angle: 45 * math.pi / 180,
              child: Container(
                padding: const EdgeInsets.all(6.8),
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColor.shadow,
                      offset: Offset(2.0, 2.0),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: Transform.rotate(
                  angle: -45 * math.pi / 180,
                  child: icon,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(86.0);
}
