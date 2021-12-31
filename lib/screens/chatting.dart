import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat(
      {Key? key,
      @required this.sendto,
      @required this.currentuseremail,
      @required this.sendtoemail,
      @required this.chatRoom})
      : super(key: key);
  final sendto;
  final currentuseremail;
  final sendtoemail;
  final chatRoom;
  @override
  _ChatState createState() => _ChatState();
}

bool selectuser = true;

TextEditingController msg = TextEditingController();

addData(sender, receiver, chatRoom) async {
  await FirebaseFirestore.instance
      .collection("chatRoom")
      .doc(chatRoom)
      .collection("Chats")
      .add({
    'currentemail': sender,
    'senttoemail': receiver,
    'message': msg.text,
    'time': DateTime.now().millisecondsSinceEpoch,
  });
  msg.clear();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Colors.amber,
            ),
          ),
        ],
        title: Center(
          child: Text(
            "${widget.sendto}",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink),
          ),
        ),
        leadingWidth: MediaQuery.of(context).size.width * 0.2,
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_outlined, color: Colors.pink)),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("chatRoom")
                    .doc('${widget.chatRoom}')
                    .collection("Chats")
                    .orderBy("time")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Image(
                      image: AssetImage("assets/images/run.gif"),
                    );
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      if ('${data['currentemail']}' ==
                          "${widget.currentuseremail}") {
                        selectuser = true;
                      } else {
                        selectuser = false;
                      }
                      return Column(children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.05,
                            left: selectuser
                                ? MediaQuery.of(context).size.width * 0.25
                                : MediaQuery.of(context).size.width * 0.05,
                            right: selectuser
                                ? MediaQuery.of(context).size.width * 0.05
                                : MediaQuery.of(context).size.width * 0.25,
                          ),
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.width * 0.05,
                              top: MediaQuery.of(context).size.width * 0.05),
                          decoration: BoxDecoration(
                            color: selectuser ? Colors.pink : Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width * 0.90,
                          child: Container(
                            padding: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * 0.05,
                                left: MediaQuery.of(context).size.width * 0.05),
                            child: RichText(
                              text: TextSpan(
                                text: '${data['message']}',
                                style: TextStyle(
                                    color: selectuser
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 18.0),
                              ),
                            ),
                          ),
                        ),
                      ]);
                    }).toList(),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width * 0.03,
                  top: MediaQuery.of(context).size.width * 0.03),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                    ),
                    width: MediaQuery.of(context).size.width * 0.78,
                    child: TextField(
                        controller: msg,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7)),
                            suffixIcon: Icon(
                              Icons.mic,
                              color: Colors.pink,
                            ),
                            hintText: 'Type a message',
                            prefixIcon: Icon(
                              Icons.face,
                              color: Colors.pink,
                            ))),
                  ),
                  InkWell(
                    onTap: () {},
                    child: InkWell(
                      onTap: () {
                        if (msg.text != "") {
                          addData("${widget.currentuseremail}",
                              "${widget.sendtoemail}", "${widget.chatRoom}");
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.pink,
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
