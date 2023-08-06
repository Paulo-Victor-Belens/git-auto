#!/bin/bash

#-----Instalação git-auto-------
INSTALATION_DIR="$HOME/.git-auto"

if [ ! -d "$INSTALATION_DIR" ]; then
  # Se o diretório não existe, cria o diretório e copia o script para o diretório de instalação
  chmod +x git-auto.sh
  mkdir -p "$INSTALATION_DIR" && \
    cp -p ./git-auto.sh "$INSTALATION_DIR"
fi

SHELL_NAME=${SHELL##*\/}
case "${SHELL_NAME}" in
  zsh) SHELL_CONFIG="$HOME/.zshrc";;
  bash) SHELL_CONFIG="$HOME/.bashrc";;
  csh) SHELL_CONFIG="$HOME/.cshrc";;
  tcsh) SHELL_CONFIG="$HOME/.tcshrc";;
  *) SHELL_CONFIG="not-found";;
esac

# Verifica se o alias git-auto já está presente no arquivo de configuração do shell
ALIAS_EXISTS=$(grep -c "alias git-auto='$HOME/.git-auto/git-auto.sh'" $SHELL_CONFIG)
if [ "$ALIAS_EXISTS" -eq 0 ]; then
  # Se o alias não existe, adiciona ao arquivo de configuração
  ALIAS_COMMAND="alias git-auto='$HOME/.git-auto/git-auto.sh'"
  echo -e $ALIAS_COMMAND >> $SHELL_CONFIG
fi

source $SHELL_CONFIG

# Solicita a opção ao usuário
echo "Escolha uma opção:
1. Criar uma nova Branch e dar push Origin com nome personalizado
2. Add, Commit e Push
3. Fechar o git-auto
"
read opcao

# Verifica se a opção é válida
while [ "$opcao" -ne 1 -a "$opcao" -ne 2 -a "$opcao" -ne 3 ] || [ "${#opcao}" -gt 1 ]; do
  echo "Opção inválida. Por favor, escolha uma opção entre 1, 2 e 3."
  echo "
1. Criar uma nova Branch e dar push Origin com nome personalizado
2. Add, Commit e Push
3. Fechar o git-auto
"
  read opcao
done

# Cria uma nova branch e envia para o repositório remoto se a opção for 1
if [ "$opcao" -eq 1 ]; then
  echo "Digite o nome da branch: "
  read branch
  git checkout -b $branch
  git add .
  # Solicita a mensagem do commit ao usuário
  echo "Digite a mensagem do commit: "
  read mensagem
  git commit -m "$mensagem"
  git push -u origin $branch
fi

# Adiciona, faz commit e envia para o repositório remoto se a opção for 2
if [ "$opcao" -eq 2 ]; then
  git add .
  # Solicita a mensagem do commit ao usuário
  echo "Digite a mensagem do commit: "
  read mensagem
  git commit -m "$mensagem"
  git push
fi

# Fecha o executável se a opção for 3
if [ "$opcao" -eq 3 ]; then
  exit
fi
