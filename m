Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642B6338EC6
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 14:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhCLN2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 08:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbhCLN2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 08:28:04 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6042C061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 05:28:03 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id bm21so53347156ejb.4
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 05:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=b+5LL81NTCNgfBYQfEPL7kybqyqdg+vaL/Zty0afB6Y=;
        b=esIoD+GqtcUfJ/C5j41XoF+ISrbAZg9gkze2zEdn5COb4YI9WMtWu9zlPPHug2qUYd
         vl+NbB1Eq40lhlJeJt0fABQLH3pnnmS8/HsbdlbUZ05U85XbJ0aRAjbuC99n9b7+P00w
         rSHSTpRAsN5OMMKsguud8YI+DaFZ618k4wj7McwHcLAnOpwZDW9YI+j440S2K/0X7IZl
         pX+49pna7djUw0KjeVdxyGVsAg0IgCgrNg9jbrAnxNgl9wkY2IL4UicYVOEZkvIiTL+N
         uS+Vj/O8bDKd0PnK5/gRoKfhOGkLl6wowBjsTm5mfoFWWHtzqiWfFiTPCcS2c2f97eeG
         nHUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=b+5LL81NTCNgfBYQfEPL7kybqyqdg+vaL/Zty0afB6Y=;
        b=ZasCzd5ETqCiBqldZWyBkUf4Qj3yNjJTWPR5qbCmeflskSNoGF4+mzLWNSF2CFE0lA
         pVTwbxJHPwzczm/gQblSOWX8aTDIEbht5g8CT6LcNP9ufTnO0YsYGoMHAqErlPHYmclN
         cDnzHt6uvtRpmZ352s3OgzrJQlqWLXaZjPMMSCCi/eYgtewCHqhTCHAVxTpPdtDN8ZGd
         1FE5iQgfGLw5rbuFoAMxbenSLBofHofT6vpfWAWgMqOaWr0UC3q20aow4X2YbGLi5k3f
         4fRhQESEyTz9noyJNzNo/v8ExnihbN147q4OP2s7Sz6f3N4xb65UxTOdQIGf7cBZIk1U
         UGhg==
X-Gm-Message-State: AOAM5300uWQNy1zrl2RP3yGyh3I5Y4t99m0unKtfoiqsd0Fpia9AfWkq
        TKJj3YDFXdaVftuUnSCA4NBAReOEdU/BULMB3FjhkQ==
X-Google-Smtp-Source: ABdhPJy+RXN4DcvEaJGj3C9Kz5xGxvFyJiu+MssGsIOUkDxSMm9oS/NOn3mYmXyZdVoWm2gvLd36Ygf/1nz1AmXazho=
X-Received: by 2002:a17:906:229b:: with SMTP id p27mr8826996eja.287.1615555682331;
 Fri, 12 Mar 2021 05:28:02 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 12 Mar 2021 18:57:51 +0530
Message-ID: <CA+G9fYvXBk8njCeodicbtc72LLwSGvODLqqBTjfEHthjvUH7AQ@mail.gmail.com>
Subject: drivers/gpio/gpio-pca953x.c:117:40: error: 'ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER'
 undeclared here (not in a function)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-gpio@vger.kernel.org, lkft-triage@lists.linaro.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While building stable rc 5.4 for arm and arm64 the following warnings / errors
were noticed.

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
'HOSTCC=sccache gcc' olddefconfig
.config:7570:warning: override: TRANSPARENT_HUGEPAGE_MADVISE changes
choice state
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
'HOSTCC=sccache gcc'

arch/arm64/boot/dts/exynos/exynos5433.dtsi:254.3-29: Warning
(reg_format): /gpu@14ac0000:reg: property has invalid length (8 bytes)
(#address-cells == 2, #size-cells == 2)
arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning
(pci_device_bus_num): Failed prerequisite 'reg_format'
arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (i2c_bus_reg):
Failed prerequisite 'reg_format'
arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (spi_bus_reg):
Failed prerequisite 'reg_format'
arch/arm64/boot/dts/exynos/exynos5433.dtsi:254.3-29: Warning
(reg_format): /gpu@14ac0000:reg: property has invalid length (8 bytes)
(#address-cells == 2, #size-cells == 2)
arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning
(pci_device_bus_num): Failed prerequisite 'reg_format'
arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (i2c_bus_reg):
Failed prerequisite 'reg_format'
arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (spi_bus_reg):
Failed prerequisite 'reg_format'
arch/arm64/boot/dts/exynos/exynos7.dtsi:83.3-29: Warning (reg_format):
/gpu@14ac0000:reg: property has invalid length (8 bytes)
(#address-cells == 2, #size-cells == 2)
arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning
(pci_device_bus_num): Failed prerequisite 'reg_format'
arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning
(i2c_bus_reg): Failed prerequisite 'reg_format'
arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning
(spi_bus_reg): Failed prerequisite 'reg_format'
drivers/gpio/gpio-pca953x.c:117:40: error:
'ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER' undeclared here (not in a function)
  117 |  { "irq-gpios", &pca953x_irq_gpios, 1,
ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER },
      |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
make[3]: *** [scripts/Makefile.build:262: drivers/gpio/gpio-pca953x.o] Error 1
make[3]: Target '__build' not remade because of errors.


Reported-by:  Linux Kernel Functional Testing <lkft@linaro.org>

Build link,
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1091050853#L375

steps to reproduce:
---------------------------

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


tuxmake --runtime podman --target-arch arm64 --toolchain gcc-9
--kconfig defconfig --kconfig-add
https://builds.tuxbuild.com/1pcgZ6HCDYD6pGG5Xn1ammT72EM/config


-- 
Linaro LKFT
https://lkft.linaro.org
