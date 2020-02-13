Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4B215C10A
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbgBMPIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:08:23 -0500
Received: from mail-lj1-f178.google.com ([209.85.208.178]:46249 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbgBMPIX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 10:08:23 -0500
Received: by mail-lj1-f178.google.com with SMTP id x14so6957277ljd.13
        for <stable@vger.kernel.org>; Thu, 13 Feb 2020 07:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ee3GiJH577lg4OY0wM/xXf9Ee0smp8wTuy1Kt6Kxyhw=;
        b=JZeUUNWM13eWdOmRSQp9k9sdhZx/TJEin/ByaULHziiBPHEmI9T9Zsvx8lwaVyoPO/
         VaSNqryIHsoUv0qdIVghhaHGZ5YE4Kn2ZXOPDTM7rGSH45GGa2TMRaQ0ki5CESdszK5v
         wUhBgb44im56N11L5k3kBh++rCK9jS7WF6Y8PcZXyhRHmJGxisA/JTxAxYFoOoRPNxh4
         tq5RCfRDdLpgwBfaHR/ERAJg+aaC2UPpVRNqUZGO6Ji36L95jzDNk8v2kH5dCan3Af/u
         ppUINnczbX/08gkNp9fdHeOeycatSjfOOSCmBz/X0Sg3Wgb/3j1LqVVH/C+Wid5Gpbh3
         +oVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ee3GiJH577lg4OY0wM/xXf9Ee0smp8wTuy1Kt6Kxyhw=;
        b=Bdz+N+rAMioe2eYeU5wOZKyCnKVhPTkURVkCZ/wI5Jxs+ah2WcacBaq3pCzL/H0tol
         90KCKfGR2boSQvMKkz0BkjgHtch0hlSOTHCH0eynx/PM+lclhiYapCBjNVDTVEt0BiXz
         +GMlbPnlNu5/XuBO/dMBYahmMYh6ZPpURpA1YD16F4NfbLx6i+FTybTBXGEUdLS1UGaY
         MuXag32f1ZsHiO8RRn3ypyxFcOvYkYRKYOius18Q86c7h4CovriO7/jSBzEm+p5ez4OZ
         oKzcB5RjD9TA+dCEw54ioHXMcxue68fcUO41qasaexKchQpBu3UrIDQGMEBXGmyZ8jRS
         hjOw==
X-Gm-Message-State: APjAAAU7Zl0xttrMK4nktgmybv7q5gYw12BHxV565LYZ/+YFrjmZ4gXA
        QUUMm86cjq+/zaOnkXXkn+TtNN1+8tsDMuB9JHontA==
X-Google-Smtp-Source: APXvYqwViHloSrWiho2QMtHCGc3xN17HyL+4UdJATCgdO7LA+fzGLegBLXjGlZU44h+dsmkp0buMYHBKj+IWlY4aVHo=
X-Received: by 2002:a2e:e12:: with SMTP id 18mr11682234ljo.123.1581606500827;
 Thu, 13 Feb 2020 07:08:20 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 13 Feb 2020 20:38:07 +0530
Message-ID: <CA+G9fYsxGkwOQYhuxwOZMwJi=1v4qc+cZ8PZgV6MczFNjo84HQ@mail.gmail.com>
Subject: stable-rc 5.4: arm64 make dtbs failed
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-samsung-soc@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, agross@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

# make -sk KBUILD_BUILD_USER=TuxBuild -C/linux ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu- HOSTCC=gcc CC="sccache
aarch64-linux-gnu-gcc" O=build dtbs


../arch/arm64/boot/dts/exynos/exynos5433.dtsi:254.3-29: Warning
(reg_format): /gpu@14ac0000:reg: property has invalid length (8 bytes)
(#address-cells == 2, #size-cells == 2)
arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning
(pci_device_bus_num): Failed prerequisite 'reg_format'
arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (i2c_bus_reg):
Failed prerequisite 'reg_format'
arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (spi_bus_reg):
Failed prerequisite 'reg_format'
../arch/arm64/boot/dts/exynos/exynos5433.dtsi:254.3-29: Warning
(reg_format): /gpu@14ac0000:reg: property has invalid length (8 bytes)
(#address-cells == 2, #size-cells == 2)
arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning
(pci_device_bus_num): Failed prerequisite 'reg_format'
arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (i2c_bus_reg):
Failed prerequisite 'reg_format'
arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (spi_bus_reg):
Failed prerequisite 'reg_format'
../arch/arm64/boot/dts/exynos/exynos7.dtsi:83.3-29: Warning
(reg_format): /gpu@14ac0000:reg: property has invalid length (8 bytes)
(#address-cells == 2, #size-cells == 2)
arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning
(pci_device_bus_num): Failed prerequisite 'reg_format'
arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning
(i2c_bus_reg): Failed prerequisite 'reg_format'
arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning
(spi_bus_reg): Failed prerequisite 'reg_format'
../arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi:10.10-13.4: ERROR
(path_references): /aliases: Reference to non-existent node or label
"blsp1_uart3"

ERROR: Input tree has errors, aborting (use -f to force output)
make[3]: *** [scripts/Makefile.lib:299:
arch/arm64/boot/dts/qcom/msm8998-mtp.dtb] Error 2

ref:
https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/435619179

-- 
Linaro LKFT
https://lkft.linaro.org
