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
	pip install -U "huggingface_hub[cli]"
	python -m huggingface_hub.commands.huggingface_cli login --token $(HF) --add-to-git-credential

push-hub:
	python -m huggingface_hub.commands.huggingface_cli upload Valhallan/learn1 ./App --repo-type=space --commit-message="Sync App files"
	python -m huggingface_hub.commands.huggingface_cli upload Valhallan/learn1 ./Model /Model --repo-type=space --commit-message="Sync Model"
	python -m huggingface_hub.commands.huggingface_cli upload Valhallan/learn1 ./Results /Metrics --repo-type=space --commit-message="Sync Metrics"

deploy: hf-login push-hub

