class EventStaticComponent {
  EventStaticComponent._();

  static EventStaticComponent instance = EventStaticComponent._();

  Map<String, Function> listEvent = {};

  add({required String key, dynamic event}) {
    listEvent[key] = event;
  }

  remove({required String key}) {
    listEvent.remove(key);
  }

  call({required String key, dynamic params}){
    listEvent[key]?.call(params);
  }

  removeAll() {
    listEvent = {};
  }
}
