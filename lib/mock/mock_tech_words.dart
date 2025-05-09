import '../models/tech_word.dart';

final List<TechWord> mockTechWords = [
  TechWord(
    id: 1,
    word: 'Algorithm',
    meaning: 'A set of rules or steps used to solve a problem or perform a task.',
    example: 'Example: Sorting numbers in ascending order.',
    category: 'Programming',
  ),
  TechWord(
    id: 2,
    word: 'API',
    meaning: 'A set of functions and protocols that allow different software applications to communicate with each other.',
    example: 'Example: Using a weather API to fetch weather data.',
    category: 'Web Development',
  ),
  TechWord(
    id: 3,
    word: 'Bug',
    meaning: 'An error or flaw in a computer program that causes it to produce incorrect or unexpected results.',
    example: 'Example: A calculation error in the code.',
    category: 'Programming',
  ),
  TechWord(
    id: 4,
    word: 'Cloud Computing',
    meaning: 'The delivery of computing services over the internet, allowing for on-demand access to resources.',
    example: 'Example: Using AWS to host a website.',
    category: 'Infrastructure',
  ),
];
