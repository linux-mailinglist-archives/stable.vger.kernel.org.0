Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC006575FE
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 12:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbiL1Lpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 06:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiL1Lpc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 06:45:32 -0500
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677EADED5
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 03:45:31 -0800 (PST)
Received: by mail-vk1-xa2d.google.com with SMTP id f24so7299560vkl.9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 03:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DO8ZjPmBlydgmvZZ1N7cloiBjSVhW28qONM3ineUNkY=;
        b=RQQw2KzUCAlDJWVTPFD29bqw1sySDUqJF8euKg62rXfSaeS6iBhYQ5FEPk/lnlsrjP
         axi1ZT6824deTtNyMTYr6t16cpndy+wc89gDYZKJS3iJuhww4zi7OimebT1Sn9AleXhY
         zpnnJqWYAcjdbXY8tCdNOejArNtn6kJi87DZqoG8yvHrChDcJHJYKKnBYutx7qJArVN8
         qdeWAqf7e4jGS2m6lPtNAgomNeeMzncHrShaRJJqpaXpKbnihyM7de+xu094JLHu9f7A
         8BOCXgPZkURPiHy31h26QMMGZ7fuCD4SjdR8Cg2A5vvoVesJDjEulWEt/9ih17AGG0pA
         /FhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DO8ZjPmBlydgmvZZ1N7cloiBjSVhW28qONM3ineUNkY=;
        b=3ZWoPtqj+syvDOnTWxMjDSBFADQ0G7ZEF8SeFhGuxrsTf5TcXzdPTItyctyohyvj4H
         Jpx7Wz0SxUedze+F88W19AHS4ulYcV00PjcDauOyQSzilphjyxS8vnL7VH/hTevPqcxz
         G+jZRymAc8JtNj5a+cJYqVCRS/Cl2P7Q2QMw9gx0Nvy/17EnOVqwznMqf5LLS0mhjbDs
         a/8FXaNG5fjS5Dg45YBa0ONvg2Dc9KO/LY2lGmYKiLCZxclbZqj8tvLrlsqHFSKWwvqD
         cxZzHtMk8riN0DF/FtiTrSvKz8Gkr29G5d8UJOKrCEcKaOnEV9VC2uXpY9BsW9kmCstm
         KAdQ==
X-Gm-Message-State: AFqh2krr93pEpZXlwO0llMVFLJErDeliiPV2rqwLwVcH6t5X+QMnQEHI
        BvsgEnu6lENmozFx0DalUR+injS601vcq3Peu3EawHQwXMgLFunC
X-Google-Smtp-Source: AMrXdXvHRKwjhq5h3eeEdb8RJBes/abyIF7ZhjsnC0XXCJe0wqsCQLNYhWPLa5qA3e4LQ4H6bLRje0w4zltjSTgOU0A=
X-Received: by 2002:a1f:3215:0:b0:3d5:86ff:6638 with SMTP id
 y21-20020a1f3215000000b003d586ff6638mr122357vky.30.1672227930232; Wed, 28 Dec
 2022 03:45:30 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 28 Dec 2022 17:15:19 +0530
Message-ID: <CA+G9fYv1ZbtQKOmHX_mBOVqoK0P3tOL1bcb_z4eMkAZTXtzbNQ@mail.gmail.com>
Subject: stable-rc: 4.19: s390x-linux-gnu-ld: drivers/base/platform.o: in
 function `devm_platform_get_and_ioremap_resource': platform.c:(.text+0x43a):
 undefined reference to `devm_ioremap_resource'
To:     linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, linux-s390@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dejin Zheng <zhengdejin5@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following s390 build warnings / errors noticed on stable-rc 4.19 queue.

Regressions found on s390:
   - build/gcc-11-tinyconfig
   - build/gcc-10-tinyconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc-queues
git_describe: v4.19.269-363-g176f3d59718e
Build: v4.19.269-363-g176f3d59718e
Details: https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_4.19-sanity/build/v4.19.269-363-g176f3d59718e

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/build ARCH=s390
CROSS_COMPILE=s390x-linux-gnu- 'CC=sccache s390x-linux-gnu-gcc'
'HOSTCC=sccache gcc'

In function 'setup_lowcore_dat_off',
    inlined from 'setup_arch' at /builds/linux/arch/s390/kernel/setup.c:958:2:
/builds/linux/arch/s390/kernel/setup.c:342:9: warning: 'memcpy'
reading 128 bytes from a region of size 0 [-Wstringop-overread]
  342 |         memcpy(lc->stfle_fac_list, S390_lowcore.stfle_fac_list,
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  343 |                sizeof(lc->stfle_fac_list));
      |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~
/builds/linux/arch/s390/kernel/setup.c:344:9: warning: 'memcpy'
reading 128 bytes from a region of size 0 [-Wstringop-overread]
  344 |         memcpy(lc->alt_stfle_fac_list, S390_lowcore.alt_stfle_fac_list,
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  345 |                sizeof(lc->alt_stfle_fac_list));
      |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from /builds/linux/arch/s390/kernel/lgr.c:13:
In function 'stfle',
    inlined from 'lgr_info_get' at /builds/linux/arch/s390/kernel/lgr.c:122:2:
/builds/linux/arch/s390/include/asm/facility.h:88:9: warning: 'memcpy'
reading 4 bytes from a region of size 0 [-Wstringop-overread]
   88 |         memcpy(stfle_fac_list, &S390_lowcore.stfl_fac_list, 4);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
s390x-linux-gnu-ld: drivers/base/platform.o: in function
`devm_platform_get_and_ioremap_resource':
platform.c:(.text+0x43a): undefined reference to `devm_ioremap_resource'
s390x-linux-gnu-ld: drivers/base/platform.o: in function
`devm_platform_ioremap_resource':
platform.c:(.text+0x478): undefined reference to `devm_ioremap_resource'
make[1]: *** [/builds/linux/Makefile:1055: vmlinux] Error 1


Build details,
https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_4.19-sanity/build/v4.19.269-363-g176f3d59718e/testrun/13836893/suite/build/test/gcc-11-tinyconfig/details/
https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_4.19-sanity/build/v4.19.269-363-g176f3d59718e/testrun/13836893/suite/build/test/gcc-11-tinyconfig/history/

Build logs,
https://storage.tuxsuite.com/public/linaro/lkft/builds/2JXXJr2fBrwWGJISB1IcJiW15jL/

Steps to reproduce:
--------------------
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.
# Original tuxmake command with fragments listed below.
# tuxmake --runtime podman --target-arch s390 --toolchain gcc-11
--kconfig tinyconfig


--
Linaro LKFT
https://lkft.linaro.org
