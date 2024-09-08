##Use .net core SDK official image as a parent image
#FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
#WORKDIR /app
#
##Copy the project file and restore any dependencies (use .csproj for the project name)
#COPY *.csproj ./
#RUN dotnet restore
#
##Copy rest of the application code
#COPY . .
#
##Publish the application
#RUN dotnet publish -c Release -o out
#
##Build the runtime image
#FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
#WORKDIR /app
#COPY --from=build /app/out ./
#
##Expose the port of the application will run on
#EXPOSE 80
#
##Start the application
#ENTRYPOINT ["dotnet", "DockerWebApiSampleApp.dll"]
#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["DockerWebApiSampleApp.csproj", "."]
RUN dotnet restore "./DockerWebApiSampleApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "./DockerWebApiSampleApp.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./DockerWebApiSampleApp.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Copy the SSL certificate into the container
COPY your-certificate.pfx /root/.aspnet/https/your-certificate.pfx

# Set environment variables for the certificate path and password
ENV ASPNETCORE_Kestrel__Certificates__Default__Path=/root/.aspnet/https/your-certificate.pfx
ENV ASPNETCORE_Kestrel__Certificates__Default__KeyPassword=your-certificate-password

ENTRYPOINT ["dotnet", "DockerWebApiSampleApp.dll"]