import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../models/bike_model.dart';

class BikeCard extends StatelessWidget {
  final Bike bike;
  final VoidCallback? onDelete;

  const BikeCard({super.key, required this.bike, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImage(context, bike, colorScheme, textTheme),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bike.bikeName,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '@${bike.ownerName}',
                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                      if (bike.frameSize.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          bike.frameSize,
                          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.4),
                        ),
                      ],
                    ],
                  ),
                ),
                PopupMenuButton<_BikeAction>(
                  tooltip: 'действия',
                  color: colorScheme.surface,
                  onSelected: (action) {
                    if (action == _BikeAction.delete) onDelete?.call();
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: _BikeAction.delete,
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: colorScheme.error),
                          const SizedBox(width: 8),
                          Text('удалить', style: TextStyle(color: colorScheme.error)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStatText(
                  label: 'Соотношение',
                  value: '${bike.chainring}x${bike.cog}',
                  colorScheme: colorScheme,
                ),
                const SizedBox(width: 12),
                _buildStatText(
                  label: 'Передача',
                  value: bike.gearRatio > 0 ? bike.gearRatio.toStringAsFixed(2) : '—',
                  colorScheme: colorScheme,
                ),
                const SizedBox(width: 12),
                _buildStatText(
                  label: 'Скидпатчи',
                  value: '${bike.skidPatches}',
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              collapsedBackgroundColor: colorScheme.surface,
              backgroundColor: colorScheme.surface,
              title: Text(
                'чекнуть сэтап',
                style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurface),
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                _buildCategory('виллсет', bike.wheelset, colorScheme),
                _buildCategory('руль и хват', bike.cockpit, colorScheme),
                _buildCategory('трансмиссия', bike.drivetrain, colorScheme),
                _buildCategory('седло', bike.seating, colorScheme),
                _buildCategory('дополнительно', bike.extras, colorScheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context, Bike bike, ColorScheme colorScheme, TextTheme textTheme) {
    final raw = bike.imageUrl.trim();
    final resolved = raw.isEmpty
        ? ''
        : (Uri.tryParse(raw)?.hasScheme ?? false)
            ? raw
            : 'https://$raw';

    final imageWidget = resolved.isEmpty
        ? ColoredBox(
            color: colorScheme.surfaceContainerHighest,
            child: const Center(
              child: Icon(Icons.image_not_supported_outlined, size: 40),
            ),
          )
        : CachedNetworkImage(
            imageUrl: resolved,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey.shade800,
              highlightColor: Colors.grey.shade700,
              child: ColoredBox(color: colorScheme.surfaceContainerHighest),
            ),
            errorWidget: (context, url, error) => ColoredBox(
              color: colorScheme.surfaceContainerHighest,
              child: const Center(
                child: Icon(Icons.broken_image_outlined, size: 40),
              ),
            ),
          );

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          imageWidget,
          if (resolved.isNotEmpty)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      colorScheme.surface.withValues(alpha: 0.68),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bike.bikeName,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@${bike.ownerName}',
                  style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatText({
    required String label,
    required String value,
    required ColorScheme colorScheme,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(String title, String specs, ColorScheme colors) {
    if (specs.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(specs, style: TextStyle(height: 1.4, color: colors.onSurfaceVariant)),
        ],
      ),
    );
  }
}

enum _BikeAction { delete }