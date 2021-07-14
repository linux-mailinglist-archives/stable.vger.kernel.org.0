Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452723C8C60
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhGNTlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233889AbhGNTlo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:41:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 445F8613D0;
        Wed, 14 Jul 2021 19:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291532;
        bh=Xqm3V5AtxhUsIjIu3F59Y1o7AfocRBgBIMh/YO06G8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6m1HTi2veuVbeznoq97ODnLXQbr5dJZaOxU/w0Vn2t+4Q0uXFfprEJexQGKj4qpg
         bCeX3jVGiyujSOyqGKUlRZNlD5tov/z/nj/dd3VG+mohpAqdrixj6MP7CkDDqu+19T
         7G0ThARchTqx/doIY3Rg2lbft9jsjbQyqRQOlnS4A6ZOe2MrB+WTmKfJIGkHNKEqmn
         Osaf514B9YALrT+wbON+TvxSfFlBNHaF21s3Zb4q92NJ3+1+z45HNkKRje7Wc2KVul
         9SSkLaCJKcFk7oe//uUBN5jpGGOVT8z1sxOWDEMql56ICLVN+3BxyIK6ZIXFTEkp3P
         x5tfGwlmbqW6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 035/108] ARM: dts: ux500: Fix orientation of Janice accelerometer
Date:   Wed, 14 Jul 2021 15:36:47 -0400
Message-Id: <20210714193800.52097-35-sashal@kernel.org>
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

[ Upstream commit e409c1e1d5cb164361229e3a3f084e4a32544fb6 ]

This fixes up the axis on the Janice accelerometer to give
the right orientation according to tests.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-ux500-samsung-janice.dts | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/ste-ux500-samsung-janice.dts b/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
index eaf8039d10ad..25af066f6f3a 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
@@ -583,10 +583,9 @@ i2c-gate {
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

