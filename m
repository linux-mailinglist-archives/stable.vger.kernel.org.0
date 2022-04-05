Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2644F2D07
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243097AbiDEJi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238424AbiDEJFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:05:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1DB3204A;
        Tue,  5 Apr 2022 01:56:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4FD961476;
        Tue,  5 Apr 2022 08:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB26C385A0;
        Tue,  5 Apr 2022 08:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148960;
        bh=XsRduxZtTDbtWyJYNuVfIxnpKzpREhUg0fNjCeY0/q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yq/BApXS47WlvthyDK7IaudL9zskd2b8w+SNtTdvYEWsaPiguGB2of/DQmb36279e
         cCN8FgIVzIoYPxayQi0aGtgM9pboGsh6a/8pVIBkmcgn1vQ5rKhOGJe5eseA2nELup
         3yFfELQ2av3NgO+XuInux+pR0BOuG7B8St5TSxyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0542/1017] net: dsa: realtek-smi: move to subdirectory
Date:   Tue,  5 Apr 2022 09:24:15 +0200
Message-Id: <20220405070410.376748345@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

[ Upstream commit 319a70a5fea9590e9431dd57f56191996c4787f4 ]

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                                   |  3 +--
 drivers/net/dsa/Kconfig                       | 12 +----------
 drivers/net/dsa/Makefile                      |  3 +--
 drivers/net/dsa/realtek/Kconfig               | 20 +++++++++++++++++++
 drivers/net/dsa/realtek/Makefile              |  3 +++
 .../net/dsa/{ => realtek}/realtek-smi-core.c  |  0
 .../net/dsa/{ => realtek}/realtek-smi-core.h  |  0
 drivers/net/dsa/{ => realtek}/rtl8365mb.c     |  0
 drivers/net/dsa/{ => realtek}/rtl8366.c       |  0
 drivers/net/dsa/{ => realtek}/rtl8366rb.c     |  0
 10 files changed, 26 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/dsa/realtek/Kconfig
 create mode 100644 drivers/net/dsa/realtek/Makefile
 rename drivers/net/dsa/{ => realtek}/realtek-smi-core.c (100%)
 rename drivers/net/dsa/{ => realtek}/realtek-smi-core.h (100%)
 rename drivers/net/dsa/{ => realtek}/rtl8365mb.c (100%)
 rename drivers/net/dsa/{ => realtek}/rtl8366.c (100%)
 rename drivers/net/dsa/{ => realtek}/rtl8366rb.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index dd36acc87ce6..af9530d98717 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16147,8 +16147,7 @@ REALTEK RTL83xx SMI DSA ROUTER CHIPS
 M:	Linus Walleij <linus.walleij@linaro.org>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
-F:	drivers/net/dsa/realtek-smi*
-F:	drivers/net/dsa/rtl83*
+F:	drivers/net/dsa/realtek/*
 
 REALTEK WIRELESS DRIVER (rtlwifi family)
 M:	Ping-Ke Shih <pkshih@realtek.com>
diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 0029d279616f..37a3dabdce31 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -68,17 +68,7 @@ config NET_DSA_QCA8K
 	  This enables support for the Qualcomm Atheros QCA8K Ethernet
 	  switch chips.
 
-config NET_DSA_REALTEK_SMI
-	tristate "Realtek SMI Ethernet switch family support"
-	select NET_DSA_TAG_RTL4_A
-	select NET_DSA_TAG_RTL8_4
-	select FIXED_PHY
-	select IRQ_DOMAIN
-	select REALTEK_PHY
-	select REGMAP
-	help
-	  This enables support for the Realtek SMI-based switch
-	  chips, currently only RTL8366RB.
+source "drivers/net/dsa/realtek/Kconfig"
 
 config NET_DSA_SMSC_LAN9303
 	tristate
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index 8da1569a34e6..e73838c12256 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -9,8 +9,6 @@ obj-$(CONFIG_NET_DSA_LANTIQ_GSWIP) += lantiq_gswip.o
 obj-$(CONFIG_NET_DSA_MT7530)	+= mt7530.o
 obj-$(CONFIG_NET_DSA_MV88E6060) += mv88e6060.o
 obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
-obj-$(CONFIG_NET_DSA_REALTEK_SMI) += realtek-smi.o
-realtek-smi-objs		:= realtek-smi-core.o rtl8366.o rtl8366rb.o rtl8365mb.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303) += lan9303-core.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_I2C) += lan9303_i2c.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_MDIO) += lan9303_mdio.o
@@ -23,5 +21,6 @@ obj-y				+= microchip/
 obj-y				+= mv88e6xxx/
 obj-y				+= ocelot/
 obj-y				+= qca/
+obj-y				+= realtek/
 obj-y				+= sja1105/
 obj-y				+= xrs700x/
diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
new file mode 100644
index 000000000000..1c62212fb0ec
--- /dev/null
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -0,0 +1,20 @@
+# SPDX-License-Identifier: GPL-2.0-only
+menuconfig NET_DSA_REALTEK
+	tristate "Realtek Ethernet switch family support"
+	depends on NET_DSA
+	select NET_DSA_TAG_RTL4_A
+	select NET_DSA_TAG_RTL8_4
+	select FIXED_PHY
+	select IRQ_DOMAIN
+	select REALTEK_PHY
+	select REGMAP
+	help
+	  Select to enable support for Realtek Ethernet switch chips.
+
+config NET_DSA_REALTEK_SMI
+	tristate "Realtek SMI connected switch driver"
+	depends on NET_DSA_REALTEK
+	default y
+	help
+	  Select to enable support for registering switches connected
+	  through SMI.
diff --git a/drivers/net/dsa/realtek/Makefile b/drivers/net/dsa/realtek/Makefile
new file mode 100644
index 000000000000..323b921bfce0
--- /dev/null
+++ b/drivers/net/dsa/realtek/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_NET_DSA_REALTEK_SMI) 	+= realtek-smi.o
+realtek-smi-objs			:= realtek-smi-core.o rtl8366.o rtl8366rb.o rtl8365mb.o
diff --git a/drivers/net/dsa/realtek-smi-core.c b/drivers/net/dsa/realtek/realtek-smi-core.c
similarity index 100%
rename from drivers/net/dsa/realtek-smi-core.c
rename to drivers/net/dsa/realtek/realtek-smi-core.c
diff --git a/drivers/net/dsa/realtek-smi-core.h b/drivers/net/dsa/realtek/realtek-smi-core.h
similarity index 100%
rename from drivers/net/dsa/realtek-smi-core.h
rename to drivers/net/dsa/realtek/realtek-smi-core.h
diff --git a/drivers/net/dsa/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
similarity index 100%
rename from drivers/net/dsa/rtl8365mb.c
rename to drivers/net/dsa/realtek/rtl8365mb.c
diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/realtek/rtl8366.c
similarity index 100%
rename from drivers/net/dsa/rtl8366.c
rename to drivers/net/dsa/realtek/rtl8366.c
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/realtek/rtl8366rb.c
similarity index 100%
rename from drivers/net/dsa/rtl8366rb.c
rename to drivers/net/dsa/realtek/rtl8366rb.c
-- 
2.34.1



