import 'dart:async';

import 'package:earnings_tracker/bootstrap.dart';
import 'package:earnings_tracker/features/tracker/presentation/bloc/earnings_bloc.dart';
import 'package:earnings_tracker/features/tracker/presentation/screens/earnings_screen.dart';
import 'package:earnings_tracker/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await dotenv.load(fileName: '.env');
  unawaited(bootstrap(() => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => sl<EarningsBloc>())],
      child: ResponsiveSizer(
        builder: (p0, p1, p2) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            home: const EarningsScreen(),
          );
        },
      ),
    );
  }
}
