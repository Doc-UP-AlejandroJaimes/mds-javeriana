import re

from mrjob.job import MRJob


class MRWordCount(MRJob):
    def mapper(self, _, line):
        words = re.findall(r"[a-záéíóúüñ]+", line.lower())
        for word in words:
            yield word, 1

    def reducer(self, word, counts):
        yield word, sum(counts)


if __name__ == "__main__":
    MRWordCount.run()
