import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'change_reminders_event.dart';
part 'change_reminders_state.dart';

class ChangeRemindersBloc
    extends Bloc<ChangeRemindersEvent, ChangeRemindersState> {
  ChangeRemindersBloc() : super(ChangeRemindersInitial()) {
    on<AddRemindersEvent>((event, emit) {
      emit(AddRemindersState());
    });
  }
}
