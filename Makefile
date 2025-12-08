install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

format:
	black *.py

train:
	python train.py

eval:
	echo "## Model Metrics" > report.md
	cat ./Results/metrics.txt >> report.md

	echo '\n## Confusion Matrix Plot' >> report.md
	echo '![Confusion Matrix](./Results/model_results.png)' >> report.md

	cml comment create report.md

update-branch:
	git config --global user.name $(USER_NAME)
	git config --global user.email $(USER_EMAIL)
	git add .
	git commit -m "Update with new results" || echo "No changes to commit"
	git push --force origin HEAD:update

hf-login:
	git pull origin update
	git switch update
	pip install -U "huggingface_hub>=1.0.0"

push-hub:
	python - << 'EOF'
	import os
	from huggingface_hub import HfApi

	token = os.environ["HF"]
	api = HfApi(token=token)
	space_id = "Valhallan/learn1"

	# Upload Gradio app (App folder goes to Space root)
	api.upload_folder(
	    folder_path="App",
	    repo_id=space_id,
	    repo_type="space",
	)

	# Upload model files to /Model in the Space
	api.upload_folder(
	    folder_path="Model",
	    repo_id=space_id,
	    repo_type="space",
	    path_in_repo="Model",
	)

	# Upload results/metrics to /Metrics in the Space
	api.upload_folder(
	    folder_path="Results",
	    repo_id=space_id,
	    repo_type="space",
	    path_in_repo="Metrics",
	)
	EOF

deploy: hf-login push-hub
