Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A403C90C3
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240734AbhGNT4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239436AbhGNTvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:51:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77C2C613D6;
        Wed, 14 Jul 2021 19:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292103;
        bh=QmZEeEmLfxQoRoE8qrvDu+yMerH+43fNrchKN6qiIFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IncjXrDMV6Nc5l8zbJZvrug0c4BTGB20r9Un0RLzu71sh1SDrGbe6D/lbjujwYDAv
         tw3h7zEIivF2zWHELsQ1ngQbmY7T//Sw4it4rGZZ5fSazzO/qYZKXPSVBzoTtn/v/Z
         8nUz7vAoYCPZeuCiHzcQ1+CikP6vtftvTwZqnOVIW/fmpaalShUa9nQGdVlN+wn0ZB
         0svmp1d5XhlHP7paj0PxU5/0z6WgV78Z0hjIs2QDMIO9MbEoMZ62cYgc0+Q/jSYWWB
         UoUMurpCfsLFnsynkbmVuwiG7JpkdD7tSs2TwfOizdMHKnyk7TqWw0mYKGfAqvK60g
         YUA4bg7ff2J7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 11/18] ARM: dts: stm32: fix RCC node name on stm32f429 MCU
Date:   Wed, 14 Jul 2021 15:47:59 -0400
Message-Id: <20210714194806.55962-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194806.55962-1-sashal@kernel.org>
References: <20210714194806.55962-1-sashal@kernel.org>
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
index 336ee4fb587d..64dc50afc385 100644
--- a/arch/arm/boot/dts/stm32f429.dtsi
+++ b/arch/arm/boot/dts/stm32f429.dtsi
@@ -334,7 +334,7 @@ pins {
 			};
 		};
 
-		rcc: rcc@40023810 {
+		rcc: rcc@40023800 {
 			#reset-cells = <1>;
 			#clock-cells = <2>;
 			compatible = "st,stm32f42xx-rcc", "st,stm32-rcc";
-- 
2.30.2

