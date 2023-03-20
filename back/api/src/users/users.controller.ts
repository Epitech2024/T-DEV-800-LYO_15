import {
  Controller,
  Post,
  Body,
  Get,
  Delete,
  UseGuards,
  Req,
  Ip,
} from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import { Request } from 'express';
import { LoginDto } from 'src/auths/dto/login.dto';
import { JwtAuthGuard } from 'src/auths/jwt-auths.guard';
import { UsersService } from './users.service';

@Controller('user')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @UseGuards(JwtAuthGuard)
  @Get('info')
  async getUserById(@Req() request) {
    const fetchedUser = await this.usersService.findOneById(
      request.user.userId,
    );
    return { user: fetchedUser };
  }

  @UseGuards(JwtAuthGuard)
  @Delete()
  async deleteUser(@Req() request) {
    const response = await this.usersService.delete(request.user.userId);
    return response;
  }

  @UseGuards(JwtAuthGuard)
  @Post('update')
  async updateUser(
    @Req() request,
    @Body('username') username: string,
    @Body('password') password: string,
  ) {
    const response = await this.usersService.update(
      request.user.userId,
      username,
      /* Checking if the password is null or undefined, if it is, it will hash the password. */
      password ? await bcrypt.hash(password, 12) : undefined,
    );
    return response;
  }

  @Post('register')
  async addUser(
    @Body('username') username: string,
    @Body('password') pwd: string,
    @Ip() ip: string,
    @Req() request: Request,
  ) {
    var password = await bcrypt.hash(pwd, 12);
    const generatedJWT = await this.usersService.insertUser(
      username,
      password,
      ip,
      request.headers['user-agent'],
    );
    return generatedJWT;
  }
}
