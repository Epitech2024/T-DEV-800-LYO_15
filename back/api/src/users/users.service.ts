import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

import { User } from './users.model';

@Injectable()
export class UsersService {
  private users: User[] = [];

  constructor(@InjectModel('User') private readonly userModel: Model<User>) {}

  async insertUser(username: string, password: string) {
    const checkUser = await this.userModel.findOne({ username: username });


    if (checkUser) {
      return 'username already exists.';
    } else {
      const newUser = new this.userModel({
        username,
        password,
      });

      const result = await newUser.save();
      return result.id as string;
    }
  }

  async update(id: string, username: string, password: string) {
    return await this.userModel.findOneAndUpdate(
      { id: id },
      {
        username: username,
        password: password,
      },
    );
  }

  async delete(id: string) {
    return await this.userModel.deleteOne({ id: id });
  }

  async findOneById(id: string): Promise<User> {
    return await this.userModel.findById(id);
  }

  async findOne(username: string): Promise<User | undefined> {
    return await this.userModel.findOne({ username: username });
  }
}
