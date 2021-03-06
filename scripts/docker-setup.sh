#!/bin/bash

REPOSITORY_DIR=$(pwd)
WORKSPACE_DIR=/catkin_ws
DEPENDENCIES_DIR=$WORKSPACE_DIR/dependencies
APP_DIR=/root/.panda_simulator

# Install libfranka
mkdir $DEPENDENCIES_DIR && cd $DEPENDENCIES_DIR
git clone --recursive https://github.com/frankaemika/libfranka
cd libfranka
git checkout 0.5.0
git submodule update
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTS=0 ..
cmake --build . -- -j$(nproc)

# Clone the franka_ros and panda_moveit_config repositories for simulating Panda robot
cd $WORKSPACE_DIR/src
git clone https://github.com/rpl-as-ucl/panda_moveit_config.git
git clone --branch simulation https://github.com/rpl-as-ucl/franka_ros.git

# Install package dependencies with rosdep
cd $WORKSPACE_DIR
rosdep install --from-paths src --ignore-src -y --skip-keys libfranka --skip-keys moveit_perception

# create app directory for config files
mkdir $APP_DIR
