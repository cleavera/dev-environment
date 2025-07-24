function projects() {
  local base_path="$HOME/git"
  local -a git_projects

  while IFS= read -r -d $'\0' project_path; do
    git_projects+=("$project_path")
  done < <(find "$base_path" -type f -name ".git/index" -print0 | xargs -0 -I {} dirname "{}")

  if [ ${#git_projects[@]} -eq 0 ]; then
    echo "No Git projects found under $base_path."
    return 1
  fi

  cd $(gitlist ~/git | sort | fzf --tac) 
}

