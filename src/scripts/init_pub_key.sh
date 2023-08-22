get_or_init_pub_key() {
  echo "开始生成ssh 的pubkey"
  # && echo "文件存在" || echo "文件不存在"
  if [ ! -f ~/.ssh/id_rsa.pub ]; then
    ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa <<< y
  fi
  echo "ssh 的 pub key："
  cat ~/.ssh/id_rsa.pub
}

get_or_init_pub_key
