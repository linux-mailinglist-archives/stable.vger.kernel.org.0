Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FD23CE70A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 19:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349515AbhGSQUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 12:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352715AbhGSQOb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 12:14:31 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F754C05BD2C
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 09:08:19 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id 75-20020a9d08510000b02904acfe6bcccaso18727762oty.12
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 09:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kbUdQK2vlTB6j8FkLGF5mfubURI8TtogZmmaDTQnPvE=;
        b=m1Y5GGDzL9DhhIvkQOhKE8jm3ZPo4x4Kv6XvT4jPArx0adIOBT1hGUUUbAshqq35At
         cndkNHv3bLE99B2KPXbx+BBHRsvMNEKx7wZFz3S2elI3zJMYHu0SAlm5rcIyp1hfBy2h
         89LdnkHO0yJuDXGxtdbPbok1w/9yDgFDESo27uJMpG9xBVdPCaPb7TxfI4h1HltRqi8V
         EVWjePQnUvjw4o8vQiw0vFx0L2ew1xzqVhz8912TvG7AK2WMYtMRkiu6XZ46lYpGSiap
         Bv0DFKDwfzskPik/IwZXUFaBoM1tM253EjCycIAHlDL9qYGSyy3QqtYCqiS+KdK70o5r
         SaNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kbUdQK2vlTB6j8FkLGF5mfubURI8TtogZmmaDTQnPvE=;
        b=L8rYQ1YWsB2+yQHPEVDnMIbVnnstqEQRNFiWr2OMnM21Np/+XeZgouq9sX8voaGNgn
         Op21FkpFSf5PkiQGMp4NCyW+rgYfMgdBVymjZE7xJ7MlBetM1NBGHaq7O5NeaasDD6Ql
         Ulj9Y5BAtHIeIRefTFsRGeai2PHwmFub6zY/DFthQrphzT7hHELbtkA+oIG5q5K7r6E0
         rBislTrg6FtNAZbGaicrd7oWIZAcPoCh+JShNyQtnvc0dCzwFlsMqNqkA5CGez0Vvx2h
         Xp7X0sOYtfWea+aTQiX7TN0Hb1tD8ZdC0G2BzFMXO4a6r5/CWkBRifmKar/U8351nJLw
         qy9A==
X-Gm-Message-State: AOAM530XcnagvItd3j9hzShUoqdcRW+UyaQ8lhL4P3FDT5/WobTXfasl
        A3m3oW3zzfKfBgqDEntvS13Okwv1axKxwUXVX1n0/w==
X-Google-Smtp-Source: ABdhPJxNFGGSwVV4mbFVlmbTZTuBcgOgdMnEF1cKN+gu3X2TRo9H89LDD1Q4vY5nLoK0erRMiePXRw+pMiFgx5TJODI=
X-Received: by 2002:a05:6830:242f:: with SMTP id k15mr19821711ots.72.1626712304089;
 Mon, 19 Jul 2021 09:31:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210719144940.904087935@linuxfoundation.org> <20210719144947.891096868@linuxfoundation.org>
In-Reply-To: <20210719144947.891096868@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 19 Jul 2021 22:01:30 +0530
Message-ID: <CA+G9fYt3-5vb_1rjdW3=4nASPGMe3gRrXzdCu10bSgR+Zeo-Hw@mail.gmail.com>
Subject: Re: [PATCH 5.10 216/243] arm64: dts: ti: k3-j721e-common-proc-board:
 Use external clock for SERDES
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Jul 2021 at 21:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Kishon Vijay Abraham I <kishon@ti.com>
>
> [ Upstream commit f2a7657ad7a821de9cc77d071a5587b243144cd5 ]
>
> Use external clock for all the SERDES used by PCIe controller. This will
> make the same clock used by the local SERDES as well as the clock
> provided to the PCIe connector.
>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Link: https://lore.kernel.org/r/20210603143427.28735-4-kishon@ti.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  .../dts/ti/k3-j721e-common-proc-board.dts     | 40 +++++++++++++++++++
>  1 file changed, 40 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
> index 7cd31ac67f88..56a92f59c3a1 100644
> --- a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
> +++ b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
> @@ -9,6 +9,7 @@
>  #include <dt-bindings/gpio/gpio.h>
>  #include <dt-bindings/input/input.h>
>  #include <dt-bindings/net/ti-dp83867.h>
> +#include <dt-bindings/phy/phy-cadence.h>

Following build errors noticed on arm64 architecture on 5.10 branch.

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
'HOSTCC=sccache gcc'
/builds/linux/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts:12:10:
fatal error: dt-bindings/phy/phy-cadence.h: No such file or directory
   12 | #include <dt-bindings/phy/phy-cadence.h>
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
make[3]: *** [scripts/Makefile.lib:326:
arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dtb] Error 1
make[3]: Target '__build' not remade because of errors.
make[2]: *** [/builds/linux/scripts/Makefile.build:497:
arch/arm64/boot/dts/ti] Error 2
make[2]: Target '__build' not remade because of errors.
make[1]: *** [/builds/linux/Makefile:1358: dtbs] Error 2

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


ref:
https://builds.tuxbuild.com/1vXT3b334rT9K155TzUSkMWobkx/
https://builds.tuxbuild.com/1vXT3b334rT9K155TzUSkMWobkx/config

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


tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
--kconfig defconfig --kconfig-add
https://builds.tuxbuild.com/1vXT3b334rT9K155TzUSkMWobkx/config

--
Linaro LKFT
https://lkft.linaro.org
