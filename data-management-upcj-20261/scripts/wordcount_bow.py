import re

from mrjob.job import MRJob

STOPWORDS = {
    # Stopwords español
    "de",
    "la",
    "en",
    "el",
    "a",
    "que",
    "y",
    "una",
    "las",
    "los",
    "se",
    "por",
    "un",
    "para",
    "es",
    "no",
    "al",
    "como",
    "del",
    "con",
    "su",
    "más",
    "pero",
    "sus",
    "le",
    "ya",
    "o",
    "este",
    # Stopwords inglés
    "the",
    "of",
    "and",
    "in",
    "to",
    "is",
    "for",
    "are",
    "that",
}


class MRWordCountBoW(MRJob):
    def mapper(self, _, line):
        words = re.findall(r"[a-záéíóúüñ]+", line.lower())
        for word in words:
            if word not in STOPWORDS:
                yield word, 1

    def reducer(self, word, counts):
        yield word, sum(counts)


if __name__ == "__main__":
    MRWordCountBoW.run()
