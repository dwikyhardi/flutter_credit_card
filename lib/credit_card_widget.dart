import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'credit_card_background.dart';
import 'credit_card_brand.dart';
import 'custom_card_type_icon.dart';
import 'glassmorphism_config.dart';

const Map<CardType, String> CardTypeIconAsset = <CardType, String>{
  CardType.visa: 'icons/visa.png',
  CardType.americanExpress: 'icons/amex.png',
  CardType.mastercard: 'icons/mastercard.png',
  CardType.discover: 'icons/discover.png',
  CardType.gpn: 'icons/gpn.png',
};

class CreditCardWidget extends StatefulWidget {
  const CreditCardWidget({
    Key? key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    this.height,
    this.width,
    this.textStyle,
    this.cardBgColor = const Color(0x552563eb),
    this.obscureCardNumber = true,
    this.obscureCardCvv = true,
    this.labelCardHolder = 'CARD HOLDER',
    this.labelExpiredDate = 'MM/YY',
    this.cardType,
    this.isHolderNameVisible = false,
    this.backgroundImage,
    this.glassmorphismConfig,
    this.customCardTypeIcons = const <CustomCardTypeIcon>[],
    required this.onCreditCardWidgetChange,
    this.showButtonEnabled = false,
    this.showButtonCallback,
  }) : super(key: key);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final TextStyle? textStyle;
  final Color cardBgColor;
  final double? height;
  final double? width;
  final bool obscureCardNumber;
  final bool obscureCardCvv;
  final void Function(CreditCardBrand) onCreditCardWidgetChange;
  final bool isHolderNameVisible;
  final String? backgroundImage;
  final Glassmorphism? glassmorphismConfig;

  final bool showButtonEnabled;
  final Future<void> Function()? showButtonCallback;

  final String labelCardHolder;
  final String labelExpiredDate;

