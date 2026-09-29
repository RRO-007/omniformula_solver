import 'practice_question.dart';

class PracticeDatabase {
  static final List<PracticeQuestion> questions = [
    PracticeQuestion(
      question: 'A car accelerates from rest at 2 m/s² for 5 seconds. What is its final velocity?',
      options: ['5 m/s', '10 m/s', '15 m/s', '20 m/s'],
      correctIndex: 1,
      explanation: 'Using v = u + at, where u = 0, a = 2, t = 5. v = 0 + (2)(5) = 10 m/s.',
    ),
    PracticeQuestion(
      question: 'What is the kinetic energy of a 2 kg object moving at 4 m/s?',
      options: ['8 J', '16 J', '32 J', '64 J'],
      correctIndex: 1,
      explanation: 'KE = ½mv² = 0.5 × 2 × 4² = 0.5 × 2 × 16 = 16 J.',
    ),
    PracticeQuestion(
      question: 'If the mass of an object is 5 kg and its velocity is 3 m/s, what is its momentum?',
      options: ['8 kg·m/s', '15 kg·m/s', '2 kg·m/s', '0.6 kg·m/s'],
      correctIndex: 1,
      explanation: 'Momentum p = mv = 5 × 3 = 15 kg·m/s.',
    ),
    PracticeQuestion(
      question: 'What is the potential energy of a 3 kg book lifted 2 meters above the ground? (g = 9.8 m/s²)',
      options: ['6 J', '19.6 J', '29.4 J', '58.8 J'],
      correctIndex: 3,
      explanation: 'PE = mgh = 3 × 9.8 × 2 = 58.8 J.',
    ),
    PracticeQuestion(
      question:
          'A 10 N force is applied to a 2 kg object. What is the acceleration?',
      options: ['5 m/s²', '20 m/s²', '0.2 m/s²', '12 m/s²'],
      correctIndex: 0,
      explanation: 'Using F = ma, a = F/m = 10 / 2 = 5 m/s².',
    ),
    PracticeQuestion(
      question: 'What is the frequency of a wave with a wavelength of 2 m and a speed of 10 m/s?',
      options: ['0.2 Hz', '5 Hz', '20 Hz', '12 Hz'],
      correctIndex: 1,
      explanation: 'Frequency f = v/λ = 10 / 2 = 5 Hz.',
    ),
    PracticeQuestion(
      question: 'A 5 kg object is dropped from a height of 20 m. What is its velocity just before hitting the ground? (g = 10 m/s²)',
      options: ['10 m/s', '20 m/s', '40 m/s', '200 m/s'],
      correctIndex: 1,
      explanation: 'Using v² = u² + 2as, with u=0, a=10, s=20: v² = 0 + 2×10×20 = 400. v = √400 = 20 m/s.',
    ),
    PracticeQuestion(
      question: 'What is the power of a machine that does 500 J of work in 10 seconds?',
      options: ['50 W', '5000 W', '5 W', '100 W'],
      correctIndex: 0,
      explanation: 'Power P = W/t = 500 / 10 = 50 W.',
    ),
    PracticeQuestion(
      question: 'A resistor of 5 Ω has a current of 2 A flowing through it. What is the voltage across it?',
      options: ['2.5 V', '10 V', '7 V', '20 V'],
      correctIndex: 1,
      explanation: 'Ohm\'s Law: V = IR = 2 × 5 = 10 V.',
    ),
    PracticeQuestion(
      question: 'A ball is thrown horizontally from a cliff. Which of these remains constant during its flight (ignoring air resistance)?',
      options: ['Vertical velocity', 'Horizontal velocity', 'Both', 'Neither'],
      correctIndex: 1,
      explanation: 'In projectile motion, the horizontal velocity remains constant because there is no horizontal acceleration.',
    ),
  ];
}
