import os

import requests
from requests.compat import urljoin
import streamlit as st
import google.auth.transport.requests
import google.oauth2.id_token

URL = os.environ.get("BACKEND_URL")


auth_req = google.auth.transport.requests.Request()
target_audience = URL
id_token = google.oauth2.id_token.fetch_id_token(auth_req, target_audience)
headers = {"Authorization": f"Bearer {id_token}"}

st.title('Greeting')

form = st.form(key='my-form')
name = form.text_input('Enter your name')
submit = form.form_submit_button('Submit')

st.write('Press submit to have your name')

if submit:
    params = {'name': name}
    resp = requests.get(urljoin(URL, 'hello'), params=params, headers=headers)
    st.json(resp.json())