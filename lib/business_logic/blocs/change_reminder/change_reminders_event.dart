part of 'change_reminders_bloc.dart';

abstract class ChangeRemindersEvent{
  const ChangeRemindersEvent();
}

class AddRemindersEvent extends ChangeRemindersEvent{}