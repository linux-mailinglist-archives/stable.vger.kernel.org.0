Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B251316279D
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 15:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgBROD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 09:03:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726571AbgBROD3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 09:03:29 -0500
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF93521D56;
        Tue, 18 Feb 2020 14:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582034608;
        bh=WDPWzQ9h06fO5BvQ/cXq3ZJUz8r0IeTu9pkb16Fh47I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oY5ZNRvQUQobu6kwPBPXoeC4/aFklIPIxJEKQEkk5wrPQbRZpOGXG0U4gmWYVbgtT
         QtWPNy+TOXKQk5xZK2/a1f2C63V1n+33kEeDkBtOEswxONkG7TxrnewcMK1qJR7tqz
         pwWOx6TCOCeNyx1NyJvhUQip4UA0gxC8KgQBoYrA=
Received: by mail-lj1-f177.google.com with SMTP id q8so23022913ljj.11;
        Tue, 18 Feb 2020 06:03:27 -0800 (PST)
X-Gm-Message-State: APjAAAVK0TQeFKpiBD0WJhohrLEVvIw8Z4utm2aYtIdwIFI5kXdU9/Em
        Vu5eVhWOhxPVhxbTR7MGGfXkUUMf/m0ux9zFbX4=
X-Google-Smtp-Source: APXvYqyu3tqs7d1o1hFLIjDMvfhUSPaiuzZqw9hBKx+J7cxJ471R62AqtfhLJ1T448/LUKRaWkGxI1cFe0kSw+ndYy8=
X-Received: by 2002:a2e:9c85:: with SMTP id x5mr13224473lji.50.1582034605913;
 Tue, 18 Feb 2020 06:03:25 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYsxGkwOQYhuxwOZMwJi=1v4qc+cZ8PZgV6MczFNjo84HQ@mail.gmail.com>
 <20200213151540.GA3502153@kroah.com>
In-Reply-To: <20200213151540.GA3502153@kroah.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Tue, 18 Feb 2020 15:03:14 +0100
X-Gmail-Original-Message-ID: <CAJKOXPew3gu8=vTPUZB7mk5L08WRdWWYcJQtkG3YgohzDhRkVA@mail.gmail.com>
Message-ID: <CAJKOXPew3gu8=vTPUZB7mk5L08WRdWWYcJQtkG3YgohzDhRkVA@mail.gmail.com>
Subject: Re: stable-rc 5.4: arm64 make dtbs failed
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, agross@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 13 Feb 2020 at 16:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Feb 13, 2020 at 08:38:07PM +0530, Naresh Kamboju wrote:
> > # make -sk KBUILD_BUILD_USER=TuxBuild -C/linux ARCH=arm64
> > CROSS_COMPILE=aarch64-linux-gnu- HOSTCC=gcc CC="sccache
> > aarch64-linux-gnu-gcc" O=build dtbs
> >
> >
> > ../arch/arm64/boot/dts/exynos/exynos5433.dtsi:254.3-29: Warning
> > (reg_format): /gpu@14ac0000:reg: property has invalid length (8 bytes)
> > (#address-cells == 2, #size-cells == 2)
> > arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning
> > (pci_device_bus_num): Failed prerequisite 'reg_format'
> > arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (i2c_bus_reg):
> > Failed prerequisite 'reg_format'
> > arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (spi_bus_reg):
> > Failed prerequisite 'reg_format'
> > ../arch/arm64/boot/dts/exynos/exynos5433.dtsi:254.3-29: Warning
> > (reg_format): /gpu@14ac0000:reg: property has invalid length (8 bytes)
> > (#address-cells == 2, #size-cells == 2)
> > arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning
> > (pci_device_bus_num): Failed prerequisite 'reg_format'
> > arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (i2c_bus_reg):
> > Failed prerequisite 'reg_format'
> > arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (spi_bus_reg):
> > Failed prerequisite 'reg_format'
> > ../arch/arm64/boot/dts/exynos/exynos7.dtsi:83.3-29: Warning
> > (reg_format): /gpu@14ac0000:reg: property has invalid length (8 bytes)
> > (#address-cells == 2, #size-cells == 2)
> > arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning
> > (pci_device_bus_num): Failed prerequisite 'reg_format'
> > arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning
> > (i2c_bus_reg): Failed prerequisite 'reg_format'
> > arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning
> > (spi_bus_reg): Failed prerequisite 'reg_format'
> > ../arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi:10.10-13.4: ERROR
> > (path_references): /aliases: Reference to non-existent node or label
> > "blsp1_uart3"
>
> Thanks for the notice, I'll go drop the offending patch.

The backport is needed but the prerequisites are missing for v5.3 and newer:
   Cc: <stable@vger.kernel.org> # 5.3.x: 72ddcf6aa224 arm64: dts:
exynos: Move GPU under /soc node for Exynos5433
   Cc: <stable@vger.kernel.org> # 5.3.x: ede87c3a2bdb arm64: dts:
exynos: Move GPU under /soc node for Exynos7

Best regards,
Krzysztof
