import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/components/spaces.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/constants/theme.dart';


class ListProfile extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subTitle;
  final Function()? onTap;

  const ListProfile({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subTitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Card(
        color: Colors.white, // Menambahkan warna background pada Card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Menambahkan border radius
        ),
        child: Row(
          children: [
            // Image/Icon Menu
            Container(
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset(
                imagePath, // Menggunakan SvgPicture untuk menampilkan gambar SVG
                width: 56,
                height: 56,
              ),
            ),

            // Text and Subtitle
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(left: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 'Title
                    Text(
                      title,
                      style: fontPoppins.copyWith(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: weightMedium,
                        color: Colors.black,
                        fontSize: sizeMedium,
                      ),
                    ),

                    const SpaceHeight(4),

                    // Subtitle
                    Text(
                      subTitle,
                      style: fontPoppins.copyWith(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: weightReguler,
                        color: Colors.black,
                        fontSize: sizeSmall,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
