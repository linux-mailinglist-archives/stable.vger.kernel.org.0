Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E60F338EF5
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 14:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhCLNiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 08:38:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhCLNhm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 08:37:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2CAB64FB5;
        Fri, 12 Mar 2021 13:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615556262;
        bh=tSgA+9USDFlx+ELVk0gskxJOB6P9QjauHHTRco8jc/0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wkQTU2TD8jBmK/9C/yrHbshr+jab/CN77XiXE2UGJsMmZ77BII9ZMGpW6RGPGznbm
         Us3Q8CAe0bZGuuRCdXS7JPklfzcz7HM/H5SORTcNW4WjyJ1+CSVzxtPa7qu3+3tWnN
         CoJW+xgeAu8WOkXUfv2IlFug61dMh1YDNJOWaZ48=
Date:   Fri, 12 Mar 2021 14:37:39 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-gpio@vger.kernel.org, lkft-triage@lists.linaro.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: drivers/gpio/gpio-pca953x.c:117:40: error:
 'ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER' undeclared here (not in a function)
Message-ID: <YEtuo59GNHSGZ5eK@kroah.com>
References: <CA+G9fYvXBk8njCeodicbtc72LLwSGvODLqqBTjfEHthjvUH7AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvXBk8njCeodicbtc72LLwSGvODLqqBTjfEHthjvUH7AQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 06:57:51PM +0530, Naresh Kamboju wrote:
> While building stable rc 5.4 for arm and arm64 the following warnings / errors
> were noticed.
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm64
> CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
> 'HOSTCC=sccache gcc' olddefconfig
> .config:7570:warning: override: TRANSPARENT_HUGEPAGE_MADVISE changes
> choice state
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm64
> CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
> 'HOSTCC=sccache gcc'
> 
> arch/arm64/boot/dts/exynos/exynos5433.dtsi:254.3-29: Warning
> (reg_format): /gpu@14ac0000:reg: property has invalid length (8 bytes)
> (#address-cells == 2, #size-cells == 2)
> arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning
> (pci_device_bus_num): Failed prerequisite 'reg_format'
> arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (i2c_bus_reg):
> Failed prerequisite 'reg_format'
> arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (spi_bus_reg):
> Failed prerequisite 'reg_format'
> arch/arm64/boot/dts/exynos/exynos5433.dtsi:254.3-29: Warning
> (reg_format): /gpu@14ac0000:reg: property has invalid length (8 bytes)
> (#address-cells == 2, #size-cells == 2)
> arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning
> (pci_device_bus_num): Failed prerequisite 'reg_format'
> arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (i2c_bus_reg):
> Failed prerequisite 'reg_format'
> arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (spi_bus_reg):
> Failed prerequisite 'reg_format'
> arch/arm64/boot/dts/exynos/exynos7.dtsi:83.3-29: Warning (reg_format):
> /gpu@14ac0000:reg: property has invalid length (8 bytes)
> (#address-cells == 2, #size-cells == 2)
> arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning
> (pci_device_bus_num): Failed prerequisite 'reg_format'
> arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning
> (i2c_bus_reg): Failed prerequisite 'reg_format'
> arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning
> (spi_bus_reg): Failed prerequisite 'reg_format'
> drivers/gpio/gpio-pca953x.c:117:40: error:
> 'ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER' undeclared here (not in a function)
>   117 |  { "irq-gpios", &pca953x_irq_gpios, 1,
> ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER },
>       |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> make[3]: *** [scripts/Makefile.build:262: drivers/gpio/gpio-pca953x.o] Error 1
> make[3]: Target '__build' not remade because of errors.
> 
> 
> Reported-by:  Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build link,
> https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1091050853#L375
> 
> steps to reproduce:
> ---------------------------
> 
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
> tuxmake --runtime podman --target-arch arm64 --toolchain gcc-9
> --kconfig defconfig --kconfig-add
> https://builds.tuxbuild.com/1pcgZ6HCDYD6pGG5Xn1ammT72EM/config

Should now be fixed up, sorry about that.

greg k-h
