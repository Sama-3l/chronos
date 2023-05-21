import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'toggle_buttons_event.dart';
part 'toggle_buttons_state.dart';

class ToggleButtonsBloc extends Bloc<ToggleButtonsEvent, ToggleButtonsState> {
  ToggleButtonsBloc() : super(ToggleButtonsInitial()) {
    on<ButtonToggleEvent>((event, emit) {
      emit(ButtonToggleState());
    });
  }
}
