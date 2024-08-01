import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'background_sync_platform_interface.dart';

/// An implementation of [BackgroundSyncPlatform] that uses method channels.
class MethodChannelBackgroundSync extends BackgroundSyncPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('background_sync');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
