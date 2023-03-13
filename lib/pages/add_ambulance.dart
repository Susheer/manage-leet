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

class AddAmbulanceScreen extends StatefulWidget {
  const AddAmbulanceScreen({Key? key}) : super(key: key);

  @override
  State<AddAmbulanceScreen> createState() => _AddAmbulanceScreenState();
}

class _AddAmbulanceScreenState extends State<AddAmbulanceScreen> {
   Future<AmbulancePayload>? _futureAmbulance;
  final todaysDate = DateTime.now();
  late int _dateIndex;
   final TextEditingController _nameCtl = TextEditingController();
   final TextEditingController _longCtl = TextEditingController();
   final TextEditingController _latCtl = TextEditingController();
   final TextEditingController _bidCtl = TextEditingController();
   final TextEditingController _descCtl = TextEditingController();
   late bool _isAnyFieldEmpty=false;

   final double _width = 70;
  final double _margin = 15;
  final _scrollController = ScrollController();
  late int days;

   @override
   void dispose() {
     _nameCtl.dispose();
     _longCtl.dispose();
     _latCtl.dispose();
     _bidCtl.dispose();
     _descCtl.dispose();
     super.dispose();
   }

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

  bool checkEmpty(String param){
     return param?.isEmpty ?? true;
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
        title: const Text(""),
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
          _registrationForm(),
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
            "Fill the details",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Register new ambulance",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),

      ],
    );
  }

  Widget _actionButton(final String title, VoidCallback onClickHandler){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        minimumSize: const Size.fromHeight(50), // NEW
      ),
      onPressed: () {
        onClickHandler();
      },
      child: Text(
        title,
        style: TextStyle(fontSize: 24),
      ),
    );
  }


  SizedBox _registrationForm() {
    return SizedBox(
        height: 600,
        child:ListView(
        children: [
          Column(
            children: [
              TextField(
                controller: _nameCtl,
                decoration: InputDecoration(labelText: 'Ambulance name'),
              ),
              TextField(
                controller: _longCtl,
                decoration: InputDecoration(labelText: 'Longitude value'),
              ),
              TextField(
                controller: _latCtl,
                decoration: InputDecoration(labelText: 'Latitude value'),
              ),
              TextField(
                controller: _bidCtl,
                decoration: InputDecoration(labelText: 'Business Id'),
              ),
            TextField(
                controller: _descCtl,
                decoration: InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                minLines: 3,
            maxLines: null),
              const SizedBox(
                height: 60,
              ),
              if(_futureAmbulance == null)
                _actionButton("Submit", () {
                  setState(() {
                    late String name=_nameCtl.text.toUpperCase();
                    late String lat=_latCtl.text.toUpperCase();
                    late String long=_longCtl.text.toUpperCase();
                    late String desc=_descCtl.text.toUpperCase();
                    late String bid=_bidCtl.text.toUpperCase();
                    late bool isEmpty = checkEmpty(name) || checkEmpty(lat) || checkEmpty(long) || checkEmpty(desc)|| checkEmpty(bid);
                    if(isEmpty){
                      final snackbar=SnackBar(
                        content: Text('Do not miss any detais'),
                        duration: Duration(seconds: 2),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                    else{
                      _futureAmbulance = createAmbulance(name, lat, long, desc, bid);
                    }
                  });
                }),
              if(_futureAmbulance != null)
                FutureBuilder<AmbulancePayload>(
                  future: _futureAmbulance,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Text("Ambulance created"),
                          SizedBox(height:15),
                          _actionButton("Refresh", () {
                            setState(() {
                              _nameCtl.clear();
                              _longCtl.clear();
                              _bidCtl.clear();
                              _descCtl.clear();
                              _latCtl.clear();
                              _futureAmbulance = null;
                            });
                          }),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      debugPrint(snapshot.toString());
                      return Text("${snapshot.error}");
                    }

                    return Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height:15),
                            Text("Please wait")
                          ],
                        );
                  },
                ),
         ])
        ])
        );
  }

  Future<AmbulancePayload> createAmbulance(String name,String lat, String lng, String desc, String bId) async {
    final http.Response response = await http.post(
      Uri.parse('http://localhost:1337/ambulance'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'latitude':lat,
        'name':name,
        'longitude':lng,
        'description':desc,
        'business_id': bId
      }),
    );

// Dispatch action depending upon
// the server response
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return AmbulancePayload.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error: ${response.reasonPhrase} with ${response.statusCode}');
    }
  }

}

class  AmbulancePayload{
  late String name;
  AmbulancePayload({
    required this.name,
  });

  factory AmbulancePayload.fromJson(Map<String, dynamic> json) {
    return AmbulancePayload(
      name: json['name']
    );
  }
}


