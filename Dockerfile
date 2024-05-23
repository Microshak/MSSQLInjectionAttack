
# mssql-python3.6-pyodbc
# Python runtime with pyodbc to connect to SQL Server
FROM python:3.8.6


RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# install SQL Server drivers
RUN apt-get update 
#RUN apt-get install  -y msodbcsql18 ACCEPT_EULA=Y 

RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18


# install SQL Server tools
RUN  ACCEPT_EULA=Y  apt-get install -y   mssql-tools 
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

# python libraries
RUN apt-get update && apt-get install -y \
    python3-pip python3-dev python3-setuptools \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# install necessary locales
RUN apt-get update && apt-get install -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen
RUN pip3 install --upgrade pip

# install additional utilities
RUN apt-get update && apt-get install gettext nano vim -y





# install SQL Server Python SQL Server connector module - pyodbc
RUN pip3 install pyodbc
RUN pip3 install pandas
#RUN sudo apt-get install protobuf-compiler libprotoc-dev

COPY ./app /app
WORKDIR /app
RUN pip3 install -r requirements.txt
EXPOSE 5000

CMD ["python","-i","app.py"]