import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../model/categories_news_model.dart';
import '../model/news_headlines_model.dart';
import '../utils/colors.dart';
import '../view/news_view_model.dart';
import 'category_screen.dart';
import 'news_detail_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum NewsFilterList { bbcNews, bbcSport, espn, foxSports, theverge }

class _HomeScreenState extends State<HomeScreen> {
  NewsFilterList? selectedMenu;
  String name = "bbc-news";
  final format = DateFormat('MMMM dd, yyyy');

  NewsViewModel newsViewModel = NewsViewModel();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: beige,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CategoryScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.menu_book_rounded,
            color: Colors.black,
          ),
        ),
        backgroundColor: beige,
        elevation: 0,
        title: const Center(
          child: Text(
            "News",
            style: TextStyle(
              color: charcoal,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<NewsFilterList>(
            initialValue: selectedMenu,
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            color: beige,
            onSelected: (NewsFilterList item) {
              setState(() {
                selectedMenu = item;
                switch (item) {
                  case NewsFilterList.bbcNews:
                    name = "bbc-news";
                    break;
                  case NewsFilterList.bbcSport:
                    name = "bbc-sport";
                    break;
                  case NewsFilterList.espn:
                    name = "espn";
                    break;
                  case NewsFilterList.foxSports:
                    name = "fox-sports";
                    break;
                  case NewsFilterList.theverge:
                    name = "the-verge";
                    break;
                }
              });
            },
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<NewsFilterList>>[
              const PopupMenuItem<NewsFilterList>(
                value: NewsFilterList.bbcNews,
                child: Text("BBC News"),
              ),
              const PopupMenuItem<NewsFilterList>(
                value: NewsFilterList.bbcSport,
                child: Text("BBC Sports"),
              ),
              const PopupMenuItem<NewsFilterList>(
                value: NewsFilterList.espn,
                child: Text("ESPN"),
              ),
              const PopupMenuItem<NewsFilterList>(
                value: NewsFilterList.theverge,
                child: Text("The verge"),
              ),
              const PopupMenuItem<NewsFilterList>(
                value: NewsFilterList.foxSports,
                child: Text("Fox Sports"),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height:  height * .55,
              width: width,
              child: FutureBuilder<NewsHeadlineModel>(
                future: newsViewModel.getNewsApi(name),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: roseWood,
                      ),
                    );
                  } else if (snapshot.hasData) { // Check if snapshot.data is not null
                    return ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());

                          String? newsImage = snapshot.data!.articles![index].urlToImage;
                          String? newsTitle = snapshot.data!.articles![index].title;
                          String? newsDate = snapshot.data!.articles![index].publishedAt;
                          String? newsAuthor = snapshot.data!.articles![index].author;
                          String? newsDesc = snapshot.data!.articles![index].description;
                          String? newsContent = snapshot.data!.articles![index].content;
                          String? newsSource = snapshot.data!.articles![index].source?.name;

                          return InkWell(
                            onTap: () {
                              if (newsImage != null && newsTitle != null && newsDate != null &&
                                  newsAuthor != null && newsDesc != null && newsContent != null &&
                                  newsSource != null) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                    NewsDetailScreen(newsImage, newsTitle, newsDate, newsAuthor,
                                        newsDesc, newsContent, newsSource)));
                              }
                            },
                            child: SizedBox(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: height * 0.6,
                                    width: width * 0.9,
                                    padding: EdgeInsets.symmetric(horizontal: height * 0.02),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: CachedNetworkImage(
                                        imageUrl: newsImage ?? '', // Use the null-aware operator
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(child: spinKit2,),
                                        errorWidget: (context, url, error) => const Icon(Icons.error_outline, color: Colors.red,),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 7,
                                    child: Card(
                                      elevation: 5,
                                      color: dun,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        padding: const EdgeInsets.all(15),
                                        height: height * 0.22,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: width * 0.7,
                                              child: Text(newsTitle!,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              width: width * 0.7,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(newsSource ?? '',
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                                                  ),
                                                  Text(format.format(dateTime),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else {
                    return const Center(
                      child: Text("No data available."),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.getCategoriesApi("Entertainment"),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: roseWood,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.articles?.length ?? 0,
                        itemBuilder: (context, index) {
                          final articles = snapshot.data!.articles;
                          if (articles != null) {
                            DateTime dateTime = DateTime.parse(articles[index].publishedAt.toString());
                            String? newsImage = articles[index].urlToImage;
                            String? newsTitle = articles[index].title;
                            String? newsDate = articles[index].publishedAt;
                            String? newsAuthor = articles[index].author;
                            String? newsDesc = articles[index].description;
                            String? newsContent = articles[index].content;
                            String? newsSource = articles[index].source?.name;

                            return InkWell(
                              onTap: () {
                                if (newsImage != null && newsTitle != null && newsDate != null &&
                                    newsAuthor != null && newsDesc != null && newsContent != null &&
                                    newsSource != null) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                      NewsDetailScreen(
                                        newsImage,
                                        newsTitle,
                                        newsDate,
                                        newsAuthor,
                                        newsDesc,
                                        newsContent,
                                        newsSource,
                                      )
                                  ));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  color: dun,
                                  elevation: 4,
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: CachedNetworkImage(
                                          imageUrl: newsImage ?? '', // Modified this line
                                          fit: BoxFit.cover,
                                          height: height * 0.18,
                                          width: width * 0.4,
                                          placeholder: (context, url) => Container(
                                            child: const Center(
                                              child: SpinKitCircle(
                                                size: 50,
                                                color: roseWood,
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => const Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: height * 0.18,
                                          padding: const EdgeInsets.only(left: 15),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                newsTitle!,
                                                maxLines: 3,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const Spacer(),
                                              SizedBox(
                                                width: width * 0.7,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        newsSource ?? '',
                                                        maxLines: 2,
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 14,
                                                          color: Colors.black54,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      format.format(dateTime),
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: Text("No data available."),
                            );
                          }
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else {
                    return const Center(
                      child: Text("No data available."),
                    );
                  }
                },
              ),
            )

          ],
        ),
      ),
    );
  }
}
