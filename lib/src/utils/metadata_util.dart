import 'package:html/parser.dart';

Map<String, String> parseMetadata(String html) => Map.fromEntries(
      parse(html)
          .head!
          .getElementsByTagName('meta')
          .where((e) =>
              e.attributes['name'] != null && e.attributes['content'] != null)
          .map(
              (e) => MapEntry(e.attributes['name']!, e.attributes['content']!)),
    );
