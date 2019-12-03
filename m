Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE3DD111CCC
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfLCWri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:47:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:37836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729324AbfLCWrf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:47:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DEF320656;
        Tue,  3 Dec 2019 22:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413255;
        bh=x4QYvNgnGAT1UIUmEnssqiLP8KCWRUy/qX7wjuA54Zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkb0UUwIblQDf4VxE29gFh5LeYaRRowMixpvv3/vkzzi8Q1G2RL7ptHreemGbjDJa
         Ef1bLwPAu6HcKH+F5uXQzBHSogw5D5eeYAgew/No0kS3cyBYhLS950gxSVrDiz4EuB
         I3qOi5mLvVkUX3TKuP5bfQLLzMoQ7sRTe1qNkg5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 059/321] ARM: dts: imx6ul: Fix memory node duplication
Date:   Tue,  3 Dec 2019 23:32:05 +0100
Message-Id: <20191203223430.239743477@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



