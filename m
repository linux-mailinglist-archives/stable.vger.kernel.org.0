Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E155715C131
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbgBMPPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:15:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727163AbgBMPPl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:15:41 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96BF52168B;
        Thu, 13 Feb 2020 15:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581606940;
        bh=Wa++UXcaTTd5txMUfjV4DpYjH7laEO8r+6+IdRw6vgI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IEpcxp4lr9mfOTEf/UXaZC9RMhgaF5/9q12kkMKiAmaXVNh6WvFdMJK5DiwLt5606
         G84NAY+qL7U6t/CKytpJs+OW3H7nf0YQMyvRMj9GdvYe83NEpYjRBUZ8lx0+j7RONy
         2PI4tt316/V1A8wV0aaN4DNtSeWU/nlTrqmzDxqA=
Date:   Thu, 13 Feb 2020 07:15:40 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-samsung-soc@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, agross@kernel.org
Subject: Re: stable-rc 5.4: arm64 make dtbs failed
Message-ID: <20200213151540.GA3502153@kroah.com>
References: <CA+G9fYsxGkwOQYhuxwOZMwJi=1v4qc+cZ8PZgV6MczFNjo84HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsxGkwOQYhuxwOZMwJi=1v4qc+cZ8PZgV6MczFNjo84HQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 08:38:07PM +0530, Naresh Kamboju wrote:
> # make -sk KBUILD_BUILD_USER=TuxBuild -C/linux ARCH=arm64
> CROSS_COMPILE=aarch64-linux-gnu- HOSTCC=gcc CC="sccache
> aarch64-linux-gnu-gcc" O=build dtbs
> 
> 
> ../arch/arm64/boot/dts/exynos/exynos5433.dtsi:254.3-29: Warning
> (reg_format): /gpu@14ac0000:reg: property has invalid length (8 bytes)
> (#address-cells == 2, #size-cells == 2)
> arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning
> (pci_device_bus_num): Failed prerequisite 'reg_format'
> arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (i2c_bus_reg):
> Failed prerequisite 'reg_format'
> arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (spi_bus_reg):
> Failed prerequisite 'reg_format'
> ../arch/arm64/boot/dts/exynos/exynos5433.dtsi:254.3-29: Warning
> (reg_format): /gpu@14ac0000:reg: property has invalid length (8 bytes)
> (#address-cells == 2, #size-cells == 2)
> arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning
> (pci_device_bus_num): Failed prerequisite 'reg_format'
> arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (i2c_bus_reg):
> Failed prerequisite 'reg_format'
> arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (spi_bus_reg):
> Failed prerequisite 'reg_format'
> ../arch/arm64/boot/dts/exynos/exynos7.dtsi:83.3-29: Warning
> (reg_format): /gpu@14ac0000:reg: property has invalid length (8 bytes)
> (#address-cells == 2, #size-cells == 2)
> arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning
> (pci_device_bus_num): Failed prerequisite 'reg_format'
> arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning
> (i2c_bus_reg): Failed prerequisite 'reg_format'
> arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning
> (spi_bus_reg): Failed prerequisite 'reg_format'
> ../arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi:10.10-13.4: ERROR
> (path_references): /aliases: Reference to non-existent node or label
> "blsp1_uart3"

Thanks for the notice, I'll go drop the offending patch.

greg k-h
