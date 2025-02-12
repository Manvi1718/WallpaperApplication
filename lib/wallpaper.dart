import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/full_screen.dart';

class Wallpaper extends StatefulWidget {
  const Wallpaper({super.key});

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  List images = [];
  int page = 1;
  fetchApi() async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization':
              'Nag7o2YVPPuPUMOlbeLhp4MlbxJ1ShlrosTpdyz1lT3NO4kpqwFF7TT2'
        }).then(
      (value) {
        Map result = jsonDecode(value.body);
        // print(result);
        setState(() {
          images = result['photos'];
        });
      },
    );
  }

  loadmore() async {
    setState(() {
      page = page + 1;
    });
    String url = 'https://api.pexels.com/v1/curated?per_page=80&page=$page';

    await http.get(Uri.parse(url), headers: {
      'Authorization':
          'Nag7o2YVPPuPUMOlbeLhp4MlbxJ1ShlrosTpdyz1lT3NO4kpqwFF7TT2'
    }).then(
      (value) {
        Map result = jsonDecode(value.body);
        setState(() {
          images.addAll(result['photos']);
        });
      },
    );
  }

  @override
  void initState() {
    fetchApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallpaper'),
        backgroundColor: const Color.fromARGB(255, 44, 44, 44),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: images.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 2,
                crossAxisCount: 3,
                childAspectRatio: 2 / 3,
                mainAxisSpacing: 2,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return FullScreen(
                            imageUrl: images[index]['src']['large2x']);
                      },
                    ));
                  },
                  child: Container(
                    color: Colors.white,
                    child: Image.network(
                      images[index]['src']['tiny'],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          InkWell(
            onTap: () {
              loadmore();
            },
            child: SizedBox(
              height: 60,
              width: double.infinity,
              // color: Colors.black,
              child: Center(
                child: Text(
                  'Load More',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
