# DESIGN-vibrant.md - AsiPanjabi Modern Youth Learning System

## Brand Core & Aesthetics
- **Target Audience**: Teenagers, young adults, and language learners seeking an inspiring, modern Panjabi vocabulary portal.
- **Visual Aesthetic**: Duolingo / Quizlet hybrid — vibrant, energetic, clean, and highly structured with playful yet professional UI components.
- **Strict Brand Rule**: **NO EMOJIS EVER**. All visual badges, micro-indicators, and UI elements must use clean inline SVG vector graphics and CSS pills.

## Color System & Script Identity

```css
:root {
  /* Brand Canvas & Surface */
  --bg-canvas: #FAF8F5;
  --bg-card: #FFFFFF;
  --bg-card-glass: rgba(255, 255, 255, 0.88);
  --color-border: #E8E2D9;
  --color-ink: #0F172A;
  --color-body: #475569;
  --color-muted: #64748B;

  /* Vibrant Accents */
  --accent-saffron: #FF6B00;
  --accent-saffron-hover: #E05300;
  --accent-saffron-light: #FFF7ED;

  --accent-emerald: #059669;
  --accent-emerald-light: #ECFDF5;

  --accent-indigo: #6366F1;
  --accent-indigo-light: #EEF2FF;

  --accent-coral: #F43F5E;
  --accent-coral-light: #FFF1F2;

  /* Script Specific Colors */
  --script-gurmukhi-bg: #FFF7ED;
  --script-gurmukhi-text: #C2410C;
  --script-gurmukhi-border: #FDBA74;

  --script-shahmukhi-bg: #ECFDF5;
  --script-shahmukhi-text: #047857;
  --script-shahmukhi-border: #6EE7B7;

  --script-romanized-bg: #EEF2FF;
  --script-romanized-text: #4338CA;
  --script-romanized-border: #A5B4FC;
}
```

## Duolingo-Style Lesson Architecture

1. **Top Progress Track**:
   - Live visual progress bar (`0%` to `100%`) showing exact step completion.
   - Script indicator pill (Gurmukhi / Shahmukhi / Romanized).

2. **Step 1..N — Learn Phase (Card Studio)**:
   - Big, readable Panjabi target word in chosen script.
   - Pronunciation guide & English translation.
   - Contextual example sentence.
   - Primary CTA: *"Continue / Next Word"* (advances to next step in sequence).

3. **Step N+1..M — Test Phase (MCQ Studio)**:
   - Target prompt (e.g. *"What is the meaning of Sat Sri Akal?"* or *"Select the correct translation for 'Thank You'"*).
   - 4 interactive option cards with A, B, C, D badges.
   - Instant visual feedback: Emerald `#059669` for correct, Coral `#F43F5E` for incorrect.
   - Primary CTA: *"Check Answer"* ➔ *"Continue"*.

4. **Mastery Completion Screen**:
   - Celebration badge with SVG emblem.
   - Score stats (Accuracy, Words Mastered).
   - Primary CTAs: *"Next Lesson"* / *"Back to Category"*.

## Typography & Script Specs
- Display Font: `Outfit`, `Plus Jakarta Sans`, sans-serif.
- Body Font: `Inter`, sans-serif.
- Gurmukhi Font: `Noto Sans Gurmukhi`, sans-serif.
- Shahmukhi Font: `Noto Naskh Arabic`, sans-serif.
