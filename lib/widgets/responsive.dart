/// [ResponsiveWidget] is a widget that makes the child widget responsive in all screen sizes.
/// 
/// it takes 
/// * [child] as a widget that is used to show the widget.
/// * [Map<ScreenSize, double>] as a map that contains the screen sizes and the width of the widget in that screen size.
/// * [useParentWidth] as a boolean value that determines whether the widget should use the parent width or hole screen width.
/// * [showOn] as a list of [ScreenSize] that determines the screen sizes that the widget should be shown on.
/// * [hideOn] as a list of [ScreenSize] that determines the screen sizes that the widget should be hidden on.
// class 








/// [ResponsiveSize] 
// class ResponsiveSize {
//   /// [ScreenSize] is a [ScreenSize] value that determines the screen size.
//   final ScreenSize screenSize;
//   /// [width] is a double value that determines the width of the widget.
//   final double width;
//   /// [height] is a double value that determines the height of the widget.
//   final double height;

//   const ResponsiveSize({
//     required this.screenSize,
//     required this.width,
//     required this.height,
//   });
// }



/// ScreenSize
enum ScreenSize {
  /// all
  all,

  /// none
  none,

  /// small screen size
  s,

  /// medium screen size
  m,

  /// large screen size
  l,

  /// extra large screen size
  xl,

  /// extra extra large screen size
  xxl,
}