import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'change_color_event.dart';
part 'change_color_state.dart';

class ChangeColorBloc extends Bloc<ChangeColorEvent, ChangeColorState> {
  ChangeColorBloc() : super(ChangeColorInitial()) {
    on<ColorChangesEvent>((event, emit) {
      emit(ColorChangesState());
    });
  }
}
