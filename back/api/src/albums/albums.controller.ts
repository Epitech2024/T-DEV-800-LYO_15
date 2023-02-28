import { Controller, Get, Req, Res, Post, Delete } from '@nestjs/common';
import { Request, Response } from 'express';
import { ImagesService } from 'src/images/images.service';
import { AlbumsService } from './albums.service';
@Controller('albums')
export class AlbumsController {
  constructor(
    private readonly albumsService: AlbumsService,
    private readonly imagesService: ImagesService,
  ) {}
  @Get(':id')
  async getalbumsByUserId(@Req() request: Request, @Res() res: Response) {
    const albums = await this.albumsService.findOneById(request.params.id);
    if (albums.length === 0) {
      return res.status(401).send('no albums Found');
    } else {
      return res.send(albums);
    }
  }
  @Post('')
  async createAlbum(@Req() request: Request, @Res() res: Response) {
    const result = await this.albumsService.createAlbum(
      request.body.userId,
      request.body.name,
      [request.body.img],
      new Date(),
    );
    return res.send(result);
  }
  @Post('rename')
  async renameAlbum(@Req() request: Request, @Res() res: Response) {
    const result = await this.albumsService.renameAlbum(
      request.body.id,
      request.body.name,
    );
    return res.send(result);
  }
  @Post('add')
  async addImageToAlbum(@Req() request: Request, @Res() res: Response) {
    const result = await this.albumsService.addImageToAlbum(
      request.body.id,
      request.body.img,
    );
    return res.send(result);
  }
  @Post('remove')
  async removeImageToAlbum(@Req() request: Request, @Res() res: Response) {
    const result = await this.albumsService.removeImageFromAlbum(
      request.body.id,
      request.body.img,
    );
    return res.send(result);
  }
  @Delete('')
  async deleteAlbum(@Req() request: Request, @Res() res: Response) {
    const result = await this.albumsService.deleteAlbum(request.body.id);
    if (result) {
      res.send('deleted');
    } else {
      res.send('does not exist');
    }
  }
}
