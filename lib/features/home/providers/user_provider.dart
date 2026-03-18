import 'package:flutter_assignment/core/services/base_api_client.dart';
import 'package:flutter_assignment/features/home/models/user_model.dart';
import 'package:flutter_assignment/features/home/services/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final baseApiClientProvider = Provider<BaseApiClient>((ref) {
  return BaseApiClient();
});

final userServiceProvider = Provider<UserService>((ref) {
  final apiClient = ref.watch(baseApiClientProvider);
  return UserService(apiClient);
});

final userListProvider = FutureProvider<List<User>>((ref) async {
  final service = ref.watch(userServiceProvider);
  return await service.getUsers();
});

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(() {
  return SearchQueryNotifier();
});

final filteredUserListProvider = Provider<AsyncValue<List<User>>>((ref) {
  final usersState = ref.watch(userListProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  return usersState.whenData((users) {
    if (query.isEmpty) return users;
    return users.where((user) {
      return user.name.toLowerCase().contains(query) ||
             user.email.toLowerCase().contains(query) ||
             user.address.city.toLowerCase().contains(query);
    }).toList();
  });
});
