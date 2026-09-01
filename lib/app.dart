import 'package:flutter/material.dart';

import 'routes/app_routes.dart';

class FoodPleaseApp extends StatelessWidget {
  const FoodPleaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodPlease',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF29ABE2))
            .copyWith(primary: const Color(0xFF29ABE2)),
      ),
      initialRoute: AppRoutes.orders,
      routes: AppRoutes.routes,
    );
  }
}
