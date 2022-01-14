import 'dart:async';

import 'package:chattingapp/helper/stoarage_helper.dart';
import 'package:chattingapp/screens/chatting.dart';
import 'package:chattingapp/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatUser extends StatefulWidget {
  const ChatUser({Key? key}) : super(key: key);

  @override
  _ChatUserState createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  final Storage storageobj = Storage();
  final _auth = FirebaseAuth.instance.currentUser!;
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      String first = a + "_" + b;
      String second = b + "_" + a;
      print(first);
      print(second);
      print(a);
      print(b);
      print("asd");
      return "$a\_$b";
    } else {
      print(a);
      print(b);
      print("dsd");
      return "$b\_$a";
    }
  }

  addData(chatRoomId, chatRoom, currentuser, usertosend) async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('chatRoom');

    Future<void> getData() async {
      // Get docs from collection reference
      QuerySnapshot querySnapshot = await _collectionRef.get();

      // Get data from docs and convert map to List
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      if (allData.toString().contains("${currentuser}_${usertosend}") ==
              false &&
          allData.toString().contains("${usertosend}_${currentuser}") ==
              false) {
        await FirebaseFirestore.instance
            .collection("chatRoom")
            .doc(chatRoomId)
            .set(chatRoom)
            .catchError((e) {
          print(e);
        });
      }
      // print(allData.toString().contains("${currentuser}_${usertosend}"));
      // print(allData.toString().contains("${usertosend}_${currentuser}"));
      // for (var fruit in allData) {
      // print(fruit.toString().contains("${currentuser}_${usertosend}"));
      // print(fruit.toString().contains("${usertosend}_${currentuser}"));
      // }
      // print(allData);
    }

    getData();
  }

  signOut() async {
    try {
      return await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentuser = "${_auth.email}";
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                          MediaQuery.of(context).size.width * 0.1),
                      bottomRight: Radius.circular(
                          MediaQuery.of(context).size.width * 0.1)),
                  color: Colors.grey[300],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Messages",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink),
                        ),
                        InkWell(
                          onTap: () {
                            signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.01),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.pink),
                            child: Icon(
                              Icons.drag_indicator_sharp,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.01),
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.06,
                            backgroundColor: Colors.pink,
                            child: Icon(Icons.add),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.73,
                          height: 50,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('user_detail')
                                .where('email', isNotEqualTo: currentuser)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text("Error");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(child: Text(""));
                              }

                              return ListView(
                                scrollDirection: Axis.horizontal,
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;
                                  return Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.01),
                                      child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: StreamBuilder(
                                            stream: Storage().downloadedUrl(
                                                '${data['profile']}'),
                                            builder: (context,
                                                AsyncSnapshot<String> snap) {
                                              if (snap.hasError) {
                                                return Text("Error");
                                              } else if (snap.connectionState ==
                                                      ConnectionState.done &&
                                                  snap.hasData) {
                                                return CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                  snap.data!,
                                                ));
                                                //Container(width: 300,height: 450,
                                                // child: Image.network(snap.data!,
                                                // fit: BoxFit.cover,),

                                              }
                                              if (snap.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }
                                              return Container();
                                            },
                                          )));
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01),
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(25.7)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(25.7)),
                          hintText: 'Enter a search term',
                          prefixText: ' ',
                          suffixText: 'Go',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.pink,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('user_detail')
                      .where('email', isNotEqualTo: currentuser)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Image(
                          image: AssetImage("assets/images/run.gif"),
                        ),
                      );
                    }

                    return Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.00,
                          right: MediaQuery.of(context).size.width * 0.0),
                      child: ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return Container(
                            child: InkWell(
                              onTap: () {
                                List<String> users = [
                                  currentuser,
                                  '${data['email']}'
                                ];

                                String chatRoomId = getChatRoomId(
                                    currentuser, '${data['email']}');
                                Map<String, dynamic> chatRoom = {
                                  "users": users,
                                  "chatRoomId": chatRoomId,
                                };
                                addData(chatRoomId, chatRoom, currentuser,
                                    '${data['email']}');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Chat(
                                          sendto: '${data['username']}',
                                          currentuseremail: currentuser,
                                          sendtoemail: '${data['email']}',
                                          chatRoom: '$chatRoomId',
                                          profile: '${data['profile']}')),
                                );
                              },
                              child: ListTile(
                                leading: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: StreamBuilder(
                                    stream: Storage()
                                        .downloadedUrl('${data['profile']}'),
                                    builder:
                                        (context, AsyncSnapshot<String> snap) {
                                      if (snap.hasError) {
                                        return Text("Error");
                                      } else if (snap.connectionState ==
                                              ConnectionState.done &&
                                          snap.hasData) {
                                        return CircleAvatar(
                                            backgroundImage: NetworkImage(
                                          snap.data!,
                                        ));
                                        //Container(width: 300,height: 450,
                                        // child: Image.network(snap.data!,
                                        // fit: BoxFit.cover,),

                                      }
                                      if (snap.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                      return Container();
                                    },
                                  ),
                                ),
                                //  CircleAvatar(
                                //   child: Icon(Icons.beach_access),
                                // ),
                                title: Text(
                                  data['username'],
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  data['email'],
                                  style: TextStyle(color: Colors.grey[800]),
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "12:00 am",
                                      style: TextStyle(color: Colors.grey[800]),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.008),
                                      child: const CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Color(0xFF1F1A30),
                                        child: Text(
                                          '1',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
              //   Expanded(
              //     child: FutureBuilder(
              //       future: Storage()
              //           .downloadedUrl('a@gmail.com/IMG_20220112_113426.jpg'),
              //       builder: (BuildContext context, AsyncSnapshot<String> snap) {
              //         if (snap.hasError) {
              //           return Text("Error");
              //         } else if (snap.connectionState == ConnectionState.done &&
              //             snap.hasData) {
              //           return Expanded(
              //             child: ListView.builder(
              //                 itemCount: 1,
              //                 itemBuilder: (BuildContext context, index) {
              //                   return Text(
              //                     "${snap.data!}",
              //                   );
              //                   // CircleAvatar(
              //                   //   backgroundImage: NetworkImage(
              //                   //     snap.data!,
              //                   //   ),
              //                 }),
              //           );
              //           //Container(width: 300,height: 450,
              //           // child: Image.network(snap.data!,
              //           // fit: BoxFit.cover,),

              //         }
              //         if (snap.connectionState == ConnectionState.waiting) {
              //           return Center(child: CircularProgressIndicator());
              //         }
              //         return Container();
              //       },
              //     ),
              //   )
            ],
          ),
        ),
      ),
    );
  }
}
