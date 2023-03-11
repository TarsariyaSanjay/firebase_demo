import 'package:firebase_demo/model/Databasemodel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionHelper{

  static CollectionHelper instance = CollectionHelper();
  CollectionReference data = FirebaseFirestore.instance.collection('data');
  // static data add in collection firebase // ====== Not Using Model Class


  // insertData() async {
  //   CollectionReference data = await FirebaseFirestore.instance.collection('data');
  //   return data.add(
  //       {
  //         'name' : 'Sahil',
  //         'age' : '20'
  //       }
  //   ).then((value) => print('User Added'))
  //       .catchError((error) => print("failed USer : $error"));
  // }


  // ============== using model class ==================

    dataInsert(UsersData users){

      return data.add(users.toMap())
          .then((value) => print("data Add"))
          .catchError((error) => print("error : ${error}"));
    }

  // ================= update

  dataUpdate({int? id,required UsersData usersData}) async {
      var docSnap = await data.get();
      var docId = docSnap.docs;
     return data
         .doc(docId[id!].id)
         .update(usersData.toMap())
         .then((value) => print("data Update"))
         .catchError((error) => print("error : ${error}"));
  }

  dataDelete({int? index}) async {
    var docSnap = await data.get();
    var docId = docSnap.docs;
    return data
        .doc(docId[index!].id)
        .delete()
        .then((value) => print("data Delete"))
        .catchError((error) => print("error : ${error}"));
  }



}