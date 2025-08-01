import 'package:flutter/material.dart';

class BleedingCell extends StatefulWidget {
  final bool top;
  final bool left;
  final bool right;
  final bool bottom;
  final ValueChanged<int> onTapped;

  const BleedingCell({
    super.key,
    required this.top,
    required this.left,
    required this.right,
    required this.bottom,
    required this.onTapped,
  });

  @override
  State<BleedingCell> createState() => _BleedingCellState();
}

class _BleedingCellState extends State<BleedingCell> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _handleTap(details.localPosition),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 0.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: CustomPaint(
          painter: _BleedingCellPainter(
            top: widget.top,
            left: widget.left,
            right: widget.right,
            bottom: widget.bottom,
          ),
        ),
      ),
    );
  }

  void _handleTap(Offset localPosition) {
    if (_pointInTriangle(localPosition, Offset(0, 0), Offset(30, 30), Offset(60, 0))) {
      widget.onTapped(1); // Top triangle
    } 
    else if (_pointInTriangle(localPosition, Offset(0, 0), Offset(30, 30), Offset(0, 60))) {
      widget.onTapped(2); // Left triangle
    }
    else if (_pointInTriangle(localPosition, Offset(60, 0), Offset(30, 30), Offset(60, 60))) {
      widget.onTapped(3); // Right triangle
    }
    else if (_pointInTriangle(localPosition, Offset(0, 60), Offset(30, 30), Offset(60, 60))) {
      widget.onTapped(4); // Bottom triangle
    }
  }

  bool _pointInTriangle(Offset p, Offset a, Offset b, Offset c) {
    final d = (b.dy - c.dy) * (a.dx - c.dx) + (c.dx - b.dx) * (a.dy - c.dy);
    final u = ((b.dy - c.dy) * (p.dx - c.dx) + (c.dx - b.dx) * (p.dy - c.dy)) / d;
    final v = ((c.dy - a.dy) * (p.dx - c.dx) + (a.dx - c.dx) * (p.dy - c.dy)) / d;
    final w = 1 - u - v;
    return u >= 0 && v >= 0 && w >= 0;
  }
}

class _BleedingCellPainter extends CustomPainter {
  final bool top;
  final bool left;
  final bool right;
  final bool bottom;

  _BleedingCellPainter({
    required this.top,
    required this.left,
    required this.right,
    required this.bottom,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw diagonals
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), linePaint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), linePaint);

    // Draw triangle highlights
    if (top) _drawTriangleHighlight(canvas, [Offset(0, 0), Offset(30, 30), Offset(60, 0)]);
    if (left) _drawTriangleHighlight(canvas, [Offset(0, 0), Offset(30, 30), Offset(0, 60)]);
    if (right) _drawTriangleHighlight(canvas, [Offset(60, 0), Offset(30, 30), Offset(60, 60)]);
    if (bottom) _drawTriangleHighlight(canvas, [Offset(0, 60), Offset(30, 30), Offset(60, 60)]);

    // Draw symbols
    _drawSymbol(canvas, top ? '+' : '-', top ? Colors.red : Colors.green, 
      _triangleCentroid([Offset(0, 0), Offset(30, 30), Offset(60, 0)]));
    _drawSymbol(canvas, left ? '+' : '-', left ? Colors.red : Colors.green, 
      _triangleCentroid([Offset(0, 0), Offset(30, 30), Offset(0, 60)]));
    _drawSymbol(canvas, right ? '+' : '-', right ? Colors.red : Colors.green, 
      _triangleCentroid([Offset(60, 0), Offset(30, 30), Offset(60, 60)]));
    _drawSymbol(canvas, bottom ? '+' : '-', bottom ? Colors.red : Colors.green, 
      _triangleCentroid([Offset(0, 60), Offset(30, 30), Offset(60, 60)]));
  }

  void _drawTriangleHighlight(Canvas canvas, List<Offset> points) {
    final highlightPaint = Paint()
      ..color = Colors.red.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    
    final path = Path()
      ..moveTo(points[0].dx, points[0].dy)
      ..lineTo(points[1].dx, points[1].dy)
      ..lineTo(points[2].dx, points[2].dy)
      ..close();
    
    canvas.drawPath(path, highlightPaint);
  }

  Offset _triangleCentroid(List<Offset> points) {
    return Offset(
      (points[0].dx + points[1].dx + points[2].dx) / 3,
      (points[0].dy + points[1].dy + points[2].dy) / 3,
    );
  }

  void _drawSymbol(Canvas canvas, String text, Color color, Offset center) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    
    textPainter.paint(
      canvas, 
      center - Offset(textPainter.width/2, textPainter.height/2)
    );
  }

  @override
  bool shouldRepaint(_BleedingCellPainter oldDelegate) =>
      top != oldDelegate.top ||
      left != oldDelegate.left ||
      right != oldDelegate.right ||
      bottom != oldDelegate.bottom;
}