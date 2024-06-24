import 'package:flutter/material.dart';

class InfoProject extends StatefulWidget {
  const InfoProject({super.key});

  @override
  State<InfoProject> createState() => _InfoProjectState();
}

class _InfoProjectState extends State<InfoProject>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}