import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management/core/res/color.dart';
import 'package:task_management/models/ambulance.dart';
import 'package:task_management/models/task.dart';
import 'package:task_management/widgets/ambulance.dart';
import 'package:task_management/widgets/circle_gradient_icon.dart';
import 'package:task_management/widgets/task.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const ANDROID_LOCALHOST="10.0.2.2";

class AmbulanceListScreen extends StatefulWidget {
  const AmbulanceListScreen({Key? key}) : super(key: key);

  @override
  State<AmbulanceListScreen> createState() => _AmbulanceListScreenState();
}

class _AmbulanceListScreenState extends State<AmbulanceListScreen> {
  final todaysDate = DateTime.now();
  late int _dateIndex;
  final double _width = 70;
  final double _margin = 15;
  final _scrollController = ScrollController();
  late int days;

   List<AmbulanceModel> _ambulanceList = [];

  Future<List<AmbulanceModel>>fetchAmbulanceListFromWeb() async {
    http.Response response = await http.get(Uri.parse('http://localhost:1337/ambulance'));
    List responseJson;
    List<AmbulanceModel> ambulanceList;
    print("StatusCode ${response.statusCode}");
    if(response.statusCode==200){
      responseJson = json.decode(response.body.toString());
      ambulanceList = createAmbulanceList(responseJson);
    }else {
      ambulanceList = [];
    }
    return ambulanceList;
  }


  List<AmbulanceModel> createAmbulanceList(List data){
    debugPrint("createAmbulanceList Invoked");
    List<AmbulanceModel> list = <AmbulanceModel>[];
    for (int i = 0; i < data.length; i++) {
      String description = data[i]["description"];
      String displayName = data[i]["name"];
      int registredDate = data[i]["createdAt"];
      int lastService = data[i]["updatedAt"];
      String authorityDisplayName = data[i]["business_id"];
      bool isActive = data[i]["active"];

      String driverName = "Mr Raghav"; //data[i]["driverName"];
      String mobileNo =  "8948451168";  //data[i]["mobileNo"];
      AmbulanceModel ambulance = new AmbulanceModel(
          authorityDisplayName:authorityDisplayName ,
          description: description,
          displayName: displayName,
          isActive: isActive,
          registredDate: registredDate,
          driverName: driverName,
          mobileNo: mobileNo,
          lastService:lastService,
      );
      list.add(ambulance);
    }
    return list;
  }

  void _scroll() {
    if(_scrollController.hasClients){
      _scrollController.animateTo(
        (days * _dateIndex.toDouble()) +
            (_dateIndex.toDouble() * _width) -
            (_dateIndex * _margin),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeIn,
      );
    }

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View All"),
      ),
      body: _buildBody(context),
    );
  }

  Container _buildBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          _buildHeader(context),
          const SizedBox(
            height: 20,
          ),
          _buildList(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
            "Ambulances",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Registered in the system",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),

      ],
    );
  }

  SizedBox _buildList() {
    return SizedBox(
      height: 500,
      child: new FutureBuilder<List<AmbulanceModel>>(
        future: fetchAmbulanceListFromWeb(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            _ambulanceList=snapshot.data!;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _ambulanceList?.length,
              controller: _scrollController,
              itemBuilder: (context, index) {
                return  AmbulanceWidget(onDelete: (String name){
                  debugPrint('Record deleted ${name}');
                  setState(() {
                    _ambulanceList.removeWhere((ambulance) => ambulance.displayName == name);
                  });
                },ambulanceModel: _ambulanceList[index]);
              },
            );
          }else if (snapshot.hasError){
            return new Text("${snapshot.error}");
          }
          // By default, show a loading spinner
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height:15),
                Text("Please wait")
              ],
            ));
        }
    ));
  }
}

