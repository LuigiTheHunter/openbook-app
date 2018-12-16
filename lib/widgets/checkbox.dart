import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final OBCheckboxSize size;

  const OBCheckbox({
    Key key,
    this.value,
    this.onChanged,
    this.size = OBCheckboxSize.medium,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(50)),
        child: Center(
          child: OBIcon(
            value ? OBIcons.checkCircleSelected : OBIcons.checkCircle,
            themeColor: value ? OBIconThemeColor.primaryAccent : null,
          ),
        ),
      ),
    );
  }
}

enum OBCheckboxSize { medium }