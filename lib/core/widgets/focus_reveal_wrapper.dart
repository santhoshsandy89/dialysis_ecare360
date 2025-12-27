import 'package:flutter/material.dart';

class FocusRevealWrapper extends StatefulWidget {
  final Widget child;
  final FocusNode focusNode;

  const FocusRevealWrapper({
    super.key,
    required this.child,
    required this.focusNode,
  });

  @override
  State<FocusRevealWrapper> createState() => _FocusRevealWrapperState();
}

class _FocusRevealWrapperState extends State<FocusRevealWrapper> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (widget.focusNode.hasFocus) {
      // Wait for the keyboard to animate into view
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && widget.focusNode.hasFocus) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: 0.1, // Scroll until the widget is slightly below the top (0.0 is top, 1.0 is bottom)
            // But usually we want it above the keyboard. alignmentPolicy or alignment helps.
            // Alignment 0.0 means the item is at the top of the viewport.
            // Alignment 1.0 means the item is at the bottom of the viewport.
            // We want it visible. By default ensureVisible brings it into the viewport.
            // Let's stick with default behavior first, or a specific alignment if needed.
            // 0.5 centers it? No, alignment is relative to the viewport.
            // Actually alignment maps the item's position to the viewport.
            // 0.0 = leading edge of item aligned w/ leading edge of viewport.
            // AlignmentPolicy.explicit with alignment is used.
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
