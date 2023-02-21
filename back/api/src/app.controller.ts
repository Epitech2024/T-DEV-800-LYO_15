import { Controller, Request, Get, Post, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(
    private readonly appService: AppService,
  ) {}

  //@UseGuards(LocalAuthGuard)
  //@Post('auth/login')
  //async login(@Request() req) {
  //  return this.authService.login(req.user);
  //}
//
  //@UseGuards(JwtAuthGuard)
  //@Get('profile')
  //getProfile(@Request() req) {
  //  return req.user;
  //}
}

