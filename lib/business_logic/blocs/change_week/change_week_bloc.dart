import 'package:bloc/bloc.dart';
import 'package:chronos/data/model/selectedDay.dart';
import 'package:equatable/equatable.dart';

part 'change_week_event.dart';
part 'change_week_state.dart';

class ChangeWeekBloc extends Bloc<ChangeWeekEvent, ChangeWeekState> {
  ChangeWeekBloc() : super(ChangeWeekInitial(selectedDay: null)) {
    on<WeekChangeEvent>((event, emit) {
      emit(WeekChangeState(selectedDay: event.selectedDay));
    });
  }
}
