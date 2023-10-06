import 'package:flutter/material.dart';

class EventStaticComponent {
  EventStaticComponent._();

  static EventStaticComponent instance = EventStaticComponent._();

  Map<String, Map<String, Function>> groupEvent = {};
  Map<String, Function> listEvent = {};

  add({required String key, required Function event}) {
    listEvent[key] = event;
  }

  addGroup({required String groupKey, required String key, required Function event}) {
    if (groupEvent[groupKey] == null) {
      groupEvent[groupKey] = {key: event};
    } else {
      groupEvent[groupKey]![key] = event;
    }
  }

  remove({
    required String key,
  }) {
    listEvent.remove(key);
  }

  removeGroup({required String groupKey, String? key}) {
    if (key != null) {
      groupEvent[groupKey]?.remove(key);
    } else {
      groupEvent.remove(groupKey);
    }
  }

  call({required String key, dynamic params}) {
    listEvent[key]?.call(params);
  }

  callGroup({required String groupKey, String? key, dynamic params}) {
    if (key != null) {
      groupEvent[groupKey]?[key]?.call(params);
    } else {
      final listKey = groupEvent[groupKey]?.keys.toList();
      for (var item in listKey ?? []) {
        try {
          groupEvent[groupKey]?[item]?.call(params ?? {});
        } catch (error) {
          debugPrint("error: $error");
        }
      }
    }
  }

  removeAll() {
    listEvent = {};
    groupEvent = {};
  }
}
