import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../model/categories_news_model.dart';
import '../utils/colors.dart';
import '../view/news_view_model.dart';
import 'news_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

String categoryName = "General"; // Fixed the typo
final format = DateFormat('MMMM dd, yyyy');

List<String> categoriesList = [
  "General",
  "Entertainment",
  "Health",
  "Sports",
  "Business",
  "Technology",
];

NewsViewModel newsViewModel = NewsViewModel();

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width; // Fixed MediaQuery usage
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: dun,
      appBar: AppBar(
        backgroundColor: dun,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoriesList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      categoryName = categoriesList[index];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: categoryName == categoriesList[index]
                            ? roseWood
                            : charcoal,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(
                          child: Text(
                            categoriesList[index],
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.getCategoriesApi(categoryName),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: roseWood,
                    ),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());
                      return InkWell(
                        onTap: (){
                          String newsImage =
                          snapshot.data!.articles![index].urlToImage!;
                          String newsTitle =
                          snapshot.data!.articles![index].title!;
                          String newsDate =
                          snapshot.data!.articles![index].publishedAt!;
                          String newsAuthor =
                          snapshot.data!.articles![index].author!;
                          String newsDesc =
                          snapshot.data!.articles![index].description!;
                          String newsContent =
                          snapshot.data!.articles![index].content!;
                          String newsSource =
                          snapshot.data!.articles![index].source!.name!;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen
                            (newsImage,
                              newsTitle,
                              newsDate,
                               newsAuthor,
                              newsDesc,
                              newsContent,
                              newsSource)
                           ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Card(
                            color: mistryRose,
                            elevation: 4,
                            child: Row(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot
                                          .data!.articles![index].urlToImage!
                                          .toString() ?? '', // Modified this line
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
                                    )),
                                Expanded(
                                  child: Container(
                                    height: height * 0.18,
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
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
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  snapshot.data!.articles![index]
                                                      .source!.name
                                                      .toString(),
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
                    },
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
    );
  }
}
