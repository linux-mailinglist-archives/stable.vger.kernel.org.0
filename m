Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72063582DCA
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241285AbiG0RDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiG0RCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:02:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646666C13E;
        Wed, 27 Jul 2022 09:38:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5D23B821A6;
        Wed, 27 Jul 2022 16:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B63C433C1;
        Wed, 27 Jul 2022 16:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939900;
        bh=7+QOaPl6X2wUo779kjghaLkfqQGV8c0zdFf9/rbyZD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tez8VNiVeDmIW6U4AWIlTmahWlAbbJJUUDWHWToE3c4dUyr4BEi1nwogEpACxailM
         NSIGwT93aNgJX7BbEP6ZIEHz9NZ51RobjDdaKrSoMCVHkxk5TppsWhjo3mfKhZgZ9B
         DH+XF0pR1YcF+Akm1186XN/od7R9cCTt6DslbVGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/201] pinctrl: ralink: rename pinctrl-rt2880 to pinctrl-ralink
Date:   Wed, 27 Jul 2022 18:08:58 +0200
Message-Id: <20220727161028.284052945@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

[ Upstream commit 6b3dd85b0bdec1a8308fa5dcbafcd5d55b5f3608 ]

pinctrl-rt2880.c and pinmux.h make up the Ralink pinctrl driver. Rename
pinctrl-rt2880.c to pinctrl-ralink.c. Rename pinmux.h to pinctrl-ralink.h.
Fix references to it. Rename functions that include "rt2880" to "ralink".

Remove PINCTRL_RT2880 symbol and make the existing PINCTRL_RALINK symbol
compile pinctrl-ralink.c. Change the bool to "Ralink pinctrl driver".

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Acked-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20220414173916.5552-3-arinc.unal@arinc9.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/ralink/Kconfig                | 16 ++--
 drivers/pinctrl/ralink/Makefile               |  2 +-
 drivers/pinctrl/ralink/pinctrl-mt7620.c       | 92 +++++++++----------
 drivers/pinctrl/ralink/pinctrl-mt7621.c       | 30 +++---
 .../{pinctrl-rt2880.c => pinctrl-ralink.c}    | 90 +++++++++---------
 .../ralink/{pinmux.h => pinctrl-ralink.h}     | 16 ++--
 drivers/pinctrl/ralink/pinctrl-rt288x.c       | 20 ++--
 drivers/pinctrl/ralink/pinctrl-rt305x.c       | 44 ++++-----
 drivers/pinctrl/ralink/pinctrl-rt3883.c       | 28 +++---
 9 files changed, 167 insertions(+), 171 deletions(-)
 rename drivers/pinctrl/ralink/{pinctrl-rt2880.c => pinctrl-ralink.c} (73%)
 rename drivers/pinctrl/ralink/{pinmux.h => pinctrl-ralink.h} (75%)

diff --git a/drivers/pinctrl/ralink/Kconfig b/drivers/pinctrl/ralink/Kconfig
index a76ee3deb8c3..d0f0a8f2b9b7 100644
--- a/drivers/pinctrl/ralink/Kconfig
+++ b/drivers/pinctrl/ralink/Kconfig
@@ -3,37 +3,33 @@ menu "Ralink pinctrl drivers"
         depends on RALINK
 
 config PINCTRL_RALINK
-        bool "Ralink pin control support"
-        default y if RALINK
-
-config PINCTRL_RT2880
-        bool "RT2880 pinctrl driver for RALINK/Mediatek SOCs"
+        bool "Ralink pinctrl driver"
         select PINMUX
         select GENERIC_PINCONF
 
 config PINCTRL_MT7620
         bool "mt7620 pinctrl driver for RALINK/Mediatek SOCs"
         depends on RALINK && SOC_MT7620
-        select PINCTRL_RT2880
+        select PINCTRL_RALINK
 
 config PINCTRL_MT7621
         bool "mt7621 pinctrl driver for RALINK/Mediatek SOCs"
         depends on RALINK && SOC_MT7621
-        select PINCTRL_RT2880
+        select PINCTRL_RALINK
 
 config PINCTRL_RT288X
         bool "RT288X pinctrl driver for RALINK/Mediatek SOCs"
         depends on RALINK && SOC_RT288X
-        select PINCTRL_RT2880
+        select PINCTRL_RALINK
 
 config PINCTRL_RT305X
         bool "RT305X pinctrl driver for RALINK/Mediatek SOCs"
         depends on RALINK && SOC_RT305X
-        select PINCTRL_RT2880
+        select PINCTRL_RALINK
 
 config PINCTRL_RT3883
         bool "RT3883 pinctrl driver for RALINK/Mediatek SOCs"
         depends on RALINK && SOC_RT3883
-        select PINCTRL_RT2880
+        select PINCTRL_RALINK
 
 endmenu
diff --git a/drivers/pinctrl/ralink/Makefile b/drivers/pinctrl/ralink/Makefile
index a15610206ced..2c1323b74e96 100644
--- a/drivers/pinctrl/ralink/Makefile
+++ b/drivers/pinctrl/ralink/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_PINCTRL_RT2880)   += pinctrl-rt2880.o
+obj-$(CONFIG_PINCTRL_RALINK)   += pinctrl-ralink.o
 
 obj-$(CONFIG_PINCTRL_MT7620)   += pinctrl-mt7620.o
 obj-$(CONFIG_PINCTRL_MT7621)   += pinctrl-mt7621.o
diff --git a/drivers/pinctrl/ralink/pinctrl-mt7620.c b/drivers/pinctrl/ralink/pinctrl-mt7620.c
index d3f9feec1f74..51b863d85c51 100644
--- a/drivers/pinctrl/ralink/pinctrl-mt7620.c
+++ b/drivers/pinctrl/ralink/pinctrl-mt7620.c
@@ -5,7 +5,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
-#include "pinmux.h"
+#include "pinctrl-ralink.h"
 
 #define MT7620_GPIO_MODE_UART0_SHIFT	2
 #define MT7620_GPIO_MODE_UART0_MASK	0x7
@@ -54,20 +54,20 @@
 #define MT7620_GPIO_MODE_EPHY		15
 #define MT7620_GPIO_MODE_PA		20
 
