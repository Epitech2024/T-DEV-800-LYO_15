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
  /* This is the function that is called when the user wants to see a specific image that they have
uploaded. */
  @Get('one/:imageId')
  async getImagesById(@Req() request: Request, @Res() res: Response) {
    const images = await this.ImagesService.findOneById(request.params.imageId);
    if (!images) {
      return res.status(401).send('no images Found');
    }
    return res.send(images);
  }
  /* This is the function that is called when the user wants to see all the images that they have
uploaded. */
  @Get(':userId')
  async getImagesByUserId(@Req() request: Request, @Res() res: Response) {
    const images = await this.ImagesService.findOneByUserId(
      request.params.userId,
    );
    console.log(images.length);

    if (images.length === 0) {
      return res.status(401).send('no images Found');
    }
    return res.send(images);
  }
  /* This is the function that is called when the user uploads an image. */
  @Post('')
  @UseInterceptors(FileInterceptor('photo')) //Name of the key of the image file
  async uploadImage(@UploadedFile() file, @Req() request: Request) {
    const compressedImage: Buffer = await sharp(file.buffer)
      .resize(500, 500)
      .toBuffer();
    const insertImage = await this.ImagesService.insertImage(
      request.body.userId,
      request.body.name,
      compressedImage,
      new Date(),
    );
    return insertImage;
  }
  /* This is the function that is called when the user deletes an image. */
  @Delete(':imageId')
  async deleteImagesById(@Req() request: Request, @Res() res: Response) {
    const imageDeleted = await this.ImagesService.deleteImage(
      request.params.imageId,
    );
    return res.send(imageDeleted);
  }
}
