import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gauseva_app/controllers/authController.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class UploadScreen extends StatefulWidget {
  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late ImagePicker imagePicker;
  File? image;
  String result = '';
  late List<DetectedObject> objects;
  late bool locationPermissionGranted;
  late String _postCreatedOn;
  dynamic objectDetector;
  MainAxisAlignment _axisAlignment = MainAxisAlignment.center;
  Position? position;
  String? address;
  final List<String> items = ['Yes', 'No'];
  final List<String> numbers = ['1 - 5', '5 - 10', '>10'];
  String? selectedValue;
  String? selectedNumber;

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    createObjectDetector();
  }

  @override
  void dispose() {
    super.dispose();
    objectDetector.close();
  }

  Future<void> _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) {
      showSnackBar('No image chosen');
      return;
    }
    bool cowDetected = await doObjectDetection(File(pickedFile.path));
    if (cowDetected == true) {
      await _getUserLocation();
      setState(() {
        image = File(pickedFile.path);
      });
      _postCreatedOn =
          "${DateFormat.jm().format(DateTime.now())} ${DateFormat.yMMMMEEEEd().format(DateTime.now())}";
    } else {
      showSnackBar(
          "The image doesn't quite ressamble a cow...try taking picture from a different angle");
    }
  }

  Future<void> _imgFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      showSnackBar('No image chosen');
      return;
    }
    bool cowDetected = await doObjectDetection(File(pickedFile.path));
    if (cowDetected == true) {
      await _getUserLocation();
      setState(() {
        image = File(pickedFile.path);
      });
      _postCreatedOn =
          "${DateFormat.jm().format(DateTime.now())} ${DateFormat.yMMMMEEEEd().format(DateTime.now())}";
    } else {
      showSnackBar(
        "The image doesn't quite ressamble a cow...try taking picture from a different angle",
      );
    }
  }

  Future<String> _getModel(String assetPath) async {
    await _requestPermission();
    if (Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  Future<void> createObjectDetector() async {
    final modelPath = await _getModel('assets/models/mobilenet.tflite');
    // final modelPath = 'assets/models/mobilenet.tflite';
    final options = LocalObjectDetectorOptions(
      modelPath: modelPath,
      classifyObjects: true,
      multipleObjects: true,
      mode: DetectionMode.single,
    );
    objectDetector = ObjectDetector(options: options);
  }

  Future<bool> doObjectDetection(File image) async {
    bool cowDetected = false;
    final inputImage = InputImage.fromFile(image);
    objects = await objectDetector.processImage(inputImage);
    for (DetectedObject object in objects) {
      for (Label l in object.labels) {
        if (l.text == 'ox') {
          cowDetected = true;
          return cowDetected;
        }
      }
    }
    return cowDetected;
  }

  Future<void> _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.manageExternalStorage,
      Permission.location,
    ].request();
    // print(
    //     'permission ${await Permission.manageExternalStorage.isGranted} --------------------------------------');
    // print(
    //     'permission ${await Permission.location.isGranted} --------------------------------------');
  }

  void showSnackBar(String msg, {title = null}) {
    GetSnackBar snackbar = GetSnackBar(
      duration: Duration(seconds: 3),
      isDismissible: true,
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      dismissDirection: DismissDirection.horizontal,
      borderRadius: 10.0,
      titleText: Text(
        title != null ? title : 'Something went wrong',
        style: GoogleFonts.raleway(
          color: Colors.white,
        ),
      ),
      messageText: Text(
        msg,
        style: GoogleFonts.raleway(
          color: Colors.grey,
          fontSize: 10.sp,
        ),
      ),
    );
    Get.closeCurrentSnackbar();
    Get.showSnackbar(snackbar);
  }

  // Future<bool> _handleLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     showSnackBar(
  //         'Location services are disabled. Please enable the services');
  //     return false;
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       showSnackBar('Location permissions are denied');
  //       return false;
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     showSnackBar(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //     return false;
  //   }
  //   return true;
  // }

  Future<void> _getUserLocation() async {
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      await placemarkFromCoordinates(position!.latitude, position!.longitude)
          .then((List<Placemark> placemarks) {
        Placemark place = placemarks[0];
        setState(() {
          address =
              '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}, ${place.country}';
        });
      }).catchError((_) {
        showSnackBar('');
      });
    } catch (_) {
      showSnackBar('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: image != null
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.file(
                          image!,
                          height: 30.h,
                          width: 70.h,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Positioned(
                        top: 23.h,
                        left: 78.w,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              image = null;
                            });
                          },
                          icon: Icon(Icons.edit),
                          color: Colors.black,
                          iconSize: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Username',
                    style: GoogleFonts.montserrat(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(Get.find<AuthController>().userData['username'],
                      style: GoogleFonts.raleway()),
                  SizedBox(height: 20),
                  Text(
                    'Location',
                    style: GoogleFonts.montserrat(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('$address', style: GoogleFonts.raleway()),
                  SizedBox(height: 20),
                  Text(
                    'Time',
                    style: GoogleFonts.montserrat(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _postCreatedOn,
                    style: GoogleFonts.raleway(),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Did the cow had a tag on the ear?',
                    style: GoogleFonts.montserrat(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: Text(
                          'Select Response',
                          style: GoogleFonts.raleway(
                            fontSize: 13.sp,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: items
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: GoogleFonts.raleway(
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as String;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 5.h,
                          width: 80.w,
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Approx number of cows seen',
                    style: GoogleFonts.montserrat(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: Text(
                          'Select Response',
                          style: GoogleFonts.raleway(
                            fontSize: 13.sp,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: numbers
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: GoogleFonts.raleway(
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        value: selectedNumber,
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            selectedNumber = value as String;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 5.h,
                          width: 80.w,
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _isLoading
                      ? Center(
                          child: SizedBox(
                            width: 60.w,
                            height: 5.5.h,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      : Center(
                          child: SizedBox(
                            width: 60.w,
                            height: 5.5.h,
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.upload_rounded),
                              onPressed: () async {
                                if (selectedValue == null) {
                                  showSnackBar(
                                      'Please select either yes or no in tag dropdown');
                                  return;
                                }
                                if (selectedNumber == null) {
                                  showSnackBar(
                                      'Please select the number of cows seen');
                                  return;
                                }
                                setState(() {
                                  _isLoading = true;
                                });
                                var severity = '';
                                if (selectedNumber == '1 - 5') {
                                  print('low');
                                  severity = 'low';
                                } else if (selectedNumber == '5 - 10') {
                                  severity = 'more';
                                } else {
                                  severity = 'high';
                                }

                                await Get.find<AuthController>()
                                    .uploadUserPost(
                                  image!,
                                  address!,
                                  position!.latitude,
                                  position!.longitude,
                                  DateTime.now(),
                                  selectedValue == 'Yes' ? true : false,
                                  severity,
                                  address!.split(',').elementAt(1),
                                  address!.split(',').elementAt(2),
                                )
                                    .then(
                                  (_) {
                                    setState(() {
                                      image = null;
                                      _isLoading = false;
                                    });
                                    showSnackBar(
                                      'Post uploaded successfully! check your feed..',
                                      title: 'SUCCESS',
                                    );
                                  },
                                );
                              },
                              label: Text('Upload'),
                              style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(
                                  GoogleFonts.raleway(),
                                ),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(height: 20),
                  Container(
                    child: SingleChildScrollView(
                      child: Text(
                        "Don't worry none of your information will be shared with anyone including phonenumber except username as it will help others in your locality identify you and upvote your post",
                        style: GoogleFonts.raleway(fontWeight: FontWeight.w400),
                      ),
                    ),
                    width: double.infinity,
                    height: 14.h,
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  )
                ],
              ),
            )
          : Column(
              mainAxisAlignment: _axisAlignment,
              children: [
                SizedBox(height: 18.h),
                Center(
                  child: Image.network(
                    "https://img.freepik.com/premium-vector/illustration-vector-graphic-cartoon-character-upload-image_516790-805.jpg?w=2000",
                    fit: BoxFit.cover,
                    width: 80.w,
                    height: 40.h,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'See a stray cow? Click a picture!',
                  style: GoogleFonts.raleway(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _imgFromCamera,
                      child: Text("Upload from Camera"),
                      style: ElevatedButton.styleFrom(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    ElevatedButton(
                      onPressed: _imgFromGallery,
                      child: Text("Upload from Gallery"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.greenAccent,
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0),
                            topLeft: Radius.circular(0.0),
                            bottomLeft: Radius.circular(0.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
