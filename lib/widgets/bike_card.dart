import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../models/bike_model.dart';
import '../screens/setup_preview_sheet.dart';

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
           GestureDetector(
             onTap: () {
               showModalBottomSheet(
                 context: context,
                 isScrollControlled: true,
                 backgroundColor: Colors.transparent,
                 builder: (ctx) {
                   final fullHeight = MediaQuery.of(context).size.height * 0.95;
                   return SizedBox(
                     height: fullHeight,
                     width: double.infinity,
                     child: Container(
                       decoration: BoxDecoration(
                         color: Theme.of(context).scaffoldBackgroundColor,
                         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                       ),
                       child: SingleChildScrollView(
                         child: Padding(
                           padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                           child: SetupPreviewSheet(bike: bike),
                         ),
                       ),
                     ),
                   );
                 },
               );
             },
             child: Container(
               color: colorScheme.surface,
               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
               child: Row(
                 children: [
                   Icon(Icons.info_outline, color: colorScheme.primary),
                   const SizedBox(width: 12),
                   Text(
                     'чекнуть сэтап',
                     style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurface),
                   ),
                   const Spacer(),
                   Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
                 ],
               ),
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
}

enum _BikeAction { delete }