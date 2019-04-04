import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';

class OBLoadingTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title: Center(
        child: OBProgressIndicator(),
      ),
    );
  }
}
