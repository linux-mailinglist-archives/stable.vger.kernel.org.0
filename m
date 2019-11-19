Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBC9110188A
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfKSFZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:25:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:42100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727640AbfKSFZL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:25:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A02C821783;
        Tue, 19 Nov 2019 05:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141110;
        bh=vFmPq7PNhXDOpLhB/RDsLsk5lYZk6ybGv47b1LMINsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xtA0ILHcIroh0C3Qm87kBOhzmwuIBDWIFAqVobF7OVODnGwMSzkOF5wIYyXfveTW6
         62P8U8fGJYztlbhE2C/LsH70Dd+SikyoGh615FOYo7UOg+hC9/Jm+L2cW6eVxDlCDJ
         NThqXor2c0XIbXG4y032kbcp332jeU56LA2FoW68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 047/422] ARM: dts: rcar: Correct SATA device sizes to 2 MiB
Date:   Tue, 19 Nov 2019 06:14:04 +0100
Message-Id: <20191119051402.923163298@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 441f61e3aa9e7386731ce1405044d484bd81f911 ]

Update the SATA device nodes on R-Car H1, H2, and M2-W to use a 2 MiB
I/O space, as specified in Rev.1.0 of the R-Car H1 and R-Car Gen2
hardware user manuals.

See also commit e9f0089b2d8a3d45 ("arm64: dts: r8a7795: Correct SATA
device size to 2MiB").

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/r8a7779.dtsi | 2 +-
 arch/arm/boot/dts/r8a7790.dtsi | 4 ++--
 arch/arm/boot/dts/r8a7791.dtsi | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7779.dtsi b/arch/arm/boot/dts/r8a7779.dtsi
index 6b997bc016ee8..03919714645ae 100644
--- a/arch/arm/boot/dts/r8a7779.dtsi
+++ b/arch/arm/boot/dts/r8a7779.dtsi
@@ -344,7 +344,7 @@
 
 	sata: sata@fc600000 {
 		compatible = "renesas,sata-r8a7779", "renesas,rcar-sata";
-		reg = <0xfc600000 0x2000>;
+		reg = <0xfc600000 0x200000>;
 		interrupts = <GIC_SPI 100 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp1_clks R8A7779_CLK_SATA>;
 		power-domains = <&sysc R8A7779_PD_ALWAYS_ON>;
diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
index 0925bdca438fe..52a757f47bf08 100644
--- a/arch/arm/boot/dts/r8a7790.dtsi
+++ b/arch/arm/boot/dts/r8a7790.dtsi
@@ -1559,7 +1559,7 @@
 		sata0: sata@ee300000 {
 			compatible = "renesas,sata-r8a7790",
 				     "renesas,rcar-gen2-sata";
-			reg = <0 0xee300000 0 0x2000>;
+			reg = <0 0xee300000 0 0x200000>;
 			interrupts = <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 815>;
 			power-domains = <&sysc R8A7790_PD_ALWAYS_ON>;
@@ -1570,7 +1570,7 @@
 		sata1: sata@ee500000 {
 			compatible = "renesas,sata-r8a7790",
 				     "renesas,rcar-gen2-sata";
-			reg = <0 0xee500000 0 0x2000>;
+			reg = <0 0xee500000 0 0x200000>;
 			interrupts = <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 814>;
 			power-domains = <&sysc R8A7790_PD_ALWAYS_ON>;
diff --git a/arch/arm/boot/dts/r8a7791.dtsi b/arch/arm/boot/dts/r8a7791.dtsi
index 991ac6feedd5b..25b6a99dd87a2 100644
--- a/arch/arm/boot/dts/r8a7791.dtsi
+++ b/arch/arm/boot/dts/r8a7791.dtsi
@@ -1543,7 +1543,7 @@
 		sata0: sata@ee300000 {
 			compatible = "renesas,sata-r8a7791",
 				     "renesas,rcar-gen2-sata";
-			reg = <0 0xee300000 0 0x2000>;
+			reg = <0 0xee300000 0 0x200000>;
 			interrupts = <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 815>;
 			power-domains = <&sysc R8A7791_PD_ALWAYS_ON>;
@@ -1554,7 +1554,7 @@
 		sata1: sata@ee500000 {
 			compatible = "renesas,sata-r8a7791",
 				     "renesas,rcar-gen2-sata";
-			reg = <0 0xee500000 0 0x2000>;
+			reg = <0 0xee500000 0 0x200000>;
 			interrupts = <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 814>;
 			power-domains = <&sysc R8A7791_PD_ALWAYS_ON>;
-- 
2.20.1



