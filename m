Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3E23A0166
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235851AbhFHSvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235933AbhFHStd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 14:49:33 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD30C06114A
        for <stable@vger.kernel.org>; Tue,  8 Jun 2021 11:45:29 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id he7so14836458ejc.13
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 11:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/9rLQJhNwowgUH5qn2d/6rawlhJslNX08LVgR1AXk/Y=;
        b=Ttd70NFKeWLtk9YzA6vnRM3q4SBEOb8SG1Ot6V8gOIonraUAhzMpICfr7RGO6CgYl6
         q0praKM8UQD7AO6T9EUBO0JsYeQAODFDuTfUjQ8qRmBJ5sdIz3yxD7C6cev3BaJ2GFbz
         oORYl2lsEVzOd3Zfuv9tn+b4R1Qa+q89E4KeZObisVFFdnzvjbSzoBhn/aehYKzb0x1X
         Pj/2GQgaaeaMP/nsb3uqcTBrsKUyFPk4XXZb5/6Dhz7SD3b+0I9/IYzhDgUzFLIjwJW0
         O/OvZOkOBPeHPkZIT2jFWt2Po7447MuAYMb9bcEd+5fvkQ6FvFiiVLTrl6Wyv/QyuUCD
         eSrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/9rLQJhNwowgUH5qn2d/6rawlhJslNX08LVgR1AXk/Y=;
        b=uAKw5/OaIMq4ge98GRoTXDGlDTJvgEct+KgR6ivQgINZ42g3n3MwaNYfCOGpspNOCR
         rYC/nRK9U4ohJBBcY6FfVbxB0J1QCore43APaUdekhPc2vzS/XH3aBhVH4XlSKQG7eHA
         O2oGz+UnNnEUP9bGxXjsynHS2RW9H59nRebpExtSkBibOcdhsm0G89GXWM9ftkN3fOMq
         AYD9PqxejSi+ZPihDm18vaiSx69V4b8geOfNO3lj/TR0UdCmJvADpsuaIDLpgbqismDB
         YRRv5cyEQLUtJzpb2N7fSJKJWiLiTx6vxTDuXjHKBN7MArYi5hF9f5RHuWMxSZ3XirAb
         zylw==
X-Gm-Message-State: AOAM531axwpvrMPCV3705z8la27OZcAgkMfgaD6+DUYZ9A1PW4OssnZQ
        5B929bI7XV5exjW4jhVnjWtBQzdSerEBm+iK6+VRE3neTaut9jQI
X-Google-Smtp-Source: ABdhPJxHcaek0VALuIjuQpmEqsmb5L2rvgJA/6sLy4W0yYlT1gGdDMFuke3UuV+avIprR0fyd6fYid/IvCWfLZ7+5t0=
X-Received: by 2002:a17:906:8318:: with SMTP id j24mr24739511ejx.375.1623177927896;
 Tue, 08 Jun 2021 11:45:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210608175932.263480586@linuxfoundation.org>
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 9 Jun 2021 00:15:15 +0530
Message-ID: <CA+G9fYu3URCR6_ZL+KPYFEOVL4f=8TjjyFncmvoLuYrR_YR3=A@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/58] 4.19.194-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marek Vasut <marex@denx.de>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Fabio Estevam <festevam@gmail.com>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Ludwig Zenz <lzenz@dh-electronics.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 9 Jun 2021 at 00:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.194 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.194-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following patch caused arm dtb build failure on 4.19

> Marek Vasut <marex@denx.de>
>     ARM: dts: imx6q-dhcom: Add PU,VDD1P1,VDD2P5 regulators

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm
CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc'
Error: /builds/linux/arch/arm/boot/dts/imx6q-dhcom-som.dtsi:414.1-12
Label or path reg_vdd1p1 not found
Error: /builds/linux/arch/arm/boot/dts/imx6q-dhcom-som.dtsi:418.1-12
Label or path reg_vdd2p5 not found
FATAL ERROR: Syntax error parsing input tree
make[2]: *** [scripts/Makefile.lib:294:
arch/arm/boot/dts/imx6q-dhcom-pdk2.dtb] Error 1

Reported-by:  Linux Kernel Functional Testing <lkft@linaro.org>

build url:
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1328891505#L477

Config:
https://builds.tuxbuild.com/1tg0YjTz4ow5CkHv0bzTc05pVs5/config

--
Linaro LKFT
https://lkft.linaro.org
