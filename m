Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8C9D35305
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfFDXTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:19:41 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:41908 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDXTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 19:19:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:Subject:To:From:
        Sender:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=V8wBy63Rs2/KxkA9h0zPvlYs0bL1AG6jqRWL7W17uO0=; b=cQtFmJl88TDCix2yVafBPw/sw
        LbYG2kyLtjruSrZwCQ97Zh7TgxOZxzZUvYeOi/Vs3ZU38hhdWfhWh0YkMyvcEa6Zf8nCUppkdyOw3
        EU7lvMpY0+IKirGllRUfUrRiBNjp4S2om54l1CrqETgVMyDRfjUORI1epjHyhRkVFpllE=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=optimist)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hYIiI-0006tN-NQ; Tue, 04 Jun 2019 23:19:30 +0000
Received: from broonie by optimist with local (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hYIiI-0000cT-1a; Wed, 05 Jun 2019 00:19:30 +0100
From:   Build bot for Mark Brown <broonie@kernel.org>
To:     kernel-build-reports@lists.linaro.org,
        linaro-kernel@lists.linaro.org, stable@vger.kernel.org
Subject: v4.14.123 build: 8 failures 2 warnings (v4.14.123)
Message-Id: <E1hYIiI-0000cT-1a@optimist>
Date:   Wed, 05 Jun 2019 00:19:30 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tree/Branch: v4.14.123
Git describe: v4.14.123
Commit: 8cb1239889 Linux 4.14.123

Build Time: 1 min 44 sec

Passed:    3 / 11   ( 27.27 %)
Failed:    8 / 11   ( 72.73 %)

Errors: 154
Warnings: 2
Section Mismatches: 0

Failed defconfigs:
	arm64-allnoconfig
	arm64-allmodconfig
	arm-allmodconfig
	arm64-defconfig

Errors:

	arm64-allnoconfig
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:31:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:36:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:41:31: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?

	arm64-allmodconfig
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:31:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:36:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:41:31: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?

	arm-allmodconfig
Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:202.1-6 Label or path cpu1 not found
Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:206.1-6 Label or path cpu2 not found
Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:210.1-6 Label or path cpu3 not found
Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:238.1-5 Label or path gpu not found
Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:705.1-6 Label or path vop0 not found
Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:709.1-10 Label or path vop0_out not found
Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:715.1-6 Label or path vop1 not found
Error: ../arch/arm/boot/dts/at91-wb45n.dtsi:30.1-18 Label or path reset_controller not found
Error: ../arch/arm/boot/dts/at91-wb45n.dtsi:34.1-21 Label or path shutdown_controller not found
Error: ../arch/arm/boot/dts/at91-wb45n.dtsi:157.1-9 Label or path pinctrl not found
Error: ../arch/arm/boot/dts/at91-wb45n.dts:30.1-10 Label or path watchdog not found
Error: ../arch/arm/boot/dts/at91-wb50n.dtsi:25.1-9 Label or path pinctrl not found
Error: ../arch/arm/boot/dts/at91-wb50n.dts:61.1-10 Label or path watchdog not found
Error: ../arch/arm/boot/dts/imx51-zii-scu2-mezz.dts:346.1-5 Label or path vpu not found
Error: ../arch/arm/boot/dts/imx6ull-colibri.dtsi:490.4-5 syntax error
Error: ../arch/arm/boot/dts/meson8m2.dtsi:25.19-20 syntax error
Error: ../arch/arm/boot/dts/imx6dl-mamoj.dts:491.10-492.1 syntax error
Error: ../arch/arm/boot/dts/imx53-ppd.dts:596.1-5 Label or path pmu not found
Error: ../arch/arm/boot/dts/berlin2cd-valve-steamlink.dts:29.1-5 Label or path cpu not found
Error: ../arch/arm/boot/dts/berlin2cd-valve-steamlink.dts:37.1-6 Label or path i2c0 not found
Error: ../arch/arm/boot/dts/iwg20d-q7-common.dtsi:80.21-22 syntax error
../arch/arm/boot/dts/aspeed-bmc-quanta-q71l.dts:4:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
Error: ../arch/arm/boot/dts/mt7623n-rfb-emmc.dts:109.1-6 Label or path btif not found
Error: ../arch/arm/boot/dts/mt7623n-rfb-emmc.dts:254.1-6 Label or path pcie not found
Error: ../arch/arm/boot/dts/mt7623n-rfb-emmc.dts:268.1-11 Label or path pcie0_phy not found
Error: ../arch/arm/boot/dts/mt7623n-rfb-emmc.dts:272.1-11 Label or path pcie1_phy not found
Error: ../arch/arm/boot/dts/at91-som60.dtsi:34.1-9 Label or path pinctrl not found
Error: ../arch/arm/boot/dts/at91-dvk_su60_somc_lcm.dtsi:50.1-9 Label or path pinctrl not found
../arch/arm/boot/dts/aspeed-bmc-facebook-tiogapass.dts:7:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
../arch/arm/boot/dts/pxa300-raumfeld-tuneable-clock.dtsi:3:45: fatal error: dt-bindings/clock/maxim,max9485.h: No such file or directory
../arch/arm/boot/dts/mt7623a.dtsi:9:45: fatal error: dt-bindings/power/mt7623a-power.h: No such file or directory
Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:29.1-6 Label or path cmt0 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:60.1-8 Label or path mmcif0 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:70.1-6 Label or path qspi not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:91.1-6 Label or path rwdt not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:96.1-7 Label or path sdhi1 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:106.1-6 Label or path i2c3 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:84.1-5 Label or path avb not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:103.1-6 Label or path can0 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:118.1-7 Label or path hsusb not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:124.1-6 Label or path i2c5 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:141.1-6 Label or path pci1 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:195.1-12 Label or path rcar_sound not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:219.1-7 Label or path sdhi0 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:229.1-6 Label or path ssi4 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:233.1-8 Label or path usbphy not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm-dbhd-ca.dts:39.1-4 Label or path du not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm-dbhd-ca.dts:54.1-6 Label or path can1 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm-dbhd-ca.dts:68.1-6 Label or path i2c1 not found
Error: ../arch/arm/boot/dts/exynos4412-midas.dtsi:337.1-8 Label or path camera not found
../arch/arm/boot/dts/aspeed-bmc-inspur-on5263m5.dts:6:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
../arch/arm/boot/dts/bcm283x-rpi-lan7515.dtsi:2:47: fatal error: dt-bindings/net/microchip-lan78xx.h: No such file or directory
Error: ../arch/arm/boot/dts/imx6qdl-emcon.dtsi:813.1-6 Label or path cpu0 not found
Error: ../arch/arm/boot/dts/sun8i-h2-plus-bananapi-m2-zero.dts:75.1-6 Label or path cpu0 not found
Error: ../arch/arm/boot/dts/bcm2836-rpi.dtsi:4.1-7 Label or path vchiq not found
Error: ../arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts:93.1-4 Label or path de not found
Error: ../arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts:122.1-6 Label or path hdmi not found
Error: ../arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts:126.1-10 Label or path hdmi_out not found
Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:231.1-6 Label or path ssp1 not found
Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:235.1-6 Label or path ssp2 not found
Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:239.1-17 Label or path nand_controller not found
Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:343.4-5 syntax error
../arch/arm/boot/dts/r9a06g032.dtsi:10:49: fatal error: dt-bindings/clock/r9a06g032-sysctrl.h: No such file or directory
Error: ../arch/arm/boot/dts/am335x-guardian.dts:246.48-49 syntax error
Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:127.1-6 Label or path cpu0 not found
Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:131.1-4 Label or path de not found
Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:151.1-6 Label or path emac not found
Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:158.1-6 Label or path hdmi not found
Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:162.1-10 Label or path hdmi_out not found
../arch/arm/boot/dts/r7s9210.dtsi:10:48: fatal error: dt-bindings/clock/r7s9210-cpg-mssr.h: No such file or directory
Error: ../arch/arm/boot/dts/at91-nattis-2-natte-2.dts:146.1-9 Label or path pinctrl not found
Error: ../arch/arm/boot/dts/at91-nattis-2-natte-2.dts:178.1-10 Label or path watchdog not found
Error: ../arch/arm/boot/dts/imx51-zii-scu3-esb.dts:354.1-5 Label or path vpu not found
Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:127.1-6 Label or path cpu0 not found
Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:131.1-4 Label or path de not found
Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:151.1-6 Label or path emac not found
Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:158.1-6 Label or path hdmi not found
Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:162.1-10 Label or path hdmi_out not found
../arch/arm/boot/dts/r8a7744.dtsi:10:48: fatal error: dt-bindings/clock/r8a7744-cpg-mssr.h: No such file or directory
../arch/arm/boot/dts/imx7ulp.dtsi:8:45: fatal error: dt-bindings/clock/imx7ulp-clock.h: No such file or directory
Error: ../arch/arm/boot/dts/at91-wb50n.dtsi:25.1-9 Label or path pinctrl not found
Error: ../arch/arm/boot/dts/at91-gatwick.dts:72.1-9 Label or path pinctrl not found
Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:134.1-6 Label or path i2c0 not found
Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:141.1-6 Label or path i2c1 not found
Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:203.1-6 Label or path i2c2 not found
Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:265.1-6 Label or path i2c3 not found
Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:272.1-6 Label or path i2c4 not found
Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:279.1-6 Label or path i2c5 not found
Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:286.1-6 Label or path i2c6 not found
Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:293.1-6 Label or path i2c7 not found
Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:300.1-6 Label or path i2c8 not found
Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:362.1-7 Label or path i2c13 not found
../arch/arm/boot/dts/stm32mp157c.dtsi:7:45: fatal error: dt-bindings/clock/stm32mp1-clks.h: No such file or directory
../arch/arm/boot/dts/imx6sll.dtsi:8:45: fatal error: dt-bindings/clock/imx6sll-clock.h: No such file or directory
Error: ../arch/arm/boot/dts/bcm2836-rpi.dtsi:4.1-7 Label or path vchiq not found
Error: ../arch/arm/boot/dts/imx31-lite.dts:38.1-5 Label or path ata not found
Error: ../arch/arm/boot/dts/imx31-lite.dts:42.1-5 Label or path nfc not found
Error: ../arch/arm/boot/dts/imx31-lite.dts:49.1-8 Label or path sdhci1 not found
Error: ../arch/arm/boot/dts/imx31-lite.dts:56.1-6 Label or path spi2 not found
Error: ../arch/arm/boot/dts/imx31-lite.dts:157.1-6 Label or path weim not found
../arch/arm/boot/dts/aspeed-bmc-opp-lanyang.dts:6:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
Error: ../arch/arm/boot/dts/imx6q-icore-mipi.dts:27.1-8 Label or path ov5640 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:29.1-6 Label or path cmt0 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:60.1-8 Label or path mmcif0 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:70.1-6 Label or path qspi not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:91.1-6 Label or path rwdt not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:96.1-7 Label or path sdhi1 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:106.1-6 Label or path i2c3 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:84.1-5 Label or path avb not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:103.1-6 Label or path can0 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:118.1-7 Label or path hsusb not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:124.1-6 Label or path i2c5 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:141.1-6 Label or path pci1 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:195.1-12 Label or path rcar_sound not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:219.1-7 Label or path sdhi0 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:229.1-6 Label or path ssi4 not found
Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:233.1-8 Label or path usbphy not found
../arch/arm/boot/dts/pxa300-raumfeld-tuneable-clock.dtsi:3:45: fatal error: dt-bindings/clock/maxim,max9485.h: No such file or directory
../arch/arm/boot/dts/r8a7744.dtsi:10:48: fatal error: dt-bindings/clock/r8a7744-cpg-mssr.h: No such file or directory
Error: ../arch/arm/boot/dts/imx6ul-14x14-evk.dtsi:519.4-5 syntax error
Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:131.1-6 Label or path cpu0 not found
Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:135.1-8 Label or path cpu100 not found
Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:139.1-4 Label or path de not found
Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:197.1-5 Label or path pwm not found
Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:388.1-7 Label or path tcon0 not found
Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:393.1-11 Label or path tcon0_out not found
Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:407.1-7 Label or path uart1 not found
../arch/arm/boot/dts/aspeed-bmc-arm-stardragon4800-rep2.dts:5:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
../arch/arm/boot/dts/aspeed-bmc-portwell-neptune.dts:6:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
../arch/arm/boot/dts/stm32mp157c.dtsi:7:45: fatal error: dt-bindings/clock/stm32mp1-clks.h: No such file or directory
Error: ../arch/arm/boot/dts/exynos4412-midas.dtsi:337.1-8 Label or path camera not found
Error: ../arch/arm/boot/dts/imx51-zii-rdu1.dts:565.1-15 Label or path ipu_di0_disp1 not found
Error: ../arch/arm/boot/dts/imx51-zii-rdu1.dts:569.1-5 Label or path pmu not found
Error: ../arch/arm/boot/dts/sun8i-h3-orangepi-zero-plus2.dts:88.1-4 Label or path de not found
Error: ../arch/arm/boot/dts/sun8i-h3-orangepi-zero-plus2.dts:92.1-6 Label or path hdmi not found
Error: ../arch/arm/boot/dts/sun8i-h3-orangepi-zero-plus2.dts:96.1-10 Label or path hdmi_out not found
../arch/arm/boot/dts/pxa300-raumfeld-tuneable-clock.dtsi:3:45: fatal error: dt-bindings/clock/maxim,max9485.h: No such file or directory
../arch/arm/boot/dts/aspeed-bmc-opp-witherspoon.dts:4:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
Error: ../arch/arm/boot/dts/am3874-iceboard.dts:415.1-7 Label or path gpio3 not found
Error: ../arch/arm/boot/dts/am3874-iceboard.dts:423.1-7 Label or path gpio4 not found
Error: ../arch/arm/boot/dts/am3874-iceboard.dts:482.1-8 Label or path mcspi3 not found
Error: ../arch/arm/boot/dts/am3874-iceboard.dts:489.1-8 Label or path mcspi4 not found
Error: ../arch/arm/boot/dts/r8a7790-stout.dts:96.17-18 syntax error
../arch/arm/boot/dts/aspeed-bmc-arm-centriq2400-rep.dts:5:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
../arch/arm/boot/dts/pxa300-raumfeld-tuneable-clock.dtsi:3:45: fatal error: dt-bindings/clock/maxim,max9485.h: No such file or directory
Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:82.1-6 Label or path i2c1 not found
Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:86.1-6 Label or path i2c2 not found
Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:90.1-6 Label or path i2c3 not found
Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:94.1-6 Label or path i2c4 not found
Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:98.1-6 Label or path i2c5 not found
Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:102.1-6 Label or path i2c6 not found
Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:106.1-6 Label or path i2c7 not found
Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:110.1-7 Label or path i2c13 not found
Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:122.1-11 Label or path pwm_tacho not found
Error: ../arch/arm/boot/dts/meson8b-ec100.dts:216.1-6 Label or path cpu0 not found
Error: ../arch/arm/boot/dts/meson8b-ec100.dts:268.1-6 Label or path sdio not found
Error: ../arch/arm/boot/dts/sun8i-h3-mapleboard-mp130.dts:78.1-6 Label or path emac not found
Error: ../arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi:111.1-4 Label or path de not found
Error: ../arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi:127.1-6 Label or path emac not found
Error: ../arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi:137.1-15 Label or path external_mdio not found
Error: ../arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi:144.1-6 Label or path hdmi not found
Error: ../arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi:148.1-10 Label or path hdmi_out not found
Error: ../arch/arm/boot/dts/sunxi-bananapi-m2-plus-v1.2.dtsi:29.1-6 Label or path cpu0 not found
Error: ../arch/arm/boot/dts/rv1108-elgin-r1.dts:51.1-6 Label or path gmac not found
../arch/arm/boot/dts/mt7623a.dtsi:9:45: fatal error: dt-bindings/power/mt7623a-power.h: No such file or directory
Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:231.1-6 Label or path ssp1 not found
Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:235.1-6 Label or path ssp2 not found
Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:239.1-17 Label or path nand_controller not found
Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:343.4-5 syntax error
Error: ../arch/arm/boot/dts/imx6qdl-var-dart.dtsi:213.4-5 syntax error
Error: ../arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts:93.1-4 Label or path de not found
Error: ../arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts:122.1-6 Label or path hdmi not found
Error: ../arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts:126.1-10 Label or path hdmi_out not found
../arch/arm/boot/dts/r8a77470.dtsi:10:49: fatal error: dt-bindings/clock/r8a77470-cpg-mssr.h: No such file or directory
Error: ../arch/arm/boot/dts/exynos4412-midas.dtsi:337.1-8 Label or path camera not found
Error: ../arch/arm/boot/dts/am335x-osd3358-sm-red.dts:459.48-49 syntax error
Error: ../arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts:200.21-22 syntax error
Error: ../arch/arm/boot/dts/imx6ull-colibri.dtsi:490.4-5 syntax error
../arch/arm/boot/dts/aspeed-bmc-opp-zaius.dts:4:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
Error: ../arch/arm/boot/dts/ls1021a-moxa-uc-8410a.dts:206.1-6 Label or path qspi not found
Error: ../arch/arm/boot/dts/armada-385-db-88f6820-amc.dts:94.1-17 Label or path nand_controller not found
ERROR: Input tree has errors, aborting (use -f to force output)
ERROR: Input tree has errors, aborting (use -f to force output)
ERROR: Input tree has errors, aborting (use -f to force output)
ERROR: Input tree has errors, aborting (use -f to force output)
ERROR: Input tree has errors, aborting (use -f to force output)
ERROR: Input tree has errors, aborting (use -f to force output)
ERROR: Input tree has errors, aborting (use -f to force output)
ERROR: Input tree has errors, aborting (use -f to force output)
ERROR: Input tree has errors, aborting (use -f to force output)
ERROR: Input tree has errors, aborting (use -f to force output)
ERROR: Input tree has errors, aborting (use -f to force output)
ERROR: Input tree has errors, aborting (use -f to force output)
ERROR: Input tree has errors, aborting (use -f to force output)
ERROR: Input tree has errors, aborting (use -f to force output)
ERROR: Input tree has errors, aborting (use -f to force output)
ERROR: Input tree has errors, aborting (use -f to force output)
ERROR: Input tree has errors, aborting (use -f to force output)
ERROR: Input tree has errors, aborting (use -f to force output)

	arm64-defconfig
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:31:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:36:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:41:31: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?

-------------------------------------------------------------------------------
defconfigs with issues (other than build errors):
      1 warnings    0 mismatches  : arm64-allnoconfig
      1 warnings    0 mismatches  : arm64-allmodconfig
      1 warnings    0 mismatches  : x86_64-defconfig
      1 warnings    0 mismatches  : x86_64-allmodconfig
      1 warnings    0 mismatches  : arm64-defconfig

-------------------------------------------------------------------------------

Errors summary: 154
	 18 ERROR: Input tree has errors, aborting (use -f to force output)
	 15 ../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	 15 ../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	 15 ../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	 12 ../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	 12 ../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	 12 ../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	 12 ../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	  4 ../arch/arm/boot/dts/pxa300-raumfeld-tuneable-clock.dtsi:3:45: fatal error: dt-bindings/clock/maxim,max9485.h: No such file or directory
	  3 Error: ../arch/arm/boot/dts/exynos4412-midas.dtsi:337.1-8 Label or path camera not found
	  3 ../arch/arm64/include/asm/preempt.h:41:31: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	  3 ../arch/arm64/include/asm/preempt.h:36:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	  3 ../arch/arm64/include/asm/preempt.h:31:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	  2 Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:162.1-10 Label or path hdmi_out not found
	  2 Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:158.1-6 Label or path hdmi not found
	  2 Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:151.1-6 Label or path emac not found
	  2 Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:131.1-4 Label or path de not found
	  2 Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:127.1-6 Label or path cpu0 not found
	  2 Error: ../arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts:93.1-4 Label or path de not found
	  2 Error: ../arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts:126.1-10 Label or path hdmi_out not found
	  2 Error: ../arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts:122.1-6 Label or path hdmi not found
	  2 Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:96.1-7 Label or path sdhi1 not found
	  2 Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:91.1-6 Label or path rwdt not found
	  2 Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:70.1-6 Label or path qspi not found
	  2 Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:60.1-8 Label or path mmcif0 not found
	  2 Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:29.1-6 Label or path cmt0 not found
	  2 Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:106.1-6 Label or path i2c3 not found
	  2 Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:84.1-5 Label or path avb not found
	  2 Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:233.1-8 Label or path usbphy not found
	  2 Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:229.1-6 Label or path ssi4 not found
	  2 Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:219.1-7 Label or path sdhi0 not found
	  2 Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:195.1-12 Label or path rcar_sound not found
	  2 Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:141.1-6 Label or path pci1 not found
	  2 Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:124.1-6 Label or path i2c5 not found
	  2 Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:118.1-7 Label or path hsusb not found
	  2 Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:103.1-6 Label or path can0 not found
	  2 Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:343.4-5 syntax error
	  2 Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:239.1-17 Label or path nand_controller not found
	  2 Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:235.1-6 Label or path ssp2 not found
	  2 Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:231.1-6 Label or path ssp1 not found
	  2 Error: ../arch/arm/boot/dts/imx6ull-colibri.dtsi:490.4-5 syntax error
	  2 Error: ../arch/arm/boot/dts/bcm2836-rpi.dtsi:4.1-7 Label or path vchiq not found
	  2 Error: ../arch/arm/boot/dts/at91-wb50n.dtsi:25.1-9 Label or path pinctrl not found
	  2 ../arch/arm/boot/dts/stm32mp157c.dtsi:7:45: fatal error: dt-bindings/clock/stm32mp1-clks.h: No such file or directory
	  2 ../arch/arm/boot/dts/r8a7744.dtsi:10:48: fatal error: dt-bindings/clock/r8a7744-cpg-mssr.h: No such file or directory
	  2 ../arch/arm/boot/dts/mt7623a.dtsi:9:45: fatal error: dt-bindings/power/mt7623a-power.h: No such file or directory
	  1 Error: ../arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi:148.1-10 Label or path hdmi_out not found
	  1 Error: ../arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi:144.1-6 Label or path hdmi not found
	  1 Error: ../arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi:137.1-15 Label or path external_mdio not found
	  1 Error: ../arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi:127.1-6 Label or path emac not found
	  1 Error: ../arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi:111.1-4 Label or path de not found
	  1 Error: ../arch/arm/boot/dts/sunxi-bananapi-m2-plus-v1.2.dtsi:29.1-6 Label or path cpu0 not found
	  1 Error: ../arch/arm/boot/dts/sun8i-h3-orangepi-zero-plus2.dts:96.1-10 Label or path hdmi_out not found
	  1 Error: ../arch/arm/boot/dts/sun8i-h3-orangepi-zero-plus2.dts:92.1-6 Label or path hdmi not found
	  1 Error: ../arch/arm/boot/dts/sun8i-h3-orangepi-zero-plus2.dts:88.1-4 Label or path de not found
	  1 Error: ../arch/arm/boot/dts/sun8i-h3-mapleboard-mp130.dts:78.1-6 Label or path emac not found
	  1 Error: ../arch/arm/boot/dts/sun8i-h2-plus-bananapi-m2-zero.dts:75.1-6 Label or path cpu0 not found
	  1 Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:407.1-7 Label or path uart1 not found
	  1 Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:393.1-11 Label or path tcon0_out not found
	  1 Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:388.1-7 Label or path tcon0 not found
	  1 Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:197.1-5 Label or path pwm not found
	  1 Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:139.1-4 Label or path de not found
	  1 Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:135.1-8 Label or path cpu100 not found
	  1 Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:131.1-6 Label or path cpu0 not found
	  1 Error: ../arch/arm/boot/dts/rv1108-elgin-r1.dts:51.1-6 Label or path gmac not found
	  1 Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:715.1-6 Label or path vop1 not found
	  1 Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:709.1-10 Label or path vop0_out not found
	  1 Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:705.1-6 Label or path vop0 not found
	  1 Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:238.1-5 Label or path gpu not found
	  1 Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:210.1-6 Label or path cpu3 not found
	  1 Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:206.1-6 Label or path cpu2 not found
	  1 Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:202.1-6 Label or path cpu1 not found
	  1 Error: ../arch/arm/boot/dts/r8a7790-stout.dts:96.17-18 syntax error
	  1 Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm-dbhd-ca.dts:68.1-6 Label or path i2c1 not found
	  1 Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm-dbhd-ca.dts:54.1-6 Label or path can1 not found
	  1 Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm-dbhd-ca.dts:39.1-4 Label or path du not found
	  1 Error: ../arch/arm/boot/dts/mt7623n-rfb-emmc.dts:272.1-11 Label or path pcie1_phy not found
	  1 Error: ../arch/arm/boot/dts/mt7623n-rfb-emmc.dts:268.1-11 Label or path pcie0_phy not found
	  1 Error: ../arch/arm/boot/dts/mt7623n-rfb-emmc.dts:254.1-6 Label or path pcie not found
	  1 Error: ../arch/arm/boot/dts/mt7623n-rfb-emmc.dts:109.1-6 Label or path btif not found
	  1 Error: ../arch/arm/boot/dts/meson8m2.dtsi:25.19-20 syntax error
	  1 Error: ../arch/arm/boot/dts/meson8b-ec100.dts:268.1-6 Label or path sdio not found
	  1 Error: ../arch/arm/boot/dts/meson8b-ec100.dts:216.1-6 Label or path cpu0 not found
	  1 Error: ../arch/arm/boot/dts/ls1021a-moxa-uc-8410a.dts:206.1-6 Label or path qspi not found
	  1 Error: ../arch/arm/boot/dts/iwg20d-q7-common.dtsi:80.21-22 syntax error
	  1 Error: ../arch/arm/boot/dts/imx6ul-14x14-evk.dtsi:519.4-5 syntax error
	  1 Error: ../arch/arm/boot/dts/imx6qdl-var-dart.dtsi:213.4-5 syntax error
	  1 Error: ../arch/arm/boot/dts/imx6qdl-emcon.dtsi:813.1-6 Label or path cpu0 not found
	  1 Error: ../arch/arm/boot/dts/imx6q-icore-mipi.dts:27.1-8 Label or path ov5640 not found
	  1 Error: ../arch/arm/boot/dts/imx6dl-mamoj.dts:491.10-492.1 syntax error
	  1 Error: ../arch/arm/boot/dts/imx53-ppd.dts:596.1-5 Label or path pmu not found
	  1 Error: ../arch/arm/boot/dts/imx51-zii-scu3-esb.dts:354.1-5 Label or path vpu not found
	  1 Error: ../arch/arm/boot/dts/imx51-zii-scu2-mezz.dts:346.1-5 Label or path vpu not found
	  1 Error: ../arch/arm/boot/dts/imx51-zii-rdu1.dts:569.1-5 Label or path pmu not found
	  1 Error: ../arch/arm/boot/dts/imx51-zii-rdu1.dts:565.1-15 Label or path ipu_di0_disp1 not found
	  1 Error: ../arch/arm/boot/dts/imx31-lite.dts:56.1-6 Label or path spi2 not found
	  1 Error: ../arch/arm/boot/dts/imx31-lite.dts:49.1-8 Label or path sdhci1 not found
	  1 Error: ../arch/arm/boot/dts/imx31-lite.dts:42.1-5 Label or path nfc not found
	  1 Error: ../arch/arm/boot/dts/imx31-lite.dts:38.1-5 Label or path ata not found
	  1 Error: ../arch/arm/boot/dts/imx31-lite.dts:157.1-6 Label or path weim not found
	  1 Error: ../arch/arm/boot/dts/berlin2cd-valve-steamlink.dts:37.1-6 Label or path i2c0 not found
	  1 Error: ../arch/arm/boot/dts/berlin2cd-valve-steamlink.dts:29.1-5 Label or path cpu not found
	  1 Error: ../arch/arm/boot/dts/at91-wb50n.dts:61.1-10 Label or path watchdog not found
	  1 Error: ../arch/arm/boot/dts/at91-wb45n.dtsi:34.1-21 Label or path shutdown_controller not found
	  1 Error: ../arch/arm/boot/dts/at91-wb45n.dtsi:30.1-18 Label or path reset_controller not found
	  1 Error: ../arch/arm/boot/dts/at91-wb45n.dtsi:157.1-9 Label or path pinctrl not found
	  1 Error: ../arch/arm/boot/dts/at91-wb45n.dts:30.1-10 Label or path watchdog not found
	  1 Error: ../arch/arm/boot/dts/at91-som60.dtsi:34.1-9 Label or path pinctrl not found
	  1 Error: ../arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts:200.21-22 syntax error
	  1 Error: ../arch/arm/boot/dts/at91-nattis-2-natte-2.dts:178.1-10 Label or path watchdog not found
	  1 Error: ../arch/arm/boot/dts/at91-nattis-2-natte-2.dts:146.1-9 Label or path pinctrl not found
	  1 Error: ../arch/arm/boot/dts/at91-gatwick.dts:72.1-9 Label or path pinctrl not found
	  1 Error: ../arch/arm/boot/dts/at91-dvk_su60_somc_lcm.dtsi:50.1-9 Label or path pinctrl not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:98.1-6 Label or path i2c5 not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:94.1-6 Label or path i2c4 not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:90.1-6 Label or path i2c3 not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:86.1-6 Label or path i2c2 not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:82.1-6 Label or path i2c1 not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:122.1-11 Label or path pwm_tacho not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:110.1-7 Label or path i2c13 not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:106.1-6 Label or path i2c7 not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:102.1-6 Label or path i2c6 not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:362.1-7 Label or path i2c13 not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:300.1-6 Label or path i2c8 not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:293.1-6 Label or path i2c7 not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:286.1-6 Label or path i2c6 not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:279.1-6 Label or path i2c5 not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:272.1-6 Label or path i2c4 not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:265.1-6 Label or path i2c3 not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:203.1-6 Label or path i2c2 not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:141.1-6 Label or path i2c1 not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:134.1-6 Label or path i2c0 not found
	  1 Error: ../arch/arm/boot/dts/armada-385-db-88f6820-amc.dts:94.1-17 Label or path nand_controller not found
	  1 Error: ../arch/arm/boot/dts/am3874-iceboard.dts:489.1-8 Label or path mcspi4 not found
	  1 Error: ../arch/arm/boot/dts/am3874-iceboard.dts:482.1-8 Label or path mcspi3 not found
	  1 Error: ../arch/arm/boot/dts/am3874-iceboard.dts:423.1-7 Label or path gpio4 not found
	  1 Error: ../arch/arm/boot/dts/am3874-iceboard.dts:415.1-7 Label or path gpio3 not found
	  1 Error: ../arch/arm/boot/dts/am335x-osd3358-sm-red.dts:459.48-49 syntax error
	  1 Error: ../arch/arm/boot/dts/am335x-guardian.dts:246.48-49 syntax error
	  1 ../arch/arm/boot/dts/r9a06g032.dtsi:10:49: fatal error: dt-bindings/clock/r9a06g032-sysctrl.h: No such file or directory
	  1 ../arch/arm/boot/dts/r8a77470.dtsi:10:49: fatal error: dt-bindings/clock/r8a77470-cpg-mssr.h: No such file or directory
	  1 ../arch/arm/boot/dts/r7s9210.dtsi:10:48: fatal error: dt-bindings/clock/r7s9210-cpg-mssr.h: No such file or directory
	  1 ../arch/arm/boot/dts/imx7ulp.dtsi:8:45: fatal error: dt-bindings/clock/imx7ulp-clock.h: No such file or directory
	  1 ../arch/arm/boot/dts/imx6sll.dtsi:8:45: fatal error: dt-bindings/clock/imx6sll-clock.h: No such file or directory
	  1 ../arch/arm/boot/dts/bcm283x-rpi-lan7515.dtsi:2:47: fatal error: dt-bindings/net/microchip-lan78xx.h: No such file or directory
	  1 ../arch/arm/boot/dts/aspeed-bmc-quanta-q71l.dts:4:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
	  1 ../arch/arm/boot/dts/aspeed-bmc-portwell-neptune.dts:6:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
	  1 ../arch/arm/boot/dts/aspeed-bmc-opp-zaius.dts:4:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
	  1 ../arch/arm/boot/dts/aspeed-bmc-opp-witherspoon.dts:4:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
	  1 ../arch/arm/boot/dts/aspeed-bmc-opp-lanyang.dts:6:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
	  1 ../arch/arm/boot/dts/aspeed-bmc-inspur-on5263m5.dts:6:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
	  1 ../arch/arm/boot/dts/aspeed-bmc-facebook-tiogapass.dts:7:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
	  1 ../arch/arm/boot/dts/aspeed-bmc-arm-stardragon4800-rep2.dts:5:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
	  1 ../arch/arm/boot/dts/aspeed-bmc-arm-centriq2400-rep.dts:5:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory

Warnings Summary: 2
	  3 ../arch/arm64/include/asm/preempt.h:7:0: warning: "PREEMPT_NEED_RESCHED" redefined
	  2 ../fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized in this function [-Wmaybe-uninitialized]



===============================================================================
Detailed per-defconfig build reports below:


-------------------------------------------------------------------------------
arm64-allnoconfig : FAIL, 34 errors, 1 warnings, 0 section mismatches

Errors:
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:31:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:36:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:41:31: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?

Warnings:
	../arch/arm64/include/asm/preempt.h:7:0: warning: "PREEMPT_NEED_RESCHED" redefined

-------------------------------------------------------------------------------
arm64-allmodconfig : FAIL, 34 errors, 1 warnings, 0 section mismatches

Errors:
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:31:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:36:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:41:31: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?

Warnings:
	../arch/arm64/include/asm/preempt.h:7:0: warning: "PREEMPT_NEED_RESCHED" redefined

-------------------------------------------------------------------------------
x86_64-defconfig : PASS, 0 errors, 1 warnings, 0 section mismatches

Warnings:
	../fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized in this function [-Wmaybe-uninitialized]

-------------------------------------------------------------------------------
arm-allmodconfig : FAIL, 199 errors, 0 warnings, 0 section mismatches

Errors:
	Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:202.1-6 Label or path cpu1 not found
	Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:206.1-6 Label or path cpu2 not found
	Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:210.1-6 Label or path cpu3 not found
	Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:238.1-5 Label or path gpu not found
	Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:705.1-6 Label or path vop0 not found
	Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:709.1-10 Label or path vop0_out not found
	Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:715.1-6 Label or path vop1 not found
	Error: ../arch/arm/boot/dts/at91-wb45n.dtsi:30.1-18 Label or path reset_controller not found
	Error: ../arch/arm/boot/dts/at91-wb45n.dtsi:34.1-21 Label or path shutdown_controller not found
	Error: ../arch/arm/boot/dts/at91-wb45n.dtsi:157.1-9 Label or path pinctrl not found
	Error: ../arch/arm/boot/dts/at91-wb45n.dts:30.1-10 Label or path watchdog not found
	Error: ../arch/arm/boot/dts/at91-wb50n.dtsi:25.1-9 Label or path pinctrl not found
	Error: ../arch/arm/boot/dts/at91-wb50n.dts:61.1-10 Label or path watchdog not found
	Error: ../arch/arm/boot/dts/imx51-zii-scu2-mezz.dts:346.1-5 Label or path vpu not found
	Error: ../arch/arm/boot/dts/imx6ull-colibri.dtsi:490.4-5 syntax error
	Error: ../arch/arm/boot/dts/meson8m2.dtsi:25.19-20 syntax error
	Error: ../arch/arm/boot/dts/imx6dl-mamoj.dts:491.10-492.1 syntax error
	Error: ../arch/arm/boot/dts/imx53-ppd.dts:596.1-5 Label or path pmu not found
	Error: ../arch/arm/boot/dts/berlin2cd-valve-steamlink.dts:29.1-5 Label or path cpu not found
	Error: ../arch/arm/boot/dts/berlin2cd-valve-steamlink.dts:37.1-6 Label or path i2c0 not found
	Error: ../arch/arm/boot/dts/iwg20d-q7-common.dtsi:80.21-22 syntax error
	../arch/arm/boot/dts/aspeed-bmc-quanta-q71l.dts:4:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
	Error: ../arch/arm/boot/dts/mt7623n-rfb-emmc.dts:109.1-6 Label or path btif not found
	Error: ../arch/arm/boot/dts/mt7623n-rfb-emmc.dts:254.1-6 Label or path pcie not found
	Error: ../arch/arm/boot/dts/mt7623n-rfb-emmc.dts:268.1-11 Label or path pcie0_phy not found
	Error: ../arch/arm/boot/dts/mt7623n-rfb-emmc.dts:272.1-11 Label or path pcie1_phy not found
	Error: ../arch/arm/boot/dts/at91-som60.dtsi:34.1-9 Label or path pinctrl not found
	Error: ../arch/arm/boot/dts/at91-dvk_su60_somc_lcm.dtsi:50.1-9 Label or path pinctrl not found
	../arch/arm/boot/dts/aspeed-bmc-facebook-tiogapass.dts:7:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
	../arch/arm/boot/dts/pxa300-raumfeld-tuneable-clock.dtsi:3:45: fatal error: dt-bindings/clock/maxim,max9485.h: No such file or directory
	../arch/arm/boot/dts/mt7623a.dtsi:9:45: fatal error: dt-bindings/power/mt7623a-power.h: No such file or directory
	Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:29.1-6 Label or path cmt0 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:60.1-8 Label or path mmcif0 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:70.1-6 Label or path qspi not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:91.1-6 Label or path rwdt not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:96.1-7 Label or path sdhi1 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:106.1-6 Label or path i2c3 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:84.1-5 Label or path avb not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:103.1-6 Label or path can0 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:118.1-7 Label or path hsusb not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:124.1-6 Label or path i2c5 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:141.1-6 Label or path pci1 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:195.1-12 Label or path rcar_sound not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:219.1-7 Label or path sdhi0 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:229.1-6 Label or path ssi4 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:233.1-8 Label or path usbphy not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm-dbhd-ca.dts:39.1-4 Label or path du not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm-dbhd-ca.dts:54.1-6 Label or path can1 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm-dbhd-ca.dts:68.1-6 Label or path i2c1 not found
	Error: ../arch/arm/boot/dts/exynos4412-midas.dtsi:337.1-8 Label or path camera not found
	../arch/arm/boot/dts/aspeed-bmc-inspur-on5263m5.dts:6:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
	../arch/arm/boot/dts/bcm283x-rpi-lan7515.dtsi:2:47: fatal error: dt-bindings/net/microchip-lan78xx.h: No such file or directory
	Error: ../arch/arm/boot/dts/imx6qdl-emcon.dtsi:813.1-6 Label or path cpu0 not found
	Error: ../arch/arm/boot/dts/sun8i-h2-plus-bananapi-m2-zero.dts:75.1-6 Label or path cpu0 not found
	Error: ../arch/arm/boot/dts/bcm2836-rpi.dtsi:4.1-7 Label or path vchiq not found
	Error: ../arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts:93.1-4 Label or path de not found
	Error: ../arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts:122.1-6 Label or path hdmi not found
	Error: ../arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts:126.1-10 Label or path hdmi_out not found
	Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:231.1-6 Label or path ssp1 not found
	Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:235.1-6 Label or path ssp2 not found
	Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:239.1-17 Label or path nand_controller not found
	Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:343.4-5 syntax error
	../arch/arm/boot/dts/r9a06g032.dtsi:10:49: fatal error: dt-bindings/clock/r9a06g032-sysctrl.h: No such file or directory
	Error: ../arch/arm/boot/dts/am335x-guardian.dts:246.48-49 syntax error
	Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:127.1-6 Label or path cpu0 not found
	Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:131.1-4 Label or path de not found
	Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:151.1-6 Label or path emac not found
	Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:158.1-6 Label or path hdmi not found
	Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:162.1-10 Label or path hdmi_out not found
	../arch/arm/boot/dts/r7s9210.dtsi:10:48: fatal error: dt-bindings/clock/r7s9210-cpg-mssr.h: No such file or directory
	Error: ../arch/arm/boot/dts/at91-nattis-2-natte-2.dts:146.1-9 Label or path pinctrl not found
	Error: ../arch/arm/boot/dts/at91-nattis-2-natte-2.dts:178.1-10 Label or path watchdog not found
	Error: ../arch/arm/boot/dts/imx51-zii-scu3-esb.dts:354.1-5 Label or path vpu not found
	Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:127.1-6 Label or path cpu0 not found
	Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:131.1-4 Label or path de not found
	Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:151.1-6 Label or path emac not found
	Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:158.1-6 Label or path hdmi not found
	Error: ../arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi:162.1-10 Label or path hdmi_out not found
	../arch/arm/boot/dts/r8a7744.dtsi:10:48: fatal error: dt-bindings/clock/r8a7744-cpg-mssr.h: No such file or directory
	../arch/arm/boot/dts/imx7ulp.dtsi:8:45: fatal error: dt-bindings/clock/imx7ulp-clock.h: No such file or directory
	Error: ../arch/arm/boot/dts/at91-wb50n.dtsi:25.1-9 Label or path pinctrl not found
	Error: ../arch/arm/boot/dts/at91-gatwick.dts:72.1-9 Label or path pinctrl not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:134.1-6 Label or path i2c0 not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:141.1-6 Label or path i2c1 not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:203.1-6 Label or path i2c2 not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:265.1-6 Label or path i2c3 not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:272.1-6 Label or path i2c4 not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:279.1-6 Label or path i2c5 not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:286.1-6 Label or path i2c6 not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:293.1-6 Label or path i2c7 not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:300.1-6 Label or path i2c8 not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:362.1-7 Label or path i2c13 not found
	../arch/arm/boot/dts/stm32mp157c.dtsi:7:45: fatal error: dt-bindings/clock/stm32mp1-clks.h: No such file or directory
	../arch/arm/boot/dts/imx6sll.dtsi:8:45: fatal error: dt-bindings/clock/imx6sll-clock.h: No such file or directory
	Error: ../arch/arm/boot/dts/bcm2836-rpi.dtsi:4.1-7 Label or path vchiq not found
	Error: ../arch/arm/boot/dts/imx31-lite.dts:38.1-5 Label or path ata not found
	Error: ../arch/arm/boot/dts/imx31-lite.dts:42.1-5 Label or path nfc not found
	Error: ../arch/arm/boot/dts/imx31-lite.dts:49.1-8 Label or path sdhci1 not found
	Error: ../arch/arm/boot/dts/imx31-lite.dts:56.1-6 Label or path spi2 not found
	Error: ../arch/arm/boot/dts/imx31-lite.dts:157.1-6 Label or path weim not found
	../arch/arm/boot/dts/aspeed-bmc-opp-lanyang.dts:6:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
	Error: ../arch/arm/boot/dts/imx6q-icore-mipi.dts:27.1-8 Label or path ov5640 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:29.1-6 Label or path cmt0 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:60.1-8 Label or path mmcif0 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:70.1-6 Label or path qspi not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:91.1-6 Label or path rwdt not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:96.1-7 Label or path sdhi1 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22m.dtsi:106.1-6 Label or path i2c3 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:84.1-5 Label or path avb not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:103.1-6 Label or path can0 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:118.1-7 Label or path hsusb not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:124.1-6 Label or path i2c5 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:141.1-6 Label or path pci1 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:195.1-12 Label or path rcar_sound not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:219.1-7 Label or path sdhi0 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:229.1-6 Label or path ssi4 not found
	Error: ../arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts:233.1-8 Label or path usbphy not found
	../arch/arm/boot/dts/pxa300-raumfeld-tuneable-clock.dtsi:3:45: fatal error: dt-bindings/clock/maxim,max9485.h: No such file or directory
	../arch/arm/boot/dts/r8a7744.dtsi:10:48: fatal error: dt-bindings/clock/r8a7744-cpg-mssr.h: No such file or directory
	Error: ../arch/arm/boot/dts/imx6ul-14x14-evk.dtsi:519.4-5 syntax error
	Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:131.1-6 Label or path cpu0 not found
	Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:135.1-8 Label or path cpu100 not found
	Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:139.1-4 Label or path de not found
	Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:197.1-5 Label or path pwm not found
	Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:388.1-7 Label or path tcon0 not found
	Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:393.1-11 Label or path tcon0_out not found
	Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:407.1-7 Label or path uart1 not found
	../arch/arm/boot/dts/aspeed-bmc-arm-stardragon4800-rep2.dts:5:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
	../arch/arm/boot/dts/aspeed-bmc-portwell-neptune.dts:6:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
	../arch/arm/boot/dts/stm32mp157c.dtsi:7:45: fatal error: dt-bindings/clock/stm32mp1-clks.h: No such file or directory
	Error: ../arch/arm/boot/dts/exynos4412-midas.dtsi:337.1-8 Label or path camera not found
	Error: ../arch/arm/boot/dts/imx51-zii-rdu1.dts:565.1-15 Label or path ipu_di0_disp1 not found
	Error: ../arch/arm/boot/dts/imx51-zii-rdu1.dts:569.1-5 Label or path pmu not found
	Error: ../arch/arm/boot/dts/sun8i-h3-orangepi-zero-plus2.dts:88.1-4 Label or path de not found
	Error: ../arch/arm/boot/dts/sun8i-h3-orangepi-zero-plus2.dts:92.1-6 Label or path hdmi not found
	Error: ../arch/arm/boot/dts/sun8i-h3-orangepi-zero-plus2.dts:96.1-10 Label or path hdmi_out not found
	../arch/arm/boot/dts/pxa300-raumfeld-tuneable-clock.dtsi:3:45: fatal error: dt-bindings/clock/maxim,max9485.h: No such file or directory
	../arch/arm/boot/dts/aspeed-bmc-opp-witherspoon.dts:4:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
	Error: ../arch/arm/boot/dts/am3874-iceboard.dts:415.1-7 Label or path gpio3 not found
	Error: ../arch/arm/boot/dts/am3874-iceboard.dts:423.1-7 Label or path gpio4 not found
	Error: ../arch/arm/boot/dts/am3874-iceboard.dts:482.1-8 Label or path mcspi3 not found
	Error: ../arch/arm/boot/dts/am3874-iceboard.dts:489.1-8 Label or path mcspi4 not found
	Error: ../arch/arm/boot/dts/r8a7790-stout.dts:96.17-18 syntax error
	../arch/arm/boot/dts/aspeed-bmc-arm-centriq2400-rep.dts:5:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
	../arch/arm/boot/dts/pxa300-raumfeld-tuneable-clock.dtsi:3:45: fatal error: dt-bindings/clock/maxim,max9485.h: No such file or directory
	Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:82.1-6 Label or path i2c1 not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:86.1-6 Label or path i2c2 not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:90.1-6 Label or path i2c3 not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:94.1-6 Label or path i2c4 not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:98.1-6 Label or path i2c5 not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:102.1-6 Label or path i2c6 not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:106.1-6 Label or path i2c7 not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:110.1-7 Label or path i2c13 not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts:122.1-11 Label or path pwm_tacho not found
	Error: ../arch/arm/boot/dts/meson8b-ec100.dts:216.1-6 Label or path cpu0 not found
	Error: ../arch/arm/boot/dts/meson8b-ec100.dts:268.1-6 Label or path sdio not found
	Error: ../arch/arm/boot/dts/sun8i-h3-mapleboard-mp130.dts:78.1-6 Label or path emac not found
	Error: ../arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi:111.1-4 Label or path de not found
	Error: ../arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi:127.1-6 Label or path emac not found
	Error: ../arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi:137.1-15 Label or path external_mdio not found
	Error: ../arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi:144.1-6 Label or path hdmi not found
	Error: ../arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi:148.1-10 Label or path hdmi_out not found
	Error: ../arch/arm/boot/dts/sunxi-bananapi-m2-plus-v1.2.dtsi:29.1-6 Label or path cpu0 not found
	Error: ../arch/arm/boot/dts/rv1108-elgin-r1.dts:51.1-6 Label or path gmac not found
	../arch/arm/boot/dts/mt7623a.dtsi:9:45: fatal error: dt-bindings/power/mt7623a-power.h: No such file or directory
	Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:231.1-6 Label or path ssp1 not found
	Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:235.1-6 Label or path ssp2 not found
	Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:239.1-17 Label or path nand_controller not found
	Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:343.4-5 syntax error
	Error: ../arch/arm/boot/dts/imx6qdl-var-dart.dtsi:213.4-5 syntax error
	Error: ../arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts:93.1-4 Label or path de not found
	Error: ../arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts:122.1-6 Label or path hdmi not found
	Error: ../arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts:126.1-10 Label or path hdmi_out not found
	../arch/arm/boot/dts/r8a77470.dtsi:10:49: fatal error: dt-bindings/clock/r8a77470-cpg-mssr.h: No such file or directory
	Error: ../arch/arm/boot/dts/exynos4412-midas.dtsi:337.1-8 Label or path camera not found
	Error: ../arch/arm/boot/dts/am335x-osd3358-sm-red.dts:459.48-49 syntax error
	Error: ../arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts:200.21-22 syntax error
	Error: ../arch/arm/boot/dts/imx6ull-colibri.dtsi:490.4-5 syntax error
	../arch/arm/boot/dts/aspeed-bmc-opp-zaius.dts:4:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
	Error: ../arch/arm/boot/dts/ls1021a-moxa-uc-8410a.dts:206.1-6 Label or path qspi not found
	Error: ../arch/arm/boot/dts/armada-385-db-88f6820-amc.dts:94.1-17 Label or path nand_controller not found
	ERROR: Input tree has errors, aborting (use -f to force output)
	ERROR: Input tree has errors, aborting (use -f to force output)
	ERROR: Input tree has errors, aborting (use -f to force output)
	ERROR: Input tree has errors, aborting (use -f to force output)
	ERROR: Input tree has errors, aborting (use -f to force output)
	ERROR: Input tree has errors, aborting (use -f to force output)
	ERROR: Input tree has errors, aborting (use -f to force output)
	ERROR: Input tree has errors, aborting (use -f to force output)
	ERROR: Input tree has errors, aborting (use -f to force output)
	ERROR: Input tree has errors, aborting (use -f to force output)
	ERROR: Input tree has errors, aborting (use -f to force output)
	ERROR: Input tree has errors, aborting (use -f to force output)
	ERROR: Input tree has errors, aborting (use -f to force output)
	ERROR: Input tree has errors, aborting (use -f to force output)
	ERROR: Input tree has errors, aborting (use -f to force output)
	ERROR: Input tree has errors, aborting (use -f to force output)
	ERROR: Input tree has errors, aborting (use -f to force output)
	ERROR: Input tree has errors, aborting (use -f to force output)

-------------------------------------------------------------------------------
x86_64-allmodconfig : PASS, 0 errors, 1 warnings, 0 section mismatches

Warnings:
	../fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized in this function [-Wmaybe-uninitialized]

-------------------------------------------------------------------------------
arm64-defconfig : FAIL, 34 errors, 1 warnings, 0 section mismatches

Errors:
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:31:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:36:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:41:31: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?

Warnings:
	../arch/arm64/include/asm/preempt.h:7:0: warning: "PREEMPT_NEED_RESCHED" redefined
-------------------------------------------------------------------------------

Passed with no errors, warnings or mismatches:

x86_64-allnoconfig
arm-multi_v7_defconfig
arm-allnoconfig
arm-multi_v4t_defconfig
arm-multi_v5_defconfig
