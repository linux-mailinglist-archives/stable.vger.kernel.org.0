Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA15B1FDC1A
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgFRBQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:16:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728800AbgFRBQt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:16:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 787EE21D80;
        Thu, 18 Jun 2020 01:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443008;
        bh=ZF5pLP1xQEDutAGX1wdMPzCQgPQOe+9sdqXZFI3dazc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SnuRv/UMHGZb6FMxcocOpjufe7wgc0ciaB7VbIA2BGQul9fU9UQaH/819wL4V86mk
         JKNBUrZh8A2fz8GgKE0PjsmM7amWRCyVYGcl0jsEQPuvbe+S6y13zzq/X+qClSfIB2
         oaWstr47tvdQjG9JRgLixjTs5HdcBbhm/5v3S+Ak=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 012/266] ARM: dts: renesas: Fix IOMMU device node names
Date:   Wed, 17 Jun 2020 21:12:17 -0400
Message-Id: <20200618011631.604574-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
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
index de981d629bdd..fdd267819319 100644
--- a/arch/arm/boot/dts/r8a7743.dtsi
+++ b/arch/arm/boot/dts/r8a7743.dtsi
@@ -338,7 +338,7 @@ thermal: thermal@e61f0000 {
 			#thermal-sensor-cells = <0>;
 		};
 
