FROM openanalytics/r-base

# system libraries of general use
RUN apt-get update && apt-get install -y \
        sudo \
        pandoc \
        pandoc-citeproc \
        libcurl4-gnutls-dev \
        libcairo2-dev \
        libxt-dev \
        libssl-dev \
        libssh2-1-dev \
        libssl1.0.0 \
        libv8-dev \
        libxml2-dev \
        python3 \
        python3-pip

# Install python dependencies
RUN pip3 install --upgrade pip
RUN pip3 install --user pandas
RUN pip3 install --user synapseclient

# install renv
ENV RENV_VERSION 0.9.2
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

# copy the app to the image
RUN mkdir /root/dccvalidator
COPY . /root/dccvalidator/

# install R package dependencies
RUN R -e "renv::restore('/root/dccvalidator/')"

COPY .Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/root/dccvalidator')"]
