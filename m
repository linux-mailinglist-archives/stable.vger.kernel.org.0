Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF923C9002
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240655AbhGNTxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240790AbhGNTuF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7135613D9;
        Wed, 14 Jul 2021 19:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291963;
        bh=nG1mHoVKB7GDuXbwFhRAqAY4A8bWHVWSz5k1Uq7o26g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iRiFeQU55HPuj/IjadjOGmrjkN6AsvCRDXUOnCYWhnfJ3b5L+6z3fNFee9qbfUR+3
         8nI/isjtZ2bXidEqE3nFGRAT2bJy0yuVXNdCUe8VjBe3yknhnkwkWA+W3xGAkaZphg
         o0GW4573lhLBcOGOi7xwbVWDQHT3aFXYp7tQ/Fj6PXRWPKlYhs7sBavgi/ssvv9a67
         oT7ja76T3AFXuwt1Dx4kg5uGUgdRFHyIjy5XT9T9o78oQiTKrbqVxloqQSOEjgg7F8
         /EJEg002AXb8anc1hu5+Rg7b0uqSBUG4c9mf3B7dvP2ufXPkU0EGtbSNjHMw6KjRk0
         Hf/U2P3jQsWOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 35/51] ARM: dts: stm32: fix i2c node name on stm32f746 to prevent warnings
Date:   Wed, 14 Jul 2021 15:44:57 -0400
Message-Id: <20210714194513.54827-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194513.54827-1-sashal@kernel.org>
References: <20210714194513.54827-1-sashal@kernel.org>
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
index 974dc71b2fe3..60680fcf8eb3 100644
--- a/arch/arm/boot/dts/stm32f746.dtsi
+++ b/arch/arm/boot/dts/stm32f746.dtsi
@@ -362,9 +362,9 @@ i2c2: i2c@40005800 {
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

