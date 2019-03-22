FROM apihackers/pelican:pyup_update-pelican-3.7.1-to-4.0.1

COPY requirements.txt requirements.txt
RUN python3 -m pip install -r requirements.txt
CMD bash