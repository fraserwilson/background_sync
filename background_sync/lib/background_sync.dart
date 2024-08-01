
import 'background_sync_platform_interface.dart';

class BackgroundSync {
  Future<String?> getPlatformVersion() {
    return BackgroundSyncPlatform.instance.getPlatformVersion();
  }
}
