import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shimmer_box.dart';

class RepoDetailSkeleton extends StatelessWidget {
  final bool isDark;
  const RepoDetailSkeleton({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        // Back row
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: ShimmerBox(width: 100, height: 14),
          ),
        ),
        // Repo header card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: _HeaderCardSkeleton(isDark: isDark),
          ),
        ),
        // Summary card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            child: _SummaryCardSkeleton(isDark: isDark),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(isDark),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(isDark)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(width: 120, height: 11),
          const SizedBox(height: 6),
          const ShimmerBox(width: 180, height: 20),
          const SizedBox(height: 12),
          const ShimmerBox(width: double.infinity, height: 13),
          const SizedBox(height: 6),
          const ShimmerBox(width: 220, height: 13),
          const SizedBox(height: 20),
          Row(
            children: const [
              ShimmerBox(width: 60, height: 22, radius: 100),
              SizedBox(width: 8),
              ShimmerBox(width: 60, height: 22, radius: 100),
              SizedBox(width: 8),
              ShimmerBox(width: 60, height: 22, radius: 100),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: AppColors.border(isDark),
          ),
          const SizedBox(height: 20),
          Row(
            children: List.generate(3, (i) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: i == 0 ? 0 : 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerBox(width: 40, height: 18),
                    SizedBox(height: 4),
                    ShimmerBox(width: 56, height: 11),
                  ],
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }
}

class _SummaryCardSkeleton extends StatelessWidget {
  final bool isDark;
  const _SummaryCardSkeleton({required this.isDark});

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
              ShimmerBox(width: 100, height: 16),
              Spacer(),
              ShimmerBox(width: 32, height: 28, radius: 6),
            ],
          ),
          const SizedBox(height: 16),
          const ShimmerBox(width: double.infinity, height: 13),
          const SizedBox(height: 6),
          const ShimmerBox(width: double.infinity, height: 13),
          const SizedBox(height: 6),
          const ShimmerBox(width: 180, height: 13),
          const SizedBox(height: 20),
          const ShimmerBox(width: 80, height: 14),
          const SizedBox(height: 10),
          Row(
            children: const [
              ShimmerBox(width: 60, height: 26, radius: 100),
              SizedBox(width: 8),
              ShimmerBox(width: 72, height: 26, radius: 100),
              SizedBox(width: 8),
              ShimmerBox(width: 56, height: 26, radius: 100),
            ],
          ),
          const SizedBox(height: 20),
          const ShimmerBox(width: 80, height: 14),
          const SizedBox(height: 10),
          _BulletSkeleton(),
          const SizedBox(height: 8),
          _BulletSkeleton(),
          const SizedBox(height: 8),
          _BulletSkeleton(width: 200),
        ],
      ),
    );
  }
}

class _BulletSkeleton extends StatelessWidget {
  final double width;
  const _BulletSkeleton({this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ShimmerBox(width: 6, height: 6, radius: 3),
        const SizedBox(width: 10),
        Expanded(child: ShimmerBox(width: width, height: 13)),
      ],
    );
  }
}
