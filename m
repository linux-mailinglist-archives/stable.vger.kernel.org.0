Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B945F4357BA
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhJUA2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:28:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231857AbhJUA0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:26:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9FA061354;
        Thu, 21 Oct 2021 00:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775869;
        bh=JZvb5aZChvEeaRYi0gPN5KIejU8wmaPEpKHviKIR3Ho=;
        h=From:To:Cc:Subject:Date:From;
        b=l1w1oVbh4UHg+yRGUKU9jd7J8ESKlRj3R248eHQdI99CIY9hSe5BEZJ5V4cdN7aSF
         UfhFilJA6ChnSMWUPLx2+RLpthD586KrADsZRp2U8w3e+3B8BHIiX6lAqPKKZ1Jvhg
         pZ0MamTrngwvXy+Fg5S5N1OcM1ED/8TeR/7XrYm0j8kMPm1mLipcgzzOqQreAMWHEm
         N21qa8SCHsE8xrcbQDqw5QQ72MLQvT2It0L7hN6PviSHpgbrz55QqPVaFXd4b7jpVA
         TVavexv6GOBz9XvAEL8se42gnzndsbHYt1fZNzcLSMPuEOWz6VOplEk/nbwtiCPogA
         vk1kkf2kN1FHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Herve Codina <herve.codina@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, vireshk@kernel.org,
        shiraz.linux.kernel@gmail.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/7] ARM: dts: spear3xx: Fix gmac node
Date:   Wed, 20 Oct 2021 20:24:20 -0400
Message-Id: <20211021002427.1130044-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 6636fec29cdf6665bd219564609e8651f6ddc142 ]

On SPEAr3xx, ethernet driver is not compatible with the SPEAr600
one.
Indeed, SPEAr3xx uses an earlier version of this IP (v3.40) and
needs some driver tuning compare to SPEAr600.

The v3.40 IP support was added to stmmac driver and this patch
fixes this issue and use the correct compatible string for
SPEAr3xx

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/spear3xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/spear3xx.dtsi b/arch/arm/boot/dts/spear3xx.dtsi
index 118135d75899..4e4166d96b26 100644
--- a/arch/arm/boot/dts/spear3xx.dtsi
+++ b/arch/arm/boot/dts/spear3xx.dtsi
@@ -53,7 +53,7 @@ dma@fc400000 {
 		};
 
 		gmac: eth@e0800000 {
-			compatible = "st,spear600-gmac";
+			compatible = "snps,dwmac-3.40a";
 			reg = <0xe0800000 0x8000>;
 			interrupts = <23 22>;
 			interrupt-names = "macirq", "eth_wake_irq";
-- 
2.33.0

