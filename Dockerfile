# Base image çekilebilmesi için repo IP'si değiştirildi : 
FROM MY_REPO/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Base image çekilebilmesi için repo IP'si değiştirildi : 
FROM MY_REPO/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["CloudApi.csproj", "."]

# nuget.config dosyası projeye eklenip, dockerfile içerisindede kopyalanması sağlandı
COPY ["nuget.config",""]

RUN dotnet restore "./CloudApi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "CloudApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CloudApi.csproj" -c Release -o /app/publish 

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CloudApi.dll"]
