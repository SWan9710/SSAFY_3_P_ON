import 'package:p_on/screen/notification/vo/vo_notification.dart';
import 'package:p_on/screen/notification/w_notification_item.dart';
import 'package:flutter/material.dart';
import 'package:nav/dialog/dialog.dart';
import 'package:nav/enum/enum_nav_ani.dart';

class NotificationDialog extends DialogWidget {
  final List<MyNotification> notifications;

  NotificationDialog(this.notifications,
      {super.key,
      super.animation = NavAni.Fade,
      super.barrierDismissible = true});

  @override
  DialogState<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends DialogState<NotificationDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...widget.notifications
              .map((element) => NotificationItemWidget(
                  onTap: () {
                    widget.hide();
                  },
                  notification: element))
              .toList()
        ],
      ),
    );
  }
}
