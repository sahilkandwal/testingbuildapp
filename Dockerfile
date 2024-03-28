# Use the official Ubuntu 20.04 image as the base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during installations
ENV DEBIAN_FRONTEND noninteractive

# Install necessary packages for Android SDK and Gradle
RUN apt-get update && \
    apt-get install -y curl expect git openjdk-11-jdk wget unzip && \
    apt-get clean

# Set up environment variables for Android SDK
ENV ANDROID_HOME /opt/android-sdk
ENV PATH ${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools

# Download and install Android SDK
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd ${ANDROID_HOME}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip -O cmdline-tools.zip && \
    unzip -q cmdline-tools.zip -d . && \
    mv tools latest && \
    rm cmdline-tools.zip

# Accept Android SDK licenses
RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses

# Install Android build tools and platforms
RUN ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager "platform-tools" "build-tools;30.0.3" "platforms;android-30"

# Set the working directory inside the Docker container
WORKDIR /workspace
