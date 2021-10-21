Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0C94357A6
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhJUA1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:27:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232528AbhJUA0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:26:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAAD061391;
        Thu, 21 Oct 2021 00:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775846;
        bh=JZvb5aZChvEeaRYi0gPN5KIejU8wmaPEpKHviKIR3Ho=;
        h=From:To:Cc:Subject:Date:From;
        b=e8pm1GWnEvWci0uqLqJ/f+rWcobQ6rwfyd/lEcFTHCNfffza2vM0vTTmCTPOU9V9t
         X2k98TMWb7kjvpkMAtWDE2GU2dkaRdChEeMhFI+x4L1yGr3n/o9QZ2x9w0Fk94kzMd
         1V20Sq8zxCQ5lJ/Bg8kyx0AmLmmOyh6PC2RjkSBBhPWDPe7+QL0gl+KW0BDAqxV8Mm
         hLFUOfz7EeCtXeS6mBv83MNZHr4I0Y7C06Di/F+I8sY74q2IO6bgyztMXcPlTWefY9
         QApFnyBoAqj1MzS+JqHY9VDE5/3VqHK83MhX83rCw6Zgt2vfQGzf89rPrdNdyL/jVq
         UpRRP2Ly1KGgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Herve Codina <herve.codina@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, vireshk@kernel.org,
        shiraz.linux.kernel@gmail.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 1/7] ARM: dts: spear3xx: Fix gmac node
Date:   Wed, 20 Oct 2021 20:23:57 -0400
Message-Id: <20211021002404.1129946-1-sashal@kernel.org>
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

