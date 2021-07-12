Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222673C5CF5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 15:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhGLNK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 09:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbhGLNK1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 09:10:27 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC4CC0613DD
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 06:07:39 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id ga14so19462668ejc.6
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 06:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qkkW7DZ67mzoAamz+YIVSt7JvYQY7Z5zd7I/5Xo8WOg=;
        b=aU2/4IRRrURZKw/NwMgXH2zrDrfQw64BB3vwlHQwXUsYUWXy+YBcVUefyOKJwTJ3/F
         P0iZDGWUg4E+tRvcEFyAJuslwoBKOZ6QBGhhX/1ZJOzVqpuOu+/d89fFisLXfmyZAysy
         wzqV2EpaGUujV2WQz2LZ+IPqOaLBtRr6R634dkRMtKzSiyUAykXDBeSPB+56obPwWNvV
         lMaVcTsmDGXJCIRgzA09aVEbR2vd9C4dz3UIhonsfYP8yE0vH+Wb5ZdZT8yru15NiUfk
         rsPfJMn3DU7VXObA6BoCwd7ChG1rb9zuOSfSncMYonGP962IRKuLP95JVwnz0O4MAjUJ
         A5hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qkkW7DZ67mzoAamz+YIVSt7JvYQY7Z5zd7I/5Xo8WOg=;
        b=CXAIb5zy5cyQlmUYbtwZ8Cof2u78/VvCY+syxQMct6J56tZEr48eQHHpteelLAHzdz
         pAWI15LjBmAPXQ5fqtPd5vTYpdaL/jDdvvr3EJrvfmLL3NV4JVaf1kLxXxGhLyJjq81v
         IMiQc2uNBZ78KQ55I25ipIx73muRAXWwLmpxDWJiSrDknQpsO3vaEy9ipUOVN29vxTzC
         JYXyCvx+s0p9+gosIBVjjpN/vxvOqYfQct3YSyuNDRR8zxdtLbG7XaXJH8mstMWjb6TQ
         miaixKRjad8ISv+vZzTMVqS/ehczv8YLHfEzHk082wW0JXEu0SKDYfUe89baV6OBbbmE
         YPIg==
X-Gm-Message-State: AOAM532xUH8wRY/kchBnPFfqemfuf+GmOQUBH86yMAJS/waf+GPbpYrm
        gjai18MBnIVrK1gc+4qqDIB5l5utUq7gAmbqtoCrXQ==
X-Google-Smtp-Source: ABdhPJzOiydqZEYFmQm+4OEyqqTs5V+r5oZm9chpBuQdmuBEdhncaVT/innE0yiDRfNNM3mO9L4pBISb4OMMkpouQIs=
X-Received: by 2002:a17:907:7b9f:: with SMTP id ne31mr1554663ejc.133.1626095258066;
 Mon, 12 Jul 2021 06:07:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210712060659.886176320@linuxfoundation.org>
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 12 Jul 2021 18:37:26 +0530
Message-ID: <CA+G9fYu6+hex77zTHTCopRvSVpCfxPjLydEL3Ew+92poZkncSw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/348] 5.4.132-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>, nathanl@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Jul 2021 at 11:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.132 release.
> There are 348 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.132-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.

Regressions found on powerpc:

 - build/gcc-10-cell_defconfig
 - build/gcc-8-defconfig
 - build/gcc-10-defconfig
 - build/gcc-9-defconfig
 - build/gcc-9-maple_defconfig
 - build/gcc-8-maple_defconfig
 - build/gcc-8-cell_defconfig
 - build/gcc-10-maple_defconfig
 - build/gcc-9-cell_defconfig

The following patch caused build warnings / errors on powerpc.

> Michael Ellerman <mpe@ellerman.id.au>
>     powerpc/stacktrace: Fix spurious "stale" traces in raise_backtrace_ip=
i()


Build error:
------------
arch/powerpc/kernel/stacktrace.c: In function 'raise_backtrace_ipi':
arch/powerpc/kernel/stacktrace.c:248:5: error: implicit declaration of
function 'udelay' [-Werror=3Dimplicit-function-declaration]
  248 |     udelay(1);
      |     ^~~~~~
cc1: all warnings being treated as errors

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

steps to reproduce:
-------------------------
# TuxMake is a command line tool and Python library that provides
# portable and repeatable Linux kernel builds across a variety of
# architectures, toolchains, kernel configurations, and make targets.
#
# TuxMake supports the concept of runtimes.
# See https://docs.tuxmake.org/runtimes/, for that to work it requires
# that you install podman or docker on your system.
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.

tuxmake --runtime podman --target-arch powerpc --toolchain gcc-10
--kconfig defconfig


build log link,
https://builds.tuxbuild.com/1vChzZyzmKmQCN2cLMtRBR5kbdI/

--
Linaro LKFT
https://lkft.linaro.org
