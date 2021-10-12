import 'dart:convert';
import 'package:at_your_doorstep/Help_Classes/Constants.dart';
import 'package:at_your_doorstep/Help_Classes/api.dart';
import 'package:at_your_doorstep/Help_Classes/specialSpinner.dart';
import 'package:at_your_doorstep/Screens/LandingPages/showItemPage.dart';
import 'package:at_your_doorstep/Screens/Orders/orderDetailPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotifiedOrdersList extends StatefulWidget {
  const NotifiedOrdersList({Key? key}) : super(key: key);

  @override
  _NotifiedOrdersListState createState() => _NotifiedOrdersListState();
}

class _NotifiedOrdersListState extends State<NotifiedOrdersList>
    with SingleTickerProviderStateMixin{

  var orderItems1;
  bool executed3 = false;
  var today = new DateTime.now();
  var date = '';
  late AnimationController _animationController;

  @override
  void initState() {
    executed3 = false;
    date = today.toString().substring(0,10);
    _animationController = new AnimationController(vsync: this , duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    getOrderedItemsSeller();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Notification",
          style: TextStyle(
              fontSize: 20,
              color: Colors.red,
              fontFamily: "PTSans",
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.red,size: 35,),
        ),
      ),
      body: executed3 ? SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              orderItems1.length > 0 ? SizedBox(
                height: 500,
                child: ListView.builder(
                  itemCount: orderItems1.length,
                  itemBuilder:(context , index){
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  date == orderItems1[index]['created_at'].substring(0,10) ? FadeTransition(
                                    opacity: _animationController,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Container(
                                        color: Colors.red,
                                        child: Text(" New ", style:
                                        TextStyle(fontSize: 14, color: Colors.white, fontFamily: "PTSans", fontWeight: FontWeight.w700 , )),
                                      ),
                                    ),
                                  ): SizedBox(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("New Order",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 18.0, fontWeight: FontWeight.w700),),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Ordered Date: ", style:
                                    TextStyle(fontSize: 15, color: Colors.black26, fontFamily: "PTSans", fontWeight: FontWeight.w700 )),
                                    Text(orderItems1[index]['created_at'].substring(0,10), style:
                                    TextStyle(fontSize: 15, color: Colors.black26, fontFamily: "PTSans", fontWeight: FontWeight.w700 )),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Divider(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ): ListTile(title: Center(child: Text("No Notification Order!",
                style: TextStyle(color: Colors.red),
              ))),
            ],
          ),
        ),
      ): SpecialSpinner(),
    );
  }
  getOrderedItemsSeller() async {
   orderItems1={};
    var res= await CallApi().postData({'check':1},'/getOrders');
    var body =json.decode(res.body);
    print(body[0].toString());
    if(res.statusCode == 200){
      setState(() {
       orderItems1 = body;
      });
      print(orderItems1.toString());
      executed3 = true;
    }
  }
}
