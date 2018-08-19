import 'package:color_picker/src/circle_color.dart';
import 'package:color_picker/src/colors.dart';
import 'package:flutter/material.dart';

class MaterialColorPicker extends StatefulWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChange;
  final WrapAlignment colorsAlignment;
  final List<ColorSwatch> colors;

  const MaterialColorPicker(
      {Key key,
      this.selectedColor,
      this.onColorChange,
      this.colorsAlignment = WrapAlignment.start,
      this.colors = materialColors})
      : super(key: key);

  @override
  _MaterialColorPickerState createState() => _MaterialColorPickerState();
}

class _MaterialColorPickerState extends State<MaterialColorPicker> {
  static const double _kCircleColorSize = 47.0;
  static const double _kPadding = 9.0;

  static final _defaultValue = materialColors[0];

  List<ColorSwatch> _colors = materialColors;

  ColorSwatch _mainColor;
  Color _shadeColor;
  bool _isMainSelection;

  @override
  void initState() {
    super.initState();
    _initSelectedValue();
  }

  @protected
  void didUpdateWidget(covariant MaterialColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initSelectedValue();
  }

  void _initSelectedValue() {
    if (widget.colors != null) _colors = widget.colors;

    Color shadeColor = widget.selectedColor ?? _defaultValue;
    ColorSwatch mainColor = _findMainColor(shadeColor);

    if (mainColor == null) {
      mainColor = _colors[0];
      shadeColor = mainColor[500] ?? mainColor[400];
    }

    setState(() {
      _mainColor = mainColor;
      _shadeColor = shadeColor;
      _isMainSelection = true;
    });
  }

  ColorSwatch _findMainColor(Color shadeColor) {
    for (final mainColor in _colors)
      if (_isShadeOfMain(mainColor, shadeColor)) return mainColor;

    return null;
  }

  bool _isShadeOfMain(ColorSwatch mainColor, Color shadeColor) {
    List<Color> shades = _getMaterialColorShades(mainColor);

    for (var shade in shades) if (shade == shadeColor) return true;

    return false;
  }

  void _onMainColorSelected(ColorSwatch color) {
    var isShadeOfMain = _isShadeOfMain(color, _shadeColor);
    final shadeColor = isShadeOfMain ? _shadeColor : (color[500] ?? color[400]);

    setState(() {
      _mainColor = color;
      _shadeColor = shadeColor;
      _isMainSelection = false;
    });
    widget.onColorChange(shadeColor);
  }

  void _onShadeColorSelected(Color color) {
    setState(() {
      _shadeColor = color;
    });
    widget.onColorChange(color);
  }

  void _onBack() {
    setState(() {
      _isMainSelection = true;
    });
  }

  List<Widget> _buildListMainColor(List<ColorSwatch> colors) {
    List<Widget> circles = [];
    for (final color in colors) {
      final isSelected = _mainColor == color;

      circles.add(CircleColor(
          color: color,
          circleSize: _kCircleColorSize,
          onColorChoose: () => _onMainColorSelected(color),
          isSelected: isSelected));
    }

    return circles;
  }

  List<Color> _getMaterialColorShades(ColorSwatch color) {
    List<Color> colors = [];
    if (color[50] != null) colors.add(color[50]);
    if (color[100] != null) colors.add(color[100]);
    if (color[200] != null) colors.add(color[200]);
    if (color[300] != null) colors.add(color[300]);
    if (color[400] != null) colors.add(color[400]);
    if (color[500] != null) colors.add(color[500]);
    if (color[600] != null) colors.add(color[600]);
    if (color[700] != null) colors.add(color[700]);
    if (color[800] != null) colors.add(color[800]);
    if (color[900] != null) colors.add(color[900]);

    return colors;
  }

  List<Widget> _buildListShadesColor(ColorSwatch color) {
    List<Widget> circles = [];

    circles.add(IconButton(icon: Icon(Icons.arrow_back), onPressed: _onBack));

    final shades = _getMaterialColorShades(color);
    for (final color in shades) {
      final isSelected = _shadeColor == color;

      circles.add(CircleColor(
          color: color,
          circleSize: _kCircleColorSize,
          onColorChoose: () => _onShadeColorSelected(color),
          isSelected: isSelected));
    }
    return circles;
  }

  @override
  Widget build(BuildContext context) {
    final listChildren = _isMainSelection
        ? _buildListMainColor(_colors)
        : _buildListShadesColor(_mainColor);

    return Container(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
            runSpacing: _kPadding,
            spacing: _kPadding,
            children: listChildren,
            verticalDirection: VerticalDirection.down,
            alignment: widget.colorsAlignment));
  }
}
