Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2DD3C8D8A
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbhGNTpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235533AbhGNToY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:44:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D1C1613EE;
        Wed, 14 Jul 2021 19:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291672;
        bh=gpnF7OUMNHCYMkaXyNSVlQlN1/Aws7hl9vXk2PLcjrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjQ4RJO9PiNXFchSaNm1MJuDcOEnRi7KlmFkCHcN2TEFonQCAXbQitUn8dOl4Oi92
         zb1Bos1BTFwtdgqo0UlBiZHLm4Ykmt8FNBCuHIRnnJznQERpZqtgkW/k3CYyouzcW9
         y06LH+Mlabr1iPFj7V85qbu9CEvexY1xIaox2QV2Z/MASjxm5aEv3bQ2jthQCFamBA
         OCiuAfdpF+ZsCHjzUPZRVoDA++P4pgDSL8v/8LsxHVH22GhiDlvlQTeAhC0JzW7Kno
         PZBZ9shKmr2W1qnN4hJHblpNXlhSmdKF7xJ1m/W5ZvtdwJXoMZstB6BbdICEcrh31Y
         lNy5T6JGqeRcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 025/102] ARM: dts: exynos: align Broadcom WiFi with dtschema
Date:   Wed, 14 Jul 2021 15:39:18 -0400
Message-Id: <20210714194036.53141-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit cc29e39412b9a78b43f7dfa09d739f8ba9fa7984 ]

The Broadcom BCM4329 family dtschema expects devices to be compatible
also with brcm,bcm4329-fmac:

  arch/arm/boot/dts/exynos3250-rinato.dt.yaml: wifi@1: compatible: 'oneOf' conditional failed, one must be fixed:
    ['brcm,bcm4334-fmac'] is too short
    'brcm,bcm4329-fmac' was expected

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20210505135941.59898-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos3250-rinato.dts         | 2 +-
 arch/arm/boot/dts/exynos4210-i9100.dts          | 2 +-
 arch/arm/boot/dts/exynos4210-trats.dts          | 2 +-
 arch/arm/boot/dts/exynos4210-universal_c210.dts | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index d64ccf4b7d32..2a93f71abf9a 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -653,7 +653,7 @@ &mshc_1 {
 	mmc-pwrseq = <&wlan_pwrseq>;
 
 	brcmf: wifi@1 {
-		compatible = "brcm,bcm4334-fmac";
+		compatible = "brcm,bcm4334-fmac", "brcm,bcm4329-fmac";
 		reg = <1>;
 
 		interrupt-parent = <&gpx1>;
diff --git a/arch/arm/boot/dts/exynos4210-i9100.dts b/arch/arm/boot/dts/exynos4210-i9100.dts
index d98c78207aaf..26820b46cc76 100644
--- a/arch/arm/boot/dts/exynos4210-i9100.dts
+++ b/arch/arm/boot/dts/exynos4210-i9100.dts
@@ -752,7 +752,7 @@ &sdhci_3 {
 	pinctrl-0 = <&sd3_clk>, <&sd3_cmd>, <&sd3_bus4>;
 
 	brcmf: wifi@1 {
-		compatible = "brcm,bcm4330-fmac";
+		compatible = "brcm,bcm4330-fmac", "brcm,bcm4329-fmac";
 		reg = <1>;
 
 		interrupt-parent = <&gpx2>;
diff --git a/arch/arm/boot/dts/exynos4210-trats.dts b/arch/arm/boot/dts/exynos4210-trats.dts
index d2406c9146b8..3eb8df319246 100644
--- a/arch/arm/boot/dts/exynos4210-trats.dts
+++ b/arch/arm/boot/dts/exynos4210-trats.dts
@@ -521,7 +521,7 @@ &sdhci_3 {
 	pinctrl-0 = <&sd3_clk>, <&sd3_cmd>, <&sd3_bus4>;
 
 	brcmf: wifi@1 {
-		compatible = "brcm,bcm4330-fmac";
+		compatible = "brcm,bcm4330-fmac", "brcm,bcm4329-fmac";
 		reg = <1>;
 
 		interrupt-parent = <&gpx2>;
diff --git a/arch/arm/boot/dts/exynos4210-universal_c210.dts b/arch/arm/boot/dts/exynos4210-universal_c210.dts
index dd44ad2c6ad6..f052853244a4 100644
--- a/arch/arm/boot/dts/exynos4210-universal_c210.dts
+++ b/arch/arm/boot/dts/exynos4210-universal_c210.dts
@@ -614,7 +614,7 @@ &sdhci_3 {
 	pinctrl-0 = <&sd3_clk>, <&sd3_cmd>, <&sd3_bus4>;
 
 	brcmf: wifi@1 {
-		compatible = "brcm,bcm4330-fmac";
+		compatible = "brcm,bcm4330-fmac", "brcm,bcm4329-fmac";
 		reg = <1>;
 		interrupt-parent = <&gpx2>;
 		interrupts = <5 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.30.2

