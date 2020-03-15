
import 'package:country_house/Screens/Country.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AllCountries  extends StatefulWidget{

  @override
  _AllCountriesState createState() => _AllCountriesState();
}

class _AllCountriesState extends State<AllCountries> {
  List countries = [];
  bool isSearching = false;
  getCountries() async {
    try {
      var response = await Dio().get("https://restcountries.eu/rest/v2/all");
      return response.data;
    } catch(e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCountries().then((data){
      setState(() {
        countries = data;
      });
    });
    super.initState();
  }

  void _filterCountries(String value) {
    print(value);  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: !isSearching 
        ? Text('All Countries') 
        : TextField(
            onChanged: (value){
              _filterCountries(value);
            },
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              icon: Icon(Icons.search, color: Colors.white,),
              hintText: "Search Country here",
              hintStyle: TextStyle(color: Colors.white)
          )
        ),
        actions: <Widget>[
          isSearching
            ? IconButton(
                icon: Icon(Icons.cancel), 
                onPressed: (){
                  setState(() {
                    this.isSearching = false;
                  });
                }
              )
            : IconButton(
                icon: Icon(Icons.search), 
                onPressed: (){
                  setState(() {
                    this.isSearching = true;
                  });
                }
            )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: countries.length>0 ? ListView.builder(
          itemCount: countries.length,
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>  Country(countries[index])
                        ),
                      );
                    },
                    child: Card(
                        elevation: 10.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal:8.0),
                          child: Text(countries[index]['name'], style: TextStyle(fontSize: 18),),
                        )
                    )
                );
          },
        ) : Center(child: CircularProgressIndicator(),)
      ),
    );
  }
}