-		ipmmu_sy0: mmu@e6280000 {
+		ipmmu_sy0: iommu@e6280000 {
 			compatible = "renesas,ipmmu-r8a7743",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6280000 0 0x1000>;
@@ -348,7 +348,7 @@ ipmmu_sy0: mmu@e6280000 {
 			status = "disabled";
 		};
 
-		ipmmu_sy1: mmu@e6290000 {
+		ipmmu_sy1: iommu@e6290000 {
 			compatible = "renesas,ipmmu-r8a7743",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6290000 0 0x1000>;
@@ -357,7 +357,7 @@ ipmmu_sy1: mmu@e6290000 {
 			status = "disabled";
 		};
 
-		ipmmu_ds: mmu@e6740000 {
+		ipmmu_ds: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a7743",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6740000 0 0x1000>;
@@ -367,7 +367,7 @@ ipmmu_ds: mmu@e6740000 {
 			status = "disabled";
 		};
 
-		ipmmu_mp: mmu@ec680000 {
+		ipmmu_mp: iommu@ec680000 {
 			compatible = "renesas,ipmmu-r8a7743",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xec680000 0 0x1000>;
@@ -376,7 +376,7 @@ ipmmu_mp: mmu@ec680000 {
 			status = "disabled";
 		};
 
-		ipmmu_mx: mmu@fe951000 {
+		ipmmu_mx: iommu@fe951000 {
 			compatible = "renesas,ipmmu-r8a7743",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xfe951000 0 0x1000>;
@@ -386,7 +386,7 @@ ipmmu_mx: mmu@fe951000 {
 			status = "disabled";
 		};
 
-		ipmmu_gp: mmu@e62a0000 {
+		ipmmu_gp: iommu@e62a0000 {
 			compatible = "renesas,ipmmu-r8a7743",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe62a0000 0 0x1000>;
diff --git a/arch/arm/boot/dts/r8a7744.dtsi b/arch/arm/boot/dts/r8a7744.dtsi
index fa74a262107b..8264481bf876 100644
--- a/arch/arm/boot/dts/r8a7744.dtsi
+++ b/arch/arm/boot/dts/r8a7744.dtsi
@@ -338,7 +338,7 @@ thermal: thermal@e61f0000 {
 			#thermal-sensor-cells = <0>;
 		};
 
-		ipmmu_sy0: mmu@e6280000 {
+		ipmmu_sy0: iommu@e6280000 {
 			compatible = "renesas,ipmmu-r8a7744",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6280000 0 0x1000>;
@@ -348,7 +348,7 @@ ipmmu_sy0: mmu@e6280000 {
 			status = "disabled";
 		};
 
-		ipmmu_sy1: mmu@e6290000 {
+		ipmmu_sy1: iommu@e6290000 {
 			compatible = "renesas,ipmmu-r8a7744",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6290000 0 0x1000>;
@@ -357,7 +357,7 @@ ipmmu_sy1: mmu@e6290000 {
 			status = "disabled";
 		};
 
-		ipmmu_ds: mmu@e6740000 {
+		ipmmu_ds: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a7744",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6740000 0 0x1000>;
@@ -367,7 +367,7 @@ ipmmu_ds: mmu@e6740000 {
 			status = "disabled";
 		};
 
-		ipmmu_mp: mmu@ec680000 {
+		ipmmu_mp: iommu@ec680000 {
 			compatible = "renesas,ipmmu-r8a7744",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xec680000 0 0x1000>;
@@ -376,7 +376,7 @@ ipmmu_mp: mmu@ec680000 {
 			status = "disabled";
 		};
 
-		ipmmu_mx: mmu@fe951000 {
+		ipmmu_mx: iommu@fe951000 {
 			compatible = "renesas,ipmmu-r8a7744",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xfe951000 0 0x1000>;
@@ -386,7 +386,7 @@ ipmmu_mx: mmu@fe951000 {
 			status = "disabled";
 		};
 
-		ipmmu_gp: mmu@e62a0000 {
+		ipmmu_gp: iommu@e62a0000 {
 			compatible = "renesas,ipmmu-r8a7744",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe62a0000 0 0x1000>;
diff --git a/arch/arm/boot/dts/r8a7745.dtsi b/arch/arm/boot/dts/r8a7745.dtsi
index c53f7ff20695..c306713f2ab7 100644
--- a/arch/arm/boot/dts/r8a7745.dtsi
+++ b/arch/arm/boot/dts/r8a7745.dtsi
@@ -302,7 +302,7 @@ irqc: interrupt-controller@e61c0000 {
 			resets = <&cpg 407>;
 		};
 
-		ipmmu_sy0: mmu@e6280000 {
+		ipmmu_sy0: iommu@e6280000 {
 			compatible = "renesas,ipmmu-r8a7745",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6280000 0 0x1000>;
@@ -312,7 +312,7 @@ ipmmu_sy0: mmu@e6280000 {
 			status = "disabled";
 		};
 
-		ipmmu_sy1: mmu@e6290000 {
+		ipmmu_sy1: iommu@e6290000 {
 			compatible = "renesas,ipmmu-r8a7745",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6290000 0 0x1000>;
@@ -321,7 +321,7 @@ ipmmu_sy1: mmu@e6290000 {
 			status = "disabled";
 		};
 
-		ipmmu_ds: mmu@e6740000 {
+		ipmmu_ds: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a7745",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6740000 0 0x1000>;
@@ -331,7 +331,7 @@ ipmmu_ds: mmu@e6740000 {
 			status = "disabled";
 		};
 
-		ipmmu_mp: mmu@ec680000 {
+		ipmmu_mp: iommu@ec680000 {
 			compatible = "renesas,ipmmu-r8a7745",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xec680000 0 0x1000>;
@@ -340,7 +340,7 @@ ipmmu_mp: mmu@ec680000 {
 			status = "disabled";
 		};
 
-		ipmmu_mx: mmu@fe951000 {
+		ipmmu_mx: iommu@fe951000 {
 			compatible = "renesas,ipmmu-r8a7745",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xfe951000 0 0x1000>;
@@ -350,7 +350,7 @@ ipmmu_mx: mmu@fe951000 {
 			status = "disabled";
 		};
 
-		ipmmu_gp: mmu@e62a0000 {
+		ipmmu_gp: iommu@e62a0000 {
 			compatible = "renesas,ipmmu-r8a7745",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe62a0000 0 0x1000>;
diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
index 5a2747758f67..e3ba00a22eeb 100644
--- a/arch/arm/boot/dts/r8a7790.dtsi
+++ b/arch/arm/boot/dts/r8a7790.dtsi
@@ -427,7 +427,7 @@ thermal: thermal@e61f0000 {
 			#thermal-sensor-cells = <0>;
 		};
 
-		ipmmu_sy0: mmu@e6280000 {
+		ipmmu_sy0: iommu@e6280000 {
 			compatible = "renesas,ipmmu-r8a7790",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6280000 0 0x1000>;
@@ -437,7 +437,7 @@ ipmmu_sy0: mmu@e6280000 {
 			status = "disabled";
 		};
 
-		ipmmu_sy1: mmu@e6290000 {
+		ipmmu_sy1: iommu@e6290000 {
 			compatible = "renesas,ipmmu-r8a7790",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6290000 0 0x1000>;
@@ -446,7 +446,7 @@ ipmmu_sy1: mmu@e6290000 {
 			status = "disabled";
 		};
 
-		ipmmu_ds: mmu@e6740000 {
+		ipmmu_ds: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a7790",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6740000 0 0x1000>;
@@ -456,7 +456,7 @@ ipmmu_ds: mmu@e6740000 {
 			status = "disabled";
 		};
 
-		ipmmu_mp: mmu@ec680000 {
+		ipmmu_mp: iommu@ec680000 {
 			compatible = "renesas,ipmmu-r8a7790",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xec680000 0 0x1000>;
@@ -465,7 +465,7 @@ ipmmu_mp: mmu@ec680000 {
 			status = "disabled";
 		};
 
-		ipmmu_mx: mmu@fe951000 {
+		ipmmu_mx: iommu@fe951000 {
 			compatible = "renesas,ipmmu-r8a7790",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xfe951000 0 0x1000>;
@@ -475,7 +475,7 @@ ipmmu_mx: mmu@fe951000 {
 			status = "disabled";
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a7790",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xffc80000 0 0x1000>;
diff --git a/arch/arm/boot/dts/r8a7791.dtsi b/arch/arm/boot/dts/r8a7791.dtsi
index 6f875502453c..a26f86ccc579 100644
--- a/arch/arm/boot/dts/r8a7791.dtsi
+++ b/arch/arm/boot/dts/r8a7791.dtsi
@@ -350,7 +350,7 @@ thermal: thermal@e61f0000 {
 			#thermal-sensor-cells = <0>;
 		};
 
-		ipmmu_sy0: mmu@e6280000 {
+		ipmmu_sy0: iommu@e6280000 {
 			compatible = "renesas,ipmmu-r8a7791",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6280000 0 0x1000>;
@@ -360,7 +360,7 @@ ipmmu_sy0: mmu@e6280000 {
 			status = "disabled";
 		};
 
-		ipmmu_sy1: mmu@e6290000 {
+		ipmmu_sy1: iommu@e6290000 {
 			compatible = "renesas,ipmmu-r8a7791",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6290000 0 0x1000>;
@@ -369,7 +369,7 @@ ipmmu_sy1: mmu@e6290000 {
 			status = "disabled";
 		};
 
-		ipmmu_ds: mmu@e6740000 {
+		ipmmu_ds: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a7791",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6740000 0 0x1000>;
@@ -379,7 +379,7 @@ ipmmu_ds: mmu@e6740000 {
 			status = "disabled";
 		};
 
-		ipmmu_mp: mmu@ec680000 {
+		ipmmu_mp: iommu@ec680000 {
 			compatible = "renesas,ipmmu-r8a7791",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xec680000 0 0x1000>;
@@ -388,7 +388,7 @@ ipmmu_mp: mmu@ec680000 {
 			status = "disabled";
 		};
 
-		ipmmu_mx: mmu@fe951000 {
+		ipmmu_mx: iommu@fe951000 {
 			compatible = "renesas,ipmmu-r8a7791",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xfe951000 0 0x1000>;
@@ -398,7 +398,7 @@ ipmmu_mx: mmu@fe951000 {
 			status = "disabled";
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a7791",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xffc80000 0 0x1000>;
@@ -407,7 +407,7 @@ ipmmu_rt: mmu@ffc80000 {
 			status = "disabled";
 		};
 
-		ipmmu_gp: mmu@e62a0000 {
+		ipmmu_gp: iommu@e62a0000 {
 			compatible = "renesas,ipmmu-r8a7791",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe62a0000 0 0x1000>;
diff --git a/arch/arm/boot/dts/r8a7793.dtsi b/arch/arm/boot/dts/r8a7793.dtsi
index bf05110fac4e..fa3839795018 100644
--- a/arch/arm/boot/dts/r8a7793.dtsi
+++ b/arch/arm/boot/dts/r8a7793.dtsi
@@ -336,7 +336,7 @@ thermal: thermal@e61f0000 {
 			#thermal-sensor-cells = <0>;
 		};
 
-		ipmmu_sy0: mmu@e6280000 {
+		ipmmu_sy0: iommu@e6280000 {
 			compatible = "renesas,ipmmu-r8a7793",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6280000 0 0x1000>;
@@ -346,7 +346,7 @@ ipmmu_sy0: mmu@e6280000 {
 			status = "disabled";
 		};
 
-		ipmmu_sy1: mmu@e6290000 {
+		ipmmu_sy1: iommu@e6290000 {
 			compatible = "renesas,ipmmu-r8a7793",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6290000 0 0x1000>;
@@ -355,7 +355,7 @@ ipmmu_sy1: mmu@e6290000 {
 			status = "disabled";
 		};
 
-		ipmmu_ds: mmu@e6740000 {
+		ipmmu_ds: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a7793",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6740000 0 0x1000>;
@@ -365,7 +365,7 @@ ipmmu_ds: mmu@e6740000 {
 			status = "disabled";
 		};
 
-		ipmmu_mp: mmu@ec680000 {
+		ipmmu_mp: iommu@ec680000 {
 			compatible = "renesas,ipmmu-r8a7793",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xec680000 0 0x1000>;
@@ -374,7 +374,7 @@ ipmmu_mp: mmu@ec680000 {
 			status = "disabled";
 		};
 
-		ipmmu_mx: mmu@fe951000 {
+		ipmmu_mx: iommu@fe951000 {
 			compatible = "renesas,ipmmu-r8a7793",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xfe951000 0 0x1000>;
@@ -384,7 +384,7 @@ ipmmu_mx: mmu@fe951000 {
 			status = "disabled";
 		};
 
-		ipmmu_rt: mmu@ffc80000 {
+		ipmmu_rt: iommu@ffc80000 {
 			compatible = "renesas,ipmmu-r8a7793",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xffc80000 0 0x1000>;
@@ -393,7 +393,7 @@ ipmmu_rt: mmu@ffc80000 {
 			status = "disabled";
 		};
 
-		ipmmu_gp: mmu@e62a0000 {
+		ipmmu_gp: iommu@e62a0000 {
 			compatible = "renesas,ipmmu-r8a7793",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe62a0000 0 0x1000>;
diff --git a/arch/arm/boot/dts/r8a7794.dtsi b/arch/arm/boot/dts/r8a7794.dtsi
index 8d797d34816e..9dd952479e68 100644
--- a/arch/arm/boot/dts/r8a7794.dtsi
+++ b/arch/arm/boot/dts/r8a7794.dtsi
@@ -290,7 +290,7 @@ irqc0: interrupt-controller@e61c0000 {
 			resets = <&cpg 407>;
 		};
 
-		ipmmu_sy0: mmu@e6280000 {
+		ipmmu_sy0: iommu@e6280000 {
 			compatible = "renesas,ipmmu-r8a7794",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6280000 0 0x1000>;
@@ -300,7 +300,7 @@ ipmmu_sy0: mmu@e6280000 {
 			status = "disabled";
 		};
 
-		ipmmu_sy1: mmu@e6290000 {
+		ipmmu_sy1: iommu@e6290000 {
 			compatible = "renesas,ipmmu-r8a7794",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6290000 0 0x1000>;
@@ -309,7 +309,7 @@ ipmmu_sy1: mmu@e6290000 {
 			status = "disabled";
 		};
 
-		ipmmu_ds: mmu@e6740000 {
+		ipmmu_ds: iommu@e6740000 {
 			compatible = "renesas,ipmmu-r8a7794",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe6740000 0 0x1000>;
@@ -319,7 +319,7 @@ ipmmu_ds: mmu@e6740000 {
 			status = "disabled";
 		};
 
-		ipmmu_mp: mmu@ec680000 {
+		ipmmu_mp: iommu@ec680000 {
 			compatible = "renesas,ipmmu-r8a7794",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xec680000 0 0x1000>;
@@ -328,7 +328,7 @@ ipmmu_mp: mmu@ec680000 {
 			status = "disabled";
 		};
 
-		ipmmu_mx: mmu@fe951000 {
+		ipmmu_mx: iommu@fe951000 {
 			compatible = "renesas,ipmmu-r8a7794",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xfe951000 0 0x1000>;
@@ -338,7 +338,7 @@ ipmmu_mx: mmu@fe951000 {
 			status = "disabled";
 		};
 
-		ipmmu_gp: mmu@e62a0000 {
+		ipmmu_gp: iommu@e62a0000 {
 			compatible = "renesas,ipmmu-r8a7794",
 				     "renesas,ipmmu-vmsa";
 			reg = <0 0xe62a0000 0 0x1000>;
-- 
2.25.1

