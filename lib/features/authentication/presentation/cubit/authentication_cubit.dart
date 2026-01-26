import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nurse_servant/core/services/supabase_service.dart';
import 'package:nurse_servant/features/authentication/presentation/pages/register_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  bool googleFirstTime = true;
  Future<void> signInWithGoogle() async {
    try {
      emit(AuthenticationGoogleLoading());
  
      if (googleFirstTime) {
        final con = await SupabaseService.supabase.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: 'myapp://login-callback',
        );
        await SupabaseService.supabase.auth.onAuthStateChange.firstWhere(
          (element) => element.session != null,
        );

        emit(AuthenticationGoogleSuccess());
      }

      log(SupabaseService.supabase.auth.currentSession.toString());
      log('___________________________________________________________');
    } on Exception catch (e) {
      log(e.toString());
      emit(AuthenticationGoogleFail(message: e.toString()));
    }
  }

  String gEmail = '';
  String gPassword = '';
  bool firstReg = true;
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      emit(RegisterLoading());
      log('regester!!!!!!!!!!!!!');
      if (firstReg) {
        final AuthResponse res = await SupabaseService.supabase.auth.signUp(
          email: email,
          password: password,
          data: {'name': name},
          emailRedirectTo: 'myapp://login-callback',
        );
        gEmail = email;
        gPassword = password;
        firstReg = firstReg;

        emit(RegisterSuccess());
      }
    } on Exception catch (e) {
      emit(RegisterFail(message: e.toString()));
    }
  }

  bool firstTime = true;
  Future<void> login({required String email, required String password}) async {
    try {
      emit(LoginLoading());
      log('login!!!!!!!!!!!!!');
      if (firstTime) {
        final AuthResponse res = await SupabaseService.supabase.auth
            .signInWithPassword(email: email, password: password);
        emit(LoginSuccess());
      }
    } on Exception catch (e) {
      log(e.toString());
      emit(LoginFail(message: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      emit(LogoutLoading());
      log('func');
      firstTime = true;
      googleFirstTime = true;
      firstReg = true;
      await SupabaseService.supabase.auth.signOut();
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFail(message: e.toString()));
    }
  }

  Future<void> confirmEmailToChangePassword({required String email}) async {
    try {
      emit(PasswordResetConfirmLoading());
      log('SESSION: ${SupabaseService.supabase.auth.currentSession}');
      await SupabaseService.supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'myapp://reset-password',
      );
      emit(PasswordResetConfirmSuccess());
    } on Exception catch (e) {
      emit(PasswordResetConfirmFail(message: e.toString()));
    }
  }

  Future<void> resetPassword({required String newPassword}) async {
    try {
      emit(ResetPasswordLoading());
      log('SESSION: ${SupabaseService.supabase.auth.currentSession}');

      log(
        'xxxxxxxxxxxxxxxxxxxxxxxxxSESSION: ${SupabaseService.supabase.auth.currentSession}',
      );
      await SupabaseService.supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      emit(ResetPasswordSuccess());
    } catch (e) {
      log(e.toString());
      emit(ResetPasswordFail(message: e.toString()));
    }
  }
}
