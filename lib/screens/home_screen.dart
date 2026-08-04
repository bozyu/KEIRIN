import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bike_model.dart';
import '../widgets/bike_card.dart';
import 'add_setup_sheet.dart';
import 'empty_state.dart';

enum BikeSort { newest, ratioHigh, skidPatches }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final List<Bike> _bikes = [];
  BikeSort _sort = BikeSort.newest;

  @override
  void initState() {
    super.initState();
    _loadBikes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Bike> get _visibleBikes {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = _bikes.where((bike) {
      if (query.isEmpty) return true;
      return [
        bike.ownerName,
        bike.bikeName,
        bike.frameSize,
        bike.wheelset,
        bike.cockpit,
        bike.drivetrain,
        bike.seating,
        bike.extras,
      ].any((value) => value.toLowerCase().contains(query));
    }).toList();

    switch (_sort) {
      case BikeSort.newest:
        return filtered;
      case BikeSort.ratioHigh:
        return filtered..sort((a, b) => b.gearRatio.compareTo(a.gearRatio));
      case BikeSort.skidPatches:
        return filtered..sort((a, b) => b.skidPatches.compareTo(a.skidPatches));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bikes = _visibleBikes;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KEIRIN',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 4),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'сэтапы fixed gear',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_bikes.length} сэтапов в ленте',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'искать по юзеру, фрейму или деталям',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'очистить поиск',
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<BikeSort>(
                    segments: const [
                      ButtonSegment(
                        value: BikeSort.newest,
                        icon: Icon(Icons.schedule),
                        label: Text('новые'),
                      ),
                      ButtonSegment(
                        value: BikeSort.ratioHigh,
                        icon: Icon(Icons.speed),
                        label: Text('передача'),
                      ),
                      ButtonSegment(
                        value: BikeSort.skidPatches,
                        icon: Icon(Icons.tire_repair),
                        label: Text('скидпатчи'),
                      ),
                    ],
                    selected: {_sort},
                    onSelectionChanged: (value) {
                      setState(() => _sort = value.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          if (bikes.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.builder(
                itemCount: bikes.length,
                itemBuilder: (context, index) {
                  return BikeCard(
                    bike: bikes[index],
                    onDelete: () => _deleteBike(bikes[index]),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 220),
        child: FloatingActionButton.extended(
          onPressed: _openAddSetupSheet,
          icon: const Icon(Icons.add),
          label: const Text('сэтап'),
        ),
      ),
    );
  }

  void _deleteBike(Bike bike) {
    setState(() => _bikes.removeWhere((item) => item.id == bike.id));
    _saveBikes();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('удалено ${bike.bikeName}')));
  }

  Future<void> _openAddSetupSheet() async {
    final bike = await showModalBottomSheet<Bike>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => const AddSetupSheet(),
    );

    if (bike == null || !mounted) return;
    setState(() => _bikes.insert(0, bike));
    _saveBikes();
  }

  Future<SharedPreferences?> _tryGetPrefs({int retries = 5, Duration delay = const Duration(milliseconds: 200)}) async {
    for (var i = 0; i < retries; i++) {
      try {
        return await SharedPreferences.getInstance();
      } catch (e) {
        if (i == retries - 1) return null;
        await Future.delayed(delay);
      }
    }
    return null;
  }

  Future<void> _loadBikes() async {
    final prefs = await _tryGetPrefs();
    if (prefs == null) return;
    final list = prefs.getStringList('bikes') ?? [];
    setState(() {
      _bikes.clear();
      _bikes.addAll(list.map((e) => Bike.fromJson(e)));
    });
  }

  Future<void> _saveBikes() async {
    final prefs = await _tryGetPrefs();
    if (prefs == null) return;
    final list = _bikes.map((b) => b.toJson()).toList();
    await prefs.setStringList('bikes', list);
  }
}
