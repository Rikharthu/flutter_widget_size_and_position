import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Keys are required to access widget in order to fetch their sizes
  GlobalKey _keyRed = GlobalKey();
  GlobalKey _keyPurple = GlobalKey();
  GlobalKey _keyGreen = GlobalKey();

  _Dimension _currentDimension = _Dimension.SIZE;
  Size _sizeRed;
  Size _sizePurple;
  Size _sizeGreen;
  Offset _offsetRed;
  Offset _offsetPurple;
  Offset _offsetGreen;

  @override
  void initState() {
    // Used to get sizes/positions just after layout, without initially pressing button
    WidgetsBinding.instance.addPersistentFrameCallback(_afterLayout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String textRed = "";
    String textPurple = "";
    String textGreen = "";
    if (_currentDimension == _Dimension.POSITION && _offsetRed != null) {
      textRed = "(${_offsetRed.dx}, ${_offsetRed.dy})";
      textPurple = "(${_offsetPurple.dx}, ${_offsetPurple.dy})";
      textGreen = "(${_offsetGreen.dx}, ${_offsetGreen.dy})";
    } else if (_currentDimension == _Dimension.SIZE && _sizeRed != null) {
      textRed = "${_sizeRed.width} x ${_sizeRed.height}";
      textPurple = "${_sizePurple.width} x ${_sizePurple.height}";
      textGreen = "${_sizeGreen.width} x ${_sizeGreen.height}";
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Sice and Position"),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              key: _keyRed,
              flex: 2,
              child: Container(
                color: Colors.red,
                child: Center(
                  child: Text(
                    textRed,
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                ),
              ),
            ),
            Flexible(
              key: _keyPurple,
              flex: 1,
              child: Container(
                color: Colors.purple,
                child: Center(
                  child: Text(
                    textPurple,
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                ),
              ),
            ),
            Flexible(
              key: _keyGreen,
              flex: 3,
              child: Container(
                color: Colors.green,
                child: Center(
                  child: Text(
                    textGreen,
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                ),
              ),
            ),
            Spacer(),
            _buildControlPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Padding(
      padding: EdgeInsets.only(bottom: 32.0, top: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            child: Text("Get Sizes"),
            padding: const EdgeInsets.all(15.0),
            color: Colors.grey,
            onPressed: _getSizes,
          ),
          MaterialButton(
            child: Text("Get Positions"),
            padding: const EdgeInsets.all(15.0),
            color: Colors.grey,
            onPressed: _getPositions,
          ),
        ],
      ),
    );
  }

  void _getSizes() {
    // To get widget's size we need to obtain it's associated RenderBox
    final RenderBox renderBoxRed = _keyRed.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;

    final RenderBox renderBoxPurple =
        _keyPurple.currentContext.findRenderObject();
    final RenderBox renderBoxGreen =
        _keyGreen.currentContext.findRenderObject();
    this.setState(() {
      _currentDimension = _Dimension.SIZE;
      _sizeRed = renderBoxRed.size;
      _sizePurple = renderBoxPurple.size;
      _sizeGreen = renderBoxGreen.size;
    });
  }

  void _getPositions() {
    final RenderBox renderBoxRed = _keyRed.currentContext.findRenderObject();
    final RenderBox renderBoxPurple =
        _keyPurple.currentContext.findRenderObject();
    final RenderBox renderBoxGreen =
        _keyGreen.currentContext.findRenderObject();

    setState(() {
      _currentDimension = _Dimension.POSITION;
      // Obtain the position of the Widget relative to the top-left of
      // the defined position (in this case we are using 0.0 it means the
      // top-left corner of our current screen).
      _offsetRed = renderBoxRed.localToGlobal(Offset.zero);
      _offsetPurple = renderBoxPurple.localToGlobal(Offset.zero);
      _offsetGreen = renderBoxGreen.localToGlobal(Offset.zero);
    });
  }

  void _afterLayout(Duration timeStamp) {
    _getSizes();
  }
}

enum _Dimension { SIZE, POSITION }
