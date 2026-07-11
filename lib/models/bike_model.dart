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
}
