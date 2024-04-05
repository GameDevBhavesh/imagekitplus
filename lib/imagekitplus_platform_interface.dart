import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'imagekitplus_method_channel.dart';

abstract class ImagekitplusPlatform extends PlatformInterface {
  /// Constructs a ImagekitplusPlatform.
  ImagekitplusPlatform() : super(token: _token);

  static final Object _token = Object();

  static ImagekitplusPlatform _instance = MethodChannelImagekitplus();

  /// The default instance of [ImagekitplusPlatform] to use.
  ///
  /// Defaults to [MethodChannelImagekitplus].
  static ImagekitplusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ImagekitplusPlatform] when
  /// they register themselves.
  static set instance(ImagekitplusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Uint8List?> removeBackground(Uint8List img) {
    print("removeBackground");
    throw UnimplementedError('removeBackground() has not been implemented.');
  }

  Future<List<dynamic>?> classifyImage(Uint8List img) {
    print("removeBackground");
    throw UnimplementedError('removeBackground() has not been implemented.');
  }

  Future<List<dynamic>> recognizeText(Uint8List img) {
    print("removeBackground");
    throw UnimplementedError('removeBackground() has not been implemented.');
  }
}
