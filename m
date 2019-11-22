Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91DE2106035
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfKVFbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:31:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:47778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727194AbfKVFaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:30:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 035B620707;
        Fri, 22 Nov 2019 05:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574400612;
        bh=PdKlgkUbmjtGXd4lr35779+IJqQhfvMEQr7fvNa42pU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vt7EGcXAT3R4Ctr1C6ojPA0BHWA55tOSgZr6DJxjQzt9Apb7j7aQEAqY7ieXWIA3+
         y0d63NXPdrYoi/oDWQk03RfXkBoD4aAxOLwmpBC3WOfJmRCBF7xLo1sDjsknf0gpGe
         rWQ37IBib4+17+b2cUBBctwMSpD0lGUewkPsPjLI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Estevam <festevam@gmail.com>, Rob Herring <robh@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 014/219] ARM: dts: imx6sx: Fix memory node duplication
Date:   Fri, 22 Nov 2019 00:26:36 -0500
Message-Id: <20191122053001.752-7-sashal@kernel.org>
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

[ Upstream commit 216f35fedd8688c8b654ebfbad18c6e64713fad7 ]

Boards based on imx6sx have duplicate memory nodes:

- One coming from the board dts file: memory@

- One coming from the imx6sx.dtsi file.

Fix the duplication by removing the memory node from the dtsi file
and by adding 'device_type = "memory";' in the board dts.

Reported-by: Rob Herring <robh@kernel.org>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sx-nitrogen6sx.dts         | 1 +
 arch/arm/boot/dts/imx6sx-sabreauto.dts           | 1 +
 arch/arm/boot/dts/imx6sx-sdb.dtsi                | 1 +
 arch/arm/boot/dts/imx6sx-softing-vining-2000.dts | 1 +
 arch/arm/boot/dts/imx6sx-udoo-neo-basic.dts      | 1 +
 arch/arm/boot/dts/imx6sx-udoo-neo-extended.dts   | 1 +
 arch/arm/boot/dts/imx6sx-udoo-neo-full.dts       | 1 +
 arch/arm/boot/dts/imx6sx.dtsi                    | 2 --
 8 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6sx-nitrogen6sx.dts b/arch/arm/boot/dts/imx6sx-nitrogen6sx.dts
index adb5cc7d8ce2f..832b5c5d7441a 100644
--- a/arch/arm/boot/dts/imx6sx-nitrogen6sx.dts
+++ b/arch/arm/boot/dts/imx6sx-nitrogen6sx.dts
@@ -12,6 +12,7 @@
 	compatible = "boundary,imx6sx-nitrogen6sx", "fsl,imx6sx";
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x40000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx6sx-sabreauto.dts b/arch/arm/boot/dts/imx6sx-sabreauto.dts
index 841a27f3198ff..48aede543612b 100644
--- a/arch/arm/boot/dts/imx6sx-sabreauto.dts
+++ b/arch/arm/boot/dts/imx6sx-sabreauto.dts
@@ -11,6 +11,7 @@
 	compatible = "fsl,imx6sx-sabreauto", "fsl,imx6sx";
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x80000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx6sx-sdb.dtsi b/arch/arm/boot/dts/imx6sx-sdb.dtsi
index f8f31872fa144..7f5ede5ca4c30 100644
--- a/arch/arm/boot/dts/imx6sx-sdb.dtsi
+++ b/arch/arm/boot/dts/imx6sx-sdb.dtsi
@@ -21,6 +21,7 @@
 	};
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x40000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx6sx-softing-vining-2000.dts b/arch/arm/boot/dts/imx6sx-softing-vining-2000.dts
index 252175b592475..2bc51623a8060 100644
--- a/arch/arm/boot/dts/imx6sx-softing-vining-2000.dts
+++ b/arch/arm/boot/dts/imx6sx-softing-vining-2000.dts
@@ -21,6 +21,7 @@
 	};
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x40000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx6sx-udoo-neo-basic.dts b/arch/arm/boot/dts/imx6sx-udoo-neo-basic.dts
index 40ccdf43dffc5..db0feb9b9f5d7 100644
--- a/arch/arm/boot/dts/imx6sx-udoo-neo-basic.dts
+++ b/arch/arm/boot/dts/imx6sx-udoo-neo-basic.dts
@@ -49,6 +49,7 @@
 	compatible = "udoo,neobasic", "fsl,imx6sx";
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x20000000>;
 	};
 };
diff --git a/arch/arm/boot/dts/imx6sx-udoo-neo-extended.dts b/arch/arm/boot/dts/imx6sx-udoo-neo-extended.dts
index 42bfc8f8f7f6b..5c7a2bb9141cb 100644
--- a/arch/arm/boot/dts/imx6sx-udoo-neo-extended.dts
+++ b/arch/arm/boot/dts/imx6sx-udoo-neo-extended.dts
@@ -49,6 +49,7 @@
 	compatible = "udoo,neoextended", "fsl,imx6sx";
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x40000000>;
 	};
 };
diff --git a/arch/arm/boot/dts/imx6sx-udoo-neo-full.dts b/arch/arm/boot/dts/imx6sx-udoo-neo-full.dts
index c84c877f09d49..13dfe2afaba56 100644
--- a/arch/arm/boot/dts/imx6sx-udoo-neo-full.dts
+++ b/arch/arm/boot/dts/imx6sx-udoo-neo-full.dts
@@ -49,6 +49,7 @@
 	compatible = "udoo,neofull", "fsl,imx6sx";
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x40000000>;
 	};
 };
diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
index 7b62e6fb47ebe..ae0728df542e9 100644
--- a/arch/arm/boot/dts/imx6sx.dtsi
+++ b/arch/arm/boot/dts/imx6sx.dtsi
@@ -15,10 +15,8 @@
 	 * The decompressor and also some bootloaders rely on a
 	 * pre-existing /chosen node to be available to insert the
 	 * command line and merge other ATAGS info.
-	 * Also for U-Boot there must be a pre-existing /memory node.
 	 */
 	chosen {};
-	memory { device_type = "memory"; };
 
 	aliases {
 		can0 = &flexcan1;
-- 
2.20.1

