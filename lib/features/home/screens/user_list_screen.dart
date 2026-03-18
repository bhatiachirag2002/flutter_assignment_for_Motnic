import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/features/home/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchQueryProvider.notifier).setQuery(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsersState = ref.watch(filteredUserListProvider);
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: const Color(0xFFF0EFEF),
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text(
          'User List',
          style: TextStyle(fontSize: width * 0.06, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name, email or city...',
                hintStyle: TextStyle(fontSize: width * 0.04),
                prefixIcon: Icon(Icons.search, size: width * 0.06),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(width * 0.03),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                  vertical: width * 0.03,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              style: TextStyle(fontSize: width * 0.04),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(userListProvider);
                await ref.read(userListProvider.future);
              },
              child: filteredUsersState.when(
                data: (users) {
                  if (users.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.3,
                        ),
                        Center(
                          child: Text(
                            'No users found.',
                            style: TextStyle(fontSize: width * 0.04),
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Card(
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                          vertical: width * 0.01,
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: width * 0.04,
                            vertical: width * 0.02,
                          ),
                          title: Text(
                            user.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.04,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: width * 0.01),
                              Text(
                                'Email: ${user.email}',
                                style: TextStyle(fontSize: width * 0.035),
                              ),
                              Text(
                                'City: ${user.address.city}',
                                style: TextStyle(fontSize: width * 0.035),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: width * 0.04,
                          ),
                          onTap: () {
                            context.pushNamed('user_detail', extra: user);
                          },
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.08,
                        ), 
                        child: Text(
                          'Error: $err',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: width * 0.04),
                        ), 
                      ),
                      SizedBox(height: width * 0.04), 
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(userListProvider);
                        },
                        child: Text(
                          'Retry',
                          style: TextStyle(fontSize: width * 0.04),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
