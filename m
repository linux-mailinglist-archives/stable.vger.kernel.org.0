Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2E62655F9
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 02:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725440AbgIKAMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 20:12:47 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46658 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgIKAMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 20:12:44 -0400
Received: by mail-io1-f68.google.com with SMTP id d18so9172491iop.13;
        Thu, 10 Sep 2020 17:12:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u2g+BRUsxbAc6+9v662wrPylHc+E/Q5PDs7cD5no2GQ=;
        b=PwGV7zQpVnOHuHgz7CFWEpYP2mt+vkMwtW/dH/O9oTHJPFH/vEhKxv+7W8NJzY1oKr
         x1D0PzIWlz6IfD45LlsXQPMIrsU3uZKP6A3m3Gx9T6GNf5toGNVgrSFjZBpoDlXUVzLG
         8yswJJpf3d0gBt4aA4tze4OQ2Qupcrl0M7r9l/DSxx+/W7awNzm9btG70mbac2ufzsfd
         jRlvekEjdGckwhCOndO80WPEWayu0uNTcYU2iavjykSVtwpQTop4lxisPwyNvazF0j0m
         D/bLc4LbTJGEFNmx36YqGzeJrkDKe20pZKZfzc50ddFkkLCPtavlfg3I9sc6e+P+NF1T
         EDqw==
X-Gm-Message-State: AOAM530wSJ6U3YxswcR6PP7u5ICJnvwJ+B1zodq42ObTrFQ1mU9j30EW
        ECNiEus9gHmqUnxr1NyrCY5yQQXw+1J0LZNAAYvDEAOzus8=
X-Google-Smtp-Source: ABdhPJzCDmX4+QHEZjLMbfVPDVv7k7Vfl4ysvcj2IMf+0wPSk8y9sBy1fEkgKbSgVdrGsZojmkIehvOD0MIiptg31tY=
X-Received: by 2002:a6b:6016:: with SMTP id r22mr9782988iog.42.1599783163555;
 Thu, 10 Sep 2020 17:12:43 -0700 (PDT)
MIME-Version: 1.0
References: <1599624552-17523-3-git-send-email-chenhc@lemote.com> <20200910163423.6FE0B221EB@mail.kernel.org>
In-Reply-To: <20200910163423.6FE0B221EB@mail.kernel.org>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Fri, 11 Sep 2020 08:12:32 +0800
Message-ID: <CAAhV-H5usiPEE1wfaDNHA-_XdWCtDANpTXmBjjiVkwcN_bRbaQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] irqchip/loongson-pch-pic: Reserve legacy LPC irqs
To:     Sasha Levin <sashal@kernel.org>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Sasha,

