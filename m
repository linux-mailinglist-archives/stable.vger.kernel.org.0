Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BF8206699
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387661AbgFWVpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:45:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387651AbgFWUB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:01:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2F052080C;
        Tue, 23 Jun 2020 20:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942486;
        bh=FqbIEP2+xJNsy+OV6IgJgR52Rfcp5aWwEwpoXpHng/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GgBKQMO8Afm68R+XBWKWQBm8BmJaU6nIpRSu7Yy7S34xUHKpbJNABCc59fdCV0yDk
         thHIKeAo8hKCg7PfUShbw3eI5k3h6K2t8d1EXFaabFuKZsfR5JRJ7aj/g2UScCuckE
         e4kDAeiSzq43YbIEfRtcEZXCRmIkeeQF07tV6dMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 018/477] arm64: dts: renesas: Fix IOMMU device node names
Date:   Tue, 23 Jun 2020 21:50:15 +0200
Message-Id: <20200623195408.465043894@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 79023433a740b..a603d947970ec 100644
--- a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
@@ -1000,7 +1000,7 @@
 			       <&ipmmu_ds1 30>, <&ipmmu_ds1 31>;
 		};
 
-		ipmmu_ds0: mmu@e6740000 {
+		ipmmu_ds0: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a774a1";
 			reg = <0 0xe6740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -1008,7 +1008,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a774a1";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 1>;
@@ -1016,7 +1016,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_hc: mmu@e6570000 {
+		ipmmu_hc: iommu@e6570000 {
 			compatible = "renesas,ipmmu-r8a774a1";
 			reg = <0 0xe6570000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 2>;
@@ -1024,7 +1024,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a774a1";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -1033,7 +1033,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mp: mmu@ec670000 {
+		ipmmu_mp: iommu@ec670000 {
 			compatible = "renesas,ipmmu-r8a774a1";
 			reg = <0 0xec670000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 4>;
@@ -1041,7 +1041,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv0: mmu@fd800000 {
+		ipmmu_pv0: iommu@fd800000 {
 			compatible = "renesas,ipmmu-r8a774a1";
 			reg = <0 0xfd800000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 5>;
@@ -1049,7 +1049,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv1: mmu@fd950000 {
+		ipmmu_pv1: iommu@fd950000 {
 			compatible = "renesas,ipmmu-r8a774a1";
 			reg = <0 0xfd950000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 6>;
@@ -1057,7 +1057,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc0: mmu@fe6b0000 {
+		ipmmu_vc0: iommu@fe6b0000 {
 			compatible = "renesas,ipmmu-r8a774a1";
 			reg = <0 0xfe6b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 8>;
@@ -1065,7 +1065,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a774a1";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 9>;
diff --git a/arch/arm64/boot/dts/renesas/r8a774b1.dtsi b/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
index 3137f735974be..1e51855c7cd38 100644
--- a/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
@@ -874,7 +874,7 @@
 			       <&ipmmu_ds1 30>, <&ipmmu_ds1 31>;
 		};
 
-		ipmmu_ds0: mmu@e6740000 {
+		ipmmu_ds0: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a774b1";
 			reg = <0 0xe6740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -882,7 +882,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a774b1";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 1>;
@@ -890,7 +890,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_hc: mmu@e6570000 {
+		ipmmu_hc: iommu@e6570000 {
 			compatible = "renesas,ipmmu-r8a774b1";
 			reg = <0 0xe6570000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 2>;
@@ -898,7 +898,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a774b1";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -907,7 +907,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mp: mmu@ec670000 {
+		ipmmu_mp: iommu@ec670000 {
 			compatible = "renesas,ipmmu-r8a774b1";
 			reg = <0 0xec670000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 4>;
@@ -915,7 +915,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv0: mmu@fd800000 {
+		ipmmu_pv0: iommu@fd800000 {
 			compatible = "renesas,ipmmu-r8a774b1";
 			reg = <0 0xfd800000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 6>;
@@ -923,7 +923,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc0: mmu@fe6b0000 {
+		ipmmu_vc0: iommu@fe6b0000 {
 			compatible = "renesas,ipmmu-r8a774b1";
 			reg = <0 0xfe6b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 12>;
@@ -931,7 +931,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a774b1";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 14>;
@@ -939,7 +939,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vp0: mmu@fe990000 {
+		ipmmu_vp0: iommu@fe990000 {
 			compatible = "renesas,ipmmu-r8a774b1";
 			reg = <0 0xfe990000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 16>;
diff --git a/arch/arm64/boot/dts/renesas/r8a774c0.dtsi b/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
index 22785cbddff5d..5c72a7efbb035 100644
--- a/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
@@ -847,7 +847,7 @@
 			       <&ipmmu_ds1 30>, <&ipmmu_ds1 31>;
 		};
 
-		ipmmu_ds0: mmu@e6740000 {
+		ipmmu_ds0: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a774c0";
 			reg = <0 0xe6740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -855,7 +855,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a774c0";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 1>;
@@ -863,7 +863,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_hc: mmu@e6570000 {
+		ipmmu_hc: iommu@e6570000 {
 			compatible = "renesas,ipmmu-r8a774c0";
 			reg = <0 0xe6570000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 2>;
@@ -871,7 +871,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a774c0";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -880,7 +880,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mp: mmu@ec670000 {
+		ipmmu_mp: iommu@ec670000 {
 			compatible = "renesas,ipmmu-r8a774c0";
 			reg = <0 0xec670000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 4>;
@@ -888,7 +888,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv0: mmu@fd800000 {
+		ipmmu_pv0: iommu@fd800000 {
 			compatible = "renesas,ipmmu-r8a774c0";
 			reg = <0 0xfd800000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 6>;
@@ -896,7 +896,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc0: mmu@fe6b0000 {
+		ipmmu_vc0: iommu@fe6b0000 {
 			compatible = "renesas,ipmmu-r8a774c0";
 			reg = <0 0xfe6b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 12>;
@@ -904,7 +904,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a774c0";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 14>;
@@ -912,7 +912,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vp0: mmu@fe990000 {
+		ipmmu_vp0: iommu@fe990000 {
 			compatible = "renesas,ipmmu-r8a774c0";
 			reg = <0 0xfe990000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 16>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77950.dtsi b/arch/arm64/boot/dts/renesas/r8a77950.dtsi
index 3975eecd50c49..d716c4386ae9f 100644
--- a/arch/arm64/boot/dts/renesas/r8a77950.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77950.dtsi
@@ -77,7 +77,7 @@
 	/delete-node/ dma-controller@e6460000;
 	/delete-node/ dma-controller@e6470000;
 
-	ipmmu_mp1: mmu@ec680000 {
+	ipmmu_mp1: iommu@ec680000 {
 		compatible = "renesas,ipmmu-r8a7795";
 		reg = <0 0xec680000 0 0x1000>;
 		renesas,ipmmu-main = <&ipmmu_mm 5>;
@@ -85,7 +85,7 @@
 		#iommu-cells = <1>;
 	};
 
-	ipmmu_sy: mmu@e7730000 {
+	ipmmu_sy: iommu@e7730000 {
 		compatible = "renesas,ipmmu-r8a7795";
 		reg = <0 0xe7730000 0 0x1000>;
 		renesas,ipmmu-main = <&ipmmu_mm 8>;
@@ -93,11 +93,11 @@
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
index 52229546454c4..61d67d9714ab9 100644
--- a/arch/arm64/boot/dts/renesas/r8a77951.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77951.dtsi
@@ -1073,7 +1073,7 @@
 			       <&ipmmu_ds1 30>, <&ipmmu_ds1 31>;
 		};
 
-		ipmmu_ds0: mmu@e6740000 {
+		ipmmu_ds0: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xe6740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -1081,7 +1081,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 1>;
@@ -1089,7 +1089,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_hc: mmu@e6570000 {
+		ipmmu_hc: iommu@e6570000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xe6570000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 2>;
@@ -1097,7 +1097,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ir: mmu@ff8b0000 {
+		ipmmu_ir: iommu@ff8b0000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xff8b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 3>;
@@ -1105,7 +1105,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -1114,7 +1114,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mp0: mmu@ec670000 {
+		ipmmu_mp0: iommu@ec670000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xec670000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 4>;
@@ -1122,7 +1122,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv0: mmu@fd800000 {
+		ipmmu_pv0: iommu@fd800000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfd800000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 6>;
@@ -1130,7 +1130,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv1: mmu@fd950000 {
+		ipmmu_pv1: iommu@fd950000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfd950000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 7>;
@@ -1138,7 +1138,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv2: mmu@fd960000 {
+		ipmmu_pv2: iommu@fd960000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfd960000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 8>;
@@ -1146,7 +1146,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv3: mmu@fd970000 {
+		ipmmu_pv3: iommu@fd970000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfd970000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 9>;
@@ -1154,7 +1154,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xffc80000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 10>;
@@ -1162,7 +1162,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc0: mmu@fe6b0000 {
+		ipmmu_vc0: iommu@fe6b0000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfe6b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 12>;
@@ -1170,7 +1170,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc1: mmu@fe6f0000 {
+		ipmmu_vc1: iommu@fe6f0000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfe6f0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 13>;
@@ -1178,7 +1178,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 14>;
@@ -1186,7 +1186,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi1: mmu@febe0000 {
+		ipmmu_vi1: iommu@febe0000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfebe0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 15>;
@@ -1194,7 +1194,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vp0: mmu@fe990000 {
+		ipmmu_vp0: iommu@fe990000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfe990000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 16>;
@@ -1202,7 +1202,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vp1: mmu@fe980000 {
+		ipmmu_vp1: iommu@fe980000 {
 			compatible = "renesas,ipmmu-r8a7795";
 			reg = <0 0xfe980000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 17>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77960.dtsi b/arch/arm64/boot/dts/renesas/r8a77960.dtsi
index 31282367d3acd..33bf62acffbb7 100644
--- a/arch/arm64/boot/dts/renesas/r8a77960.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77960.dtsi
@@ -997,7 +997,7 @@
 			       <&ipmmu_ds1 30>, <&ipmmu_ds1 31>;
 		};
 
-		ipmmu_ds0: mmu@e6740000 {
+		ipmmu_ds0: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xe6740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -1005,7 +1005,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 1>;
@@ -1013,7 +1013,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_hc: mmu@e6570000 {
+		ipmmu_hc: iommu@e6570000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xe6570000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 2>;
@@ -1021,7 +1021,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ir: mmu@ff8b0000 {
+		ipmmu_ir: iommu@ff8b0000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xff8b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 3>;
@@ -1029,7 +1029,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -1038,7 +1038,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mp: mmu@ec670000 {
+		ipmmu_mp: iommu@ec670000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xec670000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 4>;
@@ -1046,7 +1046,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv0: mmu@fd800000 {
+		ipmmu_pv0: iommu@fd800000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xfd800000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 5>;
@@ -1054,7 +1054,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv1: mmu@fd950000 {
+		ipmmu_pv1: iommu@fd950000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xfd950000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 6>;
@@ -1062,7 +1062,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xffc80000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 7>;
@@ -1070,7 +1070,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc0: mmu@fe6b0000 {
+		ipmmu_vc0: iommu@fe6b0000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xfe6b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 8>;
@@ -1078,7 +1078,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a7796";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 9>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77965.dtsi b/arch/arm64/boot/dts/renesas/r8a77965.dtsi
index d82dd4e67b62b..6f7ab39fd2824 100644
--- a/arch/arm64/boot/dts/renesas/r8a77965.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77965.dtsi
@@ -867,7 +867,7 @@
 			       <&ipmmu_ds1 30>, <&ipmmu_ds1 31>;
 		};
 
-		ipmmu_ds0: mmu@e6740000 {
+		ipmmu_ds0: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xe6740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -875,7 +875,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 1>;
@@ -883,7 +883,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_hc: mmu@e6570000 {
+		ipmmu_hc: iommu@e6570000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xe6570000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 2>;
@@ -891,7 +891,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -900,7 +900,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mp: mmu@ec670000 {
+		ipmmu_mp: iommu@ec670000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xec670000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 4>;
@@ -908,7 +908,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv0: mmu@fd800000 {
+		ipmmu_pv0: iommu@fd800000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xfd800000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 6>;
@@ -916,7 +916,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xffc80000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 10>;
@@ -924,7 +924,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc0: mmu@fe6b0000 {
+		ipmmu_vc0: iommu@fe6b0000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xfe6b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 12>;
@@ -932,7 +932,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 14>;
@@ -940,7 +940,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vp0: mmu@fe990000 {
+		ipmmu_vp0: iommu@fe990000 {
 			compatible = "renesas,ipmmu-r8a77965";
 			reg = <0 0xfe990000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 16>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77970.dtsi b/arch/arm64/boot/dts/renesas/r8a77970.dtsi
index a009c0ebc8b4f..bd95ecb1b40d8 100644
--- a/arch/arm64/boot/dts/renesas/r8a77970.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77970.dtsi
@@ -985,7 +985,7 @@
 			       <&ipmmu_ds1 22>, <&ipmmu_ds1 23>;
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a77970";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -993,7 +993,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ir: mmu@ff8b0000 {
+		ipmmu_ir: iommu@ff8b0000 {
 			compatible = "renesas,ipmmu-r8a77970";
 			reg = <0 0xff8b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 3>;
@@ -1001,7 +1001,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a77970";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -1010,7 +1010,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a77970";
 			reg = <0 0xffc80000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 7>;
@@ -1018,7 +1018,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a77970";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 9>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77980.dtsi b/arch/arm64/boot/dts/renesas/r8a77980.dtsi
index d672b320bc145..387e6d99f2f36 100644
--- a/arch/arm64/boot/dts/renesas/r8a77980.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77980.dtsi
@@ -1266,7 +1266,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -1274,7 +1274,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ir: mmu@ff8b0000 {
+		ipmmu_ir: iommu@ff8b0000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xff8b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 3>;
@@ -1282,7 +1282,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -1291,7 +1291,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xffc80000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 10>;
@@ -1299,7 +1299,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc0: mmu@fe990000 {
+		ipmmu_vc0: iommu@fe990000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xfe990000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 12>;
@@ -1307,7 +1307,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 14>;
@@ -1315,7 +1315,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vip0: mmu@e7b00000 {
+		ipmmu_vip0: iommu@e7b00000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xe7b00000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 4>;
@@ -1323,7 +1323,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vip1: mmu@e7960000 {
+		ipmmu_vip1: iommu@e7960000 {
 			compatible = "renesas,ipmmu-r8a77980";
 			reg = <0 0xe7960000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 11>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77990.dtsi b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
index 1543f18e834f4..cd11f24744d4a 100644
--- a/arch/arm64/boot/dts/renesas/r8a77990.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
@@ -817,7 +817,7 @@
 			       <&ipmmu_ds1 30>, <&ipmmu_ds1 31>;
 		};
 
-		ipmmu_ds0: mmu@e6740000 {
+		ipmmu_ds0: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xe6740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -825,7 +825,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 1>;
@@ -833,7 +833,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_hc: mmu@e6570000 {
+		ipmmu_hc: iommu@e6570000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xe6570000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 2>;
@@ -841,7 +841,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -850,7 +850,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mp: mmu@ec670000 {
+		ipmmu_mp: iommu@ec670000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xec670000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 4>;
@@ -858,7 +858,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv0: mmu@fd800000 {
+		ipmmu_pv0: iommu@fd800000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xfd800000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 6>;
@@ -866,7 +866,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xffc80000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 10>;
@@ -874,7 +874,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc0: mmu@fe6b0000 {
+		ipmmu_vc0: iommu@fe6b0000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xfe6b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 12>;
@@ -882,7 +882,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 14>;
@@ -890,7 +890,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vp0: mmu@fe990000 {
+		ipmmu_vp0: iommu@fe990000 {
 			compatible = "renesas,ipmmu-r8a77990";
 			reg = <0 0xfe990000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 16>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77995.dtsi b/arch/arm64/boot/dts/renesas/r8a77995.dtsi
index e8d2290fe79d7..e5617ec0f49cb 100644
--- a/arch/arm64/boot/dts/renesas/r8a77995.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77995.dtsi
@@ -507,7 +507,7 @@
 			       <&ipmmu_ds1 22>, <&ipmmu_ds1 23>;
 		};
 
-		ipmmu_ds0: mmu@e6740000 {
+		ipmmu_ds0: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xe6740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 0>;
@@ -515,7 +515,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_ds1: mmu@e7740000 {
+		ipmmu_ds1: iommu@e7740000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xe7740000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 1>;
@@ -523,7 +523,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_hc: mmu@e6570000 {
+		ipmmu_hc: iommu@e6570000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xe6570000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 2>;
@@ -531,7 +531,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mm: mmu@e67b0000 {
+		ipmmu_mm: iommu@e67b0000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xe67b0000 0 0x1000>;
 			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
@@ -540,7 +540,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_mp: mmu@ec670000 {
+		ipmmu_mp: iommu@ec670000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xec670000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 4>;
@@ -548,7 +548,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_pv0: mmu@fd800000 {
+		ipmmu_pv0: iommu@fd800000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xfd800000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 6>;
@@ -556,7 +556,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xffc80000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 10>;
@@ -564,7 +564,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vc0: mmu@fe6b0000 {
+		ipmmu_vc0: iommu@fe6b0000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xfe6b0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 12>;
@@ -572,7 +572,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vi0: mmu@febd0000 {
+		ipmmu_vi0: iommu@febd0000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xfebd0000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 14>;
@@ -580,7 +580,7 @@
 			#iommu-cells = <1>;
 		};
 
-		ipmmu_vp0: mmu@fe990000 {
+		ipmmu_vp0: iommu@fe990000 {
 			compatible = "renesas,ipmmu-r8a77995";
 			reg = <0 0xfe990000 0 0x1000>;
 			renesas,ipmmu-main = <&ipmmu_mm 16>;
-- 
2.25.1



