Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF27437CF1F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236036AbhELRIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:08:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239626AbhELQuU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:50:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F7DE61E8C;
        Wed, 12 May 2021 16:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836187;
        bh=V9TTWM/FdIb7f4inNOYuRsbBFdOcMFf8+vZ3Q1I9HOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pxmez0O7BcqD5bUhZpbNzL9oorO8G4KRAlMaDVIYXN+hmJlGDqFp4jFccxFyYZv6m
         WK8/1JwsXcHFqA5wP3+AEWPiBJSDx9159l7JS2NsddZc1urGWwNoRnzEkOuaV2rL97
         5KmBQyKwjrV9RMgEHZqYzM0vCABbFL+ygcV1DpB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 638/677] arm64: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E
Date:   Wed, 12 May 2021 16:51:24 +0200
Message-Id: <20210512144858.560141591@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit dcabb06bf127b3e0d3fbc94a2b65dd56c2725851 ]

UniPhier LD20 and PXs3 boards have RTL8211E ethernet phy, and the phy have
the RX/TX delays of RGMII interface using pull-ups on the RXDLY and TXDLY
pins.

After the commit bbc4d71d6354 ("net: phy: realtek: fix rtl8211e rx/tx
delay config"), the delays are working correctly, however, "rgmii" means
no delay and the phy doesn't work. So need to set the phy-mode to
"rgmii-id" to show that RX/TX delays are enabled.

Fixes: c73730ee4c9a ("arm64: dts: uniphier: add AVE ethernet node")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/socionext/uniphier-ld20.dtsi | 2 +-
 arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/socionext/uniphier-ld20.dtsi b/arch/arm64/boot/dts/socionext/uniphier-ld20.dtsi
index a87b8a678719..8f2c1c1e2c64 100644
--- a/arch/arm64/boot/dts/socionext/uniphier-ld20.dtsi
+++ b/arch/arm64/boot/dts/socionext/uniphier-ld20.dtsi
@@ -734,7 +734,7 @@
 			clocks = <&sys_clk 6>;
 			reset-names = "ether";
 			resets = <&sys_rst 6>;
-			phy-mode = "rgmii";
+			phy-mode = "rgmii-id";
 			local-mac-address = [00 00 00 00 00 00];
 			socionext,syscon-phy-mode = <&soc_glue 0>;
 
diff --git a/arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi b/arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi
index 0e52dadf54b3..be97da132258 100644
--- a/arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi
+++ b/arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi
@@ -564,7 +564,7 @@
 			clocks = <&sys_clk 6>;
 			reset-names = "ether";
 			resets = <&sys_rst 6>;
-			phy-mode = "rgmii";
+			phy-mode = "rgmii-id";
 			local-mac-address = [00 00 00 00 00 00];
 			socionext,syscon-phy-mode = <&soc_glue 0>;
 
@@ -585,7 +585,7 @@
 			clocks = <&sys_clk 7>;
 			reset-names = "ether";
 			resets = <&sys_rst 7>;
-			phy-mode = "rgmii";
+			phy-mode = "rgmii-id";
 			local-mac-address = [00 00 00 00 00 00];
 			socionext,syscon-phy-mode = <&soc_glue 1>;
 
-- 
2.30.2



