import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UsersModule } from './users/users.module';
import { MongooseModule } from '@nestjs/mongoose';
import { AuthsModule } from './auths/auths.module';
import { ImagesModule } from './images/images.module';
import { AlbumsModule } from './albums/albums.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    UsersModule,
    MongooseModule.forRoot(
      'mongodb+srv://cls_user:admin@cluster0.nwxifnb.mongodb.net/pictsmanager?retryWrites=true&w=majority',
    ),
    AuthsModule,
    ImagesModule,
    AlbumsModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
