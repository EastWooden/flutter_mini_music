import 'package:flutter/material.dart';

class Toast {
  show(BuildContext context,String msg) {
    var overlatState = Overlay.of(context);
    OverlayEntry overlayEntry;
    overlayEntry = new OverlayEntry(builder: (context){
      return buildToastLayout(msg);
    });
    overlatState.insert(overlayEntry);
  }

    static LayoutBuilder buildToastLayout(String msg) {
    return LayoutBuilder(builder: (context, constraints) {
      return IgnorePointer(
        ignoring: true,
        child: Container(
          child: Material(
            color: Colors.white.withOpacity(0),
            child: Container(
              child: Container(
                child: Text(
                  msg,
                  style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              margin: EdgeInsets.only(
                bottom: constraints.biggest.height * 0.15,
                left: constraints.biggest.width * 0.2,
                right: constraints.biggest.width * 0.2,
              ),
            ),
          ),
          alignment: Alignment.bottomCenter,
        ),
      );
    });
  }
}