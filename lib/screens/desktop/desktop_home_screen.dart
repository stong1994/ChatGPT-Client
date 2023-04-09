import 'package:flutter/material.dart';
import 'package:open_gpt_client/models/api_client.dart';
import 'package:open_gpt_client/models/chat.dart';
import 'package:open_gpt_client/models/local_data.dart';
import 'package:open_gpt_client/screens/desktop/sidebar_home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_gpt_client/utils/app_bloc.dart';
import 'package:open_gpt_client/widgets/chat_message_ui.dart';
import 'package:uuid/uuid.dart';

class DesktopHomeScreen extends StatefulWidget {
  const DesktopHomeScreen({super.key});

  @override
  State<DesktopHomeScreen> createState() => _DesktopHomeScreenState();
}

class _DesktopHomeScreenState extends State<DesktopHomeScreen> {
  final _textController = TextEditingController();
  final _fieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final appState = AppBloc.of(context).appState;
    final appLocals = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        elevation: 5,
      ),
      body: Row(
        children: [
          const SizedBox(
            width: 250,
            child: SidebarHome(),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${appLocals.model}: '),
                        const Text(
                          'gpt-3.5-turbo-0301',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${appLocals.messagesInContext}: ',
                        ),
                        ValueListenableBuilder(
                          valueListenable: appState,
                          builder: (context, state, _) {
                            return Text(
                              state.selectedChat?.contextMessages.length
                                      .toString() ??
                                  '0',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: appState,
                    builder: (context, state, _) {
                      if (state.selectedChat == null) {
                        return const Expanded(
                          child: SizedBox.shrink(),
                        );
                      }
                      final selectedChat = state.selectedChat!;

                      if (selectedChat.messages.isEmpty) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              appLocals.noMessages,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      final reversedList =
                          selectedChat.messages.reversed.toList();

                      return Expanded(
                        child: ListView.separated(
                          addAutomaticKeepAlives: false,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          itemCount: selectedChat.messages.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            final message = reversedList[index];
                            return ChatMessageUI(
                              key: message.uniqueKeyUI,
                              message: message,
                              messageIsInContext:
                                  appState.messageIsInContext(message),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 8,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ValueListenableBuilder(
                        valueListenable: appState,
                        builder: (context, currentState, _) {
                          return TextField(
                            maxLines: 10,
                            minLines: 1,
                            maxLength: 1000,
                            controller: _textController,
                            focusNode: _fieldFocusNode,
                            enabled: currentState.selectedChat != null,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(gapPadding: 12),
                              hintText: appLocals.dasboardFieldInput,
                              suffix: Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final trimmedText =
                                        _textController.text.trim();
                                    if (currentState.selectedChat != null &&
                                        trimmedText.isNotEmpty) {
                                      final message = ChatMessage(
                                        id: const Uuid().v4(),
                                        senderRole: MessageSenderRole.user,
                                        content: trimmedText,
                                      );
                                      appState.addToSelectedAndContext(message);

                                      LocalData.instance
                                          .saveAppState(currentState);

                                      _textController.clear();
                                      _fieldFocusNode.unfocus();
                                      appState.addMessageToSelectedChat(
                                        ChatMessage(
                                          id: const Uuid().v4(),
                                          uniqueKeyUI:
                                              GlobalKey<ChatMessageUIState>(),
                                          senderRole:
                                              MessageSenderRole.assistant,
                                          content: '',
                                          isLoadingResponse: true,
                                        ),
                                      );

                                      final response = await ApiClient()
                                          .sendMessages(
                                              currentState.selectedChat!);
                                      if (response != null) {
                                        appState.attachStreamToLastResponse(
                                            response);
                                      }
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(appLocals.send),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.send, size: 15),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}