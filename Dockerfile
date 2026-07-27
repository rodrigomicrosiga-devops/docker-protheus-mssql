# Pinado em vez de :2025-latest -- tag mutável, o build silenciosamente puxaria uma
# imagem base diferente a cada nova Cumulative Update lançada pela Microsoft. CU7 é
# o que :2025-latest resolvia no momento da fixação (mesmo digest, conferido via MCR).
FROM mcr.microsoft.com/mssql/server:2025-CU7-ubuntu-24.04

USER root

WORKDIR /opt/mssql/init

# Copia o script SQL e o entrypoint inteligente para dentro da imagem
COPY init-protheus.sql .
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Garante permissões de execução para os scripts
RUN chmod +x /usr/local/bin/entrypoint.sh && \
    chown -R mssql:root /opt/mssql/init

# Retorna para o usuário padrão do SQL Server para execução segura
USER mssql

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]