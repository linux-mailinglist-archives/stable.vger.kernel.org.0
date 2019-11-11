Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF4D6F6E84
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 07:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfKKGXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 01:23:05 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49225 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726205AbfKKGXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 01:23:05 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0D2DC2067B;
        Mon, 11 Nov 2019 01:23:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 11 Nov 2019 01:23:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=iE79xV
        07klu6f57kOQBFA19DrYCS8HsmIogNYsCgW2E=; b=A7DLo0eg96eVF0TLbWZJ8H
        Rz3j7ODfN8qfRV8u6wNqYwjlQpfaj59QNyf/Aczad8TvT8hSzlCR2/TFmK9jtTHD
        PO7MlWGXOc8c054VAclVlM+8qZQ8pManTD/Zg3bLISDHFRS3mLQvbV3xv/pXsmLA
        n7DMi3fiOb4LpgyGoV54Vk5iU2VyfA0wVEG6lR9XsV9fuGLJuSI2qIGWnChYldEV
        t2EAQ8PmXTNOY3q9Ym4atXmxODpvm/mvRYlwnSgZIlolPHpt06Pd9C+rUc9oYkmO
        SLteUscerbiSfanWsBnBet+P2sMZe7NaC/rj+fsGetHEZ3Akj+xR3gGnjfD7qQoQ
        ==
X-ME-Sender: <xms:R_7IXa3xLexDTxiC5naeatjRHtkHT83GhEPRJPxLZQVwelHr3yqp4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddviedgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:R_7IXTM_YjRPXnjkr8ouxb0RbuLMncqAVJTGg-ihIk2hi0SKv7gVpw>
    <xmx:R_7IXVkL_Ak_RniTFzSTuqAm6lXuBoiSaKTonTMxJrDoSV72JUGkvw>
    <xmx:R_7IXZrZ6aaf0xSYLCHlncJQieBL6a8Qq4QG9EdobPhitFzpbG59OQ>
    <xmx:R_7IXYcC18NQm5g5jSyVmifg1ynMochLah3xr5A3eg1KHpJkqh_yDA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 43A58306005C;
        Mon, 11 Nov 2019 01:23:03 -0500 (EST)
Subject: FAILED: patch "[PATCH] clk: imx8m: Use SYS_PLL1_800M as intermediate parent of" failed to apply to 5.3-stable tree
To:     leonard.crestez@nxp.com, sboyd@kernel.org, shawnguo@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Nov 2019 07:23:01 +0100
Message-ID: <157345338112980@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b234fe9558615098d8d62516e7041ad7f99ebcea Mon Sep 17 00:00:00 2001
From: Leonard Crestez <leonard.crestez@nxp.com>
Date: Tue, 22 Oct 2019 22:21:28 +0300
Subject: [PATCH] clk: imx8m: Use SYS_PLL1_800M as intermediate parent of
 CLK_ARM

During cpu frequency switching the main "CLK_ARM" is reparented to an
intermediate "step" clock. On imx8mm and imx8mn the 24M oscillator is
used for this purpose but it is extremely slow, increasing wakeup
latencies to the point that i2c transactions can timeout and system
becomes unresponsive.

Fix by switching the "step" clk to SYS_PLL1_800M, matching the behavior
of imx8m cpufreq drivers in imx vendor tree.

This bug was not immediately apparent because upstream arm64 defconfig
uses the "performance" governor by default so no cpufreq transitions
happen.

Fixes: ba5625c3e272 ("clk: imx: Add clock driver support for imx8mm")
Fixes: 96d6392b54db ("clk: imx: Add support for i.MX8MN clock driver")

Cc: stable@vger.kernel.org
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Link: https://lkml.kernel.org/r/f5d2b9c53f1ed5ccb1dd3c6624f56759d92e1689.1571771777.git.leonard.crestez@nxp.com
Acked-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>

diff --git a/drivers/clk/imx/clk-imx8mm.c b/drivers/clk/imx/clk-imx8mm.c
index 067ab876911d..172589e94f60 100644
--- a/drivers/clk/imx/clk-imx8mm.c
+++ b/drivers/clk/imx/clk-imx8mm.c
@@ -638,7 +638,7 @@ static int imx8mm_clocks_probe(struct platform_device *pdev)
 					   clks[IMX8MM_CLK_A53_DIV],
 					   clks[IMX8MM_CLK_A53_SRC],
 					   clks[IMX8MM_ARM_PLL_OUT],
-					   clks[IMX8MM_CLK_24M]);
+					   clks[IMX8MM_SYS_PLL1_800M]);
 
 	imx_check_clocks(clks, ARRAY_SIZE(clks));
 
diff --git a/drivers/clk/imx/clk-imx8mn.c b/drivers/clk/imx/clk-imx8mn.c
index 47a4b44ba3cb..58b5acee3830 100644
--- a/drivers/clk/imx/clk-imx8mn.c
+++ b/drivers/clk/imx/clk-imx8mn.c
@@ -610,7 +610,7 @@ static int imx8mn_clocks_probe(struct platform_device *pdev)
 					   clks[IMX8MN_CLK_A53_DIV],
 					   clks[IMX8MN_CLK_A53_SRC],
 					   clks[IMX8MN_ARM_PLL_OUT],
-					   clks[IMX8MN_CLK_24M]);
+					   clks[IMX8MN_SYS_PLL1_800M]);
 
 	imx_check_clocks(clks, ARRAY_SIZE(clks));
 

