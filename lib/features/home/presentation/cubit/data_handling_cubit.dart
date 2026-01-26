import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nurse_servant/core/services/supabase_service.dart';
import 'package:nurse_servant/features/home/data/models/medicine_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'data_handling_state.dart';

class DataHandlingCubit extends Cubit<DataHandlingState> {
  DataHandlingCubit() : super(DataHandlingInitial());

  Future<void> creatNewUserOrFetch(String email) async {
    try {
      emit(CreatingNewUserLoading());
      final data = await SupabaseService.supabase
          .from('userData')
          .select('id')
          .eq('email', email);

      if (data.isEmpty) {
        await SupabaseService.supabase.from('userData').insert({
          'email': email,
          'name': SupabaseService
              .supabase
              .auth
              .currentUser!
              .userMetadata!['full_name'],
          'medicines': [],
        });
      }
      final userDate = await SupabaseService.supabase
          .from('userData')
          .select('email, name, medicines')
          .eq('email', email);
      log(userDate.toString());
      emit(CreatingNewUserSuccess(jsons: userDate.first['medicines']));
    } on Exception catch (e) {
      emit(CreatingNewUserError(message: e.toString()));
    }
  }

  Future<void> syncAccount(List<dynamic> medicinesList) async {
    try {
      log('update');
      emit(SyncUserLoading());
      List<Map<String, dynamic>> supaList = List.generate(
        medicinesList.length,
        (index) => MedicineModel.toJson(medicinesList[index]),
      );
      await SupabaseService.supabase
          .from('userData')
          .update({'medicines': supaList})
          .eq('email', SupabaseService.supabase.auth.currentUser!.email!);
      emit(SyncUserSuccess());
    } on Exception catch (e) {
      emit(SyncUserError(message: e.toString()));
    }
  }
}
