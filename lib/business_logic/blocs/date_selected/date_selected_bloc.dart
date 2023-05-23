import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'date_selected_event.dart';
part 'date_selected_state.dart';

class DateSelectedBloc extends Bloc<DateSelectedEvent, DateSelectedState> {
  DateSelectedBloc() : super(DateSelectedInitial()) {
    on<DateChangedEvent>((event, emit) {
      emit(DateChangedState());
    });
  }
}
