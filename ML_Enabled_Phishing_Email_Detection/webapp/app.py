import streamlit as st
import re

st.set_page_config(page_title="Phishing Email Detection Dashboard", layout="centered")

st.title("📧 Phishing Email Detection Dashboard")

st.write(
    """
    This dashboard allows you to analyze email content and predict whether it is a phishing attempt.
    Paste the email text below and click **Analyze**.
    """
)

def simple_phishing_detector(email_text):
    # Simple rule-based detection for demonstration
    phishing_keywords = [
        "urgent", "verify your account", "click here", "login", "password", "bank", "update your information",
        "suspend", "limited time", "act now", "confirm", "security alert", "reset", "account locked"
    ]
    suspicious_links = re.findall(r'http[s]?://\S+', email_text, re.IGNORECASE)
    score = 0

    # Keyword check
    for kw in phishing_keywords:
        if kw in email_text.lower():
            score += 1

    # Link check
    score += len(suspicious_links)

    # Heuristic: if score >= 2, flag as phishing
    if score >= 2:
        return "Phishing", score, suspicious_links
    else:
        return "Legitimate", score, suspicious_links

# Placeholder functions for other models
def logistic_phishing_detector(email_text):
    # Placeholder: Replace with actual model inference
    return "Legitimate", 1, []

def bayes_phishing_detector(email_text):
    # Placeholder: Replace with actual model inference
    return "Phishing", 2, []

def rf_phishing_detector(email_text):
    # Placeholder: Replace with actual model inference
    return "Phishing", 3, []

model_options = {
    "Rule-based": simple_phishing_detector,
    "Logistic Regression": logistic_phishing_detector,
    "Naive Bayes": bayes_phishing_detector,
    "Random Forest": rf_phishing_detector,
    
}

with st.form("phishing_form"):
    demo_text = """
[https://www.canadapost-postescanada.ca/cpc/assets/cpc/img/logos/cpc-main-logo.svg]
Dear amuench@uvic.ca,

An agent of ours tried to ship a package to your address and no one was home, the package returned to our warehouse. Your action is required to establish a new shipment a small fee must be paid, otherwise it will be returned to sender.

To schedule a urgent shipment just follow the steps bellow:

Parcel no: 8857281302282572 - 12/29/2023 10:39:51 AM

&gt;&gt;&gt; Request new shipment &lt;&lt;&lt; <https://s3.amazonaws.com/ats-nivedhana/nivedhana/44/8/new-schedule.html>

Please assure that on the next shipment someone is at the address to receive the parcel.
Thank You,
MyCanadaPost.

2024 MyCanadaPost
To ensure that you receive future emails, please add
<mailto:hudsonesajoyce@gmail.com>
"""

    email_text = st.text_area(
        "Paste the email content here:",
        value=demo_text,
        height=250
    )
    
    model_choice = st.selectbox(
        "Select detection model:",
        list(model_options.keys()),
        index=0
    )
    submitted = st.form_submit_button("Analyze")

if submitted:
    if not email_text.strip():
        st.warning("Please paste the email content to analyze.")
    else:
        detector_func = model_options[model_choice]
        result, score, links = detector_func(email_text)
        if result == "Phishing":
            st.error("⚠️ This email is likely a **Phishing** attempt!")
        else:
            st.success("✅ This email appears to be **Legitimate**.")

        st.markdown(f"**Detection Score:** {score}")
        if links:
            st.markdown("**Suspicious Links Detected:**")
            for link in links:
                st.write(f"- {link}")
