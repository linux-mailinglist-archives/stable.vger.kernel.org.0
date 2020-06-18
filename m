Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138851FE8FC
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgFRCwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727116AbgFRBIe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:08:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85C6221D7D;
        Thu, 18 Jun 2020 01:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442512;
        bh=PZVB8c/W0Hw4KNJB2l0XfZ4/3C5PuWPzrpXoHfizJ3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNxoCn3uMryvYwTaLqcpKsYqyRm38LiAxUrNWF4RDqSKAMwDfRjFily3G1cqc9b+o
         /D1lJrnmopQYA7ylzP/7hbh85uvShGZp8YPMwsw7S82A+ljnNxk+zEAs1UU1UVu/zz
         PQwF2yaK+MTv7rsAjQ9nlusdlWEeN9EZcqdDhzo8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 019/388] arm64: dts: renesas: Fix IOMMU device node names
Date:   Wed, 17 Jun 2020 21:01:56 -0400
Message-Id: <20200618010805.600873-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit cf8ae446bbcbf5c48214eb7ddaa6ac6e12f4633d ]

Fix IOMMU device node names as "iommu@".

Fixes: 8f507babc617 ("arm64: dts: renesas: r8a774a1: Add IPMMU device nodes")
Fixes: 63093a8e58be ("arm64: dts: renesas: r8a774b1: Add IPMMU device nodes")
Fixes: 6c7e02178e8f ("arm64: dts: renesas: r8a774c0: Add IPMMU device nodes")
Fixes: 3b7e7848f0e8 ("arm64: dts: renesas: r8a7795: Add IPMMU device nodes")
Fixes: e4b9a493df45 ("arm64: dts: renesas: r8a7795-es1: Add IPMMU device nodes")
Fixes: 389baa409617 ("arm64: dts: renesas: r8a7796: Add IPMMU device nodes")
Fixes: 55697cbb44e4 ("arm64: dts: renesas: r8a779{65,80,90}: Add IPMMU devices nodes")
Fixes: ce3b52a1595b ("arm64: dts: renesas: r8a77970: Add IPMMU device nodes")
Fixes: a3901e7398e1 ("arm64: dts: renesas: r8a77995: Add IPMMU device nodes")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/r/1587461775-13369-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi | 18 ++++++------
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi | 18 ++++++------
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi | 18 ++++++------
 arch/arm64/boot/dts/renesas/r8a77950.dtsi | 14 +++++-----
 arch/arm64/boot/dts/renesas/r8a77951.dtsi | 34 +++++++++++------------
 arch/arm64/boot/dts/renesas/r8a77960.dtsi | 22 +++++++--------
 arch/arm64/boot/dts/renesas/r8a77965.dtsi | 20 ++++++-------
 arch/arm64/boot/dts/renesas/r8a77970.dtsi | 10 +++----
 arch/arm64/boot/dts/renesas/r8a77980.dtsi | 16 +++++------
 arch/arm64/boot/dts/renesas/r8a77990.dtsi | 20 ++++++-------
 arch/arm64/boot/dts/renesas/r8a77995.dtsi | 20 ++++++-------
 11 files changed, 105 insertions(+), 105 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
index 79023433a740..a603d947970e 100644
--- a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
@@ -1000,7 +1000,7 @@ dmac2: dma-controller@e7310000 {
 			       <&ipmmu_ds1 30>, <&ipmmu_ds1 31>;
 		};
 
