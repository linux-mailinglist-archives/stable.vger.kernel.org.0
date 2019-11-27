Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A76F810BF3C
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbfK0Ukh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:40:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbfK0Ukg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:40:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C71D20863;
        Wed, 27 Nov 2019 20:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887236;
        bh=X93YxrL4e1zQIw8m5y0o6WIOY4hS2G+mT0DqMqffEj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gKH0AncnWW5ix0/vVvfKDgrhflscdQQVXHI7MCAWpX850Q32VWYHgXJXY+DR/jBmv
         min7+6EL0/l9RTcbEkZEKHhWOM2u2S4dwtNRxFL9HGTRe10DWVRKNPQIRab4yKTjJ0
         ozdnyywFhCkCLn6UEThnhF8qNA0J9NyNInNE8sZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 033/151] clk: mmp2: fix the clock id for sdh2_clk and sdh3_clk
Date:   Wed, 27 Nov 2019 21:30:16 +0100
Message-Id: <20191127203020.869830028@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9adaf48aea231..061a9f10218b3 100644
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



