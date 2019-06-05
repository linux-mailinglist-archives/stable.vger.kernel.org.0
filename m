Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC15135C1A
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 13:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfFELzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 07:55:32 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:40384 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbfFELzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 07:55:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:Subject:To:From:
        Sender:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FYI93kpwXNS+BpspMC2dZ/S9BJtJnXBOt/DBM9bRBZc=; b=Z41+rQoaCAiU2oFhlGY4rJroX
        a0dnrxciYzWjfWSfFRG8PqUYYPDfA+fW4h6jh716yJXGmhxq1kpW+1+Qh9bOdNBC/ip6OoSKXT6sf
        1i3EdYHRseDf0BUZzNzwTZVjVtHtChi/1lGqhnFVZ/aZmaqes67f5+m5E5MRHZVftaDVI=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=optimist)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hYUVp-0000Js-9V; Wed, 05 Jun 2019 11:55:25 +0000
Received: from broonie by optimist with local (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hYUVo-0000NP-Jq; Wed, 05 Jun 2019 12:55:24 +0100
From:   Build bot for Mark Brown <broonie@kernel.org>
To:     kernel-build-reports@lists.linaro.org,
        linaro-kernel@lists.linaro.org, stable@vger.kernel.org
Subject: v4.9.180 build: 8 failures 1 warnings (v4.9.180)
Message-Id: <E1hYUVo-0000NP-Jq@optimist>
Date:   Wed, 05 Jun 2019 12:55:24 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tree/Branch: v4.9.180
Git describe: v4.9.180
Commit: b16a5334ed Linux 4.9.180

Build Time: 0 min 53 sec

Passed:    3 / 11   ( 27.27 %)
Failed:    8 / 11   ( 72.73 %)

Errors: 52
Warnings: 1
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
Error: ../arch/arm/boot/dts/imx7d-sdb.dts:43.1-9 syntax error
../arch/arm/boot/dts/pxa300-raumfeld-tuneable-clock.dtsi:3:45: fatal error: dt-bindings/clock/maxim,max9485.h: No such file or directory
Error: ../arch/arm/boot/dts/bcm4708-linksys-ea6500-v2.dts:43.1-10 Label or path usb3_phy not found
../arch/arm/boot/dts/pxa300-raumfeld-tuneable-clock.dtsi:3:45: fatal error: dt-bindings/clock/maxim,max9485.h: No such file or directory
Error: ../arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi:299.1-25 Label or path ipu1_csi1_from_mipi_vc1 not found
Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:34.20-21 syntax error
../arch/arm/boot/dts/r8a7744.dtsi:10:48: fatal error: dt-bindings/clock/r8a7744-cpg-mssr.h: No such file or directory
../arch/arm/boot/dts/bcm2837-rpi-3-a-plus.dts:3:24: fatal error: bcm2837.dtsi: No such file or directory
Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:231.1-6 Label or path ssp1 not found
Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:235.1-6 Label or path ssp2 not found
Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:239.1-17 Label or path nand_controller not found
Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:343.4-5 syntax error
Error: ../arch/arm/boot/dts/am335x-guardian.dts:246.48-49 syntax error
../arch/arm/boot/dts/r7s9210.dtsi:10:48: fatal error: dt-bindings/clock/r7s9210-cpg-mssr.h: No such file or directory
../arch/arm/boot/dts/r8a7744.dtsi:10:48: fatal error: dt-bindings/clock/r8a7744-cpg-mssr.h: No such file or directory
Error: ../arch/arm/boot/dts/imx6qdl-emcon.dtsi:813.1-6 Label or path cpu0 not found
Error: ../arch/arm/boot/dts/am3874-iceboard.dts:415.1-7 Label or path gpio3 not found
Error: ../arch/arm/boot/dts/am3874-iceboard.dts:423.1-7 Label or path gpio4 not found
Error: ../arch/arm/boot/dts/am3874-iceboard.dts:482.1-8 Label or path mcspi3 not found
Error: ../arch/arm/boot/dts/am3874-iceboard.dts:489.1-8 Label or path mcspi4 not found
../arch/arm/boot/dts/bcm47094-phicomm-k3.dts:9:25: fatal error: bcm47094.dtsi: No such file or directory
../arch/arm/boot/dts/pxa300-raumfeld-tuneable-clock.dtsi:3:45: fatal error: dt-bindings/clock/maxim,max9485.h: No such file or directory
Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:231.1-6 Label or path ssp1 not found
Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:235.1-6 Label or path ssp2 not found
Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:239.1-17 Label or path nand_controller not found
Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:343.4-5 syntax error
Error: ../arch/arm/boot/dts/sun8i-h3-mapleboard-mp130.dts:59.1-7 Label or path codec not found
Error: ../arch/arm/boot/dts/sun8i-h3-mapleboard-mp130.dts:78.1-6 Label or path emac not found
Error: ../arch/arm/boot/dts/sun8i-h3-mapleboard-mp130.dts:145.1-9 Label or path usb_otg not found
../arch/arm/boot/dts/rv1108-elgin-r1.dts:9:23: fatal error: rv1108.dtsi: No such file or directory
../arch/arm/boot/dts/sun8i-t3-cqa3t-bv3.dts:47:26: fatal error: sun8i-r40.dtsi: No such file or directory
../arch/arm/boot/dts/aspeed-bmc-inspur-on5263m5.dts:6:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
../arch/arm/boot/dts/pxa300-raumfeld-tuneable-clock.dtsi:3:45: fatal error: dt-bindings/clock/maxim,max9485.h: No such file or directory
Error: ../arch/arm/boot/dts/imx6ul-pico.dtsi:8.1-9 syntax error
../arch/arm/boot/dts/imx7ulp.dtsi:8:45: fatal error: dt-bindings/clock/imx7ulp-clock.h: No such file or directory
../arch/arm/boot/dts/imx7d-pico-hobbit.dts:5:27: fatal error: imx7d-pico.dtsi: No such file or directory
Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:61.1-9 Label or path pinctrl not found
Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:81.1-5 Label or path fmc not found
Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:124.1-6 Label or path mac1 not found
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
Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:366.1-5 Label or path adc not found

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
      1 warnings    0 mismatches  : arm64-defconfig

-------------------------------------------------------------------------------

Errors summary: 52
	 15 ../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	 15 ../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	 15 ../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	 12 ../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	 12 ../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	 12 ../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	 12 ../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	  4 ../arch/arm/boot/dts/pxa300-raumfeld-tuneable-clock.dtsi:3:45: fatal error: dt-bindings/clock/maxim,max9485.h: No such file or directory
	  3 ../arch/arm64/include/asm/preempt.h:41:31: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	  3 ../arch/arm64/include/asm/preempt.h:36:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	  3 ../arch/arm64/include/asm/preempt.h:31:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	  2 Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:343.4-5 syntax error
	  2 Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:239.1-17 Label or path nand_controller not found
	  2 Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:235.1-6 Label or path ssp2 not found
	  2 Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:231.1-6 Label or path ssp1 not found
	  2 ../arch/arm/boot/dts/r8a7744.dtsi:10:48: fatal error: dt-bindings/clock/r8a7744-cpg-mssr.h: No such file or directory
	  1 Error: ../arch/arm/boot/dts/sun8i-h3-mapleboard-mp130.dts:78.1-6 Label or path emac not found
	  1 Error: ../arch/arm/boot/dts/sun8i-h3-mapleboard-mp130.dts:59.1-7 Label or path codec not found
	  1 Error: ../arch/arm/boot/dts/sun8i-h3-mapleboard-mp130.dts:145.1-9 Label or path usb_otg not found
	  1 Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:34.20-21 syntax error
	  1 Error: ../arch/arm/boot/dts/imx7d-sdb.dts:43.1-9 syntax error
	  1 Error: ../arch/arm/boot/dts/imx6ul-pico.dtsi:8.1-9 syntax error
	  1 Error: ../arch/arm/boot/dts/imx6qdl-emcon.dtsi:813.1-6 Label or path cpu0 not found
	  1 Error: ../arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi:299.1-25 Label or path ipu1_csi1_from_mipi_vc1 not found
	  1 Error: ../arch/arm/boot/dts/bcm4708-linksys-ea6500-v2.dts:43.1-10 Label or path usb3_phy not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:81.1-5 Label or path fmc not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:61.1-9 Label or path pinctrl not found
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:366.1-5 Label or path adc not found
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
	  1 Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:124.1-6 Label or path mac1 not found
	  1 Error: ../arch/arm/boot/dts/am3874-iceboard.dts:489.1-8 Label or path mcspi4 not found
	  1 Error: ../arch/arm/boot/dts/am3874-iceboard.dts:482.1-8 Label or path mcspi3 not found
	  1 Error: ../arch/arm/boot/dts/am3874-iceboard.dts:423.1-7 Label or path gpio4 not found
	  1 Error: ../arch/arm/boot/dts/am3874-iceboard.dts:415.1-7 Label or path gpio3 not found
	  1 Error: ../arch/arm/boot/dts/am335x-guardian.dts:246.48-49 syntax error
	  1 ../arch/arm/boot/dts/sun8i-t3-cqa3t-bv3.dts:47:26: fatal error: sun8i-r40.dtsi: No such file or directory
	  1 ../arch/arm/boot/dts/rv1108-elgin-r1.dts:9:23: fatal error: rv1108.dtsi: No such file or directory
	  1 ../arch/arm/boot/dts/r7s9210.dtsi:10:48: fatal error: dt-bindings/clock/r7s9210-cpg-mssr.h: No such file or directory
	  1 ../arch/arm/boot/dts/imx7ulp.dtsi:8:45: fatal error: dt-bindings/clock/imx7ulp-clock.h: No such file or directory
	  1 ../arch/arm/boot/dts/imx7d-pico-hobbit.dts:5:27: fatal error: imx7d-pico.dtsi: No such file or directory
	  1 ../arch/arm/boot/dts/bcm47094-phicomm-k3.dts:9:25: fatal error: bcm47094.dtsi: No such file or directory
	  1 ../arch/arm/boot/dts/bcm2837-rpi-3-a-plus.dts:3:24: fatal error: bcm2837.dtsi: No such file or directory
	  1 ../arch/arm/boot/dts/aspeed-bmc-inspur-on5263m5.dts:6:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory

Warnings Summary: 1
	  3 ../arch/arm64/include/asm/preempt.h:7:0: warning: "PREEMPT_NEED_RESCHED" redefined



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
arm-allmodconfig : FAIL, 50 errors, 0 warnings, 0 section mismatches

Errors:
	Error: ../arch/arm/boot/dts/imx7d-sdb.dts:43.1-9 syntax error
	../arch/arm/boot/dts/pxa300-raumfeld-tuneable-clock.dtsi:3:45: fatal error: dt-bindings/clock/maxim,max9485.h: No such file or directory
	Error: ../arch/arm/boot/dts/bcm4708-linksys-ea6500-v2.dts:43.1-10 Label or path usb3_phy not found
	../arch/arm/boot/dts/pxa300-raumfeld-tuneable-clock.dtsi:3:45: fatal error: dt-bindings/clock/maxim,max9485.h: No such file or directory
	Error: ../arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi:299.1-25 Label or path ipu1_csi1_from_mipi_vc1 not found
	Error: ../arch/arm/boot/dts/rk3188-bqedison2qc.dts:34.20-21 syntax error
	../arch/arm/boot/dts/r8a7744.dtsi:10:48: fatal error: dt-bindings/clock/r8a7744-cpg-mssr.h: No such file or directory
	../arch/arm/boot/dts/bcm2837-rpi-3-a-plus.dts:3:24: fatal error: bcm2837.dtsi: No such file or directory
	Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:231.1-6 Label or path ssp1 not found
	Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:235.1-6 Label or path ssp2 not found
	Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:239.1-17 Label or path nand_controller not found
	Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:343.4-5 syntax error
	Error: ../arch/arm/boot/dts/am335x-guardian.dts:246.48-49 syntax error
	../arch/arm/boot/dts/r7s9210.dtsi:10:48: fatal error: dt-bindings/clock/r7s9210-cpg-mssr.h: No such file or directory
	../arch/arm/boot/dts/r8a7744.dtsi:10:48: fatal error: dt-bindings/clock/r8a7744-cpg-mssr.h: No such file or directory
	Error: ../arch/arm/boot/dts/imx6qdl-emcon.dtsi:813.1-6 Label or path cpu0 not found
	Error: ../arch/arm/boot/dts/am3874-iceboard.dts:415.1-7 Label or path gpio3 not found
	Error: ../arch/arm/boot/dts/am3874-iceboard.dts:423.1-7 Label or path gpio4 not found
	Error: ../arch/arm/boot/dts/am3874-iceboard.dts:482.1-8 Label or path mcspi3 not found
	Error: ../arch/arm/boot/dts/am3874-iceboard.dts:489.1-8 Label or path mcspi4 not found
	../arch/arm/boot/dts/bcm47094-phicomm-k3.dts:9:25: fatal error: bcm47094.dtsi: No such file or directory
	../arch/arm/boot/dts/pxa300-raumfeld-tuneable-clock.dtsi:3:45: fatal error: dt-bindings/clock/maxim,max9485.h: No such file or directory
	Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:231.1-6 Label or path ssp1 not found
	Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:235.1-6 Label or path ssp2 not found
	Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:239.1-17 Label or path nand_controller not found
	Error: ../arch/arm/boot/dts/pxa300-raumfeld-common.dtsi:343.4-5 syntax error
	Error: ../arch/arm/boot/dts/sun8i-h3-mapleboard-mp130.dts:59.1-7 Label or path codec not found
	Error: ../arch/arm/boot/dts/sun8i-h3-mapleboard-mp130.dts:78.1-6 Label or path emac not found
	Error: ../arch/arm/boot/dts/sun8i-h3-mapleboard-mp130.dts:145.1-9 Label or path usb_otg not found
	../arch/arm/boot/dts/rv1108-elgin-r1.dts:9:23: fatal error: rv1108.dtsi: No such file or directory
	../arch/arm/boot/dts/sun8i-t3-cqa3t-bv3.dts:47:26: fatal error: sun8i-r40.dtsi: No such file or directory
	../arch/arm/boot/dts/aspeed-bmc-inspur-on5263m5.dts:6:42: fatal error: dt-bindings/gpio/aspeed-gpio.h: No such file or directory
	../arch/arm/boot/dts/pxa300-raumfeld-tuneable-clock.dtsi:3:45: fatal error: dt-bindings/clock/maxim,max9485.h: No such file or directory
	Error: ../arch/arm/boot/dts/imx6ul-pico.dtsi:8.1-9 syntax error
	../arch/arm/boot/dts/imx7ulp.dtsi:8:45: fatal error: dt-bindings/clock/imx7ulp-clock.h: No such file or directory
	../arch/arm/boot/dts/imx7d-pico-hobbit.dts:5:27: fatal error: imx7d-pico.dtsi: No such file or directory
	Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:61.1-9 Label or path pinctrl not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:81.1-5 Label or path fmc not found
	Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:124.1-6 Label or path mac1 not found
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
	Error: ../arch/arm/boot/dts/aspeed-bmc-facebook-cmm.dts:366.1-5 Label or path adc not found

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

arm-multi_v5_defconfig
arm-multi_v7_defconfig
x86_64-defconfig
arm-allnoconfig
x86_64-allnoconfig
arm-multi_v4t_defconfig
x86_64-allmodconfig
