Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4AD56FCB0
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiGKJq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233277AbiGKJpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:45:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2876A5A459;
        Mon, 11 Jul 2022 02:22:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA6F6B80D2C;
        Mon, 11 Jul 2022 09:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C03C341C0;
        Mon, 11 Jul 2022 09:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531360;
        bh=ZRKOWlgp3/1UmGe8prm69u5KOFkQi/fYa9/rSwmn2Nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJWP9/ECfT7CYL9yPwAzA5xj6i+u66CeNXd92EzVfcii4/SoLUtvMDRctLNUnWhDH
         EaiT/KD23P2ZuuwhjP65O08iTZIg9PivdStlY0q+9frxt5Do+zR6abFpTTBbvdpw73
         AkmRTiwAwfi2yS9roXiE2+czf6N8qDbe9EwtMJmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/230] clk: renesas: r9a07g044: Update multiplier and divider values for PLL2/3
Date:   Mon, 11 Jul 2022 11:05:32 +0200
Message-Id: <20220711090606.232816891@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit b289cdecc7c3e25e001cde260c882e4d9a8b0772 ]

As per the HW manual (Rev.1.00 Sep, 2021) PLL2 and PLL3 should be
1600 MHz, but with current multiplier and divider values this resulted
to 1596 MHz.

This patch updates the multiplier and divider values for PLL2 and PLL3
so that we get the exact (1600 MHz) values.

Fixes: 17f0ff3d49ff1 ("clk: renesas: Add support for R9A07G044 SoC")
Suggested-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/r/20211223093223.4725-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r9a07g044-cpg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/renesas/r9a07g044-cpg.c b/drivers/clk/renesas/r9a07g044-cpg.c
index 1490446985e2..61609eddf7d0 100644
--- a/drivers/clk/renesas/r9a07g044-cpg.c
+++ b/drivers/clk/renesas/r9a07g044-cpg.c
@@ -61,8 +61,8 @@ static const struct cpg_core_clk r9a07g044_core_clks[] __initconst = {
 	DEF_FIXED(".osc", R9A07G044_OSCCLK, CLK_EXTAL, 1, 1),
 	DEF_FIXED(".osc_div1000", CLK_OSC_DIV1000, CLK_EXTAL, 1, 1000),
 	DEF_SAMPLL(".pll1", CLK_PLL1, CLK_EXTAL, PLL146_CONF(0)),
-	DEF_FIXED(".pll2", CLK_PLL2, CLK_EXTAL, 133, 2),
-	DEF_FIXED(".pll3", CLK_PLL3, CLK_EXTAL, 133, 2),
+	DEF_FIXED(".pll2", CLK_PLL2, CLK_EXTAL, 200, 3),
+	DEF_FIXED(".pll3", CLK_PLL3, CLK_EXTAL, 200, 3),
 
 	DEF_FIXED(".pll2_div2", CLK_PLL2_DIV2, CLK_PLL2, 1, 2),
 	DEF_FIXED(".pll2_div16", CLK_PLL2_DIV16, CLK_PLL2, 1, 16),
-- 
2.35.1



