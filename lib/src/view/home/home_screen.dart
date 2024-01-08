import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_gpt_demo/src/model/chat_model.dart';
import 'package:chat_gpt_demo/src/network/network_utils.dart';
import 'package:chat_gpt_demo/src/services/tts.dart';
import 'package:chat_gpt_demo/src/view/base/k_scroll_behavior.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../utils/colors.dart';
import '../../utils/strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpeechToText _speechToText = SpeechToText();
  bool _isSpeaking = false;
  String _text = 'Hold the button and start speaking';
  final List<ChatMessage> message = [];
  final ScrollController _scrollController = ScrollController();

  scrollMethod() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 70,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.sort_rounded),
        title: const Text(appName),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              _text,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: _isSpeaking ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: kBlack,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ScrollConfiguration(
                  behavior: KScrollBehavior(),
                  child: ListView.separated(
                    // physics: const BouncingScrollPhysics(),
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: message.length,
                    itemBuilder: (context, index) {
                      var msg = message[index];
                      return _chatBubble(msg);
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Developed By @Rifat Hossain',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        duration: const Duration(milliseconds: 2000),
        glowColor: appColor,
        repeat: true,
        startDelay: const Duration(milliseconds: 100),
        animate: true,
        child: GestureDetector(
          onTapDown: (_) async {
            if (!_isSpeaking) {
              bool isAvailable = await _speechToText.initialize();
              if (isAvailable) {
                setState(() {
                  _isSpeaking = true;
                  _speechToText.listen(onResult: (result) {
                    setState(() {
                      _text = result.recognizedWords;
                      scrollMethod();
                    });
                  });
                });
              }
            }
          },
          onTapUp: (_) async {
            setState(() {
              _isSpeaking = false;
            });
            _speechToText.stop();

            if (_text.isNotEmpty &&
                _text != "Hold the button and start speaking") {
              message.add(ChatMessage(_text, ChatMessageType.user));
              var msg = await Network.sendMessage(_text);
              msg = msg.toString().trim();
              setState(() {
                message.add(ChatMessage(msg, ChatMessageType.bot));
              });



              /// to speak
              try{
                Future.delayed(
                  const Duration(milliseconds: 300),
                      () {
                    scrollMethod();
                    TextToSpeech.speak(msg);
                  },
                );
              } catch(e){
                print('Device Issue!');
              }
            } else {
              print('Failed To Fetch Data!');
            }
          },
          child: CircleAvatar(
            maxRadius: 35,
            backgroundColor: kWhite.withOpacity(0.9),
            child: Icon(
              _isSpeaking ? Icons.mic : Icons.mic_none,
              color: appColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _chatBubble(ChatMessage message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        message.type == ChatMessageType.bot ? CircleAvatar(
          backgroundColor: appColor,
          backgroundImage: AssetImage('assets/chatGpt_icon.jpg'),
        ) :
        CircleAvatar(
          backgroundColor: appColor,
          child: Icon(
                  Icons.person,
                  color: kWhite,
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
                color: message.type == ChatMessageType.bot ? appColor : kWhite,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),),
            child: Text(
              message.text ?? '',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: message.type == ChatMessageType.bot ? kWhite : kBlack,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
