import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_client_screen.dart';
import 'screens/home_merchant_screen.dart';
import 'screens/account_screen.dart';
import 'screens/account_settings_screen.dart';
import 'screens/search_screen.dart';

class Routes {
  static const login = '/login';
  static const register = '/register';
  static const homeClient = '/home-client';
  static const homeMerchant = '/home-merchant';
  static const account = '/account';
  static const accountSettings = '/account-settings';
  static const search = '/search';

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case homeClient:
        return MaterialPageRoute(builder: (_) => const HomeClientScreen());
      case homeMerchant:
        return MaterialPageRoute(builder: (_) => const HomeMerchantScreen());
      case account:
        return MaterialPageRoute(builder: (_) => const AccountScreen());
      case accountSettings:
        return MaterialPageRoute(builder: (_) => const AccountSettingsScreen());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
