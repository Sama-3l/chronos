part of 'fix_error_bloc.dart';

abstract class FixErrorState{
  const FixErrorState();
}

class FixErrorInitial extends FixErrorState {}

class ErrorChangeState extends FixErrorState {}