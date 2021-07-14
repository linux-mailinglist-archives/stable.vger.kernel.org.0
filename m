Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5E83C8CC7
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235311AbhGNTmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234515AbhGNTmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8037C60FF2;
        Wed, 14 Jul 2021 19:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291569;
        bh=LFVEaR1xtWQYNqrkRBhh8fCD7glKGjkVyuQOUnkJZvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cz/bcs5apz0X7EKvOHtYmwHFWQp7R4ueDxz3OKErxPSx9yLf7ON8oY5Y/fkLjYTGu
         CkYXSCXSUypXNYjHdDD+yCIJFFebS21rW+ZZPrR0V6AwwcQRdNZ11vNi3nP17eOFsa
         Opj+zV3wmDpTMCaKjJCTmCrJp4e/Ft6nBLz1pQ0Z374tqbTbCXDUcbWz8TnboxhlD2
         DALKUuJ7cb8y5F1Q7Rv/8tnL8mWvAxfSGf5KCJWuwBQoVZfSYSMuL/kMdvHd1lTv2r
         sGolSDrThd2OvH7Udh5jyQHAmQLMuZDswwFluKUW59KQFnuSTm/VYDAuZ9NmGv4b7E
         dMeT05i2+wLJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 061/108] ARM: dts: stm32: fix RCC node name on stm32f429 MCU
Date:   Wed, 14 Jul 2021 15:37:13 -0400
Message-Id: <20210714193800.52097-61-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
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

