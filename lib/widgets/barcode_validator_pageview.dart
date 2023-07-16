import 'package:barcode_validator/barrel.dart';
import 'package:barcode_validator/widgets/barcode_list_validator.dart';
import 'package:barcode_validator/widgets/barcode_read_widget.dart';
import 'package:flutter/material.dart';

class BarcodeValidatorPageViewer extends StatefulWidget {
  const BarcodeValidatorPageViewer({Key? key, required this.appConfig, required this.barcodeConfigs, required PageController pageController, required this.lastScan})
      : _pageController = pageController,
        super(key: key);
  final BarcodeFormatModel lastScan;
  final ApplicationConfig appConfig;
  final BarcodeConfigRepository barcodeConfigs;
  final PageController _pageController;

  @override
  State<BarcodeValidatorPageViewer> createState() => _BarcodeValidatorPageViewerState();
}

class _BarcodeValidatorPageViewerState extends State<BarcodeValidatorPageViewer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BarcodeReadWidget(widget.lastScan),
        Flexible(
            child: Container(
          color: Theme.of(context).colorScheme.background,
          child: PageView.builder(
              onPageChanged: (index) => setState(() {
                    widget.appConfig.changeLastIndex(index);
                  }),
              scrollDirection: Axis.horizontal,
              itemCount: widget.barcodeConfigs.length,
              controller: widget._pageController,
              itemBuilder: (context, index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                  margin: EdgeInsets.all(widget.appConfig.lastSavedIndex == index ? 0 : 100),
                  color: Theme.of(context).primaryColor.withAlpha(index.isEven ? 100 : 200),
                  child: BarcodeListValidatorWidget(widget.barcodeConfigs.barcodeModels[index], widget.lastScan))),
        )),
        if (widget.barcodeConfigs.length > 1)
          Container(
            color: Theme.of(context).bottomAppBarColor,
            height: 50,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              InkWell(
                  child: Icon(Icons.skip_previous, color: widget.appConfig.lastSavedIndex == 0 ? Colors.white : Colors.white54, size: 20),
                  onTap: widget.appConfig.lastSavedIndex == 0 ? null : () => widget._pageController.jumpToPage(0)),
              ...List.generate(widget.barcodeConfigs.length, (index) => index).map((e) {
                bool isSelected = e == widget.appConfig.lastSavedIndex;
                final close = (widget.appConfig.lastSavedIndex - e).abs() * 2.0;
                final double size = isSelected
                    ? 18
                    : close > 4
                        ? 7
                        : 13 - close;
                return close > 14 || e == widget.barcodeConfigs.length - 1 || e == 0
                    ? Container()
                    : InkWell(
                        onTap: isSelected ? null : () => widget._pageController.animateToPage(e, duration: const Duration(milliseconds: 500), curve: Curves.decelerate),
                        child: Container(
                          margin: EdgeInsets.all(close > 3 ? 3 : (20 - close) * .6),
                          width: size,
                          height: size,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? Colors.white : Colors.white54),
                        ),
                      );
              }).toList(),
              InkWell(
                  child: Icon(Icons.skip_next, color: widget.appConfig.lastSavedIndex == widget.barcodeConfigs.length - 1 ? Colors.white : Colors.white54, size: 20),
                  onTap: widget.appConfig.lastSavedIndex == widget.barcodeConfigs.length - 1 ? null : () => widget._pageController.jumpToPage(widget.barcodeConfigs.length - 1))
            ]),
          ),
      ],
    );
  }
}
