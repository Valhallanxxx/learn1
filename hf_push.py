import os
from huggingface_hub import HfApi


def main():
    # Read token from environment variable HF (cd.yml passes this)
    token = os.environ["HF"]

    api = HfApi(token=token)
    space_id = "Valhallan/learn1"  # your Space

    # 1) Upload Gradio app (App folder → Space root)
    api.upload_folder(
        folder_path="App",
        repo_id=space_id,
        repo_type="space",
    )

    # 2) Upload model files to /Model in the Space
    api.upload_folder(
        folder_path="Model",
        repo_id=space_id,
        repo_type="space",
        path_in_repo="Model",
    )

    # 3) Upload results/metrics to /Metrics in the Space
    api.upload_folder(
        folder_path="Results",
        repo_id=space_id,
        repo_type="space",
        path_in_repo="Metrics",
    )


if __name__ == "__main__":
    main()
