part of 'change_color_bloc.dart';

abstract class ChangeColorEvent{
  const ChangeColorEvent();
}

class ColorChangesEvent extends ChangeColorEvent {}