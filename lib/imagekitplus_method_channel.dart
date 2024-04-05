import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'imagekitplus_platform_interface.dart';

/// An implementation of [ImagekitplusPlatform] that uses method channels.
class MethodChannelImagekitplus extends ImagekitplusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('imagekitplus');

  @override
  Future<String?> getPlatformVersion() async {
    print("getPlatformVersion 3");
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    print("getPlatformVersion 3 end");
    return version;
  }

  @override
  Future<Uint8List?> removeBackground(Uint8List img) async {
    print("removeBackground 3");
    final bytes =
        await methodChannel.invokeMethod<Uint8List>('removeBackground', img);
    print("removeBackground complete");
    return bytes;
  }

  @override
  Future<List<dynamic>> classifyImage(Uint8List img) async {
    print("classifyImage started");
    final bytes =
        await methodChannel.invokeMethod<List<dynamic>>('classifyImage', img);
    print("classifyImage complete");
    return bytes!;
  }

  @override
  Future<List<dynamic>> recognizeText(Uint8List img) async {
    print("classifyImage started");
    final text =
        await methodChannel.invokeMethod<List<dynamic>>('classifyImage', img);
    print("classifyImage complete");
    return text!;
  }
}
