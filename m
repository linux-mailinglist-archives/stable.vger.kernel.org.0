Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062093C8CE1
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235724AbhGNTnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:43:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234698AbhGNTmi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2B38613E6;
        Wed, 14 Jul 2021 19:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291585;
        bh=tMzPHTju6AOkWoFp5plTaNzOg9YQgcXIFkGYdveKVco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e438Ep6/GM6ReuuDb4UM18+jRrkzayLhbzUsXGMPOFTmvNPiZBck3TuMsGtIkQyhU
         sz5I8aMQG2+btPlU+Hnit4UbrGPw0RM+zC9RsZOA8qYrzwmCeD/H3vBrBN7X6YW1VE
         pr4ESl+W5RkeBYkzbB3sqSZmejfhwgRbNWcdWrPCv3HzGM9oEfvaVqexBnC5YSCyTK
         KdPz9J1rYQ/3hV9rKa0/HDEw6ynrV4uOgZH2isIyq36b30zrJWNRO0pT5ukgCh1rzX
         pDnudifLTmbjQR9ww2gP67F0j315S2yPLFdz4TUVPPtRa/2VnHWwBb5gPDHbzoIL1F
         q4RdkcI7X4USA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 072/108] ARM: dts: stm32: fix i2c node name on stm32f746 to prevent warnings
Date:   Wed, 14 Jul 2021 15:37:24 -0400
Message-Id: <20210714193800.52097-72-sashal@kernel.org>
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

[ Upstream commit ad0ed10ba5792064fc3accbf8f0341152a57eecb ]

Replace upper case by lower case in i2c nodes name.

Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32f746.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/stm32f746.dtsi b/arch/arm/boot/dts/stm32f746.dtsi
index 72c1b76684b6..014b416f57e6 100644
--- a/arch/arm/boot/dts/stm32f746.dtsi
+++ b/arch/arm/boot/dts/stm32f746.dtsi
@@ -360,9 +360,9 @@ i2c2: i2c@40005800 {
 			status = "disabled";
 		};
 
-		i2c3: i2c@40005C00 {
+		i2c3: i2c@40005c00 {
 			compatible = "st,stm32f7-i2c";
-			reg = <0x40005C00 0x400>;
+			reg = <0x40005c00 0x400>;
 			interrupts = <72>,
 				     <73>;
 			resets = <&rcc STM32F7_APB1_RESET(I2C3)>;
-- 
2.30.2

