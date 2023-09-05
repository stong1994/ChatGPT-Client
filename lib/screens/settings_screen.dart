import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_gpt_client/extensions/context_extension.dart';
import 'package:open_gpt_client/models/app_settings.dart';
import 'package:open_gpt_client/models/local_data.dart';

/// The settings screen.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showApiKeyDialog(String apiKey) {
    showDialog(
      context: context,
      builder: (context) {
        final textController = TextEditingController(
          text: apiKey,
        );
        return AlertDialog(
          title: const Text('修改API密钥'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'API密钥',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                if (textController.text.isEmpty ||
                    textController.text == apiKey) {
                  context.pop();
                  return;
                }
                await LocalData.instance.setAPIKey(textController.text);

                if (!mounted) {
                  return;
                }

                context.pop();
                context.showSnackBar(
                  'API密钥已修改!',
                );
                setState(() {});
              },
              child: const Text(
                '保存',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: LocalData.instance.reducedApiKey,
              builder: (context, apiKeySnapshot) {
                if (!apiKeySnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final apiKey = apiKeySnapshot.data!;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'API秘钥 (OpenAI)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(apiKey),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              tooltip: '复制',
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: apiKey),
                                );
                                context.showSnackBar(
                                  'API密钥已复制到剪贴板',
                                );
                              },
                            ),
                            IconButton(
                              tooltip: '修改',
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showApiKeyDialog(apiKey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '生成图片 (DALL•E)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '使用DALL•E服务根据描述生成图像',
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text('图片尺寸: '),
                            DropdownButton<DallEImageSize>(
                              value: context
                                  .appState.value.settings.dallEImageSize,
                              onChanged: (value) async {
                                if (value == null ||
                                    value ==
                                        context.appState.value.settings
                                            .dallEImageSize) {
                                  return;
                                }

                                context.appState.value.settings.dallEImageSize =
                                    value;
                                LocalData.instance.saveAppSettings(
                                    context.appState.value.settings);
                                setState(() {});
                              },
                              items: DallEImageSize.values.map((size) {
                                return DropdownMenuItem(
                                  value: size,
                                  child: Text('${size.apiSize} (${size.cost})'),
                                );
                              }).toList(),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
