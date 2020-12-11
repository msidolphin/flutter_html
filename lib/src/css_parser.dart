import 'dart:ui';

import 'package:csslib/visitor.dart' as css;
import 'package:csslib/parser.dart' as cssparser;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';

Style declarationsToStyle(Map<String, List<css.Expression>> declarations) {
  Style style = new Style();
  declarations.forEach((property, value) {
    switch (property) {
      case 'background-color':
        style.backgroundColor =
            ExpressionMapping.expressionToColor(value.first);
        break;
      case 'color':
        style.color = ExpressionMapping.expressionToColor(value.first);
        break;
      case 'text-align':
        style.textAlign = ExpressionMapping.expressionToTextAlign(value.first);
        break;
      case 'font-weight':
        if (value.first is css.NumberTerm) {
          css.NumberTerm size = value.first;
          style.fontWeight = FontWeight.values[(size.value / 100).toInt()];
        }
        /// TODO
        break;
      case 'font-size':
        String fontSize = value.first.toString().replaceAll("px", "")
          .replaceAll("em", "")
          .replaceAll("rem", "")
          .replaceAll("%", "")
          .replaceAll("vw", "")
          .replaceAll("vh", "");
        style.fontSize = FontSize(double.parse(fontSize));
        break;
      case 'width':
        String width = value.first.toString().replaceAll("px", "")
            .replaceAll("em", "")
            .replaceAll("rem", "")
            .replaceAll("%", "")
            .replaceAll("vw", "")
            .replaceAll("vh", "");
        style.width = double.parse(width);
        break;
      case 'margin':
        style.margin = getPaddingOrMargin(value);
        print(style.margin);
        break;
      case 'padding':
        style.padding = getPaddingOrMargin(value);
        break;
    }
  });
  return style;
}

EdgeInsetsGeometry getPaddingOrMargin(List<css.Expression> style) {
  double top = 0;
  double bottom = 0;
  double left = 0;
  double right = 0;
  if (style.length == 1) {
    top = bottom = left = right = double.parse(erasureCssUnit(style.first.toString()));
  } else if (style.length == 2) {
    top = bottom = double.parse(erasureCssUnit(style[0].toString()));
    left = right = double.parse(erasureCssUnit(style[1].toString()));
  } else if (style.length == 3) {
    top = double.parse(erasureCssUnit(style[0].toString()));
    left = right = double.parse(erasureCssUnit(style[1].toString()));
    bottom = double.parse(erasureCssUnit(style[2].toString()));
  } else {
    top = double.parse(erasureCssUnit(style[0].toString()));
    right = double.parse(erasureCssUnit(style[1].toString()));
    bottom = double.parse(erasureCssUnit(style[2].toString()));
    left = double.parse(erasureCssUnit(style[1].toString()));
  }
  return EdgeInsets.only(
    left: left,
    top: top,
    right: right,
    bottom: bottom
  );
}

String erasureCssUnit(String style) {
  return style.toString().replaceAll("px", "")
      .replaceAll("em", "")
      .replaceAll("rem", "")
      .replaceAll("%", "")
      .replaceAll("vw", "")
      .replaceAll("vh", "");
}

Style inlineCSSToStyle(String inlineStyle) {
  final sheet = cssparser.parse("*{$inlineStyle}");
  final declarations = DeclarationVisitor().getDeclarations(sheet);
  return declarationsToStyle(declarations);
}

class DeclarationVisitor extends css.Visitor {
  Map<String, List<css.Expression>> _result;
  String _currentProperty;

  Map<String, List<css.Expression>> getDeclarations(css.StyleSheet sheet) {
    _result = new Map<String, List<css.Expression>>();
    sheet.visit(this);
    return _result;
  }

  @override
  void visitDeclaration(css.Declaration node) {
    _currentProperty = node.property;
    _result[_currentProperty] = new List<css.Expression>();
    node.expression.visit(this);
  }

  @override
  void visitExpressions(css.Expressions node) {
    node.expressions.forEach((expression) {
      _result[_currentProperty].add(expression);
    });
  }
}

//Mapping functions
class ExpressionMapping {
  static Color expressionToColor(css.Expression value) {
    if (value is css.HexColorTerm) {
      return stringToColor(value.text);
    } else if (value is css.FunctionTerm) {
      if (value.text == 'rgba') {
        return rgbOrRgbaToColor(value.span.text);
      } else if (value.text == 'rgb') {
        return rgbOrRgbaToColor(value.span.text);
      }
    }
    return null;
  }

  static Color stringToColor(String _text) {
    var text = _text.replaceFirst('#', '');
    if (text.length == 3)
      text = text.replaceAllMapped(
          RegExp(r"[a-f]|\d"), (match) => '${match.group(0)}${match.group(0)}');
    int color = int.parse(text, radix: 16);

    if (color <= 0xffffff) {
      return new Color(color).withAlpha(255);
    } else {
      return new Color(color);
    }
  }

  static Color rgbOrRgbaToColor(String text) {
    final rgbaText = text.replaceAll(')', '').replaceAll(' ', '');
    try {
      final rgbaValues =
          rgbaText.split(',').map((value) => double.parse(value)).toList();
      if (rgbaValues.length == 4) {
        return Color.fromRGBO(
          rgbaValues[0].toInt(),
          rgbaValues[1].toInt(),
          rgbaValues[2].toInt(),
          rgbaValues[3],
        );
      } else if (rgbaValues.length == 3) {
        return Color.fromRGBO(
          rgbaValues[0].toInt(),
          rgbaValues[1].toInt(),
          rgbaValues[2].toInt(),
          1.0,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static TextAlign expressionToTextAlign(css.Expression value) {
    if (value is css.LiteralTerm) {
      switch(value.text) {
        case "center":
          return TextAlign.center;
        case "left":
          return TextAlign.left;
        case "right":
          return TextAlign.right;
        case "justify":
          return TextAlign.justify;
        case "end":
          return TextAlign.end;
        case "start":
          return TextAlign.start;
      }
    }
    return TextAlign.start;
  }
}
