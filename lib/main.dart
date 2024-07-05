import 'package:auth_api/features/auth/domain/repo/get_data_repo.dart';
import 'package:auth_api/features/auth/domain/repo/login_repo.dart';
import 'package:auth_api/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:auth_api/features/auth/presentation/screens/login_screen.dart';
import 'package:auth_api/features/auth/presentation/screens/permission_check_screen.dart';
import 'package:auth_api/features/auth/presentation/screens/reg_screen.dart';
import 'package:auth_api/features/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/domain/repo/delete_repo.dart';
import 'features/auth/domain/repo/log_out_repo.dart';
import 'features/auth/domain/repo/reg_repo.dart';
import 'features/auth/domain/repo/update_repo.dart';
import 'features/auth/presentation/screens/update_screen.dart';
import 'features/auth/presentation/screens/delete_screen.dart';
import 'features/auth/presentation/screens/get_user_data_screen.dart';

void main() async {
  runApp(const AuthApp());
}

class AuthApp extends StatelessWidget {
  const AuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AuthenticationBloc(LoginRepo(), RegisterRepo(),
                UpdateRepo(), DeleteRepo(), LogoutRepo(), GetUserRepo())),
      ],
      child: MaterialApp(
        initialRoute: PermissionCheckScreen.routeName,
        debugShowCheckedModeBanner: false,
        routes: {
          PermissionCheckScreen.routeName: (context) => PermissionCheckScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
          RegistrationScreen.routeName: (context) => const RegistrationScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          UpdateUserScreen.routeName: (context) => const UpdateUserScreen(),
          DeleteUserScreen.routeName: (context) => DeleteUserScreen(),
          GetUserDataScreen.routeName: (context) => GetUserDataScreen(),
          // Add other routes here
        },
      ),
    );
  }
}
