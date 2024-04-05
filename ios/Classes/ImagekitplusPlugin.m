#import "ImagekitplusPlugin.h"
#if __has_include(<imagekitplus/imagekitplus-Swift.h>)
#import <imagekitplus/imagekitplus-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "imagekitplus-Swift.h"
#endif

@implementation ImagekitplusPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftImagekitplusPlugin registerWithRegistrar:registrar];
}
@end
