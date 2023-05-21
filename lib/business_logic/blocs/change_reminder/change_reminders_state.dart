part of 'change_reminders_bloc.dart';

abstract class ChangeRemindersState{
  const ChangeRemindersState();
  
}

class ChangeRemindersInitial extends ChangeRemindersState {}

class AddRemindersState extends ChangeRemindersState {}