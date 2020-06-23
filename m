Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C3A20669B
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390817AbgFWVpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:45:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387610AbgFWUBR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:01:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BBFF206C3;
        Tue, 23 Jun 2020 20:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942476;
        bh=U5Q6+8CGURXaua+xnPPC5QS3m+tdrb/XSQcbT1FfpH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=daPMDqZlcmfcmHqjB73MD5WfYJm6WG5TW0tVClKmWE9aL7a3x1o0pSn7FlVde+y4p
         Gkq5/LFbuHn1RSBIrucyd2fRSylbV1bTn9oTZQQNMPzVItCBQRLfkZMsrSle2ftaiU
         nadLImTSDPPAXAEH+nLtVOTd9Of2KQFMxHF9DkYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 014/477] ARM: dts: renesas: Fix IOMMU device node names
Date:   Tue, 23 Jun 2020 21:50:11 +0200
Message-Id: <20200623195408.272558652@linuxfoundation.org>
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

[ Upstream commit ae990a1de014396ffc8d0fcc31b6888c9b0ce59a ]

Fix IOMMU device node names as "iommu@".

Fixes: bbb44da0b595 ("ARM: dts: r8a7743: Add IPMMU DT nodes")
Fixes: 0dcba3de5835 ("ARM: dts: r8a7745: Add IPMMU DT nodes")
Fixes: 350ae49b97c4 ("ARM: dts: r8a7744: Add IPMMU DT nodes")
Fixes: 70496727c082 ("ARM: shmobile: r8a7790: Add IPMMU DT nodes")
Fixes: f1951852ed17 ("ARM: shmobile: r8a7791: Add IPMMU DT nodes")
Fixes: 098cb3a601e6 ("ARM: shmobile: r8a7793: Add IPMMU nodes")
Fixes: 1cb2794f6082 ("ARM: shmobile: r8a7794: Add IPMMU DT nodes")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/r/1587461756-13317-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/r8a7743.dtsi | 12 ++++++------
 arch/arm/boot/dts/r8a7744.dtsi | 12 ++++++------
 arch/arm/boot/dts/r8a7745.dtsi | 12 ++++++------
 arch/arm/boot/dts/r8a7790.dtsi | 12 ++++++------
 arch/arm/boot/dts/r8a7791.dtsi | 14 +++++++-------
 arch/arm/boot/dts/r8a7793.dtsi | 14 +++++++-------
 arch/arm/boot/dts/r8a7794.dtsi | 12 ++++++------
 7 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7743.dtsi b/arch/arm/boot/dts/r8a7743.dtsi
index e8b340bb99bc3..fff123753b85b 100644
--- a/arch/arm/boot/dts/r8a7743.dtsi
+++ b/arch/arm/boot/dts/r8a7743.dtsi
@@ -338,7 +338,7 @@
 			#thermal-sensor-cells = <0>;
 		};
 
