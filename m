Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C1E65D5DD
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjADOhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239628AbjADOgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:36:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568051035
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:36:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E2ABB8166B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFB4C433EF;
        Wed,  4 Jan 2023 14:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843010;
        bh=rGro+rOVVuRxYzJl5IU7BtPpQryRqPvTmZ7l6RCe/2M=;
        h=Subject:To:Cc:From:Date:From;
        b=l9TmztqLVsTYHe0Ry9PesA9U5cwLkL9JK6bQGuhG6w0P0lN4GYX2j+9ihYeVMnNfo
         FgMJMjlSe2CJSEmZKCL8CPWA+M9zEMSiA3ORFwP0mqQv90+4H7vp1xjIe4GVEcZnmA
         As+iBf7zBGc4jQ/ZaWZRYwrGbk/LWLTC5pkcfh5c=
Subject: FAILED: patch "[PATCH] drm/amd/pm: fulfill SMU13.0.7 cstate control interface" failed to apply to 6.0-stable tree
To:     evan.quan@amd.com, Hawking.Zhang@amd.com,
        alexander.deucher@amd.com, lijo.lazar@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:36:39 +0100
Message-ID: <1672842999138101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

3cf377ee8df7 ("drm/amd/pm: fulfill SMU13.0.7 cstate control interface")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3cf377ee8df7dc4ae5e543c37833ae5a5b2a78d3 Mon Sep 17 00:00:00 2001
From: Evan Quan <evan.quan@amd.com>
Date: Thu, 29 Sep 2022 10:30:01 +0800
Subject: [PATCH] drm/amd/pm: fulfill SMU13.0.7 cstate control interface

Fulfill the functionality for cstate control.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index c422bf8a09b1..c4102cfb734c 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -121,6 +121,7 @@ static struct cmn2asic_msg_mapping smu_v13_0_7_message_map[SMU_MSG_MAX_COUNT] =
 	MSG_MAP(Mode1Reset,             PPSMC_MSG_Mode1Reset,                  0),
 	MSG_MAP(PrepareMp1ForUnload,		PPSMC_MSG_PrepareMp1ForUnload,         0),
 	MSG_MAP(SetMGpuFanBoostLimitRpm,	PPSMC_MSG_SetMGpuFanBoostLimitRpm,     0),
+	MSG_MAP(DFCstateControl,		PPSMC_MSG_SetExternalClientDfCstateAllow, 0),
 };
 
 static struct cmn2asic_mapping smu_v13_0_7_clk_map[SMU_CLK_COUNT] = {
@@ -1587,6 +1588,16 @@ static bool smu_v13_0_7_is_mode1_reset_supported(struct smu_context *smu)
 
 	return true;
 }
+
+static int smu_v13_0_7_set_df_cstate(struct smu_context *smu,
+				     enum pp_df_cstate state)
+{
+	return smu_cmn_send_smc_msg_with_param(smu,
+					       SMU_MSG_DFCstateControl,
+					       state,
+					       NULL);
+}
+
 static const struct pptable_funcs smu_v13_0_7_ppt_funcs = {
 	.get_allowed_feature_mask = smu_v13_0_7_get_allowed_feature_mask,
 	.set_default_dpm_table = smu_v13_0_7_set_default_dpm_table,
@@ -1649,6 +1660,7 @@ static const struct pptable_funcs smu_v13_0_7_ppt_funcs = {
 	.mode1_reset_is_support = smu_v13_0_7_is_mode1_reset_supported,
 	.mode1_reset = smu_v13_0_mode1_reset,
 	.set_mp1_state = smu_v13_0_7_set_mp1_state,
+	.set_df_cstate = smu_v13_0_7_set_df_cstate,
 };
 
 void smu_v13_0_7_set_ppt_funcs(struct smu_context *smu)

