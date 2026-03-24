#FROM --platform=linux/arm64 rocker/r-ver:4.5.0
FROM rocker/r-ver:4.5.0
# Set working directory
WORKDIR /home

# Install system dependencies
#RUN apt-get update && \
#    apt-get install -y --no-install-recommends \
#        libcurl4-openssl-dev \
#        libssl-dev \
#	libxml2-dev \
#	zlib1g-dev \
#	libfontconfig1-dev \
#	libharfbuzz-dev \
#	libfribidi-dev \
#	libfreetype6-dev \
#	libpng-dev \
#	libtiff5-dev \
#	libjpeg-dev \
#	pkg-config \
#        && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY renv.lock /home/renv.lock
COPY renv/library /home/app/renv/library

# Install renv and restore environment
RUN R -e "install.packages('renv', repos='https://packagemanager.posit.co/cran/latest')" && \
    R -e "renv::restore()"
