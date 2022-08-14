Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3A759225F
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241517AbiHNPrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241887AbiHNPqf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:46:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040F327CC0;
        Sun, 14 Aug 2022 08:35:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8086760DE6;
        Sun, 14 Aug 2022 15:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF77C43140;
        Sun, 14 Aug 2022 15:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491300;
        bh=z24/BARLJ//SDqxiofAV43yx4a8PcW9v68+Ar14AMV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMISJmH1bRsczmpIYSmp4R/x0SoxKgXOqFPNpugLhX9I9pqBsCHQoo2/kQGjjJGob
         +W1XJAwayB6hm5T/AoOpi+d9x+xRgeCDXV/kQGNMZhtIoZ015oA2n2Tnpt3aquHvoT
         uwmHX2QU3flYzQNINryu/q7NxK3osQnsg6bL4IE9RoFpTx3eEWjYiSze6LOLqx8Zd4
         M1e4uCRWyWV6qli0vonRaVRBUOQHeCznH5njYyCs6Hz26v073zowbUQOlRi0Sw+TLj
         WGS4osTcG+wkMKKZzkzN3sMBr0Rhp6TgnRBSv07aG5ANZcGa1bVWqL8TXaN9UO61z3
         UrB0G84Mi1T7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        mturquette@baylibre.com, linux-arm-msm@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 15/31] clk: qcom: clk-alpha-pll: fix clk_trion_pll_configure description
Date:   Sun, 14 Aug 2022 11:34:15 -0400
Message-Id: <20220814153431.2379231-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153431.2379231-1-sashal@kernel.org>
References: <20220814153431.2379231-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit 94bed9bb05c7850ff5d80b87cc29004901f37956 ]

After merging lucid and trion pll functions in commit 0b01489475c6
("clk: qcom: clk-alpha-pll: same regs and ops for trion and lucid")
the function clk_trion_pll_configure() is left with an old description
header, which results in a W=2 compile time warning, fix it.

Acked-by: Stephen Boyd <sboyd@kernel.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220701062711.2757855-1-vladimir.zapolskiy@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-alpha-pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/clk-alpha-pll.c b/drivers/clk/qcom/clk-alpha-pll.c
index 1a571c04a76c..cf265ab035ea 100644
--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -1379,7 +1379,7 @@ const struct clk_ops clk_alpha_pll_postdiv_fabia_ops = {
 EXPORT_SYMBOL_GPL(clk_alpha_pll_postdiv_fabia_ops);
 
 /**
- * clk_lucid_pll_configure - configure the lucid pll
+ * clk_trion_pll_configure - configure the trion pll
  *
  * @pll: clk alpha pll
  * @regmap: register map
-- 
2.35.1

