Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764573CE986
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 19:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352148AbhGSQ5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 12:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358386AbhGSQxH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 12:53:07 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDDDC025250
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 10:09:38 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id b24-20020a9d60d80000b02904d14e47202cso1546066otk.4
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 10:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wcwQJYf67o94a9TBPs5MmeYX0NSO4HBqK2b4H8Qxl1k=;
        b=Qp4Pg9+ZODgt1PgZecCPV9NqTHTA+BZkY/Hc/xTZHcjW4cSUZ6my1w0e+pwdM3zFgD
         WRUs74b/eQHSx2OGTREIvPC1APn3pkEVLlnBhBImloXWbbCWWYWVgke8p2ZcYvq6bX4z
         6ehYVSNIzbTMLkjpu52gwzAHwbHD2GObMY42MQDUg4ffPnBjLpYD8xQX8qGqRQqLRW+/
         NmdXDIHvymD/sOrMWH25AfNVc8Vl1SvUsuhWO7xMUePmjUyDRY6iBLUWDr7/B00oWBmu
         ghuhG5wtbIsvLA0aLhIZRmxBw7LmZTQGtm2jeLnhgSmKYkAlbRAGKCkZNuF4A2nNCzl/
         k7+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wcwQJYf67o94a9TBPs5MmeYX0NSO4HBqK2b4H8Qxl1k=;
        b=eUDFqSUCFogq7Ffkdodjc2cNMIkEy5HJIW/6NDHwXNU0tio0ZjbqsvDc4AyRhHjrlO
         5MI519VmHZVduGC2UqF9FJ6JqjWrUdEgsKU7b7kryQesGG991dfSMa+RcVSrMgUyfoSE
         2gzMFI89pT/CiSTWtwEH31CaICyK56sXYuwsi/EgyflLu0IHdaFtGSBsY6CnbA9/qDoF
         1f3ix66/VeZSOTcsItFHo7V5uSsapi0MJtd1yUxS13/bi3uZ4PdUrzPM33A1zM17du/V
         8Tyvyk8JL/kVeGZ6PGqFUOZDXJO6k63rLInYO/ZsBhrFFN6hwFa779+1Empdfna43H1o
         W22A==
X-Gm-Message-State: AOAM5330Iw2nTtyzvoimWF959J3ndbkpyGeTbnpw0EJ97Htlp4lzos0h
        0C6cq5ieFQFdVMPCdp6AXU0oohO8gR3a9ugnk/+oNQ==
X-Google-Smtp-Source: ABdhPJzUI/tvjcaqBTVTLQvqMVFNcLp5pNnHuNKOF/yo0hg4caIfHYLZ3XY+PpIK957Z1HK66E+79t8qRdmsxq1OLIM=
X-Received: by 2002:a9d:32f:: with SMTP id 44mr19289969otv.266.1626715699953;
 Mon, 19 Jul 2021 10:28:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210719144942.514164272@linuxfoundation.org>
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 19 Jul 2021 22:58:08 +0530
Message-ID: <CA+G9fYts0yyTCEpSQf=1AEWEJ5Y7=o=3fGE7k5rhPA5mXJCBng@mail.gmail.com>
Subject: Re: [PATCH 5.12 000/292] 5.12.19-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Jul 2021 at 21:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> NOTE, this is going to be the LAST 5.12.y release.  After this one, it
> is end-of-life for this kernel branch.  Please move to 5.13.y at this
> point in time.
>
> ---------------
>
> This is the start of the stable review cycle for the 5.12.19 release.
> There are 292 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Jul 2021 14:47:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.19-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following build errors noticed on arm64 architecture on 5.12 branch.

> Kishon Vijay Abraham I <kishon@ti.com>
>     arm64: dts: ti: k3-j721e-common-proc-board: Use external clock for SERDES


make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
'HOSTCC=sccache gcc'
/builds/linux/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts:12:10:
fatal error: dt-bindings/phy/phy-cadence.h: No such file or directory
   12 | #include <dt-bindings/phy/phy-cadence.h>
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
make[3]: *** [scripts/Makefile.lib:336:
arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dtb] Error 1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


ref:
https://builds.tuxbuild.com/1vXepgrWZ3f66we49R8XJj2fGTR/
https://builds.tuxbuild.com/1vXepgrWZ3f66we49R8XJj2fGTR/config

Steps to reproduce:
--------------------
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


tuxmake --runtime podman --target-arch arm64 --toolchain gcc-10
--kconfig defconfig

--
Linaro LKFT
https://lkft.linaro.org
