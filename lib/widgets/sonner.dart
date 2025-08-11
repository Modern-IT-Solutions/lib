import 'package:flutter/material.dart';
import 'dart:async';

/// A simplified notification system for Flutter
/// 
/// This API provides a clean, simple way to show notifications with full control
/// over their content and behavior.
/// 
/// ## Usage
/// 
/// 1. Wrap your app with [NotificationProvider]:
/// ```dart
/// NotificationProvider(
///   child: MyApp(),
/// )
/// ```
/// 
/// 2. Show notifications using [showNotificationWithContext] (recommended):
/// ```dart
/// var notification = showNotificationWithContext(
///   context: context,
///   data: NotificationData(
///     title: "Super Notification",
///     body: "This is a test notification",
///     type: NotificationType.info,
///   ),
///   priority: NotificationPriority.high,
///   alignment: Alignment.bottomCenter,
///   builder: (context, data, notification) => ListTile(
///     title: Text(data.title ?? 'No title'),
///     subtitle: Text(data.body ?? 'No body'),
///     trailing: IconButton(
///       icon: Icon(Icons.close),
///       onPressed: () => notification.close(),
///     ),
///   ),
/// );
/// ```
/// 
/// 3. Control the notification:
/// ```dart
/// notification.replace(Text("Replaced content"));
/// notification.close();
/// ```
/// 
/// ## Features
/// 
/// - **Simple API**: Just one function to show notifications
/// - **Full Control**: Replace content, close, and manage notifications
/// - **Flexible Positioning**: Choose any alignment
/// - **Custom Widgets**: Build any widget you want
/// - **Direct Data Access**: Access notification data directly in the builder
/// - **Direct Instance Access**: The notification instance is passed to the builder
/// - **Smooth Animations**: Built-in slide and fade animations
/// 
/// ## Example with Progress
/// 
/// ```dart
/// var progressNotifier = ValueNotifier<double>(0.0);
/// 
/// var notification = showNotificationWithContext(
///   context: context,
///   data: NotificationData(title: "Upload Progress"),
///   builder: (context, data, notification) => Column(
///     children: [
///       Text(data.title ?? ''),
///       ValueListenableBuilder<double>(
///         valueListenable: progressNotifier,
///         builder: (context, progress, child) => LinearProgressIndicator(value: progress),
///       ),
///       IconButton(
///         icon: Icon(Icons.close),
///         onPressed: () => notification.close(),
///       ),
///     ],
///   ),
/// );
/// 
/// // Update progress
/// progressNotifier.value = 0.5;
/// ```

/// Types of notifications
enum NotificationType {
  info,
  warning,
  error,
}

/// Priority levels for notifications
enum NotificationPriority {
  low,    // Only shows in panel
  high,   // Shows floating (if panel not open) + panel
}

/// Data model for notifications
class NotificationData {
  const NotificationData({
    this.title,
    this.body,
    this.type = NotificationType.info,
  });

  final String? title;
  final String? body;
  final NotificationType type;
}

/// A notification instance that can be controlled
class SonnerNotification {
  SonnerNotification._({
    required this.id,
    required this.data,
    required this.priority,
    required this.alignment,
    required this.builder,
    required this.onClose,
    required this.onReplace,
    required this.onAnimatedClose,
  });

  final String id;
  final NotificationData data;
  final NotificationPriority priority;
  final Alignment alignment;
  final Widget Function(BuildContext, NotificationData, SonnerNotification) builder;
  final VoidCallback onClose;
  final void Function(Widget) onReplace;
  final Future<void> Function() onAnimatedClose;

  /// Replace the notification content
  void replace(Widget newWidget) {
    onReplace(newWidget);
  }

  /// Close the notification with animation
  Future<void> close() async {
    print('🔒 SonnerNotification.close() called for ID: $id');
    await onAnimatedClose();
  }

  /// Close the notification immediately (without animation)
  void closeImmediately() {
    onClose();
  }

