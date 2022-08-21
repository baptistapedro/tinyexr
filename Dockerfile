FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev
RUN git clone  https://github.com/syoyo/tinyexr
WORKDIR /vigra
RUN cmake -DCMAKE_C_COMPILER=afl-clang -DCMAKE_CXX_COMPILER=afl-clang++ .
RUN make
RUN mkdir /tinyexrCorpus
RUN wget https://github.com/AcademySoftwareFoundation/openexr-images/blob/master/TestImages/AllHalfValues.exr
RUN wget https://github.com/AcademySoftwareFoundation/openexr-images/blob/master/TestImages/RgbRampsDiagonal.exr
RUN wget https://github.com/AcademySoftwareFoundation/openexr-images/blob/master/TestImages/GammaChart.exr
RUN wget https://github.com/AcademySoftwareFoundation/openexr-images/blob/master/TestImages/WideFloatRange.exr
RUN wget https://github.com/AcademySoftwareFoundation/openexr-images/blob/master/TestImages/BrightRings.exr
RUN mv *.exr /tinyexrCorpus

ENTRYPOINT ["afl-fuzz", "-i", "/tinyexrCorpus", "-o", "/tinyexrOut"]
CMD ["/tinyexr/test_tinyexr", "@@"]
