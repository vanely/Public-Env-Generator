#!/bin/bash

# spellcheck source=./utils/helpers/validation.sh
# source ./utils/helpers/validation.sh
source "/${HOME}/engen/utils/helpers/validation.sh"

DIR_NAME="${1}"

function engen() {
  # reference to wear command is run from
  EXECUTION_DIR="$(pwd)"
  return_to_execution_dir() {
    # file search
    if [[ -d "${EXECUTION_DIR}" ]] ; then
      cd "${EXECUTION_DIR}"
    else
      cd "${HOME}"
    fi
  }

  # SIGINT fall back
  function leave_script() {
    cd "${EXECUTION_DIR}"
    kill $$
  }
  trap leave_script SIGINT

  # command help options
  if [[ "${DIR_NAME}" == "-h" ]] || [[ "${DIR_NAME}" == "--help" ]] ; then
    echo "Existing base directories are shown by name and will be the context for the engen command"
    echo "_________________________________________________________________________________________"
    echo
    echo "The '0' option will generate a directory tree"
    echo "of practice, projects, and challenges for various languages."
    echo
    echo "The '1' option will allow you to choose which programs you'd like to install"
    echo
    echo "The '2' option will allow you to cleanup(remove dirs, and installs)"
    echo
    echo "The '3' option will allow you to check the status of git repos, do a pull on them"
    echo "create repos remotely, or delete repos remotely"
    echo
    echo "The '4' option will"
    echo
    echo "The '5' option will"
    echo
  else
    arr=()
    # file search
    if [[ -f ~/.profile ]] ; then
      arr=($(grep "ROOT_ENV_DIR" ~/.profile))
    fi
    # remove 'export' keyword in array
    no_exports_arr=( "${arr[@]/export/}" )
    # flatten empty spaces out of array
    ENV_DIR_ARRAY=(${no_exports_arr[@]})
    # get array length
    ENV_DIR_ARRAY_LEN="${#ENV_DIR_ARRAY[@]}"
    # array of just ENV_DIR_NAMES
    ENV_VAR_NAME_ARRAY=()
    ENV_DIR_NAMES=()
    ENV_DIR_PATHS=()

    if [[ "${ENV_DIR_ARRAY_LEN}" -ge 1 ]] ; then
      for ENV_VAR in ${ENV_DIR_ARRAY[@]}
      do
        IFS="=" read -r -a touple <<< ${ENV_VAR}
        ENV_VAR_NAME_ARRAY+=("${touple[0]}")
        ENV_DIR_PATHS+=("${touple[1]}")
      done

      for DIR_VAR_NAME in ${ENV_VAR_NAME_ARRAY[@]}
      do
        IFS="_" read -r -a name <<< ${DIR_VAR_NAME}
        ENV_DIR_NAMES+=("${name[3]}")
      done

      echo "========================================================================================="
      echo "=============================== [--ENV DIRECTORIES--]===================================="
      echo "========================================================================================="
      echo
      echo "From the following list, select which env dir you'd like to access"
      echo
      # present list of existing dir trees.
      for (( i=0; i<"${ENV_DIR_ARRAY_LEN}"; i++ ))
      do
        echo "${i}: ${ENV_DIR_NAMES[i]}"
      done
      echo
      echo -n "> "
      read -r index

      # validate input
      while "true"
      do
        if [[ "$(input_is_number "${index}")" == "true" ]] ; then
          # derive base dir name and pass as arg. main.sh is now accepting it
          # echo "Current env: ${ENV_DIR_NAMES[${index}]}"
          echo
          cd "${HOME}/${ENV_DIR_NAMES[${index}]}"
          bash "${HOME}/engen/main.sh" "${ENV_DIR_NAMES[${index}]}"
          return_to_execution_dir
          break
        else
          echo
          echo "Input must be a number in the above list"
          echo
          echo -n "> "
          read -r index
        fi
      done
    else
      # file search use depth search instead
      bash "${HOME}/engen/main.sh"
      return_to_execution_dir
    fi
  fi
}

engen
