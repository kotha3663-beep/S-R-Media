# NnowQuiz

মজার কুইজ প্ল্যাটফর্ম - প্রবন্ধ পড়ে কুইজ দিন, পয়েন্ট জিতুন, লিডারবোর্ডে জায়গা করে নিন।

## টেক স্ট্যাক
- HTML + CSS + JavaScript
- Supabase (Auth + Database)
- Vercel + GitHub (Hosting)

## সেটআপ

1. Supabase প্রজেক্ট তৈরি করুন
2. SQL Editor-এ স্কিমা রান করুন (আগে দেওয়া)
3. Authentication → Providers → Email → Confirm email **Off** করুন
4. `js/supabase.js` ফাইলে URL ও Anon Key বসান
5. প্রথম ইউজার রেজিস্টার করুন
6. Supabase → Table Editor → `profiles` → আপনার ইউজারের `is_admin` = `true` করুন
7. GitHub-এ আপলোড করে Vercel-এ ডিপ্লয় করুন

## এডমিন প্যানেল
- URL: `/admin/index.html`
- প্রবন্ধ যোগ/এডিট/ডিলিট
- প্রশ্ন যোগ/ডিলিট
- কুইজ পজ/চালু
- সেটিংস পরিবর্তন

## কুইজ সিস্টেম
- ৮টি কুইজ × ৫টি প্রশ্ন
- প্রতি সঠিক উত্তরে ১০ পয়েন্ট
- ২ ঘণ্টায় সর্বোচ্চ ৮টি কুইজ
- প্রবন্ধ সাইকেল + সেট রোটেশন

## বিজ্ঞাপন
- Multitag + Native সবসময়
- Interstitial প্রতি ৪ মিনিট (রোটেশন)
- Rewarded কুইজ শুরুর সময়
- পরে Monetag / Adsterra / HilltopAds কোড যোগ করতে হবে
