


FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# # Copy project files
# COPY DbChatPro.Core/DbChatPro.Core.csproj DbChatPro.Core/
# COPY DBChatPro.UI/DBChatPro.UI.csproj DBChatPro.UI/

# # Restore
# RUN dotnet restore DBChatPro.UI/DBChatPro.UI.csproj

# Copy project files - note the exact casing
COPY ["DBChatPro.UI/DBChatPro.UI.csproj", "DBChatPro.UI/"]
COPY ["DbChatPro.Core/DbChatPro.Core.csproj", "DbChatPro.Core/"]

# Restore dependencies
RUN dotnet restore "DBChatPro.UI/DBChatPro.UI.csproj"

# Copy all source code
COPY . .
# Copy everything else
COPY DbChatPro.Core/ DbChatPro.Core/
COPY DBChatPro.UI/ DBChatPro.UI/

# Build
WORKDIR /src/DBChatPro.UI
RUN dotnet build DBChatPro.UI.csproj -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish DBChatPro.UI.csproj -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DBChatPro.UI.dll"]

# # Use the official .NET 8 ASP.NET runtime image as the base for the final stage
# FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
# WORKDIR /app
# EXPOSE 5000

# # Use the official .NET 8 SDK image for building
# FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
# ARG BUILD_CONFIGURATION=Release
# WORKDIR /src
# # Copy solution and all projects
# # COPY *.sln ./
# # COPY DBChatPro.UI/*.csproj ./DBChatPro.UI/
# # COPY DbChatPro.Core/*.csproj ./DbChatPro.Core/
# # COPY DbChatPro.MCPServer/*.csproj ./DbChatPro.MCPServer/
# # Copy everything to /src
# COPY . ./
# # WORKDIR /src

# # Restore dependencies
# RUN dotnet restore

# # Copy all source code
# COPY . ./

# WORKDIR /src/DBChatPro.UI

# # Publish the application
# RUN dotnet publish DBChatPro.UI.csproj -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# # Final stage: copy published app
# FROM base AS final
# WORKDIR /app
# COPY --from=build /app/publish .

# # Environment variables for ASP.NET
# ENV ASPNETCORE_URLS=http://+:5000
# ENV ASPNETCORE_ENVIRONMENT=Production

# ENTRYPOINT ["dotnet", "DBChatPro.UI.dll"]



# FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
# WORKDIR /app
# EXPOSE 5000

# FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
# ARG BUILD_CONFIGURATION=Release
# WORKDIR /src

# # Copy csproj
# COPY DBChatPro.UI/*.csproj ./DBChatPro.UI/
# COPY DbChatPro.Core/*.csproj ./DbChatPro.Core/

# # Force correct AI packages (fixes the MissingMethodException)
# RUN dotnet add DBChatPro.UI/DBChatPro.UI.csproj package Microsoft.Extensions.AI --version 9.6.0 && \
#     dotnet add DBChatPro.UI/DBChatPro.UI.csproj package Microsoft.Extensions.AI.Abstractions --version 9.6.0 && \
#     dotnet add DBChatPro.UI/DBChatPro.UI.csproj package Microsoft.Extensions.AI.Ollama --version 9.6.0 && \
#     dotnet remove DBChatPro.UI/DBChatPro.UI.csproj package ModelContextProtocol || true

# RUN dotnet restore DBChatPro.UI/DBChatPro.UI.csproj --locked-mode

# # Copy source
# COPY DBChatPro.UI/ ./DBChatPro.UI/
# COPY DbChatPro.Core/ ./DbChatPro.Core/

# WORKDIR /src/DBChatPro.UI
# RUN dotnet publish DBChatPro.UI.csproj -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false --no-restore

# # Final stage
# FROM base AS final
# WORKDIR /app
# COPY --from=build /app/publish .

# # Critical for Blazor/MudBlazor in Docker
# ENV ASPNETCORE_URLS=http://+:5000
# ENV ASPNETCORE_ENVIRONMENT=Production   
# # ← Change to Development only if you mount volumes for hot reload

# ENTRYPOINT ["dotnet", "DBChatPro.UI.dll"]
# # ------------------- Base runtime image -------------------
# FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
# WORKDIR /app

# # Match the port you really use in docker-compose (5000)
# EXPOSE 5000

# # ------------------- Build stage -------------------
# FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
# ARG BUILD_CONFIGURATION=Release
# WORKDIR /src

# # Copy csproj files
# COPY DBChatPro.UI/*.csproj ./DBChatPro.UI/
# COPY DbChatPro.Core/*.csproj ./DbChatPro.Core/

# # ────── THIS IS THE FIX ──────
# # Force correct stable 9.6.0 versions and remove the problematic package
# RUN dotnet add DBChatPro.UI/DBChatPro.UI.csproj package Microsoft.Extensions.AI --version 9.6.0 && \
#     dotnet add DBChatPro.UI/DBChatPro.UI.csproj package Microsoft.Extensions.AI.Abstractions --version 9.6.0 && \
#     dotnet add DBChatPro.UI/DBChatPro.UI.csproj package Microsoft.Extensions.AI.OpenAI --version 9.6.0 && \
#     dotnet add DBChatPro.UI/DBChatPro.UI.csproj package Microsoft.Extensions.AI.Ollama --version 9.6.0 && \
#     dotnet add DBChatPro.UI/DBChatPro.UI.csproj package Microsoft.Extensions.AI.AzureAIInference --version 9.6.0 && \
#     dotnet remove DBChatPro.UI/DBChatPro.UI.csproj package ModelContextProtocol || true

# # Normal restore (now with correct locked versions)
# RUN dotnet restore DBChatPro.UI/DBChatPro.UI.csproj --locked-mode

# # Copy source code
# COPY DBChatPro.UI/ ./DBChatPro.UI/
# COPY DbChatPro.Core/ ./DbChatPro.Core/

# # Build & publish
# WORKDIR /src/DBChatPro.UI
# RUN dotnet publish DBChatPro.UI.csproj -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false --no-restore

# # ------------------- Final image -------------------
# FROM base AS final
# WORKDIR /app
# COPY --from=build /app/publish .

# ENV ASPNETCORE_URLS=http://+:5000

# ENTRYPOINT ["dotnet", "DBChatPro.UI.dll"]





# FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
# WORKDIR /app
# EXPOSE 8080
# EXPOSE 8081

# FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
# ARG BUILD_CONFIGURATION=Release
# WORKDIR /src

# # Copy project files
# COPY DbChatPro.Core/DbChatPro.Core.csproj DbChatPro.Core/
# COPY DBChatPro.UI/DBChatPro.UI.csproj DBChatPro.UI/

# # Restore
# RUN dotnet restore DBChatPro.UI/DBChatPro.UI.csproj

# # Copy everything else
# COPY DbChatPro.Core/ DbChatPro.Core/
# COPY DBChatPro.UI/ DBChatPro.UI/

# # Build
# WORKDIR /src/DBChatPro.UI
# RUN dotnet build DBChatPro.UI.csproj -c $BUILD_CONFIGURATION -o /app/build

# FROM build AS publish
# ARG BUILD_CONFIGURATION=Release
# RUN dotnet publish DBChatPro.UI.csproj -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# FROM base AS final
# WORKDIR /app
# COPY --from=publish /app/publish .
# ENTRYPOINT ["dotnet", "DBChatPro.UI.dll"]