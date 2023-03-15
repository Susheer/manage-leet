import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:task_management/core/res/color.dart';
import 'package:task_management/models/ambulance.dart';
import 'package:task_management/models/task.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:task_management/widgets/loading_spinner.dart';

const darkColor = Color(0xFF49535C);
class AmbulanceWidget extends StatelessWidget {
  final AmbulanceModel ambulanceModel;
  final Function(String value) onDelete;
  AmbulanceWidget({
    Key? key,
    required this.ambulanceModel,
    required this.onDelete,
  }) : super(key: key);

  Future deleteAmbulance(String name) async {
    bool flag=false;
    http.Response response = await http.delete(Uri.parse('http://localhost:1337/ambulance/${name}'));
    print("StatusCode ${response.statusCode}");
    if(response.statusCode==200){
     flag=true;
    }
    return flag;
  }

  TextStyle buildMontserrat(
      Color color, {
        FontWeight fontWeight = FontWeight.normal,
      }) {
    return TextStyle(
      fontSize: 18,
      color: color,
      fontWeight: fontWeight,
    );
  }


  TextStyle boldStyle() {
    return   TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle normal() {
    return   TextStyle(
      fontSize: 12,
      color: Colors.white.withOpacity(0.6),
      fontWeight: FontWeight.bold,
    );
  }

  String getRegisteredDate(int timestamp){
    var dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat.yMMM().format(dt);
  }

  Widget getMenuList(BuildContext context, String name, bool isActive){
    return  PopupMenuButton(
        icon: Icon(Icons.more_vert,color: Colors.white), // add this line
        itemBuilder: (context){
          return [
            PopupMenuItem<int>(
              value: 0,
              child: Row(
                children: [
                  Text("Edit")
                ],
              ),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: Row(
                children: [
                  Text("Delete")
                ],
              ),
            ),
            PopupMenuItem<int>(
              value: 2,
              child: Row(
                children: [
                  if(isActive==true)
                  Text("Deactivate"),
                  if(isActive==false)
                    Text("Activate"),
                ],
              ),
            ),
          ];
        },
        constraints: BoxConstraints(
          minWidth: 30.w,
          maxWidth: 30.w,
        ),
        elevation: 2,
        onSelected:(value) async {
          if(value == 0){
            print('Edit Action ${name}'); // @todo
          }else if(value == 1){
            FocusScope.of(context).unfocus();
            Spinner(context).startLoading();
            bool result = await deleteAmbulance(name);
            if(result==false) {
              Spinner(context).showError("Something went wrong");
            }
            onDelete(name); // refresh the list
            Spinner(context).stopLoading();
          }else if(value == 2){
            print('Is_ACTIVE Action ${name}'); // @todo
          }
        }
    );
  }

  Widget buildRowFirst(BuildContext context, String displayName, String driverName, bool isActive){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(displayName, style: boldStyle()),
    Container(
      child: Row(
        children: [
        Text("Active", style: boldStyle()),
        getMenuList(context,displayName,isActive),
      ],
      ),
    )

        ],);
  }
  Widget buildRowSecond(String driverName, bool isActive){
    String flag="No";
    if(isActive==true){
      flag="Yes";
    }

    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            "Driver: ${driverName} ",
            style: normal()
        ),
        Text(flag, style: normal()),
      ],);
  }
  Widget buildNormalRow(String value1, String value2){


    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            "${value1} ",
            style: normal()
        ),
        Text(value2, style: normal()),
      ],);
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 90.w,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    gradient: AppColors.getDarkLinearGradient(
                      Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: const Offset(2, 6),
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildRowFirst(context,ambulanceModel.displayName,ambulanceModel.driverName!, true),
                    buildRowSecond(ambulanceModel.driverName!,ambulanceModel.isActive),
                    buildNormalRow("+91 ${ambulanceModel.mobileNo} ","Last trip: ${getRegisteredDate(ambulanceModel.lastService!)}" ),
                    const SizedBox(height: 6),
                    Text("Authority: ${ambulanceModel.authorityDisplayName} ", style: normal()),
                    const SizedBox(height: 8),
                    Text("Details:", style: normal()),
                    const SizedBox(height: 4),
                    Text("${ambulanceModel.description} ", style: normal(),maxLines: 12),
                    const SizedBox(height: 40), // mine
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(getRegisteredDate(ambulanceModel.registredDate), style: boldStyle()),
                              Text("Registered", style: normal())
                            ],
                          ),
                          SizedBox(height: 50,
                            child: const VerticalDivider(
                              color: Colors.white,
                            ),
                          ),
                          Column(
                            children: [
                              Text("6", style: boldStyle()),
                              Text("Served", style: normal())
                            ],
                          ),
                          SizedBox(
                            height: 50,
                            child: const VerticalDivider(
                              color: Colors.white,
                            ),
                          ),
                          Column(
                            children: [
                              Text("3/5", style: boldStyle()),
                              Text("Ratings", style: normal())
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8)
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const Divider(),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

}

