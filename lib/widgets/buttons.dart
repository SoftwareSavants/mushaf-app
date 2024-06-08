import 'package:flutter/material.dart';

enum AppButtonStyle {
  primary,
  secondary,
  outline,
  text,
  textPrimary,
  error,
  errorOutline,
  disabled,
}

extension on AppButtonStyle {
  Color background(BuildContext context) {
    switch (this) {
      case AppButtonStyle.primary:
        return Theme.of(context).primaryColor;
      case AppButtonStyle.secondary:
        return Theme.of(context).colorScheme.secondary;
      case AppButtonStyle.text:
      case AppButtonStyle.textPrimary:
        return Colors.transparent;
      case AppButtonStyle.error:
        return Theme.of(context).errorColor;
      case AppButtonStyle.outline:
      case AppButtonStyle.errorOutline:
        return Colors.transparent;
      case AppButtonStyle.disabled:
        return Theme.of(context).disabledColor;
    }
  }

  Color textColor(BuildContext context) {
    switch (this) {
      case AppButtonStyle.primary:
        return Theme.of(context).colorScheme.onPrimary;
      case AppButtonStyle.secondary:
        return Theme.of(context).colorScheme.secondary;
      case AppButtonStyle.textPrimary:
        return Theme.of(context).primaryColor;
      case AppButtonStyle.outline:
      case AppButtonStyle.text:
        return Theme.of(context).colorScheme.onBackground;
      case AppButtonStyle.error:
        return Theme.of(context).colorScheme.onPrimary;
      case AppButtonStyle.errorOutline:
        return Theme.of(context).colorScheme.error;
      case AppButtonStyle.disabled:
        return Colors.white70;
    }
  }

  bool get isText =>
      this == AppButtonStyle.text || this == AppButtonStyle.textPrimary;
  bool get isOutline => this == AppButtonStyle.outline;
  bool get isError =>
      this == AppButtonStyle.error || this == AppButtonStyle.errorOutline;
}

enum AppButtonPadding { thin, normal }

extension on AppButtonPadding {
  EdgeInsets get value {
    switch (this) {
      case AppButtonPadding.thin:
        return const EdgeInsets.symmetric(vertical: 8, horizontal: 16);
      case AppButtonPadding.normal:
        return const EdgeInsets.symmetric(vertical: 16, horizontal: 16);
    }
  }
}

class AppButton extends StatelessWidget {
  final String labelText;
  final Widget? icon;
  final VoidCallback? onPressed;
  final AppButtonPadding padding;
  final EdgeInsetsGeometry margin;
  final bool disabled;
  final AppButtonStyle style;
  final BorderRadius? borderRadius;
  final Color? background;
  final Color? textColor;

  const AppButton({
    Key? key,
    required this.labelText,
    this.onPressed,
    this.icon,
    this.padding = AppButtonPadding.normal,
    this.margin = EdgeInsets.zero,
    this.disabled = false,
    this.style = AppButtonStyle.primary,
    this.borderRadius,
    this.background,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = disabled ? AppButtonStyle.disabled : this.style;

    final buttonStyle = ElevatedButton.styleFrom(
      foregroundColor: textColor ?? style.textColor(context), padding: padding.value, backgroundColor: background ?? style.background(context),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(8.0),
        side: style.isOutline || style.isError
            ? BorderSide(
                color: style.isError
                    ? Theme.of(context).errorColor
                    : Theme.of(context).primaryColor,
                width: 2,
              )
            : BorderSide.none,
      ),
      textStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
            color: textColor ?? style.textColor(context),
          ),
      elevation: style.isText || style.isOutline || style.isError ? 0 : 4,
      shadowColor: Colors.black54,
    );

    return Padding(
      padding: margin,
      child: icon != null
          ? ElevatedButton.icon(
              onPressed: disabled ? () {} : onPressed ?? () {},
              icon: icon!,
              style: buttonStyle,
              label: Text(labelText, textAlign: TextAlign.center),
            )
          : ElevatedButton(
              onPressed: disabled ? () {} : onPressed ?? () {},
              style: buttonStyle,
              child: Text(labelText, textAlign: TextAlign.center),
            ),
    );
  }
}
