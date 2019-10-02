Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 491BAC9104
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 20:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbfJBSm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 14:42:29 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36031 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfJBSm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 14:42:29 -0400
Received: by mail-qt1-f196.google.com with SMTP id o12so18141qtf.3
        for <stable@vger.kernel.org>; Wed, 02 Oct 2019 11:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6YtTJIYr7pc2y7DAEryLRlVYSoo0I0Rkb3x9ag71BSM=;
        b=M4PzeA0+W5Jrxd2n6yO1uo0+DhV8iAyDdZ+2eOvtX/+Z/XppvuAkqqEixAkncguEac
         WMscVPMDzRXxHcxCf0wFLbML+C7kW9TgQFvleh8CqlrneCGaSsbWDlrkrH9gHFKS1y9o
         RFqyNCnpVQQTgp6vnLHw/wUOjIi1iPRVjaLaliEIyD6SQRJ2EovpJMzJb3G3gkFasHsP
         6cY84BpITDgkbhS4NFtmduxfkyD7gB6uPbyx1/m8pd+l6kilBt5VdiKmuOWEsNj/EPYV
         NaV09EPxIsi++4yh+gmZwkMsaq/dIYCARzhhpCNtxIbPjiLNMpIUOi3mmc7YsGxMZJKR
         62TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6YtTJIYr7pc2y7DAEryLRlVYSoo0I0Rkb3x9ag71BSM=;
        b=CTA/a4eYP+QkjIUuxBQLO3r5acc5w7UoOaKdeZyz99rru9KlR+2JPskxRm1DDi8P/d
         yqDFMD52yzYFm0lFyZdxJ3+IeDNh+eIltG1t427X0p6ar6dfUzx5P177hZqEtfDE+4zJ
         wnilQVrRUZTKdQfe9tWfMv3hAGoqDGmBDYvaDOIBwZzeLs8HVUzn8R+Mu0+TaC5RHe9Q
         CMYu7QEvOfGSwRgH5qbZdWiVyIVJy3WOpb1wx/EadkkcX6DHh6DHyM74UaQaCFsGbYg6
         QEB8h63J4e5jOMbLPUPWJ5v2uOe8xF6fDCUzaRseuATFeNRYzXmWyDDt17gJPMdfR5aM
         6NqA==
X-Gm-Message-State: APjAAAWJpC/S9jrKjUhXVfWz1d+SbPuzckP8YzzZIi3yUaWAkUju/AFr
        HLt323Fpxr15oS1z378WuNmz9qYn
X-Google-Smtp-Source: APXvYqw9cO8fh2UPNQkM14rFXIdEwzOeE2GdDKkRuMfnD0AkYz7D34wypvyTCiTW5Qum+Ur+aZWExg==
X-Received: by 2002:a0c:9326:: with SMTP id d35mr4421200qvd.162.1570041748135;
        Wed, 02 Oct 2019 11:42:28 -0700 (PDT)
Received: from localhost.localdomain ([71.219.73.178])
        by smtp.gmail.com with ESMTPSA id n125sm1178qkn.129.2019.10.02.11.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 11:42:27 -0700 (PDT)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Charlene Liu <charlene.liu@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 1/3] drm/amd/display: dce11.x /dce12 update formula input
Date:   Wed,  2 Oct 2019 13:42:17 -0500
Message-Id: <20191002184219.4011-2-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191002184219.4011-1-alexander.deucher@amd.com>
References: <20191002184219.4011-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charlene Liu <charlene.liu@amd.com>

[Description]
1. OUTSTANDING_REQUEST_LIMIT update from 0xFF to 0x1F (HW doc update)
2. using memory type to convert UMC's MCLK to Yclk.

Signed-off-by: Charlene Liu <charlene.liu@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c46e5df4ac898108da66a880c4e18f69c74f6c1b)
cc: stable@vger.kernel.org # 5.3.x
---
 .../display/dc/clk_mgr/dce110/dce110_clk_mgr.c   |  7 +++++--
 .../gpu/drm/amd/display/dc/dce/dce_mem_input.c   |  4 ++--
 .../drm/amd/display/dc/dce112/dce112_resource.c  | 16 ++++++++++------
 .../drm/amd/display/dc/dce120/dce120_resource.c  | 11 ++++++++---
 drivers/gpu/drm/amd/display/dc/inc/resource.h    |  2 ++
 5 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
