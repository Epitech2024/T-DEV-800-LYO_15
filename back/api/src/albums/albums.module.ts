import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ImagesModule } from 'src/images/images.module';
import { ImagesService } from 'src/images/images.service';
import { AlbumsController } from './albums.controller';
import { AlbumSchema } from './albums.model';
import { AlbumsService } from './albums.service';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: 'Album', schema: AlbumSchema }]),
    ImagesModule,
  ],
  providers: [AlbumsService],
  exports: [AlbumsService],
  controllers: [AlbumsController],
})
export class AlbumsModule {}
