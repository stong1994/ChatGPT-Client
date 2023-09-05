import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:open_gpt_client/extensions/context_extension.dart';
import 'package:open_gpt_client/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionNewsDialog extends StatelessWidget {
  const VersionNewsDialog({Key? key}) : super(key: key);

  void _openGithubIssue() async {
    final uri =
        Uri.parse('https://github.com/dariowskii/open_gpt_client/issues/3');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('版本新功能 - ${Constants.appVersion}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• 使用DALL•E生成图像！ 🤖',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text.rich(
            TextSpan(
              text: '   选择 ',
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.settings,
                    size: 16,
                  ),
                ),
                TextSpan(
                  text: ' 设置 ',
                ),
                WidgetSpan(
                  child: Icon(
                    Icons.arrow_right,
                    size: 16,
                  ),
                ),
                TextSpan(
                  text: ' 生成图像 (DALL•E) 用于设置生成图像的大小（以及相应的成本）',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              text: '• 在初始阶段修复了密码生成中的一个错误。 (',
              style: const TextStyle(
                fontSize: 16,
              ),
              children: [
                WidgetSpan(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.bug_report,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
                TextSpan(
                    text: '#3',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = _openGithubIssue),
                const TextSpan(
                  text: ')',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '• 性能改进.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('好的，关闭'),
        ),
      ],
    );
  }
}
