#!/bin/bash

# Função que criar uma regra de firewall
create_firewall_rule() {
    cadeia=""
    alvo=""
    filtro_endereco_origem=""
    filtro_endereco_destino=""
    filtro_protocolo=""
    filtro_porta_origem=""
    filtro_porta_destino=""
    filtro_mac=""
    filtro_estado=""
    filtro_interface_origem=""
    filtro_interface_saida=""

    #CADEIA DA REGRA
    opcao=$(zenity --list --title="Escolha a CADEIA para regra" --text="Escolha a CADEIA para regra:" --column="Opção" --column="Valor" "1" "Entrada" "2" "Saída" "3" "Encaminhamento" "4" "Voltar")
    case $opcao in
        1) cadeia="INPUT";;
        2) cadeia="OUTPUT";;
        3) cadeia="FORWARD";;
        4) main_firewall_menu;;
        *) zenity --info --text="Opção inválida!";;
    esac

    #ALVO DA REGRA
    opcao=$(zenity --list --title="Escolha o ALVO da regra" --text="Escolha o ALVO da regra:" --column="Opção" --column="Valor" "1" "Aceitar" "2" "Rejeitar" "3" "Descartar" "4" "Voltar")
    case $opcao in
        1) alvo="ACCEPT";;
        2) alvo="REJECT";;
        3) alvo="DROP";;
        4) main_firewall_menu;;
        *) zenity --info --text="Opção inválida!";;
    esac

    # ESCOLHA DOS FILTROS
    while true; do
        opcao=$(zenity --list --title="Escolha o FILTRO para a regra" --text="Escolha o FILTRO para a regra:" --column="Opção" --column="Valor" "1" "Endereço de Origem" "2" "Endereço de Destino" "3" "Protocolo" "4" "Porta de Origem" "5" "Porta de Destino" "6" "Endereço MAC" "7" "Estado" "8" "Interface de Entrada" "9" "Interface de Saída" "10" "Enviar" "0" "Cancelar")
        case $opcao in
            1) endereco_origem=$(zenity --entry --title="Endereço de Origem" --text="Digite o número do IP ex (10.99.0.1):")
               filtro_endereco_origem="-s $endereco_origem";;
            2) endereco_destino=$(zenity --entry --title="Endereço de Destino" --text="Digite o número do IP ex (10.99.0.1):")
               filtro_endereco_destino="-d $endereco_destino";;
            3) nome_protocolo=$(zenity --entry --title="Protocolo" --text="Digite a sigla do protocolo ex (tcp):")
               filtro_protocolo="-p $nome_protocolo";;
            4) porta_origem=$(zenity --entry --title="Porta de Origem" --text="Digite o número da porta ex (80):")
               filtro_porta_origem="--sport $porta_origem";;
            5) porta_destino=$(zenity --entry --title="Porta de Destino" --text="Digite o número da porta ex (80):")
               filtro_porta_destino="--dport $porta_destino";;
            6) numero_mac=$(zenity --entry --title="Endereço MAC" --text="Digite o número de MAC\nex (00:0d:83:b1:c0:8e):")
               filtro_mac="-m mac --mac-source $numero_mac";;
            7) parametro=$(zenity --entry --title="Estado" --text="Digite o parâmetro ex (ESTABLISHED):")
               filtro_estado="-m state --state $parametro";;
            8) interface_origem=$(zenity --entry --title="Interface de Entrada" --text="Digite a interface de origem (eth1):")
               filtro_interface_origem="-i $interface_origem";;
            9) interface_saida=$(zenity --entry --title="Interface de Saída" --text="Digite a interface de destino (eth1):")
               filtro_interface_saida="-o $interface_saida";;
            10) break;;
            0) main_firewall_menu;;
            *) zenity --info --text="Opção inválida!";;
        esac
    done

    # CRIAR AS REGRAS UTILIZANDO AS VARÁVEIS
    sudo iptables -I $cadeia $filtro_endereco_origem $filtro_endereco_destino $filtro_protocolo $filtro_porta_origem $filtro_porta_destino $filtro_mac $filtro_estado $filtro_interface_origem $filtro_interface_saida -j $alvo

    # MOSTRANDO A REGRA AO USUÁRIO
    zenity --info --text="REGRA CRIADA:\n\niptables -I $cadeia $filtro_endereco_origem $filtro_endereco_destino $filtro_protocolo $filtro_porta_origem $filtro_porta_destino $filtro_mac $filtro_estado $filtro_interface_origem $filtro_interface_saida -j $alvo"

    # MENU DEPOIS DE CRIAR A REGRA
    main_firewall_menu
} 




