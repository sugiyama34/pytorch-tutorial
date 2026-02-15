FROM nvidia/cuda:12.8.0-cudnn-devel-ubuntu24.04

ARG PYTHON_VERSION=3.12

ENV DEBIAN_FRONTEND="noninteractive"
ENV LC_ALL="C.UTF-8"
ENV LANG="C.UTF-8"

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    python${PYTHON_VERSION} \
    python3-pip \
    python-is-python3 \
    git \
    wget \
    ca-certificates \
 && apt-get -y clean \
 && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 1 && \
    update-alternatives --set python3 /usr/bin/python${PYTHON_VERSION}
RUN pip install --upgrade pip uv

# Environment (uv)
RUN uv venv /opt/venv --python /usr/bin/python${PYTHON_VERSION}
ENV VIRTUAL_ENV="/opt/venv"
ENV PATH="/opt/venv/bin:$PATH"

RUN uv pip install psutil \
    && uv pip install torch==2.9.1 torchvision==0.24.1 torchaudio==2.9.1 --index-url https://download.pytorch.org/whl/cu128

COPY requirements.txt /tmp/requirements.txt
RUN uv pip install -r /tmp/requirements.txt
# RUN uv pip install -e .

CMD ["/bin/bash"]
