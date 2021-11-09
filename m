Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876D944B6AF
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236328AbhKIW3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:29:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344415AbhKIW01 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:26:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDA9661A53;
        Tue,  9 Nov 2021 22:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496385;
        bh=nE358nGDGr7KcK43TlL/FW4cfCEKyXOcwBJem4GhvV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbsqDSsti6W6UrMHyomg/zd6qSU5MhaY/m5XigvQ5KAAqIsmG2s6TZPOb9rkfAnS5
         Jo3SteIA5MOYAChKd6vEaVZa5SsMvFI3lypqclL7LAejxGOMekkgj+5LmX8SdNayR+
         e6HhzojhI5zoNawQC+inggLycszsyCldk7wwXgtLpuGaroG6J61PTkKA7mnSotgIHt
         ISbOlKofafNwytN20R2ybBGtzTsGvN0v/qmLtH1rKcJaI5rEMGS4fwV2sDbYkXC7gP
         v7HdKJ/IzGR2NOEtaQB1UZGwIp+lbSKivg2fKNlo4Tbdu5IVYVTaEe6KDeJiCIG0ew
         5qYVkJ/c6Z38w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 22/75] ARM: dts: ux500: Skomer regulator fixes
Date:   Tue,  9 Nov 2021 17:18:12 -0500
Message-Id: <20211109221905.1234094-22-sashal@kernel.org>
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
index 94afd7a0fe1f0..9a90e7bbb4673 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
@@ -290,10 +290,10 @@
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
@@ -312,9 +312,9 @@
 
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