# Função que configurar a política padrão
set_default_policy() {
    cadeia=""
    alvo=""
   
    #CADEIA DA REGRA
    opcao=$(zenity --list --title="Escolha a CADEIA para regra" --text="Escolha a CADEIA para regra:" --column="Opção" --column="Valor" "1" "Entrada" "2" "Saída" "3" "Encaminhamento" "4" "Voltar")
    case $opcao in
        1) cadeia="INPUT";;
        2) cadeia="OUTPUT";;
        3) cadeia="FORWARD";;
        4) main_firewall_menu;;
        *) zenity --info --text="Opção inválida!";;
    esac

    #ALVO DA REGRA
    opcao=$(zenity --list --title="Escolha o ALVO da regra" --text="Escolha o ALVO da regra:" --column="Opção" --column="Valor" "1" "Aceitar" "2" "Rejeitar" "3" "Descartar" "4" "Voltar")
    case $opcao in
        1) alvo="ACCEPT";;
        2) alvo="REJECT";;
        3) alvo="DROP";;
        4) main_firewall_menu;;
        *) zenity --info --text="Opção inválida!";;
    esac
   
    #CRIAR AS REGRAS UTILIZANDO AS VARÁVEIS
    sudo iptables -I $cadeia -j $alvo
   
    # MOSTRANDO A REGRA AO USUÁRIO
    zenity --info --text="REGRA CRIADA:\n\niptables -I $cadeia -j $alvo"
   
    # CHAMAR O MENU DEPOIS DE CRIAR A REGRA
    main_firewall_menu
}


# Função para listar todas as regras
list_all_rules() {
   iptables_output=$(sudo iptables -L)
    zenity --text-info --title="LISTA DAS REGRAS" --width=600 --height=400 --filename=<(echo -e "$iptables_output")
} 


# Função para deletar um  das regras
delete_firewall_rule() {

while true; do
        opcao=$(zenity --list --title="Escolha uma cadeia" --text="Escolha uma cadeia:" --column="Opção" --column="Cadeia" 1 'Entrada' 2 'Saída' 3 'Encaminhamento' 4 'Sair')
        case $opcao in
            1) cadeia="INPUT";;
            2) cadeia="OUTPUT";;
            3) cadeia="FORWARD";;
            4) main_firewall_menu;;
            *) zenity --info --text="Opção inválida!";;
        esac

        regras=$(sudo iptables -L $cadeia --line-numbers)
        indice=$(zenity --entry --title="Remover Regra" --text="Digite o número da regra que deseja remover:\n$regras")
       
        if [ -n "$indice" ]; then
            sudo iptables -D $cadeia $indice
            zenity --info --title="Regra Apagada" --text="Regra apagada com sucesso!"
        fi
    done

}


# Função para apagar todas as regras
delete_all_rules() {
    sudo iptables -F
    zenity --info --title="Regras Apagadas" --text="TODAS AS REGRAS DE FIREWALL FORAM APAGADAS COM SUCESSO!"
}


# Função para salvar as regras em um arquivo
save_rules_to_file() {
     nome=$(zenity --entry --title="Salvar Regras do Firewall" --text="Nome do arquivo (ex: firewall.txt):" --entry-text="firewall.txt")
    if [ -n "$nome" ]; then
        sudo iptables-save > "$nome"
        zenity --info --title="Arquivo Salvo" --text="Arquivo salvo com sucesso!"
    fi
}


# Função para restaurar as regras de um arquivo
restore_rules_from_file() {
    lista=$(ls)
    regras=$(zenity --entry --title="Restaurar Regras do Firewall" --text="Arquivos disponíveis:\n\n$lista" --entry-text="")
   
    if [ -n "$regras" ]; then
        sudo iptables-restore < "$regras"
        zenity --info --title="Regras Restauradas" --text="Regras restauradas com sucesso!"
    fi
}

# Função para mostrar informações dos participantes
show_participants_info() {
    zenity --info --title="PARTICIPANTES" --text="PARTICIPANTES:\n* Felipe Moreira \n* Eduardo Siqueira\n* Carlos Eduardo"

}

# Main menu function - Menu Main
main_firewall_menu() {
    while :
    do
        choice=$(zenity --list --title="Gerenciador de Firewall" \
            --column="" --column="Ação" \
            "Criar Regra de Firewall" "Criar uma nova regra de firewall" \
            "Configurar Política Padrão" "Configurar a política padrão do firewall" \
            "Apagar uma regra" "Apagar uma regra específica" \
            "Listar Todas as Regras" "Listar todas as regras do firewall" \
            "Apagar Todas as Regras" "Apagar todas as regras do firewall" \
            "Salvar Regras em Arquivo" "Salvar as regras em um arquivo" \
            "Restaurar Regras de Arquivo" "Restaurar as regras do firewall de um arquivo" \
            "Informações dos Participantes" "Informações sobre os participantes" \
            "Sair" "Sair do gerenciador de firewall")

        case "$choice" in
            "Criar Regra de Firewall")
                create_firewall_rule
                ;;
            "Configurar Política Padrão")
                set_default_policy
                ;;
            "Apagar uma regra")
                delete_firewall_rule
                ;;
            "Listar Todas as Regras")
                list_all_rules
                ;;
            "Apagar Todas as Regras")
                delete_all_rules
                ;;
            "Salvar Regras em Arquivo")
                save_rules_to_file
                ;;
            "Restaurar Regras de Arquivo")
                restore_rules_from_file
                ;;
            "Informações dos Participantes")
                show_participants_info
                ;;
            "Sair")
                exit 0
                ;;
            *)
                zenity --error --text="Escolha uma ação válida."
                ;;
        esac
    done
}

# Start the main menu
main_firewall_menu



