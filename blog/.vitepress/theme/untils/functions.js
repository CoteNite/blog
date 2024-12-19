const pattern = /[a-zA-Z0-9_\u0392-\u03C9\u00C0-\u00FF\u0600-\u06FF\u0400-\u04FF]+|[\u4E00-\u9FFF\u3400-\u4DBF\uF900-\uFAFF\u3040-\u309F\uAC00-\uD7AF]+/g;

export function countWord(data) {
    const m = data.match(pattern);
    let count = 0;

    if (!m) {
        return 0;
    }

    for (let i = 0; i < m.length; i++) {
        // If the word starts with a character in the CJK block
        if (m[i].charCodeAt(0) >= 0x4E00) {
            count += m[i].length;  // Add the length of the word for multi-character words
        } else {
            count += 1;  // Otherwise, it's a single character (like English letters or numbers)
        }
    }

    return count;
}
