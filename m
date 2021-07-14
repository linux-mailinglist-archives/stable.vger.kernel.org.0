Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0B03C8C5B
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhGNTlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231922AbhGNTlk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:41:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79CEF61370;
        Wed, 14 Jul 2021 19:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291528;
        bh=RxU1pXfrgyFerT2YD9jVlKnFWUqieyhdT0/pHAltVWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3pf6Zd2fCiC8O7Cpy7PuFPFUAAMDc+R8lcgqey0qpJgnyYe7mp0OhNc/lA4iqGL7
         RNx+g1n2OCKLuA9pbZe1zKNOr9t+7UGRH/IyAqFrc1gO72n3TWNj0p/WdRnkTpTHlD
         ZaqEAVIn0fAkvJa/3ZFP7Dh869WqSE8oRFHB6MdYJvP4zkL0AJxgjYa6Yt0f8Ad5vc
         S8vUo5ysgA+94/WUA1U0LCeuw/IGuDf3nhqFwRFBEVZdblntsXKATp/NYVx6kxIy5A
         VsKYIGpQWmBpW3/Dq+Lujc7PujNY4Nw6CEZ/WIqryZ0XRk/RClA2cswj5MilEJ4S4w
         sinGwtd8cGQdw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 032/108] ARM: dts: ux500: Fix orientation of accelerometer
Date:   Wed, 14 Jul 2021 15:36:44 -0400
Message-Id: <20210714193800.52097-32-sashal@kernel.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 4beba4011995a2c44ee27e1d358dc32e6b9211b3 ]

This adds a mounting matrix to the accelerometer
on the TVK1281618 R3.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi b/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi
index 70f058352efc..511e097cc33e 100644
--- a/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi
+++ b/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi
@@ -89,6 +89,9 @@ accelerometer@19 {
 					     <19 IRQ_TYPE_EDGE_RISING>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&accel_tvk_mode>;
+				mount-matrix = "0", "-1", "0",
+					       "-1", "0", "0",
+					       "0", "0", "-1";
 			};
 			magnetometer@1e {
 				compatible = "st,lsm303dlm-magn";
-- 
2.30.2

