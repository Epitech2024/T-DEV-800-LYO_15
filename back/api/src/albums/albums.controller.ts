import { Controller, Get, Req, Res, Post, Delete } from '@nestjs/common';
import { Request, Response } from 'express';
import { AlbumsService } from './albums.service';
@Controller('albums')
export class AlbumsController {
  constructor(private readonly albumsService: AlbumsService) {}
  /* This is a get request to get all the albums of a user with images. */
  @Get(':userId/images')
  async getalbumsByUserIdWithImages(
    @Req() request: Request,
    @Res() res: Response,
  ) {
    const albums = await this.albumsService.findOneByUserIdWithImages(
      request.params.userId,
    );
    if (Object.keys(albums).length === 0) {
      return res.status(401).send('no albums Found');
    } else {
      return res.send(albums);
    }
  }
  /* This is a get request to get all the albums of a user. */
  @Get(':userId')
  async getalbumsByUserId(@Req() request: Request, @Res() res: Response) {
    const albums = await this.albumsService.findOneByUserId(
      request.params.userId,
    );
    if (albums.length === 0) {
      return res.status(401).send('no albums Found');
    } else {
      return res.send(albums);
    }
  }
  /* This is a post request to create an album. */
  @Post('')
  async createAlbum(@Req() request: Request, @Res() res: Response) {
    //imageId:63fe1f17f3d7a01f38fa64b0
    const result = await this.albumsService.createAlbum(
      request.body.userId,
      request.body.name,
      [request.body.img],
      new Date(),
    );
    if (result.includes('album')) {
      res.status(403);
    }
    return res.send(result);
  }
  /* Renaming an album by its id. */
  @Post('rename')
  async renameAlbum(@Req() request: Request, @Res() res: Response) {
    //albumId:640709ea8e305d85d21150ff
    const result = await this.albumsService.renameAlbum(
      request.body.id,
      request.body.name,
    );
    return res.send(result);
  }
  /* Adding an image to an album. */
  @Post('add')
  async addImageToAlbum(@Req() request: Request, @Res() res: Response) {
    const result = await this.albumsService.addImageToAlbum(
      request.body.id,
      request.body.img,
    );
    return res.send(result);
  }
  /* Removing an image from an album. */
  @Post('remove')
  async removeImageToAlbum(@Req() request: Request, @Res() res: Response) {
    const result = await this.albumsService.removeImageFromAlbum(
      request.body.id,
      request.body.imgId,
    );
    return res.send(result);
  }
  /* Deleting an album by its id. */
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
