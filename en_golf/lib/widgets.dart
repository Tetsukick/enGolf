import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'olympic_bloc.dart';
import 'utils.dart';

/// A simple widget that builds different things on different platforms.
class PlatformWidget extends StatelessWidget {
  const PlatformWidget({
    Key key,
    @required this.androidBuilder,
    @required this.iosBuilder,
  })  : assert(androidBuilder != null),
        assert(iosBuilder != null),
        super(key: key);

  final WidgetBuilder androidBuilder;
  final WidgetBuilder iosBuilder;

  @override
  Widget build(context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return androidBuilder(context);
      case TargetPlatform.iOS:
        return iosBuilder(context);
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return null;
    }
  }
}

/// A platform-agnostic card with a high elevation that reacts when tapped.
///
/// This is an example of a custom widget that an app developer might create for
/// use on both iOS and Android as part of their brand's unique design.
class PressableCard extends StatefulWidget {
  const PressableCard({
    this.onPressed,
    this.color,
    this.flattenAnimation,
    this.child,
  });

  final VoidCallback onPressed;
  final Color color;
  final Animation<double> flattenAnimation;
  final Widget child;

  @override
  State<StatefulWidget> createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard>
    with SingleTickerProviderStateMixin {
  bool pressed = false;
  AnimationController controller;
  Animation<double> elevationAnimation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 40),
    );
    elevationAnimation =
        controller.drive(CurveTween(curve: Curves.easeInOutCubic));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double get flatten => 1 - widget.flattenAnimation.value;

  @override
  Widget build(context) {
    return Listener(
      onPointerDown: (details) {
        if (widget.onPressed != null) {
          controller.forward();
        }
      },
      onPointerUp: (details) {
        controller.reverse();
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (widget.onPressed != null) {
            widget.onPressed();
          }
        },
        // This widget both internally drives an animation when pressed and
        // responds to an external animation to flatten the card when in a
        // hero animation. You likely want to modularize them more in your own
        // app.
        child: AnimatedBuilder(
          animation:
              Listenable.merge([elevationAnimation, widget.flattenAnimation]),
          child: widget.child,
          builder: (context, child) {
            return Transform.scale(
              // This is just a sample. You likely want to keep the math cleaner
              // in your own app.
              scale: 1 - elevationAnimation.value * 0.03,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16) *
                    flatten,
                child: PhysicalModel(
                  elevation:
                      ((1 - elevationAnimation.value) * 10 + 10) * flatten,
                  borderRadius: BorderRadius.circular(12 * flatten),
                  clipBehavior: Clip.antiAlias,
                  color: widget.color,
                  child: child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// A platform-agnostic card representing a song which can be in a card state,
/// a flat state or anything in between.
///
/// When it's in a card state, it's pressable.
///
/// This is an example of a custom widget that an app developer might create for
/// use on both iOS and Android as part of their brand's unique design.
class HeroAnimatingSongCard extends StatelessWidget {
  HeroAnimatingSongCard(
      {this.song, this.color, this.heroAnimation, this.onPressed});

  final String song;
  final Color color;
  final Animation<double> heroAnimation;
  final VoidCallback onPressed;

  double get playButtonSize => 50 + 50 * heroAnimation.value;

  @override
  Widget build(context) {
    // This is an inefficient usage of AnimatedBuilder since it's rebuilding
    // the entire subtree instead of passing in a non-changing child and
    // building a transition widget in between.
    //
    // Left simple in this demo because this card doesn't have any real inner
    // content so this just rebuilds everything while animating.
    return AnimatedBuilder(
      animation: heroAnimation,
      builder: (context, child) {
        return PressableCard(
          onPressed: heroAnimation.value == 0 ? onPressed : null,
          color: color,
          flattenAnimation: heroAnimation,
          child: SizedBox(
            height: 250,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // The song title banner slides off in the hero animation.
                Positioned(
                  bottom: -80 * heroAnimation.value,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    color: Colors.black12,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      song,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // The play button grows in the hero animation.
                Padding(
                  padding:
                      EdgeInsets.only(bottom: 45) * (1 - heroAnimation.value),
                  child: Container(
                    height: playButtonSize,
                    width: playButtonSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black12,
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.play_arrow,
                        size: playButtonSize, color: Colors.black38),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A loading song tile's silhouette.
///
/// This is an example of a custom widget that an app developer might create for
/// use on both iOS and Android as part of their brand's unique design.
class SongPlaceholderTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          children: [
            Container(
              color: Theme.of(context).textTheme.body1.color,
              width: 130,
            ),
            Padding(
              padding: EdgeInsets.only(left: 12),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 9,
                    margin: EdgeInsets.only(right: 60),
                    color: Theme.of(context).textTheme.body1.color,
                  ),
                  Container(
                    height: 9,
                    margin: EdgeInsets.only(right: 20, top: 8),
                    color: Theme.of(context).textTheme.body1.color,
                  ),
                  Container(
                    height: 9,
                    margin: EdgeInsets.only(right: 40, top: 8),
                    color: Theme.of(context).textTheme.body1.color,
                  ),
                  Container(
                    height: 9,
                    margin: EdgeInsets.only(right: 80, top: 8),
                    color: Theme.of(context).textTheme.body1.color,
                  ),
                  Container(
                    height: 9,
                    margin: EdgeInsets.only(right: 50, top: 8),
                    color: Theme.of(context).textTheme.body1.color,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreCard extends StatelessWidget {
  const ScoreCard({
    Key key,
    this.color,
    this.player,
  }) : super(key: key);

  final Color color;
  final Player player;

  static final List<int> _scoreItems = new List.generate(201, (i) => i - 100);

  Widget _pickerItem(int str) {
    return Text(
      str.toString(),
      style: const TextStyle(fontSize: 28),
    );
  }

  @override
  Widget build(BuildContext context) {
    final olympicBloc = Provider.of<OlympicBloc>(context);
    return Card(
      elevation: 1.5,
      margin: EdgeInsets.fromLTRB(6, 12, 6, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        // Make it splash on Android. It would happen automatically if this
        // was a real card but this is just a demo. Skip the splash on iOS.
        onTap: defaultTargetPlatform == TargetPlatform.iOS ? null : () {},
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Text(
                  player.rank.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 16)),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: TextEditingController(text: player.name),
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white, width: 0.0),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            onFieldSubmitted: ((text) {
                              Player tempPlayer = player;
                              tempPlayer.name = text;
                              olympicBloc.changePlayerAction.add(tempPlayer);
                            }),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              'result: ${player.result.toString()}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      child: TextFormField(
                        focusNode: AlwaysDisabledFocusNode(),
                        controller: TextEditingController(text: _scoreItems.firstWhere((score) => score == player.score).toString()),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Score',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        onTap: () => showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            FocusScope.of(context).unfocus();
                            return Container(
                              height: MediaQuery.of(context).size.height / 3,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(initialItem: _scoreItems.indexOf(player.score)),
                                  itemExtent: 40,
                                  children: _scoreItems.map(_pickerItem).toList(),
                                  onSelectedItemChanged: ((pickerIndex) {
                                    player.score = _scoreItems[pickerIndex];
                                    olympicBloc.changePlayerAction.add(player);
                                  }),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}