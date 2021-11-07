FROM ubuntu:21.04

# Prerequisites
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget

WORKDIR /sdk

# Prepare Android directories and system variables
RUN mkdir -p Android/cmdline-tools/latest
ENV ANDROID_SDK_ROOT /sdk/Android

# Set up Android SDK
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv cmdline-tools/* Android/cmdline-tools/latest/
RUN cd Android/cmdline-tools/latest/bin && yes | ./sdkmanager --licenses
RUN cd Android/cmdline-tools/latest/bin && ./sdkmanager "build-tools;29.0.2" "platform-tools" "platforms;android-30" "sources;android-29"
ENV PATH "$PATH:Android/platform-tools"

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/sdk/flutter/bin"

# Run basic check to download Dark SDK
RUN flutter doctor -v
WORKDIR /app