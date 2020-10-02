import 'dart:convert';
import 'dart:io';

import 'package:duare_shop/Dialog/CustomDialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProduct extends StatefulWidget {
  String subcatId;
  AddProduct({this.subcatId});
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController et_name = TextEditingController();
  TextEditingController et_desc = TextEditingController();
  TextEditingController et_size = TextEditingController();
  TextEditingController et_complanyName = TextEditingController();
  TextEditingController et_byuPrice = TextEditingController();
  TextEditingController et_sellingPrice = TextEditingController();
  TextEditingController et_discountPercent = TextEditingController();
  String base64Image ;
  bool _isLoading=false;
  File galaryFile;
  String errorText ="";

  selectImgFromGalary()async{
   File tempFile  =await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 80);
setState(() {
  galaryFile = tempFile;
});
  }

  error(text) {
    setState(() {
      errorText = text;
    });
  }


  String dataSharePre = '';
  String nameKey = "_key_name";



  Future<String> loadData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(nameKey);
  }

  Future addProduct() async {
    dataSharePre = await loadData();
    setState(() {
      _isLoading = true;
    });
    var postUri = Uri.parse("https://admin.duare.net/api/shopApi/product_add.php");
    var request = new http.MultipartRequest("POST", postUri);
  request.fields['name'] =et_name.text;
    request.fields['subCategory_id'] =widget.subcatId;
    request.fields['restaurant_id'] =dataSharePre;
    request.fields['description'] =et_desc.text;
    request.fields['size'] =et_size.text;
    request.fields['company_name'] =et_complanyName.text;
    request.fields['purchasePrice'] =et_byuPrice.text;
    request.fields['sellingPrice'] =et_sellingPrice.text;
    request.fields['discount_percent'] =et_discountPercent.text;
    request.fields['opening_time'] ='6:00:00';
    request.fields['closing_time'] ='23:00:00';
    request.fields['availability'] ='available';
    if( galaryFile != null){
      print('Not null');
      http.MultipartFile multipartFile =
      await http.MultipartFile.fromPath('image', galaryFile.path);
      request.files.add(multipartFile);
    }else{
      print('null null');
    }
//    final responce = await http.post("https://admin.duare.net/api/shopApi/product_add.php", body: {
//      'name':et_name.text,
//      'subCategory_id':widget.subcatId,
//      'restaurant_id':'25',
//      'description':et_desc.text,
//      'size':et_size.text,
//      'company_name':et_complanyName.text,
//      'purchasePrice':et_byuPrice.text,
//      'sellingPrice':et_sellingPrice.text,
//      'discount_percent':et_discountPercent.text,
//      'opening_time':'6:00:00',
//      'closing_time':'23:00:00',
//      'availability':'available',
//    'image':null});
    request.send().then((result) async {

      http.Response.fromStream(result)
          .then((response) {

        if (response.statusCode == 200)
        {
          print("Uploaded! ");
          print('response.body '+response.body);
          var data = json.decode(response.body);
          var message = data['message'];
          showDialog(
              context: context,
                  builder: (context) => CustomDialog(title: message,description: et_name.text+"\n"+message.toString(),buttonText: "View Product List",));

        }
        else{
          errorText = "Something Wrong";
        }

        return response.body;

      });
    }).catchError((err) => print('error : '+err.toString()))
        .whenComplete(()
    {});
    setState(() {
      _isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body: _isLoading ? CircularProgressIndicator() : SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: et_name,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                  labelText: 'Product Name',
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: et_desc,
                keyboardType: TextInputType.multiline,
                minLines: null,
                decoration: new InputDecoration(
                  labelText: 'Product Description',
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: et_size,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                  labelText: 'Size',
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: et_complanyName,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                  labelText: 'Company Name',
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: et_byuPrice,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                  labelText: 'Buy Price',
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: et_sellingPrice,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                  labelText: 'Sell Price',
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: et_discountPercent,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                  labelText: 'Discount Percent',
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
             GestureDetector(
               onTap: (){
                 selectImgFromGalary();
               },
               child: galaryFile !=null ?  Container(
                 height: 100,
                 width: 100,
                 child: Image.file(galaryFile),
               ) : Container(
                 height: 100,
                 width: 100,
                 child: Icon(Icons.image,size: 30,),
               ),
             ),

              SizedBox(
                height: 20,
              ),
              Text(errorText),
              GestureDetector(
                onTap: (){

             addProduct() ;


                },
                child: Container(
                  color: Colors.blueAccent,
                  height: 48,
                  width: MediaQuery.of(context).size.width - 60,
                  child: Center(
                      child: Text(
                    "Continue",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
