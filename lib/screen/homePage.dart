import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/helper/collectionHelper.dart';
import 'package:firebase_demo/model/Databasemodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../utils/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  CollectionHelper dbhHelper = CollectionHelper.instance;

  @override
  Widget build(BuildContext context) {
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

              Container(
                height: 500,
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


