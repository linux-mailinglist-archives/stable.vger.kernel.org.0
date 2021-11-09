Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26EC44B574
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241857AbhKIWUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:20:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245504AbhKIWUV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:20:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1C4B61027;
        Tue,  9 Nov 2021 22:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496240;
        bh=RKvTEGcFLNesPpDHRCTccw90S/XXd6jc8Qzho6g73L0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pndmYPDsTCCs7jXCa18A3sqLyqKJ8XjJ/nrB1qXN4J/1AzheK/DJ13ugrjXuLFvQ2
         VEQ5hFTEfDDehxmeEyGPlwBCabFYb7sdcIjIOBSPtxhVgbApvheRQENHw/3aV8cS4E
         n2y3xE4hcqfqHGi/FdCMH4jOLD8TVp0gkrd+jB45/pAHwuj39bKvVDK2dRrAUWbV5P
         moCCndd2vwQF0O5LDxxJAraHpmnglATmMu8Fk9gAslNxydwP/WyL7ru6iK91CokEc2
         kcHDh4dvMRIwGr/PEO6CiPuOGQVhDDf0hUhx8pVe/l+IA7X8dU2rVDhs+S21ti5aQa
         QkJCo+BwPgvlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>, Wei Xu <xuwei5@hisilicon.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 16/82] arm64: dts: hisilicon: fix arm,sp805 compatible string
Date:   Tue,  9 Nov 2021 17:15:34 -0500
Message-Id: <20211109221641.1233217-16-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 894d4f1f77d0e88f1f81af2e1e37333c1c41b631 ]

According to Documentation/devicetree/bindings/watchdog/arm,sp805.yaml
the compatible is:
  compatible = "arm,sp805", "arm,primecell";

The current compatible string doesn't exist at all. Fix it.

Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/hisilicon/hi3660.dtsi | 4 ++--
 arch/arm64/boot/dts/hisilicon/hi6220.dtsi | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/hisilicon/hi3660.dtsi b/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
index 2d5c1a348716a..6eabec2602e23 100644
--- a/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
@@ -1087,7 +1087,7 @@
 		};
 
 		watchdog0: watchdog@e8a06000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xe8a06000 0x0 0x1000>;
 			interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&crg_ctrl HI3660_OSC32K>,
@@ -1096,7 +1096,7 @@
 		};
 
 		watchdog1: watchdog@e8a07000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xe8a07000 0x0 0x1000>;
 			interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&crg_ctrl HI3660_OSC32K>,
diff --git a/arch/arm64/boot/dts/hisilicon/hi6220.dtsi b/arch/arm64/boot/dts/hisilicon/hi6220.dtsi
index dde9371dc5451..e4860b8a638ec 100644
--- a/arch/arm64/boot/dts/hisilicon/hi6220.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hi6220.dtsi
@@ -840,7 +840,7 @@
 		};
 
 		watchdog0: watchdog@f8005000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xf8005000 0x0 0x1000>;
 			interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&ao_ctrl HI6220_WDT0_PCLK>,
-- 
2.33.0

