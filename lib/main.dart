// ignore_for_file: prefer_const_constructors
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_strategy/url_strategy.dart';
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'controllers/controller.dart';
import 'controllers/theme_modifier.dart';
import 'screens/admin/home/admin_dashboard.dart';
import 'screens/admin/home/all_accounts.dart';
import 'screens/admin/home/all_complaints.dart';
import 'screens/admin/home/all_data_logs.dart';
import 'screens/admin/home/all_orders.dart';
import 'screens/admin/home/all_packages.dart';
import 'screens/admin/home/all_refunds.dart';
import 'screens/admin/signin/signin.dart';
import 'screens/error_page.dart';
import 'screens/user/home/cartalog.dart';
import 'screens/user/home/complaint.dart';
import 'screens/user/home/edit_profile.dart';
import 'screens/user/home/home_frame.dart';
import 'screens/user/home/package_details.dart';
import 'screens/user/home/refund.dart';
import 'screens/user/home/reset_password.dart';
import 'screens/user/recover_password/forgot_password.dart';
import 'screens/user/signin/signin.dart';
import 'screens/user/signup/s/signup.dart';
import 'package:provider/provider.dart';

void main() async {
  // setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  setPathUrlStrategy();
  await GetStorage.init();
  runApp(MyApp());
}

final constantValues = Get.put(Constants());
var userInfo = GetStorage();

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

class ThemeProvider with ChangeNotifier {
  ThemeMode selectedThemeMode = ThemeMode.system;

  setSelectedThemeMode(bool comparator) {
    selectedThemeMode = comparator ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}


class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => const ErrorPage(),
    routes: [
      GoRoute(
        path: "/",
        // builder: (context, state) => HomeFrame(),
        redirect: (context, state) {
          return "/home";
        },
      ),
      GoRoute(
        name: "signin",
        path: "/signin",
        builder: (context, state) => UserSignin(),
      ),
      GoRoute(
        name: "signup",
        path: "/signup",
        builder: (context, state) => UserSignup(),
      ),
      GoRoute(
        name: "forgot-password",
        path: "/forgot-password",
        builder: (context, state) => ForgotPassword(),
      ),
      GoRoute(
        name: "home",
        path: "/home",
        builder: (context, state) => HomeFrame(),
      ),
      GoRoute(
        name: "edit-profile",
        path: "/profile/edit-profile",
        builder: (context, state) => EditProfile(),
        redirect: ((context, state) {
          if (userInfo.read("userData").isEmpty) {
            return "/signin";
          }
          return "/profile/edit-profile";
        }),
      ),
      GoRoute(
        name: "complaint-history",
        path: "/profile/complaint-history",
        builder: (context, state) => Complaint(),
        redirect: ((context, state) {
          if (userInfo.read("userData").isEmpty) {
            return "/signin";
          }
          return "/profile/complaint-history";
        }),
      ),
      GoRoute(
        name: "refund-history",
        path: "/profile/refund-history",
        builder: (context, state) => Refund(),
        redirect: ((context, state) {
          if (userInfo.read("userData").isEmpty) {
            return "/signin";
          }
          return "/profile/refund-history";
        }),
      ),
      GoRoute(
        name: "reset-password",
        path: "/profile/reset-password",
        builder: (context, state) => ResetPassword(),
        redirect: ((context, state) {
          if (userInfo.read("userData").isEmpty) {
            return "/signin";
          }
          return "/profile/reset-password";
        }),
      ),
      GoRoute(
        name: "package",
        path: "/package/:name",
        builder: (context, state) => PackageDetails(
          packageCoverImage: userInfo.read("selectedPackage")["coverimage"],
          packageImages: userInfo.read("selectedPackage")["images"],
          packageName: userInfo.read("selectedPackage")["packagename"],
          description: userInfo.read("selectedPackage")["description"],
          price: userInfo.read("selectedPackage")["price"],
          discount: userInfo.read("selectedPackage")["discount"],
          rating: (userInfo.read("selectedPackage")["ratings"] as List<dynamic>)
                  .reduce((a, b) => ((a + b))) /
              (userInfo.read("selectedPackage")["ratings"] as List).length,
          reviews: userInfo.read("selectedPackage")["reviews"],
          availability: userInfo.read("selectedPackage")["available"],
        ),
      ),
      GoRoute(
        name: "cartalog",
        path: "/cartalog",
        builder: (context, state) => Cartalog(),
      ),
      GoRoute(
        name: "admin",
        path: "/admin",
        redirect: (context, state) {
          return "/admin-signin";
        },
      ),
      GoRoute(
        name: "admin-signin",
        path: "/admin-signin",
        builder: (context, state) => AdminSignin(),
      ),
      GoRoute(
        name: "dashboard",
        path: "/dashboard",
        builder: (context, state) => AdminDashboard(),
        redirect: ((context, state) {
          if (userInfo.read("adminLoggedIn") == false) {
            return "/admin-signin";
          }
          return "/dashboard";
        }),
      ),
      GoRoute(
        name: "all-packages",
        path: "/all-packages",
        builder: (context, state) => AllPackages(),
        redirect: ((context, state) {
          if (userInfo.read("adminLoggedIn") == false) {
            return "/admin-signin";
          }
          return "/all-packages";
        }),
      ),
      GoRoute(
        name: "all-accounts",
        path: "/all-accounts",
        builder: (context, state) => AllAccounts(),
        redirect: ((context, state) {
          if (userInfo.read("adminLoggedIn") == false) {
            return "/admin-signin";
          }
          return "/all-accounts";
        }),
      ),
      GoRoute(
        name: "all-orders",
        path: "/all-orders",
        builder: (context, state) => AllOrders(),
        redirect: ((context, state) {
          if (userInfo.read("adminLoggedIn") == false) {
            return "/admin-signin";
          }
          return "/all-orders";
        }),
      ),
      GoRoute(
        name: "all-refunds",
        path: "/all-refunds",
        builder: (context, state) => AllRefunds(),
        redirect: ((context, state) {
          if (userInfo.read("adminLoggedIn") == false) {
            return "/admin-signin";
          }
          return "/all-refunds";
        }),
      ),
      GoRoute(
        name: "all-complaints",
        path: "/all-complaints",
        builder: (context, state) => AllComplaints(),
        redirect: ((context, state) {
          if (userInfo.read("adminLoggedIn") == false) {
            return "/admin-signin";
          }
          return "/all-complaints";
        }),
      ),
      GoRoute(
        name: "all-data-logs",
        path: "/all-data-logs",
        builder: (context, state) => AllDataLogs(),
        redirect: ((context, state) {
          if (userInfo.read("adminLoggedIn") == false) {
            return "/admin-signin";
          }
          return "/all-data-logs";
        }),
      ),
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    userInfo.writeIfNull("isDarkTheme", false);
    final constantValues = Get.put(Constants());
    var color = constantValues.defaultColor;
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(ThemeData(
          primarySwatch: MaterialColor(0xFFFFA726, color),
          brightness: userInfo.read("isDarkTheme")
              ? Brightness.dark
              : Brightness.light)),
      child:
          MaterialAppWithTheme(router: _router, constantValues: constantValues),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  const MaterialAppWithTheme({
    super.key,
    required GoRouter router,
    required this.constantValues,
  }) : _router = router;

  final GoRouter _router;
  final Constants constantValues;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      routerConfig: _router,
      title: 'Bole by Joanes',
      theme: theme.getTheme(),
    );
  }
}
