import {
  Controller,
  Delete,
  Get,
  Post,
  Req,
  Res,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { FileInterceptor } from '@nestjs/platform-express';
import * as sharp from 'sharp';
import { ImagesService } from './images.service';
import { JwtAuthGuard } from 'src/auths/jwt-auths.guard';
@Controller('images')
export class ImagesController {
  constructor(private readonly ImagesService: ImagesService) {}

  /* This is the function that is called when the user wants to see a specific image that they have
      uploaded. */
  @UseGuards(JwtAuthGuard)
  @Get('one/:imageId')
  async getImagesById(@Req() request, @Res() res: Response) {
    const images = await this.ImagesService.findOneById(
      request.user.userId,
      request.params.imageId,
    );
    if (!images) {
      return res.status(401).send('no images Found');
    }
    return res.send(images);
  }
  /* This is the function that is called when the user wants to see all the images that they have
      uploaded. */
  @UseGuards(JwtAuthGuard)
  @Get('all')
  async getImagesByUserId(@Req() request, @Res() res: Response) {
    const images = await this.ImagesService.findOneByUserId(
      request.user.userId,
    );
    if (images.length === 0) {
      return res.status(401).send('no images Found');
    }
    return res.send(images);
  }
  @UseGuards(JwtAuthGuard)
  @Get('allIds')
  async getImagesByUserIdByIds(@Req() request, @Res() res: Response) {
    const images = await this.ImagesService.findOneByUserIdOnlyIds(
      request.user.userId,
    );
    if (images.length === 0) {
      return res.status(401).send('no images Found');
    }
    return res.send(images);
  }
  /* This is the function that is called when the user uploads an image. */
  @UseGuards(JwtAuthGuard)
  @Post('add')
  @UseInterceptors(FileInterceptor('photo')) //Name of the key of the image file
  async uploadImage(@UploadedFile() file, @Req() request) {
    const compressedImage: Buffer = await sharp(file.buffer)
      .resize(500, 500)
      .toBuffer();
    const insertImage = await this.ImagesService.insertImage(
      request.user.userId,
      request.body.name,
      compressedImage,
      new Date(),
    );
    return insertImage;
  }
  /* This is the function that is called when the user deletes an image. */
  @UseGuards(JwtAuthGuard)
  @Delete('one/:imageId')
  async deleteImagesById(@Req() request, @Res() res: Response) {
    const imageDeleted = await this.ImagesService.deleteImage(
      request.user.userId,
      request.params.imageId,
    );
    return res.send(imageDeleted);
  }
}
