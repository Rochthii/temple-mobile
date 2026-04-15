import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../shared/widgets/temple_context_badge.dart';
import '../../shared/widgets/glass_navigation_bar.dart';
import '../theme/colors.dart';
import '../../features/temple_context/presentation/temple_picker_modal.dart';
import '../../features/temple_context/domain/temple_context_provider.dart';
import '../../features/temple_context/domain/temple_context_state.dart';
import '../../features/auth/domain/auth_provider.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/profile_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/discovery/presentation/discovery_screen.dart';
import '../../features/dharma_audio/presentation/dharma_audio_screen.dart';
import '../../features/ai_bot/presentation/ai_chat_screen.dart';
import '../../features/discovery/presentation/temple_detail_screen.dart';
import '../../features/discovery/domain/models/discovery_temple.dart';
import '../../features/home/presentation/news_detail_screen.dart';
import '../../features/home/domain/models/news_model.dart';
import '../../features/merit/presentation/merit_screen.dart';
import '../../features/merit/presentation/merit_ledger_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

// Notifier dùng để trigger GoRouter.redirect khi auth thay đổi
class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  _RouterNotifier(this._ref) {
    // Lắng nghe authProvider, khi thay đổi → báo cho GoRouter refresh redirect
    _ref.listen<AsyncValue<User?>>(authProvider, (_, _) {
      notifyListeners();
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  // GoRouter tạo 1 LẦN DUY NHẤT, dùng refreshListenable để trigger redirect
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    refreshListenable: notifier,
    redirect: (context, state) {
      // Đọc auth state TẠI THỜI ĐIỂM redirect được gọi
      final authState = ref.read(authProvider);

      if (authState.isLoading) return '/splash';

      final bool loggedIn = authState.value != null;
      final String location = state.uri.toString();
      final bool isPublicRoute = location == '/login' ||
          location == '/register' ||
          location == '/splash';

      if (!loggedIn) {
        // Chưa đăng nhập → chỉ cho vào các trang public
        return isPublicRoute ? null : '/login';
      }

      // Đã đăng nhập → không cho vào login/register nữa
      if (location == '/login' || location == '/splash') {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashLoader(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/temple/:id',
        builder: (context, state) {
          final temple = state.extra as DiscoveryTemple;
          return TempleDetailScreen(temple: temple);
        },
      ),
      GoRoute(
        path: '/news/:id',
        builder: (context, state) {
          final news = state.extra as NewsModel;
          return NewsDetailScreen(news: news);
        },
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/discovery',
            builder: (context, state) => const DiscoveryScreen(),
          ),
          GoRoute(
            path: '/ai-bot',
            builder: (context, state) => const AiChatScreen(),
          ),
          GoRoute(
            path: '/dharma',
            builder: (context, state) => const DharmaAudioScreen(),
          ),
          GoRoute(
            path: '/merit',
            builder: (context, state) => const MeritScreen(),
          ),
          GoRoute(
            path: '/merit-ledger',
            builder: (context, state) => const MeritLedgerScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});

// Màn hình khung chứa Bottom Navigation
class MainScaffold extends ConsumerWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final templeState = ref.watch(templeContextProvider);
    
    String appBarTitle = 'Trang Chủ Hệ Sinh Thái';
    if (templeState.mode == ContextMode.selectedTemple) {
      appBarTitle = templeState.tenantName ?? 'Chùa đã chọn';
    } else if (templeState.mode == ContextMode.nearbySuggestion) {
      appBarTitle = 'Gần: ${templeState.tenantName}';
    }

    int currentIndex = 0;
    if (location == '/discovery') currentIndex = 1;
    if (location == '/ai-bot') currentIndex = 2;
    if (location == '/dharma') currentIndex = 3;
    if (location == '/merit') currentIndex = 4;
    if (location == '/profile') currentIndex = 5;

    return Scaffold(
      extendBody: true, // Need this for blur to extend behind the navbar
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => showTemplePicker(context),
              child: const TempleContextBadge(),
            ),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: GlassNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0: context.go('/'); break;
            case 1: context.go('/discovery'); break;
            case 2: context.go('/ai-bot'); break;
            case 3: context.go('/dharma'); break;
            case 4: context.go('/merit'); break;
            case 5: context.go('/profile'); break;
          }
        },
      ),
    );
  }
}

class SplashLoader extends StatelessWidget {
  const SplashLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title, style: Theme.of(context).textTheme.headlineMedium));
  }
}
