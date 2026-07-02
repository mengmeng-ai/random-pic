const fs = require('fs');
const path = require('path');

export default function handler(req, res) {
    const filePath = path.join(process.cwd(), 'urls.txt');
    const urls = fs.readFileSync(filePath, 'utf-8').split('\n').filter(Boolean);
    const randomUrl = urls[Math.floor(Math.random() * urls.length)].trim();
    // 302 重定向到随机出来的图片直链
    res.redirect(302, randomUrl);
}
