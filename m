Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E8A505344
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240520AbiDRM4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240301AbiDRMzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:55:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E802C33;
        Mon, 18 Apr 2022 05:37:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D51D6118A;
        Mon, 18 Apr 2022 12:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB02C385A1;
        Mon, 18 Apr 2022 12:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285426;
        bh=nWwJ6lfcdJvL3BYIz9PfXu+uR1ljjGZ1e0ba5xvWYrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sf0s8qHkDfRy6hCnjNk+pOfVqItO95DwRsL1AikYbtk6DS0nh4/dpRch67YhH5QAL
         8O2/PGzAyo/W0BjYsSAs3gzthqiDJJcWbmLGrx+W+D0IBjZ8faFtJ7AU8DrHi9RuQo
         pex+OFFCk3M9p7iPGL3AjZb4IfBndhDEp0VSIItI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/105] net: mdio: Alphabetically sort header inclusion
Date:   Mon, 18 Apr 2022 14:12:17 +0200
Message-Id: <20220418121146.321642135@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
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

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

[ Upstream commit 1bf343665057312167750509b0c48e8299293ac5 ]

Alphabetically sort header inclusion

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-bcm-unimac.c      | 16 +++++++---------
 drivers/net/mdio/mdio-bitbang.c         |  4 ++--
 drivers/net/mdio/mdio-cavium.c          |  2 +-
 drivers/net/mdio/mdio-gpio.c            | 10 +++++-----
 drivers/net/mdio/mdio-ipq4019.c         |  4 ++--
 drivers/net/mdio/mdio-ipq8064.c         |  4 ++--
 drivers/net/mdio/mdio-mscc-miim.c       |  8 ++++----
 drivers/net/mdio/mdio-mux-bcm-iproc.c   | 10 +++++-----
 drivers/net/mdio/mdio-mux-gpio.c        |  8 ++++----
 drivers/net/mdio/mdio-mux-mmioreg.c     |  6 +++---
 drivers/net/mdio/mdio-mux-multiplexer.c |  2 +-
 drivers/net/mdio/mdio-mux.c             |  6 +++---
 drivers/net/mdio/mdio-octeon.c          |  8 ++++----
 drivers/net/mdio/mdio-thunder.c         | 10 +++++-----
 drivers/net/mdio/mdio-xgene.c           |  6 +++---
 drivers/net/mdio/of_mdio.c              | 10 +++++-----
 16 files changed, 56 insertions(+), 58 deletions(-)

diff --git a/drivers/net/mdio/mdio-bcm-unimac.c b/drivers/net/mdio/mdio-bcm-unimac.c
index fbd36891ee64..5d171e7f118d 100644
--- a/drivers/net/mdio/mdio-bcm-unimac.c
+++ b/drivers/net/mdio/mdio-bcm-unimac.c
@@ -5,20 +5,18 @@
  * Copyright (C) 2014-2017 Broadcom
  */
 
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
-#include <linux/phy.h>
-#include <linux/platform_device.h>
-#include <linux/sched.h>
 #include <linux/module.h>
-#include <linux/io.h>
-#include <linux/delay.h>
-#include <linux/clk.h>
-
 #include <linux/of.h>
-#include <linux/of_platform.h>
 #include <linux/of_mdio.h>
-
+#include <linux/of_platform.h>
+#include <linux/phy.h>
 #include <linux/platform_data/mdio-bcm-unimac.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
 
 #define MDIO_CMD		0x00
 #define  MDIO_START_BUSY	(1 << 29)
diff --git a/drivers/net/mdio/mdio-bitbang.c b/drivers/net/mdio/mdio-bitbang.c
index 5136275c8e73..99588192cc78 100644
--- a/drivers/net/mdio/mdio-bitbang.c
+++ b/drivers/net/mdio/mdio-bitbang.c
@@ -14,10 +14,10 @@
  * Vitaly Bordug <vbordug@ru.mvista.com>
  */
 
-#include <linux/module.h>
+#include <linux/delay.h>
 #include <linux/mdio-bitbang.h>
+#include <linux/module.h>
 #include <linux/types.h>
-#include <linux/delay.h>
 
 #define MDIO_READ 2
 #define MDIO_WRITE 1
diff --git a/drivers/net/mdio/mdio-cavium.c b/drivers/net/mdio/mdio-cavium.c
index 1afd6fc1a351..95ce274c1be1 100644
--- a/drivers/net/mdio/mdio-cavium.c
+++ b/drivers/net/mdio/mdio-cavium.c
@@ -4,9 +4,9 @@
  */
 
 #include <linux/delay.h>
+#include <linux/io.h>
 #include <linux/module.h>
 #include <linux/phy.h>
-#include <linux/io.h>
 
 #include "mdio-cavium.h"
 
