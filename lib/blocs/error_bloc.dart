import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon_depot/event_states/event_states.dart';

class ErrorBloc extends Bloc<ErrorEvent, ErrorState> {
  ErrorBloc() : super(ErrorUninitialized());

  @override
  Stream<ErrorState> mapEventToState(ErrorEvent event) async* {
    if (event is ErrorUnauthorized) {
      yield ErrorUnauthorizedShowing();
    }

    if (event is ErrorShow) {
      yield ErrorShowing(message: event.message);
    }
  }
}
