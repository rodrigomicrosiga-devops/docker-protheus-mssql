FROM mcr.microsoft.com/mssql/server:2025-latest

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