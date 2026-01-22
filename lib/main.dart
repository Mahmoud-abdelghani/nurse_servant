import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nurse_servant/core/services/hive_service.dart';
import 'package:nurse_servant/core/services/local_notification_service.dart';
import 'package:nurse_servant/core/services/supabase_service.dart';
import 'package:nurse_servant/core/services/work_manager_service.dart';
import 'package:nurse_servant/core/utils/themes.dart';
import 'package:nurse_servant/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:nurse_servant/features/authentication/presentation/pages/forgot_password_view.dart';
import 'package:nurse_servant/features/authentication/presentation/pages/login_view.dart';
import 'package:nurse_servant/features/authentication/presentation/pages/otp_view.dart';
import 'package:nurse_servant/features/authentication/presentation/pages/register_view.dart';
import 'package:nurse_servant/features/authentication/presentation/pages/reset_password_view.dart';
import 'package:nurse_servant/features/authentication/presentation/pages/welcome_view.dart';
import 'package:nurse_servant/features/home/data/models/medicine_model_type_adapter.dart';
import 'package:nurse_servant/features/home/presentation/cubit/data_handling_cubit.dart';
import 'package:nurse_servant/features/home/presentation/cubit/load_from_hive_cubit.dart';
import 'package:nurse_servant/features/home/presentation/pages/add_med_view.dart';
import 'package:nurse_servant/features/home/presentation/pages/home_view.dart';
import 'package:nurse_servant/features/home/presentation/pages/medicine_details.dart';
import 'package:nurse_servant/features/settings/cubit/localization_cubit.dart';
import 'package:nurse_servant/features/settings/cubit/theme_cubit.dart';
import 'package:nurse_servant/features/settings/presentation/pages/settings_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getNotificationsPermission();
  await LocalNotificationService.localNotificationsInit();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(MedicineModelTypeAdapter());
  }
  // Hive.registerAdapter(MedicineModelTypeAdapter());
  await HiveService.hiveBoxInitialization();

  await Supabase.initialize(
    url: 'https://fbyivtfptfocmhpkiwis.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZieWl2dGZwdGZvY21ocGtpd2lzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU2NTM4NTgsImV4cCI6MjA4MTIyOTg1OH0.tqgxvZJluSrCMYHeyDXTWBukUUL9EN_sCBY668byDmk',
    authOptions: FlutterAuthClientOptions(authFlowType: AuthFlowType.pkce),
    realtimeClientOptions: const RealtimeClientOptions(
      logLevel: RealtimeLogLevel.info,
    ),
    storageOptions: const StorageClientOptions(retryAttempts: 10),
  );
  await WorkManagerService.workManagerInitialzation();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );
  runApp(MyApp());
}

Future<void> getNotificationsPermission() async {
  final status = await Permission.notification.status;
  if (status == PermissionStatus.denied ||
      status == PermissionStatus.limited ||
      status == PermissionStatus.permanentlyDenied) {
    final request = await Permission.notification.request();
    if (request == PermissionStatus.denied ||
        request == PermissionStatus.limited ||
        request == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => LocalizationCubit()),
        BlocProvider(create: (context) => AuthenticationCubit()),
        BlocProvider(
          create: (context) => LoadFromHiveCubit()..getDataFromHive(),
        ),
        BlocProvider(create: (context) => DataHandlingCubit()),
      ],
      child: AppRoot(),
    );
  }
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: context.watch<LocalizationCubit>().state,
      supportedLocales: [Locale('ar'), Locale('en')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: context.watch<ThemeCubit>().state,
      routes: {
        LoginView.routeName: (context) => LoginView(),
        WelcomeView.routeName: (context) => WelcomeView(),
        RegisterView.routeName: (context) => RegisterView(),
        ForgotPasswordView.routeName: (context) => ForgotPasswordView(),
        ResetPasswordView.routeName: (context) => ResetPasswordView(),
        OtpView.routeName: (context) => OtpView(),
        HomeView.routeName: (context) => HomeView(),
        AddMedView.routeName: (context) => AddMedView(),
        MedicineDetails.routeName: (context) => MedicineDetails(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
      },
      initialRoute: SupabaseService.supabase.auth.currentSession != null
          ? HomeView.routeName
          : WelcomeView.routeName,
    );
  }
}

//height  = 932  || 914.2857142857143 width = 430 || 411.42857142857144
//password data base 01211410889Md#
