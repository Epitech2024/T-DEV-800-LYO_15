import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Image } from './images.model';

@Injectable()
export class ImagesService {
  constructor(
    @InjectModel('Image') private readonly imageModel: Model<Image>,
  ) {}

  async insertImage(userId: string, name: string, img: Buffer, date: Date) {
    const newImage = new this.imageModel({ userId, name, img, date });
    const result = await newImage.save();
    return result.id as string;
  } //papa44

  async findOneByUserId(userId: string): Promise<
    (Image & {
      _id: Types.ObjectId;
    })[]
  > {
    const res = await this.imageModel.find({ userId });
    return res;
  }

  async findOneById(id: string): Promise<Image> {
    const res = await this.imageModel.findById(id);
    return res;
  }
}
