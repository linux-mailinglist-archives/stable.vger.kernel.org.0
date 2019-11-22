Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D90F6106014
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfKVFaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:30:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:47990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727239AbfKVFaU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:30:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D33CA2070B;
        Fri, 22 Nov 2019 05:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574400619;
        bh=//48Y0e+TnSjcWbypK13uBxiX7dydB+93cLmWpdG+a8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkJskqzNH4LWKISp06n70WO5DgV9ykaOis3Hbxc4NG/EcNXRBNTj+1LWXPcc/NYRa
         19LQ0gHu9RAyFzAnx6Wp66AYMpazpOv0BUjf6eouP2ZPIFgBbpdZ+V8wGayuw/4Wk9
         0PkczSuLS9YXbygF0+vkX+5MwJ9Wzu303ljW41RM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Estevam <festevam@gmail.com>, Rob Herring <robh@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 019/219] ARM: dts: imx27: Fix memory node duplication
Date:   Fri, 22 Nov 2019 00:26:41 -0500
Message-Id: <20191122053001.752-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122053001.752-1-sashal@kernel.org>
References: <20191122053001.752-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 38715dcd49b4430ac5b6bc1293278d91a4d32bd5 ]

Boards based on imx27 have duplicate memory nodes:

- One coming from the board dts file: memory@

- One coming from the imx27.dtsi file.

Fix the duplication by removing the memory node from the dtsi file
and by adding 'device_type = "memory";' in the board dts.

Reported-by: Rob Herring <robh@kernel.org>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx27-apf27.dts                 | 1 +
 arch/arm/boot/dts/imx27-eukrea-cpuimx27.dtsi      | 1 +
 arch/arm/boot/dts/imx27-pdk.dts                   | 1 +
 arch/arm/boot/dts/imx27-phytec-phycard-s-som.dtsi | 1 +
 arch/arm/boot/dts/imx27-phytec-phycore-som.dtsi   | 1 +
 arch/arm/boot/dts/imx27.dtsi                      | 2 --
 6 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx27-apf27.dts b/arch/arm/boot/dts/imx27-apf27.dts
index 3eddd805a793a..f635d5c5029c4 100644
--- a/arch/arm/boot/dts/imx27-apf27.dts
+++ b/arch/arm/boot/dts/imx27-apf27.dts
@@ -20,6 +20,7 @@
 	compatible = "armadeus,imx27-apf27", "fsl,imx27";
 
 	memory@a0000000 {
+		device_type = "memory";
 		reg = <0xa0000000 0x04000000>;
 	};
 };
diff --git a/arch/arm/boot/dts/imx27-eukrea-cpuimx27.dtsi b/arch/arm/boot/dts/imx27-eukrea-cpuimx27.dtsi
index 9c455dcbe6ebf..c85f9d01768a1 100644
--- a/arch/arm/boot/dts/imx27-eukrea-cpuimx27.dtsi
+++ b/arch/arm/boot/dts/imx27-eukrea-cpuimx27.dtsi
@@ -17,6 +17,7 @@
 	compatible = "eukrea,cpuimx27", "fsl,imx27";
 
 	memory@a0000000 {
+		device_type = "memory";
 		reg = <0xa0000000 0x04000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx27-pdk.dts b/arch/arm/boot/dts/imx27-pdk.dts
index f9a882d991329..35123b7cb6b3e 100644
--- a/arch/arm/boot/dts/imx27-pdk.dts
+++ b/arch/arm/boot/dts/imx27-pdk.dts
@@ -10,6 +10,7 @@
 	compatible = "fsl,imx27-pdk", "fsl,imx27";
 
 	memory@a0000000 {
+		device_type = "memory";
 		reg = <0xa0000000 0x08000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx27-phytec-phycard-s-som.dtsi b/arch/arm/boot/dts/imx27-phytec-phycard-s-som.dtsi
index cbad7c88c58cc..b0b4f7c00246d 100644
--- a/arch/arm/boot/dts/imx27-phytec-phycard-s-som.dtsi
+++ b/arch/arm/boot/dts/imx27-phytec-phycard-s-som.dtsi
@@ -18,6 +18,7 @@
 	compatible = "phytec,imx27-pca100", "fsl,imx27";
 
 	memory@a0000000 {
+		device_type = "memory";
 		reg = <0xa0000000 0x08000000>; /* 128MB */
 	};
 };
diff --git a/arch/arm/boot/dts/imx27-phytec-phycore-som.dtsi b/arch/arm/boot/dts/imx27-phytec-phycore-som.dtsi
index ec466b4bfd410..0935e1400e5d2 100644
--- a/arch/arm/boot/dts/imx27-phytec-phycore-som.dtsi
+++ b/arch/arm/boot/dts/imx27-phytec-phycore-som.dtsi
@@ -17,6 +17,7 @@
 	compatible = "phytec,imx27-pcm038", "fsl,imx27";
 
 	memory@a0000000 {
+		device_type = "memory";
 		reg = <0xa0000000 0x08000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx27.dtsi b/arch/arm/boot/dts/imx27.dtsi
index 753d88df16274..39e75b997bdc8 100644
--- a/arch/arm/boot/dts/imx27.dtsi
+++ b/arch/arm/boot/dts/imx27.dtsi
@@ -16,10 +16,8 @@
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

