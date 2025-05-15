docker-push:

	aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 418295709007.dkr.ecr.eu-west-2.amazonaws.com
	docker build -t project_image_yd .
	docker tag project_image_yd:latest 418295709007.dkr.ecr.eu-west-2.amazonaws.com/project_image_yd:xelixproject
	docker push 418295709007.dkr.ecr.eu-west-2.amazonaws.com/project_image_yd:xelixproject