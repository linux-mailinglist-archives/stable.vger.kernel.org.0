Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDB456FDD9
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbiGKKBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234574AbiGKJ7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:59:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E95B7D61;
        Mon, 11 Jul 2022 02:28:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B67C1B80DB7;
        Mon, 11 Jul 2022 09:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07876C34115;
        Mon, 11 Jul 2022 09:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531684;
        bh=bbeGwcWQa70BYWRXUbdD0HP8EK6OulIySJ6Ht6nUEmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=169gmadEDs0YR/2gzG5NZJGSdL0eo9zdwUzwn8+1UNHbGIB6DZrAgYAJXzNZRsNO/
         sI0vrpjWO4hJ3BJ4bhuFmbUH5u3qMar1uQJQK3uzvm60a//KHcxX7vFq4pDChhZnbe
         YDAmkZjvwgtzmRaP2KggTX5QbVcFewLD7QdYDVHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 194/230] arm64: dts: imx8mp-phyboard-pollux-rdk: correct i2c2 & mmc settings
Date:   Mon, 11 Jul 2022 11:07:30 +0200
Message-Id: <20220711090609.607923246@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 242d8ee9111171a6e68249aaff62643c513be6ec ]

BIT3 and BIT0 are reserved bits, should not touch.

Fixes: 88f7f6bcca37 ("arm64: dts: freescale: Add support for phyBOARD-Pollux-i.MX8MP")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/freescale/imx8mp-phyboard-pollux-rdk.dts | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts b/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts
index cefd3d36f93f..6aa720bafe28 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts
@@ -136,21 +136,21 @@
 
 	pinctrl_i2c2: i2c2grp {
 		fsl,pins = <
-			MX8MP_IOMUXC_I2C2_SCL__I2C2_SCL		0x400001c3
-			MX8MP_IOMUXC_I2C2_SDA__I2C2_SDA		0x400001c3
+			MX8MP_IOMUXC_I2C2_SCL__I2C2_SCL		0x400001c2
+			MX8MP_IOMUXC_I2C2_SDA__I2C2_SDA		0x400001c2
 		>;
 	};
 
 	pinctrl_i2c2_gpio: i2c2gpiogrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_I2C2_SCL__GPIO5_IO16	0x1e3
-			MX8MP_IOMUXC_I2C2_SDA__GPIO5_IO17	0x1e3
+			MX8MP_IOMUXC_I2C2_SCL__GPIO5_IO16	0x1e2
+			MX8MP_IOMUXC_I2C2_SDA__GPIO5_IO17	0x1e2
 		>;
 	};
 
 	pinctrl_reg_usdhc2_vmmc: regusdhc2vmmcgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_SD2_RESET_B__GPIO2_IO19	0x41
+			MX8MP_IOMUXC_SD2_RESET_B__GPIO2_IO19	0x40
 		>;
 	};
 
@@ -175,7 +175,7 @@
 			MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1	0x1d0
 			MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2	0x1d0
 			MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d0
-			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc1
+			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc0
 		>;
 	};
 
@@ -187,7 +187,7 @@
 			MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1	0x1d4
 			MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2	0x1d4
 			MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d4
-			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc1
+			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc0
 		>;
 	};
 
@@ -199,7 +199,7 @@
 			MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1	0x1d6
 			MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2	0x1d6
 			MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d6
-			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc1
+			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc0
 		>;
 	};
 };
-- 
2.35.1



