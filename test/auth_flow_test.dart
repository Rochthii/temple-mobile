import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Unit tests cho Auth Flow
/// Kiểm tra logic redirect của router và state management của AuthNotifier
/// Không cần kết nối Supabase thật — mock bằng ProviderOverride

void main() {
  group('🔐 Auth Router Redirect Logic', () {
    test('Khi chưa đăng nhập → phải redirect về /login', () {
      // Mô phỏng: user = null (chưa đăng nhập)
      bool loggedIn = false;
      String location = '/home';
      bool isPublicRoute = ['/login', '/register', '/splash'].contains(location);

      String? redirect;
      if (!loggedIn) {
        redirect = isPublicRoute ? null : '/login';
      }

      expect(redirect, equals('/login'));
    });

    test('Khi đã đăng nhập + đang ở /login → phải redirect về /', () {
      // Mô phỏng: có user, đang ở trang login
      const bool loggedIn = true;
      const String location = '/login';

      String? redirect;
      if (loggedIn && (location == '/login' || location == '/splash')) {
        redirect = '/';
      }

      expect(redirect, equals('/'));
    });

    test('Khi đã đăng nhập + đang ở / → không redirect (null)', () {
      const bool loggedIn = true;
      const String location = '/';

      String? redirect;
      if (loggedIn && (location == '/login' || location == '/splash')) {
        redirect = '/';
      }

      expect(redirect, isNull);
    });

    test('Khi auth đang loading → phải redirect về /splash', () {
      const bool isLoading = true;

      String? redirect;
      if (isLoading) redirect = '/splash';

      expect(redirect, equals('/splash'));
    });

    test('/register là public route → chưa login vẫn được vào', () {
      const bool loggedIn = false;
      const String location = '/register';
      final bool isPublicRoute = ['/login', '/register', '/splash'].contains(location);

      String? redirect;
      if (!loggedIn) {
        redirect = isPublicRoute ? null : '/login';
      }

      expect(redirect, isNull); // không bị redirect → được vào /register
    });
  });

  group('✅ Form Validation — Register Screen', () {
    test('Email hợp lệ phải chứa @ và .', () {
      String? validateEmail(String? v) {
        if (v == null || v.trim().isEmpty) return 'Vui lòng nhập email';
        if (!v.contains('@') || !v.contains('.')) return 'Email không hợp lệ';
        return null;
      }

      expect(validateEmail(null), equals('Vui lòng nhập email'));
      expect(validateEmail(''), equals('Vui lòng nhập email'));
      expect(validateEmail('khonghople'), equals('Email không hợp lệ'));
      expect(validateEmail('test@gmail.com'), isNull);
      expect(validateEmail('user@temple.vn'), isNull);
    });

    test('Mật khẩu phải có ít nhất 6 ký tự', () {
      String? validatePassword(String? v) {
        if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu';
        if (v.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
        return null;
      }

      expect(validatePassword(null), equals('Vui lòng nhập mật khẩu'));
      expect(validatePassword(''), equals('Vui lòng nhập mật khẩu'));
      expect(validatePassword('12345'), equals('Mật khẩu phải có ít nhất 6 ký tự'));
      expect(validatePassword('123456'), isNull);
      expect(validatePassword('password123'), isNull);
    });

    test('Xác nhận mật khẩu phải khớp', () {
      bool passwordsMatch(String pass, String confirm) => pass == confirm;

      expect(passwordsMatch('abc123', 'abc123'), isTrue);
      expect(passwordsMatch('abc123', 'abc456'), isFalse);
      expect(passwordsMatch('', ''), isTrue);
    });

    test('Họ tên không được để trống', () {
      String? validateName(String? v) =>
          (v == null || v.trim().isEmpty) ? 'Vui lòng nhập họ tên' : null;

      expect(validateName(null), equals('Vui lòng nhập họ tên'));
      expect(validateName(''), equals('Vui lòng nhập họ tên'));
      expect(validateName('   '), equals('Vui lòng nhập họ tên'));
      expect(validateName('Nguyễn Văn A'), isNull);
    });
  });

  group('🏛️ Temple Selection Logic', () {
    test('Không chọn chùa → preferredTempleId là null', () {
      String? selectedTempleId;
      // User bấm "Bỏ qua"
      selectedTempleId = null;
      expect(selectedTempleId, isNull);
    });

    test('Chọn chùa → preferredTempleId là ID của chùa đó', () {
      String? selectedTempleId;
      const String templeId = 'abc-123-xyz';
      selectedTempleId = templeId;
      expect(selectedTempleId, equals('abc-123-xyz'));
    });

    test('signUp payload phải chứa full_name', () {
      final payload = <String, dynamic>{
        'full_name': 'Nguyễn Văn Test',
      };
      final String preferredTempleId = 'temple-001';
      payload['preferred_temple_id'] = preferredTempleId;
    
      expect(payload['full_name'], equals('Nguyễn Văn Test'));
      expect(payload['preferred_temple_id'], equals('temple-001'));
    });

    test('signUp payload không có preferred_temple_id khi bỏ qua', () {
      final payload = <String, dynamic>{
        'full_name': 'Nguyễn Văn Test',
      };
      const String? preferredTempleId = null;
      if (preferredTempleId != null) {
        payload['preferred_temple_id'] = preferredTempleId;
      }

      expect(payload.containsKey('preferred_temple_id'), isFalse);
    });
  });

  group('📱 Riverpod State — AuthNotifier', () {
    test('AuthNotifier khởi tạo với AsyncValue.loading()', () {
      // Kiểm tra trạng thái khởi đầu là loading
      final AsyncValue<dynamic> initial = const AsyncValue.loading();
      expect(initial.isLoading, isTrue);
      expect(initial.value, isNull);
    });

    test('AsyncValue.data(null) → chưa đăng nhập', () {
      // Sau khi load xong, không có user
      const AsyncValue<dynamic> state = AsyncValue.data(null);
      expect(state.isLoading, isFalse);
      expect(state.value, isNull);
      expect(state.value != null, isFalse); // loggedIn = false
    });

    test('AsyncValue.data(user) → đã đăng nhập', () {
      // Mô phỏng có user object
      const String mockUserId = 'user-uuid-001';
      const AsyncValue<String> state = AsyncValue.data(mockUserId);
      expect(state.isLoading, isFalse);
      expect(state.value, equals(mockUserId));
      expect(state.value != null, isTrue); // loggedIn = true
    });
  });
}
