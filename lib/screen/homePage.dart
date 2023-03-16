import 'dart:convert';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/helper/collectionHelper.dart';
import 'package:firebase_demo/model/Databasemodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../utils/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  CollectionHelper dbhHelper = CollectionHelper.instance;
 int counter = 0;

  @override
  void initState()
  {
    super.initState();
    tz.initializeTimeZones();
  }

  void scheduled() {
   setState(() {
     counter++;
   });

   flutterLocalNotificationsPlugin.zonedSchedule(
       counter,
       "Testing Notification $counter",
       "How are you Looking Good",
       tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),
       NotificationDetails(
         android: AndroidNotificationDetails(
           channel.id,
           channel.name,
           importance: Importance.high,
           playSound: true,
           icon: "@mipmap/ic_launcher"
         ),
       ),
       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
       androidAllowWhileIdle: true,
   );

 }



  flutterMessaging()
  {


  }

  void showNotification() async {
    setState(() {
      counter++;
    });

    final http.Response response = await http.get(
        Uri.parse("https://images.unsplash.com/photo-1494976388531-d1058494cdd8?ixlib=rb-4.0.3&ixid=MnwxM"
            "jA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80"));

    BigPictureStyleInformation bigPictureStyleInformation =
    BigPictureStyleInformation(
        ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.bodyBytes)),
        largeIcon: ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.bodyBytes)),
    );

    flutterLocalNotificationsPlugin.show(
      0,
        "My_Notification $counter",
        "Hello Friends How Are You Looking Good",
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                importance:Importance.high,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              styleInformation: bigPictureStyleInformation
            )
        )
    );
  }



  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          GestureDetector(
            onTap: (){
              try{
                final userCredtional = FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }catch(e)
              {
                print(e);
              }
            },
            child: Icon(
              Icons.logout
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [

              TextFormField(
                validator: (val){
                  if(val!.isEmpty){
                    return "Please Enter The name";
                  }
                  return null;
                },
                onChanged: (val){
                  setState(() {
                    name.text = val;
                    print(email.text);
                  });
                },
                decoration: InputDecoration(
                    hintText: "name",
                    hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        fontSize: 18
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    focusedBorder: OutlineInputBorder()
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  fontSize: 20,
                ),
              ),

              SizedBox(height: 30,),

              // ====== pass =============

              TextFormField(
                validator: (val){
                  if(val!.isEmpty){
                    return "Please Enter The age";
                  }
                  return null;
                },
                onChanged: (val){
                  setState(() {
                    age.text = val;
                  });
                },
                decoration: InputDecoration(
                    hintText: "age",
                    hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        fontSize: 18
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    focusedBorder: OutlineInputBorder()
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  fontSize: 20,
                ),
              ),

              SizedBox(height: 30,),


              CupertinoButton(
                color: Colors.black,
                  child: Text("Insert",
                  style: TextStyle(
                    color: Colors.white
                  ),
                  ),
                  onPressed: ()  => setState(() {
                    var data = UsersData(name: name.text, age: age.text);
                    dbhHelper.dataInsert(data);
                    //dbhHelper.insertData();
                  }),
              ),

              SizedBox(height: 30,),


              CupertinoButton.filled(
                child: Text("Show The Notification"),
                onPressed: () => showNotification(),
              ),

              SizedBox(height: 30,),

              CupertinoButton.filled(
                child: Text("Scheduled The Notification"),
                onPressed: () => scheduled(),
              ),

              SizedBox(height: 30,),

              CupertinoButton.filled(
                child: Text("Server Side Notification"),
                onPressed: () => flutterMessaging(),
              ),

              SizedBox(height: 30,),

              Container(
                height: 200,
                color: Colors.grey.shade200,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('data').snapshots(),
                    builder: (context,snapshot){
                      if(snapshot.hasError){
                        return Text('Something went Wrong');
                      }
                      else if(snapshot.connectionState == ConnectionState.waiting){
                        return CircularProgressIndicator();
                      }
                      else {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context,index){
                              data = snapshot.data!.docs;
                            print("data $data");
                              return ListTile(
                                title: Text("${snapshot.data!.docs[index]['name']}"),
                                subtitle:  Text("${snapshot.data!.docs[index]['age']}"),
                                trailing: Container(
                                  width: 70,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap : (){
                                          dbhHelper.dataDelete(index: index);
                                        },
                                        child: Icon(Icons.delete,
                                        color: Colors.red,),
                                      ),
                                  SizedBox(width: 20,),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pushNamed(context, 'edit',arguments: index);
                                    },
                                    child: Icon(Icons.edit),
                                  ),
                                    ],
                                  ),
                                ),
                              );
                            },
                        );
                      }
                    },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}


