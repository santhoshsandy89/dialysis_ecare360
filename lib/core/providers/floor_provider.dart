import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// A simple model to hold floor details
class Floor {
  final String id;
  final String name;
  final String code;

  Floor({required this.id, required this.name, required this.code});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
      };

  factory Floor.fromJson(Map<String, dynamic> json) => Floor(
        id: json['id'] as String,
        name: json['name'] as String,
        code: json['code'] as String,
      );
}

final floorProvider = StateNotifierProvider<FloorNotifier, Floor?>((ref) {
  return FloorNotifier();
});

class FloorNotifier extends StateNotifier<Floor?> {
  FloorNotifier() : super(null) {
    _loadFloor();
  }

  static const String _floorKey = 'selected_floor';

  Future<void> _loadFloor() async {
    final prefs = await SharedPreferences.getInstance();
    final floorJson = prefs.getString(_floorKey);
    if (floorJson != null) {
      state = Floor.fromJson(json.decode(floorJson));
    }
  }

  Future<void> setFloor(String name, {required String id, required String code}) async {
    final prefs = await SharedPreferences.getInstance();
    final floor = Floor(id: id, name: name, code: code);
    await prefs.setString(_floorKey, json.encode(floor.toJson()));
    state = floor;
  }

  Future<void> clearFloor() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_floorKey);
    state = null;
  }
}
