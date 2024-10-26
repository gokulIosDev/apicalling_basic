import 'dart:convert';
import 'dart:developer';

import 'package:api/models/newsModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News App"),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getNews(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.hasError.toString()),
              );
            } else if (snapshot.data == null || snapshot.data!.articles!.isEmpty) {
              return Center(
                child: Text("Data not Found"),
              );
            }
            return ListView.builder(itemBuilder: (context, index) {
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      snapshot.data!.articles![index].urlToImage.toString()),
                ),
                title: Text(snapshot.data!.articles![index].title.toString()),
                subtitle: Text(snapshot.data!.articles![index].description.toString()),
              );
            },itemCount: snapshot.data!.articles!.length,);
          }),
    ); //Future Builder
  }

  Future<NewsModel> getNews(BuildContext context) async {
    final response = await http.get(Uri.parse(
        "https://newsapi.org/v2/everything?q=tesla&from=2024-10-24&sortBy=publishedAt&apiKey=11f999fcddb54b70b2dab328a0b8c660"));
    if (response.statusCode == 200) {
      Map<String, dynamic> reponseData = jsonDecode(response.body);
      print(reponseData);
      String meaasge = reponseData["message"];
      NewsModel newsModel = NewsModel.fromJson(reponseData);
      return newsModel;
    } else {
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.body)));
      //log(response.body);
      //String message  = response.body["message"].toString();
      //log(response.body["message"].toString());
     // return NewsModel();
      throw Exception(response.body);
    }
  }
}
