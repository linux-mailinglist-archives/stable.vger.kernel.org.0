Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F5E63E049
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiK3Szb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiK3Szb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:55:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A8F99F1E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:55:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB4DCB81C9F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473CFC433C1;
        Wed, 30 Nov 2022 18:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834527;
        bh=xyz3KHxTYesAxGhf9HBubnG3thHJlf/p5xKmQeuVMBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=scNqmRJB3px8648TYc+yV3ehXNyi0tNAIW0S61RrhJNFNyLkSgce+gJ407zFGv8RY
         jPdNXUgPwuQ6bIG3mYp/vZXRLWvV3squzp0X86+5cErgEe3smVUpLnMGesfN1CMEeZ
         zPF+59R9UCSXNsSHhQvlA/Hq8UFFZyOYynS4atyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jun Lei <Jun.Lei@amd.com>,
        Brian Chang <Brian.Chang@amd.com>,
        Dillon Varone <Dillon.Varone@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 286/289] drm/amd/display: Update soc bounding box for dcn32/dcn321
Date:   Wed, 30 Nov 2022 19:24:31 +0100
Message-Id: <20221130180550.586170894@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dillon Varone <Dillon.Varone@amd.com>

commit 5d82c82f1dbee264f7a94587adbbfee607706902 upstream.

[Description]
New values for soc bounding box and dummy pstate.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Brian Chang <Brian.Chang@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c   |    6 +++---
 drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -157,7 +157,7 @@ struct _vcs_dpi_soc_bounding_box_st dcn3
 	.dispclk_dppclk_vco_speed_mhz = 4300.0,
 	.do_urgent_latency_adjustment = true,
 	.urgent_latency_adjustment_fabric_clock_component_us = 1.0,
-	.urgent_latency_adjustment_fabric_clock_reference_mhz = 1000,
+	.urgent_latency_adjustment_fabric_clock_reference_mhz = 3000,
 };
 
 void dcn32_build_wm_range_table_fpu(struct clk_mgr_internal *clk_mgr)
@@ -211,7 +211,7 @@ void dcn32_build_wm_range_table_fpu(stru
 	/* 'DalDummyClockChangeLatencyNs' registry key option set to 0x7FFFFFFF can be used to disable Set C for dummy p-state */
 	if (clk_mgr->base.ctx->dc->bb_overrides.dummy_clock_change_latency_ns != 0x7FFFFFFF) {
 		clk_mgr->base.bw_params->wm_table.nv_entries[WM_C].valid = true;
-		clk_mgr->base.bw_params->wm_table.nv_entries[WM_C].dml_input.pstate_latency_us = 38;
+		clk_mgr->base.bw_params->wm_table.nv_entries[WM_C].dml_input.pstate_latency_us = 50;
 		clk_mgr->base.bw_params->wm_table.nv_entries[WM_C].dml_input.fclk_change_latency_us = fclk_change_latency_us;
 		clk_mgr->base.bw_params->wm_table.nv_entries[WM_C].dml_input.sr_exit_time_us = sr_exit_time_us;
 		clk_mgr->base.bw_params->wm_table.nv_entries[WM_C].dml_input.sr_enter_plus_exit_time_us = sr_enter_plus_exit_time_us;
@@ -221,7 +221,7 @@ void dcn32_build_wm_range_table_fpu(stru
 		clk_mgr->base.bw_params->wm_table.nv_entries[WM_C].pmfw_breakdown.min_uclk = min_uclk_mhz;
 		clk_mgr->base.bw_params->wm_table.nv_entries[WM_C].pmfw_breakdown.max_uclk = 0xFFFF;
 		clk_mgr->base.bw_params->dummy_pstate_table[0].dram_speed_mts = clk_mgr->base.bw_params->clk_table.entries[0].memclk_mhz * 16;
-		clk_mgr->base.bw_params->dummy_pstate_table[0].dummy_pstate_latency_us = 38;
+		clk_mgr->base.bw_params->dummy_pstate_table[0].dummy_pstate_latency_us = 50;
 		clk_mgr->base.bw_params->dummy_pstate_table[1].dram_speed_mts = clk_mgr->base.bw_params->clk_table.entries[1].memclk_mhz * 16;
 		clk_mgr->base.bw_params->dummy_pstate_table[1].dummy_pstate_latency_us = 9;
 		clk_mgr->base.bw_params->dummy_pstate_table[2].dram_speed_mts = clk_mgr->base.bw_params->clk_table.entries[2].memclk_mhz * 16;
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
@@ -125,9 +125,9 @@ struct _vcs_dpi_soc_bounding_box_st dcn3
 	.sr_enter_plus_exit_z8_time_us = 320,
 	.writeback_latency_us = 12.0,
 	.round_trip_ping_latency_dcfclk_cycles = 263,
-	.urgent_latency_pixel_data_only_us = 9.35,
-	.urgent_latency_pixel_mixed_with_vm_data_us = 9.35,
-	.urgent_latency_vm_data_only_us = 9.35,
+	.urgent_latency_pixel_data_only_us = 4,
+	.urgent_latency_pixel_mixed_with_vm_data_us = 4,
+	.urgent_latency_vm_data_only_us = 4,
 	.fclk_change_latency_us = 20,
 	.usr_retraining_latency_us = 2,
 	.smn_latency_us = 2,
@@ -155,7 +155,7 @@ struct _vcs_dpi_soc_bounding_box_st dcn3
 	.dispclk_dppclk_vco_speed_mhz = 4300.0,
 	.do_urgent_latency_adjustment = true,
 	.urgent_latency_adjustment_fabric_clock_component_us = 1.0,
-	.urgent_latency_adjustment_fabric_clock_reference_mhz = 1000,
+	.urgent_latency_adjustment_fabric_clock_reference_mhz = 3000,
 };
 
 static void get_optimal_ntuple(struct _vcs_dpi_voltage_scaling_st *entry)


