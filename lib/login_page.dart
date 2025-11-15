import 'package:flutter/material.dart';
import 'home_page.dart';
import 'dart:math'; // For sin function and random numbers

// Helper class for a single falling cash particle
class CashParticle {
  late Offset position;
  late double size;
  late Color color;
  late double opacity;
  late double speed; // Vertical fall speed
  late double rotation; // For rotation effect
  late double rotationSpeed; // How fast it rotates

  CashParticle(Random random, Size areaSize) {
    position = Offset(
      random.nextDouble() * areaSize.width, // Random X within the title area
      -random.nextDouble() * 50, // Start just above the title
    );
    size = random.nextDouble() * 15 + 10; // Size between 10 and 25
    color =
        Color.lerp(
          Colors.greenAccent[400],
          Colors.green[700],
          random.nextDouble(),
        )!; // Green shades for money
    opacity = random.nextDouble() * 0.5 + 0.5; // Opacity between 0.5 and 1.0
    speed = random.nextDouble() * 2 + 1; // Speed between 1 and 3
    rotation = random.nextDouble() * pi * 2; // Initial random rotation
    rotationSpeed =
        random.nextDouble() * 0.1 - 0.05; // Rotate left or right slowly
  }

  void update(double deltaTime, Size areaSize) {
    position = Offset(
      position.dx,
      position.dy + speed * deltaTime * 60,
    ); // Adjust fall speed
    rotation += rotationSpeed * deltaTime * 60; // Adjust rotation speed
    // Fade out as it approaches the bottom of the title area
    if (position.dy > areaSize.height * 0.7) {
      opacity = (areaSize.height - position.dy) / (areaSize.height * 0.3);
      if (opacity < 0) opacity = 0;
    }
  }

  bool isOffscreen(Size areaSize) {
    return position.dy > areaSize.height + size; // Off screen at the bottom
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // --- Animation Variables for Cash Wave (existing) ---
  late AnimationController _waveController;

  // --- Animation Variables for Cash Rain ---
  late AnimationController _cashRainController;
  final List<CashParticle> _cashParticles = [];
  final Random _random = Random();
  GlobalKey _titleAreaKey = GlobalKey(); // Key to get the title area size

  // --- Theme Colors ---
  final Color primaryDark = Color(0xFF121212); // Deep Black/Dark Grey
  final Color accentRed = Color(0xFFE53935); // Sharp Red
  final Color accentYellow = Color(0xFFFDD835); // Bright Yellow
  final String appTitle = 'SpareWise';

  // List of characters for the wave animation
  late List<String> titleChars;

  @override
  void initState() {
    super.initState();

    titleChars = appTitle.split('');

    _waveController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )..repeat();

    // --- Initialize Cash Rain Controller ---
    _cashRainController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4), // Cash rain lasts for 4 seconds
    );

    _cashRainController.addListener(() {
      if (_cashRainController.isAnimating) {
        // Generate new particles continuously while animating
        _generateCashParticles();
        // Update existing particles
        _updateCashParticles();
      }
      setState(() {}); // Rebuild to show particles
    });

    _cashRainController.forward(); // Start the cash rain animation
  }

  void _generateCashParticles() {
    RenderBox? renderBox =
        _titleAreaKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    Size titleAreaSize = renderBox.size;

    // Generate a few particles per frame to create a dense rain effect
    for (int i = 0; i < 2; i++) {
      // Generate 2 particles per frame update
      _cashParticles.add(CashParticle(_random, titleAreaSize));
    }
  }

  void _updateCashParticles() {
    RenderBox? renderBox =
        _titleAreaKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    Size titleAreaSize = renderBox.size;

    List<CashParticle> toRemove = [];
    for (var particle in _cashParticles) {
      particle.update(
        0.016,
        titleAreaSize,
      ); // Assuming 60fps, 1/60 = 0.016s per frame
      if (particle.isOffscreen(titleAreaSize) || particle.opacity <= 0) {
        toRemove.add(particle);
      }
    }
    for (var particle in toRemove) {
      _cashParticles.remove(particle);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _waveController.dispose();
    _cashRainController.dispose(); // Dispose the cash rain controller
    super.dispose();
  }

  void _attemptLogin() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(
                'Authentication Required',
                style: TextStyle(color: accentRed),
              ),
              content: Text(
                'Please enter both username and password to proceed.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK', style: TextStyle(color: accentRed)),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
      );
    }
  }

  // Custom TextField builder for cleaner dark theme code
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required bool isObscure,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: accentYellow),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white10, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentRed, width: 2.0),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }

  // Animated Cash Wave Title (existing)
  Widget _buildAnimatedCashWaveTitle() {
    const double waveAmplitude = 1.6;
    const double waveFrequency = 0.5;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(titleChars.length, (index) {
        double offset = index * waveFrequency;

        return AnimatedBuilder(
          animation: _waveController,
          builder: (context, child) {
            double sineValue = sin((_waveController.value * 2 * pi) + offset);
            double translateY = sineValue * waveAmplitude;

            return Transform.translate(
              offset: Offset(0, translateY),
              child: Text(
                titleChars[index],
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: accentRed,
                  letterSpacing: 2.0,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: accentYellow.withOpacity(0.5),
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 80),

                // --- Stack for Cash Wave Title + Cash Rain Effect ---
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Base: Cash Wave Title
                    Container(
                      key: _titleAreaKey, // Attach key to measure this area
                      width:
                          double
                              .infinity, // Ensure it takes full width for particle generation
                      height: 80, // Approximate height of the title text
                      child: _buildAnimatedCashWaveTitle(),
                    ),

                    // Overlay: Cash Rain Particles (only visible while cashRainController is animating)
                    ..._cashParticles.map((particle) {
                      return Positioned(
                        left: particle.position.dx,
                        top: particle.position.dy,
                        child: Opacity(
                          opacity: particle.opacity,
                          child: Transform.rotate(
                            angle: particle.rotation,
                            child: Icon(
                              _random.nextBool()
                                  ? Icons.attach_money
                                  : Icons.euro_symbol, // Random dollar or euro
                              size: particle.size,
                              color: particle.color,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),

                SizedBox(height: 10),

                Text(
                  'Your Financial Control Center',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),

                SizedBox(height: 60),

                _buildTextField(
                  controller: _usernameController,
                  labelText: 'Username',
                  icon: Icons.person_outline,
                  isObscure: false,
                ),

                SizedBox(height: 20),

                _buildTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  icon: Icons.lock_outline,
                  isObscure: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white54,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),

                SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: accentYellow,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _attemptLogin,
                    child: Text(
                      'LOG IN',
                      style: TextStyle(
                        color: primaryDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentRed,
                      elevation: 8,
                      shadowColor: accentRed.withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),

                SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Need a budget?',
                      style: TextStyle(color: Colors.white60, fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {
                        print('Register pressed');
                      },
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          color: accentYellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
