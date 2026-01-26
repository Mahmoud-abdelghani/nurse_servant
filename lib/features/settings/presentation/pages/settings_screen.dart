import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_servant/core/services/supabase_service.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';
import 'package:nurse_servant/features/home/data/models/medicine_model.dart';
import 'package:nurse_servant/features/home/presentation/cubit/data_handling_cubit.dart';
import 'package:nurse_servant/features/settings/cubit/localization_cubit.dart';
import 'package:nurse_servant/features/settings/cubit/theme_cubit.dart';
import 'package:nurse_servant/features/settings/presentation/widgets/custom_settings_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  static const String routeName = 'SettingsScreen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> medicines =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenSize.width * 0.018),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: ScreenSize.height * 0.1),
            Container(
              height: ScreenSize.height * 0.27,
              width: ScreenSize.width * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Copilot_20260116_024655.png'),
                ),
              ),
            ),
            SizedBox(height: ScreenSize.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  Localizations.localeOf(context).languageCode == 'ar'
                      ? 'أهلا'
                      : 'Welcome,',
                  style: TextStyle(
                    fontSize: ScreenSize.height * 0.03,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
            Text(
              SupabaseService.supabase.auth.currentUser!.userMetadata!['name'],
              style: TextStyle(
                fontSize: ScreenSize.height * 0.03,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).hintColor,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  CustomSettingsWidget(
                    iconDataLeading: Icons.color_lens_outlined,
                    title: Localizations.localeOf(context).languageCode == 'ar'
                        ? 'الوضع'
                        : 'Theme',
                    subtitle:
                        Localizations.localeOf(context).languageCode == 'ar'
                        ? 'اختر الوضع المفضل لديك'
                        : 'Select your favourite Theme',
                    widgetTrailing: IconButton(
                      onPressed: () {
                        BlocProvider.of<ThemeCubit>(context).toggleTheme();
                      },
                      icon: Icon(
                        context.watch<ThemeCubit>().state == ThemeMode.light
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined,
                        size: ScreenSize.height * 0.045,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Divider(),
                  CustomSettingsWidget(
                    iconDataLeading: Icons.language_outlined,
                    title: Localizations.localeOf(context).languageCode == 'ar'
                        ? 'اللغة'
                        : 'Language',
                    subtitle:
                        Localizations.localeOf(context).languageCode == 'ar'
                        ? 'يمكنك اختيار اللغة'
                        : 'You can select language',
                    widgetTrailing: TextButton(
                      onPressed: () {
                        BlocProvider.of<LocalizationCubit>(
                          context,
                        ).toggleLanguage();
                      },
                      child: Text(
                        context.watch<LocalizationCubit>().state.languageCode ==
                                'ar'
                            ? 'English'
                            : 'العربية',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: ScreenSize.height * 0.022,
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.maybePop(context);
                      await BlocProvider.of<DataHandlingCubit>(
                        context,
                      ).syncAccount(medicines);
                    },
                    child: CustomSettingsWidget(
                      iconDataLeading: Icons.logout,
                      title:
                          Localizations.localeOf(context).languageCode == 'ar'
                          ? 'تسجيل الخرج'
                          : 'Log Out',
                      subtitle:
                          Localizations.localeOf(context).languageCode == 'ar'
                          ? 'تسجيل الخروج من هذا الحساب'
                          : 'Log out from this account',
                      widgetTrailing: null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
