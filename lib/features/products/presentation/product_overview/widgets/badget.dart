import 'package:ecomerce/core/resources/vlaue_manager.dart';
import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key? key,
    required this.child,
    required this.value,
    this.color,
  }) : super(key: key);

  final Widget child;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(AppPadding.p2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.s12),
              color: Theme.of(context).primaryColorDark,
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppSize.s12,
              ),
            ),
          ),
        )
      ],
    );
  }
}
