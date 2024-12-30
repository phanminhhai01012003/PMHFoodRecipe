import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pmhfoodrecipe/Provider/history_provider.dart';
import 'package:pmhfoodrecipe/View/SubMenu/detail_page.dart';
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key,});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final historyprovider = HistoryProvider.of(context);
    final viewItems = historyprovider.viewProducts;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        foregroundColor: Colors.white,
        title: Text("Lịch sử xem",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text("Món ăn bạn đã xem gần đây",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: viewItems.isEmpty ? Center(
                child: Text("Không có dữ liệu",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ) : ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: viewItems.length,
                itemBuilder: (context, index){
                  String view = viewItems[index];
                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("food_recipe")
                        .doc(view)
                        .get(),
                    builder: (context, snapshot){
                      if (!snapshot.hasData){
                        return Center(
                          child: Column(
                            children: [
                              Icon(Icons.error_outline_rounded,
                                color: Colors.black,
                                size: 50,
                              ),
                              SizedBox(height: 20),
                              Text("Lỗi khi tải",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black
                                ),
                              )
                            ],
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator());
                      }
                      var foods = snapshot.data!;
                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      DetailPage(
                                          foods: foods,
                                          id: foods.id,
                                          likeList: List<Map<String, dynamic>>.from(foods['likes'] ?? [])
                                      )
                                  )
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black.withOpacity(0.25),
                                ),
                                child: Slidable(
                                  key: ValueKey(foods.id),
                                  endActionPane: ActionPane(
                                    motion: ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context){
                                          historyprovider.toggleView(foods);
                                        },
                                        backgroundColor: Colors.red.shade700,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Hero(
                                        tag: foods['imageURL'],
                                        child: Container(
                                          width: 100,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(foods['imageURL'])
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(foods['title'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text("Thể loại: ${foods['tag']}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}
