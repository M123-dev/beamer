import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';

import 'beam_page.dart';
import 'beam_location.dart';
import 'beamer_back_button_dispatcher.dart';
import 'beamer_router_delegate.dart';
import 'beamer_provider.dart';

/// Central place for creating, accessing and modifying a Router subtree.
class Beamer extends StatefulWidget {
  Beamer({
    Key key,
    @required this.routerDelegate,
  }) : super(key: key);

  /// Responsible for beaming, updating and rebuilding the page stack.
  final BeamerRouterDelegate routerDelegate;

  /// Access Beamer's [routerDelegate].
  static BeamerRouterDelegate of(BuildContext context) {
    try {
      return Router.of(context).routerDelegate;
    } catch (e) {
      assert(BeamerProvider.of(context) != null,
          'There was no Router nor BeamerProvider in current context. If using MaterialApp.builder, wrap the MaterialApp.router in BeamerProvider to which you pass the same routerDelegate as to MaterialApp.router.');
      return BeamerProvider.of(context).routerDelegate;
    }
  }

  @override
  State<StatefulWidget> createState() => BeamerState();
}

class BeamerState extends State<Beamer> {
  BeamerRouterDelegate get routerDelegate => widget.routerDelegate;
  BeamLocation get currentLocation => widget.routerDelegate.currentLocation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      widget.routerDelegate.navigationNotifier =
          (Router.of(context).routerDelegate as BeamerRouterDelegate)
              .navigationNotifier;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Router(
      routerDelegate: widget.routerDelegate,
      backButtonDispatcher:
          BeamerBackButtonDispatcher(delegate: widget.routerDelegate),
    );
  }
}

extension BeamerExtensions on BuildContext {
  /// See [BeamerRouterDelegate.beamTo]
  void beamTo(
    BeamLocation location, {
    bool beamBackOnPop = false,
    bool stacked = true,
    bool replaceCurrent = false,
  }) {
    Beamer.of(this).beamTo(
      location,
      beamBackOnPop: beamBackOnPop,
      stacked: stacked,
      replaceCurrent: replaceCurrent,
    );
  }

  /// See [BeamerRouterDelegate.beamToNamed]
  void beamToNamed(
    String uri, {
    Map<String, dynamic> data = const <String, dynamic>{},
    bool beamBackOnPop = false,
    bool stacked = true,
    bool replaceCurrent = false,
  }) {
    Beamer.of(this).beamToNamed(
      uri,
      data: data,
      beamBackOnPop: beamBackOnPop,
      stacked: stacked,
      replaceCurrent: replaceCurrent,
    );
  }

  /// See [BeamerRouterDelegate.beamBack]
  void beamBack() => Beamer.of(this).beamBack();

  /// See [BeamerRouterDelegate.currentLocation]
  BeamLocation get currentBeamLocation => Beamer.of(this).currentLocation;

  /// See [BeamerRouterDelegate.currentPages]
  List<BeamPage> get currentBeamPages => Beamer.of(this).currentPages;

  /// See [BeamerRouterDelegate.canBeamBack]
  bool get canBeamBack => Beamer.of(this).canBeamBack;

  /// See [BeamerRouterDelegate.beamBackLocation]
  BeamLocation get beamBackLocation => Beamer.of(this).beamBackLocation;
}
