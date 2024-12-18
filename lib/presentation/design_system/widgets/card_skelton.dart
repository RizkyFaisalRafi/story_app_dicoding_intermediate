import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/components/spaces.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/constants/theme.dart';
import 'skelton.dart';

class CardSkelton extends StatelessWidget {
  const CardSkelton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Card(
          child: ListTile(
            // Photo
            leading: Skelton(
              width: 100,
              height: 80,
            ),

            // Title Name
            title: Skelton(),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpaceHeight(4),
                // *Description
                Skelton(
                  width: 180,
                ),
                SpaceHeight(8),

                // *Id Story
                Row(
                  children: [
                    // Icon
                    Skelton(
                      width: 24,
                      height: 24,
                    ),
                    SpaceWidth(8),

                    // Title
                    Skelton(
                      width: 130,
                    ),
                  ],
                ),

                // *Created at
                Row(
                  children: [
                    // Icon
                    Skelton(
                      width: 24,
                      height: 24,
                    ),
                    SpaceWidth(8),

                    // Title
                    Skelton(
                      width: 130,
                    ),
                  ],
                ),

                // *Latitude
                Row(
                  children: [
                    // Icon
                    Skelton(
                      width: 24,
                      height: 24,
                    ),
                    SpaceWidth(8),

                    // Title
                    Skelton(
                      width: 130,
                    ),
                  ],
                ),

                // *Longitude
                Row(
                  children: [
                    // Icon
                    Skelton(
                      width: 24,
                      height: 24,
                    ),
                    SpaceWidth(8),

                    // Title
                    Skelton(
                      width: 130,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Shimer Loading Effect
        Positioned.fill(
          child: Shimmer(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: const [
                0.4,
                0.5,
                0.6,
              ],
              colors: [
                Colors.grey.withOpacity(0),
                Colors.grey.withOpacity(0.5),
                Colors.grey.withOpacity(0),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
              child: Container(
                color: Colors.white.withOpacity(
                  1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CardList extends StatelessWidget {
  const CardList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: defaultMargin,
          right: defaultMargin,
          bottom: defaultMargin,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4, // Menampilkan 5 card
          itemBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 8.0), // Jarak antar card
              child: CardSkelton(),
            );
          },
        ),
      ),
    );
  }
}
