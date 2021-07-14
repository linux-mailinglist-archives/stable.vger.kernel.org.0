Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295293C9058
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241447AbhGNTyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:54:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241165AbhGNTuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5BAE613F0;
        Wed, 14 Jul 2021 19:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292026;
        bh=CNuEaQCmb4bVkEAtz8mCGDynVJ90OcZXO7bRNRVHUew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mACD6XUGh1hHYFUo6ShaoaBxnnKI02pfURVFGgD3y34vbD/h9GVeXwTK1DF2vxdLd
         qIsUTFJV2OQZYlameHKLHkvSgYW2Skqb+fbiuS4/Wa0VPJFj4lHxaMy6UvGnL1mFuG
         9/xTymWcXKgs1Io+NtKR6snyTZ3iil1WtnaSbueeek91r2onN5dL/vPvn6PV5LuSVg
         sUjxyrgQj+FtBHi9YaN9mlzRaK3rQt6+vqEdOPdtZpN1wsrW9l564K7HuAjpcnW7q/
         Ibh61BVu0nUQFW2HvAeby+jDqHF5Kg+/oOisItcvxI7FtCyeU8qiA34XDrH5hZJnUu
         MHE2kysF3+CVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 28/39] ARM: dts: stm32: fix i2c node name on stm32f746 to prevent warnings
Date:   Wed, 14 Jul 2021 15:46:13 -0400
Message-Id: <20210714194625.55303-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194625.55303-1-sashal@kernel.org>
References: <20210714194625.55303-1-sashal@kernel.org>
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
index ccd87e833049..be62d9091e03 100644
--- a/arch/arm/boot/dts/stm32f746.dtsi
+++ b/arch/arm/boot/dts/stm32f746.dtsi
@@ -353,9 +353,9 @@ i2c2: i2c@40005800 {
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

