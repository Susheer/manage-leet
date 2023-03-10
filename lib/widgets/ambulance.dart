import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:task_management/core/res/color.dart';
import 'package:task_management/models/ambulance.dart';
import 'package:task_management/models/task.dart';
import 'package:intl/intl.dart';


const darkColor = Color(0xFF49535C);
class AmbulanceWidget extends StatelessWidget {
  final AmbulanceModel ambulanceModel;
  const AmbulanceWidget({
    Key? key,
    required this.ambulanceModel,
  }) : super(key: key);


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

  Widget buildRowFirst(String displayName, String driverName, bool isActive){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(displayName, style: boldStyle()),
          Text("Active", style: boldStyle()),
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
                    buildRowFirst(ambulanceModel.displayName,ambulanceModel.driverName!, true),
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

