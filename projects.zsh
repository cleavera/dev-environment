function projects() {
  cd $(gitlist ~/git | sort | fzf --tac) 
}
