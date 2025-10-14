import 'package:atl_webview/app/app.locator.dart';
import 'package:atl_webview/views/delete_user/firebase_options.dart';
import 'package:atl_webview/views/ATL_Webview/atl_webview.dart';
import 'package:atl_webview/views/delete_user/delete_user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stacked_services/stacked_services.dart';
import 'package:firebase_core/firebase_core.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          theme: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          debugShowCheckedModeBanner: false,
          // initialRoute: '/',
          // routes: {
          //   '/': (_) => const AtlWebview(),
          //   '/delete-user/': (_) => const DeleteUserView(),
          // },
          initialRoute: '/',
          onGenerateRoute: (settings) {
            final uri = Uri.parse(settings.name ?? '/');

            print('Navigating to: ${uri.path}');

            if (uri.path == '/') {
              return MaterialPageRoute(builder: (_) => const AtlWebview());
            }

            if (uri.path == '/delete-user') {
              return MaterialPageRoute(builder: (_) => const DeleteUserView());
            }

            // 404 fallback
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('403 Page Not Found')),
              ),
            );
          },
          // navigatorKey: StackedService.navigatorKey,
          // onGenerateRoute: StackedRouter().onGenerateRoute,
        );
      },
    );
  }
}
