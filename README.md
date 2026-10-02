# Gutenberg Text Mining & Quantitative NLP Analysis (R)

A statistical and Natural Language Processing (NLP) study of classical literature using R. This project demonstrates end-to-end data extraction, tokenization, chi-square hypothesis testing for collocations, character entropy dynamics, and a custom Naïve Bayes text classifier.

---

## 📌 Project Overview

The project extracts and analyzes Marius Topin's historical work *"The Man with the Iron Mask"* (Gutenberg ID: `70207`, 115,000+ words) sourced via `gutenbergr`.

### Key Highlights:
- **Data Acquisition & Pipeline:** Integrated `gutenbergr`, `tidytext`, and `dplyr` for automated text fetching and tokenization.
- **N-gram Analysis:** Computed frequencies for unigrams, bigrams, and trigrams to analyze stylistic structures.
- **Statistical Collocation Testing:** Built contingency matrices and performed Chi-Square tests (`chisq.test`) with mosaic plots to evaluate word dependency (comparing fixed phrase `"according to"` vs. `"of their"`).
- **Information Theory (Entropy):** Segmented text into 116 blocks of 1,000 words each to calculate character-level Shannon entropy ($H(X) = -\sum p_i \log_2 p_i$).
- **Statistical Confidence Intervals:** Computed a 95% Confidence Interval for mean entropy using $t$-distribution ($t_{\alpha/2, df=n-1}$).
- **Custom Naïve Bayes Classifier:** Built a probabilistic text classifier with Laplace smoothing from scratch to accurately identify the originating section of a test sentence.

---

## 🛠️ Tools & Packages

- **Language:** R
- **Packages:** `gutenbergr`, `tidytext`, `dplyr`

---

## 📊 Core Results

- **Chi-Square Dependency Test:** `"according to"` showed a statistically significant dependency ($p < 2.2 \times 10^{-16}$).
- **Mean Entropy:** $\approx 4.25$ (SD: $0.106$).
- **95% Confidence Interval:** $[4.23, 4.27]$ for average character-level entropy.
- **Naïve Bayes Classification:** Correctly matched the target sentence to Section 2 with a normalized posterior probability of **74.8%**.
