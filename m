Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138C63D2994
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbhGVQFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234188AbhGVQE1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:04:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A7F461C1C;
        Thu, 22 Jul 2021 16:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972280;
        bh=3JlmCt9jm1vR3Nu9MHMDjtOhkX2cr6kiI1C1G7RAm8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o+5x+GFLY+sY2BT2NSsQK4QqP9zuUq9hCI39BIJwn8ItNFZsCwpy+Ml4uUlLdbA02
         MolzuDLxzZwVVuzp0yjWBBBQt4b1Cr8fVzwZCbwFZoocYfSWr2Uz5G0WL5yx5oM/ws
         Vjb16n5evbpjXeW2VvPc0mFKyD0R6fLPNjHHe+3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 054/156] ARM: dts: stm32: fix RCC node name on stm32f429 MCU
Date:   Thu, 22 Jul 2021 18:30:29 +0200
Message-Id: <20210722155630.156577504@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -709,7 +709,7 @@
 			status = "disabled";
 		};
 
-		rcc: rcc@40023810 {
+		rcc: rcc@40023800 {
 			#reset-cells = <1>;
 			#clock-cells = <2>;
 			compatible = "st,stm32f42xx-rcc", "st,stm32-rcc";
-- 
2.30.2



