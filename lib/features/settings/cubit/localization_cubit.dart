import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'localization_state.dart';

class LocalizationCubit extends HydratedCubit<Locale> {
  LocalizationCubit() : super(Locale('en'));

  void toggleLanguage() {
    emit(state.languageCode == 'en' ? Locale('ar') : Locale('en'));
  }

  @override
  Locale? fromJson(Map<String, dynamic> json) {
    return Locale(json['languageCode']);
  }

  @override
  Map<String, dynamic>? toJson(Locale state) {
    return {'languageCode':state.languageCode};
  }
}
