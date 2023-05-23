part of 'date_selected_bloc.dart';

abstract class DateSelectedEvent{
  const DateSelectedEvent();
}

class DateChangedEvent extends DateSelectedEvent {}