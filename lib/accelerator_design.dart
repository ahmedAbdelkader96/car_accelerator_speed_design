import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';


class DialGauge extends StatefulWidget {
  const DialGauge({Key key}) : super(key: key);

  @override
  _DialGaugeState createState() => _DialGaugeState();
}

class _DialGaugeState extends State<DialGauge> with SingleTickerProviderStateMixin{
  var _sliderValue = 0.0;
//  final items = [0, 5, 10, 25, 50, 52, 250, 500, 1000];
  final items =
      [0, 40, 80, 120 , 160, 200, 240, 150, 250].map((e) => e * 2).toList();
  final StreamController _dividerController = StreamController<int>();

  double accelerator = 100;
  AnimationController _animationController ;
  Animation<double> tween2;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 5),);

    tween2 = Tween<double>(begin: 0.0, end: 100.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn));
    _animationController.addListener(() {
      setState(() {_sliderValue=tween2.value;print("newwwwwwwwww${tween2.value}");});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceAround,

      children: [
        const SizedBox(height: 40,),
        const Center(
          child: Text(
            'Accelerator Design',
            style:  TextStyle(
                color: Colors.black87,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20.0,right: 10),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * .25,
          alignment: Alignment.center,
          child: CustomPaint(
            child: Container(),
            painter: SpeedChecker(value: _sliderValue, items: items,
                indicatorColor:  _sliderValue==0?Colors.indigoAccent:_sliderValue<20? Colors.green:
                _sliderValue>20 && _sliderValue<50? Colors.amber: Colors.red,
            speedColor:  _sliderValue==0?Colors.indigoAccent:_sliderValue<20? Colors.green:
            _sliderValue>20 && _sliderValue<50? Colors.amber: Colors.red,
            arcColor:  _sliderValue==0?Colors.indigoAccent: _sliderValue<=20? Colors.green:
            _sliderValue>20 && _sliderValue<50? Colors.amber: Colors.red),
          ),
        ),
        const SizedBox(height: 10,),
        const Center(
          child:  Text(
            'Speed Meter',
            style:  TextStyle(
                color:  Colors.black87,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10,),

        _fakeDataFeeder(context),
        const SizedBox(height: 12,),

      ],
    );
  }

  Column _fakeDataFeeder(BuildContext context) {
    return Column(
     // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor:_sliderValue==0?Colors.indigoAccent: _sliderValue<=20? Colors.green:
            _sliderValue>20 && _sliderValue<50? Colors.amber: Colors.red,
            inactiveTrackColor: _sliderValue==0?Colors.indigoAccent: _sliderValue<=20? Colors.green:
            _sliderValue>20 && _sliderValue<50? Colors.amber: Colors.red,
            inactiveTickMarkColor: Colors.deepPurpleAccent,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 30.0),

            thumbColor: _sliderValue==0?Colors.indigoAccent: _sliderValue<=20? Colors.green:
            _sliderValue>20 && _sliderValue<50? Colors.amber: Colors.red,

          ),
          child: Slider(
            value: _sliderValue,
            min: 0.0,
            max: 100.0,
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
            },
          ),
        ),

        SpinningWheel(
          Image.asset('assets/steering-wheel.png'),
          width: 180,
          height: 180,
          initialSpinAngle: 0,
          spinResistance: 0.6,
          canInteractWhileSpinning: false,
          dividers: 8,
          onUpdate:  _dividerController.add,
          onEnd: _dividerController.add,

        ),
        const SizedBox(height:30,),


        GestureDetector(
          child: AnimatedContainer(
              height: accelerator,width: accelerator,
              duration: const Duration(milliseconds: 300),

              child: Image.asset('assets/accelerator.png' ,)),

          onLongPress: (){
            setState(()  {
              accelerator=80;
            });},

          onLongPressStart: (LongPressStartDetails){
            _animationController.forward();

          },
          onLongPressUp: (){
            setState(() {
              _animationController.reverse();
              accelerator=100;
              //_sliderValue=0;

            });
          },

        ),
        const SizedBox(height:10,),

        Center(child: Text("Accelerator",style: TextStyle(fontSize: accelerator==50? 15 :25),)),

      ],
    );
  }
}


class SpeedChecker extends CustomPainter {
  final double value;
  final List items;
  final indicatorColor;
  final speedColor;
  final arcColor;


  SpeedChecker({ this.value,  this.items,this.indicatorColor,this.speedColor,this.arcColor});

