part of 'change_week_bloc.dart';

abstract class ChangeWeekState {
  ChangeWeekState({required this.selectedDay});

  SelectedDay? selectedDay;
}

class ChangeWeekInitial extends ChangeWeekState {
  ChangeWeekInitial({required super.selectedDay});
}

class WeekChangeState extends ChangeWeekState {
  WeekChangeState({required super.selectedDay});
}
