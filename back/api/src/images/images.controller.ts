import {
  Controller,
  Delete,
  Get,
  Post,
  Req,
  Res,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { FileInterceptor } from '@nestjs/platform-express';
import * as sharp from 'sharp';
import { ImagesService } from './images.service';
@Controller('images')
export class ImagesController {
  constructor(private readonly ImagesService: ImagesService) {}
  @Get(':id')
  async getImagesByUserId(@Req() request: Request, @Res() res: Response) {
    const images = await this.ImagesService.findOneByUserId(request.params.id);
    console.log(images.length);

    if (images.length === 0) {
      return res.status(401).send('no images Found');
    }
    return res.send(images);
  }
  @Post('')
  @UseInterceptors(FileInterceptor('photo'))
  async uploadImage(@UploadedFile() file, @Req() request: Request) {
    console.log(file);
    const compressedImage: Buffer = await sharp(file.buffer)
      .resize(500, 500)
      .toBuffer();
    const insertImage = await this.ImagesService.insertImage(
      request.body.userId,
      file.originalname,
      compressedImage,
      new Date(),
    );
    return insertImage;
  }
  @Delete(':imageId')
  async deleteImagesById(@Req() request: Request, @Res() res: Response) {
    const imageDeleted = await this.ImagesService.deleteImage(
      request.params.imageId,
    );
    return res.send(imageDeleted);
  }
}
