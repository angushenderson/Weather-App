import 'package:flutter/material.dart';

class PrimaryHeader extends StatelessWidget {
  final String heading_text;
  final Widget right_button;

  PrimaryHeader(this.heading_text, this.right_button);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.menu_rounded,
                    size: 36.0,
                    color: Theme.of(context).accentColor,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 2.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.my_location_rounded,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                this.heading_text,
                                style: Theme.of(context).textTheme.headline1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 3.0,
                        ),
                        child: Text(
                          'Wednesday, 10 Feb',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ],
                  ),
                  right_button,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