  var _centerX = 0.0;
  var _centerY = 0.0;
  var startFromAngle = 180; // this should be multiple of 30.0
  var _arcRadius = 110.0;
  var handHeight = 95;

  @override
  void paint(Canvas canvas, Size size) {
    _centerX = size.width / 2;
    _centerY = size.height - 10;

    var circle = 360;
    var hemisphere = circle / 2;
    var sweepAngle = circle + hemisphere - 2 * startFromAngle;

    var center = Offset(_centerX, _centerY);

    final mainPaint = Paint()
      ..color = arcColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    var rect = Rect.fromCircle(center: center, radius: _arcRadius);

    canvas.drawArc(rect, startFromAngle.toRadian(), sweepAngle.toRadian(),
        false, mainPaint);

    for (var num = 0; num < 12; num++) {
      var ang = num * circle / 12 + startFromAngle;
      if (ang >= sweepAngle + startFromAngle + 30.0) {
        continue;
      }

      _drawNumbers(canvas, size, ang, items.length > num ? items[num] : 1000,
          _arcRadius + 40.0);

      _drawStrokedMinLines(canvas, _arcRadius + 20.0, ang, _arcRadius + 10.0,
          ang >= sweepAngle + startFromAngle);
    }

    // drawing pointers
    var angle = value * sweepAngle ~/ 100 + startFromAngle;
    var x = _centerX + handHeight * math.cos(angle.toRadian());
    var y = _centerY + handHeight * math.sin(angle.toRadian());

// drawing pointer needle // hand
    canvas.drawLine(
      center,
      Offset(x, y),
      Paint()
        ..strokeWidth = 10.0
        ..color = indicatorColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // draw text at showPercentage
    _drawPercentage(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _drawNumbers(
      Canvas canvas, Size size, double angle, int num, double radius) {
    final textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 17.0,
    );
    final textSpan = TextSpan(
      text: num.toString(),
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final double h = textPainter.height;

    var x = _centerX + radius * math.cos(angle.toRadian());
    var y = _centerY + radius * math.sin(angle.toRadian());

    var offset = Offset(x, y);
    // at center
    if ((x - _centerX).abs() < 5.0) {
      offset = Offset(x - textPainter.width / 2, y - h * .8);
    } else if (x < _centerX) {
      offset = Offset(x - textPainter.width, y - h / 2);
    } else {
      offset = Offset(x, y - h / 2);
    }

    textPainter.paint(canvas, offset);
  }

  void _drawStrokedMinLines(Canvas canvas, double radius2, double angle,
      double radius, bool drawOnlyHand) {
    if (drawOnlyHand) {
      _drawStrokedLine(canvas, radius, radius2, angle);
      return;
    }

    for (var newAngle = angle; newAngle < angle + 30; newAngle += 6) {
      if (newAngle == angle) {
        _drawStrokedLine(canvas, radius, radius2, newAngle);
      } else {
        var x = _centerX + radius * math.cos(newAngle.toRadian());
        var y = _centerY + radius * math.sin(newAngle.toRadian());

        var x2 = _centerX + radius2 * math.cos(newAngle.toRadian());
        var y2 = _centerY + radius2 * math.sin(newAngle.toRadian());

        canvas.drawLine(
            Offset(x, y), Offset(x2, y2), Paint()..color = Colors.black);
      }
    }
  }

  void _drawStrokedLine(
      Canvas canvas, double radius, double radius2, double angle) {
    var x = _centerX + radius * math.cos(angle.toRadian());
    var y = _centerY + radius * math.sin(angle.toRadian());

    var x2 = _centerX + radius2 * math.cos(angle.toRadian());
    var y2 = _centerY + radius2 * math.sin(angle.toRadian());
    canvas.drawLine(
        Offset(x, y),
        Offset(x2, y2),
        Paint()
          ..color = speedColor
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..strokeWidth = 05.0);
  }

  void _drawPercentage(Canvas canvas, Size size) {
    final textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 17.0,
    );
    final textSpan = TextSpan(
      text: (value.round()).toString()+" %",
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textPainter.paint(
        canvas, Offset(_centerX - textPainter.width / 2, _centerY - 50));
  }
}

extension DoubleExtensions on double {
  double toRadian() {
    return this * math.pi / 180;
  }
}

extension IntExtensions on int {
  double toRadian() {
    return this * math.pi / 180;
  }
}
