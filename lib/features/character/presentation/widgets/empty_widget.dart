import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class EmptyWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyWidget({
    super.key,
    this.title = 'No Data Found',
    this.subtitle = 'There is nothing here yet',
    this.icon = Icons. inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child:  Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment. center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color:  AppColors.primaryGreen),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTextStyles.heading3.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height:  8),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium. copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign. center,
            ),
          ],
        ),
      ),
    );
  }
}

class EmptySearchWidget extends StatelessWidget {
  final String query;

  const EmptySearchWidget({super.key, required this. query});

  @override
  Widget build(BuildContext context) {
    return EmptyWidget(
      icon: Icons.search_off_rounded,
      title: 'No Results Found',
      subtitle: 'No characters found for "$query"\nTry a different search term',
    );
  }
}

class EmptyFavoritesWidget extends StatelessWidget {
  const EmptyFavoritesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyWidget(
      icon: Icons.favorite_border_rounded,
      title: 'No Favorites Yet',
      subtitle: 'Start adding your favorite characters\nby tapping the heart icon',
    );
  }
}