Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3D33CE1E8
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346055AbhGSP2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349085AbhGSPZS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 11:25:18 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE8EC053388
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 08:20:24 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id e11so18144799oii.9
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 08:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T/Jo+i8u86Y0Nbf+3TlS64npfmjW9iRGqdv54lDQnDY=;
        b=uj88KLDD/vhjq0I4wFfjnMKJ7Kx1DcjZNTjTjwFa00oXWMb5Qol1UPEhcgrt2zA1Lu
         M7dR0P3oaMeQetbpQrSdbS+KmHqCRGGJRNTxydlJBt2PzG7ARiWqJzWaqaeNcpmQMg4L
         f/HO71x2Q3dQxzppaftZxNH7UzpMZ7cdWhd5JgeylOL8S04XdeSbpWz0alP+KzE14nCh
         vazIR0pd5TbekhtqAcLMG//r4dKUB+m57Fc5OTqEFyGc2JaF9GV4j4JkrFPPtERqpRMk
         WXOgZ1Z4RtppzGOhOY7KUCneAiFztjIsqJZvLL3Cme5ZZBFlR3FDRwF8kO/iqrS+RUzW
         PIHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T/Jo+i8u86Y0Nbf+3TlS64npfmjW9iRGqdv54lDQnDY=;
        b=cXwFuGf+UXSe67KQ0EZRdLSLzbE1Q+SZnwAOTtKM3t9P2QOtYoHbvMeoaqr2qSw3GU
         zS+lvQlKzWujXtfhucycGdUDoP8VYS7/f1XjCmjManp3VPdPcmwvoCC78cCpESi2PJdZ
         Z5tHD0PBXp3gAHx9Yxyp+dSjnRIGnuljv8M/EZZCMjMxIOFGT+PoW1aDEKouqF6LaSRd
         OFEzS3zCpvAXXjAhO2LVPpfWEOvg3cBHi+yS2mKID5Q75P50pYQFbPxcZAmJh6DwNMgW
         Ypbnt9ZBTbfWN/w6qZTkUeDlvM2zOlxRI1pt2NZyuJwgOZzMxtUJkyESdLOH824MrL1N
         Zk6g==
X-Gm-Message-State: AOAM531dEYJP3Qk32uQo6bMcQAFt8zGVyKZPayd+EiVjcI0Zl7kZJBgH
        HXSXBFHvq/BmZtVG5y3TQoqV0gLSSKwTRVkXuOheHg==
X-Google-Smtp-Source: ABdhPJz/1oaSMaE0B/AhvTVRFqKvfu0SZGmLlj4/rbUKSEu8x3M8WodaLzRMH+CMA2s40sDrOIoHyg1GBiOWyPxb9T0=
X-Received: by 2002:aca:eb53:: with SMTP id j80mr12734505oih.13.1626709650406;
 Mon, 19 Jul 2021 08:47:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210719144942.861561397@linuxfoundation.org> <20210719144953.504491331@linuxfoundation.org>
In-Reply-To: <20210719144953.504491331@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 19 Jul 2021 21:17:17 +0530
Message-ID: <CA+G9fYvqW9ZG8PFMyUobaiT2a_nAYyuJeWvRr0AuwB6eWMa+cQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 305/315] arm64: dts: qcom: msm8994-angler: Fix
 gpio-reserved-ranges 85-88
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Petr Vorel <petr.vorel@gmail.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Jul 2021 at 21:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Petr Vorel <petr.vorel@gmail.com>
>
> [ Upstream commit f890f89d9a80fffbfa7ca791b78927e5b8aba869 ]
>
> Reserve GPIO pins 85-88 as these aren't meant to be accessible from the
> application CPUs (causes reboot). Yet another fix similar to
> 9134586715e3, 5f8d3ab136d0, which is needed to allow angler to boot after
> 3edfb7bd76bd ("gpiolib: Show correct direction from the beginning").
>
> Fixes: feeaf56ac78d ("arm64: dts: msm8994 SoC and Huawei Angler (Nexus 6P) support")
>
> Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
> Link: https://lore.kernel.org/r/20210415193913.1836153-1-petr.vorel@gmail.com
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
> index dfa08f513dc4..e5850c4d3334 100644
> --- a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
> +++ b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
> @@ -38,3 +38,7 @@
>                 };
>         };
>  };
> +
> +&tlmm {
> +       gpio-reserved-ranges = <85 4>;
> +};

Following build errors noticed on arm64 architecture on on
stable-rc linux-4.19.y
stable-rc linux-4.14.y


make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
'HOSTCC=sccache gcc'
Error: /builds/linux/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts:42.1-6
Label or path tlmm not found
FATAL ERROR: Syntax error parsing input tree
make[3]: *** [scripts/Makefile.lib:294:
arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dtb] Error 1
make[3]: Target '__build' not remade because of errors.
make[2]: *** [/builds/linux/scripts/Makefile.build:544:
arch/arm64/boot/dts/qcom] Error 2

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

reference build link,
build: https://builds.tuxbuild.com/1vXT4jBYUbNdKdLS1wz6gmXPVLM/
config: https://builds.tuxbuild.com/1vXT4jBYUbNdKdLS1wz6gmXPVLM/config


steps to reproduce:
---------------------
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
https://builds.tuxbuild.com/1vXT4jBYUbNdKdLS1wz6gmXPVLM/config

--
Linaro LKFT
https://lkft.linaro.org
