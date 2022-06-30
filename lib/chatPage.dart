import 'dart:async';

import 'package:chatbot/http_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


List<String> _messages = <String>[];
String currMessage = "";
ScrollController _scrollController = ScrollController();
TextEditingController _messageController = TextEditingController();
Future<String> reply  = "" as Future<String> ;

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  // imported from http_service.dart
  final HttpService httpService = HttpService();



  Future<void> addReply(String userMessage) async{
    final String reply = await  httpService.GetReply(userMessage);
    setState(() {
      _messages.add(reply);
      Timer(
        Duration(milliseconds:300),
            ()=>_scrollController.jumpTo(_scrollController.position.maxScrollExtent),
      );
    });
  }

  Widget getMessageList(var width){
    var listItems = _messages;
    var listView = ListView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      // physics: NeverScrollableScrollPhysics(),
      itemCount: listItems.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment : index%2==1 ? MainAxisAlignment.start:MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                constraints: BoxConstraints(
                  maxWidth: 0.7*width,
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    index%2==1 ? Text("Bot",
                      style: TextStyle(color: Colors.blue,fontSize: 16),) : SizedBox(height:0),
                    Text(
                      listItems[index],
                      style : TextStyle(
                        fontSize: 16,
                      ),

                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                      color : Colors.black
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
              )
            ],
          ),
        );

      },
    );
    return listView;
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).viewPadding;
    var height = MediaQuery.of(context).size.height-padding.top-padding.top;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(

        backgroundColor: const Color(0xFFded7d1),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: 0.1*height,
          title: Text("ChatBot"),
        ),
        body : Column(
          children: <Widget>[
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('Images/bot_bg.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: getMessageList(width))
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.fromLTRB(10,0,0,0),
              height: 0.075*height,
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 0.8*width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                        onChanged: (text){
                          setState(() {
                            currMessage = text;
                          });
                        },
                        controller : _messageController,
                        decoration: InputDecoration(
                          hintText: "enter your message",
                          contentPadding: EdgeInsets.fromLTRB(10,0,0,0),
                        )
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.teal[700],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        // _messages.clear();
                        _messages.add(_messageController.text);
                        addReply(_messageController.text);
                        _messageController.clear();
                        setState(() {
                          currMessage = "";
                        });
                        Timer(
                          Duration(milliseconds:300),
                              ()=>_scrollController.jumpTo(_scrollController.position.maxScrollExtent),
                        );
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        )

    );
  }
}
