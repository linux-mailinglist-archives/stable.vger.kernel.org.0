Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B45CD13F19E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390691AbgAPS3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:29:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391692AbgAPRZ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:25:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 470262081E;
        Thu, 16 Jan 2020 17:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195557;
        bh=gRRExTBOxk0GsxlIZLGBj4g129fbjoNxN9f9p6V1jf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIw9quMUrsYu60LMElBVp9AFIOVhfzd5qKA+hmmkqFG2OPqT08eV2iOKiF2Iy6M8w
         7XwX+RzyIFjXAsmW6Fy4rGOWjt4anyLdcspXhYPiHfYWTwuhLV7b5WqJJOl/JtrsPP
         f81Y9/ocjBneqNobVbNXGQNoEqhWQCRI9csIClq4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 145/371] arm64: dts: allwinner: a64: Add missing PIO clocks
Date:   Thu, 16 Jan 2020 12:20:17 -0500
Message-Id: <20200116172403.18149-88-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime.ripard@bootlin.com>

[ Upstream commit 562bf19611c000cb7219431c3cc78aa60c2b371e ]

The pinctrl binding mandates that we have the three clocks fed into the PIO
described.

Even though the old case is still supported for backward compatibility, we
should update our DTs to fix this.

Fixes: 6bc37fac30cf ("arm64: dts: add Allwinner A64 SoC .dtsi")
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
index 8c8db1b057df..788a6f8c5994 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -274,7 +274,8 @@
 			interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&ccu 58>;
+			clocks = <&ccu 58>, <&osc24M>, <&rtc 0>;
+			clock-names = "apb", "hosc", "losc";
 			gpio-controller;
 			#gpio-cells = <3>;
 			interrupt-controller;
-- 
2.20.1

