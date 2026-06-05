import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    log(
      '🟢 CREATE ${bloc.runtimeType}',
      name: 'BLOC',
    );
    super.onCreate(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    log(
      '📨 EVENT ${bloc.runtimeType} -> $event',
      name: 'BLOC',
    );
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    log(
      '🔄 CHANGE ${bloc.runtimeType}\n'
      'CURRENT: ${change.currentState}\n'
      'NEXT   : ${change.nextState}',
      name: 'BLOC',
    );
    super.onChange(bloc, change);
  }

  @override
  void onTransition(
    Bloc bloc,
    Transition transition,
  ) {
    log(
      '🚀 TRANSITION ${bloc.runtimeType}\n'
      'EVENT: ${transition.event}\n'
      'CURRENT: ${transition.currentState}\n'
      'NEXT: ${transition.nextState}',
      name: 'BLOC',
    );

    super.onTransition(bloc, transition);
  }

  @override
  void onError(
    BlocBase bloc,
    Object error,
    StackTrace stackTrace,
  ) {
    log(
      '🔴 ERROR ${bloc.runtimeType}\n$error',
      name: 'BLOC',
      error: error,
      stackTrace: stackTrace,
    );

    super.onError(
      bloc,
      error,
      stackTrace,
    );
  }

  @override
  void onClose(BlocBase bloc) {
    log(
      '⚫ CLOSE ${bloc.runtimeType}',
      name: 'BLOC',
    );

    super.onClose(bloc);
  }
}