index 5cc3acccda2a..ee32d2c19305 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
@@ -98,11 +98,14 @@ uint32_t dce110_get_min_vblank_time_us(const struct dc_state *context)
 		struct dc_stream_state *stream = context->streams[j];
 		uint32_t vertical_blank_in_pixels = 0;
 		uint32_t vertical_blank_time = 0;
+		uint32_t vertical_total_min = stream->timing.v_total;
+		struct dc_crtc_timing_adjust adjust = stream->adjust;
+		if (adjust.v_total_max != adjust.v_total_min)
+			vertical_total_min = adjust.v_total_min;
 
 		vertical_blank_in_pixels = stream->timing.h_total *
-			(stream->timing.v_total
+			(vertical_total_min
 			 - stream->timing.v_addressable);
-
 		vertical_blank_time = vertical_blank_in_pixels
 			* 10000 / stream->timing.pix_clk_100hz;
 
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_mem_input.c b/drivers/gpu/drm/amd/display/dc/dce/dce_mem_input.c
index a24a2bda8656..1596ddcb26e6 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_mem_input.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_mem_input.c
@@ -148,7 +148,7 @@ static void dce_mi_program_pte_vm(
 			pte->min_pte_before_flip_horiz_scan;
 
 	REG_UPDATE(GRPH_PIPE_OUTSTANDING_REQUEST_LIMIT,
-			GRPH_PIPE_OUTSTANDING_REQUEST_LIMIT, 0xff);
+			GRPH_PIPE_OUTSTANDING_REQUEST_LIMIT, 0x7f);
 
 	REG_UPDATE_3(DVMM_PTE_CONTROL,
 			DVMM_PAGE_WIDTH, page_width,
@@ -157,7 +157,7 @@ static void dce_mi_program_pte_vm(
 
 	REG_UPDATE_2(DVMM_PTE_ARB_CONTROL,
 			DVMM_PTE_REQ_PER_CHUNK, pte->pte_req_per_chunk,
-			DVMM_MAX_PTE_REQ_OUTSTANDING, 0xff);
+			DVMM_MAX_PTE_REQ_OUTSTANDING, 0x7f);
 }
 
 static void program_urgency_watermark(
diff --git a/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c b/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c
index c6136e0ed1a4..7a04be74c9cf 100644
--- a/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c
@@ -987,6 +987,10 @@ static void bw_calcs_data_update_from_pplib(struct dc *dc)
 	struct dm_pp_clock_levels_with_latency mem_clks = {0};
 	struct dm_pp_wm_sets_with_clock_ranges clk_ranges = {0};
 	struct dm_pp_clock_levels clks = {0};
+	int memory_type_multiplier = MEMORY_TYPE_MULTIPLIER_CZ;
+
+	if (dc->bw_vbios && dc->bw_vbios->memory_type == bw_def_hbm)
+		memory_type_multiplier = MEMORY_TYPE_HBM;
 
 	/*do system clock  TODO PPLIB: after PPLIB implement,
 	 * then remove old way
@@ -1026,12 +1030,12 @@ static void bw_calcs_data_update_from_pplib(struct dc *dc)
 				&clks);
 
 		dc->bw_vbios->low_yclk = bw_frc_to_fixed(
-			clks.clocks_in_khz[0] * MEMORY_TYPE_MULTIPLIER_CZ, 1000);
+			clks.clocks_in_khz[0] * memory_type_multiplier, 1000);
 		dc->bw_vbios->mid_yclk = bw_frc_to_fixed(
-			clks.clocks_in_khz[clks.num_levels>>1] * MEMORY_TYPE_MULTIPLIER_CZ,
+			clks.clocks_in_khz[clks.num_levels>>1] * memory_type_multiplier,
 			1000);
 		dc->bw_vbios->high_yclk = bw_frc_to_fixed(
-			clks.clocks_in_khz[clks.num_levels-1] * MEMORY_TYPE_MULTIPLIER_CZ,
+			clks.clocks_in_khz[clks.num_levels-1] * memory_type_multiplier,
 			1000);
 
 		return;
@@ -1067,12 +1071,12 @@ static void bw_calcs_data_update_from_pplib(struct dc *dc)
 	 * YCLK = UMACLK*m_memoryTypeMultiplier
 	 */
 	dc->bw_vbios->low_yclk = bw_frc_to_fixed(
-		mem_clks.data[0].clocks_in_khz * MEMORY_TYPE_MULTIPLIER_CZ, 1000);
+		mem_clks.data[0].clocks_in_khz * memory_type_multiplier, 1000);
 	dc->bw_vbios->mid_yclk = bw_frc_to_fixed(
-		mem_clks.data[mem_clks.num_levels>>1].clocks_in_khz * MEMORY_TYPE_MULTIPLIER_CZ,
+		mem_clks.data[mem_clks.num_levels>>1].clocks_in_khz * memory_type_multiplier,
 		1000);
 	dc->bw_vbios->high_yclk = bw_frc_to_fixed(
-		mem_clks.data[mem_clks.num_levels-1].clocks_in_khz * MEMORY_TYPE_MULTIPLIER_CZ,
+		mem_clks.data[mem_clks.num_levels-1].clocks_in_khz * memory_type_multiplier,
 		1000);
 
 	/* Now notify PPLib/SMU about which Watermarks sets they should select
diff --git a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
index 4a6ba3173a5a..ae38c9c7277c 100644
--- a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
@@ -847,6 +847,8 @@ static void bw_calcs_data_update_from_pplib(struct dc *dc)
 	int i;
 	unsigned int clk;
 	unsigned int latency;
+	/*original logic in dal3*/
+	int memory_type_multiplier = MEMORY_TYPE_MULTIPLIER_CZ;
 
 	/*do system clock*/
 	if (!dm_pp_get_clock_levels_by_type_with_latency(
@@ -905,13 +907,16 @@ static void bw_calcs_data_update_from_pplib(struct dc *dc)
 	 * ALSO always convert UMA clock (from PPLIB)  to YCLK (HW formula):
 	 * YCLK = UMACLK*m_memoryTypeMultiplier
 	 */
+	if (dc->bw_vbios->memory_type == bw_def_hbm)
+		memory_type_multiplier = MEMORY_TYPE_HBM;
+
 	dc->bw_vbios->low_yclk = bw_frc_to_fixed(
-		mem_clks.data[0].clocks_in_khz * MEMORY_TYPE_MULTIPLIER_CZ, 1000);
+		mem_clks.data[0].clocks_in_khz * memory_type_multiplier, 1000);
 	dc->bw_vbios->mid_yclk = bw_frc_to_fixed(
-		mem_clks.data[mem_clks.num_levels>>1].clocks_in_khz * MEMORY_TYPE_MULTIPLIER_CZ,
+		mem_clks.data[mem_clks.num_levels>>1].clocks_in_khz * memory_type_multiplier,
 		1000);
 	dc->bw_vbios->high_yclk = bw_frc_to_fixed(
-		mem_clks.data[mem_clks.num_levels-1].clocks_in_khz * MEMORY_TYPE_MULTIPLIER_CZ,
+		mem_clks.data[mem_clks.num_levels-1].clocks_in_khz * memory_type_multiplier,
 		1000);
 
 	/* Now notify PPLib/SMU about which Watermarks sets they should select
diff --git a/drivers/gpu/drm/amd/display/dc/inc/resource.h b/drivers/gpu/drm/amd/display/dc/inc/resource.h
index 47f81072d7e9..c0424b4035a5 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/resource.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/resource.h
@@ -31,6 +31,8 @@
 #include "dm_pp_smu.h"
 
 #define MEMORY_TYPE_MULTIPLIER_CZ 4
+#define MEMORY_TYPE_HBM 2
+
 
 enum dce_version resource_parse_asic_id(
 		struct hw_asic_id asic_id);
-- 
2.20.1

