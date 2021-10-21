Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7606A435776
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhJUA02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:26:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231980AbhJUAZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:25:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 625FE61381;
        Thu, 21 Oct 2021 00:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775793;
        bh=JZvb5aZChvEeaRYi0gPN5KIejU8wmaPEpKHviKIR3Ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/1LYoPsRE6wGYmTa5ZCZ7YPDa3lKQkQY/ZdYetQSkzMuqngVS9H7nPh2pB3Gxzgx
         c3xHcDR6B+jJqeSJXPZra5BlUHOKkzS3SndD857ynfWjQNVW6rfnP1RhvGuJx/PBeD
         o/lBQYeBrHSOqmZIRtvt2AacOO1Iri89IGQgOQv6dyIrFT79SAOsGAXHo7jQ6fk2rJ
         INTF+KFjvzY7hI91Ut0kKpeJKekCpjwUJz9iYQa59H5RV6bkZLEbY6lOMGAew3ZX7r
         BspaVNOg4FCvFgFq77LrX45oLCQMwIP0E5o6EwJ8dbQw4G2F5hz0omQN8LGB86acDO
         yoTtc35VTAjXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Herve Codina <herve.codina@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, vireshk@kernel.org,
        shiraz.linux.kernel@gmail.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/10] ARM: dts: spear3xx: Fix gmac node
Date:   Wed, 20 Oct 2021 20:22:59 -0400
Message-Id: <20211021002305.1129633-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002305.1129633-1-sashal@kernel.org>
References: <20211021002305.1129633-1-sashal@kernel.org>
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

