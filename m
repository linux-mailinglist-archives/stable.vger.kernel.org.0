Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C139F364C45
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242897AbhDSUuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241982AbhDSUsO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:48:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62CE8613EA;
        Mon, 19 Apr 2021 20:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865142;
        bh=oUTiTeBTmouvEPFGR+1PMxjEwPUKb3rrkFwv+6AUChw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tAqEOFu+JYChTFOUr1Hk/+iqKkmH5tbKqohUjPCoDrg0GaWilK1vmFt8UzknhPsNK
         pqlGGJOTU74Vn994NJ4iSja7JOiAzhJk0sdfZg9SsP445jOKoWnP/Z5N5DAq94zvAI
         7fnQ+DbQHsmuVCi5AeOjtK3ey3QAkhIuT5s/lW+3CZjjDtUY25pUBDXozMWwcQPdUF
         M1i/VdAfu9Wg2I6ukWqhlOeN2Gj+rZ8dlwRJ6NZgw6FHmDr78exKxda+Rv3abWhSR+
         XEW721GEl5CZJQkNUVskU9Vm63GLN52qETG6qoI6Y9TM4ieoCRRyHhXY7VAfvUcugV
         PRxZ9XMyiWjVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 03/11] ARM: dts: Fix swapped mmc order for omap3
Date:   Mon, 19 Apr 2021 16:45:28 -0400
Message-Id: <20210419204536.6924-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204536.6924-1-sashal@kernel.org>
References: <20210419204536.6924-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit a1ebdb3741993f853865d1bd8f77881916ad53a7 ]

Also some omap3 devices like n900 seem to have eMMC and micro-sd swapped
around with commit 21b2cec61c04 ("mmc: Set PROBE_PREFER_ASYNCHRONOUS for
drivers that existed in v4.4").

Let's fix the issue with aliases as discussed on the mailing lists. While
the mmc aliases should be board specific, let's first fix the issue with
minimal changes.

Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap3.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index bdaf30c8c405..21eef1679d08 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -23,6 +23,9 @@ aliases {
 		i2c0 = &i2c1;
 		i2c1 = &i2c2;
 		i2c2 = &i2c3;
+		mmc0 = &mmc1;
+		mmc1 = &mmc2;
+		mmc2 = &mmc3;
 		serial0 = &uart1;
 		serial1 = &uart2;
 		serial2 = &uart3;
-- 
2.30.2

