FROM ubuntu:22.04
RUN apt update
RUN apt install --yes emacs-nox curl python3 git
RUN git clone https://github.com/cask/cask ~/.cask
WORKDIR /root
COPY Cask /root/
COPY org-tagged.el /root/
ENV PATH=/root/.cask/bin:$PATH
RUN cask install
ENTRYPOINT ["cask"]
COPY features /root/features/
CMD ["emacs"]
