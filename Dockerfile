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

# mssql-tools18 já vem na imagem base -- checa se o motor está de fato
# aceitando conexões, não só se o processo está de pé.
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -Q "SELECT 1" -C -No || exit 1

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]