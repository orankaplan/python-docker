FROM ubuntu:16.04


# remove several traces of debian python
RUN apt-get purge -y python.*

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# gpg: key 18ADD4FF: public key "Benjamin Peterson <benjamin@python.org>" imported
ENV GPG_KEY C01E1CAD5EA2C4F0B8E3571504C367C218ADD4FF

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 8.1.1

RUN apt-get update -y \
    && apt-get install -y \
    wget ssh nano iputils-ping \
    python2.7 python2.7-dev \
    mysql-client python-mysqldb libmysqlclient-dev ca-certificates libpq-dev build-essential \
    libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev sqlite3 libsqlite3-dev postgresql python-tk\
    locales libxmlsec1 libxmlsec1-dev language-pack-en-base libffi-dev libxml2-dev libxslt1-dev \
    python-pip python-setuptools \
    --no-install-recommends

RUN echo "mysql-server mysql-server/root_password select root" | debconf-set-selections \
    && echo "mysql-server mysql-server/root_password_again select root" | debconf-set-selections \
    && apt-get -y install mysql-server

RUN pip install --upgrade pip==$PYTHON_PIP_VERSION

RUN pip install -U cython
RUN pip install -U setuptools
RUN pip install -U Mercurial
RUN pip install -U virtualenv

RUN locale-gen en_US.UTF-8 \
    && dpkg-reconfigure locales \
    && echo "LANG=en_US.UTF-8" > /etc/default/locale \
    && echo "LC_TYPE=en_US.UTF-8" > /etc/default/locale \
    && echo "LC_MESSAGES=POSIX" >> /etc/default/locale \
    && echo "LANGUAGE=en" >> /etc/default/locale \
    && echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale \
    && echo "export LC_ALL=en_US.utf8" >> ~/.bashrc \
    && echo "export LANG=en_US.utf8" >> ~/.bashrc \
    && echo "export LANGUAGE=en_US.utf8" >> ~/.bashrc \
    && echo "export PYTHONPATH=/usr/local/lib/python2.7/dist-packages" >> ~/.bashrc \
    && echo "alias python=/usr/bin/python2.7" >> ~/.bashrc


ENV PYTHONUNBUFFERED 1
