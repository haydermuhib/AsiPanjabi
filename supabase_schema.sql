-- ==========================================================================
-- AsiPanjabi - Supabase PostgreSQL Schema & Seed Data Migration
-- Copy and paste this script directly into your Supabase SQL Editor
-- (https://supabase.com/dashboard/project/zvrgniyqgubooaniallx/sql)
-- ==========================================================================

-- 1. Create Tables
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    hashed_password TEXT NOT NULL,
    full_name VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    image_url TEXT,
    display_order INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS lessons (
    id SERIAL PRIMARY KEY,
    category_id INT REFERENCES categories(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    description TEXT,
    display_order INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS vocabularies (
    id SERIAL PRIMARY KEY,
    lesson_id INT REFERENCES lessons(id) ON DELETE CASCADE,
    english VARCHAR(255) NOT NULL,
    romanized VARCHAR(255) NOT NULL,
    gurmukhi VARCHAR(255) NOT NULL,
    shahmukhi VARCHAR(255) NOT NULL,
    pronunciation_hint VARCHAR(255),
    example_en TEXT,
    example_pa TEXT
);

CREATE TABLE IF NOT EXISTS user_progress (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    vocabulary_id INT REFERENCES vocabularies(id) ON DELETE CASCADE,
    state VARCHAR(50) DEFAULT 'learning',
    last_reviewed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Enable Row Level Security (RLS) policies for public reading
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE vocabularies ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public read access to categories" ON categories FOR SELECT USING (true);
CREATE POLICY "Allow public read access to lessons" ON lessons FOR SELECT USING (true);
CREATE POLICY "Allow public read access to vocabularies" ON vocabularies FOR SELECT USING (true);

-- 3. Seed Initial Categories
INSERT INTO categories (id, title, slug, description, image_url, display_order) VALUES
(1, 'Greetings & Essentials', 'greetings-and-essentials', 'Master everyday Panjabi welcomes, polite phrases, and basic conversations.', 'https://images.unsplash.com/photo-1544717305-2782549b5136?q=80&w=800&auto=format&fit=crop', 1),
(2, 'Family & Kinship', 'family-and-relatives', 'Panjabi culture has rich, distinct names for every family member.', 'https://images.unsplash.com/photo-1511895426328-dc8714191300?q=80&w=800&auto=format&fit=crop', 2),
(3, 'Panjabi Food & Dining', 'food-and-dining', 'Essential Panjabi culinary terms, dishes, and restaurant orders.', 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?q=80&w=800&auto=format&fit=crop', 3),
(4, 'Travel & Directions', 'travel-and-directions', 'Navigate Panjab cities, ask for directions, and ride transport.', 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?q=80&w=800&auto=format&fit=crop', 4)
ON CONFLICT (id) DO NOTHING;

-- 4. Seed Lessons
INSERT INTO lessons (id, category_id, title, slug, description, display_order) VALUES
(1, 1, 'Basic Greetings & Respect', 'basic-greetings', 'Standard greetings used across Panjab.', 1),
(2, 1, 'Politeness & Respect', 'polite-phrases', 'Expressing gratitude, apologies, and respect in Panjabi.', 2),
(3, 2, 'Immediate Family', 'immediate-family', 'Mother, Father, Brother, Sister, and Grandparents.', 1),
(4, 3, 'Staples & Dishes', 'staples-and-dishes', 'Famous Panjabi dishes and meals.', 1),
(5, 4, 'Asking for Directions', 'asking-directions', 'Where is it, left, right, straight ahead.', 1)
ON CONFLICT (id) DO NOTHING;

-- 5. Seed Vocabulary Across Gurmukhi, Shahmukhi, and Romanized Scripts
INSERT INTO vocabularies (id, lesson_id, english, romanized, gurmukhi, shahmukhi, pronunciation_hint, example_en, example_pa) VALUES
(1, 1, 'Hello / Greetings (Sikh standard)', 'Sat Sri Akal', 'ਸਤਿ ਸ਼੍ਰੀ ਅਕਾਲ', 'ست سری اکال', 'Sat Shree Ah-kaal', 'Hello my friend, how are you?', 'Sat Sri Akal veer ji, ki haal hai?'),
(2, 1, 'Peace be upon you / Hello (Muslim standard)', 'Assalam-o-Alaikum', 'ਅੱਸਲਾਮੂ ਅਲੈਕੁਮ', 'السلام علیکم', 'As-sah-laam-o-ah-lay-koom', 'Peace be upon you uncle.', 'Assalam-o-alaikum Chacha ji.'),
(3, 1, 'How are you? (Casual)', 'Kiddan?', 'ਕਿੱਦਾਂ?', 'کِداں؟', 'Kid-daan?', 'Hey brother! How are you?', 'Kiddan bhaji! Sab thik?'),
(4, 1, 'Thank you', 'Shukriya / Dhanvaad', 'ਸ਼ੁਕਰੀਆ / ਧੰਨਵਾਦ', 'شکریہ / دھنواد', 'Shook-ree-yah / Dhan-vaad', 'Thank you very much for your help.', 'Tuhada bohat shukriya.'),
(5, 1, 'I am fine / Good', 'Main thik haan', 'ਮੈਂ ਠੀਕ ਹਾਂ', 'میں ٹھیک ہاں', 'Main theek haan', 'I am doing fine, thank you.', 'Main bilkul thik haan, shukriya.'),
(6, 2, 'Please', 'Kripya / Meharbani', 'ਕ੍ਰਿਪਾ ਕਰਕੇ / ਮਿਹਰਬਾਨੀ', 'مہربانی / کرپا کرکے', 'Me-har-baa-nee', 'Please come inside.', 'Kripya andar aajo.'),
(7, 2, 'Excuse me / Sorry', 'Maaf karna', 'ਮਾਫ਼ ਕਰਨਾ', 'معاف کرنا', 'Maaf kar-nah', 'Sorry, I arrived late.', 'Maaf karna, main late ho gaya.'),
(8, 2, 'No problem / It''s okay', 'Koi baat nahi', 'ਕੋਈ ਗੱਲ ਨਹੀਂ', 'کوئی گل نہیں', 'Koi gall nah-hee', 'No problem at all, don''t worry.', 'Koi gall nahi, fikar na karo.'),
(9, 2, 'Good night', 'Shubh ratri / Rab rakha', 'ਸ਼ੁਭ ਰਾਤਰੀ / ਰੱਬ ਰਾਖਾ', 'رب راکھا / شبھ راتری', 'Rabb raa-khaa', 'Good night, see you tomorrow.', 'Rab rakha, kal milde haan.'),
(10, 3, 'Mother', 'Mata ji / Bebe / Ammee', 'ਮਾਤਾ ਜੀ / ਬੇਬੇ / ਅੰਮੀ', 'امی / بیبے / ماتا جی', 'Maa-taa ji / Bay-bay', 'Mother is cooking food.', 'Mata ji khana bana rahe han.'),
(11, 3, 'Father', 'Pita ji / Bapu / Abbu', 'ਪਿਤਾ ਜੀ / ਬਾਪੂ / ਅੱਬੂ', 'ابو / باپو / پتا جی', 'Pee-taa ji / Baa-poo', 'Father went to the market.', 'Pita ji bazaar gaye han.'),
(12, 3, 'Elder Brother', 'Veer ji / Bhaji', 'ਵੀਰ ਜੀ / ਭਾਜੀ', 'ویر جی / بھاجی', 'Veer ji / Bhaa-jee', 'My elder brother lives in Toronto.', 'Mera veer ji Toronto rehnde han.'),
(13, 3, 'Sister', 'Bhen / Didi', 'ਭੈਣ / ਦੀਦੀ', 'بھین / دیدی', 'Bhen / Dee-dee', 'My sister is studying.', 'Meri bhen padh rahi hai.'),
(14, 3, 'Paternal Grandfather', 'Dada ji', 'ਦਾਦਾ ਜੀ', 'دادا جی', 'Daa-daa ji', 'Grandfather tells great stories.', 'Dada ji vahiaat kahaniyan sunaunde han.'),
(15, 4, 'Water', 'Pani', 'ਪਾਣੀ', 'پاݨی', 'Paa-nee', 'Please give me cold water.', 'Kripya mainu thanda pani deo.'),
(16, 4, 'Tea / Chai', 'Chaa', 'ਚਾਹ', 'چاہ', 'Chaa', 'Would you like a cup of tea?', 'Ki tusi chaa pioge?'),
(17, 4, 'Bread / Roti', 'Roti / Phulka', 'ਰੋਟੀ / ਫੁਲਕਾ', 'روٹی / پھلکا', 'Ro-tee', 'The roti is hot and fresh.', 'Roti garam hai.'),
(18, 4, 'Clarified Butter / Ghee', 'Ghyoo / Ghee', 'ਘਿਓ', 'گھیو', 'Ghyoo', 'Put some ghee on the paratha.', 'Paranthe te ghyoo laao.'),
(19, 4, 'Delicious / Tasty', 'Swaad / Bohat badiya', 'ਸਵਾਦ', 'سواد', 'Swaad', 'The food is very delicious!', 'Khana bohat swaad hai!')
ON CONFLICT (id) DO NOTHING;
