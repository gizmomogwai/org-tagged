FROM ubuntu:22.04
RUN apt update --fix-missing
RUN apt install --yes software-properties-common
RUN add-apt-repository --yes ppa:kelleyk/emacs
RUN apt update
RUN apt install --yes emacs28-nox curl python3 git
RUN git clone https://github.com/cask/cask ~/.cask
WORKDIR /root
COPY Cask /root/
COPY org-tagged.el /root/
ENV PATH=/root/.cask/bin:$PATH
RUN cask --verbose install
ENTRYPOINT ["cask"]
CMD ["emacs"]
