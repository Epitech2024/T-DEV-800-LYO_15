import {
  Controller,
  Get,
  Req,
  Res,
  Post,
  Delete,
  UseGuards,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { JwtAuthGuard } from 'src/auths/jwt-auths.guard';
import { AlbumsService } from './albums.service';
@Controller('albums')
export class AlbumsController {
  constructor(private readonly albumsService: AlbumsService) {}
  /* This is a get request to get all the albums of a user with images. */
  @UseGuards(JwtAuthGuard)
  @Get('allImages')
  async getalbumsByUserIdWithImages(@Req() request, @Res() res: Response) {
    const albums = await this.albumsService.findOneByUserIdWithImages(
      request.user.userId,
    );
    if (Object.keys(albums).length === 0) {
      return res.status(401).send('no albums Found');
    } else {
      console.log(albums);
      return res.send(albums);
    }
  }
  /* This is a get request to get all the albums of a user. */
  @UseGuards(JwtAuthGuard)
  @Get('all')
  async getalbumsByUserId(@Req() request, @Res() res: Response) {
    const albums = await this.albumsService.findOneByUserId(
      request.user.userId,
    );
    if (albums.length === 0) {
      return res.status(401).send('no albums Found');
    } else {
      return res.send(albums);
    }
  }
  /* This is a post request to create an album. */
  @UseGuards(JwtAuthGuard)
  @Post('new')
  async createAlbum(@Req() request, @Res() res: Response) {
    //imageId:63fe1f17f3d7a01f38fa64b0
    const convertStringToArray = (idString: string) =>
      idString.substring(1, idString.length - 1).split(',');

    const result = await this.albumsService.createAlbum(
      request.user.userId,
      request.body.name,
      convertStringToArray(request.body.img),
      new Date(),
    );
    if (result.includes('album')) {
      res.status(403).send(false);
    }
    return res.status(201).send(true);
  }
  /* Renaming an album by its id. */
  @UseGuards(JwtAuthGuard)
  @Post('rename')
  async renameAlbum(@Req() request, @Res() res: Response) {
    //albumId:640709ea8e305d85d21150ff
    const result = await this.albumsService.renameAlbum(
      request.user.userId,
      request.body.name,
    );
    return res.send(result);
  }
  /* Adding an image to an album. */
  @UseGuards(JwtAuthGuard)
  @Post('add')
  async addImageToAlbum(@Req() request, @Res() res: Response) {
    const result = await this.albumsService.addImageToAlbum(
      request.user.userId,
      request.body.img,
    );
    return res.send(result);
  }
  /* Removing an image from an album. */
  @UseGuards(JwtAuthGuard)
  @Post('remove')
  async removeImageToAlbum(@Req() request, @Res() res: Response) {
    const result = await this.albumsService.removeImageFromAlbum(
      request.user.userId,
      request.body.imgId,
    );
    return res.send(result);
  }
  /* Deleting an album by its id. */
  @UseGuards(JwtAuthGuard)
  @Delete(':albumId')
  async deleteAlbum(@Req() request: Request, @Res() res: Response) {
    const result = await this.albumsService.deleteAlbum(request.params.albumId);
    if (result) {
      res.send('deleted');
    } else {
      res.send('does not exist');
    }
  }
}
