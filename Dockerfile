# Etapa 1: Build de la aplicación
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Establecer el directorio de trabajo en /app
WORKDIR /app

# Copiar los archivos de solución y de proyecto
COPY Tailspin.SpaceGame.Web.sln ./
COPY Tailspin.SpaceGame.Web/*.csproj Tailspin.SpaceGame.Web/

# Restaurar dependencias
RUN dotnet restore

# Copiar el resto del código fuente
COPY . .

# Compilar la aplicación en modo Release
RUN dotnet publish -c Release -o /app/out

# Etapa 2: Imagen ligera para ejecutar la aplicación
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

# Establecer el directorio de trabajo en /app
WORKDIR /app

# Copiar los binarios compilados desde la etapa de build
COPY --from=build /app/out ./

# Exponer el puerto en el que correrá la aplicación
EXPOSE 80
EXPOSE 443

# Comando de inicio
ENTRYPOINT ["dotnet", "Tailspin.SpaceGame.Web.dll"]

