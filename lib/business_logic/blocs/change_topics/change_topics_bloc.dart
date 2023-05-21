import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'change_topics_event.dart';
part 'change_topics_state.dart';

class ChangeTopicsBloc extends Bloc<ChangeTopicsEvent, ChangeTopicsState> {
  ChangeTopicsBloc() : super(ChangeTopicsInitial()) {
    on<TopicsChangedEvent>((event, emit) {
      emit(TopicsChangedState());
    });
  }
}
