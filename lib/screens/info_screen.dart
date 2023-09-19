import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:open_chat/utils/constants.dart';
import 'package:open_chat/widgets/support_me_card.dart';
import 'package:url_launcher/url_launcher.dart';

/// The info screen.
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  void _openGithubRepo() async {
    final uri = Uri.parse('https://github.com/stong1994/ChatGPT-Client');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ChatGPT Client',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text.rich(
                TextSpan(
                  text: 'ChatGPT Client 是一款 ',
                  children: [
                    TextSpan(
                      text: '开源',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' 软件 ',
                    ),
                    TextSpan(
                      text: ' 它允许你与OpenAI的API进行交互（特别是GPT API ',
                    ),
                    TextSpan(
                      text: 'ChatGPT 3.5',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ') 以简单且免费的方式进行交互 ',
                    ),
                    TextSpan(
                      text: '不收集个人数据.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text.rich(
                TextSpan(
                  text: '所有本地保存的数据都使用算法进行加密 ',
                  children: [
                    TextSpan(
                      text: 'AES-256',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' 而且这些数据不会被发送到远程服务器.',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  text: '源代码可在以下位置找到 ',
                  children: [
                    TextSpan(
                      text: 'GitHub',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = _openGithubRepo,
                    ),
                    const TextSpan(
                      text: ' \n源代码是可用的 ',
                    ),
                    const TextSpan(
                      text: '可以进行修改',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: ' 或者 ',
                    ),
                    const TextSpan(
                      text: '报告错误',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: '.',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // const Text(
              //   'Supporta il progetto',
              //   style: TextStyle(
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              const SizedBox(height: 16),
              // const SupportMeCard(),
              const SizedBox(height: 16),
              const Text('version: ${Constants.appVersion}')
            ],
          ),
        ),
      ),
    );
  }
}
