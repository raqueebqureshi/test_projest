
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:test_project/services/api.dart';
import 'package:test_project/utils/utils.dart';
import 'package:currency_converter/currency_converter.dart';
import 'package:currency_converter/currency.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  var res;
  List dataList=[];
  List convertAmt=[];

  @override
  void initState() {
    super.initState();
    getData();
  }


  void getData()async{
    res = await Api.getMarketData();
    print("res $res");
    if(res!={}){
      setState(() {
        dataList = res["data"];
      });
      for(var i=0; i<dataList.length;i++){
        var usdConvert = await CurrencyConverter.convert(
            from: Currency.usd, to: Currency.inr,
            amount: dataList[i]['priceUsd']!=null? double.parse(dataList[i]['priceUsd']):00);
        setState(() {
          convertAmt.add(usdConvert);
        });
      }
    }
    print('data $dataList, convertAmt $convertAmt');
  }


    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title,style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: (){
            setState(() {
              dataList=[];
              convertAmt=[];
            });
            getData();

          }, icon: Icon(
            Icons.refresh,
            color: Colors.white,

          ))
        ],
      ),
      body: dataList.isEmpty || convertAmt.length!=dataList.length ? Utils.showLoader1():
      ListView.builder(
          shrinkWrap: true,
          itemCount: dataList.length,itemBuilder: (context,index){
        return userItem(0, context, dataList,cName: dataList[index]['baseId'],
            price: "\$${dataList[index]['priceUsd']!=null
                ? double.parse(dataList[index]['priceUsd']).toStringAsFixed(2)
                :"N/A"}" ,
            icon: dataList[index]['baseSymbol'].toString(),
          amt: convertAmt[index]
             );
      }),
    );
  }



  Widget userItem(index, context, list, {required cName, required price, required icon,  amt}) {
     return Container(
      height: 90,
      margin: EdgeInsets.symmetric(horizontal:  10,vertical: 10,),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 2.5,
                offset: Offset(0, 4)),
          ],
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Utils.appThemeColor)),
            child: Center(child: Text(
              icon?? "",style: TextStyle(
              color: Colors.black26,
              fontSize: 16,
              fontWeight: FontWeight.w700

            ),

            ))
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cName ?? "" ,
                  style: TextStyle(
                      height: 1.3, fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  price.toString() ?? "",
                  style: TextStyle(
                      height: 1.3, fontSize: 16, color: Colors.black38),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
              margin: EdgeInsets.only(right: 25),
              child: Text(
            "₹$amt",style: TextStyle(
              color: Colors.black26,
              fontSize: 16,
              fontWeight: FontWeight.w700

          ),

          ))


        ],
      ),
    );
  }






}