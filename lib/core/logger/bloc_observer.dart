import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A simple BLoC observer that prints state changes and transitions.
///
/// Use `AIChat.enableStateLogging()` or manually assign this observer
/// to `Bloc.observer` to see state updates in the console.
class AIChatBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('[AIChat] onChange: ${bloc.runtimeType} ${change.currentState} -> ${change.nextState}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('[AIChat] onTransition: ${bloc.runtimeType} ${transition.currentState} -> ${transition.nextState}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('[AIChat] onError: ${bloc.runtimeType} $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    debugPrint('[AIChat] onCreate: ${bloc.runtimeType}');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    debugPrint('[AIChat] onClose: ${bloc.runtimeType}');
  }
}
