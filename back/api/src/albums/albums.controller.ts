import { Controller, Get, Req, Res, Post, Delete } from '@nestjs/common';
import { Request, Response } from 'express';
import { AlbumsService } from './albums.service';
@Controller('albums')
export class AlbumsController {
  constructor(private readonly albumsService: AlbumsService) {}
  @Get(':id')
  async getalbumsByUserIdWithImages(
    @Req() request: Request,
    @Res() res: Response,
  ) {
    const albums = await this.albumsService.findOneByUserIdWithImages(
      request.params.id,
    );
    if (Object.keys(albums).length === 0) {
      return res.status(401).send('no albums Found');
    } else {
      return res.send(albums);
    }
  }
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
  @Post('rename')
  async renameAlbum(@Req() request: Request, @Res() res: Response) {
    //albumId:640709ea8e305d85d21150ff
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
  @Delete(':id')
  async deleteAlbum(@Req() request: Request, @Res() res: Response) {
    const result = await this.albumsService.deleteAlbum(request.params.id);
    if (result) {
      res.send('deleted');
    } else {
      res.send('does not exist');
    }
  }
}
