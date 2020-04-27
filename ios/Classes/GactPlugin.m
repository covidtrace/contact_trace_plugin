#import "GactPlugin.h"
#if __has_include(<gact_plugin/gact_plugin-Swift.h>)
#import <gact_plugin/gact_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "gact_plugin-Swift.h"
#endif

@implementation GactPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGactPlugin registerWithRegistrar:registrar];
}
@end
