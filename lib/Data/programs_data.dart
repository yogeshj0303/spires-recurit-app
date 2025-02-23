import '../Models/program_model.dart';
import 'package:flutter/painting.dart';

class ProgramsData {
  static const List<Program> programs = [
    Program(
      imageUrl: 'assets/icons/1.png',
      title: 'SkillUp 1.0',
      description: 'Description:SkillUp 1.0 is your comprehensive training program designed to equip you with the essential skills and knowledge needed to land your dream internship or entry-level job. Through interactive modules, practical exercises, and industry expert insights, you\'ll gain the confidence and competence to impress employers.',
      benefits: "• Gain valuable skills through interactive modules & practical exercises.\n• Build confidence with mock interviews, interview tips, & resume workshops.\n• Connect with industry professionals & gain insights into your dream career.\n• Get access to exclusive internship listings with top companies.\n• Receive personalized guidance & support from our career coaches.",
      faqs: [
        {
          'question': 'Is SkillUp 1.0 free?',
          'answer': 'Yes, SkillUp 1.0 is completely free to access for all Spires Recruit users.'
        },
        {
          'question': 'What skills can I learn through SkillUp 1.0?',
          'answer': 'SkillUp 1.0 offers a variety of modules covering in-demand skills such as communication, problem-solving, teamwork, digital marketing, social media marketing, data analysis, and more.'
        },
        {
          'question': 'How do I get access to exclusive internship listings?',
          'answer': 'By completing relevant SkillUp 1.0 modules and demonstrating your skills, you\'ll gain access to a curated list of internship opportunities from top companies.'
        },
        {
          'question': 'Will I receive a certificate upon completion?',
          'answer': 'Yes, upon successful completion of a SkillUp 1.0 learning path, you\'ll receive a digital certificate to showcase your acquired skills to potential employers.'
        },
      ],
      howItWorks: '1. Download the Spires Recruit app / website & create a free account.\n2. Select a learning path based on your career interests & desired skills.\n3. Work through interactive modules at your own pace, anytime, anywhere.\n4. Sharpen your skills with mock interviews & resume feedback.\n5. Network with companies and apply for exclusive internship opportunities.',
    ),
    Program(
      imageUrl: 'assets/icons/3.png',
      title: 'Resume Workshop',
      description: 'Master the art of resume writing with our interactive Resume Workshop! Get expert guidance on building a compelling resume that stands out to hiring managers and lands you interviews.',
      benefits: '• Learn proven resume writing strategies.\n• Optimize your resume for Applicant Tracking Systems (ATS).\n• Tailor your resume for specific job applications.\n• Gain confidence in your resume writing skills.\n• Get feedback from career experts.\n• Network with other job seekers.',
      faqs: [
        {
          'question': 'Is the Resume Workshop free?',
          'answer': 'Yes, the Spires Recruit Resume Workshop is completely free to attend!'
        },
        {
          'question': 'Who should attend the Resume Workshop?',
          'answer': 'This workshop is beneficial for anyone seeking to improve their resume writing skills, from recent graduates to experienced professionals looking to make a career change.'
        },
        {
          'question': 'What will I learn in the workshop?',
          'answer': 'The workshop will cover a variety of topics, including resume structure, formatting, keyword optimization, crafting impactful achievements statements, and tailoring your resume for specific job applications.'
        },
        {
          'question': 'How do I register for the workshop?',
          'answer': 'Download the Spires Recruit app or visit our website to find upcoming workshop dates and register.'
        },
      ],
      howItWorks: '• Sign up for the free workshop through the Spires Recruit app / website.\n• Join our live, interactive workshop led by career development professionals.\n• Engage in interactive exercises and discussions to learn resume best practices.\n• Have the opportunity to receive personalized feedback on your resume during the workshop or through follow-up resources.',
    ),
    Program(
      imageUrl: 'assets/icons/2.png',
      title: 'Interview Preparation',
      description: 'Nail your next interview with Spires Recruit\'s comprehensive Interview Preparation section! This interactive tool equips you with the knowledge and confidence to shine in any interview setting.',
      benefits: '• Boost confidence and reduce interview anxiety.\n• Learn effective strategies for answering common interview questions.\n• Practice your responses with interactive mock interview tools.\n• Receive personalized feedback to identify areas for improvement.\n• Gain insights into different interview formats and company cultures',
      faqs: [
        {
          'question': 'What types of interview formats are covered?',
          'answer': 'Spires Recruit covers various interview formats, including phone interviews, video interviews, and traditional in-person interviews.'
        },
        {
          'question': 'How does the mock interview simulator work?',
          'answer': 'The simulator provides a virtual interviewer and presents you with common interview questions. You can record your response and receive automated feedback on your body language, verbal delivery, and answer content.'
        },
        {
          'question': 'Are there interview tips for different industries?',
          'answer': 'Yes, we offer tailored interview prep resources for various industries, helping you understand industry-specific questions and expectations.'
        },
        {
          'question': 'How can I access the Interview Preparation section?',
          'answer': 'The Interview Preparation section is available within the Spires Recruit app. Download the app for free and explore all our resources designed to help you land your dream job!'
        },
      ],
      howItWorks: '• Access a vast library of interview questions categorized by industry, job title & difficulty level.\n• Utilize our AI-powered mock interview simulator to practice your responses in a realistic setting.\n• Review detailed feedback reports on your mock interviews, highlighting strengths & areas for development.\n• Watch informative video tutorials & read articles from industry professionals on interview best practices.',
    ),
    Program(
      imageUrl: 'assets/icons/jsdh.png',
      title: 'Coding Clubs',
      description: 'The Spires Recruit Coding Club is a community for developers who are passionate about building and improving the Spires Recruit platform. We welcome coders of all experience levels, from beginners to seasoned professionals.',
      benefits: '• Work on real-world projects that utilize various coding skills and technologies.\n• Approach challenges creatively and find innovative solutions.\n• Get guidance and feedback from industry professionals.\n• Showcase your coding projects to potential employers.\n• Connect with other programmers who share your passion for coding.',
      faqs: [
        {
          'question': 'Is there a cost to join the Spires Recruit Coding Club?',
          'answer': 'No, the Spires Recruit Coding Club is completely free to join and participate in.'
        },
        {
          'question': 'What coding experience level is required?',
          'answer': 'The Spires Recruit Coding Club welcomes coders of all skill levels, from beginners to experienced programmers.'
        },
        {
          'question': 'What programming languages are covered in the club?',
          'answer': 'The Spires Recruit Coding Club covers a variety of popular programming languages, with the specific languages addressed depending on member interests and industry trends.'
        },
        {
          'question': 'How do I find out about upcoming workshops and events?',
          'answer': 'Announcements for upcoming workshops, challenges, and events will be posted within the Spires Recruit Coding Club forum and communicated through the Spires Recruit app.'
        },
      ],
      howItWorks: '• Sign up for the Spires Recruit Coding Club through the Spires Recruit app / website.\n• Participate in weekly coding challenges designed to test and enhance your skills.\n• Attend regular online workshops and Q&A sessions hosted by industry experts.\n• Join discussions, share solutions, and get help from fellow club members.\n• Connect with other coders through the forum and participate in virtual coding meetups.',
      fit: BoxFit.fill,
    ),
    Program(
      imageUrl: 'assets/icons/computer.png',
      title: 'Basic Computer',
      description: 'Master essential computer skills with our comprehensive Basic Computer course. Learn fundamental operations, software applications, and digital literacy skills needed in today\'s workplace.',
      benefits: '• Learn basic computer operations and terminology.\n• Master common office software applications.\n• Understand file management and organization.\n• Develop internet navigation and online safety skills.\n• Build confidence in using digital tools.',
      faqs: [
        {
          'question': 'Do I need my own computer to take this course?',
          'answer': 'While having access to a computer is beneficial, you can access the course content through any device with internet connectivity.'
        },
        {
          'question': 'What software applications will I learn?',
          'answer': 'You\'ll learn essential applications like Microsoft Office (Word, Excel, PowerPoint), email clients, and web browsers.'
        },
        {
          'question': 'Is this course suitable for complete beginners?',
          'answer': 'Yes, this course is specifically designed for beginners with little to no computer experience.'
        },
        {
          'question': 'Will I receive a certificate upon completion?',
          'answer': 'Yes, you\'ll receive a digital certificate upon successfully completing the course.'
        },
      ],
      howItWorks: '1. Start with basic computer concepts and terminology.\n2. Progress through hands-on exercises with common software applications.\n3. Practice file management and organization techniques.\n4. Complete interactive modules on internet usage and safety.\n5. Demonstrate your skills through practical assessments.',
    ),
    Program(
      imageUrl: 'assets/icons/market.png',
      title: 'Digital Marketing',
      description: 'Launch your digital marketing career with our comprehensive beginner\'s course. Learn the fundamentals of online marketing, social media management, and digital advertising strategies.',
      benefits: '• Understand core digital marketing concepts.\n• Learn social media marketing strategies.\n• Master basic SEO techniques.\n• Develop email marketing skills.\n• Create effective content marketing plans.\n• Analyze marketing metrics and data.',
      faqs: [
        {
          'question': 'What platforms will I learn about?',
          'answer': 'You\'ll learn about major platforms including Facebook, Instagram, LinkedIn, Google Ads, and email marketing tools.'
        },
        {
          'question': 'Do I need marketing experience?',
          'answer': 'No prior marketing experience is required. This course is designed for beginners.'
        },
        {
          'question': 'Will I create actual marketing campaigns?',
          'answer': 'Yes, you\'ll work on practical projects and create sample marketing campaigns as part of the learning process.'
        },
        {
          'question': 'How long does the course take to complete?',
          'answer': 'The course is self-paced and typically takes 4-6 weeks to complete.'
        },
      ],
      howItWorks: '1. Learn digital marketing fundamentals through video lessons.\n2. Practice with hands-on exercises and real-world examples.\n3. Create sample marketing campaigns and content.\n4. Analyze marketing metrics and optimization techniques.\n5. Complete a final project showcasing your skills.',
    ),
    Program(
      imageUrl: 'assets/icons/graphic.png',
      title: 'Graphic Designing',
      description: 'Start your journey in graphic design with our beginner-friendly course. Learn design principles, industry-standard tools, and create professional visual content.',
      benefits: '• Master fundamental design principles.\n• Learn industry-standard design software.\n• Create professional logos and graphics.\n• Develop a design portfolio.\n• Understand color theory and typography.\n• Practice with real-world projects.',
      faqs: [
        {
          'question': 'What software will I learn?',
          'answer': 'You\'ll learn popular design tools like Adobe Photoshop, Illustrator, and Canva.'
        },
        {
          'question': 'Do I need artistic skills?',
          'answer': 'No prior artistic experience is required. We\'ll teach you the fundamentals of design.'
        },
        {
          'question': 'Will I create a portfolio?',
          'answer': 'Yes, you\'ll complete projects throughout the course that can be included in your portfolio.'
        },
        {
          'question': 'What can I design after completing the course?',
          'answer': 'You\'ll be able to create logos, social media graphics, business cards, and other basic design materials.'
        },
      ],
      howItWorks: '1. Start with design principles and theory.\n2. Learn essential tools and software techniques.\n3. Practice with guided design projects.\n4. Create various types of graphic content.\n5. Build a basic design portfolio.',
    ),
    Program(
      imageUrl: 'assets/icons/web.png',
      title: 'Website Development',
      description: 'Begin your web development journey with our comprehensive course. Learn HTML, CSS, and basic JavaScript to create responsive and attractive websites.',
      benefits: '• Learn HTML5 and CSS3 fundamentals.\n• Understand basic JavaScript concepts.\n• Create responsive web designs.\n• Build interactive web pages.\n• Learn web hosting basics.\n• Develop real-world projects.',
      faqs: [
        {
          'question': 'Do I need coding experience?',
          'answer': 'No prior coding experience is required. We\'ll teach you everything from the basics.'
        },
        {
          'question': 'What tools will I need?',
          'answer': 'You\'ll need a computer with internet access and a text editor (we\'ll recommend free options).'
        },
        {
          'question': 'Will I build actual websites?',
          'answer': 'Yes, you\'ll create multiple websites as part of the course projects.'
        },
        {
          'question': 'Can I get a job after this course?',
          'answer': 'This course provides foundational skills that can help you start an entry-level web development position or freelance work.'
        },
      ],
      howItWorks: '1. Learn HTML structure and elements.\n2. Master CSS styling and layouts.\n3. Understand basic JavaScript and interactivity.\n4. Practice with hands-on coding projects.\n5. Build and deploy complete websites.',
    ),
  ];
} 