  final CardType? cardType;
  final List<CustomCardTypeIcon> customCardTypeIcons;

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget>
    with SingleTickerProviderStateMixin {
  late Gradient backgroundGradientColor;
  late bool isShowCVV = !widget.obscureCardCvv;
  late String number = widget.obscureCardNumber
      ? widget.cardNumber.replaceAll(RegExp(r'(?<=.{0})\d(?=.{4})'), '*')
      : widget.cardNumber;

  late String cvv = widget.obscureCardCvv
      ? widget.cvvCode.replaceAll(RegExp(r'\d'), '*')
      : widget.cvvCode;

  bool isShowButtonLoading = false;

  bool isAmex = false;

  @override
  void initState() {
    super.initState();

    _gradientSetup();
  }

  void _gradientSetup() {
    backgroundGradientColor = LinearGradient(
      // Where the linear gradient begins and ends
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      // Add one stop for each color. Stops should increase from 0 to 1
      stops: const <double>[0.1, 0.4, 0.7, 0.9],
      colors: <Color>[
        widget.cardBgColor.withOpacity(1),
        widget.cardBgColor.withOpacity(0.97),
        widget.cardBgColor.withOpacity(0.90),
        widget.cardBgColor.withOpacity(0.86),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///
    /// If uer adds CVV then toggle the card from front to back..
    /// controller forward starts animation and shows back layout.
    /// controller reverse starts animation and shows front layout.
    ///

    final CardType? cardType = widget.cardType != null
        ? widget.cardType
        : detectCCType(widget.cardNumber);
    widget.onCreditCardWidgetChange(CreditCardBrand(cardType));

    return _buildFrontContainer();
  }

  ///
  /// Builds a front container containing
  /// Card number, Exp. year and Card holder name
  ///
  Widget _buildFrontContainer() {
    final TextStyle defaultTextStyle =
        Theme.of(context).textTheme.headline6!.merge(
              const TextStyle(
                color: Colors.white,
                fontFamily: 'halter',
                fontSize: 14,
                package: 'flutter_credit_card',
              ),
            );

    return CardBackground(
      backgroundImage: widget.backgroundImage,
      backgroundGradientColor: backgroundGradientColor,
      glassmorphismConfig: widget.glassmorphismConfig,
      height: widget.height,
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                child: widget.cardType != null
                    ? getCardTypeImage(widget.cardType)
                    : getCardTypeIcon(widget.cardNumber),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Text(
                      widget.cardNumber.isEmpty
                          ? 'XXXX XXXX XXXX XXXX'
                          : number,
                      style: widget.textStyle ?? defaultTextStyle,
                    ),
                  ),
                  widget.showButtonEnabled
                      ? Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.width * 0.05,
                              ),
                              primary: const Color(0xFF9CA3AF),
                            ),
                            onPressed: () async {
                              setState(() {
                                isShowButtonLoading = true;
                              });
                              if (widget.showButtonCallback != null &&
                                  !isShowCVV) {
                                await widget.showButtonCallback!().then((_) {
                                  _showCVV();
                                });
                              } else {
                                _showCVV();
                              }
                              setState(() {
                                isShowButtonLoading = false;
                              });
                            },
                            child: isShowButtonLoading
                                ? const CupertinoActivityIndicator()
                                : Text(
                                    isShowCVV ? 'HIDE' : 'SHOW',
                                    style: widget.textStyle ?? defaultTextStyle,
                                  ),
                          ))
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                widget.cvvCode.isEmpty
                    ? isAmex
                        ? 'XXXX'
                        : 'XXX'
                    : cvv,
                maxLines: 1,
                style: widget.textStyle ?? defaultTextStyle,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Row(
                children: <Widget>[
                  Visibility(
                    visible: widget.isHolderNameVisible,
                    child: Expanded(
                      flex: 8,
                      child: Text(
                        widget.cardHolderName.isEmpty
                            ? widget.labelCardHolder
                            : widget.cardHolderName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: widget.textStyle ?? defaultTextStyle,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      widget.expiryDate.isEmpty
                          ? widget.labelExpiredDate
                          : widget.expiryDate,
                      style: widget.textStyle ?? defaultTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCVV() {
    isShowCVV = !isShowCVV;
    if (isShowCVV) {
      number = splitCardNumber(widget.cardNumber);
      cvv = widget.cvvCode;
    } else {
      cvv = widget.cvvCode.replaceAll(RegExp(r'\d'), '*');
      number =
          widget.cardNumber.replaceAll(RegExp(r'(?<=.{0})\d(?=.{4})'), '*');
    }
  }

  String splitCardNumber(String? cardNumber) {
    List<String> splittedCardNumbers = <String>[];
    String splittedCardNumber = '';
    if (cardNumber != null) {
      splittedCardNumbers = chunk(cardNumber);
    }

    for (String element in splittedCardNumbers) {
      splittedCardNumber = splittedCardNumber + ' ' + element;
    }

    return splittedCardNumber.trim();
  }

  List<String> chunk(String string) {
    final int chunkCount = (string.length / 4).ceil();

    final List<String> chunks = List<String>.generate(chunkCount, (int index) {
      final int sliceStart = index * 4;
      final int sliceEnd = sliceStart + 4;
      return string.substring(
        sliceStart,
        (sliceEnd < string.length) ? sliceEnd : string.length,
      );
    });

    return chunks;
  }

  /// Credit Card prefix patterns as of March 2019
  /// A [List<String>] represents a range.
  /// i.e. ['51', '55'] represents the range of cards starting with '51' to those starting with '55'
  Map<CardType, Set<List<String>>> cardNumPatterns =
      <CardType, Set<List<String>>>{
    CardType.visa: <List<String>>{
      <String>['4'],
    },
    CardType.americanExpress: <List<String>>{
      <String>['34'],
      <String>['37'],
    },
    CardType.discover: <List<String>>{
      <String>['6011'],
      <String>['622126', '622925'],
      <String>['644', '649'],
      <String>['65']
    },
    CardType.mastercard: <List<String>>{
      <String>['51', '55'],
      <String>['2221', '2229'],
      <String>['223', '229'],
      <String>['23', '26'],
      <String>['270', '271'],
      <String>['2720'],
    },
    CardType.gpn: <List<String>>{
      <String>['1'],
      <String>['2'],
      <String>['6'],
      <String>['7'],
      <String>['8'],
      <String>['9'],
    },
  };

  /// This function determines the Credit Card type based on the cardPatterns
  /// and returns it.
  CardType detectCCType(String cardNumber) {
    //Default card type is other
    CardType cardType = CardType.otherBrand;

    if (cardNumber.isEmpty) {
      return cardType;
    }

    cardNumPatterns.forEach(
      (CardType type, Set<List<String>> patterns) {
        for (List<String> patternRange in patterns) {
          // Remove any spaces
          String ccPatternStr =
              cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
          final int rangeLen = patternRange[0].length;
          // Trim the Credit Card number string to match the pattern prefix length
          if (rangeLen < cardNumber.length) {
            ccPatternStr = ccPatternStr.substring(0, rangeLen);
          }

          if (patternRange.length > 1) {
            // Convert the prefix range into numbers then make sure the
            // Credit Card num is in the pattern range.
            // Because Strings don't have '>=' type operators
            final int ccPrefixAsInt = int.parse(ccPatternStr);
            final int startPatternPrefixAsInt = int.parse(patternRange[0]);
            final int endPatternPrefixAsInt = int.parse(patternRange[1]);
            if (ccPrefixAsInt >= startPatternPrefixAsInt &&
                ccPrefixAsInt <= endPatternPrefixAsInt) {
              // Found a match
              cardType = type;
              break;
            }
          } else {
            // Just compare the single pattern prefix with the Credit Card prefix
            if (ccPatternStr == patternRange[0]) {
              // Found a match
              cardType = type;
              break;
            }
          }
        }
      },
    );

    return cardType;
  }

  Widget getCardTypeImage(CardType? cardType) {
    if (cardType != null) {
      final List<CustomCardTypeIcon> customCardTypeIcon =
          getCustomCardTypeIcon(cardType);
      if (customCardTypeIcon.isNotEmpty) {
        return customCardTypeIcon.first.cardImage;
      } else {
        return Image.asset(
          CardTypeIconAsset[cardType]!,
          height: 48,
          width: 48,
          package: 'flutter_credit_card',
        );
      }
    } else {
      return const SizedBox();
    }
  }

  // This method returns the icon for the visa card type if found
  // else will return the empty container
  Widget getCardTypeIcon(String cardNumber) {
    Widget icon;
    final CardType ccType = detectCCType(cardNumber);
    final List<CustomCardTypeIcon> customCardTypeIcon =
        getCustomCardTypeIcon(ccType);
    if (customCardTypeIcon.isNotEmpty) {
      icon = customCardTypeIcon.first.cardImage;
      isAmex = ccType == CardType.americanExpress;
    } else {
      switch (ccType) {
        case CardType.visa:
          icon = Image.asset(
            CardTypeIconAsset[ccType]!,
            height: 48,
            width: 48,
            package: 'flutter_credit_card',
          );
          isAmex = false;
          break;

        case CardType.americanExpress:
          icon = Image.asset(
            CardTypeIconAsset[ccType]!,
            height: 48,
            width: 48,
            package: 'flutter_credit_card',
          );
          isAmex = true;
          break;

        case CardType.mastercard:
          icon = Image.asset(
            CardTypeIconAsset[ccType]!,
            height: 48,
            width: 48,
            package: 'flutter_credit_card',
          );
          isAmex = false;
          break;

        case CardType.discover:
          icon = Image.asset(
            CardTypeIconAsset[ccType]!,
            height: 48,
            width: 48,
            package: 'flutter_credit_card',
          );
          isAmex = false;
          break;

        case CardType.gpn:
          icon = Image.asset(
            CardTypeIconAsset[ccType]!,
            height: 48,
            width: 48,
            package: 'flutter_credit_card',
          );
          isAmex = false;
          break;

        default:
          icon = Container(
            height: 48,
            width: 48,
          );
          isAmex = false;
          break;
      }
    }

    return icon;
  }

  List<CustomCardTypeIcon> getCustomCardTypeIcon(CardType currentCardType) =>
      widget.customCardTypeIcons
          .where((CustomCardTypeIcon element) =>
              element.cardType == currentCardType)
          .toList();
}

class MaskedTextController extends TextEditingController {
  MaskedTextController(
      {String? text, required this.mask, Map<String, RegExp>? translator})
      : super(text: text) {
    this.translator = translator ?? MaskedTextController.getDefaultTranslator();

    addListener(() {
      final String previous = _lastUpdatedText;
      if (beforeChange(previous, this.text)) {
        updateText(this.text);
        afterChange(previous, this.text);
      } else {
        updateText(_lastUpdatedText);
      }
    });

    updateText(this.text);
  }

  String mask;

  late Map<String, RegExp> translator;

  Function afterChange = (String previous, String next) {};
  Function beforeChange = (String previous, String next) {
    return true;
  };

  String _lastUpdatedText = '';

  void updateText(String text) {
    if (text.isNotEmpty) {
      this.text = _applyMask(mask, text);
    } else {
      this.text = '';
    }

    _lastUpdatedText = this.text;
  }

  void updateMask(String mask, {bool moveCursorToEnd = true}) {
    this.mask = mask;
    updateText(text);

    if (moveCursorToEnd) {
      this.moveCursorToEnd();
    }
  }

  void moveCursorToEnd() {
    final String text = _lastUpdatedText;
    selection = TextSelection.fromPosition(TextPosition(offset: text.length));
  }

  @override
  set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
      moveCursorToEnd();
    }
  }

  static Map<String, RegExp> getDefaultTranslator() {
    return <String, RegExp>{
      'A': RegExp(r'[A-Za-z]'),
      '0': RegExp(r'[0-9]'),
      '@': RegExp(r'[A-Za-z0-9]'),
      '*': RegExp(r'.*')
    };
  }

  String _applyMask(String? mask, String value) {
    String result = '';

    int maskCharIndex = 0;
    int valueCharIndex = 0;

    while (true) {
      // if mask is ended, break.
      if (maskCharIndex == mask!.length) {
        break;
      }

      // if value is ended, break.
      if (valueCharIndex == value.length) {
        break;
      }

      final String maskChar = mask[maskCharIndex];
      final String valueChar = value[valueCharIndex];

      // value equals mask, just set
      if (maskChar == valueChar) {
        result += maskChar;
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match
      if (translator.containsKey(maskChar)) {
        if (translator[maskChar]!.hasMatch(valueChar)) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      // not masked value, fixed char on mask
      result += maskChar;
      maskCharIndex += 1;
      continue;
    }

    return result;
  }
}

enum CardType {
  otherBrand,
  mastercard,
  visa,
  americanExpress,
  discover,
  gpn,
}
