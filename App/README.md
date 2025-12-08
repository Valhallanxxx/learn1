---
title: Drug Classification
emoji: 💊
colorFrom: indigo
colorTo: cyan
sdk: gradio
app_file: drug_app.py
pinned: false
---

Drug classification demo Space for CI/CD with GitHub Actions.

This Space runs a Gradio app from `drug_app.py` and uses a scikit-learn
pipeline saved in `Model/drug_pipeline.skops`. The model and metrics are
updated automatically from the GitHub repository via CI/CD.
