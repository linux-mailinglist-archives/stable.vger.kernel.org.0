Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B9D44B6D2
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344259AbhKIWaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:30:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344343AbhKIW2Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:28:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86BDF61A62;
        Tue,  9 Nov 2021 22:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496415;
        bh=dTPb2kXkqqZHHUU/5EsT1jSVWNxZwUWDpuzJjesggv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lS2aWdLUKEDquagz6aqXdGF1NGywLTj+QPRtpeewc8+0i1XGlAJvRvas7OV4bh9q/
         uGqUjRHToY3Vt+rmnBQxJJMXOb5ByeiB0NLnvWaJhe5ToORa6D9ksiqRxGTTaOIpWw
         Hc+L/O1M1J904VNB+NFejCDMgEl/m95Oq2FA3q9mLAs4aMDwjDrORQSY9nYISsbRFI
         3aBTIuJWGaPyPXkfHhiiYqSUuk3CsaxrM6626LHy+hP3DRFuzT4/kjYjbyITNCEh4y
         1alTKPuZK6577WBERjumevwo5QnsZqrbZskP9uwtLWIB0xML3kcYlPfDNbM8onvNjb
         RKYB1l8rdNlFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frieder Schrempf <frieder.schrempf@kontron.de>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 42/75] arm64: dts: imx8mm-kontron: Fix reset delays for ethernet PHY
Date:   Tue,  9 Nov 2021 17:18:32 -0500
Message-Id: <20211109221905.1234094-42-sashal@kernel.org>
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

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit 315e7b884190a6c9c28e95ad3b724dde9e922b99 ]

According to the datasheet the VSC8531 PHY expects a reset pulse of 100 ns
and a delay of 15 ms after the reset has been deasserted. Set the matching
values in the devicetree.

Reported-by: Heiko Thiery <heiko.thiery@gmail.com>
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
index e99e7644ff392..49d7470812eef 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
@@ -123,8 +123,8 @@
 
 		ethphy: ethernet-phy@0 {
 			reg = <0>;
-			reset-assert-us = <100>;
-			reset-deassert-us = <100>;
+			reset-assert-us = <1>;
+			reset-deassert-us = <15000>;
 			reset-gpios = <&gpio4 27 GPIO_ACTIVE_LOW>;
 		};
 	};
-- 
2.33.0

