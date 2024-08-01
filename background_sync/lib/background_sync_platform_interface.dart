import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'background_sync_method_channel.dart';

abstract class BackgroundSyncPlatform extends PlatformInterface {
  /// Constructs a BackgroundSyncPlatform.
  BackgroundSyncPlatform() : super(token: _token);

  static final Object _token = Object();

  static BackgroundSyncPlatform _instance = MethodChannelBackgroundSync();

  /// The default instance of [BackgroundSyncPlatform] to use.
  ///
  /// Defaults to [MethodChannelBackgroundSync].
  static BackgroundSyncPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BackgroundSyncPlatform] when
  /// they register themselves.
  static set instance(BackgroundSyncPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
