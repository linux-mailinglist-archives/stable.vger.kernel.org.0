Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A213C8E00
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237167AbhGNTqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:46:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237171AbhGNTpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:45:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AF3461403;
        Wed, 14 Jul 2021 19:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291719;
        bh=LFVEaR1xtWQYNqrkRBhh8fCD7glKGjkVyuQOUnkJZvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQXo7Djzdl+8aDSgMhk9OfeZetQEDXPJsHxmgRDOZ5R5gvzxNRua0pMYZU3M5xXYC
         seBMsP49N0dxbuOue3IsgB3nHK52kQylPvE4We4o37iDIZGRN2DRjy7yXJ3kJoxmFS
         L9cwzYP19Qb20bEyBE+QKK9gg4MvAqK3HwBqxS5cVL92ODDUHX4nZljs/um51UY0PT
         nETqbrKSPr08Rh66pdoEYwJTkwz4RIaElYkFaLL1tLnPDJs824ToF3j1sk0XNRBy3n
         LK46pcqiH+5YGgmMMbrAN3UBFEBQGNEaeTadJR6RWfcPV5D8NXR5t4eFUw2VeyjQMH
         FW8PkMATp0SQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 059/102] ARM: dts: stm32: fix RCC node name on stm32f429 MCU
Date:   Wed, 14 Jul 2021 15:39:52 -0400
Message-Id: <20210714194036.53141-59-sashal@kernel.org>
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

From: Alexandre Torgue <alexandre.torgue@foss.st.com>

[ Upstream commit e4b948415a89a219d13e454011cdcf9e63ecc529 ]

This prevent warning observed with "make dtbs_check W=1"

Warning (simple_bus_reg): /soc/rcc@40023810: simple-bus unit address format
error, expected "40023800"

Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32f429.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32f429.dtsi b/arch/arm/boot/dts/stm32f429.dtsi
index f6530d724d00..41e0087bdbf9 100644
--- a/arch/arm/boot/dts/stm32f429.dtsi
+++ b/arch/arm/boot/dts/stm32f429.dtsi
@@ -709,7 +709,7 @@ crc: crc@40023000 {
 			status = "disabled";
 		};
 
-		rcc: rcc@40023810 {
+		rcc: rcc@40023800 {
 			#reset-cells = <1>;
 			#clock-cells = <2>;
 			compatible = "st,stm32f42xx-rcc", "st,stm32-rcc";
-- 
2.30.2

