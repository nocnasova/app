import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:popnmark/features/auth/data/auth_repository_impl.dart';
import 'package:popnmark/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:popnmark/features/auth/presentation/screens/auth_gate.dart';
import 'package:popnmark/firebase_options.dart';
import 'package:provider/provider.dart';
import 'common/data_source/user_data_source.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/presentation/provider/auth_provider.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/auth/presentation/screens/sign_in_screen.dart';
import 'features/auth/presentation/screens/sign_up_screen.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final UserRemoteDataSource userRemoteDataSource = UserRemoteDataSourceImpl(
    firebaseFirestore: firebaseFirestore,
  );
  final AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSourceImpl(
    firebaseAuth: firebaseAuth,
    userRemoteDataSource: userRemoteDataSource,
  );
  final AuthRepository authRepository = AuthRepositoryImpl(
    authRemoteDataSource: authRemoteDataSource,
  );
  final AuthenticationProvider authProvider = AuthenticationProvider(
    authRepository: authRepository,
  );
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => authProvider)],
      child: const MyApp(),
    ),
  );
}

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        routes: _buildRoutes,
        home: SplashScreen(),
      ),
    );
  }

  Map<String, WidgetBuilder> get _buildRoutes => {
    '/signUp': (context) => SignUpScreen(),
    '/forgotPassword': (context) => ForgotPasswordScreen(),
    '/signIn': (context) => SignInScreen(),
    '/home': (context) => HomeScreen(),
  };
}
