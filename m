Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7188445C713
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353424AbhKXOVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357504AbhKXOUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 09:20:19 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D02C0E488F
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 04:40:30 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id t5so10017267edd.0
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 04:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nSpuGbyIyyQ+71p/yb+p6if97PJIr6GL7ZXjQCLuH6I=;
        b=Bj62C85POtUWusNZWXl1H4hR/Y7ipm7DXme1fAK5Ll+n74BM8MWiUqwUaSzbnoCmpa
         CvQxiLva2ND3i9V6hsPx6sEU3q0gHJFLUKv5fuWLlhJ8zTbJh1afDkpLIYyhXfvI+OBm
         MaRLmRHZnD2b7Ht7IYETc296NQGnWsJrFHU89QCiMk7y3HJ6c0MytulkUlYFwAdUvMVy
         33+IEXtbLlpb8tfeMmOc6ngwHbNUrbEKTNNi5unE0dUZHyBe38AQ/6H+eM6sudQWxXTD
         I5BoeKINTy3kw2TTUFH5aoWfwXugQFaX5tAv3CagvPwdym6sOmM4nN5b9ZKXJomKD0sh
         CxGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nSpuGbyIyyQ+71p/yb+p6if97PJIr6GL7ZXjQCLuH6I=;
        b=gTC4aDpE3AnPcxNQn/eKTe8S2sJpAQJSzB4czYh4l8iuOyxh4xQIxTc5s9PsQY4YtU
         V3xDD9zEX2rbya4pxWm/zIjWaKOpmoOCHWa4NYz050J7ImUux7MrNCN4Hj3K8hlyQfU3
         g1xCFaR6dzXUw1vtXUndfle4nSFHWkXzwPJq5kH4OMevuORHD0SK7tt58pTwt1Zn87sG
         VmCgJhbsPQ7RaRwv2qSRNsMBX68JKb7J5m/BfOOVw0YvoVI1Taa8iB4cRGqZuzcQ14Gj
         PJH5tzzLDLjMA0C3qefnjJm9BkjNA6rnZQJVxBf+7vpC6ht+YQLXSxbNkhJUpZ9mrUP/
         aisg==
X-Gm-Message-State: AOAM530fCeelDQTXuxc6dvuru9gLCS+PTXWvBpiuvT/ieLozt4700U1p
        7fk9/F3Ln3/Lno3/f4odNQGWNoVoORLfbeDe9+T1mBfmh2+Z6A==
X-Google-Smtp-Source: ABdhPJysX0IerTAF8T1qIJPqiZYpFNflJNAAa8GBIxbozU+a825dQgC/+iStCZUPaysVaIn5W1708LCKUnXKWlUxOq0=
X-Received: by 2002:a05:6402:4311:: with SMTP id m17mr23787247edc.103.1637757627702;
 Wed, 24 Nov 2021 04:40:27 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYskrxZvmrjhO32Q9r7mb1AtKdLBm4OvDNvt5v4PTgm4pA@mail.gmail.com>
In-Reply-To: <CA+G9fYskrxZvmrjhO32Q9r7mb1AtKdLBm4OvDNvt5v4PTgm4pA@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Nov 2021 18:10:16 +0530
Message-ID: <CA+G9fYvroifx_0xx-DxRRdDqsR79HV4KTC+a8+3zTL57Cu2TnQ@mail.gmail.com>
Subject: Re: cpuidle-tegra.c:349:38: error: 'TEGRA_SUSPEND_NOT_READY' undeclared
To:     linux-stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Nov 2021 at 17:35, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> Regression found on arm gcc-11 builds
> Following build warnings / errors reported on stable-rc queue/5.10.

 Following build warnings / errors reported on stable-rc 5.10 also.

>
> metadata:
>     git_describe: v5.10.81-155-gca79bd042925
>     git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc-queues
>     git_short_log: ca79bd042925 (\"x86/Kconfig: Fix an unused variable
> error in dell-smm-hwmon\")
>     target_arch: arm
>     toolchain: gcc-11
>
> build error :
> --------------
> arch/arm/boot/dts/bcm53016-meraki-mr32.dts:204.4-14: Warning
> (reg_format): /srab@18007000/ports/port@0:reg: property has invalid
> length (4 bytes) (#address-cells == 2, #size-cells == 1)
> arch/arm/boot/dts/bcm53016-meraki-mr32.dts:209.4-14: Warning
> (reg_format): /srab@18007000/ports/port@5:reg: property has invalid
> length (4 bytes) (#address-cells == 2, #size-cells == 1)
> arch/arm/boot/dts/bcm53016-meraki-mr32.dtb: Warning
> (pci_device_bus_num): Failed prerequisite 'reg_format'
> arch/arm/boot/dts/bcm53016-meraki-mr32.dtb: Warning (i2c_bus_reg):
> Failed prerequisite 'reg_format'
> arch/arm/boot/dts/bcm53016-meraki-mr32.dtb: Warning (spi_bus_reg):
> Failed prerequisite 'reg_format'
> arch/arm/boot/dts/bcm53016-meraki-mr32.dts:203.10-206.5: Warning
> (avoid_default_addr_size): /srab@18007000/ports/port@0: Relying on
> default #address-cells value
> arch/arm/boot/dts/bcm53016-meraki-mr32.dts:203.10-206.5: Warning
> (avoid_default_addr_size): /srab@18007000/ports/port@0: Relying on
> default #size-cells value
> arch/arm/boot/dts/bcm53016-meraki-mr32.dts:208.10-217.5: Warning
> (avoid_default_addr_size): /srab@18007000/ports/port@5: Relying on
> default #address-cells value
> arch/arm/boot/dts/bcm53016-meraki-mr32.dts:208.10-217.5: Warning
> (avoid_default_addr_size): /srab@18007000/ports/port@5: Relying on
> default #size-cells value
>
> drivers/cpuidle/cpuidle-tegra.c: In function 'tegra_cpuidle_probe':
> drivers/cpuidle/cpuidle-tegra.c:349:38: error:
> 'TEGRA_SUSPEND_NOT_READY' undeclared (first use in this function); did
> you mean 'TEGRA_SUSPEND_NONE'?
>   349 |  if (tegra_pmc_get_suspend_mode() == TEGRA_SUSPEND_NOT_READY)
>       |                                      ^~~~~~~~~~~~~~~~~~~~~~~
>       |                                      TEGRA_SUSPEND_NONE
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> due to the following patch,
> cpuidle: tegra: Check whether PMC is ready
> [ Upstream commit bdb1ffdad3b73e4d0538098fc02e2ea87a6b27cd ]
>
> Check whether PMC is ready before proceeding with the cpuidle registration.
> This fixes racing with the PMC driver probe order, which results in a
> disabled deepest CC6 idling state if cpuidle driver is probed before the
> PMC.
>
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
> build link:
> -----------
> https://builds.tuxbuild.com//21Ma7IQryRIdyeUb4V2IeX4ePy8/build.log
>
> build config:
> -------------
> https://builds.tuxbuild.com//21Ma7IQryRIdyeUb4V2IeX4ePy8/config
>
> # To install tuxmake on your system globally
> # sudo pip3 install -U tuxmake
> tuxmake --runtime podman --target-arch arm --toolchain gcc-10
> --kconfig defconfig  \
>       --kconfig-add
> https://builds.tuxbuild.com//21Ma7IQryRIdyeUb4V2IeX4ePy8/config
>
> --
> Linaro LKFT
> https://lkft.linaro.org
