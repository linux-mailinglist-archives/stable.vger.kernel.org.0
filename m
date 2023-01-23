Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED488677575
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 08:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjAWHRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 02:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjAWHRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 02:17:00 -0500
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8A310267
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 23:16:59 -0800 (PST)
Received: by mail-vk1-xa2c.google.com with SMTP id l129so5516926vkh.6
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 23:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w/nTmDIKe+CVQP0G3n4sHN1YN0YVxf/pwrE7R3XBahY=;
        b=j0DuOHuWM+7i161REIceXJtlyGe6lPzVV83om8dv7HIdjBqtObgcqD7vyxgSi0kCqS
         L6vnZ3zskyNDsHwcEDPGqMgFcSotUTM+KOlv5uKgsF71dozfHHnXplumhn+OrLFKR6ZQ
         gT2+ihJZiTQMDOSZC4DXuorDglpsrCncRhUkw+dFhodRIcFgAKJlWhZY5gahNZuH0/eB
         N5u67mwj0P+/AqC4TuZNX+W2aND1zFecRIHowMxje0VQhq0LKgbxl7wRJQp44Ci8A1rU
         2xEZ4i3VsJ7cyiL21qDmxd7HyybDEL6paFqan8T3bBIVMsAnNjh+WCQFkSLt6TYPb1nh
         4SzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w/nTmDIKe+CVQP0G3n4sHN1YN0YVxf/pwrE7R3XBahY=;
        b=pe2omFhWUYWDvPDcGubcQXbKc8cr1IoqS6dnq/G9nUhcCkcKQwxJag7lAf8iCyoQou
         hbaufsjnerXKbT/4CBh66XNdDL3N8LT/DRiEFZjYYEFbuQP+nIbxChXkW70wNRg8rLIV
         NC6wttTVZ2tMNwUT2HRaSLb4MM7GSpYulwzw08WuSxXdUe2rWB8uPPIQsYdEdnqz/fX1
         iiM3/xICf+nYzBFyBDGCIuUsNrUl8X8d84CxDof4UlJUy6bMGjlMUQF4hhPMoVQx0LZt
         7HVjtUH97mf1YxoVYeQB1dTf4hSjqgohAy9p/xx2OUazeCrE7eK8Dtp9JT1YL7N3Dzxz
         CdKA==
X-Gm-Message-State: AFqh2kojWmBs2JKyrnJcqZb5JWy88sh+5R283QX3OO3JIvW/hv4q5C5z
        k0NZemQ1rjfILCIlbH8OYvBg1o8H7Z5bO4JUMlMZpg==
X-Google-Smtp-Source: AMrXdXtMlHG8p50ItK9g4I4f9Rz4TM/4HtgzphmZKhBxXNfUZkMl+Lv2xogcqWcFaaPZQky0COP8Q34qHkT7TYmy1z8=
X-Received: by 2002:a1f:ab92:0:b0:3d5:63ee:dae1 with SMTP id
 u140-20020a1fab92000000b003d563eedae1mr3077115vke.9.1674458217943; Sun, 22
 Jan 2023 23:16:57 -0800 (PST)
MIME-Version: 1.0
References: <20230122150229.351631432@linuxfoundation.org>
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 23 Jan 2023 12:46:47 +0530
Message-ID: <CA+G9fYtQ9SLrGt0TtW5d3ctZBHEpQpau_+pNzho=qHve8QiDaA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/98] 5.10.165-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
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

On Sun, 22 Jan 2023 at 20:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.165 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.165-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
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
make[1]: *** [/builds/linux/Makefile:1194: vmlinux] Error 1

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
https://storage.tuxsuite.com/public/linaro/lkft/builds/2Kgdn5w5X9wlz0EVgtSZ=
bTFuRYy/

--
Linaro LKFT
https://lkft.linaro.org