On Fri, Sep 11, 2020 at 1:18 AM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.8.7, v5.4.63, v4.19.143, v4.14.196, v4.9.235, v4.4.235.
>
> v5.8.7: Build OK!
> v5.4.63: Failed to apply! Possible dependencies:
>     4134b762eb13 ("ARM: exynos: Enable exynos-asv driver for ARCH_EXYNOS")
>     818e915fbac5 ("irqchip: Add Loongson HyperTransport Vector support")
>     a93f1d903fa3 ("irqchip: Add driver for Loongson-3 HyperTransport PIC controller")
>     b74416dba33b ("irqchip: Define EXYNOS_IRQ_COMBINER")
>     dbb152267908 ("irqchip: Add driver for Loongson I/O Local Interrupt Controller")
>     ef8c01eb64ca ("irqchip: Add Loongson PCH PIC controller")
>
> v4.19.143: Failed to apply! Possible dependencies:
>     0145beed9d26 ("irqchip: davinci-aintc: move the driver to drivers/irqchip")
>     06a287161429 ("ARM: davinci: aintc: use the new config structure")
>     1fa70c7f4913 ("ARM: exynos: Enable exynos-chipid driver")
>     2b6a2e74f2bf ("ARM: davinci: aintc: use a common prefix for symbols in the driver")
>     2d242aa28892 ("ARM: davinci: aintc: drop GPL license boilerplate")
>     4134b762eb13 ("ARM: exynos: Enable exynos-asv driver for ARCH_EXYNOS")
>     74b0eac24259 ("ARM: davinci: aintc: use irq domain")
>     818e915fbac5 ("irqchip: Add Loongson HyperTransport Vector support")
>     a93f1d903fa3 ("irqchip: Add driver for Loongson-3 HyperTransport PIC controller")
>     a98ca73ee348 ("ARM: davinci: wrap HW interrupt numbers with a macro")
>     b74416dba33b ("irqchip: Define EXYNOS_IRQ_COMBINER")
>     d0064594f20a ("ARM: davinci: select GENERIC_IRQ_MULTI_HANDLER")
>     dbb152267908 ("irqchip: Add driver for Loongson I/O Local Interrupt Controller")
>     de4f82a245ce ("ARM: davinci: aintc: wrap davinci_irq_init() with a helper")
>     ef8c01eb64ca ("irqchip: Add Loongson PCH PIC controller")
>     fd0f4275864d ("ARM: davinci: aintc: use the new irqchip config structure in dm* SoCs")
>
> v4.14.196: Failed to apply! Possible dependencies:
>     0149385537e6 ("irqchip: Place CONFIG_SIFIVE_PLIC into the menu")
>     1fa70c7f4913 ("ARM: exynos: Enable exynos-chipid driver")
>     215f4cc0fb20 ("irqchip/meson: Add support for gpio interrupt controller")
>     33c57c0d3c67 ("RISC-V: Add a basic defconfig")
>     4134b762eb13 ("ARM: exynos: Enable exynos-asv driver for ARCH_EXYNOS")
>     4235ff50cf98 ("irqchip/irq-goldfish-pic: Add Goldfish PIC driver")
>     4a632cec8884 ("RISC-V: Enable module support in defconfig")
>     67d2075ad695 ("dt-bindings: irqchip: Introduce TISCI Interrupt router bindings")
>     706cffc1b912 ("irqchip/exiu: Add support for Socionext Synquacer EXIU controller")
>     818e915fbac5 ("irqchip: Add Loongson HyperTransport Vector support")
>     8237f8bc4f6e ("irqchip: add a SiFive PLIC driver")
>     9f1463b86c13 ("irqchip/ti-sci-inta: Add support for Interrupt Aggregator driver")
>     a93f1d903fa3 ("irqchip: Add driver for Loongson-3 HyperTransport PIC controller")
>     abe45fd9f1b0 ("irqchip: Andestech Internal Vector Interrupt Controller driver")
>     accaf1fbfb5d ("dt-bindings: irqchip: Introduce TISCI Interrupt Aggregator bindings")
>     b74416dba33b ("irqchip: Define EXYNOS_IRQ_COMBINER")
>     c2ba80af4805 ("dt-bindings/goldfish-pic: Add device tree binding for Goldfish PIC driver")
>     c94fb639d546 ("irqchip: Add Kconfig menu")
>     ca1c4d653524 ("MAINTAINERS: Add entry for sound/soc/ti and update the OMAP audio support")
>     cd844b0715ce ("irqchip/ti-sci-intr: Add support for Interrupt Router driver")
>     dbb152267908 ("irqchip: Add driver for Loongson I/O Local Interrupt Controller")
>     ef8c01eb64ca ("irqchip: Add Loongson PCH PIC controller")
>     f55c73aef890 ("irqchip/pdc: Add PDC interrupt controller for QCOM SoCs")
>
> v4.9.235: Failed to apply! Possible dependencies:
>     0464a53eba0a ("MIPS: Update Goldfish RTC driver maintainer email address")
>     1fa70c7f4913 ("ARM: exynos: Enable exynos-chipid driver")
>     215f4cc0fb20 ("irqchip/meson: Add support for gpio interrupt controller")
>     33c57c0d3c67 ("RISC-V: Add a basic defconfig")
>     4134b762eb13 ("ARM: exynos: Enable exynos-asv driver for ARCH_EXYNOS")
>     4235ff50cf98 ("irqchip/irq-goldfish-pic: Add Goldfish PIC driver")
>     4a632cec8884 ("RISC-V: Enable module support in defconfig")
>     5ed34d3a4387 ("irqchip: Add UniPhier AIDET irqchip driver")
>     706cffc1b912 ("irqchip/exiu: Add support for Socionext Synquacer EXIU controller")
>     7a08de1d8fd2 ("dt-bindings: Add device tree binding for Goldfish RTC driver")
>     818e915fbac5 ("irqchip: Add Loongson HyperTransport Vector support")
>     8237f8bc4f6e ("irqchip: add a SiFive PLIC driver")
>     a93f1d903fa3 ("irqchip: Add driver for Loongson-3 HyperTransport PIC controller")
>     b74416dba33b ("irqchip: Define EXYNOS_IRQ_COMBINER")
>     c2ba80af4805 ("dt-bindings/goldfish-pic: Add device tree binding for Goldfish PIC driver")
>     c94fb639d546 ("irqchip: Add Kconfig menu")
>     dbb152267908 ("irqchip: Add driver for Loongson I/O Local Interrupt Controller")
>     ef8c01eb64ca ("irqchip: Add Loongson PCH PIC controller")
>     f20cc9b00c7b ("irqchip/qcom: Add IRQ combiner driver")
>     f22d9cdcb5eb ("rtc: goldfish: Add RTC driver for Android emulator")
>     f48e699ddf70 ("irqchip/aspeed-i2c-ic: Add I2C IRQ controller for Aspeed")
>     f55c73aef890 ("irqchip/pdc: Add PDC interrupt controller for QCOM SoCs")
>
> v4.4.235: Failed to apply! Possible dependencies:
>     19afc3d269fe ("irqchip: i8259: Allow platforms to override poll function")
>     1fa70c7f4913 ("ARM: exynos: Enable exynos-chipid driver")
>     3900d6a85e66 ("ARM: EXYNOS: Split up exynos5250 SoC specific PMU data")
>     4134b762eb13 ("ARM: exynos: Enable exynos-asv driver for ARCH_EXYNOS")
>     73d72ed8e98c ("ARM: EXYNOS: Split up exynos4 SoC specific PMU data")
>     818e915fbac5 ("irqchip: Add Loongson HyperTransport Vector support")
>     8438aef01d35 ("ARM: EXYNOS: Remove redundant code from regs-pmu.h")
>     a93f1d903fa3 ("irqchip: Add driver for Loongson-3 HyperTransport PIC controller")
>     b74416dba33b ("irqchip: Define EXYNOS_IRQ_COMBINER")
>     bfce552d0b10 ("drivers: soc: Add support for Exynos PMU driver")
>     c21100c94dfa ("ARM: EXYNOS: Split up exynos3250 SoC specific PMU data")
>     d3bafff78331 ("ARM: EXYNOS: Enable ARCH_SUPPORTS_BIG_ENDIAN explicitly")
>     dbb152267908 ("irqchip: Add driver for Loongson I/O Local Interrupt Controller")
>     e32465429490 ("ARM: use "depends on" for SoC configs instead of "if" after prompt")
>     ef8c01eb64ca ("irqchip: Add Loongson PCH PIC controller")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
This patch is only needed in 5.8+

Huacai
>
> --
> Thanks
> Sasha
