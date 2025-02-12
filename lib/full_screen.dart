import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager_plus/wallpaper_manager_plus.dart';

class FullScreen extends StatefulWidget {
  final String imageUrl;
  const FullScreen({super.key, required this.imageUrl});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  Future<void> setWallpaper() async {
    String url = widget.imageUrl;

    var cachedImage = await DefaultCacheManager().getSingleFile(url);
    int location = WallpaperManagerPlus.homeScreen;
    await WallpaperManagerPlus().setWallpaper(cachedImage, location);
    print('--WALLPAPER SET SUCCESSFULLY ----------');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image.network(widget.imageUrl),
          ),
          InkWell(
            onTap: () {
              setWallpaper();
            },
            child: SizedBox(
              height: 60,
              width: double.infinity,
              // color: Colors.black,
              child: Center(
                child: Text(
                  'set Wallpaper',
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
