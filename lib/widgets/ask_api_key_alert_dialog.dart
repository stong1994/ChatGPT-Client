import 'package:flutter/material.dart';
import 'package:open_chat/extensions/context_extension.dart';
import 'package:open_chat/models/local_data.dart';
import 'package:url_launcher/url_launcher.dart';

class AskAPIKeyAlertDialog extends StatefulWidget {
  const AskAPIKeyAlertDialog({super.key});

  @override
  State<AskAPIKeyAlertDialog> createState() => _AskAPIKeyAlertDialogState();
}

class _AskAPIKeyAlertDialogState extends State<AskAPIKeyAlertDialog> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('请设置API密钥'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '为了使用该服务，您需要提供有效的OpenAI API密钥',
          ),
          const Text(
            '如果您没有API密钥，您可以在这里申请：',
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                final uri =
                    Uri.parse('https://platform.openai.com/account/api-keys');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
              child: const Text(
                'https://platform.openai.com/account/api-keys',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'API密钥',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (controller.text.isEmpty) {
              return;
            }
            await LocalData.instance.setAPIKey(controller.text);
            if (context.mounted) {
              context.pop();
            }
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
