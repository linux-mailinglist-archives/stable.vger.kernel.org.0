Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECD5592208
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241244AbiHNPmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241668AbiHNPmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:42:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3EE237EA;
        Sun, 14 Aug 2022 08:33:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 012CBB80B7F;
        Sun, 14 Aug 2022 15:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB7BC433D7;
        Sun, 14 Aug 2022 15:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491208;
        bh=yCu+hAZ3eXWNMUToH6jwIasEDtNCAS4aIAONapDsSKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+PUm5SZ9iMQJCfH0eJg18KW+k41+ZLiUXNDmDD+oekE3m4DnclKXTqcWobMAb9NH
         VdWTLzdotmvuBGdCacKl/XuYn394O7TTQl/UuoX3ejCCsIaFBUs3r8fhCOjqw1BXXD
         TVLj6XlRraokzxR14fAGPMWDqsYkt6wp1o3ER0zjnqPAP6qWzN/mvoVi24iKCuMfu7
         7kwqRoxvbaKg5hPOzFOf76JoMWKnhz+bZLX9vaslSpYWSulo21fZHrpRbtI0aOFJij
         GaIc5+sUI72RIYzekwjyfLRAs9XFNxETAtf5kcYi/hZopoDGFrb57q4+SuUX1RA0Vg
         KaU6gJp4gtaaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        mturquette@baylibre.com, linux-arm-msm@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 20/46] clk: qcom: clk-alpha-pll: fix clk_trion_pll_configure description
Date:   Sun, 14 Aug 2022 11:32:21 -0400
Message-Id: <20220814153247.2378312-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153247.2378312-1-sashal@kernel.org>
References: <20220814153247.2378312-1-sashal@kernel.org>
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
index 8f65b9bdafce..5e44ceb730ad 100644
--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -1420,7 +1420,7 @@ const struct clk_ops clk_alpha_pll_postdiv_fabia_ops = {
 EXPORT_SYMBOL_GPL(clk_alpha_pll_postdiv_fabia_ops);
 
 /**
- * clk_lucid_pll_configure - configure the lucid pll
+ * clk_trion_pll_configure - configure the trion pll
  *
  * @pll: clk alpha pll
  * @regmap: register map
-- 
2.35.1