-		ipmmu_ds0: mmu@e6740000 {
+		ipmmu_ds0: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a774a1";
 			reg = <0 0xe6740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -1008,7 +1008,7 @@ ipmmu_ds0: mmu@e6740000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a774a1";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 1>;
@@ -1016,7 +1016,7 @@ ipmmu_ds1: mmu@e7740000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_hc: mmu@e6570000 {
+		ipmmu_hc: iommu@e6570000 {
 			compatible = "renesas,ipmmu-r8a774a1";
 			reg = <0 0xe6570000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 2>;
@@ -1024,7 +1024,7 @@ ipmmu_hc: mmu@e6570000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a774a1";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -1033,7 +1033,7 @@ ipmmu_mm: mmu@e67b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mp: mmu@ec670000 {
+		ipmmu_mp: iommu@ec670000 {
 			compatible = "renesas,ipmmu-r8a774a1";
 			reg = <0 0xec670000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 4>;
@@ -1041,7 +1041,7 @@ ipmmu_mp: mmu@ec670000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv0: mmu@fd800000 {
+		ipmmu_pv0: iommu@fd800000 {
 			compatible = "renesas,ipmmu-r8a774a1";
 			reg = <0 0xfd800000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 5>;
@@ -1049,7 +1049,7 @@ ipmmu_pv0: mmu@fd800000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv1: mmu@fd950000 {
+		ipmmu_pv1: iommu@fd950000 {
 			compatible = "renesas,ipmmu-r8a774a1";
 			reg = <0 0xfd950000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 6>;
@@ -1057,7 +1057,7 @@ ipmmu_pv1: mmu@fd950000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc0: mmu@fe6b0000 {
+		ipmmu_vc0: iommu@fe6b0000 {
 			compatible = "renesas,ipmmu-r8a774a1";
 			reg = <0 0xfe6b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 8>;
@@ -1065,7 +1065,7 @@ ipmmu_vc0: mmu@fe6b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a774a1";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 9>;
diff --git a/arch/arm64/boot/dts/renesas/r8a774b1.dtsi b/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
index 3137f735974b..1e51855c7cd3 100644
--- a/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
@@ -874,7 +874,7 @@ dmac2: dma-controller@e7310000 {
 			       <&ipmmu_ds1 30>, <&ipmmu_ds1 31>;
 		};
 
-		ipmmu_ds0: mmu@e6740000 {
+		ipmmu_ds0: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a774b1";
 			reg = <0 0xe6740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -882,7 +882,7 @@ ipmmu_ds0: mmu@e6740000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a774b1";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 1>;
@@ -890,7 +890,7 @@ ipmmu_ds1: mmu@e7740000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_hc: mmu@e6570000 {
+		ipmmu_hc: iommu@e6570000 {
 			compatible = "renesas,ipmmu-r8a774b1";
 			reg = <0 0xe6570000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 2>;
@@ -898,7 +898,7 @@ ipmmu_hc: mmu@e6570000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a774b1";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -907,7 +907,7 @@ ipmmu_mm: mmu@e67b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mp: mmu@ec670000 {
+		ipmmu_mp: iommu@ec670000 {
 			compatible = "renesas,ipmmu-r8a774b1";
 			reg = <0 0xec670000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 4>;
@@ -915,7 +915,7 @@ ipmmu_mp: mmu@ec670000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv0: mmu@fd800000 {
+		ipmmu_pv0: iommu@fd800000 {
 			compatible = "renesas,ipmmu-r8a774b1";
 			reg = <0 0xfd800000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 6>;
@@ -923,7 +923,7 @@ ipmmu_pv0: mmu@fd800000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc0: mmu@fe6b0000 {
+		ipmmu_vc0: iommu@fe6b0000 {
 			compatible = "renesas,ipmmu-r8a774b1";
 			reg = <0 0xfe6b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 12>;
@@ -931,7 +931,7 @@ ipmmu_vc0: mmu@fe6b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a774b1";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 14>;
@@ -939,7 +939,7 @@ ipmmu_vi0: mmu@febd0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vp0: mmu@fe990000 {
+		ipmmu_vp0: iommu@fe990000 {
 			compatible = "renesas,ipmmu-r8a774b1";
 			reg = <0 0xfe990000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 16>;
diff --git a/arch/arm64/boot/dts/renesas/r8a774c0.dtsi b/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
index 22785cbddff5..5c72a7efbb03 100644
--- a/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
@@ -847,7 +847,7 @@ dmac2: dma-controller@e7310000 {
 			       <&ipmmu_ds1 30>, <&ipmmu_ds1 31>;
 		};
 
-		ipmmu_ds0: mmu@e6740000 {
+		ipmmu_ds0: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a774c0";
 			reg = <0 0xe6740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -855,7 +855,7 @@ ipmmu_ds0: mmu@e6740000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a774c0";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 1>;
@@ -863,7 +863,7 @@ ipmmu_ds1: mmu@e7740000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_hc: mmu@e6570000 {
+		ipmmu_hc: iommu@e6570000 {
 			compatible = "renesas,ipmmu-r8a774c0";
 			reg = <0 0xe6570000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 2>;
@@ -871,7 +871,7 @@ ipmmu_hc: mmu@e6570000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a774c0";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -880,7 +880,7 @@ ipmmu_mm: mmu@e67b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mp: mmu@ec670000 {
+		ipmmu_mp: iommu@ec670000 {
 			compatible = "renesas,ipmmu-r8a774c0";
 			reg = <0 0xec670000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 4>;
@@ -888,7 +888,7 @@ ipmmu_mp: mmu@ec670000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv0: mmu@fd800000 {
+		ipmmu_pv0: iommu@fd800000 {
 			compatible = "renesas,ipmmu-r8a774c0";
 			reg = <0 0xfd800000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 6>;
@@ -896,7 +896,7 @@ ipmmu_pv0: mmu@fd800000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc0: mmu@fe6b0000 {
+		ipmmu_vc0: iommu@fe6b0000 {
 			compatible = "renesas,ipmmu-r8a774c0";
 			reg = <0 0xfe6b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 12>;
@@ -904,7 +904,7 @@ ipmmu_vc0: mmu@fe6b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a774c0";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 14>;
@@ -912,7 +912,7 @@ ipmmu_vi0: mmu@febd0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vp0: mmu@fe990000 {
+		ipmmu_vp0: iommu@fe990000 {
 			compatible = "renesas,ipmmu-r8a774c0";
 			reg = <0 0xfe990000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 16>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77950.dtsi b/arch/arm64/boot/dts/renesas/r8a77950.dtsi
index 3975eecd50c4..d716c4386ae9 100644
--- a/arch/arm64/boot/dts/renesas/r8a77950.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77950.dtsi
@@ -77,7 +77,7 @@ &soc {
 	/delete-node/ dma-controller@e6460000;
 	/delete-node/ dma-controller@e6470000;
 
-	ipmmu_mp1: mmu@ec680000 {
+	ipmmu_mp1: iommu@ec680000 {
 		compatible = "renesas,ipmmu-r8a7795";
 		reg = <0 0xec680000 0 0x1000>;
 		renesas,ipmmu-main = <&ipmmu_mm 5>;
@@ -85,7 +85,7 @@ ipmmu_mp1: mmu@ec680000 {
 		#iommu-cells = <1>;
 	};
 
-	ipmmu_sy: mmu@e7730000 {
+	ipmmu_sy: iommu@e7730000 {
 		compatible = "renesas,ipmmu-r8a7795";
 		reg = <0 0xe7730000 0 0x1000>;
 		renesas,ipmmu-main = <&ipmmu_mm 8>;
@@ -93,11 +93,11 @@ ipmmu_sy: mmu@e7730000 {
 		#iommu-cells = <1>;
 	};
 
-	/delete-node/ mmu@fd950000;
-	/delete-node/ mmu@fd960000;
-	/delete-node/ mmu@fd970000;
-	/delete-node/ mmu@febe0000;
-	/delete-node/ mmu@fe980000;
+	/delete-node/ iommu@fd950000;
+	/delete-node/ iommu@fd960000;
+	/delete-node/ iommu@fd970000;
+	/delete-node/ iommu@febe0000;
+	/delete-node/ iommu@fe980000;
 
 	xhci1: usb@ee040000 {
 		compatible = "renesas,xhci-r8a7795", "renesas,rcar-gen3-xhci";
diff --git a/arch/arm64/boot/dts/renesas/r8a77951.dtsi b/arch/arm64/boot/dts/renesas/r8a77951.dtsi
index 52229546454c..61d67d9714ab 100644
--- a/arch/arm64/boot/dts/renesas/r8a77951.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77951.dtsi
@@ -1073,7 +1073,7 @@ dmac2: dma-controller@e7310000 {
 			       <&ipmmu_ds1 30>, <&ipmmu_ds1 31>;
 		};
 
-		ipmmu_ds0: mmu@e6740000 {
+		ipmmu_ds0: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xe6740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -1081,7 +1081,7 @@ ipmmu_ds0: mmu@e6740000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 1>;
@@ -1089,7 +1089,7 @@ ipmmu_ds1: mmu@e7740000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_hc: mmu@e6570000 {
+		ipmmu_hc: iommu@e6570000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xe6570000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 2>;
@@ -1097,7 +1097,7 @@ ipmmu_hc: mmu@e6570000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ir: mmu@ff8b0000 {
+		ipmmu_ir: iommu@ff8b0000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xff8b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 3>;
@@ -1105,7 +1105,7 @@ ipmmu_ir: mmu@ff8b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -1114,7 +1114,7 @@ ipmmu_mm: mmu@e67b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mp0: mmu@ec670000 {
+		ipmmu_mp0: iommu@ec670000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xec670000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 4>;
@@ -1122,7 +1122,7 @@ ipmmu_mp0: mmu@ec670000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv0: mmu@fd800000 {
+		ipmmu_pv0: iommu@fd800000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfd800000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 6>;
@@ -1130,7 +1130,7 @@ ipmmu_pv0: mmu@fd800000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv1: mmu@fd950000 {
+		ipmmu_pv1: iommu@fd950000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfd950000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 7>;
@@ -1138,7 +1138,7 @@ ipmmu_pv1: mmu@fd950000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv2: mmu@fd960000 {
+		ipmmu_pv2: iommu@fd960000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfd960000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 8>;
@@ -1146,7 +1146,7 @@ ipmmu_pv2: mmu@fd960000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv3: mmu@fd970000 {
+		ipmmu_pv3: iommu@fd970000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfd970000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 9>;
@@ -1154,7 +1154,7 @@ ipmmu_pv3: mmu@fd970000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xffc80000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 10>;
@@ -1162,7 +1162,7 @@ ipmmu_rt: mmu@ffc80000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc0: mmu@fe6b0000 {
+		ipmmu_vc0: iommu@fe6b0000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfe6b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 12>;
@@ -1170,7 +1170,7 @@ ipmmu_vc0: mmu@fe6b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc1: mmu@fe6f0000 {
+		ipmmu_vc1: iommu@fe6f0000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfe6f0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 13>;
@@ -1178,7 +1178,7 @@ ipmmu_vc1: mmu@fe6f0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 14>;
@@ -1186,7 +1186,7 @@ ipmmu_vi0: mmu@febd0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi1: mmu@febe0000 {
+		ipmmu_vi1: iommu@febe0000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfebe0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 15>;
@@ -1194,7 +1194,7 @@ ipmmu_vi1: mmu@febe0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vp0: mmu@fe990000 {
+		ipmmu_vp0: iommu@fe990000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfe990000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 16>;
@@ -1202,7 +1202,7 @@ ipmmu_vp0: mmu@fe990000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vp1: mmu@fe980000 {
+		ipmmu_vp1: iommu@fe980000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfe980000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 17>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77960.dtsi b/arch/arm64/boot/dts/renesas/r8a77960.dtsi
index 31282367d3ac..33bf62acffbb 100644
--- a/arch/arm64/boot/dts/renesas/r8a77960.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77960.dtsi
@@ -997,7 +997,7 @@ dmac2: dma-controller@e7310000 {
 			       <&ipmmu_ds1 30>, <&ipmmu_ds1 31>;
 		};
 
-		ipmmu_ds0: mmu@e6740000 {
+		ipmmu_ds0: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xe6740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -1005,7 +1005,7 @@ ipmmu_ds0: mmu@e6740000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 1>;
@@ -1013,7 +1013,7 @@ ipmmu_ds1: mmu@e7740000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_hc: mmu@e6570000 {
+		ipmmu_hc: iommu@e6570000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xe6570000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 2>;
@@ -1021,7 +1021,7 @@ ipmmu_hc: mmu@e6570000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ir: mmu@ff8b0000 {
+		ipmmu_ir: iommu@ff8b0000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xff8b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 3>;
@@ -1029,7 +1029,7 @@ ipmmu_ir: mmu@ff8b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -1038,7 +1038,7 @@ ipmmu_mm: mmu@e67b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mp: mmu@ec670000 {
+		ipmmu_mp: iommu@ec670000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xec670000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 4>;
@@ -1046,7 +1046,7 @@ ipmmu_mp: mmu@ec670000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv0: mmu@fd800000 {
+		ipmmu_pv0: iommu@fd800000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xfd800000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 5>;
@@ -1054,7 +1054,7 @@ ipmmu_pv0: mmu@fd800000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv1: mmu@fd950000 {
+		ipmmu_pv1: iommu@fd950000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xfd950000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 6>;
@@ -1062,7 +1062,7 @@ ipmmu_pv1: mmu@fd950000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xffc80000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 7>;
@@ -1070,7 +1070,7 @@ ipmmu_rt: mmu@ffc80000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc0: mmu@fe6b0000 {
+		ipmmu_vc0: iommu@fe6b0000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xfe6b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 8>;
@@ -1078,7 +1078,7 @@ ipmmu_vc0: mmu@fe6b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 9>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77965.dtsi b/arch/arm64/boot/dts/renesas/r8a77965.dtsi
index d82dd4e67b62..6f7ab39fd282 100644
--- a/arch/arm64/boot/dts/renesas/r8a77965.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77965.dtsi
@@ -867,7 +867,7 @@ dmac2: dma-controller@e7310000 {
 			       <&ipmmu_ds1 30>, <&ipmmu_ds1 31>;
 		};
 
-		ipmmu_ds0: mmu@e6740000 {
+		ipmmu_ds0: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xe6740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -875,7 +875,7 @@ ipmmu_ds0: mmu@e6740000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 1>;
@@ -883,7 +883,7 @@ ipmmu_ds1: mmu@e7740000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_hc: mmu@e6570000 {
+		ipmmu_hc: iommu@e6570000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xe6570000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 2>;
@@ -891,7 +891,7 @@ ipmmu_hc: mmu@e6570000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -900,7 +900,7 @@ ipmmu_mm: mmu@e67b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mp: mmu@ec670000 {
+		ipmmu_mp: iommu@ec670000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xec670000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 4>;
@@ -908,7 +908,7 @@ ipmmu_mp: mmu@ec670000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv0: mmu@fd800000 {
+		ipmmu_pv0: iommu@fd800000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xfd800000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 6>;
@@ -916,7 +916,7 @@ ipmmu_pv0: mmu@fd800000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xffc80000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 10>;
@@ -924,7 +924,7 @@ ipmmu_rt: mmu@ffc80000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc0: mmu@fe6b0000 {
+		ipmmu_vc0: iommu@fe6b0000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xfe6b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 12>;
@@ -932,7 +932,7 @@ ipmmu_vc0: mmu@fe6b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 14>;
@@ -940,7 +940,7 @@ ipmmu_vi0: mmu@febd0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vp0: mmu@fe990000 {
+		ipmmu_vp0: iommu@fe990000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xfe990000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 16>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77970.dtsi b/arch/arm64/boot/dts/renesas/r8a77970.dtsi
index a009c0ebc8b4..bd95ecb1b40d 100644
--- a/arch/arm64/boot/dts/renesas/r8a77970.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77970.dtsi
@@ -985,7 +985,7 @@ dmac2: dma-controller@e7310000 {
 			       <&ipmmu_ds1 22>, <&ipmmu_ds1 23>;
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a77970";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -993,7 +993,7 @@ ipmmu_ds1: mmu@e7740000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ir: mmu@ff8b0000 {
+		ipmmu_ir: iommu@ff8b0000 {
 			compatible = "renesas,ipmmu-r8a77970";
 			reg = <0 0xff8b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 3>;
@@ -1001,7 +1001,7 @@ ipmmu_ir: mmu@ff8b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a77970";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -1010,7 +1010,7 @@ ipmmu_mm: mmu@e67b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a77970";
 			reg = <0 0xffc80000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 7>;
@@ -1018,7 +1018,7 @@ ipmmu_rt: mmu@ffc80000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a77970";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 9>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77980.dtsi b/arch/arm64/boot/dts/renesas/r8a77980.dtsi
index d672b320bc14..387e6d99f2f3 100644
--- a/arch/arm64/boot/dts/renesas/r8a77980.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77980.dtsi
@@ -1266,7 +1266,7 @@ gether: ethernet@e7400000 {
 			status = "disabled";
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -1274,7 +1274,7 @@ ipmmu_ds1: mmu@e7740000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ir: mmu@ff8b0000 {
+		ipmmu_ir: iommu@ff8b0000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xff8b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 3>;
@@ -1282,7 +1282,7 @@ ipmmu_ir: mmu@ff8b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -1291,7 +1291,7 @@ ipmmu_mm: mmu@e67b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xffc80000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 10>;
@@ -1299,7 +1299,7 @@ ipmmu_rt: mmu@ffc80000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc0: mmu@fe990000 {
+		ipmmu_vc0: iommu@fe990000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xfe990000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 12>;
@@ -1307,7 +1307,7 @@ ipmmu_vc0: mmu@fe990000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 14>;
@@ -1315,7 +1315,7 @@ ipmmu_vi0: mmu@febd0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vip0: mmu@e7b00000 {
+		ipmmu_vip0: iommu@e7b00000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xe7b00000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 4>;
@@ -1323,7 +1323,7 @@ ipmmu_vip0: mmu@e7b00000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vip1: mmu@e7960000 {
+		ipmmu_vip1: iommu@e7960000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xe7960000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 11>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77990.dtsi b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
index 1543f18e834f..cd11f24744d4 100644
--- a/arch/arm64/boot/dts/renesas/r8a77990.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
@@ -817,7 +817,7 @@ dmac2: dma-controller@e7310000 {
 			       <&ipmmu_ds1 30>, <&ipmmu_ds1 31>;
 		};
 
-		ipmmu_ds0: mmu@e6740000 {
+		ipmmu_ds0: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xe6740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -825,7 +825,7 @@ ipmmu_ds0: mmu@e6740000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 1>;
@@ -833,7 +833,7 @@ ipmmu_ds1: mmu@e7740000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_hc: mmu@e6570000 {
+		ipmmu_hc: iommu@e6570000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xe6570000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 2>;
@@ -841,7 +841,7 @@ ipmmu_hc: mmu@e6570000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -850,7 +850,7 @@ ipmmu_mm: mmu@e67b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mp: mmu@ec670000 {
+		ipmmu_mp: iommu@ec670000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xec670000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 4>;
@@ -858,7 +858,7 @@ ipmmu_mp: mmu@ec670000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv0: mmu@fd800000 {
+		ipmmu_pv0: iommu@fd800000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xfd800000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 6>;
@@ -866,7 +866,7 @@ ipmmu_pv0: mmu@fd800000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xffc80000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 10>;
@@ -874,7 +874,7 @@ ipmmu_rt: mmu@ffc80000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc0: mmu@fe6b0000 {
+		ipmmu_vc0: iommu@fe6b0000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xfe6b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 12>;
@@ -882,7 +882,7 @@ ipmmu_vc0: mmu@fe6b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 14>;
@@ -890,7 +890,7 @@ ipmmu_vi0: mmu@febd0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vp0: mmu@fe990000 {
+		ipmmu_vp0: iommu@fe990000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xfe990000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 16>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77995.dtsi b/arch/arm64/boot/dts/renesas/r8a77995.dtsi
index e8d2290fe79d..e5617ec0f49c 100644
--- a/arch/arm64/boot/dts/renesas/r8a77995.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77995.dtsi
@@ -507,7 +507,7 @@ dmac2: dma-controller@e7310000 {
 			       <&ipmmu_ds1 22>, <&ipmmu_ds1 23>;
 		};
 
-		ipmmu_ds0: mmu@e6740000 {
+		ipmmu_ds0: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xe6740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -515,7 +515,7 @@ ipmmu_ds0: mmu@e6740000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 1>;
@@ -523,7 +523,7 @@ ipmmu_ds1: mmu@e7740000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_hc: mmu@e6570000 {
+		ipmmu_hc: iommu@e6570000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xe6570000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 2>;
@@ -531,7 +531,7 @@ ipmmu_hc: mmu@e6570000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -540,7 +540,7 @@ ipmmu_mm: mmu@e67b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mp: mmu@ec670000 {
+		ipmmu_mp: iommu@ec670000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xec670000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 4>;
@@ -548,7 +548,7 @@ ipmmu_mp: mmu@ec670000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv0: mmu@fd800000 {
+		ipmmu_pv0: iommu@fd800000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xfd800000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 6>;
@@ -556,7 +556,7 @@ ipmmu_pv0: mmu@fd800000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xffc80000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 10>;
@@ -564,7 +564,7 @@ ipmmu_rt: mmu@ffc80000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc0: mmu@fe6b0000 {
+		ipmmu_vc0: iommu@fe6b0000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xfe6b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 12>;
@@ -572,7 +572,7 @@ ipmmu_vc0: mmu@fe6b0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 14>;
@@ -580,7 +580,7 @@ ipmmu_vi0: mmu@febd0000 {
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vp0: mmu@fe990000 {
+		ipmmu_vp0: iommu@fe990000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xfe990000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 16>;
-- 
2.25.1

