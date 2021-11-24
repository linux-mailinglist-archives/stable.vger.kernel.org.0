Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF80F45BC21
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244518AbhKXM0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243717AbhKXMU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 07:20:58 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62179C061D7F
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 04:05:58 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id z5so9418992edd.3
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 04:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=d5ugsfg/Pze/nWnVXKXqo1YP5qI3YtashYr1KAa/7mk=;
        b=KbxKiXU7WtozO9Y+uQmKQJbmIaChWdUAkN9CZwbWXskh6OHGhiqayNOHXzEdC5fYBV
         0MczFno719aMzDQmasFZ5q5F70zRENScqcrDf/5dZnPARNIq5Kp/e9H5ctzVxVO08F8H
         C0TosQcSjOpbtM0UTDidIzBBW8mg/35oSmlzIBoWxK31fz7FsyM5lvvvMeKLDl95t+WC
         FV9TZOEsBmGA3XOrFFAO0sfwJLkU+c11Ab3eckR4Opj7+GTOBYfy3ysXwYhEYvNzCnRw
         CXwa8nx+9hnUtb+aNcSjCIbvcY7CcyHS386vz2sHWy2nUTiQFn+7xL9gdppgrp9jIsIU
         jKFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=d5ugsfg/Pze/nWnVXKXqo1YP5qI3YtashYr1KAa/7mk=;
        b=0yXn6tnvqYmm35EVuevNzPP+N9k9s+/6a5qm7y1fv9qICrt1UHOF97S7YvszZh0hjk
         AlYPuiqtCcBhImVbT6j61xTh/5uj1MnCvMfnrCFpR5HgsmcBuq4QXGYZl7XL/3OD4BvV
         Z2Ks/9k8/X+KpdE9Q5gSsbpCERxJdnyRdv4g9ibPjM5SqXtj7GWTu5kW/JBKx4+rjmK6
         jRlfvmo40XkhpNkKuw9Pmz+dvrQXCy5Dargau1ixcd9FluMY8NTfU8LM4eFU35z9QRl+
         XF03gsu6O1h1yrdQtZK/IqwFI7wQqmv8D+/7aHenWZnXIx4Z8BhcnkMGNPMhugT3+woa
         Rn5Q==
X-Gm-Message-State: AOAM5327qrKkGmIH4rXkGIGejt3/PoCRForNrgTFUReFXuWLeXeSyFAR
        UjuHirRQiiLBxtwohjr6tkslKvrlRHP9wD0S2rOCwsOlC+CW2g==
X-Google-Smtp-Source: ABdhPJwm2yC8GgnWL6oM9V2BsbmMnmdEGnjpswAXcqEJDjGAIE7iVBnN8K9X1kpHGtaV5ZIyaZb9Nu5qaVdmmb2KkcA=
X-Received: by 2002:a17:906:b50:: with SMTP id v16mr19854237ejg.384.1637755556060;
 Wed, 24 Nov 2021 04:05:56 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Nov 2021 17:35:44 +0530
Message-ID: <CA+G9fYskrxZvmrjhO32Q9r7mb1AtKdLBm4OvDNvt5v4PTgm4pA@mail.gmail.com>
Subject: cpuidle-tegra.c:349:38: error: 'TEGRA_SUSPEND_NOT_READY' undeclared
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

Regression found on arm gcc-11 builds
Following build warnings / errors reported on stable-rc queue/5.10.

metadata:
    git_describe: v5.10.81-155-gca79bd042925
    git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc-queues
    git_short_log: ca79bd042925 (\"x86/Kconfig: Fix an unused variable
error in dell-smm-hwmon\")
    target_arch: arm
    toolchain: gcc-11

build error :
--------------
arch/arm/boot/dts/bcm53016-meraki-mr32.dts:204.4-14: Warning
(reg_format): /srab@18007000/ports/port@0:reg: property has invalid
length (4 bytes) (#address-cells == 2, #size-cells == 1)
arch/arm/boot/dts/bcm53016-meraki-mr32.dts:209.4-14: Warning
(reg_format): /srab@18007000/ports/port@5:reg: property has invalid
length (4 bytes) (#address-cells == 2, #size-cells == 1)
arch/arm/boot/dts/bcm53016-meraki-mr32.dtb: Warning
(pci_device_bus_num): Failed prerequisite 'reg_format'
arch/arm/boot/dts/bcm53016-meraki-mr32.dtb: Warning (i2c_bus_reg):
Failed prerequisite 'reg_format'
arch/arm/boot/dts/bcm53016-meraki-mr32.dtb: Warning (spi_bus_reg):
Failed prerequisite 'reg_format'
arch/arm/boot/dts/bcm53016-meraki-mr32.dts:203.10-206.5: Warning
(avoid_default_addr_size): /srab@18007000/ports/port@0: Relying on
default #address-cells value
arch/arm/boot/dts/bcm53016-meraki-mr32.dts:203.10-206.5: Warning
(avoid_default_addr_size): /srab@18007000/ports/port@0: Relying on
default #size-cells value
arch/arm/boot/dts/bcm53016-meraki-mr32.dts:208.10-217.5: Warning
(avoid_default_addr_size): /srab@18007000/ports/port@5: Relying on
default #address-cells value
arch/arm/boot/dts/bcm53016-meraki-mr32.dts:208.10-217.5: Warning
(avoid_default_addr_size): /srab@18007000/ports/port@5: Relying on
default #size-cells value

drivers/cpuidle/cpuidle-tegra.c: In function 'tegra_cpuidle_probe':
drivers/cpuidle/cpuidle-tegra.c:349:38: error:
'TEGRA_SUSPEND_NOT_READY' undeclared (first use in this function); did
you mean 'TEGRA_SUSPEND_NONE'?
  349 |  if (tegra_pmc_get_suspend_mode() == TEGRA_SUSPEND_NOT_READY)
      |                                      ^~~~~~~~~~~~~~~~~~~~~~~
      |                                      TEGRA_SUSPEND_NONE

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

due to the following patch,
cpuidle: tegra: Check whether PMC is ready
[ Upstream commit bdb1ffdad3b73e4d0538098fc02e2ea87a6b27cd ]

Check whether PMC is ready before proceeding with the cpuidle registration.
This fixes racing with the PMC driver probe order, which results in a
disabled deepest CC6 idling state if cpuidle driver is probed before the
PMC.

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>

build link:
-----------
https://builds.tuxbuild.com//21Ma7IQryRIdyeUb4V2IeX4ePy8/build.log

build config:
-------------
https://builds.tuxbuild.com//21Ma7IQryRIdyeUb4V2IeX4ePy8/config

# To install tuxmake on your system globally
# sudo pip3 install -U tuxmake
tuxmake --runtime podman --target-arch arm --toolchain gcc-10
--kconfig defconfig  \
      --kconfig-add
https://builds.tuxbuild.com//21Ma7IQryRIdyeUb4V2IeX4ePy8/config

--
Linaro LKFT
https://lkft.linaro.org
