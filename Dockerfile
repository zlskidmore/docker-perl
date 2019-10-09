# work from latest LTS ubuntu release
FROM ubuntu:18.04

# set the environment variables
ENV perl_version 5.28.2
ENV HOME /opt

# run update and install necessary tools ubuntu tools
RUN apt-get update -y && apt-get install -y \
    build-essential \
    curl \
    unzip \
    vim \
    less \
    wget \
    libnss-sss \
    libexpat1-dev \
    libssl-dev \
    zlib1g-dev

# Install perbrew and perl
WORKDIR /etc
RUN curl -L https://install.perlbrew.pl | bash
RUN ["/bin/bash", "-c", "cat /etc/bash.bashrc <(echo \"source ~/perl5/perlbrew/etc/bashrc\") > /etc/bash.bashrc.tmp"]
RUN mv /etc/bash.bashrc.tmp /etc/bash.bashrc
RUN /bin/bash -c "source $HOME/perl5/perlbrew/etc/bashrc && perlbrew init && perlbrew install --multi --thread $perl_version"

# install cpanminus
WORKDIR /usr/local/bin
RUN /bin/bash -c "source $HOME/perl5/perlbrew/etc/bashrc && perlbrew init && perlbrew switch $perl_version && curl -L https://cpanmin.us | perl - App::cpanminus"

# install cpanminus modules
WORKDIR /usr/local/bin
RUN /bin/bash -c "source $HOME/perl5/perlbrew/etc/bashrc && perlbrew init && perlbrew switch $perl_version && cpanm Getopt::Long"
RUN /bin/bash -c "source $HOME/perl5/perlbrew/etc/bashrc && perlbrew init && perlbrew switch $perl_version && cpanm SOAP::Lite"
RUN /bin/bash -c "source $HOME/perl5/perlbrew/etc/bashrc && perlbrew init && perlbrew switch $perl_version && cpanm YAML::Syck"
RUN /bin/bash -c "source $HOME/perl5/perlbrew/etc/bashrc && perlbrew init && perlbrew switch $perl_version && cpanm XML::Simple"
RUN /bin/bash -c "source $HOME/perl5/perlbrew/etc/bashrc && perlbrew init && perlbrew switch $perl_version && cpanm LWP"
RUN wget https://raw.githubusercontent.com/ebi-wp/webservice-clients/master/perl/dbfetch.pl
RUN wget https://raw.githubusercontent.com/ebi-wp/webservice-clients/master/deprecated/perl/soaplite/wsdbfetch_soaplite.pl

# set default command
CMD ["perl -v"]
