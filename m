Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E24F106072
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfKVFtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:49:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:53128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbfKVFtQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:49:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0052020708;
        Fri, 22 Nov 2019 05:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401754;
        bh=uMgmPvrDLDsbL0dY3dsmfSahB5TPRLdrqSc2NbbB570=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iB+yodn2OcNcFi4xAC9TCmeymmwlISVoVqC2qrl4RQB4c4oGdBCWn2nW3EktnWiva
         EKBMwXxWFYEgFNv4y9S9FPmQoENdt6UmGMthMlz4bUd9vcMR55reBY6E57d8LqmvZd
         GmhUFmA01DCshztlgF0xLW5KF36RoDhgYXKxkNoc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Estevam <festevam@gmail.com>, Rob Herring <robh@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 009/219] ARM: dts: imx53: Fix memory node duplication
Date:   Fri, 22 Nov 2019 00:45:41 -0500
Message-Id: <20191122054911.1750-2-sashal@kernel.org>
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

[ Upstream commit e8fd17b900a4a1e3a8bef7b44727cbad35db05a7 ]

Boards based on imx53 have duplicate memory nodes:

- One coming from the board dts file: memory@

- One coming from the imx53.dtsi file.

Fix the duplication by removing the memory node from the dtsi file
and by adding 'device_type = "memory";' in the board dts.

Reported-by: Rob Herring <robh@kernel.org>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx53-ard.dts         | 1 +
 arch/arm/boot/dts/imx53-cx9020.dts      | 1 +
 arch/arm/boot/dts/imx53-m53.dtsi        | 1 +
 arch/arm/boot/dts/imx53-qsb-common.dtsi | 1 +
 arch/arm/boot/dts/imx53-smd.dts         | 1 +
 arch/arm/boot/dts/imx53-tqma53.dtsi     | 1 +
 arch/arm/boot/dts/imx53-tx53.dtsi       | 1 +
 arch/arm/boot/dts/imx53-usbarmory.dts   | 1 +
 arch/arm/boot/dts/imx53.dtsi            | 2 --
 9 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx53-ard.dts b/arch/arm/boot/dts/imx53-ard.dts
index 117bd002dd1d1..7d5a48250f867 100644
--- a/arch/arm/boot/dts/imx53-ard.dts
+++ b/arch/arm/boot/dts/imx53-ard.dts
@@ -19,6 +19,7 @@
 	compatible = "fsl,imx53-ard", "fsl,imx53";
 
 	memory@70000000 {
+		device_type = "memory";
 		reg = <0x70000000 0x40000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx53-cx9020.dts b/arch/arm/boot/dts/imx53-cx9020.dts
index cf70ebc4399a2..c875e23ee45fb 100644
--- a/arch/arm/boot/dts/imx53-cx9020.dts
+++ b/arch/arm/boot/dts/imx53-cx9020.dts
@@ -22,6 +22,7 @@
 	};
 
 	memory@70000000 {
+		device_type = "memory";
 		reg = <0x70000000 0x20000000>,
 		      <0xb0000000 0x20000000>;
 	};
diff --git a/arch/arm/boot/dts/imx53-m53.dtsi b/arch/arm/boot/dts/imx53-m53.dtsi
index ce45f08e30514..db2e5bce9b6a1 100644
--- a/arch/arm/boot/dts/imx53-m53.dtsi
+++ b/arch/arm/boot/dts/imx53-m53.dtsi
@@ -16,6 +16,7 @@
 	compatible = "aries,imx53-m53", "denx,imx53-m53", "fsl,imx53";
 
 	memory@70000000 {
+		device_type = "memory";
 		reg = <0x70000000 0x20000000>,
 		      <0xb0000000 0x20000000>;
 	};
diff --git a/arch/arm/boot/dts/imx53-qsb-common.dtsi b/arch/arm/boot/dts/imx53-qsb-common.dtsi
index 50dde84b72ed7..f00dda334976a 100644
--- a/arch/arm/boot/dts/imx53-qsb-common.dtsi
+++ b/arch/arm/boot/dts/imx53-qsb-common.dtsi
@@ -11,6 +11,7 @@
 	};
 
 	memory@70000000 {
+		device_type = "memory";
 		reg = <0x70000000 0x20000000>,
 		      <0xb0000000 0x20000000>;
 	};
diff --git a/arch/arm/boot/dts/imx53-smd.dts b/arch/arm/boot/dts/imx53-smd.dts
index 462071c9ddd73..09071ca11c6cf 100644
--- a/arch/arm/boot/dts/imx53-smd.dts
+++ b/arch/arm/boot/dts/imx53-smd.dts
@@ -12,6 +12,7 @@
 	compatible = "fsl,imx53-smd", "fsl,imx53";
 
 	memory@70000000 {
+		device_type = "memory";
 		reg = <0x70000000 0x40000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx53-tqma53.dtsi b/arch/arm/boot/dts/imx53-tqma53.dtsi
index a72b8981fc3bd..c77d58f06c949 100644
--- a/arch/arm/boot/dts/imx53-tqma53.dtsi
+++ b/arch/arm/boot/dts/imx53-tqma53.dtsi
@@ -17,6 +17,7 @@
 	compatible = "tq,tqma53", "fsl,imx53";
 
 	memory@70000000 {
+		device_type = "memory";
 		reg = <0x70000000 0x40000000>; /* Up to 1GiB */
 	};
 
diff --git a/arch/arm/boot/dts/imx53-tx53.dtsi b/arch/arm/boot/dts/imx53-tx53.dtsi
index 54cf3e67069a9..4ab135906949f 100644
--- a/arch/arm/boot/dts/imx53-tx53.dtsi
+++ b/arch/arm/boot/dts/imx53-tx53.dtsi
@@ -51,6 +51,7 @@
 
 	/* Will be filled by the bootloader */
 	memory@70000000 {
+		device_type = "memory";
 		reg = <0x70000000 0>;
 	};
 
diff --git a/arch/arm/boot/dts/imx53-usbarmory.dts b/arch/arm/boot/dts/imx53-usbarmory.dts
index f6268d0ded296..ee6263d1c2d3d 100644
--- a/arch/arm/boot/dts/imx53-usbarmory.dts
+++ b/arch/arm/boot/dts/imx53-usbarmory.dts
@@ -58,6 +58,7 @@
 	};
 
 	memory@70000000 {
+		device_type = "memory";
 		reg = <0x70000000 0x20000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
index b6b0818343c4e..8accbe16b7584 100644
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@ -23,10 +23,8 @@
 	 * The decompressor and also some bootloaders rely on a
 	 * pre-existing /chosen node to be available to insert the
 	 * command line and merge other ATAGS info.
-	 * Also for U-Boot there must be a pre-existing /memory node.
 	 */
 	chosen {};
-	memory { device_type = "memory"; };
 
 	aliases {
 		ethernet0 = &fec;
-- 
2.20.1

