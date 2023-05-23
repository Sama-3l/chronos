part of 'date_selected_bloc.dart';

abstract class DateSelectedState {
  const DateSelectedState();
}

class DateSelectedInitial extends DateSelectedState {}

class DateChangedState extends DateSelectedState {}