import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Album } from './albums.model';

@Injectable()
export class AlbumsService {
  constructor(
    @InjectModel('Album') private readonly AlbumModel: Model<Album>,
  ) {}

  async createAlbum(userId: string, name: string, imgs: string[], date: Date) {
    const newAlbum = new this.AlbumModel({ userId, name, imgs, date });
    console.log(newAlbum);

    const result = await newAlbum.save();
    return result.id as string;
  }

  async renameAlbum(id: string, name: string) {
    const Album = await this.AlbumModel.findById(id);
    Album.name = name;
    const result = await Album.save();
    return result.id as string;
  }

  async addImageToAlbum(id: string, img: string) {
    const Album = await this.AlbumModel.findById(id);
    Album.imgs.push(img);
    const result = await Album.save();
    return result.id as string;
  }

  async removeImageFromAlbum(id: string, img: string) {
    const Album = await this.AlbumModel.findById(id);
    const imageId = Album.imgs.findIndex((v) => v === img);
    if (imageId >= 0) {
      Album.imgs.splice(imageId, 1);
    }
    console.log(Album.imgs);
    const result = await Album.save();
    return result.id as string;
  }

  async deleteAlbum(id: string) {
    const Album = await this.AlbumModel.findByIdAndDelete(id);
    console.log(Album);

    return Album;
  }

  async findOneById(userId: string): Promise<
    (Album & {
      _id: Types.ObjectId;
    })[]
  > {
    const res = await this.AlbumModel.find({ userId });
    return res;
  }
}
