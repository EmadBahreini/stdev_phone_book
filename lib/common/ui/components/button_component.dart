import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phone_book/common/style/colorPalette/color_palette_helper.dart';
import 'package:phone_book/common/ui/components/simple_switcher_component.dart';
import 'package:phone_book/common/utils/logs/log_helper.dart';

import '../widgets/loading_widget.dart';

enum ButtonType { primary, secondary }

class ButtonComponent extends StatefulWidget {
  const ButtonComponent({
    required this.onPressed,
    this.text,
    this.child,
    bool widthFromHeight = false,
    double? width,
    this.enabled = true,
    this.loading,
    this.height = 48,
    this.color,
    this.disabledColor,
    this.maxWidth,
    this.minWidth,
    this.borderSide = BorderSide.none,
    this.type = ButtonType.primary,
    Key? key,
    this.icon,
    this.iconSize = 20,
    this.foregroundColor,
    this.margin,
    this.disableElevation = false,
  })  : width = widthFromHeight ? height : (width ?? double.infinity),
        super(key: key);

  final Widget? child;
  final String? text;
  final AsyncCallback onPressed;
  final bool enabled;
  final bool? loading;
  final double width;
  final double height;
  final Color? color;
  final Color? disabledColor;
  final double? maxWidth;
  final double? minWidth;
  final BorderSide borderSide;
  final ButtonType type;
  final IconData? icon;
  final EdgeInsets? margin;
  final double iconSize;
  final Color? foregroundColor;
  final bool disableElevation;

  @override
  State<ButtonComponent> createState() => CinButtonState();
}

class CinButtonState extends State<ButtonComponent> {
  bool loading = false;

  bool get finalLoading => widget.loading ?? loading;

  @override
  Widget build(BuildContext context) => Container(
        height: widget.height,
        width: widget.width,
        margin: widget.margin,
        constraints: BoxConstraints(
          maxWidth: widget.maxWidth == null ? double.infinity : widget.maxWidth!,
          minWidth: widget.minWidth == null ? 0 : widget.minWidth!,
        ),
        child: ElevatedButton(
          onPressed: widget.enabled
              ? (!finalLoading && widget.enabled
                  ? () async {
                      if (mounted) {
                        setState(() => loading = true);
                      }
                      FocusScope.of(context).requestFocus(FocusNode());
                      try {
                        await widget.onPressed();
                      } catch (e) {
                        errorLog();
                      }
                      if (mounted) {
                        setState(() => loading = false);
                      }
                    }
                  : () {})
              : null,
          style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                elevation: widget.disableElevation
                    ? MaterialStateProperty.all(0)
                    : MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                        if (widget.type == ButtonType.secondary || finalLoading || !widget.enabled) {
                          return 0;
                        } else if (states.contains(MaterialState.hovered) ||
                            states.contains(MaterialState.pressed) ||
                            states.contains(MaterialState.focused) ||
                            states.contains(MaterialState.dragged)) {
                          return 0;
                        } else {
                          return 6;
                        }
                      }),
                overlayColor: widget.disableElevation ? MaterialStateProperty.all(null) : null,
                backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) =>
                    states.contains(MaterialState.disabled)
                        ? (widget.type == ButtonType.primary
                            ? widget.disabledColor ?? Theme.of(context).primaryColor.withOpacity(0.1)
                            : widget.disabledColor ?? context.colors.background.withOpacity(0.45))
                        : widget.color ??
                            (widget.type == ButtonType.primary
                                ? Theme.of(context).primaryColor
                                : context.colors.background)),
                shadowColor: MaterialStateProperty.all((widget.color ?? context.colors.primary).withOpacity(0.6)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: (widget.enabled && !finalLoading)
                        ? widget.borderSide
                        : widget.borderSide.copyWith(color: context.colors.divider),
                  ),
                ),
                padding: MaterialStateProperty.all(const EdgeInsets.all(4)),
              ),
          child: Builder(builder: (_) {
            Color foregroundColor = widget.foregroundColor ??
                (widget.type == ButtonType.primary
                    ? context.colors.white
                    : widget.enabled
                        ? context.colors.textCaption
                        : context.colors.textDisabled);
            return SimpleSwitcherComponent(
              child: finalLoading
                  ? Center(
                      key: const Key('loading'),
                      child: LoadingWidget(color: foregroundColor, size: widget.height / 3),
                    )
                  : (widget.child ??
                      Center(
                        key: const Key('normal'),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: <Widget>[
                            if (widget.icon != null) Icon(widget.icon, size: widget.iconSize, color: foregroundColor),
                            if (widget.text != null)
                              Text(widget.text!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(color: foregroundColor, fontWeight: FontWeight.normal)),
                          ],
                        ),
                      )),
            );
          }),
        ),
      );
}
