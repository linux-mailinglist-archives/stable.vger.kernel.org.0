Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05DB53D28CC
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbhGVP66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:58:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233207AbhGVP6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:58:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DBE061375;
        Thu, 22 Jul 2021 16:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971926;
        bh=3gzh3ZVg94BnuS8r/f+mIflG8bwxx3Sw5qAMigbrg4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JU6o5UqONc0Zlaevo1Kj4Jb8WrWUtU18LP5EbefyGKUAGvJ5ojyENHidrUNUDdj+F
         axGuaXHG6PwQnzdEQ0jIGoXCjuKASjavJ7DTQGZHcZRNAYFo8Oztk+PoqRQWcK/4oq
         haGQD/0R/ylE0h312zLYDxzRAvgv2/mYFpJIsIc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/125] ARM: dts: stm32: fix RCC node name on stm32f429 MCU
Date:   Thu, 22 Jul 2021 18:30:35 +0200
Message-Id: <20210722155626.165860736@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
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
index ad715a0e1c9a..9adccd4209fb 100644
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



