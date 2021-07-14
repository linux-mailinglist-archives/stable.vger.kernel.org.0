Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA233C8DA6
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbhGNTpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235345AbhGNTov (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:44:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5BC560FF2;
        Wed, 14 Jul 2021 19:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291686;
        bh=gb5qiyJTAoL63FfxiDqBzs1HB5t2AsnKTXYpi6hvIGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNp2jP7qE3jEXp1RITUDN15c9Qbjcrf3iPZLYFjpq0aQt9g67nDZ8cy5Eq7+IVFhF
         Ax89NUGykG3EcYuSPVQXKs7QmZnB8BSL/BymfnABJsCD1zqHcBO+DqC1n6EE1Pin1f
         55ZsYhW/V7HVSGREgLhyOzHJcz5xAZ+Bw5SOr2TyAB/q1IR5FtrlYUcuN7JnquetSI
         4ss5B97NPithsVdQHEDLuqV4uZtfGyngdfJf9Ait206/zPQMrIlkHqt4k7SsIdD1gu
         Nel4HtaZAEr7NVBB12xL00YLRYLH7PKnnfP1U5NKqzzpt2SW2sHIORiDR5aV/zsn6K
         dBz2UV5cGU4vQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 035/102] ARM: dts: ux500: Fix orientation of Janice accelerometer
Date:   Wed, 14 Jul 2021 15:39:28 -0400
Message-Id: <20210714194036.53141-35-sashal@kernel.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit e409c1e1d5cb164361229e3a3f084e4a32544fb6 ]

This fixes up the axis on the Janice accelerometer to give
the right orientation according to tests.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-ux500-samsung-janice.dts | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/ste-ux500-samsung-janice.dts b/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
index 382f4af08a68..95db996bd207 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
@@ -593,10 +593,9 @@ i2c-gate {
 					accelerometer@08 {
 						compatible = "bosch,bma222";
 						reg = <0x08>;
-						/* FIXME: no idea about this */
-						mount-matrix = "1", "0", "0",
-							       "0", "1", "0",
-							       "0", "0", "1";
+						mount-matrix = "0", "1", "0",
+							       "-1", "0", "0",
+							       "0", "0", "-1";
 						vddio-supply = <&ab8500_ldo_aux2_reg>; // 1.8V
 						vdd-supply = <&ab8500_ldo_aux1_reg>; // 3V
 					};
-- 
2.30.2

