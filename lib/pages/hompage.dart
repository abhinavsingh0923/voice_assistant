import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant/api_request/request.dart';
import 'package:voice_assistant/property/color_packet.dart';
import 'package:voice_assistant/widgets/featuers_list.dart';

class MyHomepage extends StatefulWidget {
  const MyHomepage({super.key});

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
final speechTotext = SpeechToText();
final flutterTts = FlutterTts();
String lastWords = '';
final openai _openai = openai();
String? generatedcontent;
String? generatedimageurl;


  @override
  void initState() {
    super.initState();
    initspeechtotext();
    inittexttospeech();
  }
  Future<void> inittexttospeech() async{
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }
  Future<void> initspeechtotext() async{
    await speechTotext.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechTotext.listen(onResult: onSpeechResult);
    setState(() {});
  }


  Future<void> stopListening() async {
    await speechTotext.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemspeak(String content) async{
    await flutterTts.speak(content);
  }
  @override
  void dispose() {
    super.dispose();
    speechTotext.stop();
    flutterTts.stop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alex'),
        centerTitle: true,
        leading: const Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 150,
                    width: 150,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: const BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  height: 150,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/images/boss.png'))),
                )
              ],
            ),
            Visibility(
              visible: generatedimageurl == null,
              child: Container(
                margin: const EdgeInsets.only(top: 15, right: 30, left: 30),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10)
                    .copyWith(top: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Pallete.mainborderColor,
                  ),
                  borderRadius: BorderRadius.circular(20).copyWith(
                    topLeft: Radius.zero,
                  ),
                ),
                child:  Padding(
                  padding:const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    generatedcontent ==null ?
                    'Hello sir, Tell me how can i help you.' : generatedcontent!,
                    style: TextStyle(
                        fontFamily: 'Karla-Medium',
                        color: Pallete.mainFontColor,
                        fontSize:generatedcontent == null ? 20 : 17),
                  ),
                ),
              ),
            ),
            if(generatedimageurl != null)
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: ClipRRect(borderRadius:BorderRadius.circular(20),child: Image.network(generatedimageurl!)),
            ),
            Visibility(
              visible: generatedcontent == null && generatedimageurl == null,
              child: Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 10, left: 30, right: 80),
                child: const Text(
                  'Some of the features mentioned here.',
                  style: TextStyle(
                    fontFamily: 'karla',
                    color: Pallete.mainFontColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
             Visibility(
              visible: generatedcontent == null && generatedimageurl == null,
               child:const Column(
                children: [
                  Myfeaturelist(
                      color: Pallete.firstSuggestionBoxColor,
                      heading: 'ChatGPT',
                      description:
                          "It is use to create humanlike conversational dialogue. "),
                  Myfeaturelist(
                      color: Pallete.secondSuggestionBoxColor,
                      heading: "Dall-E",
                      description:
                          "The DALL-E 2 is free to try, thanks to OpenAI's generous trial credit scheme"),
                  Myfeaturelist(
                      color: Pallete.thirdSuggestionBoxColor,
                      heading: 'Voice assistant',
                      description:
                          "It's software that carries out everyday tasks via voice command.")
                ],
                         ),
             )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          if(await speechTotext.hasPermission && speechTotext.isNotListening){
            await startListening();
          }
          else if(speechTotext.isListening){
            final speech = await _openai.isnotgpt(lastWords);
            if(speech.contains('https')){
              generatedcontent = null;
              generatedimageurl = speech;
              setState(() {});
            }else{
              generatedcontent = speech;
              generatedimageurl = null;
              setState(() {});
              await systemspeak(speech);
            }
            await stopListening();
          }
          else{
            initspeechtotext();
          }
        },
        child:  Icon(speechTotext.isListening ? Icons.stop : Icons.mic),
      ),
    );
  }
}
