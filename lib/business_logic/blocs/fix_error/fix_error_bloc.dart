import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'fix_error_event.dart';
part 'fix_error_state.dart';

class FixErrorBloc extends Bloc<FixErrorEvent, FixErrorState> {
  FixErrorBloc() : super(FixErrorInitial()) {
    on<ErrorChangeEvent>((event, emit) {
      emit(ErrorChangeState());
    });
  }
}