-static struct rt2880_pmx_func i2c_grp[] =  { FUNC("i2c", 0, 1, 2) };
-static struct rt2880_pmx_func spi_grp[] = { FUNC("spi", 0, 3, 4) };
-static struct rt2880_pmx_func uartlite_grp[] = { FUNC("uartlite", 0, 15, 2) };
-static struct rt2880_pmx_func mdio_grp[] = {
+static struct ralink_pmx_func i2c_grp[] =  { FUNC("i2c", 0, 1, 2) };
+static struct ralink_pmx_func spi_grp[] = { FUNC("spi", 0, 3, 4) };
+static struct ralink_pmx_func uartlite_grp[] = { FUNC("uartlite", 0, 15, 2) };
+static struct ralink_pmx_func mdio_grp[] = {
 	FUNC("mdio", MT7620_GPIO_MODE_MDIO, 22, 2),
 	FUNC("refclk", MT7620_GPIO_MODE_MDIO_REFCLK, 22, 2),
 };
-static struct rt2880_pmx_func rgmii1_grp[] = { FUNC("rgmii1", 0, 24, 12) };
-static struct rt2880_pmx_func refclk_grp[] = { FUNC("spi refclk", 0, 37, 3) };
-static struct rt2880_pmx_func ephy_grp[] = { FUNC("ephy", 0, 40, 5) };
-static struct rt2880_pmx_func rgmii2_grp[] = { FUNC("rgmii2", 0, 60, 12) };
-static struct rt2880_pmx_func wled_grp[] = { FUNC("wled", 0, 72, 1) };
-static struct rt2880_pmx_func pa_grp[] = { FUNC("pa", 0, 18, 4) };
-static struct rt2880_pmx_func uartf_grp[] = {
+static struct ralink_pmx_func rgmii1_grp[] = { FUNC("rgmii1", 0, 24, 12) };
+static struct ralink_pmx_func refclk_grp[] = { FUNC("spi refclk", 0, 37, 3) };
+static struct ralink_pmx_func ephy_grp[] = { FUNC("ephy", 0, 40, 5) };
+static struct ralink_pmx_func rgmii2_grp[] = { FUNC("rgmii2", 0, 60, 12) };
+static struct ralink_pmx_func wled_grp[] = { FUNC("wled", 0, 72, 1) };
+static struct ralink_pmx_func pa_grp[] = { FUNC("pa", 0, 18, 4) };
+static struct ralink_pmx_func uartf_grp[] = {
 	FUNC("uartf", MT7620_GPIO_MODE_UARTF, 7, 8),
 	FUNC("pcm uartf", MT7620_GPIO_MODE_PCM_UARTF, 7, 8),
 	FUNC("pcm i2s", MT7620_GPIO_MODE_PCM_I2S, 7, 8),
@@ -76,20 +76,20 @@ static struct rt2880_pmx_func uartf_grp[] = {
 	FUNC("gpio uartf", MT7620_GPIO_MODE_GPIO_UARTF, 7, 4),
 	FUNC("gpio i2s", MT7620_GPIO_MODE_GPIO_I2S, 7, 4),
 };
-static struct rt2880_pmx_func wdt_grp[] = {
+static struct ralink_pmx_func wdt_grp[] = {
 	FUNC("wdt rst", 0, 17, 1),
 	FUNC("wdt refclk", 0, 17, 1),
 	};
-static struct rt2880_pmx_func pcie_rst_grp[] = {
+static struct ralink_pmx_func pcie_rst_grp[] = {
 	FUNC("pcie rst", MT7620_GPIO_MODE_PCIE_RST, 36, 1),
 	FUNC("pcie refclk", MT7620_GPIO_MODE_PCIE_REF, 36, 1)
 };
-static struct rt2880_pmx_func nd_sd_grp[] = {
+static struct ralink_pmx_func nd_sd_grp[] = {
 	FUNC("nand", MT7620_GPIO_MODE_NAND, 45, 15),
 	FUNC("sd", MT7620_GPIO_MODE_SD, 47, 13)
 };
 
-static struct rt2880_pmx_group mt7620a_pinmux_data[] = {
+static struct ralink_pmx_group mt7620a_pinmux_data[] = {
 	GRP("i2c", i2c_grp, 1, MT7620_GPIO_MODE_I2C),
 	GRP("uartf", uartf_grp, MT7620_GPIO_MODE_UART0_MASK,
 		MT7620_GPIO_MODE_UART0_SHIFT),
@@ -112,166 +112,166 @@ static struct rt2880_pmx_group mt7620a_pinmux_data[] = {
 	{ 0 }
 };
 
-static struct rt2880_pmx_func pwm1_grp_mt76x8[] = {
+static struct ralink_pmx_func pwm1_grp_mt76x8[] = {
 	FUNC("sdxc d6", 3, 19, 1),
 	FUNC("utif", 2, 19, 1),
 	FUNC("gpio", 1, 19, 1),
 	FUNC("pwm1", 0, 19, 1),
 };
 
-static struct rt2880_pmx_func pwm0_grp_mt76x8[] = {
+static struct ralink_pmx_func pwm0_grp_mt76x8[] = {
 	FUNC("sdxc d7", 3, 18, 1),
 	FUNC("utif", 2, 18, 1),
 	FUNC("gpio", 1, 18, 1),
 	FUNC("pwm0", 0, 18, 1),
 };
 
-static struct rt2880_pmx_func uart2_grp_mt76x8[] = {
+static struct ralink_pmx_func uart2_grp_mt76x8[] = {
 	FUNC("sdxc d5 d4", 3, 20, 2),
 	FUNC("pwm", 2, 20, 2),
 	FUNC("gpio", 1, 20, 2),
 	FUNC("uart2", 0, 20, 2),
 };
 
-static struct rt2880_pmx_func uart1_grp_mt76x8[] = {
+static struct ralink_pmx_func uart1_grp_mt76x8[] = {
 	FUNC("sw_r", 3, 45, 2),
 	FUNC("pwm", 2, 45, 2),
 	FUNC("gpio", 1, 45, 2),
 	FUNC("uart1", 0, 45, 2),
 };
 
-static struct rt2880_pmx_func i2c_grp_mt76x8[] = {
+static struct ralink_pmx_func i2c_grp_mt76x8[] = {
 	FUNC("-", 3, 4, 2),
 	FUNC("debug", 2, 4, 2),
 	FUNC("gpio", 1, 4, 2),
 	FUNC("i2c", 0, 4, 2),
 };
 
-static struct rt2880_pmx_func refclk_grp_mt76x8[] = { FUNC("refclk", 0, 37, 1) };
-static struct rt2880_pmx_func perst_grp_mt76x8[] = { FUNC("perst", 0, 36, 1) };
-static struct rt2880_pmx_func wdt_grp_mt76x8[] = { FUNC("wdt", 0, 38, 1) };
-static struct rt2880_pmx_func spi_grp_mt76x8[] = { FUNC("spi", 0, 7, 4) };
+static struct ralink_pmx_func refclk_grp_mt76x8[] = { FUNC("refclk", 0, 37, 1) };
+static struct ralink_pmx_func perst_grp_mt76x8[] = { FUNC("perst", 0, 36, 1) };
+static struct ralink_pmx_func wdt_grp_mt76x8[] = { FUNC("wdt", 0, 38, 1) };
+static struct ralink_pmx_func spi_grp_mt76x8[] = { FUNC("spi", 0, 7, 4) };
 
-static struct rt2880_pmx_func sd_mode_grp_mt76x8[] = {
+static struct ralink_pmx_func sd_mode_grp_mt76x8[] = {
 	FUNC("jtag", 3, 22, 8),
 	FUNC("utif", 2, 22, 8),
 	FUNC("gpio", 1, 22, 8),
 	FUNC("sdxc", 0, 22, 8),
 };
 
-static struct rt2880_pmx_func uart0_grp_mt76x8[] = {
+static struct ralink_pmx_func uart0_grp_mt76x8[] = {
 	FUNC("-", 3, 12, 2),
 	FUNC("-", 2, 12, 2),
 	FUNC("gpio", 1, 12, 2),
 	FUNC("uart0", 0, 12, 2),
 };
 
-static struct rt2880_pmx_func i2s_grp_mt76x8[] = {
+static struct ralink_pmx_func i2s_grp_mt76x8[] = {
 	FUNC("antenna", 3, 0, 4),
 	FUNC("pcm", 2, 0, 4),
 	FUNC("gpio", 1, 0, 4),
 	FUNC("i2s", 0, 0, 4),
 };
 
-static struct rt2880_pmx_func spi_cs1_grp_mt76x8[] = {
+static struct ralink_pmx_func spi_cs1_grp_mt76x8[] = {
 	FUNC("-", 3, 6, 1),
 	FUNC("refclk", 2, 6, 1),
 	FUNC("gpio", 1, 6, 1),
 	FUNC("spi cs1", 0, 6, 1),
 };
 
-static struct rt2880_pmx_func spis_grp_mt76x8[] = {
+static struct ralink_pmx_func spis_grp_mt76x8[] = {
 	FUNC("pwm_uart2", 3, 14, 4),
 	FUNC("utif", 2, 14, 4),
 	FUNC("gpio", 1, 14, 4),
 	FUNC("spis", 0, 14, 4),
 };
 
-static struct rt2880_pmx_func gpio_grp_mt76x8[] = {
+static struct ralink_pmx_func gpio_grp_mt76x8[] = {
 	FUNC("pcie", 3, 11, 1),
 	FUNC("refclk", 2, 11, 1),
 	FUNC("gpio", 1, 11, 1),
 	FUNC("gpio", 0, 11, 1),
 };
 
-static struct rt2880_pmx_func p4led_kn_grp_mt76x8[] = {
+static struct ralink_pmx_func p4led_kn_grp_mt76x8[] = {
 	FUNC("jtag", 3, 30, 1),
 	FUNC("utif", 2, 30, 1),
 	FUNC("gpio", 1, 30, 1),
 	FUNC("p4led_kn", 0, 30, 1),
 };
 
-static struct rt2880_pmx_func p3led_kn_grp_mt76x8[] = {
+static struct ralink_pmx_func p3led_kn_grp_mt76x8[] = {
 	FUNC("jtag", 3, 31, 1),
 	FUNC("utif", 2, 31, 1),
 	FUNC("gpio", 1, 31, 1),
 	FUNC("p3led_kn", 0, 31, 1),
 };
 
-static struct rt2880_pmx_func p2led_kn_grp_mt76x8[] = {
+static struct ralink_pmx_func p2led_kn_grp_mt76x8[] = {
 	FUNC("jtag", 3, 32, 1),
 	FUNC("utif", 2, 32, 1),
 	FUNC("gpio", 1, 32, 1),
 	FUNC("p2led_kn", 0, 32, 1),
 };
 
-static struct rt2880_pmx_func p1led_kn_grp_mt76x8[] = {
+static struct ralink_pmx_func p1led_kn_grp_mt76x8[] = {
 	FUNC("jtag", 3, 33, 1),
 	FUNC("utif", 2, 33, 1),
 	FUNC("gpio", 1, 33, 1),
 	FUNC("p1led_kn", 0, 33, 1),
 };
 
-static struct rt2880_pmx_func p0led_kn_grp_mt76x8[] = {
+static struct ralink_pmx_func p0led_kn_grp_mt76x8[] = {
 	FUNC("jtag", 3, 34, 1),
 	FUNC("rsvd", 2, 34, 1),
 	FUNC("gpio", 1, 34, 1),
 	FUNC("p0led_kn", 0, 34, 1),
 };
 
-static struct rt2880_pmx_func wled_kn_grp_mt76x8[] = {
+static struct ralink_pmx_func wled_kn_grp_mt76x8[] = {
 	FUNC("rsvd", 3, 35, 1),
 	FUNC("rsvd", 2, 35, 1),
 	FUNC("gpio", 1, 35, 1),
 	FUNC("wled_kn", 0, 35, 1),
 };
 
-static struct rt2880_pmx_func p4led_an_grp_mt76x8[] = {
+static struct ralink_pmx_func p4led_an_grp_mt76x8[] = {
 	FUNC("jtag", 3, 39, 1),
 	FUNC("utif", 2, 39, 1),
 	FUNC("gpio", 1, 39, 1),
 	FUNC("p4led_an", 0, 39, 1),
 };
 
-static struct rt2880_pmx_func p3led_an_grp_mt76x8[] = {
+static struct ralink_pmx_func p3led_an_grp_mt76x8[] = {
 	FUNC("jtag", 3, 40, 1),
 	FUNC("utif", 2, 40, 1),
 	FUNC("gpio", 1, 40, 1),
 	FUNC("p3led_an", 0, 40, 1),
 };
 
-static struct rt2880_pmx_func p2led_an_grp_mt76x8[] = {
+static struct ralink_pmx_func p2led_an_grp_mt76x8[] = {
 	FUNC("jtag", 3, 41, 1),
 	FUNC("utif", 2, 41, 1),
 	FUNC("gpio", 1, 41, 1),
 	FUNC("p2led_an", 0, 41, 1),
 };
 
-static struct rt2880_pmx_func p1led_an_grp_mt76x8[] = {
+static struct ralink_pmx_func p1led_an_grp_mt76x8[] = {
 	FUNC("jtag", 3, 42, 1),
 	FUNC("utif", 2, 42, 1),
 	FUNC("gpio", 1, 42, 1),
 	FUNC("p1led_an", 0, 42, 1),
 };
 
-static struct rt2880_pmx_func p0led_an_grp_mt76x8[] = {
+static struct ralink_pmx_func p0led_an_grp_mt76x8[] = {
 	FUNC("jtag", 3, 43, 1),
 	FUNC("rsvd", 2, 43, 1),
 	FUNC("gpio", 1, 43, 1),
 	FUNC("p0led_an", 0, 43, 1),
 };
 
-static struct rt2880_pmx_func wled_an_grp_mt76x8[] = {
+static struct ralink_pmx_func wled_an_grp_mt76x8[] = {
 	FUNC("rsvd", 3, 44, 1),
 	FUNC("rsvd", 2, 44, 1),
 	FUNC("gpio", 1, 44, 1),
@@ -308,7 +308,7 @@ static struct rt2880_pmx_func wled_an_grp_mt76x8[] = {
 #define MT76X8_GPIO_MODE_SPIS		2
 #define MT76X8_GPIO_MODE_GPIO		0
 
-static struct rt2880_pmx_group mt76x8_pinmux_data[] = {
+static struct ralink_pmx_group mt76x8_pinmux_data[] = {
 	GRP_G("pwm1", pwm1_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
 				1, MT76X8_GPIO_MODE_PWM1),
 	GRP_G("pwm0", pwm0_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
@@ -365,9 +365,9 @@ static struct rt2880_pmx_group mt76x8_pinmux_data[] = {
 static int mt7620_pinmux_probe(struct platform_device *pdev)
 {
 	if (is_mt76x8())
-		return rt2880_pinmux_init(pdev, mt76x8_pinmux_data);
+		return ralink_pinmux_init(pdev, mt76x8_pinmux_data);
 	else
-		return rt2880_pinmux_init(pdev, mt7620a_pinmux_data);
+		return ralink_pinmux_init(pdev, mt7620a_pinmux_data);
 }
 
 static const struct of_device_id mt7620_pinmux_match[] = {
diff --git a/drivers/pinctrl/ralink/pinctrl-mt7621.c b/drivers/pinctrl/ralink/pinctrl-mt7621.c
index 7d96144c474e..14b89cb43d4c 100644
--- a/drivers/pinctrl/ralink/pinctrl-mt7621.c
+++ b/drivers/pinctrl/ralink/pinctrl-mt7621.c
@@ -3,7 +3,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
-#include "pinmux.h"
+#include "pinctrl-ralink.h"
 
 #define MT7621_GPIO_MODE_UART1		1
 #define MT7621_GPIO_MODE_I2C		2
@@ -34,40 +34,40 @@
 #define MT7621_GPIO_MODE_SDHCI_SHIFT	18
 #define MT7621_GPIO_MODE_SDHCI_GPIO	1
 
-static struct rt2880_pmx_func uart1_grp[] =  { FUNC("uart1", 0, 1, 2) };
-static struct rt2880_pmx_func i2c_grp[] =  { FUNC("i2c", 0, 3, 2) };
-static struct rt2880_pmx_func uart3_grp[] = {
+static struct ralink_pmx_func uart1_grp[] =  { FUNC("uart1", 0, 1, 2) };
+static struct ralink_pmx_func i2c_grp[] =  { FUNC("i2c", 0, 3, 2) };
+static struct ralink_pmx_func uart3_grp[] = {
 	FUNC("uart3", 0, 5, 4),
 	FUNC("i2s", 2, 5, 4),
 	FUNC("spdif3", 3, 5, 4),
 };
-static struct rt2880_pmx_func uart2_grp[] = {
+static struct ralink_pmx_func uart2_grp[] = {
 	FUNC("uart2", 0, 9, 4),
 	FUNC("pcm", 2, 9, 4),
 	FUNC("spdif2", 3, 9, 4),
 };
-static struct rt2880_pmx_func jtag_grp[] = { FUNC("jtag", 0, 13, 5) };
-static struct rt2880_pmx_func wdt_grp[] = {
+static struct ralink_pmx_func jtag_grp[] = { FUNC("jtag", 0, 13, 5) };
+static struct ralink_pmx_func wdt_grp[] = {
 	FUNC("wdt rst", 0, 18, 1),
 	FUNC("wdt refclk", 2, 18, 1),
 };
-static struct rt2880_pmx_func pcie_rst_grp[] = {
+static struct ralink_pmx_func pcie_rst_grp[] = {
 	FUNC("pcie rst", MT7621_GPIO_MODE_PCIE_RST, 19, 1),
 	FUNC("pcie refclk", MT7621_GPIO_MODE_PCIE_REF, 19, 1)
 };
-static struct rt2880_pmx_func mdio_grp[] = { FUNC("mdio", 0, 20, 2) };
-static struct rt2880_pmx_func rgmii2_grp[] = { FUNC("rgmii2", 0, 22, 12) };
-static struct rt2880_pmx_func spi_grp[] = {
+static struct ralink_pmx_func mdio_grp[] = { FUNC("mdio", 0, 20, 2) };
+static struct ralink_pmx_func rgmii2_grp[] = { FUNC("rgmii2", 0, 22, 12) };
+static struct ralink_pmx_func spi_grp[] = {
 	FUNC("spi", 0, 34, 7),
 	FUNC("nand1", 2, 34, 7),
 };
-static struct rt2880_pmx_func sdhci_grp[] = {
+static struct ralink_pmx_func sdhci_grp[] = {
 	FUNC("sdhci", 0, 41, 8),
 	FUNC("nand2", 2, 41, 8),
 };
-static struct rt2880_pmx_func rgmii1_grp[] = { FUNC("rgmii1", 0, 49, 12) };
+static struct ralink_pmx_func rgmii1_grp[] = { FUNC("rgmii1", 0, 49, 12) };
 
-static struct rt2880_pmx_group mt7621_pinmux_data[] = {
+static struct ralink_pmx_group mt7621_pinmux_data[] = {
 	GRP("uart1", uart1_grp, 1, MT7621_GPIO_MODE_UART1),
 	GRP("i2c", i2c_grp, 1, MT7621_GPIO_MODE_I2C),
 	GRP_G("uart3", uart3_grp, MT7621_GPIO_MODE_UART3_MASK,
@@ -92,7 +92,7 @@ static struct rt2880_pmx_group mt7621_pinmux_data[] = {
 
 static int mt7621_pinmux_probe(struct platform_device *pdev)
 {
-	return rt2880_pinmux_init(pdev, mt7621_pinmux_data);
+	return ralink_pinmux_init(pdev, mt7621_pinmux_data);
 }
 
 static const struct of_device_id mt7621_pinmux_match[] = {
diff --git a/drivers/pinctrl/ralink/pinctrl-rt2880.c b/drivers/pinctrl/ralink/pinctrl-ralink.c
similarity index 73%
rename from drivers/pinctrl/ralink/pinctrl-rt2880.c
rename to drivers/pinctrl/ralink/pinctrl-ralink.c
index 96fc06d1b8b9..841f23f55c95 100644
--- a/drivers/pinctrl/ralink/pinctrl-rt2880.c
+++ b/drivers/pinctrl/ralink/pinctrl-ralink.c
@@ -19,23 +19,23 @@
 #include <asm/mach-ralink/ralink_regs.h>
 #include <asm/mach-ralink/mt7620.h>
 
-#include "pinmux.h"
+#include "pinctrl-ralink.h"
 #include "../core.h"
 #include "../pinctrl-utils.h"
 
 #define SYSC_REG_GPIO_MODE	0x60
 #define SYSC_REG_GPIO_MODE2	0x64
 
-struct rt2880_priv {
+struct ralink_priv {
 	struct device *dev;
 
 	struct pinctrl_pin_desc *pads;
 	struct pinctrl_desc *desc;
 
-	struct rt2880_pmx_func **func;
+	struct ralink_pmx_func **func;
 	int func_count;
 
-	struct rt2880_pmx_group *groups;
+	struct ralink_pmx_group *groups;
 	const char **group_names;
 	int group_count;
 
@@ -43,27 +43,27 @@ struct rt2880_priv {
 	int max_pins;
 };
 
-static int rt2880_get_group_count(struct pinctrl_dev *pctrldev)
+static int ralink_get_group_count(struct pinctrl_dev *pctrldev)
 {
-	struct rt2880_priv *p = pinctrl_dev_get_drvdata(pctrldev);
+	struct ralink_priv *p = pinctrl_dev_get_drvdata(pctrldev);
 
 	return p->group_count;
 }
 
-static const char *rt2880_get_group_name(struct pinctrl_dev *pctrldev,
+static const char *ralink_get_group_name(struct pinctrl_dev *pctrldev,
 					 unsigned int group)
 {
-	struct rt2880_priv *p = pinctrl_dev_get_drvdata(pctrldev);
+	struct ralink_priv *p = pinctrl_dev_get_drvdata(pctrldev);
 
 	return (group >= p->group_count) ? NULL : p->group_names[group];
 }
 
-static int rt2880_get_group_pins(struct pinctrl_dev *pctrldev,
+static int ralink_get_group_pins(struct pinctrl_dev *pctrldev,
 				 unsigned int group,
 				 const unsigned int **pins,
 				 unsigned int *num_pins)
 {
-	struct rt2880_priv *p = pinctrl_dev_get_drvdata(pctrldev);
+	struct ralink_priv *p = pinctrl_dev_get_drvdata(pctrldev);
 
 	if (group >= p->group_count)
 		return -EINVAL;
@@ -74,35 +74,35 @@ static int rt2880_get_group_pins(struct pinctrl_dev *pctrldev,
 	return 0;
 }
 
-static const struct pinctrl_ops rt2880_pctrl_ops = {
-	.get_groups_count	= rt2880_get_group_count,
-	.get_group_name		= rt2880_get_group_name,
-	.get_group_pins		= rt2880_get_group_pins,
+static const struct pinctrl_ops ralink_pctrl_ops = {
+	.get_groups_count	= ralink_get_group_count,
+	.get_group_name		= ralink_get_group_name,
+	.get_group_pins		= ralink_get_group_pins,
 	.dt_node_to_map		= pinconf_generic_dt_node_to_map_all,
 	.dt_free_map		= pinconf_generic_dt_free_map,
 };
 
-static int rt2880_pmx_func_count(struct pinctrl_dev *pctrldev)
+static int ralink_pmx_func_count(struct pinctrl_dev *pctrldev)
 {
-	struct rt2880_priv *p = pinctrl_dev_get_drvdata(pctrldev);
+	struct ralink_priv *p = pinctrl_dev_get_drvdata(pctrldev);
 
 	return p->func_count;
 }
 
-static const char *rt2880_pmx_func_name(struct pinctrl_dev *pctrldev,
+static const char *ralink_pmx_func_name(struct pinctrl_dev *pctrldev,
 					unsigned int func)
 {
-	struct rt2880_priv *p = pinctrl_dev_get_drvdata(pctrldev);
+	struct ralink_priv *p = pinctrl_dev_get_drvdata(pctrldev);
 
 	return p->func[func]->name;
 }
 
-static int rt2880_pmx_group_get_groups(struct pinctrl_dev *pctrldev,
+static int ralink_pmx_group_get_groups(struct pinctrl_dev *pctrldev,
 				       unsigned int func,
 				       const char * const **groups,
 				       unsigned int * const num_groups)
 {
-	struct rt2880_priv *p = pinctrl_dev_get_drvdata(pctrldev);
+	struct ralink_priv *p = pinctrl_dev_get_drvdata(pctrldev);
 
 	if (p->func[func]->group_count == 1)
 		*groups = &p->group_names[p->func[func]->groups[0]];
@@ -114,10 +114,10 @@ static int rt2880_pmx_group_get_groups(struct pinctrl_dev *pctrldev,
 	return 0;
 }
 
-static int rt2880_pmx_group_enable(struct pinctrl_dev *pctrldev,
+static int ralink_pmx_group_enable(struct pinctrl_dev *pctrldev,
 				   unsigned int func, unsigned int group)
 {
-	struct rt2880_priv *p = pinctrl_dev_get_drvdata(pctrldev);
+	struct ralink_priv *p = pinctrl_dev_get_drvdata(pctrldev);
 	u32 mode = 0;
 	u32 reg = SYSC_REG_GPIO_MODE;
 	int i;
@@ -158,11 +158,11 @@ static int rt2880_pmx_group_enable(struct pinctrl_dev *pctrldev,
 	return 0;
 }
 
-static int rt2880_pmx_group_gpio_request_enable(struct pinctrl_dev *pctrldev,
+static int ralink_pmx_group_gpio_request_enable(struct pinctrl_dev *pctrldev,
 						struct pinctrl_gpio_range *range,
 						unsigned int pin)
 {
-	struct rt2880_priv *p = pinctrl_dev_get_drvdata(pctrldev);
+	struct ralink_priv *p = pinctrl_dev_get_drvdata(pctrldev);
 
 	if (!p->gpio[pin]) {
 		dev_err(p->dev, "pin %d is not set to gpio mux\n", pin);
@@ -172,28 +172,28 @@ static int rt2880_pmx_group_gpio_request_enable(struct pinctrl_dev *pctrldev,
 	return 0;
 }
 
-static const struct pinmux_ops rt2880_pmx_group_ops = {
-	.get_functions_count	= rt2880_pmx_func_count,
-	.get_function_name	= rt2880_pmx_func_name,
-	.get_function_groups	= rt2880_pmx_group_get_groups,
-	.set_mux		= rt2880_pmx_group_enable,
-	.gpio_request_enable	= rt2880_pmx_group_gpio_request_enable,
+static const struct pinmux_ops ralink_pmx_group_ops = {
+	.get_functions_count	= ralink_pmx_func_count,
+	.get_function_name	= ralink_pmx_func_name,
+	.get_function_groups	= ralink_pmx_group_get_groups,
+	.set_mux		= ralink_pmx_group_enable,
+	.gpio_request_enable	= ralink_pmx_group_gpio_request_enable,
 };
 
-static struct pinctrl_desc rt2880_pctrl_desc = {
+static struct pinctrl_desc ralink_pctrl_desc = {
 	.owner		= THIS_MODULE,
-	.name		= "rt2880-pinmux",
-	.pctlops	= &rt2880_pctrl_ops,
-	.pmxops		= &rt2880_pmx_group_ops,
+	.name		= "ralink-pinmux",
+	.pctlops	= &ralink_pctrl_ops,
+	.pmxops		= &ralink_pmx_group_ops,
 };
 
-static struct rt2880_pmx_func gpio_func = {
+static struct ralink_pmx_func gpio_func = {
 	.name = "gpio",
 };
 
-static int rt2880_pinmux_index(struct rt2880_priv *p)
+static int ralink_pinmux_index(struct ralink_priv *p)
 {
-	struct rt2880_pmx_group *mux = p->groups;
+	struct ralink_pmx_group *mux = p->groups;
 	int i, j, c = 0;
 
 	/* count the mux functions */
@@ -248,7 +248,7 @@ static int rt2880_pinmux_index(struct rt2880_priv *p)
 	return 0;
 }
 
-static int rt2880_pinmux_pins(struct rt2880_priv *p)
+static int ralink_pinmux_pins(struct ralink_priv *p)
 {
 	int i, j;
 
@@ -311,10 +311,10 @@ static int rt2880_pinmux_pins(struct rt2880_priv *p)
 	return 0;
 }
 
-int rt2880_pinmux_init(struct platform_device *pdev,
-		       struct rt2880_pmx_group *data)
+int ralink_pinmux_init(struct platform_device *pdev,
+		       struct ralink_pmx_group *data)
 {
-	struct rt2880_priv *p;
+	struct ralink_priv *p;
 	struct pinctrl_dev *dev;
 	int err;
 
@@ -322,23 +322,23 @@ int rt2880_pinmux_init(struct platform_device *pdev,
 		return -ENOTSUPP;
 
 	/* setup the private data */
-	p = devm_kzalloc(&pdev->dev, sizeof(struct rt2880_priv), GFP_KERNEL);
+	p = devm_kzalloc(&pdev->dev, sizeof(struct ralink_priv), GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
 
 	p->dev = &pdev->dev;
-	p->desc = &rt2880_pctrl_desc;
+	p->desc = &ralink_pctrl_desc;
 	p->groups = data;
 	platform_set_drvdata(pdev, p);
 
 	/* init the device */
-	err = rt2880_pinmux_index(p);
+	err = ralink_pinmux_index(p);
 	if (err) {
 		dev_err(&pdev->dev, "failed to load index\n");
 		return err;
 	}
 
-	err = rt2880_pinmux_pins(p);
+	err = ralink_pinmux_pins(p);
 	if (err) {
 		dev_err(&pdev->dev, "failed to load pins\n");
 		return err;
diff --git a/drivers/pinctrl/ralink/pinmux.h b/drivers/pinctrl/ralink/pinctrl-ralink.h
similarity index 75%
rename from drivers/pinctrl/ralink/pinmux.h
rename to drivers/pinctrl/ralink/pinctrl-ralink.h
index 0046abe3bcc7..134969409585 100644
--- a/drivers/pinctrl/ralink/pinmux.h
+++ b/drivers/pinctrl/ralink/pinctrl-ralink.h
@@ -3,8 +3,8 @@
  *  Copyright (C) 2012 John Crispin <john@phrozen.org>
  */
 
-#ifndef _RT288X_PINMUX_H__
-#define _RT288X_PINMUX_H__
+#ifndef _PINCTRL_RALINK_H__
+#define _PINCTRL_RALINK_H__
 
 #define FUNC(name, value, pin_first, pin_count) \
 	{ name, value, pin_first, pin_count }
@@ -19,9 +19,9 @@
 	  .func = _func, .gpio = _gpio, \
 	  .func_count = ARRAY_SIZE(_func) }
 
-struct rt2880_pmx_group;
+struct ralink_pmx_group;
 
-struct rt2880_pmx_func {
+struct ralink_pmx_func {
 	const char *name;
 	const char value;
 
@@ -35,7 +35,7 @@ struct rt2880_pmx_func {
 	int enabled;
 };
 
-struct rt2880_pmx_group {
+struct ralink_pmx_group {
 	const char *name;
 	int enabled;
 
@@ -43,11 +43,11 @@ struct rt2880_pmx_group {
 	const char mask;
 	const char gpio;
 
-	struct rt2880_pmx_func *func;
+	struct ralink_pmx_func *func;
 	int func_count;
 };
 
-int rt2880_pinmux_init(struct platform_device *pdev,
-		       struct rt2880_pmx_group *data);
+int ralink_pinmux_init(struct platform_device *pdev,
+		       struct ralink_pmx_group *data);
 
 #endif
diff --git a/drivers/pinctrl/ralink/pinctrl-rt288x.c b/drivers/pinctrl/ralink/pinctrl-rt288x.c
index 0744aebbace5..40c45140ff8a 100644
--- a/drivers/pinctrl/ralink/pinctrl-rt288x.c
+++ b/drivers/pinctrl/ralink/pinctrl-rt288x.c
@@ -4,7 +4,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
-#include "pinmux.h"
+#include "pinctrl-ralink.h"
 
 #define RT2880_GPIO_MODE_I2C		BIT(0)
 #define RT2880_GPIO_MODE_UART0		BIT(1)
@@ -15,15 +15,15 @@
 #define RT2880_GPIO_MODE_SDRAM		BIT(6)
 #define RT2880_GPIO_MODE_PCI		BIT(7)
 
-static struct rt2880_pmx_func i2c_func[] = { FUNC("i2c", 0, 1, 2) };
-static struct rt2880_pmx_func spi_func[] = { FUNC("spi", 0, 3, 4) };
-static struct rt2880_pmx_func uartlite_func[] = { FUNC("uartlite", 0, 7, 8) };
-static struct rt2880_pmx_func jtag_func[] = { FUNC("jtag", 0, 17, 5) };
-static struct rt2880_pmx_func mdio_func[] = { FUNC("mdio", 0, 22, 2) };
-static struct rt2880_pmx_func sdram_func[] = { FUNC("sdram", 0, 24, 16) };
-static struct rt2880_pmx_func pci_func[] = { FUNC("pci", 0, 40, 32) };
+static struct ralink_pmx_func i2c_func[] = { FUNC("i2c", 0, 1, 2) };
+static struct ralink_pmx_func spi_func[] = { FUNC("spi", 0, 3, 4) };
+static struct ralink_pmx_func uartlite_func[] = { FUNC("uartlite", 0, 7, 8) };
+static struct ralink_pmx_func jtag_func[] = { FUNC("jtag", 0, 17, 5) };
+static struct ralink_pmx_func mdio_func[] = { FUNC("mdio", 0, 22, 2) };
+static struct ralink_pmx_func sdram_func[] = { FUNC("sdram", 0, 24, 16) };
+static struct ralink_pmx_func pci_func[] = { FUNC("pci", 0, 40, 32) };
 
-static struct rt2880_pmx_group rt2880_pinmux_data_act[] = {
+static struct ralink_pmx_group rt2880_pinmux_data_act[] = {
 	GRP("i2c", i2c_func, 1, RT2880_GPIO_MODE_I2C),
 	GRP("spi", spi_func, 1, RT2880_GPIO_MODE_SPI),
 	GRP("uartlite", uartlite_func, 1, RT2880_GPIO_MODE_UART0),
@@ -36,7 +36,7 @@ static struct rt2880_pmx_group rt2880_pinmux_data_act[] = {
 
 static int rt288x_pinmux_probe(struct platform_device *pdev)
 {
-	return rt2880_pinmux_init(pdev, rt2880_pinmux_data_act);
+	return ralink_pinmux_init(pdev, rt2880_pinmux_data_act);
 }
 
 static const struct of_device_id rt288x_pinmux_match[] = {
diff --git a/drivers/pinctrl/ralink/pinctrl-rt305x.c b/drivers/pinctrl/ralink/pinctrl-rt305x.c
index 5d8fa156c003..25527ca1ccaa 100644
--- a/drivers/pinctrl/ralink/pinctrl-rt305x.c
+++ b/drivers/pinctrl/ralink/pinctrl-rt305x.c
@@ -5,7 +5,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
-#include "pinmux.h"
+#include "pinctrl-ralink.h"
 
 #define RT305X_GPIO_MODE_UART0_SHIFT	2
 #define RT305X_GPIO_MODE_UART0_MASK	0x7
@@ -31,9 +31,9 @@
 #define RT3352_GPIO_MODE_LNA		18
 #define RT3352_GPIO_MODE_PA		20
 
-static struct rt2880_pmx_func i2c_func[] =  { FUNC("i2c", 0, 1, 2) };
-static struct rt2880_pmx_func spi_func[] = { FUNC("spi", 0, 3, 4) };
-static struct rt2880_pmx_func uartf_func[] = {
+static struct ralink_pmx_func i2c_func[] =  { FUNC("i2c", 0, 1, 2) };
+static struct ralink_pmx_func spi_func[] = { FUNC("spi", 0, 3, 4) };
+static struct ralink_pmx_func uartf_func[] = {
 	FUNC("uartf", RT305X_GPIO_MODE_UARTF, 7, 8),
 	FUNC("pcm uartf", RT305X_GPIO_MODE_PCM_UARTF, 7, 8),
 	FUNC("pcm i2s", RT305X_GPIO_MODE_PCM_I2S, 7, 8),
@@ -42,28 +42,28 @@ static struct rt2880_pmx_func uartf_func[] = {
 	FUNC("gpio uartf", RT305X_GPIO_MODE_GPIO_UARTF, 7, 4),
 	FUNC("gpio i2s", RT305X_GPIO_MODE_GPIO_I2S, 7, 4),
 };
-static struct rt2880_pmx_func uartlite_func[] = { FUNC("uartlite", 0, 15, 2) };
-static struct rt2880_pmx_func jtag_func[] = { FUNC("jtag", 0, 17, 5) };
-static struct rt2880_pmx_func mdio_func[] = { FUNC("mdio", 0, 22, 2) };
-static struct rt2880_pmx_func rt5350_led_func[] = { FUNC("led", 0, 22, 5) };
-static struct rt2880_pmx_func rt5350_cs1_func[] = {
+static struct ralink_pmx_func uartlite_func[] = { FUNC("uartlite", 0, 15, 2) };
+static struct ralink_pmx_func jtag_func[] = { FUNC("jtag", 0, 17, 5) };
+static struct ralink_pmx_func mdio_func[] = { FUNC("mdio", 0, 22, 2) };
+static struct ralink_pmx_func rt5350_led_func[] = { FUNC("led", 0, 22, 5) };
+static struct ralink_pmx_func rt5350_cs1_func[] = {
 	FUNC("spi_cs1", 0, 27, 1),
 	FUNC("wdg_cs1", 1, 27, 1),
 };
-static struct rt2880_pmx_func sdram_func[] = { FUNC("sdram", 0, 24, 16) };
-static struct rt2880_pmx_func rt3352_rgmii_func[] = {
+static struct ralink_pmx_func sdram_func[] = { FUNC("sdram", 0, 24, 16) };
+static struct ralink_pmx_func rt3352_rgmii_func[] = {
 	FUNC("rgmii", 0, 24, 12)
 };
-static struct rt2880_pmx_func rgmii_func[] = { FUNC("rgmii", 0, 40, 12) };
-static struct rt2880_pmx_func rt3352_lna_func[] = { FUNC("lna", 0, 36, 2) };
-static struct rt2880_pmx_func rt3352_pa_func[] = { FUNC("pa", 0, 38, 2) };
-static struct rt2880_pmx_func rt3352_led_func[] = { FUNC("led", 0, 40, 5) };
-static struct rt2880_pmx_func rt3352_cs1_func[] = {
+static struct ralink_pmx_func rgmii_func[] = { FUNC("rgmii", 0, 40, 12) };
+static struct ralink_pmx_func rt3352_lna_func[] = { FUNC("lna", 0, 36, 2) };
+static struct ralink_pmx_func rt3352_pa_func[] = { FUNC("pa", 0, 38, 2) };
+static struct ralink_pmx_func rt3352_led_func[] = { FUNC("led", 0, 40, 5) };
+static struct ralink_pmx_func rt3352_cs1_func[] = {
 	FUNC("spi_cs1", 0, 45, 1),
 	FUNC("wdg_cs1", 1, 45, 1),
 };
 
-static struct rt2880_pmx_group rt3050_pinmux_data[] = {
+static struct ralink_pmx_group rt3050_pinmux_data[] = {
 	GRP("i2c", i2c_func, 1, RT305X_GPIO_MODE_I2C),
 	GRP("spi", spi_func, 1, RT305X_GPIO_MODE_SPI),
 	GRP("uartf", uartf_func, RT305X_GPIO_MODE_UART0_MASK,
@@ -76,7 +76,7 @@ static struct rt2880_pmx_group rt3050_pinmux_data[] = {
 	{ 0 }
 };
 
-static struct rt2880_pmx_group rt3352_pinmux_data[] = {
+static struct ralink_pmx_group rt3352_pinmux_data[] = {
 	GRP("i2c", i2c_func, 1, RT305X_GPIO_MODE_I2C),
 	GRP("spi", spi_func, 1, RT305X_GPIO_MODE_SPI),
 	GRP("uartf", uartf_func, RT305X_GPIO_MODE_UART0_MASK,
@@ -92,7 +92,7 @@ static struct rt2880_pmx_group rt3352_pinmux_data[] = {
 	{ 0 }
 };
 
-static struct rt2880_pmx_group rt5350_pinmux_data[] = {
+static struct ralink_pmx_group rt5350_pinmux_data[] = {
 	GRP("i2c", i2c_func, 1, RT305X_GPIO_MODE_I2C),
 	GRP("spi", spi_func, 1, RT305X_GPIO_MODE_SPI),
 	GRP("uartf", uartf_func, RT305X_GPIO_MODE_UART0_MASK,
@@ -107,11 +107,11 @@ static struct rt2880_pmx_group rt5350_pinmux_data[] = {
 static int rt305x_pinmux_probe(struct platform_device *pdev)
 {
 	if (soc_is_rt5350())
-		return rt2880_pinmux_init(pdev, rt5350_pinmux_data);
+		return ralink_pinmux_init(pdev, rt5350_pinmux_data);
 	else if (soc_is_rt305x() || soc_is_rt3350())
-		return rt2880_pinmux_init(pdev, rt3050_pinmux_data);
+		return ralink_pinmux_init(pdev, rt3050_pinmux_data);
 	else if (soc_is_rt3352())
-		return rt2880_pinmux_init(pdev, rt3352_pinmux_data);
+		return ralink_pinmux_init(pdev, rt3352_pinmux_data);
 	else
 		return -EINVAL;
 }
diff --git a/drivers/pinctrl/ralink/pinctrl-rt3883.c b/drivers/pinctrl/ralink/pinctrl-rt3883.c
index 3e0e1b4caa64..0b8674dbe188 100644
--- a/drivers/pinctrl/ralink/pinctrl-rt3883.c
+++ b/drivers/pinctrl/ralink/pinctrl-rt3883.c
@@ -3,7 +3,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
-#include "pinmux.h"
+#include "pinctrl-ralink.h"
 
 #define RT3883_GPIO_MODE_UART0_SHIFT	2
 #define RT3883_GPIO_MODE_UART0_MASK	0x7
@@ -39,9 +39,9 @@
 #define RT3883_GPIO_MODE_LNA_G_GPIO	0x3
 #define RT3883_GPIO_MODE_LNA_G		_RT3883_GPIO_MODE_LNA_G(RT3883_GPIO_MODE_LNA_G_MASK)
 
-static struct rt2880_pmx_func i2c_func[] =  { FUNC("i2c", 0, 1, 2) };
-static struct rt2880_pmx_func spi_func[] = { FUNC("spi", 0, 3, 4) };
-static struct rt2880_pmx_func uartf_func[] = {
+static struct ralink_pmx_func i2c_func[] =  { FUNC("i2c", 0, 1, 2) };
+static struct ralink_pmx_func spi_func[] = { FUNC("spi", 0, 3, 4) };
+static struct ralink_pmx_func uartf_func[] = {
 	FUNC("uartf", RT3883_GPIO_MODE_UARTF, 7, 8),
 	FUNC("pcm uartf", RT3883_GPIO_MODE_PCM_UARTF, 7, 8),
 	FUNC("pcm i2s", RT3883_GPIO_MODE_PCM_I2S, 7, 8),
@@ -50,21 +50,21 @@ static struct rt2880_pmx_func uartf_func[] = {
 	FUNC("gpio uartf", RT3883_GPIO_MODE_GPIO_UARTF, 7, 4),
 	FUNC("gpio i2s", RT3883_GPIO_MODE_GPIO_I2S, 7, 4),
 };
-static struct rt2880_pmx_func uartlite_func[] = { FUNC("uartlite", 0, 15, 2) };
-static struct rt2880_pmx_func jtag_func[] = { FUNC("jtag", 0, 17, 5) };
-static struct rt2880_pmx_func mdio_func[] = { FUNC("mdio", 0, 22, 2) };
-static struct rt2880_pmx_func lna_a_func[] = { FUNC("lna a", 0, 32, 3) };
-static struct rt2880_pmx_func lna_g_func[] = { FUNC("lna g", 0, 35, 3) };
-static struct rt2880_pmx_func pci_func[] = {
+static struct ralink_pmx_func uartlite_func[] = { FUNC("uartlite", 0, 15, 2) };
+static struct ralink_pmx_func jtag_func[] = { FUNC("jtag", 0, 17, 5) };
+static struct ralink_pmx_func mdio_func[] = { FUNC("mdio", 0, 22, 2) };
+static struct ralink_pmx_func lna_a_func[] = { FUNC("lna a", 0, 32, 3) };
+static struct ralink_pmx_func lna_g_func[] = { FUNC("lna g", 0, 35, 3) };
+static struct ralink_pmx_func pci_func[] = {
 	FUNC("pci-dev", 0, 40, 32),
 	FUNC("pci-host2", 1, 40, 32),
 	FUNC("pci-host1", 2, 40, 32),
 	FUNC("pci-fnc", 3, 40, 32)
 };
-static struct rt2880_pmx_func ge1_func[] = { FUNC("ge1", 0, 72, 12) };
-static struct rt2880_pmx_func ge2_func[] = { FUNC("ge2", 0, 84, 12) };
+static struct ralink_pmx_func ge1_func[] = { FUNC("ge1", 0, 72, 12) };
+static struct ralink_pmx_func ge2_func[] = { FUNC("ge2", 0, 84, 12) };
 
-static struct rt2880_pmx_group rt3883_pinmux_data[] = {
+static struct ralink_pmx_group rt3883_pinmux_data[] = {
 	GRP("i2c", i2c_func, 1, RT3883_GPIO_MODE_I2C),
 	GRP("spi", spi_func, 1, RT3883_GPIO_MODE_SPI),
 	GRP("uartf", uartf_func, RT3883_GPIO_MODE_UART0_MASK,
@@ -83,7 +83,7 @@ static struct rt2880_pmx_group rt3883_pinmux_data[] = {
 
 static int rt3883_pinmux_probe(struct platform_device *pdev)
 {
-	return rt2880_pinmux_init(pdev, rt3883_pinmux_data);
+	return ralink_pinmux_init(pdev, rt3883_pinmux_data);
 }
 
 static const struct of_device_id rt3883_pinmux_match[] = {
-- 
2.35.1



