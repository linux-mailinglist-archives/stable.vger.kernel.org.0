Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BA93C8F66
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239292AbhGNTwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239538AbhGNTtV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E341761413;
        Wed, 14 Jul 2021 19:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291860;
        bh=hhMjNeNPx+mxmkaM9RmGl98HXdTIgmucoSuFq0/OXqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTIcPIjod8L8Gv9zcYv80NSiNzUxpEZn2rRsyAgyn+44ZXorf7gKmIX61qnC/v4YW
         8hqzPOP3Gd9tdVj4Zv63XFqVWOT4lJ5U95B01q8+lH9Qe+sUDHhngnKhCUg6nGrwGR
         G7N13epjSo325y1SGw7APjrjk3xwNAU9lsU2TZ8cxXdhdForhP4wygyfaiR9cV2Mce
         YQ0b3RsYTD7OLzJJHf2QQprG+TIyuhUAvzItLpDeXi9jU1VcQI33n6aacI7ufADwMR
         1U9WDBbRZ+R2TFImAH0YO/X1Dv3HG6+aOxSYb+BMWKYwarBMwicHHFqMwNRsyeQMoJ
         DFzwCdNEC10Xw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 51/88] ARM: dts: stm32: fix RCC node name on stm32f429 MCU
Date:   Wed, 14 Jul 2021 15:42:26 -0400
Message-Id: <20210714194303.54028-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
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
index ad715a0e1c9a..9adccd4209fb 100644
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

