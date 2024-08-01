import 'package:flutter_test/flutter_test.dart';
import 'package:background_sync/background_sync.dart';
import 'package:background_sync/background_sync_platform_interface.dart';
import 'package:background_sync/background_sync_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBackgroundSyncPlatform
    with MockPlatformInterfaceMixin
    implements BackgroundSyncPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BackgroundSyncPlatform initialPlatform = BackgroundSyncPlatform.instance;

  test('$MethodChannelBackgroundSync is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBackgroundSync>());
  });

  test('getPlatformVersion', () async {
    BackgroundSync backgroundSyncPlugin = BackgroundSync();
    MockBackgroundSyncPlatform fakePlatform = MockBackgroundSyncPlatform();
    BackgroundSyncPlatform.instance = fakePlatform;

    expect(await backgroundSyncPlugin.getPlatformVersion(), '42');
  });
}
