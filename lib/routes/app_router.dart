import 'package:flutter_assignment/features/home/screens/user_detail_screen.dart';
import 'package:flutter_assignment/features/home/screens/user_list_screen.dart';
import 'package:flutter_assignment/features/home/models/user_model.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'user_list',
        builder: (context, state) => const UserListScreen(),
      ),
      GoRoute(
        path: '/user_detail',
        name: 'user_detail',
        builder: (context, state) {
          final user = state.extra as User;
          return UserDetailScreen(user: user);
        },
      ),
    ],
  );
}
