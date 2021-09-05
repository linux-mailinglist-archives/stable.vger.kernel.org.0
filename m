Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2C3401033
	for <lists+stable@lfdr.de>; Sun,  5 Sep 2021 16:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbhIEO3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 10:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhIEO3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Sep 2021 10:29:36 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB389C061575
        for <stable@vger.kernel.org>; Sun,  5 Sep 2021 07:28:32 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id h9so7940775ejs.4
        for <stable@vger.kernel.org>; Sun, 05 Sep 2021 07:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=OeSEurl2+uMNxj+62TOY0u9X0gjRqzf7HvkH7Cdot5w=;
        b=eQ+xgutM+WOZhiG81CyMUjSC4bRiNMDHUHV3e2o15+vBJHgEAp2FBXkE8un4cPEtB+
         yx4pPxktEpvi1O/t13gc9BqMshV53ruIOXmh2buH5BfcDBQ44up9/NwTKXS76g2sDq+N
         FlUIXQheD6GGcIThrhQ6iyKUo0AKw4b6mX1FNqtNiRNtEwdVqY4ho+gd+fXroTsWvRiZ
         rm0XVt+XAFOffBpJ5LcbV4IfLWaMcNr2RqlaKkGpDHbp2CzmdVhGRM7o8KBEYHNlao5B
         PbLs+hUXVB9ELtKmqJ6RHn0EWTJww35RWo0PKZwl7L0YJd65ziPseniQsW8nZyiz9WN1
         APdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=OeSEurl2+uMNxj+62TOY0u9X0gjRqzf7HvkH7Cdot5w=;
        b=FCaR3fjqfouA2nnOG1Vds+i/sd5JDng+gSm006TOxDFQKsUQKf+1hRL9xpjXjslu+z
         lgiDCKL5Je9m7wUJlxmLFoFA2v9tbRj/g8p95z0JjMBE/KAaemdJQL5ry6KUa3p7AhtN
         i2Rumdbr8CdU7GolUDFqLcJ4CYRsuJM5dT0D+4wRXnT6nGFC9XFy8QBD0VJeUcvxuDEX
         BoyDzW2Kxj79tB7s+sARzAmpixJJ0vVbrD0UjEto1l9ZOUMHUXkTV9gs4mE2HehWFgC1
         VhYmiEM656+UQ+0KAYL2SgM7iIxU/DALapkfGBX1Z+3wqhH6/J29e9mytelR7nQnRDjx
         PL5w==
X-Gm-Message-State: AOAM533DUdiCZ767WdEK1lylARX5aiUQekrczWibF9MEirK052EbMlD1
        JRnoO2Hc4eo+JEgpwWeiG1F3FUwvmspndK6iIdza8w==
X-Google-Smtp-Source: ABdhPJyM4mUratmqo/RzqN0QLV+/EokLYEhrHg7Jt6NqRa9L45VFd4AtOWILD8jrkd5U6HBEchjrJKoYZG3pZd+UaNU=
X-Received: by 2002:a17:906:318b:: with SMTP id 11mr9194339ejy.493.1630852110473;
 Sun, 05 Sep 2021 07:28:30 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 5 Sep 2021 19:58:19 +0530
Message-ID: <CA+G9fYuYV-JUO5iZAWdh+_WooeiXhwNMh+xr24P2WDHPagTGJA@mail.gmail.com>
Subject: udmabuf.c:30:17: warning: implicit declaration of function 'open'
To:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Tom Murphy <murphyt7@tcd.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following build warnings noticed while building stable-rc Linux 5.14.1-rc1
with gcc-11 for arm64 architecture.

aarch64-linux-gnu-gcc -I../../../../../usr/include/    udmabuf.c  -o
kselftest/drivers/dma-buf/udmabuf
udmabuf.c: In function 'main':
udmabuf.c:30:17: warning: implicit declaration of function 'open'; did
you mean 'popen'? [-Wimplicit-function-declaration]
   30 |         devfd = open(/dev/udmabuf, O_RDWR);
      |                 ^~~~
      |                 popen
udmabuf.c:42:15: warning: implicit declaration of function 'fcntl'
[-Wimplicit-function-declaration]
   42 |         ret = fcntl(memfd, F_ADD_SEALS, F_SEAL_SHRINK);
      |               ^~~~~
make[3]: Leaving directory
'/builds/linux/tools/testing/selftests/drivers/dma-buf'

Build config:
https://builds.tuxbuild.com/1xXcUtI2INra8KaHjOXXQMOyAD0/config

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

meta data:
-----------
    git_describe: v5.14-rc6-389-g95dc72bb9c03,
    git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc,
    git_sha: 95dc72bb9c032093e79e628a98c927b3db73a6c3,
    git_short_log: 95dc72bb9c03 (\Linux 5.14.1-rc1\),
    kconfig: [
        defconfig,
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/lkft.config,
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/lkft-crypto.config,
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/distro-overrides.config,
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/systemd.config,
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/virtio.config,
        CONFIG_ARM64_MODULE_PLTS=y
    ],
    kernel_version: 5.14.1-rc1,
    target_arch: arm64,
    targets: [
        dtbs,
        dtbs-legacy,
        headers,
        kernel,
        kselftest,
        kselftest-merge,
        modules
    ],
    toolchain: gcc-11,

steps to reproduce:
https://builds.tuxbuild.com/1xXcUtI2INra8KaHjOXXQMOyAD0/tuxmake_reproducer.sh

--
Linaro LKFT
https://lkft.linaro.org
