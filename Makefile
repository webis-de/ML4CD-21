VERSION := 0.0.2
NAME := webis
REPO := ml4cd-21

build: clean
	docker build -f dockerfiles/Dockerfile.tf.gpu -t ${REPO}/${NAME}:${VERSION} -t ${REPO}/${NAME}:latest .

run: build
	docker run --rm -it -p 8888:8888 -p 6006:6006 --gpus all --env PYTHONPATH=/tf/src --mount type=bind,source=${PWD},target=/tf ${REPO}/${NAME}:${VERSION} && make -s clean

run-cpu: build
	docker run --rm -it -p 8888:8888 -p 6006:6006 --env PYTHONPATH=/tf/src --mount type=bind,source=${PWD},target=/tf ${REPO}/${NAME}:${VERSION} && make -s clean

clean:
	sudo chown -R 1000:1000 .

push: build
	docker push ${REPO}/${NAME}:${VERSION} && docker push ${REPO}/${NAME}:latest
