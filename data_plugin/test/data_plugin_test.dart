import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_plugin/data_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('data_plugin');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await DataPlugin.platformVersion, '42');
  });
}
