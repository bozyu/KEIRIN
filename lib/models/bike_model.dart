import 'dart:convert';

class Bike {
  final String id;
  final String ownerName;
  final String bikeName;
  final String imageUrl;

  final String frameSize;
  final int chainring;
  final int cog;

  final String wheelset;
  final String cockpit;
  final String drivetrain;
  final String seating;
  final String extras;

  const Bike({
    required this.id,
    required this.ownerName,
    required this.bikeName,
    required this.imageUrl,
    required this.frameSize,
    required this.chainring,
    required this.cog,
    required this.wheelset,
    required this.cockpit,
    required this.drivetrain,
    required this.seating,
    required this.extras,
  });

  double get gearRatio => cog == 0 ? 0 : chainring / cog;

  int get skidPatches {
    if (chainring <= 0 || cog <= 0) return 0;

    int gcd(int a, int b) {
      while (b != 0) {
        final t = b;
        b = a % b;
        a = t;
      }
      return a;
    }

    return cog ~/ gcd(chainring, cog);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerName': ownerName,
      'bikeName': bikeName,
      'imageUrl': imageUrl,
      'frameSize': frameSize,
      'chainring': chainring,
      'cog': cog,
      'wheelset': wheelset,
      'cockpit': cockpit,
      'drivetrain': drivetrain,
      'seating': seating,
      'extras': extras,
    };
  }

  factory Bike.fromMap(Map<String, dynamic> map) {
    return Bike(
      id: map['id'] as String? ?? '',
      ownerName: map['ownerName'] as String? ?? '',
      bikeName: map['bikeName'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      frameSize: map['frameSize'] as String? ?? '',
      chainring: (map['chainring'] is int)
          ? map['chainring'] as int
          : int.tryParse('${map['chainring']}') ?? 0,
      cog: (map['cog'] is int)
          ? map['cog'] as int
          : int.tryParse('${map['cog']}') ?? 0,
      wheelset: map['wheelset'] as String? ?? '',
      cockpit: map['cockpit'] as String? ?? '',
      drivetrain: map['drivetrain'] as String? ?? '',
      seating: map['seating'] as String? ?? '',
      extras: map['extras'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Bike.fromJson(String source) =>
      Bike.fromMap(json.decode(source) as Map<String, dynamic>);
}
