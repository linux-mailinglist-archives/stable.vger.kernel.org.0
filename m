Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64952A4FDD
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 20:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbgKCTSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 14:18:34 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:39387 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729399AbgKCTSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 14:18:34 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 5A6151942AC1;
        Tue,  3 Nov 2020 14:18:33 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 14:18:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PfA/XO
        m9Q05TV7sy9hphp01LdeHxNO1cFtj/mdGtKNU=; b=maHnB59KX1lYbXXogxj1d7
        iRy/SeJj9viDg/wQ9IBEl49nwxzPBkHOXaJew8+DPSNlgJlptPE+3aSbgea4ZMgl
        YNr6pxW2ZBO6lB/ejwbJ4mjxh854KoEZ8j6aCvs0+nq7QKSr1lvqosHmvTuJg3Xv
        K3QxJc5YRX3BIiVKbhNVLDjgMeY6LX3RAUreGUZhsbE5I9IsCXFQxV70SOUGSkdr
        OFjKfqULoRnk8x1aWzUIJtYJWDCzYaZbdbqEqvZNGIe4Aew8qT0nbKU7S4JzXpYa
        Y0shDitRGbZ/SOHpC6K7P66u2++XUD39mfuZswBMFk37djy0hvkOQH0uleyTGC7Q
        ==
X-ME-Sender: <xms:CK2hX97lwa6nIS_9kl_7u-sUN6kF0vb3XyZ34KDxIJ8xCAkOjBm95g>
    <xme:CK2hX65vslF8qDzWkHi-r6ZkOoNiug--BQ4M6mb01s-knuxwvwR1rjztfVXsQlLAd
    FpYJQP2vP45Jg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefgge
    dvuedufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:CK2hX0c5GOkttdnNiIIRZLmP7RH9N6rECV62ErOZrOnL88l78O-dUg>
    <xmx:CK2hX2KZHacL95UsLPTqiFIglCpDFBZc6rTlTvlRNi_UaWFm6oxHYg>
    <xmx:CK2hXxIfBF45zQbVWapVlPqObsOfcFq8WAUYS8SNNR2DsRu-p6CMJg>
    <xmx:Ca2hX4U8ORYWCovo1-XLCAzQKpsvDzo7HD4ZuiJ770wKDQLK-ErLlQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B73733064682;
        Tue,  3 Nov 2020 14:18:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64: dts: marvell: espressobin: Add ethernet switch aliases" failed to apply to 5.4-stable tree
To:     pali@kernel.org, a.heider@gmail.com, andrew@lunn.ch,
        gregory.clement@bootlin.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 20:18:30 +0100
Message-ID: <160443111019694@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b64d814257b027e29a474bcd660f6372490138c7 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Mon, 7 Sep 2020 13:27:17 +0200
Subject: [PATCH] arm64: dts: marvell: espressobin: Add ethernet switch aliases
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Espressobin boards have 3 ethernet ports and some of them got assigned more
then one MAC address. MAC addresses are stored in U-Boot environment.

Since commit a2c7023f7075c ("net: dsa: read mac address from DT for slave
device") kernel can use MAC addresses from DT for particular DSA port.

Currently Espressobin DTS file contains alias just for ethernet0.

This patch defines additional ethernet aliases in Espressobin DTS files, so
bootloader can fill correct MAC address for DSA switch ports if more MAC
addresses were specified.

DT alias ethernet1 is used for wan port, DT aliases ethernet2 and ethernet3
are used for lan ports for both Espressobin revisions (V5 and V7).

Fixes: 5253cb8c00a6f ("arm64: dts: marvell: espressobin: add ethernet alias")
Cc: <stable@vger.kernel.org> # a2c7023f7075c: dsa: read mac address
Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Andre Heider <a.heider@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7-emmc.dts b/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7-emmc.dts
index 03733fd92732..215d2f702623 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7-emmc.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7-emmc.dts
@@ -20,17 +20,23 @@ / {
 	compatible = "globalscale,espressobin-v7-emmc", "globalscale,espressobin-v7",
 		     "globalscale,espressobin", "marvell,armada3720",
 		     "marvell,armada3710";
+
+	aliases {
+		/* ethernet1 is wan port */
+		ethernet1 = &switch0port3;
+		ethernet3 = &switch0port1;
+	};
 };
 
 &switch0 {
 	ports {
-		port@1 {
+		switch0port1: port@1 {
 			reg = <1>;
 			label = "lan1";
 			phy-handle = <&switch0phy0>;
 		};
 
-		port@3 {
+		switch0port3: port@3 {
 			reg = <3>;
 			label = "wan";
 			phy-handle = <&switch0phy2>;
diff --git a/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7.dts b/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7.dts
index 8570c5f47d7d..b6f4af8ebafb 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7.dts
@@ -19,17 +19,23 @@ / {
 	model = "Globalscale Marvell ESPRESSOBin Board V7";
 	compatible = "globalscale,espressobin-v7", "globalscale,espressobin",
 		     "marvell,armada3720", "marvell,armada3710";
+
+	aliases {
+		/* ethernet1 is wan port */
+		ethernet1 = &switch0port3;
+		ethernet3 = &switch0port1;
+	};
 };
 
 &switch0 {
 	ports {
-		port@1 {
+		switch0port1: port@1 {
 			reg = <1>;
 			label = "lan1";
 			phy-handle = <&switch0phy0>;
 		};
 
-		port@3 {
+		switch0port3: port@3 {
 			reg = <3>;
 			label = "wan";
 			phy-handle = <&switch0phy2>;
diff --git a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi
index b97218c72727..0775c16e0ec8 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi
@@ -13,6 +13,10 @@
 / {
 	aliases {
 		ethernet0 = &eth0;
+		/* for dsa slave device */
+		ethernet1 = &switch0port1;
+		ethernet2 = &switch0port2;
+		ethernet3 = &switch0port3;
 		serial0 = &uart0;
 		serial1 = &uart1;
 	};
@@ -120,7 +124,7 @@ ports {
 			#address-cells = <1>;
 			#size-cells = <0>;
 
-			port@0 {
+			switch0port0: port@0 {
 				reg = <0>;
 				label = "cpu";
 				ethernet = <&eth0>;
@@ -131,19 +135,19 @@ fixed-link {
 				};
 			};
 
-			port@1 {
+			switch0port1: port@1 {
 				reg = <1>;
 				label = "wan";
 				phy-handle = <&switch0phy0>;
 			};
 
-			port@2 {
+			switch0port2: port@2 {
 				reg = <2>;
 				label = "lan0";
 				phy-handle = <&switch0phy1>;
 			};
 
-			port@3 {
+			switch0port3: port@3 {
 				reg = <3>;
 				label = "lan1";
 				phy-handle = <&switch0phy2>;

