import 'dart:convert';
import 'package:ecare360/data/models/session_data_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // Will be overridden in main
});

class BpEntryListNotifier extends StateNotifier<List<BloodPressureEntry>> {
  BpEntryListNotifier(this._prefs) : super([]) {
    _loadBpEntries();
  }

  final SharedPreferences _prefs;
  static const String _bpEntriesKey = 'bpEntries';

  Future<void> _loadBpEntries() async {
    final String? bpEntriesJson = _prefs.getString(_bpEntriesKey);
    if (bpEntriesJson != null) {
      final List<dynamic> jsonList = json.decode(bpEntriesJson);
      state = jsonList.map((e) => BloodPressureEntry.fromMap(e as Map<String, dynamic>)).toList();
    }
  }

  Future<void> _saveBpEntries() async {
    final String bpEntriesJson = json.encode(state.map((e) => e.toMap()).toList());
    await _prefs.setString(_bpEntriesKey, bpEntriesJson);
  }

  void addBpEntry(BloodPressureEntry entry) {
    state = [...state, entry];
    _saveBpEntries();
  }

  void updateBpEntry(int index, BloodPressureEntry entry) {
    if (index >= 0 && index < state.length) {
      final List<BloodPressureEntry> newState = List.from(state);
      newState[index] = entry;
      state = newState;
      _saveBpEntries();
    }
  }

  void removeBpEntry(int index) {
    if (index >= 0 && index < state.length) {
      final List<BloodPressureEntry> newState = List.from(state);
      newState.removeAt(index);
      state = newState;
      _saveBpEntries();
    }
  }

  void setBpEntries(List<BloodPressureEntry> entries) {
    state = entries;
    _saveBpEntries();
  }
}

final bpEntryListProvider = StateNotifierProvider<BpEntryListNotifier, List<BloodPressureEntry>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return BpEntryListNotifier(prefs);
});
