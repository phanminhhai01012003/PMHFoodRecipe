import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class HistoryProvider extends ChangeNotifier{
  List<String> _viewList = [];
  List<String> get viewProducts => _viewList;
  HistoryProvider(){
    viewLoad();
  }
  void toggleView(DocumentSnapshot data) async{
    String foodID = data.id;
    if (_viewList.contains(foodID)){
      _viewList.remove(foodID);
      await removeRecentFood(foodID);
    }else{
      _viewList.add(foodID);
      await addRecentFood(foodID);
    }
    notifyListeners();
  }
  Future<void> addRecentFood(String id) async{
    try{
      await FirebaseFirestore.instance.collection("history").doc(id).set({
        "id": FirebaseAuth.instance.currentUser!.uid,
        "isViewed": true,
        "viewedAt": DateTime.now()
      });
    }catch(e){
      Fluttertoast.showToast(
        msg: "Có lỗi xảy ra: ${e.toString()}",
        backgroundColor: Colors.red.shade500,
        textColor: Colors.white,
        fontSize: 14,
        toastLength: Toast.LENGTH_LONG
      );
    }
  }
  Future<void> removeRecentFood(String id) async{
    try{
      await FirebaseFirestore.instance.collection("history").doc(id).delete();
    }catch(e){
      Fluttertoast.showToast(
        msg: "Có lỗi xảy ra: ${e.toString()}",
        backgroundColor: Colors.red.shade500,
        textColor: Colors.white,
        fontSize: 14,
        toastLength: Toast.LENGTH_LONG
      );
    }
  }
  Future<void> viewLoad() async{
    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("history")
          .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      _viewList = snapshot.docs.map((doc) => doc.id).toList();
    }catch(e){
      Fluttertoast.showToast(
        msg: "Có lỗi xảy ra: ${e.toString()}",
        backgroundColor: Colors.red.shade500,
        textColor: Colors.white,
        fontSize: 14,
        toastLength: Toast.LENGTH_LONG
      );
    }
    notifyListeners();
  }
  static HistoryProvider of(BuildContext context, {bool listen = true}){
    return Provider.of<HistoryProvider>(context, listen: listen);
  }
}