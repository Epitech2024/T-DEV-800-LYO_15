import { Module } from '@nestjs/common';
import { UsersService } from './users.service';
import { MongooseModule } from '@nestjs/mongoose';

import { UserSchema } from './users.model';
import { UsersController } from './users.controller';
import { AuthsModule } from 'src/auths/auths.module';
import { forwardRef } from '@nestjs/common/utils';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: 'User', schema: UserSchema }]),
    forwardRef(() => AuthsModule),
  ],
  providers: [UsersService],
  exports: [UsersService],
  controllers: [UsersController],
})
export class UsersModule {}