-		ipmmu_sy0: mmu@e6280000 {
+		ipmmu_sy0: iommu@e6280000 {
 			compatible = "renesas,ipmmu-r8a7743",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6280000 0 0x1000>;
@@ -348,7 +348,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_sy1: mmu@e6290000 {
+		ipmmu_sy1: iommu@e6290000 {
 			compatible = "renesas,ipmmu-r8a7743",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6290000 0 0x1000>;
@@ -357,7 +357,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_ds: mmu@e6740000 {
+		ipmmu_ds: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a7743",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6740000 0 0x1000>;
@@ -367,7 +367,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_mp: mmu@ec680000 {
+		ipmmu_mp: iommu@ec680000 {
 			compatible = "renesas,ipmmu-r8a7743",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xec680000 0 0x1000>;
@@ -376,7 +376,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_mx: mmu@fe951000 {
+		ipmmu_mx: iommu@fe951000 {
 			compatible = "renesas,ipmmu-r8a7743",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xfe951000 0 0x1000>;
@@ -386,7 +386,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_gp: mmu@e62a0000 {
+		ipmmu_gp: iommu@e62a0000 {
 			compatible = "renesas,ipmmu-r8a7743",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe62a0000 0 0x1000>;
diff --git a/arch/arm/boot/dts/r8a7744.dtsi b/arch/arm/boot/dts/r8a7744.dtsi
index def840b8b2d3c..5050ac19041d5 100644
--- a/arch/arm/boot/dts/r8a7744.dtsi
+++ b/arch/arm/boot/dts/r8a7744.dtsi
@@ -338,7 +338,7 @@
 			#thermal-sensor-cells = <0>;
 		};
 
-		ipmmu_sy0: mmu@e6280000 {
+		ipmmu_sy0: iommu@e6280000 {
 			compatible = "renesas,ipmmu-r8a7744",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6280000 0 0x1000>;
@@ -348,7 +348,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_sy1: mmu@e6290000 {
+		ipmmu_sy1: iommu@e6290000 {
 			compatible = "renesas,ipmmu-r8a7744",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6290000 0 0x1000>;
@@ -357,7 +357,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_ds: mmu@e6740000 {
+		ipmmu_ds: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a7744",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6740000 0 0x1000>;
@@ -367,7 +367,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_mp: mmu@ec680000 {
+		ipmmu_mp: iommu@ec680000 {
 			compatible = "renesas,ipmmu-r8a7744",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xec680000 0 0x1000>;
@@ -376,7 +376,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_mx: mmu@fe951000 {
+		ipmmu_mx: iommu@fe951000 {
 			compatible = "renesas,ipmmu-r8a7744",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xfe951000 0 0x1000>;
@@ -386,7 +386,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_gp: mmu@e62a0000 {
+		ipmmu_gp: iommu@e62a0000 {
 			compatible = "renesas,ipmmu-r8a7744",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe62a0000 0 0x1000>;
diff --git a/arch/arm/boot/dts/r8a7745.dtsi b/arch/arm/boot/dts/r8a7745.dtsi
index 7ab58d8bb7401..b0d1fc24e97e4 100644
--- a/arch/arm/boot/dts/r8a7745.dtsi
+++ b/arch/arm/boot/dts/r8a7745.dtsi
@@ -302,7 +302,7 @@
 			resets = <&cpg 407>;
 		};
 
-		ipmmu_sy0: mmu@e6280000 {
+		ipmmu_sy0: iommu@e6280000 {
 			compatible = "renesas,ipmmu-r8a7745",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6280000 0 0x1000>;
@@ -312,7 +312,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_sy1: mmu@e6290000 {
+		ipmmu_sy1: iommu@e6290000 {
 			compatible = "renesas,ipmmu-r8a7745",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6290000 0 0x1000>;
@@ -321,7 +321,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_ds: mmu@e6740000 {
+		ipmmu_ds: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a7745",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6740000 0 0x1000>;
@@ -331,7 +331,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_mp: mmu@ec680000 {
+		ipmmu_mp: iommu@ec680000 {
 			compatible = "renesas,ipmmu-r8a7745",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xec680000 0 0x1000>;
@@ -340,7 +340,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_mx: mmu@fe951000 {
+		ipmmu_mx: iommu@fe951000 {
 			compatible = "renesas,ipmmu-r8a7745",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xfe951000 0 0x1000>;
@@ -350,7 +350,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_gp: mmu@e62a0000 {
+		ipmmu_gp: iommu@e62a0000 {
 			compatible = "renesas,ipmmu-r8a7745",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe62a0000 0 0x1000>;
diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
index e5ef9fd4284ae..166d5566229d4 100644
--- a/arch/arm/boot/dts/r8a7790.dtsi
+++ b/arch/arm/boot/dts/r8a7790.dtsi
@@ -427,7 +427,7 @@
 			#thermal-sensor-cells = <0>;
 		};
 
-		ipmmu_sy0: mmu@e6280000 {
+		ipmmu_sy0: iommu@e6280000 {
 			compatible = "renesas,ipmmu-r8a7790",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6280000 0 0x1000>;
@@ -437,7 +437,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_sy1: mmu@e6290000 {
+		ipmmu_sy1: iommu@e6290000 {
 			compatible = "renesas,ipmmu-r8a7790",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6290000 0 0x1000>;
@@ -446,7 +446,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_ds: mmu@e6740000 {
+		ipmmu_ds: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a7790",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6740000 0 0x1000>;
@@ -456,7 +456,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_mp: mmu@ec680000 {
+		ipmmu_mp: iommu@ec680000 {
 			compatible = "renesas,ipmmu-r8a7790",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xec680000 0 0x1000>;
@@ -465,7 +465,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_mx: mmu@fe951000 {
+		ipmmu_mx: iommu@fe951000 {
 			compatible = "renesas,ipmmu-r8a7790",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xfe951000 0 0x1000>;
@@ -475,7 +475,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a7790",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xffc80000 0 0x1000>;
diff --git a/arch/arm/boot/dts/r8a7791.dtsi b/arch/arm/boot/dts/r8a7791.dtsi
index 6e5bd86731cde..09e47cc177650 100644
--- a/arch/arm/boot/dts/r8a7791.dtsi
+++ b/arch/arm/boot/dts/r8a7791.dtsi
@@ -350,7 +350,7 @@
 			#thermal-sensor-cells = <0>;
 		};
 
-		ipmmu_sy0: mmu@e6280000 {
+		ipmmu_sy0: iommu@e6280000 {
 			compatible = "renesas,ipmmu-r8a7791",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6280000 0 0x1000>;
@@ -360,7 +360,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_sy1: mmu@e6290000 {
+		ipmmu_sy1: iommu@e6290000 {
 			compatible = "renesas,ipmmu-r8a7791",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6290000 0 0x1000>;
@@ -369,7 +369,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_ds: mmu@e6740000 {
+		ipmmu_ds: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a7791",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6740000 0 0x1000>;
@@ -379,7 +379,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_mp: mmu@ec680000 {
+		ipmmu_mp: iommu@ec680000 {
 			compatible = "renesas,ipmmu-r8a7791",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xec680000 0 0x1000>;
@@ -388,7 +388,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_mx: mmu@fe951000 {
+		ipmmu_mx: iommu@fe951000 {
 			compatible = "renesas,ipmmu-r8a7791",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xfe951000 0 0x1000>;
@@ -398,7 +398,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a7791",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xffc80000 0 0x1000>;
@@ -407,7 +407,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_gp: mmu@e62a0000 {
+		ipmmu_gp: iommu@e62a0000 {
 			compatible = "renesas,ipmmu-r8a7791",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe62a0000 0 0x1000>;
diff --git a/arch/arm/boot/dts/r8a7793.dtsi b/arch/arm/boot/dts/r8a7793.dtsi
index dadbda16161b7..1b62a7e06b429 100644
--- a/arch/arm/boot/dts/r8a7793.dtsi
+++ b/arch/arm/boot/dts/r8a7793.dtsi
@@ -336,7 +336,7 @@
 			#thermal-sensor-cells = <0>;
 		};
 
-		ipmmu_sy0: mmu@e6280000 {
+		ipmmu_sy0: iommu@e6280000 {
 			compatible = "renesas,ipmmu-r8a7793",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6280000 0 0x1000>;
@@ -346,7 +346,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_sy1: mmu@e6290000 {
+		ipmmu_sy1: iommu@e6290000 {
 			compatible = "renesas,ipmmu-r8a7793",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6290000 0 0x1000>;
@@ -355,7 +355,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_ds: mmu@e6740000 {
+		ipmmu_ds: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a7793",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6740000 0 0x1000>;
@@ -365,7 +365,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_mp: mmu@ec680000 {
+		ipmmu_mp: iommu@ec680000 {
 			compatible = "renesas,ipmmu-r8a7793",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xec680000 0 0x1000>;
@@ -374,7 +374,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_mx: mmu@fe951000 {
+		ipmmu_mx: iommu@fe951000 {
 			compatible = "renesas,ipmmu-r8a7793",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xfe951000 0 0x1000>;
@@ -384,7 +384,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a7793",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xffc80000 0 0x1000>;
@@ -393,7 +393,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_gp: mmu@e62a0000 {
+		ipmmu_gp: iommu@e62a0000 {
 			compatible = "renesas,ipmmu-r8a7793",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe62a0000 0 0x1000>;
diff --git a/arch/arm/boot/dts/r8a7794.dtsi b/arch/arm/boot/dts/r8a7794.dtsi
index 2c9e7a1ebfec1..8d7f8798628a6 100644
--- a/arch/arm/boot/dts/r8a7794.dtsi
+++ b/arch/arm/boot/dts/r8a7794.dtsi
@@ -290,7 +290,7 @@
 			resets = <&cpg 407>;
 		};
 
-		ipmmu_sy0: mmu@e6280000 {
+		ipmmu_sy0: iommu@e6280000 {
 			compatible = "renesas,ipmmu-r8a7794",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6280000 0 0x1000>;
@@ -300,7 +300,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_sy1: mmu@e6290000 {
+		ipmmu_sy1: iommu@e6290000 {
 			compatible = "renesas,ipmmu-r8a7794",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6290000 0 0x1000>;
@@ -309,7 +309,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_ds: mmu@e6740000 {
+		ipmmu_ds: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a7794",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6740000 0 0x1000>;
@@ -319,7 +319,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_mp: mmu@ec680000 {
+		ipmmu_mp: iommu@ec680000 {
 			compatible = "renesas,ipmmu-r8a7794",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xec680000 0 0x1000>;
@@ -328,7 +328,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_mx: mmu@fe951000 {
+		ipmmu_mx: iommu@fe951000 {
 			compatible = "renesas,ipmmu-r8a7794",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xfe951000 0 0x1000>;
@@ -338,7 +338,7 @@
 			status = "disabled";
 		};
 
-		ipmmu_gp: mmu@e62a0000 {
+		ipmmu_gp: iommu@e62a0000 {
 			compatible = "renesas,ipmmu-r8a7794",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe62a0000 0 0x1000>;
-- 
2.25.1



