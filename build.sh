for dir in infrastructure/environments/*; do
  if [ -d "$dir" ]; then
    echo "Planning $dir"
    terraform plan -chdir="$dir"
  fi
done