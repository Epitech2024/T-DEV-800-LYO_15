import { Inject, Injectable } from '@nestjs/common';
import { forwardRef } from '@nestjs/common/utils';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { AuthsService } from 'src/auths/auths.service';
import { LoginDto } from 'src/auths/dto/login.dto';

import { User } from './users.model';

@Injectable()
export class UsersService {
  constructor(
    @InjectModel('User') private readonly userModel: Model<User>,
    @Inject(forwardRef(() => AuthsService))
    private readonly authservice: AuthsService,
  ) {}

  async insertUser(
    username: string,
    password: string,
    ip: string,
    useragent: string,
  ) {
    const checkUser = await this.userModel.findOne({ username: username });
    console.log(checkUser);
    if (checkUser) {
      return 'username already exists.';
    } else {
      const newUser = new this.userModel({
        username,
        password,
      });
      await newUser.save();
      const token = await this.authservice.newRefreshAndAccessToken(newUser, {
        userAgent: useragent,
        ipAddress: ip,
      });
      return token;
    }
  }

  async update(id: string, username: string, password?: string) {
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
