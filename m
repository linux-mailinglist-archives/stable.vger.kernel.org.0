Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59FA3C8C43
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbhGNTld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233427AbhGNTla (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:41:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E9EB613E5;
        Wed, 14 Jul 2021 19:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291518;
        bh=YqPZ4A7rwODNHcwjLupbqwVXr++J4UcLSbXKtNNQLfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJ5ySzOXEkGGTvpv0g0yIt0HmH3v601oJ8dK7zJOjqfcMDXSL2/B1YEDqEiwDuXWV
         sOngoq7iT372+DSUVuDWpD4+rslrhKlVPazMPFPY1RVty2NovgXq9i40AMOo9pQtxY
         qjmUJhSyPH0/RJT0JUB2pwP+NOBTicMYkhLnOz8DvqXe69uBndqNy4175nFXTNZ0s/
         qQulOrrEtcGVgXDfPCYeBNdzS9MkhrDlxu/zlLKhJdGphduNbWhoFUivRe/6p/kuDM
         5r6J4e5a4J6ckzRLvODfCNDxjUYqKNSaG3A6p1PLQm/E7H7Uxd+d8yxNbx8fzGyf+V
         OZvD8kNE/LVEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 025/108] ARM: dts: exynos: align Broadcom WiFi with dtschema
Date:   Wed, 14 Jul 2021 15:36:37 -0400
Message-Id: <20210714193800.52097-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
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
index c52b9cf4f74c..f6ba5e426040 100644
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
index 525ff3d2fac3..db70f62cc08f 100644
--- a/arch/arm/boot/dts/exynos4210-i9100.dts
+++ b/arch/arm/boot/dts/exynos4210-i9100.dts
@@ -806,7 +806,7 @@ &sdhci_3 {
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

