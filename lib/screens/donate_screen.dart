// 192939
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:gauseva_app/screens/subscribe.dart';
import 'package:flutter/services.dart';
// import 'package:upi_india/upi_india.dart';
// import 'package:easy_upi_payment/easy_upi_payment.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({Key? key}) : super(key: key);

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  String mid = "", orderId = "", amount = "", txnToken = "";
  String result = "";
  bool isStaging = false;
  bool isApiCallInprogress = false;
  String callbackUrl = "";
  bool restrictAppInvoke = false;
  bool enableAssist = true;
  @override
  void initState() {
    print("initState");
    super.initState();
  }

  void makePayment() async {
    try {
      var response = AllInOneSdk.startTransaction(
          mid, orderId, amount, txnToken, "", isStaging, restrictAppInvoke);
      response.then((value) {
        print(value);
        setState(() {
          ;
          result = value.toString();
        });
      }).catchError((onError) {
        if (onError is PlatformException) {
          print('hehe1');
          setState(() {
            result = "${onError.message}  ${onError.details.toString()}";
          });
        } else {
          print('hehe2');
          setState(() {
            result = onError.toString();
          });
        }
      });
    } catch (err) {
      print('hehe3');
      result = err.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: makePayment,
        child: Text("Pay"),
      ),
    );
  }
}

// class DonateScreen extends StatefulWidget {
//   const DonateScreen({Key? key}) : super(key: key);

//   @override
//   State<DonateScreen> createState() => _DonateScreenState();
// }

// class _DonateScreenState extends State<DonateScreen> {
//   Future<UpiResponse>? _transaction;
//   UpiIndia _upiIndia = UpiIndia();
//   List<UpiApp>? apps;

//   TextStyle header = TextStyle(
//     fontSize: 18,
//     fontWeight: FontWeight.bold,
//   );

//   TextStyle value = TextStyle(
//     fontWeight: FontWeight.w400,
//     fontSize: 14,
//   );

//   @override
//   void initState() {
//     _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
//       setState(() {
//         apps = value;
//       });
//     }).catchError((e) {
//       apps = [];
//     });

//     Widget wid = Icon(Icons.location)
//     super.initState();
//   }

//   Future<UpiResponse> initiateTransaction(UpiApp app) async {
//     return _upiIndia.startTransaction(
//       app: app,
//       receiverUpiId: "9654761823@paytm",
//       receiverName: 'Surinder Kumar',
//       transactionRefId: 'TestingUpiIndiaPlugin',
//       transactionNote: 'Not actual. Just an example.',
//       amount: 10.00,
//     );
//   }

//   Widget displayUpiApps() {
//     if (apps == null)
//       return Center(child: CircularProgressIndicator());
//     else if (apps!.length == 0)
//       return Center(
//         child: Text(
//           "No apps found to handle transaction.",
//           style: header,
//         ),
//       );
//     else
//       return Align(
//         alignment: Alignment.topCenter,
//         child: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Wrap(
//             children: apps!.map<Widget>((UpiApp app) {
//               return GestureDetector(
//                 onTap: () {
//                   _transaction = initiateTransaction(app);
//                   setState(() {});
//                 },
//                 child: Container(
//                   height: 100,
//                   width: 100,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Image.memory(
//                         app.icon,
//                         height: 60,
//                         width: 60,
//                       ),
//                       Text(app.name),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       );
//   }

//   Widget displayTransactionData(title, body) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text("$title: ", style: header),
//           Flexible(
//               child: Text(
//             body,
//             style: value,
//           )),
//         ],
//       ),
//     );
//   }

//   String _upiErrorHandler(error) {
//     switch (error) {
//       case UpiIndiaAppNotInstalledException:
//         return 'Requested app not installed on device';
//       case UpiIndiaUserCancelledException:
//         return 'You cancelled the transaction';
//       case UpiIndiaNullResponseException:
//         return 'Requested app didn\'t return any response';
//       case UpiIndiaInvalidParametersException:
//         return 'Requested app cannot handle the transaction';
//       default:
//         return 'An Unknown error has occurred';
//     }
//   }

//   void _checkTxnStatus(String status) {
//     switch (status) {
//       case UpiPaymentStatus.SUCCESS:
//         print('Transaction Successful');
//         break;
//       case UpiPaymentStatus.SUBMITTED:
//         print('Transaction Submitted');
//         break;
//       case UpiPaymentStatus.FAILURE:
//         print('Transaction Failed');
//         break;
//       default:
//         print('Received an Unknown transaction status');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Expanded(
//           child: displayUpiApps(),
//         ),
//         Expanded(
//           child: FutureBuilder(
//             future: _transaction,
//             builder:
//                 (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Text(
//                       _upiErrorHandler(snapshot.error.runtimeType),
//                       style: header,
//                     ), // Print's text message on screen
//                   );
//                 }

//                 // If we have data then definitely we will have UpiResponse.
//                 // It cannot be null
//                 UpiResponse _upiResponse = snapshot.data!;

//                 // Data in UpiResponse can be null. Check before printing
//                 String txnId = _upiResponse.transactionId ?? 'N/A';
//                 String resCode = _upiResponse.responseCode ?? 'N/A';
//                 String txnRef = _upiResponse.transactionRefId ?? 'N/A';
//                 String status = _upiResponse.status ?? 'N/A';
//                 String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
//                 _checkTxnStatus(status);

//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       displayTransactionData('Transaction Id', txnId),
//                       displayTransactionData('Response Code', resCode),
//                       displayTransactionData('Reference Id', txnRef),
//                       displayTransactionData('Status', status.toUpperCase()),
//                       displayTransactionData('Approval No', approvalRef),
//                     ],
//                   ),
//                 );
//               } else
//                 return Center(
//                   child: Text(''),
//                 );
//             },
//           ),
//         )
//       ],
//     );
//   }
// }