diff --git a/drivers/net/mdio/mdio-gpio.c b/drivers/net/mdio/mdio-gpio.c
index 1b00235d7dc5..56c8f914f893 100644
--- a/drivers/net/mdio/mdio-gpio.c
+++ b/drivers/net/mdio/mdio-gpio.c
@@ -17,15 +17,15 @@
  * Vitaly Bordug <vbordug@ru.mvista.com>
  */
 
-#include <linux/module.h>
-#include <linux/slab.h>
+#include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
-#include <linux/platform_device.h>
-#include <linux/platform_data/mdio-gpio.h>
 #include <linux/mdio-bitbang.h>
 #include <linux/mdio-gpio.h>
-#include <linux/gpio/consumer.h>
+#include <linux/module.h>
 #include <linux/of_mdio.h>
+#include <linux/platform_data/mdio-gpio.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
 
 struct mdio_gpio_info {
 	struct mdiobb_ctrl ctrl;
diff --git a/drivers/net/mdio/mdio-ipq4019.c b/drivers/net/mdio/mdio-ipq4019.c
index 25c25ea6da66..9cd71d896963 100644
--- a/drivers/net/mdio/mdio-ipq4019.c
+++ b/drivers/net/mdio/mdio-ipq4019.c
@@ -3,10 +3,10 @@
 /* Copyright (c) 2020 Sartura Ltd. */
 
 #include <linux/delay.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
diff --git a/drivers/net/mdio/mdio-ipq8064.c b/drivers/net/mdio/mdio-ipq8064.c
index f0a6bfa61645..49d4e9aa30bb 100644
--- a/drivers/net/mdio/mdio-ipq8064.c
+++ b/drivers/net/mdio/mdio-ipq8064.c
@@ -7,12 +7,12 @@
 
 #include <linux/delay.h>
 #include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
 #include <linux/module.h>
-#include <linux/regmap.h>
 #include <linux/of_mdio.h>
 #include <linux/of_address.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
 
 /* MII address register definitions */
 #define MII_ADDR_REG_ADDR                       0x10
diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 1c9232fca1e2..037649bef92e 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -6,14 +6,14 @@
  * Copyright (c) 2017 Microsemi Corporation
  */
 
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/phy.h>
-#include <linux/platform_device.h>
 #include <linux/bitops.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/of_mdio.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
 
 #define MSCC_MIIM_REG_STATUS		0x0
 #define		MSCC_MIIM_STATUS_STAT_PENDING	BIT(2)
diff --git a/drivers/net/mdio/mdio-mux-bcm-iproc.c b/drivers/net/mdio/mdio-mux-bcm-iproc.c
index 42fb5f166136..641cfa41f492 100644
--- a/drivers/net/mdio/mdio-mux-bcm-iproc.c
+++ b/drivers/net/mdio/mdio-mux-bcm-iproc.c
@@ -3,14 +3,14 @@
  * Copyright 2016 Broadcom
  */
 #include <linux/clk.h>
-#include <linux/platform_device.h>
+#include <linux/delay.h>
 #include <linux/device.h>
-#include <linux/of_mdio.h>
+#include <linux/iopoll.h>
+#include <linux/mdio-mux.h>
 #include <linux/module.h>
+#include <linux/of_mdio.h>
 #include <linux/phy.h>
-#include <linux/mdio-mux.h>
-#include <linux/delay.h>
-#include <linux/iopoll.h>
+#include <linux/platform_device.h>
 
 #define MDIO_RATE_ADJ_EXT_OFFSET	0x000
 #define MDIO_RATE_ADJ_INT_OFFSET	0x004
diff --git a/drivers/net/mdio/mdio-mux-gpio.c b/drivers/net/mdio/mdio-mux-gpio.c
index 10a758fdc9e6..3c7f16f06b45 100644
--- a/drivers/net/mdio/mdio-mux-gpio.c
+++ b/drivers/net/mdio/mdio-mux-gpio.c
@@ -3,13 +3,13 @@
  * Copyright (C) 2011, 2012 Cavium, Inc.
  */
 
-#include <linux/platform_device.h>
 #include <linux/device.h>
-#include <linux/of_mdio.h>
+#include <linux/gpio/consumer.h>
+#include <linux/mdio-mux.h>
 #include <linux/module.h>
+#include <linux/of_mdio.h>
 #include <linux/phy.h>
-#include <linux/mdio-mux.h>
-#include <linux/gpio/consumer.h>
+#include <linux/platform_device.h>
 
 #define DRV_VERSION "1.1"
 #define DRV_DESCRIPTION "GPIO controlled MDIO bus multiplexer driver"
diff --git a/drivers/net/mdio/mdio-mux-mmioreg.c b/drivers/net/mdio/mdio-mux-mmioreg.c
index d1a8780e24d8..c02fb2a067ee 100644
--- a/drivers/net/mdio/mdio-mux-mmioreg.c
+++ b/drivers/net/mdio/mdio-mux-mmioreg.c
@@ -7,13 +7,13 @@
  * Copyright 2012 Freescale Semiconductor, Inc.
  */
 
-#include <linux/platform_device.h>
 #include <linux/device.h>
+#include <linux/mdio-mux.h>
+#include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/of_mdio.h>
-#include <linux/module.h>
 #include <linux/phy.h>
-#include <linux/mdio-mux.h>
+#include <linux/platform_device.h>
 
 struct mdio_mux_mmioreg_state {
 	void *mux_handle;
diff --git a/drivers/net/mdio/mdio-mux-multiplexer.c b/drivers/net/mdio/mdio-mux-multiplexer.c
index d6564381aa3e..527acfc3c045 100644
--- a/drivers/net/mdio/mdio-mux-multiplexer.c
+++ b/drivers/net/mdio/mdio-mux-multiplexer.c
@@ -4,10 +4,10 @@
  * Copyright 2019 NXP
  */
 
-#include <linux/platform_device.h>
 #include <linux/mdio-mux.h>
 #include <linux/module.h>
 #include <linux/mux/consumer.h>
+#include <linux/platform_device.h>
 
 struct mdio_mux_multiplexer_state {
 	struct mux_control *muxc;
diff --git a/drivers/net/mdio/mdio-mux.c b/drivers/net/mdio/mdio-mux.c
index ccb3ee704eb1..3dde0c2b3e09 100644
--- a/drivers/net/mdio/mdio-mux.c
+++ b/drivers/net/mdio/mdio-mux.c
@@ -3,12 +3,12 @@
  * Copyright (C) 2011, 2012 Cavium, Inc.
  */
 
-#include <linux/platform_device.h>
-#include <linux/mdio-mux.h>
-#include <linux/of_mdio.h>
 #include <linux/device.h>
+#include <linux/mdio-mux.h>
 #include <linux/module.h>
+#include <linux/of_mdio.h>
 #include <linux/phy.h>
+#include <linux/platform_device.h>
 
 #define DRV_DESCRIPTION "MDIO bus multiplexer driver"
 
diff --git a/drivers/net/mdio/mdio-octeon.c b/drivers/net/mdio/mdio-octeon.c
index 6faf39314ac9..e096e68ac667 100644
--- a/drivers/net/mdio/mdio-octeon.c
+++ b/drivers/net/mdio/mdio-octeon.c
@@ -3,13 +3,13 @@
  * Copyright (C) 2009-2015 Cavium, Inc.
  */
 
-#include <linux/platform_device.h>
+#include <linux/gfp.h>
+#include <linux/io.h>
+#include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/of_mdio.h>
-#include <linux/module.h>
-#include <linux/gfp.h>
 #include <linux/phy.h>
-#include <linux/io.h>
+#include <linux/platform_device.h>
 
 #include "mdio-cavium.h"
 
diff --git a/drivers/net/mdio/mdio-thunder.c b/drivers/net/mdio/mdio-thunder.c
index dd7430c998a2..822d2cdd2f35 100644
--- a/drivers/net/mdio/mdio-thunder.c
+++ b/drivers/net/mdio/mdio-thunder.c
@@ -3,14 +3,14 @@
  * Copyright (C) 2009-2016 Cavium, Inc.
  */
 
-#include <linux/of_address.h>
-#include <linux/of_mdio.h>
-#include <linux/module.h>
+#include <linux/acpi.h>
 #include <linux/gfp.h>
-#include <linux/phy.h>
 #include <linux/io.h>
-#include <linux/acpi.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_mdio.h>
 #include <linux/pci.h>
+#include <linux/phy.h>
 
 #include "mdio-cavium.h"
 
diff --git a/drivers/net/mdio/mdio-xgene.c b/drivers/net/mdio/mdio-xgene.c
index 461207cdf5d6..7ab4e26db08c 100644
--- a/drivers/net/mdio/mdio-xgene.c
+++ b/drivers/net/mdio/mdio-xgene.c
@@ -13,11 +13,11 @@
 #include <linux/io.h>
 #include <linux/mdio/mdio-xgene.h>
 #include <linux/module.h>
-#include <linux/of_platform.h>
-#include <linux/of_net.h>
 #include <linux/of_mdio.h>
-#include <linux/prefetch.h>
+#include <linux/of_net.h>
+#include <linux/of_platform.h>
 #include <linux/phy.h>
+#include <linux/prefetch.h>
 #include <net/ip.h>
 
 static bool xgene_mdio_status;
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 4daf94bb56a5..ea0bf13e8ac3 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -8,17 +8,17 @@
  * out of the OpenFirmware device tree and using it to populate an mii_bus.
  */
 
-#include <linux/kernel.h>
 #include <linux/device.h>
-#include <linux/netdevice.h>
 #include <linux/err.h>
-#include <linux/phy.h>
-#include <linux/phy_fixed.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
-#include <linux/module.h>
+#include <linux/phy.h>
+#include <linux/phy_fixed.h>
 
 #define DEFAULT_GPIO_RESET_DELAY	10	/* in microseconds */
 
-- 
2.35.1



