import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

import { User } from './users.model';

@Injectable()
export class UsersService {
  private users: User[] = [];

  constructor(@InjectModel('User') private readonly userModel: Model<User>) {}

  async insertUser(name: string, email: string, password: string, role: string) {
    const newUser = new this.userModel({
      name,
      email,
      password,
      role
    });
    const result = await newUser.save();
    return result.id as string;
  }

  async update(id: string, name: string, email: string, password: string) {
    const oldUser = await this.userModel.findOneAndUpdate(
      {id: id},
      {
          name: name,
          email: email,
          password: password
      });
  }

  async delete(id: string) {
    const res = await this.userModel.deleteOne({id: id});
    return res;
  }

  async findOneById(id: string): Promise<User> {
    const res = await this.userModel.findById(id);
    return res;
  }

  async findOne(name: string): Promise<User | undefined> {
    return this.users.find(user => user.name === name);
  }

  async findOneEmail(email: string): Promise<User | undefined> {
    return await this.userModel.findOne({email: email}).exec();
  }
}
