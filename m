Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EE923CCD7
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 19:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgHERIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 13:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728467AbgHERFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 13:05:00 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4CDC06174A
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 10:05:00 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id j8so34312499ioe.9
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 10:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=+tKIJ4WfKtgkgJ70TYuXATNUVm3LhJghXiOd28Dg4S4=;
        b=kleVXsE46UakXw54HJz9RI31Pm/wR5ygNm2B19l8S5/st12R9Faem7GqanY5xMSa24
         2EPhX8Xe48UrUk/IPL5fvB+4mgiJHSdVlh/07MkzfqwEXrpz18yzuMI0ns71XkeN07x9
         a6hymI5IWaCBTbwQrVRYUFzdmK8W+oISvCJf0MJ9AoYWPH0Lp5x+aprfy/D/uX8St6z/
         1pnb5sW3dj5t6+W6f4Fg2yTzrAhsijWFulDLBysOY0KBM4IBXnIDpoSbAwyBna1TIIxh
         dyv2ZQuSdjnL+cfyQbqAlCMFR8khuqvVZIxsKeGippegBPYCC6rq2LBJNH0KHJGBJZZp
         oZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=+tKIJ4WfKtgkgJ70TYuXATNUVm3LhJghXiOd28Dg4S4=;
        b=N9wYIy9CvOibw7XucwVYVSdVC08EVh0FuAISqBOZvu3PsLjorMZkB7t3ETEdY5lueS
         Y0d6tWFobDpwQxXJLYBO9qewapcjpbuZULRGQhQYgo2tmozdWYdY5ICArPBfTZSZOEwd
         5Uphtg845O9TZ1XFrpXqQefRflcysQXTFnCQ0+R0noUd+QkKfGLen4sRC/axSvBK08du
         C2NqodTCvQMnEsUpYSIl5YILDzyiJSfo/YZ2R7TuU6q8cYv5+6qe710EepUmFxeAo/MC
         xM2Uj2tY2nJsH+RurmPtdgBE7rYnk7kyZXHsGJaayVfrS4Cz5WfoAuq0sC+TwzS+kRVC
         +KYQ==
X-Gm-Message-State: AOAM530LJ/rdxrHDoghYS6OH7eeL7AIljMBQ/mrz9rXZoYbZfFArUx/5
        FjvrH10BNKV+SPVLZ1zG50ip+2Jkg3Zu5P92v1I44o/KVVDS+w==
X-Google-Smtp-Source: ABdhPJx2ihURBb9WXEgJWBbJrLCpXYtPqeV+qPX2VxxwISq3rP1Z5pMvy/je2X/nqaRG0OTnUp7Lolp9VsEDp+rb/NY=
X-Received: by 2002:a05:6638:1129:: with SMTP id f9mr3627080jar.35.1596647096002;
 Wed, 05 Aug 2020 10:04:56 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 5 Aug 2020 22:34:44 +0530
Message-ID: <CA+G9fYu4tshr3YUqqU-y8vXtoMVt5BgHtmFXqMUa_457_-8D-A@mail.gmail.com>
Subject: stable rc 4.9- v4.9.232-51-g1f47445197d2 - build breaks on arm64,
 arm, x86_64 and i386.
To:     linux- stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable rc 4.9 build breaks on arm64, arm, x86_64 and i386.

Here are the build log failures on arm64.

    git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-=
stable-rc.git
    target_arch: arm64
    toolchain: gcc-9
    git_short_log: 1f47445197d2 (\Linux 4.9.233-rc1\)
    git_sha: 1f47445197d2c8eecafa2b996f635aa89851c123
    git_describe: v4.9.232-51-g1f47445197d2
    kernel_version: 4.9.233-rc1

