Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4A310667B
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfKVGbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:31:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbfKVFtV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:49:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAFE92070A;
        Fri, 22 Nov 2019 05:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401760;
        bh=x4QYvNgnGAT1UIUmEnssqiLP8KCWRUy/qX7wjuA54Zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DK//fqz00RVTPaqMaV3Cv+GUhlXTebB13ZKPTu1kOJBzwQNNpfNiuhqjVOe/F1yr+
         XiX4l7oTnxw9cr9H+Dcuxn+a2sJ6Oz7rQgFgT4yM7lOL0TSWY6OEH9jW+QKnix7+eO
         Np8by5P4E0v4F9Tr6I632TKbi9N29O32zZghxlwA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Estevam <festevam@gmail.com>, Rob Herring <robh@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 013/219] ARM: dts: imx6ul: Fix memory node duplication
Date:   Fri, 22 Nov 2019 00:45:45 -0500
Message-Id: <20191122054911.1750-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 750d8df6e7b269b828f66631a1d39ea027afc92a ]

Boards based on imx6ul have duplicate memory nodes:

- One coming from the board dts file: memory@

- One coming from the imx6ul.dtsi file.

Fix the duplication by removing the memory node from the dtsi file
and by adding 'device_type = "memory";' in the board dts.

Reported-by: Rob Herring <robh@kernel.org>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul-14x14-evk.dtsi        | 1 +
 arch/arm/boot/dts/imx6ul-geam.dts              | 1 +
 arch/arm/boot/dts/imx6ul-isiot.dtsi            | 1 +
 arch/arm/boot/dts/imx6ul-litesom.dtsi          | 1 +
 arch/arm/boot/dts/imx6ul-opos6ul.dtsi          | 1 +
 arch/arm/boot/dts/imx6ul-pico-hobbit.dts       | 1 +
 arch/arm/boot/dts/imx6ul-tx6ul.dtsi            | 1 +
 arch/arm/boot/dts/imx6ul.dtsi                  | 2 --
 arch/arm/boot/dts/imx6ull-colibri-nonwifi.dtsi | 1 +
 arch/arm/boot/dts/imx6ull-colibri-wifi.dtsi    | 1 +
 10 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi b/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
index 32a07232c0345..8180211265592 100644
--- a/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
+++ b/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
@@ -12,6 +12,7 @@
 	};
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x20000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx6ul-geam.dts b/arch/arm/boot/dts/imx6ul-geam.dts
index d81d20f8fc8dd..85cfad080f15c 100644
--- a/arch/arm/boot/dts/imx6ul-geam.dts
+++ b/arch/arm/boot/dts/imx6ul-geam.dts
@@ -51,6 +51,7 @@
 	compatible = "engicam,imx6ul-geam", "fsl,imx6ul";
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x08000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx6ul-isiot.dtsi b/arch/arm/boot/dts/imx6ul-isiot.dtsi
index cd99285511544..1cb52744f58ad 100644
--- a/arch/arm/boot/dts/imx6ul-isiot.dtsi
+++ b/arch/arm/boot/dts/imx6ul-isiot.dtsi
@@ -46,6 +46,7 @@
 
 / {
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x20000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx6ul-litesom.dtsi b/arch/arm/boot/dts/imx6ul-litesom.dtsi
index 8f775f6974d1c..8d6893210842b 100644
--- a/arch/arm/boot/dts/imx6ul-litesom.dtsi
+++ b/arch/arm/boot/dts/imx6ul-litesom.dtsi
@@ -48,6 +48,7 @@
 	compatible = "grinn,imx6ul-litesom", "fsl,imx6ul";
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x20000000>;
 	};
 };
diff --git a/arch/arm/boot/dts/imx6ul-opos6ul.dtsi b/arch/arm/boot/dts/imx6ul-opos6ul.dtsi
index a031bee311df4..cf7faf4b9c47e 100644
--- a/arch/arm/boot/dts/imx6ul-opos6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul-opos6ul.dtsi
@@ -49,6 +49,7 @@
 
 / {
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0>; /* will be filled by U-Boot */
 	};
 
diff --git a/arch/arm/boot/dts/imx6ul-pico-hobbit.dts b/arch/arm/boot/dts/imx6ul-pico-hobbit.dts
index 0c09420f99512..797262d2f27fd 100644
--- a/arch/arm/boot/dts/imx6ul-pico-hobbit.dts
+++ b/arch/arm/boot/dts/imx6ul-pico-hobbit.dts
@@ -53,6 +53,7 @@
 
 	/* Will be filled by the bootloader */
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0>;
 	};
 
diff --git a/arch/arm/boot/dts/imx6ul-tx6ul.dtsi b/arch/arm/boot/dts/imx6ul-tx6ul.dtsi
index 02b5ba42cd591..bb6dbfd5546b4 100644
--- a/arch/arm/boot/dts/imx6ul-tx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul-tx6ul.dtsi
@@ -71,6 +71,7 @@
 	};
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0>; /* will be filled by U-Boot */
 	};
 
diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index 336cdead3da54..50834a43e5fb2 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -15,10 +15,8 @@
 	 * The decompressor and also some bootloaders rely on a
 	 * pre-existing /chosen node to be available to insert the
 	 * command line and merge other ATAGS info.
-	 * Also for U-Boot there must be a pre-existing /memory node.
 	 */
 	chosen {};
-	memory { device_type = "memory"; };
 
 	aliases {
 		ethernet0 = &fec1;
diff --git a/arch/arm/boot/dts/imx6ull-colibri-nonwifi.dtsi b/arch/arm/boot/dts/imx6ull-colibri-nonwifi.dtsi
index 10ab4697950f5..fb213bec46543 100644
--- a/arch/arm/boot/dts/imx6ull-colibri-nonwifi.dtsi
+++ b/arch/arm/boot/dts/imx6ull-colibri-nonwifi.dtsi
@@ -7,6 +7,7 @@
 
 / {
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x10000000>;
 	};
 };
diff --git a/arch/arm/boot/dts/imx6ull-colibri-wifi.dtsi b/arch/arm/boot/dts/imx6ull-colibri-wifi.dtsi
index 183193e8580dd..038d8c90f6dfe 100644
--- a/arch/arm/boot/dts/imx6ull-colibri-wifi.dtsi
+++ b/arch/arm/boot/dts/imx6ull-colibri-wifi.dtsi
@@ -7,6 +7,7 @@
 
 / {
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x20000000>;
 	};
 
-- 
2.20.1

