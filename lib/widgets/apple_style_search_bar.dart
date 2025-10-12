import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/theme/app_theme.dart';

class AppleStyleSearchBar extends StatefulWidget {
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;

  const AppleStyleSearchBar({
    Key? key,
    this.placeholder = 'Buscar',
    this.onChanged,
    this.onTap,
    this.controller,
  }) : super(key: key);

  @override
  State<AppleStyleSearchBar> createState() => _AppleStyleSearchBarState();
}

class _AppleStyleSearchBarState extends State<AppleStyleSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing20,
        vertical: AppTheme.spacing12,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isDark 
            ? (_isFocused ? AppTheme.darkSurface2 : AppTheme.darkSurface)
            : (_isFocused ? Colors.white : AppTheme.gray5),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
        ),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.gray1,
            ),
            prefixIcon: Icon(
              CupertinoIcons.search,
              color: AppTheme.gray1,
              size: 20,
            ),
            suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: AppTheme.gray2,
                    size: 18,
                  ),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged?.call('');
                  },
                )
              : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
              vertical: AppTheme.spacing12,
            ),
          ),
        ),
      ),
    );
  }
}