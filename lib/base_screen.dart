import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:klontong/presentation/auth/login_screen.dart';
import 'package:klontong/presentation/bloc/auth/login_bloc.dart';
import 'package:klontong/core/services/user_service.dart';
import 'package:klontong/presentation/cart/cart_list_screen.dart';
import 'package:klontong/presentation/product/add_product_screen.dart';
import 'package:klontong/presentation/product/product_list_screen.dart';
import 'package:klontong/presentation/profile/profile_screen.dart';

class BaseTabScreen extends HookWidget {
  final LoginBloc loginBloc;

  const BaseTabScreen({super.key, required this.loginBloc});

  @override
  Widget build(BuildContext context) {
    final tabIndex = useState<int>(0);
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: loginBloc)],
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginInitial) {
            // Navigate to LoginPage if state is LoginInitial
            locator<UserService>().setUser(null);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) => false,
            );
          }
        },
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text(tabIndex.value == 2 ? "Profile" : 'Klontong'),
              actions: [
                if (tabIndex.value == 2)
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () async {
                      // Trigger logout event
                      BlocProvider.of<LoginBloc>(context)
                          .add(LogoutRequested());

                      // Optional: If you need to handle post-logout navigation, you can use `await`
                      await Future.delayed(Duration(
                          milliseconds: 500)); // Adjust delay as needed
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
              ],
            ),
            body: TabBarView(
              children: List.generate(3, (index) {
                switch (index) {
                  case 0:
                    return const ProductListScreen();
                  case 1:
                    return const CartScreen();
                  case 2:
                    return const ProfileScreen();
                  default:
                    return Container();
                }
              }),
            ),
            bottomNavigationBar: SafeArea(
              child: TabBar(
                onTap: (i) {
                  tabIndex.value = i;
                },
                tabs: const [
                  Tab(icon: Icon(Icons.home), text: 'Home'),
                  Tab(icon: Icon(Icons.shopping_cart), text: 'Cart'),
                  Tab(icon: Icon(Icons.person), text: 'Profile'),
                ],
              ),
            ),
            floatingActionButton: tabIndex.value == 2
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddNewProductScreen()));
                    },
                    child: const Icon(Icons.add),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
