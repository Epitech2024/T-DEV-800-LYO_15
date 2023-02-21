import {Controller, Post, Body, Get, Delete, UseGuards, Req} from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import { JwtAuthGuard } from 'src/auths/jwt-auths.guard';
import { UsersService } from './users.service';

@Controller('user')
export class UsersController {
    constructor(private readonly usersService: UsersService) {}

    @UseGuards(JwtAuthGuard)
    @Get()
    async getUserById(@Req() request) {
        const fetchedUser = await this.usersService.findOneById(request.user.userId);
        return { user: fetchedUser }
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
        @Body('name') name: string,
        @Body('email') email: string,
        @Body('password') password: string,
    ) {
        const response = await this;this.usersService.update(request.user.userId, name, email, password);
        return response;
    }

    @Post()
    async addUser(
        @Body('name') name: string,
        @Body('email') email: string,
        @Body('password') pwd: string,
        @Body('role') role: string
    ) {
        var password = await bcrypt.hash(pwd, 12);
        const generatedUserId = await this.usersService.insertUser(
            name, email, password, role
        );
        return { id: generatedUserId };
    }

}
