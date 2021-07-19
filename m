Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383563CE988
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 19:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352239AbhGSQ5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 12:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358648AbhGSQxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 12:53:19 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106D2C014CC3
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 10:10:50 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id a17-20020a9d3e110000b02904ce97efee36so7186031otd.7
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 10:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wzuKjO1Bj462QTMKvDqhgEerTybn9c7OBhwpooW3xtg=;
        b=VNsTTFSUKiQbiKtytaDLBVf3Jz77PfOOK3R9uHEQIBtCz0/A3qZIw6j12E3AT55kJ9
         Gb14QHVlkwsp8ShHAiruL601fC5L1GgvqaP5nGBktvtc/b98AoTF7Op6i5rr09lR95+E
         gcHShc2gPYQ1CJ5ECchNfZChzkKEGIzl748Fa9g/IGbFDmftva3U3AA46TpAtdi13a5A
         SB5ewlnZcCcTFr8V8Z8X2gUQM9PU3/ulYUqZ+VNnAhsZzTZ8Brl7CFSVpzvNefplCszl
         GOyGrlYqX5qjexbsUr0A2xN7vdpve+3uOS5NRmzUiJg6i4ndut2dEocBU/anT2ifc4un
         P6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wzuKjO1Bj462QTMKvDqhgEerTybn9c7OBhwpooW3xtg=;
        b=Qbzpkte/f5pdRi87CNXbNjLpOIbiziInib/mMLPLjbpZm4vgcwgmpT6oQqPLlODHZs
         ZzVHLpA/ILiuGaghZ7qbcrIjNoc30/HEwDEZtJF9w8Tpurmy4OMpkNqVc+4GkHulsPWf
         /875PQ0sHjfOs0Ty0RBiWBsIPyeEGm5bcAQRRR4b4fxxyH3G2+UftVs+iSQxuHfUrRnb
         f1X3727jtAAFlX308Q7oBBiQ03QR52pKN7Yb9/Cvz3wB+I8OzT3TDhjb6kBKAr/i3s6c
         hidzU3Cy969a/huUU4CsoktFeR43QCSU7Obt8kQCzX4ShRayZ45KXySZIRzPH+7vuXJf
         GeSg==
X-Gm-Message-State: AOAM5303Ee3EJ3Ko/X4qECUAWYJooW+S2g+TLxYVI12u1iu3+49bZN54
        dQMwujrSvrBi7eUsFMO0A8ewrtNeJdh+VeRuEcppKg==
X-Google-Smtp-Source: ABdhPJxtMrpwPvoJzvlQoTebB/00JUT1s1m5LDSL/PeBtVdVeUkGBjNSGmGgepU4b//aJt4UjoNlb1eWeKqBJCe7kxQ=
X-Received: by 2002:a9d:27a4:: with SMTP id c33mr19831834otb.281.1626715766376;
 Mon, 19 Jul 2021 10:29:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210719144940.904087935@linuxfoundation.org> <20210719144947.891096868@linuxfoundation.org>
 <CA+G9fYt3-5vb_1rjdW3=4nASPGMe3gRrXzdCu10bSgR+Zeo-Hw@mail.gmail.com>
In-Reply-To: <CA+G9fYt3-5vb_1rjdW3=4nASPGMe3gRrXzdCu10bSgR+Zeo-Hw@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 19 Jul 2021 22:59:14 +0530
Message-ID: <CA+G9fYvHj9w1ZYk7UCCh2raCybeb0QeFFic-cuCgj8s_Ffwtbw@mail.gmail.com>
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

On Mon, 19 Jul 2021 at 22:01, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Mon, 19 Jul 2021 at 21:42, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Kishon Vijay Abraham I <kishon@ti.com>
> >
> > [ Upstream commit f2a7657ad7a821de9cc77d071a5587b243144cd5 ]
> >
> > Use external clock for all the SERDES used by PCIe controller. This will
> > make the same clock used by the local SERDES as well as the clock
> > provided to the PCIe connector.
> >
> > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> > Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> > Link: https://lore.kernel.org/r/20210603143427.28735-4-kishon@ti.com
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  .../dts/ti/k3-j721e-common-proc-board.dts     | 40 +++++++++++++++++++
> >  1 file changed, 40 insertions(+)
> >
> > diff --git a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
> > index 7cd31ac67f88..56a92f59c3a1 100644
> > --- a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
> > +++ b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
> > @@ -9,6 +9,7 @@
> >  #include <dt-bindings/gpio/gpio.h>
> >  #include <dt-bindings/input/input.h>
> >  #include <dt-bindings/net/ti-dp83867.h>
> > +#include <dt-bindings/phy/phy-cadence.h>
>
> Following build errors noticed on arm64 architecture on 5.10 branch.

also noticed on stable-rc 5.12.


> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm64
> CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
> 'HOSTCC=sccache gcc'
> /builds/linux/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts:12:10:
> fatal error: dt-bindings/phy/phy-cadence.h: No such file or directory
>    12 | #include <dt-bindings/phy/phy-cadence.h>
>       |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> compilation terminated.
> make[3]: *** [scripts/Makefile.lib:326:
> arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dtb] Error 1
> make[3]: Target '__build' not remade because of errors.
> make[2]: *** [/builds/linux/scripts/Makefile.build:497:
> arch/arm64/boot/dts/ti] Error 2
> make[2]: Target '__build' not remade because of errors.
> make[1]: *** [/builds/linux/Makefile:1358: dtbs] Error 2
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
>
> ref:
> https://builds.tuxbuild.com/1vXT3b334rT9K155TzUSkMWobkx/
> https://builds.tuxbuild.com/1vXT3b334rT9K155TzUSkMWobkx/config
>
> Steps to reproduce:
> --------------------
> # TuxMake is a command line tool and Python library that provides
> # portable and repeatable Linux kernel builds across a variety of
> # architectures, toolchains, kernel configurations, and make targets.
> #
> # TuxMake supports the concept of runtimes.
> # See https://docs.tuxmake.org/runtimes/, for that to work it requires
> # that you install podman or docker on your system.
> #
> # To install tuxmake on your system globally:
> # sudo pip3 install -U tuxmake
> #
> # See https://docs.tuxmake.org/ for complete documentation.
>
>
> tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
> --kconfig defconfig --kconfig-add
> https://builds.tuxbuild.com/1vXT3b334rT9K155TzUSkMWobkx/config
>
> --
> Linaro LKFT
> https://lkft.linaro.org
