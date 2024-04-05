import 'package:flutter/foundation.dart';
import 'package:imagekitplus/imagekitplus_method_channel.dart';

import 'imagekitplus_platform_interface.dart';

class Imagekitplus {
  static Future<String?> getPlatformVersion() {
    return ImagekitplusPlatform.instance.getPlatformVersion();
  }

  static Future<Uint8List?> removeBackround(Uint8List img) {
    return (ImagekitplusPlatform.instance as MethodChannelImagekitplus)
        .removeBackground(img);
  }

  static Future<List<dynamic>> recognizeText(Uint8List img) {
    return (ImagekitplusPlatform.instance as MethodChannelImagekitplus)
        .recognizeText(img);
  }

  static Future<List<dynamic>?> classifyImage(Uint8List img) {
    return (ImagekitplusPlatform.instance as MethodChannelImagekitplus)
        .classifyImage(img);
  }
}
