FROM mitmproxy/mitmproxy:8.1.1

#RUN python3 -m pip install --user pipx
#RUN python3 -m pipx ensurepath

#RUN /root/.local/bin/pipx install mitmproxy
RUN ln -s /usr/local/bin/mitmproxy /usr/bin/mitmproxy
RUN ln -s /usr/local/bin/mitmdump /usr/bin/mitmdump
RUN ln -s /usr/local/bin/mitmweb /usr/bin/mitmweb

COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

CMD ["sh"]
