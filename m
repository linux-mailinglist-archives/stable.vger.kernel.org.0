Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E8E6AB00F
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjCENwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjCENwN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:52:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B078C6EAE;
        Sun,  5 Mar 2023 05:52:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C99660A54;
        Sun,  5 Mar 2023 13:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D83AC433D2;
        Sun,  5 Mar 2023 13:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024330;
        bh=GD7bRPnmKLbCghxsUKpSfGGru8Lwm80DFDBP/5YwPmo=;
        h=From:To:Cc:Subject:Date:From;
        b=rFR/DWnLWlUVMsy6NTvekkzTcDVFaVcEkelmz80581gJwB+3LLPNT3Yw4u+NF+Y/p
         L3yq9iegOwhWNQDHpOtXxuccO+hFGAGYo45p8f6koiAs2LlFMyAG+nD/abXVR/FMs5
         ptFtymr/ntHAs1EX30kTnIsXcxZULfr89qVXdUsUdFvnRyZDx5rEdqlmXAgCd0QyXf
         Tc2bYFGTPBEl3FKNl9O/rM4k1kc4c8f6txZPpl4YFh+Xd0VsYvy5jQ6tDpwTjRVr3b
         I/nGLHTf1EGh8F7ZDhFQKq6mRfR/vpO1tvBmXfWNBctTzziF2c+Sco2r2XLEdCLEI7
         4dxTdKzP2x7Gw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        mturquette@baylibre.com, linux-arm-msm@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 01/16] clk: qcom: mmcc-apq8084: remove spdm clocks
Date:   Sun,  5 Mar 2023 08:51:52 -0500
Message-Id: <20230305135207.1793266-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 7b347f4b677b6d84687e67d82b6b17c6f55ea2b4 ]

SPDM is used for debug/profiling and does not have any other
functionality. These clocks can safely be removed.

Suggested-by: Stephen Boyd <sboyd@kernel.org>
Suggested-by: Georgi Djakov <djakov@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230111060402.1168726-11-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/mmcc-apq8084.c | 271 --------------------------------
 1 file changed, 271 deletions(-)

diff --git a/drivers/clk/qcom/mmcc-apq8084.c b/drivers/clk/qcom/mmcc-apq8084.c
index e9f9713591558..025e21793b3c4 100644
--- a/drivers/clk/qcom/mmcc-apq8084.c
+++ b/drivers/clk/qcom/mmcc-apq8084.c
@@ -2364,262 +2364,6 @@ static struct clk_branch mmss_rbcpr_clk = {
 	},
 };
 
