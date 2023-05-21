part of 'change_topics_bloc.dart';

abstract class ChangeTopicsEvent{
  const ChangeTopicsEvent();
}

class TopicsChangedEvent extends ChangeTopicsEvent {}