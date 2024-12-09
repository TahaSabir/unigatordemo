import 'dart:math';
import 'package:flutter/material.dart';

class NeuralNode {
  Offset position;
  List<NeuralNode> connections;
  double speed;
  double direction;

  NeuralNode(this.position)
      : connections = [],
        speed = Random().nextDouble() * 0.5,
        direction = Random().nextDouble() * 2 * pi;
}

class NeuralNetworkPainter extends CustomPainter {
  final List<NeuralNode> nodes;
  final Animation<double> animation;

  NeuralNetworkPainter({
    required this.nodes,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final nodePaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Update node positions
    for (var node in nodes) {
      node.position = Offset(
        (node.position.dx + cos(node.direction) * node.speed) % size.width,
        (node.position.dy + sin(node.direction) * node.speed) % size.height,
      );

      // Draw connections
      for (var connection in node.connections) {
        double distance = (node.position - connection.position).distance;
        double opacity = 1.0 - (distance / 100.0);
        opacity = opacity.clamp(0.0, 0.3);

        canvas.drawLine(
          node.position,
          connection.position,
          paint..color = Colors.white.withOpacity(opacity),
        );
      }

      // Draw nodes
      canvas.drawCircle(node.position, 3.0, nodePaint);
    }
  }

  @override
  bool shouldRepaint(NeuralNetworkPainter oldDelegate) => true;
}