  /// Access notification data from context
  static SonnerNotification? of(BuildContext context) {
    final notification = _NotificationInheritedWidget.of(context);
    print('🔍 SonnerNotification.of(context) called, result: $notification');
    return notification;
  }

  /// Access notification data from context (for backward compatibility)
  static NotificationData ofData(BuildContext context) {
    return of(context)?.data ?? const NotificationData();
  }
}

/// Show a notification and return a controllable instance
/// 
/// This function requires a BuildContext. Use this when you have access to context:
/// ```dart
/// var notification = showNotificationWithContext(
///   context: context,
///   data: NotificationData(title: "Hello"),
///   builder: (context, data, notification) => Text(data.title ?? "Hello"),
/// );
/// ```
SonnerNotification showNotificationWithContext({
  required BuildContext context,
  NotificationData? data,
  NotificationPriority priority = NotificationPriority.high,
  Alignment alignment = Alignment.bottomCenter,
  required Widget Function(BuildContext, NotificationData, SonnerNotification) builder,
}) {
  return NotificationProvider.of(context).showNotification(
    data: data,
    priority: priority,
    alignment: alignment,
    builder: builder,
  );
}

/// Show a notification and return a controllable instance
/// 
/// This function tries to use the global context. Make sure NotificationProvider is in the widget tree.
SonnerNotification showNotification({
  NotificationData? data,
  NotificationPriority priority = NotificationPriority.high,
  Alignment alignment = Alignment.bottomCenter,
  required Widget Function(BuildContext, NotificationData, SonnerNotification) builder,
}) {
  // Get the current context from the provider
  final context = NotificationProvider.currentContext;
  if (context == null) {
    throw StateError('NotificationProvider not found. Make sure to wrap your app with NotificationProvider.');
  }
  
  return NotificationProvider.of(context).showNotification(
    data: data,
    priority: priority,
    alignment: alignment,
    builder: builder,
  );
}

/// Extension to access notification data from context
extension NotificationExtension on BuildContext {
  NotificationData get notification => SonnerNotification.ofData(this);
}

/// Provider for notifications
class NotificationProvider extends StatefulWidget {
  const NotificationProvider({
    super.key,
    required this.child,
  });

  final Widget child;
  static BuildContext? currentContext;

  @override
  State<NotificationProvider> createState() => _NotificationProviderState();

  /// Access the notification provider from context
  static _NotificationProviderState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedNotificationProvider>()!.state;
  }
}

class _NotificationProviderState extends State<NotificationProvider> {
  final Map<String, SonnerNotification> _notifications = {};
  final Map<String, OverlayEntry> _overlayEntries = {};
  final Map<String, Widget> _currentWidgets = {};
  final Map<String, Future<void> Function()> _animateOutCallbacks = {}; // Store animation callbacks

  @override
  void initState() {
    super.initState();
    // Set the current context for global access
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationProvider.currentContext = context;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update current context when dependencies change
    NotificationProvider.currentContext = context;
  }

  /// Show a notification and return a controllable instance
  SonnerNotification showNotification({
    NotificationData? data,
    NotificationPriority priority = NotificationPriority.high,
    Alignment alignment = Alignment.bottomCenter,
    required Widget Function(BuildContext, NotificationData, SonnerNotification) builder,
  }) {
    final id = '${DateTime.now().millisecondsSinceEpoch}_${builder.hashCode}';
    final notificationData = data ?? const NotificationData();
    
    final notification = SonnerNotification._(
      id: id,
      data: notificationData,
      priority: priority,
      alignment: alignment,
      builder: builder,
      onClose: () => _closeNotification(id),
      onReplace: (newWidget) => _replaceNotification(id, newWidget),
      onAnimatedClose: () => _animateOut(id),
    );

    _notifications[id] = notification;
    _currentWidgets[id] = notification.builder(context, notificationData, notification);
    _showOverlay(id, notification);

    return notification;
  }

