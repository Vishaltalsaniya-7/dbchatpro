FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copy project files (paths relative to build context which is the root folder)
COPY ["DBChatPro.UI/DBChatPro.UI.csproj", "DBChatPro.UI/"]
COPY ["DbChatPro.Core/DbChatPro.Core.csproj", "DbChatPro.Core/"]

# Restore dependencies
RUN dotnet restore "DBChatPro.UI/DBChatPro.UI.csproj"

# Copy all source code
COPY ["DBChatPro.UI/", "DBChatPro.UI/"]
COPY ["DbChatPro.Core/", "DbChatPro.Core/"]

# Build
WORKDIR "/src/DBChatPro.UI"
RUN dotnet build "DBChatPro.UI.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "DBChatPro.UI.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DBChatPro.UI.dll"]


# FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
# USER app
# WORKDIR /app
# EXPOSE 8080
# EXPOSE 8081

# FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
# ARG BUILD_CONFIGURATION=Release
# WORKDIR /src
# COPY ["DBChatPro.csproj", "DBChatPro/"]
# RUN dotnet restore "DBChatPro/DBChatPro.csproj"
# WORKDIR "/src/DBChatPro"
# COPY . .
# RUN dotnet build "./DBChatPro.csproj" -c $BUILD_CONFIGURATION -o /app/build

# FROM build AS publish
# ARG BUILD_CONFIGURATION=Release
# RUN dotnet publish "./DBChatPro.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# FROM base AS final
# WORKDIR /app
# COPY --from=publish /app/publish .
# ENTRYPOINT ["dotnet", "DBChatPro.dll"]