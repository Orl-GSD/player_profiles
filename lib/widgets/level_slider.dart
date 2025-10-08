import 'package:flutter/material.dart';
import 'package:player_profiles/model/player.dart';

// Add these mapping constants
const Map<Level, String> levelString = {
  Level.beginner: 'Beginner',
  Level.intermediate: 'Intermediate',
  Level.levelG: 'Level G',
  Level.levelF: 'Level F',
  Level.levelE: 'Level E',
  Level.levelD: 'Level D',
  Level.openPlayer: 'Open',
};

const Map<Strength, String> strengthString = {
  Strength.weak: 'Weak',
  Strength.mid: 'Mid',
  Strength.strong: 'Strong',
};

class LevelSlider extends StatefulWidget {
  final Level initialStartLevel;
  final Level initialEndLevel;
  final Strength? initialStartStrength;
  final Strength? initialEndStrength;
  final void Function(Level startLevel, Strength? startStrength, Level endLevel, Strength? endStrength)? onChanged;

  const LevelSlider({
    super.key,
    required this.initialStartLevel,
    required this.initialEndLevel,
    this.initialStartStrength,
    this.initialEndStrength,
    this.onChanged,
  });

  @override
  State<LevelSlider> createState() => _LevelSliderState();
}

class _LevelSliderState extends State<LevelSlider> {
  late RangeValues _currentRange;
  bool _isInitialized = false;

  static const List<LevelDefinition> _levelDefinitions = [
    LevelDefinition(Level.beginner, 'Beginner'),
    LevelDefinition(Level.intermediate, 'Intmdt'),
    LevelDefinition(Level.levelG, 'Level G'),
    LevelDefinition(Level.levelF, 'Level F'),
    LevelDefinition(Level.levelE, 'Level E'),
    LevelDefinition(Level.levelD, 'Level D'),
    LevelDefinition(Level.openPlayer, 'Open'),
  ];

  static const List<Strength> _strengths = [Strength.weak, Strength.mid, Strength.strong];
  
  int get _maxSliderValue => (_levelDefinitions.length - 1) * 3;

  @override
  void initState() {
    super.initState();
    _currentRange = RangeValues(
      _levelToSliderValue(widget.initialStartLevel, widget.initialStartStrength),
      _levelToSliderValue(widget.initialEndLevel, widget.initialEndStrength),
    );
    _isInitialized = true;
  }

  @override
  void didUpdateWidget(LevelSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update if the initial values changed and we're not currently building
    if (_isInitialized && 
        (oldWidget.initialStartLevel != widget.initialStartLevel ||
         oldWidget.initialEndLevel != widget.initialEndLevel ||
         oldWidget.initialStartStrength != widget.initialStartStrength ||
         oldWidget.initialEndStrength != widget.initialEndStrength)) {
      _updateRangeFromInitialValues();
    }
  }

