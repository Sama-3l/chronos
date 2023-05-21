part of 'change_topics_bloc.dart';

abstract class ChangeTopicsState{
  const ChangeTopicsState();
}

class ChangeTopicsInitial extends ChangeTopicsState {}

class TopicsChangedState extends ChangeTopicsState {}