-static struct clk_branch mmss_spdm_ahb_clk = {
-	.halt_reg = 0x0230,
-	.clkr = {
-		.enable_reg = 0x0230,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_ahb_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_ahb_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_axi_clk = {
-	.halt_reg = 0x0210,
-	.clkr = {
-		.enable_reg = 0x0210,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_axi_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_axi_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_csi0_clk = {
-	.halt_reg = 0x023c,
-	.clkr = {
-		.enable_reg = 0x023c,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_csi0_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_csi0_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_gfx3d_clk = {
-	.halt_reg = 0x022c,
-	.clkr = {
-		.enable_reg = 0x022c,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_gfx3d_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_gfx3d_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_jpeg0_clk = {
-	.halt_reg = 0x0204,
-	.clkr = {
-		.enable_reg = 0x0204,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_jpeg0_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_jpeg0_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_jpeg1_clk = {
-	.halt_reg = 0x0208,
-	.clkr = {
-		.enable_reg = 0x0208,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_jpeg1_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_jpeg1_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_jpeg2_clk = {
-	.halt_reg = 0x0224,
-	.clkr = {
-		.enable_reg = 0x0224,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_jpeg2_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_jpeg2_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_mdp_clk = {
-	.halt_reg = 0x020c,
-	.clkr = {
-		.enable_reg = 0x020c,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_mdp_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_mdp_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_pclk0_clk = {
-	.halt_reg = 0x0234,
-	.clkr = {
-		.enable_reg = 0x0234,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_pclk0_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_pclk0_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_pclk1_clk = {
-	.halt_reg = 0x0228,
-	.clkr = {
-		.enable_reg = 0x0228,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_pclk1_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_pclk1_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_vcodec0_clk = {
-	.halt_reg = 0x0214,
-	.clkr = {
-		.enable_reg = 0x0214,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_vcodec0_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_vcodec0_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_vfe0_clk = {
-	.halt_reg = 0x0218,
-	.clkr = {
-		.enable_reg = 0x0218,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_vfe0_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_vfe0_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_vfe1_clk = {
-	.halt_reg = 0x021c,
-	.clkr = {
-		.enable_reg = 0x021c,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_vfe1_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_vfe1_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_rm_axi_clk = {
-	.halt_reg = 0x0304,
-	.clkr = {
-		.enable_reg = 0x0304,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_rm_axi_clk",
-			.parent_names = (const char *[]){
-				"mmss_axi_clk_src",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_rm_ocmemnoc_clk = {
-	.halt_reg = 0x0308,
-	.clkr = {
-		.enable_reg = 0x0308,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_rm_ocmemnoc_clk",
-			.parent_names = (const char *[]){
-				"ocmemnoc_clk_src",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-
 static struct clk_branch mmss_misc_ahb_clk = {
 	.halt_reg = 0x502c,
 	.clkr = {
@@ -3252,21 +2996,6 @@ static struct clk_regmap *mmcc_apq8084_clocks[] = {
 	[MDSS_VSYNC_CLK] = &mdss_vsync_clk.clkr,
 	[MMSS_RBCPR_AHB_CLK] = &mmss_rbcpr_ahb_clk.clkr,
 	[MMSS_RBCPR_CLK] = &mmss_rbcpr_clk.clkr,
-	[MMSS_SPDM_AHB_CLK] = &mmss_spdm_ahb_clk.clkr,
-	[MMSS_SPDM_AXI_CLK] = &mmss_spdm_axi_clk.clkr,
-	[MMSS_SPDM_CSI0_CLK] = &mmss_spdm_csi0_clk.clkr,
-	[MMSS_SPDM_GFX3D_CLK] = &mmss_spdm_gfx3d_clk.clkr,
-	[MMSS_SPDM_JPEG0_CLK] = &mmss_spdm_jpeg0_clk.clkr,
-	[MMSS_SPDM_JPEG1_CLK] = &mmss_spdm_jpeg1_clk.clkr,
-	[MMSS_SPDM_JPEG2_CLK] = &mmss_spdm_jpeg2_clk.clkr,
-	[MMSS_SPDM_MDP_CLK] = &mmss_spdm_mdp_clk.clkr,
-	[MMSS_SPDM_PCLK0_CLK] = &mmss_spdm_pclk0_clk.clkr,
-	[MMSS_SPDM_PCLK1_CLK] = &mmss_spdm_pclk1_clk.clkr,
-	[MMSS_SPDM_VCODEC0_CLK] = &mmss_spdm_vcodec0_clk.clkr,
-	[MMSS_SPDM_VFE0_CLK] = &mmss_spdm_vfe0_clk.clkr,
-	[MMSS_SPDM_VFE1_CLK] = &mmss_spdm_vfe1_clk.clkr,
-	[MMSS_SPDM_RM_AXI_CLK] = &mmss_spdm_rm_axi_clk.clkr,
-	[MMSS_SPDM_RM_OCMEMNOC_CLK] = &mmss_spdm_rm_ocmemnoc_clk.clkr,
 	[MMSS_MISC_AHB_CLK] = &mmss_misc_ahb_clk.clkr,
 	[MMSS_MMSSNOC_AHB_CLK] = &mmss_mmssnoc_ahb_clk.clkr,
 	[MMSS_MMSSNOC_BTO_AHB_CLK] = &mmss_mmssnoc_bto_ahb_clk.clkr,
-- 
2.39.2

