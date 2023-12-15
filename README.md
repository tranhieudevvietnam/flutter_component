# flutter_component

A new Flutter plugin project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Init component

- init main:

```

    // Initialize Firebase.
    await Firebase.initializeApp();
```

## Turn off automatic collection natively

- AndroidManifest.xml
  
```

<meta-data
  android:name="firebase_crashlytics_collection_enabled"
  android:value="false" />
```

- AndroidManifest.xml

```

 <key>FirebaseCrashlyticsCollectionEnabled</key>
 <false/>
```

## flutter_gen

- add `pubspec.yaml`

```
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

  build_runner: 
  flutter_gen_runner:

flutter_gen:
  output: lib/gen/ # Optional (default: lib/gen/)
  # line_length: 80 # Optional (default: 80)

  # Optional
  integrations:
    flutter_svg: true
  colors:
    inputs:
      - assets/colors.xml
```
