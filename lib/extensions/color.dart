import 'dart:ui';

/// toStringWeb() is extension method for [Color] class
/// to convert [Color] to [String] in web format
extension ColorToStringWeb on Color {
  String toStringWeb() {
    return '#${value.toRadixString(16).substring(2)}';
  }
}
