part of 'change_week_bloc.dart';

abstract class ChangeWeekEvent{
  ChangeWeekEvent({required this.selectedDay});

  SelectedDay? selectedDay;
}

class WeekChangeEvent extends ChangeWeekEvent {
  WeekChangeEvent({required super.selectedDay});
}