  /// Get current notification from context
  SonnerNotification? getCurrentNotification() {
    // This is a simplified version - in a real implementation you'd track the current context
    return _notifications.values.isNotEmpty ? _notifications.values.first : null;
  }

  void _showOverlay(String id, SonnerNotification notification) {
    final overlayEntry = OverlayEntry(
      builder: (context) => _NotificationOverlay(
        notification: notification,
        widget: _currentWidgets[id]!,
        onClose: () => _closeNotification(id),
        onAnimatedClose: () => _animateOut(id),
        onRegisterAnimateOut: (callback) => _animateOutCallbacks[id] = callback, // Register the callback
      ),
    );

    _overlayEntries[id] = overlayEntry;
    Overlay.of(context).insert(overlayEntry);
  }

  void _closeNotification(String id) {
    final overlayEntry = _overlayEntries.remove(id);
    overlayEntry?.remove();
    _notifications.remove(id);
    _currentWidgets.remove(id);
    _animateOutCallbacks.remove(id); // Clean up callback
  }

  void _replaceNotification(String id, Widget newWidget) {
    _currentWidgets[id] = newWidget;
    final overlayEntry = _overlayEntries[id];
    if (overlayEntry != null) {
      overlayEntry.markNeedsBuild();
    }
  }

  Future<void> _animateOut(String id) async {
    print('🎬 _animateOut called for ID: $id');
    // Call the registered animation callback
    final callback = _animateOutCallbacks[id];
    if (callback != null) {
      await callback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedNotificationProvider(
      state: this,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    for (final entry in _overlayEntries.values) {
      entry.remove();
    }
    _overlayEntries.clear();
    _notifications.clear();
    _currentWidgets.clear();
    _animateOutCallbacks.clear();
    super.dispose();
  }
}

class _InheritedNotificationProvider extends InheritedWidget {
  const _InheritedNotificationProvider({
    required this.state,
    required super.child,
  });

  final _NotificationProviderState state;

  @override
  bool updateShouldNotify(_InheritedNotificationProvider oldWidget) {
    return state != oldWidget.state;
  }
}

/// Overlay widget for notifications
class _NotificationOverlay extends StatefulWidget {
  const _NotificationOverlay({
    required this.notification,
    required this.widget,
    required this.onClose,
    required this.onAnimatedClose,
    required this.onRegisterAnimateOut,
  });

  final SonnerNotification notification;
  final Widget widget;
  final VoidCallback onClose;
  final Future<void> Function() onAnimatedClose;
  final void Function(Future<void> Function()) onRegisterAnimateOut;

  @override
  State<_NotificationOverlay> createState() => _NotificationOverlayState();
}

class _NotificationOverlayState extends State<_NotificationOverlay>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideController.forward();
    _fadeController.forward();
    
    // Register our animate out method with the provider
    widget.onRegisterAnimateOut(_animateOut);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  /// Animate out and then call the close callback
  Future<void> _animateOut() async {
    if (_isClosing) return;
    _isClosing = true;
    
    print('🎬 _NotificationOverlay._animateOut() called');
    
    // Animate out with slide and fade
    await Future.wait([
      _slideController.reverse(),
      _fadeController.reverse(),
    ]);
    
    print('✅ Animation complete, calling close callback');
    // Call the close callback to clean up
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return _NotificationInheritedWidget(
      notification: widget.notification,
      child: Positioned.fill(
        child: Align(
          alignment: widget.notification.alignment,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: widget.widget,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Inherited widget to provide notification data to the builder
class _NotificationInheritedWidget extends InheritedWidget {
  const _NotificationInheritedWidget({
    required this.notification,
    required super.child,
  });

  final SonnerNotification notification;

  @override
  bool updateShouldNotify(_NotificationInheritedWidget oldWidget) {
    return notification != oldWidget.notification;
  }

  static SonnerNotification? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_NotificationInheritedWidget>()?.notification;
  }
} 