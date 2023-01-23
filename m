Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04E5677567
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 08:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjAWHKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 02:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjAWHKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 02:10:09 -0500
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DCB15CB0
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 23:10:08 -0800 (PST)
Received: by mail-vk1-xa31.google.com with SMTP id z190so5521934vka.4
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 23:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WjPqSuzor2mexKiakowxVQr4nOSsrzDO0rfbtbGNoJ0=;
        b=EVERcEcMqSr90XjlxF++5xpZEtsLFuRMqwSNiXlc0zPwSqcClBFfrozDsHWkFW7BXE
         eKEMo6xE036strpAeBm6CPGX0OEMWBmL6czhjrw7LXmCPLjfxCtztgG6lVgwauixaqAY
         Y3FOZq5N0myiplQ50oaCQ1i0xLhdIxQU4jkEOAdbSe8OhhyHrIEgwSgFZKZwS2epivvR
         DIpX6Om4oBKxRYS9OsUdGFC6rR+n7CB7BAlgkxCYdmGLyvCUl463pF3Bhsw6tweB+lZS
         1FXp+IbXI8lRTCwVwyKSFYaSAg+T72fmR+p+PH4BHhNCCkpFa++sF8XQVskThvRwy0JR
         YTaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WjPqSuzor2mexKiakowxVQr4nOSsrzDO0rfbtbGNoJ0=;
        b=fxsGCjFw2ccjYjJUg5nx3uta7X4GuiPc5KOsh2v0EG+iXOY6wNrXmT1RhaBZqjuCFC
         R1eFHsuF4Ci7SMVcryPBV6duMqatoa9gmBD0yXMd7fxD4H0BxSQdw6jReZWYbFHcfh09
         uAx/raZgB2WZim5AOyaJvBqvvzjy1+o+17weI04CIyTqzDfALZk5yR5SqzZxPn8G/WE1
         os63eUuHE1tLZHxxMIUv3fZVSPXnmEPPSC7fF6XT7R4DXKNk2kqjtBSOGSQmxCWkL/ge
         L94DeHUlJYVzV8bxsVGQtG561aND1vaKAyT4MktWHTiz3/ZpyLRj/VQ7Rf7CP3+s/FPy
         JaHw==
X-Gm-Message-State: AFqh2kpX4OEJdB9uD0hqoiJS2dx5kaMCOS1f3wHbzEEjNub+hOUvYz3/
        z/1k0P1gJ+qol2Ub1wylTLzqjPkhAI9n6nYtMRb6dw==
X-Google-Smtp-Source: AMrXdXvlw86yjS3bdxq8s5wT6J7Oljmynzmd4ce2Jo2uBxrWlKKExzHkg7k5D2qomyWH8IJo6utmWr8SzlbfCo+2DZU=
X-Received: by 2002:a1f:ab92:0:b0:3d5:63ee:dae1 with SMTP id
 u140-20020a1fab92000000b003d563eedae1mr3075127vke.9.1674457807360; Sun, 22
 Jan 2023 23:10:07 -0800 (PST)
MIME-Version: 1.0
References: <20230122150232.736358800@linuxfoundation.org>
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 23 Jan 2023 12:39:55 +0530
Message-ID: <CA+G9fYsEvpCj_vSFLxkKA6tzdNOhimqZYF+WCLKYAiNLtrMvsA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 22 Jan 2023 at 20:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.90 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.90-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build regressions found on sh:
   - build/gcc-8-dreamcast_defconfig
   - build/gcc-8-microdev_defconfig


Build error logs:

`.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
defined in discarded section `.exit.text' of crypto/algboss.o
`.exit.text' referenced in section `__bug_table' of
drivers/char/hw_random/core.o: defined in discarded section
`.exit.text' of drivers/char/hw_random/core.o
make[1]: *** [/builds/linux/Makefile:1218: vmlinux] Error 1

Bisection points to this commit,
    arch: fix broken BuildID for arm64 and riscv
    commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.

Ref:
upstream discussion thread,
https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/

Steps to reproduce:
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.
# Original tuxmake command with fragments listed below.

tuxmake --runtime podman --target-arch sh --toolchain gcc-8 --kconfig
microdev_defconfig


Build log links,
https://storage.tuxsuite.com/public/linaro/lkft/builds/2Kgdvgv8TfoAfi1b9HBQ=
rkWJO1G/


--
Linaro LKFT
https://lkft.linaro.org
