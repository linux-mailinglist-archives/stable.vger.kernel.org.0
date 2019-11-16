Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE523FEF7B
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731370AbfKPPyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:54:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:35394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731366AbfKPPyA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:54:00 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 133F92184B;
        Sat, 16 Nov 2019 15:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919640;
        bh=QCIZeCkQ0r6C4cbohp8AQg8/ULaLDHBUimyrxqpfD38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u4dhYnPrwm08RwkUc7RiSuhd9xgZcnzUr7jc+6UOuxdQwBAn2r5I/cwd4vdwHlWmI
         LeEzb3KhXfRqPBCq7yju1RRYr9jjsURm+/v4on+4mtvpSNiP3LztBFmeuAw/S9oEs2
         MLMafF9BwDxE2wWk8PyCScdXmarFjdpPOAWJz6y8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lubomir Rintel <lkundrak@v3.sk>, Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 19/77] clk: mmp2: fix the clock id for sdh2_clk and sdh3_clk
Date:   Sat, 16 Nov 2019 10:52:41 -0500
Message-Id: <20191116155339.11909-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155339.11909-1-sashal@kernel.org>
References: <20191116155339.11909-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lubomir Rintel <lkundrak@v3.sk>

[ Upstream commit 4917fb90eec7c26dac1497ada3bd4a325f670fcc ]

A typo that makes it impossible to get the correct clocks for
MMP2_CLK_SDH2 and MMP2_CLK_SDH3.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Fixes: 1ec770d92a62 ("clk: mmp: add mmp2 DT support for clock driver")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mmp/clk-of-mmp2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/mmp/clk-of-mmp2.c b/drivers/clk/mmp/clk-of-mmp2.c
index f261b1d292c74..8b45cb2caed1b 100644
--- a/drivers/clk/mmp/clk-of-mmp2.c
+++ b/drivers/clk/mmp/clk-of-mmp2.c
@@ -227,8 +227,8 @@ static struct mmp_param_gate_clk apmu_gate_clks[] = {
 	/* The gate clocks has mux parent. */
 	{MMP2_CLK_SDH0, "sdh0_clk", "sdh_mix_clk", CLK_SET_RATE_PARENT, APMU_SDH0, 0x1b, 0x1b, 0x0, 0, &sdh_lock},
 	{MMP2_CLK_SDH1, "sdh1_clk", "sdh_mix_clk", CLK_SET_RATE_PARENT, APMU_SDH1, 0x1b, 0x1b, 0x0, 0, &sdh_lock},
-	{MMP2_CLK_SDH1, "sdh2_clk", "sdh_mix_clk", CLK_SET_RATE_PARENT, APMU_SDH2, 0x1b, 0x1b, 0x0, 0, &sdh_lock},
-	{MMP2_CLK_SDH1, "sdh3_clk", "sdh_mix_clk", CLK_SET_RATE_PARENT, APMU_SDH3, 0x1b, 0x1b, 0x0, 0, &sdh_lock},
+	{MMP2_CLK_SDH2, "sdh2_clk", "sdh_mix_clk", CLK_SET_RATE_PARENT, APMU_SDH2, 0x1b, 0x1b, 0x0, 0, &sdh_lock},
+	{MMP2_CLK_SDH3, "sdh3_clk", "sdh_mix_clk", CLK_SET_RATE_PARENT, APMU_SDH3, 0x1b, 0x1b, 0x0, 0, &sdh_lock},
 	{MMP2_CLK_DISP0, "disp0_clk", "disp0_div", CLK_SET_RATE_PARENT, APMU_DISP0, 0x1b, 0x1b, 0x0, 0, &disp0_lock},
 	{MMP2_CLK_DISP0_SPHY, "disp0_sphy_clk", "disp0_sphy_div", CLK_SET_RATE_PARENT, APMU_DISP0, 0x1024, 0x1024, 0x0, 0, &disp0_lock},
 	{MMP2_CLK_DISP1, "disp1_clk", "disp1_div", CLK_SET_RATE_PARENT, APMU_DISP1, 0x1b, 0x1b, 0x0, 0, &disp1_lock},
-- 
2.20.1

