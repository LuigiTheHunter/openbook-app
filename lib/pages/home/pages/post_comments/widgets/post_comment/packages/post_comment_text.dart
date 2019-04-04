import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OBPostCommentText extends StatelessWidget {
  final PostComment postComment;
  final VoidCallback onUsernamePressed;
  final Widget badge;
  ToastService _toastService;
  BuildContext _context;

  OBPostCommentText(this.postComment,
      {Key key, this.onUsernamePressed, this.badge})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;

    _toastService = openbookProvider.toastService;
    _context = context;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: GestureDetector(
                        onTap: onUsernamePressed,
                        child: Text(
                          postComment.getCommenterUsername(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: themeValueParserService
                                  .parseColor(theme.primaryTextColor),
                              fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        )),
                  ),
                  badge == null
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: badge,
                        ),
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: GestureDetector(
                       onLongPress: _copyText,
                       child:_getActionableSmartText(postComment.isEdited),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  Widget _getActionableSmartText(bool isEdited) {
    if (isEdited) {
      return OBActionableSmartText(
          text: postComment.text,
          trailingSmartTextElement: SecondaryTextElement(' (edited)')
      );
    } else {
      return OBActionableSmartText(
          text: postComment.text
      );
    }
  }

  void _copyText(){
    Clipboard.setData(ClipboardData(text: postComment.text));
    _toastService.toast(message: 'Text copied!', context: _context, type: ToastType.info);
  }
}
