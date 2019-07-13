#!/bin/bash

# Uncomment -> integrationTestFelixFolder=/custom/felix
sed -i "s,^# integrationTestFelixFolder=.*$,integrationTestFelixFolder=/custom/felix,g" /build/src/core/dotCMS/gradle.properties

# Prepare everything to run the integration tests
# We will run some heavy compile tasks (and download dependencies) in order to take
# advantage of the build image cache
cd /build/src/core/dotCMS \
    && ./gradlew immutables \
    && ./gradlew compileAspect \
    && ./gradlew compileTestAspect \
    && ./gradlew prepareIntegrationTests