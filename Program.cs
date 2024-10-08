var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.WebHost.UseKestrel(options =>
{
    //HTTP
    options.ListenAnyIP(8080);

    //HTTPS
    //options.ListenAnyIP(8081, listenOptions =>
    //{
    //    var certificatePath = "C:\\Users\\DELL\\source\\repos\\DockerWebApiSampleApp\\your-certificate.pfx";
    //    var certificatePassword = "your-certificate-password";
    //    listenOptions.UseHttps(certificatePath, certificatePassword);
    //});
});
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
