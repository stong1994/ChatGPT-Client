import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_gpt_client/extensions/context_extension.dart';
import 'package:open_gpt_client/models/chat.dart';
import 'package:open_gpt_client/models/local_data.dart';
import 'package:uuid/uuid.dart';

class AddChatButton extends StatelessWidget {
  const AddChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.appState;
    final appLocals = context.appLocals;

    return ValueListenableBuilder(
      valueListenable: appState,
      builder: (context, state, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: state.isGenerating
                ? null
                : () async {
                    final chat = await showChatDialog(context);
                    if (chat != null) {
                      appState.addAndSelectChat(chat);
                      await LocalData.instance.saveChat(chat);
                      await LocalData.instance
                          .saveAppSettings(appState.value.settings);
                    }
                  },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add),
                const SizedBox(width: 8),
                Text(appLocals.addChat),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Chat?> showChatDialog(BuildContext context) async {
    String chatTitle = '';
    String systemPrompt = '';
    int maxContextLength = 0;

    return showDialog<Chat>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('设置聊天'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  chatTitle = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                onChanged: (value) {
                  systemPrompt = value;
                },
                decoration: const InputDecoration(
                  labelText: 'System Prompt',
                ),
              ),
              TextField(
                onChanged: (value) {
                  maxContextLength = int.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(
                  labelText: 'Max Context Length',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                final chat = Chat(
                  id: const Uuid().v4(),
                  title: chatTitle,
                  systemPrompt: systemPrompt,
                  maxContextLength: maxContextLength,
                  messages: [],
                  contextMessages: [],
                );
                Navigator.of(dialogContext).pop(chat);
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }
}
