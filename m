Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA36A44B67A
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344594AbhKIW1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:27:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:41104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344184AbhKIWZa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:25:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5C9661A0D;
        Tue,  9 Nov 2021 22:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496376;
        bh=elr+QbfI2F+4NI8UHuNhjqlTP/2e5Quor1FydPXmnHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xz3K0qxnN2OalPHWAkYZt0nL1v9EBDwVR+AFGu3Om78W+Q03WIvKm90O9xDu+9ITZ
         eNwaukWi9NcDNiQRu7li4EikbFc6LfCcTe8pdvRkka5mMs5zRP2K+wAqYuZkzFJ0AW
         fjCVnrOy4g8akA6Qo25O8hFnOV2EJRznXAGXJ45Lji5YdwhiMNu7yxWuBjUl+jLdv9
         KB4NdP0oQXeKKYG8AvfdnThCGiWFGo+hKPZLUW5csKpDTrn8O8s75521KN7+/qiViz
         MbRaE3eaVI4rIi61PBJJf8VL6jcWpTHzFvR9IcRPwMsMjIDWUq4/vOWmdZO0adszY1
         IhNmzcudonErQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>, Wei Xu <xuwei5@hisilicon.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 15/75] arm64: dts: hisilicon: fix arm,sp805 compatible string
Date:   Tue,  9 Nov 2021 17:18:05 -0500
Message-Id: <20211109221905.1234094-15-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
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
index f1ec87c058421..ef70144972671 100644
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

