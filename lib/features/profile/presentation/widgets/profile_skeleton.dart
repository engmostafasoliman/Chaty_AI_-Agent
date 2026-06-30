import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shimmer_box.dart';

class ProfileSkeleton extends StatelessWidget {
  final bool isDark;
  const ProfileSkeleton({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _HeaderCardSkeleton(isDark: isDark),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _StatsSkeleton(isDark: isDark),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          sliver: SliverList.separated(
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, __) => _RepoCardSkeleton(isDark: isDark),
          ),
        ),
      ],
    );
  }
}

class _HeaderCardSkeleton extends StatelessWidget {
  final bool isDark;
  const _HeaderCardSkeleton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(isDark),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(isDark)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            child: ShimmerBox(
              width: double.infinity,
              height: 96,
              radius: 0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ShimmerBox(width: 140, height: 18),
                          const SizedBox(height: 8),
                          const ShimmerBox(width: 96, height: 13),
                        ],
                      ),
                    ),
                    const ShimmerBox(width: 110, height: 13),
                  ],
                ),
                const SizedBox(height: 16),
                const ShimmerBox(width: double.infinity, height: 13),
                const SizedBox(height: 6),
                const ShimmerBox(width: 200, height: 13),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 20,
                  runSpacing: 8,
                  children: const [
                    ShimmerBox(width: 100, height: 12),
                    ShimmerBox(width: 80, height: 12),
                    ShimmerBox(width: 90, height: 12),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsSkeleton extends StatelessWidget {
  final bool isDark;
  const _StatsSkeleton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface(isDark),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(isDark)),
      ),
      child: Row(
        children: List.generate(4, (i) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.bg(isDark),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  ShimmerBox(width: 40, height: 18),
                  SizedBox(height: 6),
                  ShimmerBox(width: 56, height: 11),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}

class _RepoCardSkeleton extends StatelessWidget {
  final bool isDark;
  const _RepoCardSkeleton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(isDark),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(isDark)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              ShimmerBox(width: 128, height: 16),
              Spacer(),
              ShimmerBox(width: 56, height: 22, radius: 100),
            ],
          ),
          const SizedBox(height: 16),
          const ShimmerBox(width: double.infinity, height: 13),
          const SizedBox(height: 6),
          const ShimmerBox(width: 200, height: 13),
          const SizedBox(height: 20),
          Row(
            children: const [
              ShimmerBox(width: 64, height: 12),
              SizedBox(width: 16),
              ShimmerBox(width: 40, height: 12),
              SizedBox(width: 16),
              ShimmerBox(width: 80, height: 12),
            ],
          ),
        ],
      ),
    );
  }
}
