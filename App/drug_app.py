import gradio as gr
import skops.io as sio

MODEL_PATH = "./Model/drug_pipeline.skops"

# Get list of untrusted types from the file (skops security requirement)
unknown_types = sio.get_untrusted_types(file=MODEL_PATH)

# We trust this file because it comes from our own CI pipeline,
# so we pass those types explicitly to `trusted`.
pipe = sio.load(MODEL_PATH, trusted=unknown_types)



def predict_drug(age, sex, blood_pressure, cholesterol, na_to_k_ratio):
    """
    Predict drugs based on patient features.
    """
    features = [age, sex, blood_pressure, cholesterol, na_to_k_ratio]
    predicted_drug = pipe.predict([features])[0]
    return f"Predicted Drug: {predicted_drug}"


inputs = [
    gr.Slider(15, 74, step=1, label="Age"),
    gr.Radio(["M", "F"], label="Sex"),
    gr.Radio(["HIGH", "LOW", "NORMAL"], label="Blood Pressure"),
    gr.Radio(["HIGH", "NORMAL"], label="Cholesterol"),
    gr.Slider(6.2, 38.2, step=0.1, label="Na_to_K"),
]

outputs = gr.Label(num_top_classes=5)

examples = [
    [30, "M", "HIGH", "NORMAL", 15.4],
    [35, "F", "LOW", "NORMAL", 8],
    [50, "M", "HIGH", "HIGH", 34],
]

title = "Drug Classification"
description = "Enter the details to predict the Drug type."
article = (
    "This app is part of a CI/CD for ML demo. "
    "The model is trained and deployed automatically using GitHub Actions."
)

demo = gr.Interface(
    fn=predict_drug,
    inputs=inputs,
    outputs=outputs,
    examples=examples,
    title=title,
    description=description,
    article=article
)


if __name__ == "__main__":
    demo.launch()
