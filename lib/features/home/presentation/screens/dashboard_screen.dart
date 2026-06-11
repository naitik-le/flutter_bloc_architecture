import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_architecture/features/crypto/presentation/screens/crypto_screen.dart';
import 'package:flutter_bloc_architecture/features/products/presentation/screens/product_list_screen.dart';
import 'package:flutter_bloc_architecture/features/home/presentation/bloc/dashboard_cubit.dart';
import 'package:flutter_bloc_architecture/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_bloc_architecture/features/home/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter_bloc_architecture/features/profile/presentation/screens/profile_screen.dart';

/// Main container screen handling bottom navigation between Home, Products, Crypto, and Profile.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final List<Widget> _screens = const [
    HomeScreen(),
    ProductListScreen(),
    CryptoScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, int>(
      builder: (context, activeIndex) {
        return Scaffold(
          extendBody: true, // Floating navbar sits above scrollable content
          body: IndexedStack(
            index: activeIndex,
            children: _screens,
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: activeIndex,
            onTap: (index) => context.read<DashboardCubit>().setTab(index),
          ),
        );
      },
    );
  }
}
