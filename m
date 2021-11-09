Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BA244B57D
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242232AbhKIWVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:21:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:40432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245575AbhKIWUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:20:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63EF56135E;
        Tue,  9 Nov 2021 22:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496250;
        bh=cu/bqtw9RWtPNA9V8zfU73kT1TMaVL2UnCG56a5XWpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZHyfI+uetEW3BCjDcMK8cZglEpieg+CizdUMyH0lp4B8RuKWvboaiopX7tvv11AXN
         hY5UvM2xzgKbYnxYwy78UJBr0mr0lQhWxDxVMagKwWMGO29dWCzuG4Ibr+kWPpLOs0
         Vtk+Vinc65JzgSXYThYhmJ+8yiT02ccTXYkS11mrudelA9vdNxgtvvmQ/hnOS0IJGY
         /MzRjLAP4suPcapuyaZpN8bW9H+3yC0e3UyZTxkPXYK33nY0ArkT5Y9no2uX0Nvldv
         5wn7xNcuGzGYH3HS/LyG49aEsVFd41cK14Stx6fkbz3UK1e5upNTM+fcMrgv/MRAm2
         LI9JdXxNwUQiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 23/82] ARM: dts: ux500: Skomer regulator fixes
Date:   Tue,  9 Nov 2021 17:15:41 -0500
Message-Id: <20211109221641.1233217-23-sashal@kernel.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 7aee0288beab72cdfa35af51f62e94373fca595d ]

AUX2 has slightly wrong voltage and AUX5 doesn't need to be
always on.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-ux500-samsung-skomer.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts b/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
index 264f3e9b5fce5..86e83639fadc1 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
@@ -292,10 +292,10 @@
 					};
 
 					ab8500_ldo_aux2 {
-						/* Supplies the Cypress TMA140 touchscreen only with 3.3V */
+						/* Supplies the Cypress TMA140 touchscreen only with 3.0V */
 						regulator-name = "AUX2";
-						regulator-min-microvolt = <3300000>;
-						regulator-max-microvolt = <3300000>;
+						regulator-min-microvolt = <3000000>;
+						regulator-max-microvolt = <3000000>;
 					};
 
 					ab8500_ldo_aux3 {
@@ -314,9 +314,9 @@
 
 					ab8500_ldo_aux5 {
 						regulator-name = "AUX5";
+						/* Intended for 1V8 for touchscreen but actually left unused */
 						regulator-min-microvolt = <1050000>;
 						regulator-max-microvolt = <2790000>;
-						regulator-always-on;
 					};
 
 					ab8500_ldo_aux6 {
-- 
2.33.0

