#!/bin/bash
#
# TODO: Add gpt code review for buffer feature into neovim plugin,
# IDEA: Ask gpt for potential bugs and write suggested fixes as fix comment on top of the code
# FIX: 
#1. It is recommended to add error handling for pip installation in ask_install_requirements() in case the installation fails.
#2. In create_venv(), it is recommended to add error handling in case the venv creation fails.
#3. In activate_venv(), the function asks for requirements installation only if the venv is activated. It is recommended to add a check before calling the function to ask for installing requirements to make sure the venv is activated.
#4. In is_this_script_called_via_source(), it is recommended to use [[ $0 == "$BASH_SOURCE" ]] instead of checking the shell name to determine if the script is sourced or not, as it is more reliable.
#5. In activate_venv(), it is recommended to check for the existence of pip before installing requirements to prevent errors if pip is not installed in the system.

ask_install_requirements() {
    echo "😀 Do you want to install the requirements? [y/n]"
    read answer
    if [ "$answer" == "y" ]; then
      if [ -f requirements.txt ]; then
        pip install -r requirements.txt
      else
        echo "😀 requirements.txt not found"
      fi
    else
        echo "😀 exit without installing requirements"
    fi
}

create_venv() {
      python3 -m venv venv
      echo "😀 venv created"
      asks_activate_venv
}

is-venv-activated() {
    if [ -z "$VIRTUAL_ENV" ]; then
        echo "😀 venv not activated"
        return 1
    else
        echo "😀 venv activated"
        return 0
    fi
}

ask_remove_venv_and_recreate() {
    echo "😀 Do you want to remove the venv and recreate it? [y/n]"
    read answer
    if [ "$answer" == "y" ]; then
        rm -rf venv
        create_venv
    else
        echo "😀 exit without removing venv"
    fi
}

ask_create_venv() {
    echo "😀 Do you want to create the venv? [y/n]"
    read answer
    if [ "$answer" == "y" ]; then
        create_venv
    else
        echo "😀 exit without creating venv"
    fi
}

ask_activate_venv() {
    echo "😀 Do you want to activate the venv? [y/n]"
    read answer
    if [ "$answer" == "y" ]; then
        activate_venv
    else
        echo "😀 exit without activating venv"
    fi
}

is_requirements_are_installed() {
    if [ -f requirements.txt ]; then
        pip freeze | grep -f requirements.txt
        return $?
    else
        echo "😀 requirements.txt not found"
        return 1
    fi
}

get_called_shell_name() {
    echo $SHELL | awk -F/ '{print $NF}'
}

get_current_shell_name() {
    ps -p $$ | tail -1 | awk '{print $NF}'
}

is_this_script_called_via_source() {
  if [[ $(get_called_shell_name) == $(get_current_shell_name) ]]; then
      echo "😀 this script is called via 'source venv.sh'"
      return 0
  else
      echo "😀 this script is called directly"
      return 1
  fi
}

activate_venv() {
  if is_this_script_called_via_source; then
    if [ -d venv ] && [ -f venv/bin/activate ]; then
        source venv/bin/activate
        if is-venv-activated; then
            if is_requirements_are_installed; then
                echo "😀 requirements already installed"
            else
                ask_install_requirements
            fi
        fi
    else
        ask_create_venv
    fi
  else
    echo "😀 you should run this script via 'source venv.sh'"
  fi
}

activate_venv
