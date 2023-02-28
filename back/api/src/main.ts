import { NestFactory } from '@nestjs/core';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';
import { load } from 'ts-dotenv';
import { exec } from 'child_process';
import { hostname } from 'os';

const env = load({
  API_SERVER_PORT: Number,
});

var IP = '';

// exec('./getIp.bat', (err, stdout, stderr) => {
//   if (err) {
//     //some err occurred
//     console.error(err);
//   } else {
//     // the *entire* stdout and stderr (buffered)
//     IP = stdout;
//     console.log(`stdout: ${stdout}`);
//     console.log(`stderr: ${stderr}`);
//   }
// });

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  //API Swagger
  const config = new DocumentBuilder()
    .setTitle('CASH_MANAGER')
    .setDescription('The API description')
    .setVersion('1.0')
    .addTag('cash')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  IP.replace(/\s+\n|\r[&\/\\#,+()$~%'":*?<>{}]/g, '').trim();
  IP.replace(/\r/g, '').replace(/\n/g, '');

  console.log('|' + IP + '|');

  //console.log("[CASH_MANAGER] API server listening at http://localhost:" + env.API_SERVER_PORT)
  //console.log("[CASH_MANAGER] API Documentation Swagger at http://localhost:" + env.API_SERVER_PORT + "/api")

  console.log(
    '[CASH_MANAGER] API server listening at ' + IP + ':' + env.API_SERVER_PORT,
  );
  console.log(
    '[CASH_MANAGER] API Documentation Swagger at ' +
      IP +
      ':' +
      env.API_SERVER_PORT +
      '/api',
  );

  await app.listen(env.API_SERVER_PORT);
}
bootstrap();
