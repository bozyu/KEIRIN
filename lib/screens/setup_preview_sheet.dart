import 'package:flutter/material.dart';
import '../models/bike_model.dart';

class SetupPreviewSheet extends StatelessWidget {
  final Bike bike;
  const SetupPreviewSheet({super.key, required this.bike});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'просмотр сэтапа',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 6),

            // image removed for minimal view

            _labeledSectionCard(context, 'рама', [
              'нэйм фикса',
              'рама',
              'вилка',
              'рулевая',
            ], [
              bike.bikeName,
              ..._splitValues(bike.frameSize, 3),
            ]),

            _labeledSectionCard(context, 'кокпит', [
              'руль',
              'вынос',
              'грипсы / обмотка',
            ], [..._splitValues(bike.cockpit, 3)]),

            _labeledSectionCard(context, 'виллсет', [
              'втулки',
              'обода',
              'спицы',
              'ниппели',
            ], [..._splitValues(bike.wheelset, 4)]),

            _labeledSectionCard(context, 'трансмиссия', [
              'соотношение',
              'передача',
              'скидпатчи',
              'система (шатуны)',
              'каретка',
              'цепь',
              'локринг',
            ], [
              if (bike.chainring > 0 || bike.cog > 0) '${bike.chainring}x${bike.cog}',
              if (bike.chainring > 0 || bike.cog > 0)
                (bike.gearRatio > 0 ? bike.gearRatio.toStringAsFixed(2) : '—'),
              if (bike.chainring > 0 || bike.cog > 0) '${bike.skidPatches}',
              ..._splitValues(bike.drivetrain, 4),
            ]),

            _labeledSectionCard(context, 'посадка', [
              'подседельный штырь',
              'седло',
              'подседельный зажим',
            ], [..._splitValues(bike.seating, 3)]),

            _labeledSectionCard(context, 'дополнительно', [
              'покрышки',
              'педали',
              'стрепы / туклипы',
            ], [..._splitValues(bike.extras, 3)]),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  List<String> _splitValues(String data, int maxFields) {
    if (data.trim().isEmpty) return List.filled(0, '');
    final parts = data.split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    // return up to maxFields values; if less, return only those present
    return parts.take(maxFields).toList();
  }

  Widget _labeledSectionCard(BuildContext context, String title, List<String> labels, List<String> values) {
    final rows = <Widget>[];
    for (var i = 0; i < labels.length; i++) {
      final label = labels[i];
      final value = i < values.length ? values[i] : '';
      if (value.isEmpty) continue;
      rows.add(_minimalField(context, label, value));
    }

    if (rows.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          ...rows,
        ],
      ),
    );
  }

  Widget _minimalField(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
