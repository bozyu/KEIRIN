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
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Builder(builder: (context) {
              final raw = bike.imageUrl.trim();
              final resolved = raw.isEmpty
                  ? ''
                  : (Uri.tryParse(raw)?.hasScheme ?? false)
                      ? raw
                      : 'https://$raw';

              if (resolved.isEmpty) {
                return ColoredBox(
                  color: Colors.grey.shade900,
                  child: const Center(
                    child: Icon(Icons.image_not_supported_outlined,
                        size: 40, color: Colors.white54),
                  ),
                );
              }

              return CachedNetworkImage(
                imageUrl: resolved,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade900,
                  highlightColor: Colors.grey.shade800,
                  child: ColoredBox(color: Colors.grey.shade900),
                ),
                errorWidget: (context, url, error) => ColoredBox(
                  color: Colors.grey.shade900,
                  child: const Center(
                    child: Icon(Icons.broken_image_outlined,
                        size: 40, color: Colors.white54),
                  ),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bike.bikeName,
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '@${bike.ownerName} - ${bike.frameSize}',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<_BikeAction>(
                      tooltip: 'действия',
                      onSelected: (action) {
                        if (action == _BikeAction.delete) onDelete?.call();
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: _BikeAction.delete,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            leading: Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            title: Text('удалить',
                                style: TextStyle(color: Colors.redAccent)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildStatChip(
                      Icons.settings,
                      '${bike.chainring}x${bike.cog}',
                      colorScheme.primary,
                    ),
                    _buildStatChip(
                      Icons.speed,
                      'передача ${bike.gearRatio.toStringAsFixed(2)}',
                      colorScheme.secondary,
                    ),
                    _buildStatChip(
                      Icons.tire_repair,
                      '${bike.skidPatches} скидпатчей',
                      bike.skidPatches <= 2
                          ? colorScheme.error
                          : colorScheme.tertiary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: const Text(
                'чекнуть сэтап',
                style: TextStyle(fontWeight: FontWeight.w700),
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

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(String title, String specs, ColorScheme colors) {
    if (specs.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
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
          Text(specs,
              style: const TextStyle(height: 1.4, color: Colors.white70)),
        ],
      ),
    );
  }
}

enum _BikeAction { delete }
