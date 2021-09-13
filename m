Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D90408D41
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241074AbhIMNYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:24:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240771AbhIMNWv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:22:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6799E610E7;
        Mon, 13 Sep 2021 13:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631539270;
        bh=emI3vMGMyN0xMydV4DqKx+lv5q0NpfntR+OHbZIe8dw=;
        h=From:To:Cc:Subject:Date:From;
        b=RNEuWyq5+B07J7SdqMvLqf9rEubZ3YwoLrrn3PsZFr2DNXY85HGcvxd0Pfxp4v2wE
         wkie/x57Oeo4E1epuf6Eb/M64JyuowwlTKe5CiaWBjDnFsYdVoMxYD8gWAlM7GaWaX
         kqeU5hOcGO1h1AcV4InoFEY4Mxf758e2ga/MVpCzr37WsXFWofDQdVydvI4c3Pk5bK
         +7J5YSU/N1CSdgcwMAZuZATwPu2MIo5NpPAoXod+Uokcgef2tFCn2BmPjA7JRAE1sL
         yYBWO7ArI9gzacqnFdDeXILj2eK9rYoajrkUN4tmd5CAtUyHnitZkmyFvb3r9dxkc+
         /XOFHaRsG4/nA==
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     sboyd@kernel.org
Cc:     dinguyen@kernel.org, mturquette@baylibre.com,
        linux-clk@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] clk: socfpga: agilex: fix duplicate s2f_user0_clk
Date:   Mon, 13 Sep 2021 08:21:02 -0500
Message-Id: <20210913132102.883361-1-dinguyen@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Remove the duplicate s2f_user0_clk.

Fixes: f817c132db67 ("clk: socfpga: agilex: fix up s2f_user0_clk
representation")
Cc: stable@vger.kernel.org
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 drivers/clk/socfpga/clk-agilex.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/clk/socfpga/clk-agilex.c b/drivers/clk/socfpga/clk-agilex.c
index 242e94c0cf8a..b4d300fbbc66 100644
--- a/drivers/clk/socfpga/clk-agilex.c
+++ b/drivers/clk/socfpga/clk-agilex.c
@@ -312,8 +312,6 @@ static const struct stratix10_gate_clock agilex_gate_clks[] = {
 	  4, 0x44, 28, 1, 0, 0, 0},
 	{ AGILEX_CS_TIMER_CLK, "cs_timer_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux), 0, 0x24,
 	  5, 0, 0, 0, 0x30, 1, 0},
-	{ AGILEX_S2F_USER0_CLK, "s2f_user0_clk", NULL, s2f_usr0_mux, ARRAY_SIZE(s2f_usr0_mux), 0, 0x24,
-	  6, 0, 0, 0, 0, 0, 0},
 	{ AGILEX_EMAC0_CLK, "emac0_clk", NULL, emac_mux, ARRAY_SIZE(emac_mux), 0, 0x7C,
 	  0, 0, 0, 0, 0x94, 26, 0},
 	{ AGILEX_EMAC1_CLK, "emac1_clk", NULL, emac_mux, ARRAY_SIZE(emac_mux), 0, 0x7C,
-- 
2.25.1