make -sk KBUILD_BUILD_USER=3DTuxBuild -C/linux -j16 ARCH=3Darm64
CROSS_COMPILE=3Daarch64-linux-gnu- HOSTCC=3Dgcc CC=3D"sccache
aarch64-linux-gnu-gcc" O=3Dbuild Image
#
../arch/arm64/kernel/hw_breakpoint.c: In function =E2=80=98arch_bp_generic_=
fields=E2=80=99:
../arch/arm64/kernel/hw_breakpoint.c:352:5: note: parameter passing
for argument of type =E2=80=98struct arch_hw_breakpoint_ctrl=E2=80=99 chang=
ed in GCC
9.1
  352 | int arch_bp_generic_fields(struct arch_hw_breakpoint_ctrl ctrl,
      |     ^~~~~~~~~~~~~~~~~~~~~~
../fs/ext4/inode.c: In function =E2=80=98ext4_direct_IO=E2=80=99:
../fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98offset=E2=80=99
 3610 |  loff_t offset =3D iocb->ki_pos;
      |         ^~~~~~
../fs/ext4/inode.c:3608:9: note: previous definition of =E2=80=98offset=E2=
=80=99 was here
 3608 |  loff_t offset =3D iocb->ki_pos;
      |         ^~~~~~
make[3]: *** [../scripts/Makefile.build:304: fs/ext4/inode.o] Error 1
make[3]: Target '__build' not remade because of errors.
make[2]: *** [../scripts/Makefile.build:555: fs/ext4] Error 2
../lib/vsprintf.c: In function =E2=80=98number=E2=80=99:
../lib/vsprintf.c:399:7: note: parameter passing for argument of type
=E2=80=98struct printf_spec=E2=80=99 changed in GCC 9.1
  399 | char *number(char *buf, char *end, unsigned long long num,
      |       ^~~~~~
../lib/vsprintf.c: In function =E2=80=98widen_string=E2=80=99:
../lib/vsprintf.c:562:7: note: parameter passing for argument of type
=E2=80=98struct printf_spec=E2=80=99 changed in GCC 9.1
  562 | char *widen_string(char *buf, int n, char *end, struct printf_spec =
spec)
      |       ^~~~~~~~~~~~
../lib/vsprintf.c: In function =E2=80=98string=E2=80=99:
../lib/vsprintf.c:583:7: note: parameter passing for argument of type
=E2=80=98struct printf_spec=E2=80=99 changed in GCC 9.1
  583 | char *string(char *buf, char *end, const char *s, struct
printf_spec spec)
      |       ^~~~~~
../lib/vsprintf.c: In function =E2=80=98hex_string=E2=80=99:
../lib/vsprintf.c:803:7: note: parameter passing for argument of type
=E2=80=98struct printf_spec=E2=80=99 changed in GCC 9.1
  803 | char *hex_string(char *buf, char *end, u8 *addr, struct
printf_spec spec,
      |       ^~~~~~~~~~
../lib/vsprintf.c: In function =E2=80=98mac_address_string=E2=80=99:
../lib/vsprintf.c:936:7: note: parameter passing for argument of type
=E2=80=98struct printf_spec=E2=80=99 changed in GCC 9.1
  936 | char *mac_address_string(char *buf, char *end, u8 *addr,
      |       ^~~~~~~~~~~~~~~~~~
../lib/vsprintf.c: In function =E2=80=98ip4_addr_string=E2=80=99:
../lib/vsprintf.c:1137:7: note: parameter passing for argument of type
=E2=80=98struct printf_spec=E2=80=99 changed in GCC 9.1
 1137 | char *ip4_addr_string(char *buf, char *end, const u8 *addr,
      |       ^~~~~~~~~~~~~~~
../lib/vsprintf.c: In function =E2=80=98uuid_string=E2=80=99:
../lib/vsprintf.c:1305:7: note: parameter passing for argument of type
=E2=80=98struct printf_spec=E2=80=99 changed in GCC 9.1
 1305 | char *uuid_string(char *buf, char *end, const u8 *addr,
      |       ^~~~~~~~~~~
../lib/vsprintf.c: In function =E2=80=98symbol_string=E2=80=99:
../lib/vsprintf.c:668:7: note: parameter passing for argument of type
=E2=80=98struct printf_spec=E2=80=99 changed in GCC 9.1
  668 | char *symbol_string(char *buf, char *end, void *ptr,
      |       ^~~~~~~~~~~~~
../lib/vsprintf.c: In function =E2=80=98resource_string=E2=80=99:
../lib/vsprintf.c:695:7: note: parameter passing for argument of type
=E2=80=98struct printf_spec=E2=80=99 changed in GCC 9.1
  695 | char *resource_string(char *buf, char *end, struct resource *res,
      |       ^~~~~~~~~~~~~~~
../lib/vsprintf.c: In function =E2=80=98ip6_addr_string=E2=80=99:
../lib/vsprintf.c:1123:7: note: parameter passing for argument of type
=E2=80=98struct printf_spec=E2=80=99 changed in GCC 9.1
 1123 | char *ip6_addr_string(char *buf, char *end, const u8 *addr,
      |       ^~~~~~~~~~~~~~~
../lib/vsprintf.c: In function =E2=80=98ip4_addr_string_sa=E2=80=99:
../lib/vsprintf.c:1210:7: note: parameter passing for argument of type
=E2=80=98struct printf_spec=E2=80=99 changed in GCC 9.1
 1210 | char *ip4_addr_string_sa(char *buf, char *end, const struct
sockaddr_in *sa,
      |       ^~~~~~~~~~~~~~~~~~
../lib/vsprintf.c: In function =E2=80=98ip6_addr_string_sa=E2=80=99:
../lib/vsprintf.c:1148:7: note: parameter passing for argument of type
=E2=80=98struct printf_spec=E2=80=99 changed in GCC 9.1
 1148 | char *ip6_addr_string_sa(char *buf, char *end, const struct
sockaddr_in6 *sa,
      |       ^~~~~~~~~~~~~~~~~~
../lib/vsprintf.c: In function =E2=80=98escaped_string=E2=80=99:
../lib/vsprintf.c:1245:7: note: parameter passing for argument of type
=E2=80=98struct printf_spec=E2=80=99 changed in GCC 9.1
 1245 | char *escaped_string(char *buf, char *end, u8 *addr, struct
printf_spec spec,
      |       ^~~~~~~~~~~~~~
../lib/vsprintf.c: In function =E2=80=98dentry_name=E2=80=99:
../lib/vsprintf.c:604:7: note: parameter passing for argument of type
=E2=80=98struct printf_spec=E2=80=99 changed in GCC 9.1
  604 | char *dentry_name(char *buf, char *end, const struct dentry
*d, struct printf_spec spec,
      |       ^~~~~~~~~~~
../lib/vsprintf.c: In function =E2=80=98clock.isra.0=E2=80=99:
../lib/vsprintf.c:1387:7: note: parameter passing for argument of type
=E2=80=98struct printf_spec=E2=80=99 changed in GCC 9.1
 1387 | char *clock(char *buf, char *end, struct clk *clk, struct
printf_spec spec,
      |       ^~~~~
../lib/vsprintf.c: In function =E2=80=98bitmap_list_string.isra.0=E2=80=99:
../lib/vsprintf.c:896:7: note: parameter passing for argument of type
=E2=80=98struct printf_spec=E2=80=99 changed in GCC 9.1
  896 | char *bitmap_list_string(char *buf, char *end, unsigned long *bitma=
p,
      |       ^~~~~~~~~~~~~~~~~~
../lib/vsprintf.c: In function =E2=80=98bitmap_string.isra.0=E2=80=99:
../lib/vsprintf.c:855:7: note: parameter passing for argument of type
=E2=80=98struct printf_spec=E2=80=99 changed in GCC 9.1
  855 | char *bitmap_string(char *buf, char *end, unsigned long *bitmap,
      |       ^~~~~~~~~~~~~
../lib/vsprintf.c: In function =E2=80=98bdev_name.isra.0=E2=80=99:
../lib/vsprintf.c:649:7: note: parameter passing for argument of type
=E2=80=98struct printf_spec=E2=80=99 changed in GCC 9.1
  649 | char *bdev_name(char *buf, char *end, struct block_device *bdev,
      |       ^~~~~~~~~
../lib/vsprintf.c: In function =E2=80=98pointer=E2=80=99:
../lib/vsprintf.c:1571:7: note: parameter passing for argument of type
=E2=80=98struct printf_spec=E2=80=99 changed in GCC 9.1
 1571 | char *pointer(const char *fmt, char *buf, char *end, void *ptr,
      |       ^~~~~~~
make[2]: Target '__build' not remade because of errors.
make[1]: *** [/linux/Makefile:1036: fs] Error 2
make[1]: Target 'Image' not remade because of errors.
make: *** [Makefile:152: sub-make] Error 2
make: Target 'Image' not remade because of errors.


--=20
Linaro LKFT
https://lkft.linaro.org