  void _updateRangeFromInitialValues() {
    final newRange = RangeValues(
      _levelToSliderValue(widget.initialStartLevel, widget.initialStartStrength),
      _levelToSliderValue(widget.initialEndLevel, widget.initialEndStrength),
    );
    
    if (newRange != _currentRange) {
      setState(() {
        _currentRange = newRange;
      });
      // Notify parent after a frame to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notifyParent();
      });
    }
  }

  double _levelToSliderValue(Level level, Strength? strength) {
    final levelIndex = _levelDefinitions.indexWhere((def) => def.level == level);
    if (levelIndex == -1) return 0;

    if (level == Level.openPlayer) {
      return _maxSliderValue.toDouble();
    }

    final strengthIndex = strength != null ? _strengths.indexOf(strength) : 1;
    final effectiveStrengthIndex = strengthIndex.clamp(0, _strengths.length - 1);
    
    return (levelIndex * 3 + effectiveStrengthIndex).toDouble();
  }

  (Level, Strength?) _sliderValueToLevel(double value) {
    final intPosition = value.round().clamp(0, _maxSliderValue);
    
    if (intPosition >= (_levelDefinitions.length - 1) * 3) {
      return (_levelDefinitions.last.level, null);
    }

    final levelIndex = intPosition ~/ 3;
    final strengthIndex = intPosition % 3;
    
    final level = _levelDefinitions[levelIndex].level;
    final strength = _strengths[strengthIndex];
    
    return (level, strength);
  }

  String _getPositionLabel(double value) {
    final (level, strength) = _sliderValueToLevel(value);
    final levelDef = _levelDefinitions.firstWhere((def) => def.level == level);
    
    if (level == Level.openPlayer) {
      return levelDef.label;
    }
    
    final strengthLabel = strength != null 
        ? (strengthString[strength]?.substring(0, 1) ?? '') 
        : '';
    return '$strengthLabel ${levelDef.label}'.trim();
  }

  String _getPositionDescription(double value) {
    final (level, strength) = _sliderValueToLevel(value);
    
    if (level == Level.openPlayer) {
      return 'Open Player';
    }
    
    final strengthText = strength != null ? strengthString[strength] : '';
    final levelText = levelString[level] ?? '';
    return '$strengthText $levelText'.trim();
  }

  void _notifyParent() {
    if (!mounted) return;
    
    final (startLevel, startStrength) = _sliderValueToLevel(_currentRange.start);
    final (endLevel, endStrength) = _sliderValueToLevel(_currentRange.end);
    
    widget.onChanged?.call(startLevel, startStrength, endLevel, endStrength);
  }

  void _handleSliderChange(RangeValues values) {
    double start = values.start;
    double end = values.end;
    
    if ((end - start) < 1.0) {
      if ((values.start - _currentRange.start).abs() > (values.end - _currentRange.end).abs()) {
        start = end - 1.0;
      } else {
        end = start + 1.0;
      }
    }
    
    setState(() {
      _currentRange = RangeValues(start, end);
    });
    
    _notifyParent();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isInitialized = false; 
        _notifyParent();
      });
    }

    return Column(
      children: [
        _buildVisualScale(),
        const SizedBox(height: 12),
        _buildRangeSlider(),
        const SizedBox(height: 16),
        _buildCurrentSelection(),
      ],
    );
  }

  Widget _buildVisualScale() {
    return Column(
      children: [
        Row(
          children: _levelDefinitions.map((levelDef) {
            return Expanded(
              child: _buildLevelIndicator(levelDef),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLevelIndicator(LevelDefinition levelDef) {
    final isOpenLevel = levelDef.level == Level.openPlayer;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          levelDef.label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        if (isOpenLevel) ...[
          const SizedBox(height: 4),
          const Text('-', style: TextStyle(fontSize: 8, color: Colors.grey)),
        ] else ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: _strengths.map((strength) {
              return Text(
                strengthString[strength]?.substring(0, 1) ?? '',
                style: const TextStyle(fontSize: 8, color: Colors.grey),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildRangeSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.blueAccent,
        inactiveTrackColor: Colors.grey[300],
        thumbColor: Colors.blueAccent,
        overlayColor: Colors.blueAccent.withOpacity(0.2),
        trackHeight: 6,
        rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 12),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
      ),
      child: RangeSlider(
        values: _currentRange,
        min: 0,
        max: _maxSliderValue.toDouble(),
        divisions: _maxSliderValue,
        onChanged: _handleSliderChange,
      ),
    );
  }

  Widget _buildCurrentSelection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4,
        children: [
          _buildSelectionChip(_currentRange.start),
          Text(
            '-',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.blueAccent,
            ),
          ),
          _buildSelectionChip(_currentRange.end),
        ],
      ),
    );
  }

  Widget _buildSelectionChip(double value) {
    return Column(
      children: [
        const SizedBox(height: 2),
        Text(
          _getPositionDescription(value),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}

class LevelDefinition {
  final Level level;
  final String label;

  const LevelDefinition(this.level, this.label);
}