#!/usr/bin/env bash

echo "Installing InfraPulse..."

mkdir -p logs reports

chmod +x monitoring/*.sh
chmod +x dashboard/*.sh
chmod +x lib/*.sh

echo "Installation Complete."
