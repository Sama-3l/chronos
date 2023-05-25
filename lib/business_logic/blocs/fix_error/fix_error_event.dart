part of 'fix_error_bloc.dart';

abstract class FixErrorEvent{
  const FixErrorEvent();
}

class ErrorChangeEvent extends FixErrorEvent {}