Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A218363DC20
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 18:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiK3RiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 12:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiK3RiI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 12:38:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F94C326FB
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 09:38:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF64461D3A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 17:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06840C433C1;
        Wed, 30 Nov 2022 17:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669829883;
        bh=a+mbrEKjHsJ0vCOC44sdThvmflUMCfgfy9WTvKviQS8=;
        h=Subject:To:Cc:From:Date:From;
        b=01V+jKuQQcnJjpcs80V6Tjpj9GDP7zscf2qJUgjqRi/0pYTEzV94YyrYD6uIeaK9W
         v5P/tR82ejhXEoHUd1mD1SvOcC0064xGRu1lt4rTO5y/X5jA0wEhwsiIsvHrZPdDgy
         IaxhhnynENfa8b2WDU27VhjSGgYaBMHDs4bkFB/0=
Subject: FAILED: patch "[PATCH] drm/amdgpu/mst: Stop ignoring error codes and deadlocking" failed to apply to 5.15-stable tree
To:     lyude@redhat.com, Wayne.Lin@amd.com, alexander.deucher@amd.com,
        harry.wentland@amd.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 18:37:52 +0100
Message-ID: <1669829872100167@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ba891436c2d2 ("drm/amdgpu/mst: Stop ignoring error codes and deadlocking")
876fcc4222e1 ("drm/amd/display: Validate DSC After Enable All New CRTCs")
4d07b0bc4034 ("drm/display/dp_mst: Move all payload info into the atomic state")
6366fc70deb9 ("drm/display/dp_mst: Maintain time slot allocations when deleting payloads")
a5c2c0d164e9 ("drm/display/dp_mst: Add nonblocking helpers for DP MST")
0b4e477e08a1 ("drm/display/dp_mst: Add helper for finding payloads in atomic MST state")
0bee2ae29eb4 ("drm/display/dp_mst: Add some missing kdocs for atomic MST structs")
df78f7f660cd ("drm/display/dp_mst: Call them time slots, not VCPI slots")
48b6b3726fb7 ("drm/display/dp_mst: Rename drm_dp_mst_vcpi_allocation")
dbaadb3cebaa ("drm/amdgpu/dm/mst: Rename get_payload_table()")
8c5e9bbb3662 ("drm/amdgpu/dc/mst: Rename dp_mst_stream_allocation(_table)")
25f7cde8bad9 ("drm/amd/display: Add tags for indicating mst progress status")
8b076fa7c5be ("drm/amd/display: Add is_mst_connector debugfs entry")
922e7ee31def ("drm/amd/display: Clear edid when unplug mst connector")
990cad0e4a9d ("drm/amd/display: extract update stream allocation to link_hwss")
84a8b3908285 ("drm/amd/display: Release remote dc_sink under mst scenario")
71be4b16d39a ("drm/amd/display: dsc validate fail not pass to atomic check")
453b0016a054 ("drm/amd/display: Detect dpcd_rev when hotplug mst monitor")
00df0514ab13 ("Merge tag 'amd-drm-next-5.19-2022-05-18' of https://gitlab.freedesktop.org/agd5f/linux into drm-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ba891436c2d2b2a6d6c1bc3733bab3b72f07e87f Mon Sep 17 00:00:00 2001
From: Lyude Paul <lyude@redhat.com>
Date: Mon, 14 Nov 2022 17:17:52 -0500
Subject: [PATCH] drm/amdgpu/mst: Stop ignoring error codes and deadlocking

It appears that amdgpu makes the mistake of completely ignoring the return
values from the DP MST helpers, and instead just returns a simple
true/false. In this case, it seems to have come back to bite us because as
a result of simply returning false from
compute_mst_dsc_configs_for_state(), amdgpu had no way of telling when a
deadlock happened from these helpers. This could definitely result in some
kernel splats.

V2:
* Address Wayne's comments (fix another bunch of spots where we weren't
  passing down return codes)

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 8c20a1ed9b4f ("drm/amd/display: MST DSC compute fair share")
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: <stable@vger.kernel.org> # v5.6+
Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 3e1ecca72430..636e6d640b4e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6475,7 +6475,7 @@ static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
 	struct drm_connector_state *new_con_state;
 	struct amdgpu_dm_connector *aconnector;
 	struct dm_connector_state *dm_conn_state;
-	int i, j;
+	int i, j, ret;
 	int vcpi, pbn_div, pbn, slot_num = 0;
 
 	for_each_new_connector_in_state(state, connector, new_con_state, i) {
@@ -6522,8 +6522,11 @@ static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
 			dm_conn_state->pbn = pbn;
 			dm_conn_state->vcpi_slots = slot_num;
 
-			drm_dp_mst_atomic_enable_dsc(state, aconnector->port, dm_conn_state->pbn,
-						     false);
+			ret = drm_dp_mst_atomic_enable_dsc(state, aconnector->port,
+							   dm_conn_state->pbn, false);
+			if (ret < 0)
+				return ret;
+
 			continue;
 		}
 
@@ -9537,10 +9540,9 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 
 #if defined(CONFIG_DRM_AMD_DC_DCN)
 	if (dc_resource_is_dsc_encoding_supported(dc)) {
-		if (!pre_validate_dsc(state, &dm_state, vars)) {
-			ret = -EINVAL;
+		ret = pre_validate_dsc(state, &dm_state, vars);
+		if (ret != 0)
 			goto fail;
-		}
 	}
 #endif
 
@@ -9635,9 +9637,9 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 		}
 
 #if defined(CONFIG_DRM_AMD_DC_DCN)
-		if (!compute_mst_dsc_configs_for_state(state, dm_state->context, vars)) {
+		ret = compute_mst_dsc_configs_for_state(state, dm_state->context, vars);
+		if (ret) {
 			DRM_DEBUG_DRIVER("compute_mst_dsc_configs_for_state() failed\n");
-			ret = -EINVAL;
 			goto fail;
 		}
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 6ff96b4bdda5..bba2e8aaa2c2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -703,13 +703,13 @@ static int bpp_x16_from_pbn(struct dsc_mst_fairness_params param, int pbn)
 	return dsc_config.bits_per_pixel;
 }
 
-static bool increase_dsc_bpp(struct drm_atomic_state *state,
-			     struct drm_dp_mst_topology_state *mst_state,
-			     struct dc_link *dc_link,
-			     struct dsc_mst_fairness_params *params,
-			     struct dsc_mst_fairness_vars *vars,
-			     int count,
-			     int k)
+static int increase_dsc_bpp(struct drm_atomic_state *state,
+			    struct drm_dp_mst_topology_state *mst_state,
+			    struct dc_link *dc_link,
+			    struct dsc_mst_fairness_params *params,
+			    struct dsc_mst_fairness_vars *vars,
+			    int count,
+			    int k)
 {
 	int i;
 	bool bpp_increased[MAX_PIPES];
@@ -719,6 +719,7 @@ static bool increase_dsc_bpp(struct drm_atomic_state *state,
 	int remaining_to_increase = 0;
 	int link_timeslots_used;
 	int fair_pbn_alloc;
+	int ret = 0;
 
 	for (i = 0; i < count; i++) {
 		if (vars[i + k].dsc_enabled) {
@@ -757,52 +758,60 @@ static bool increase_dsc_bpp(struct drm_atomic_state *state,
 
 		if (initial_slack[next_index] > fair_pbn_alloc) {
 			vars[next_index].pbn += fair_pbn_alloc;
-			if (drm_dp_atomic_find_time_slots(state,
-							  params[next_index].port->mgr,
-							  params[next_index].port,
-							  vars[next_index].pbn) < 0)
-				return false;
-			if (!drm_dp_mst_atomic_check(state)) {
+			ret = drm_dp_atomic_find_time_slots(state,
+							    params[next_index].port->mgr,
+							    params[next_index].port,
+							    vars[next_index].pbn);
+			if (ret < 0)
+				return ret;
+
+			ret = drm_dp_mst_atomic_check(state);
+			if (ret == 0) {
 				vars[next_index].bpp_x16 = bpp_x16_from_pbn(params[next_index], vars[next_index].pbn);
 			} else {
 				vars[next_index].pbn -= fair_pbn_alloc;
-				if (drm_dp_atomic_find_time_slots(state,
-								  params[next_index].port->mgr,
-								  params[next_index].port,
-								  vars[next_index].pbn) < 0)
-					return false;
+				ret = drm_dp_atomic_find_time_slots(state,
+								    params[next_index].port->mgr,
+								    params[next_index].port,
+								    vars[next_index].pbn);
+				if (ret < 0)
+					return ret;
 			}
 		} else {
 			vars[next_index].pbn += initial_slack[next_index];
-			if (drm_dp_atomic_find_time_slots(state,
-							  params[next_index].port->mgr,
-							  params[next_index].port,
-							  vars[next_index].pbn) < 0)
-				return false;
-			if (!drm_dp_mst_atomic_check(state)) {
+			ret = drm_dp_atomic_find_time_slots(state,
+							    params[next_index].port->mgr,
+							    params[next_index].port,
+							    vars[next_index].pbn);
+			if (ret < 0)
+				return ret;
+
+			ret = drm_dp_mst_atomic_check(state);
+			if (ret == 0) {
 				vars[next_index].bpp_x16 = params[next_index].bw_range.max_target_bpp_x16;
 			} else {
 				vars[next_index].pbn -= initial_slack[next_index];
-				if (drm_dp_atomic_find_time_slots(state,
-								  params[next_index].port->mgr,
-								  params[next_index].port,
-								  vars[next_index].pbn) < 0)
-					return false;
+				ret = drm_dp_atomic_find_time_slots(state,
+								    params[next_index].port->mgr,
+								    params[next_index].port,
+								    vars[next_index].pbn);
+				if (ret < 0)
+					return ret;
 			}
 		}
 
 		bpp_increased[next_index] = true;
 		remaining_to_increase--;
 	}
-	return true;
+	return 0;
 }
 
-static bool try_disable_dsc(struct drm_atomic_state *state,
-			    struct dc_link *dc_link,
-			    struct dsc_mst_fairness_params *params,
-			    struct dsc_mst_fairness_vars *vars,
-			    int count,
-			    int k)
+static int try_disable_dsc(struct drm_atomic_state *state,
+			   struct dc_link *dc_link,
+			   struct dsc_mst_fairness_params *params,
+			   struct dsc_mst_fairness_vars *vars,
+			   int count,
+			   int k)
 {
 	int i;
 	bool tried[MAX_PIPES];
@@ -810,6 +819,7 @@ static bool try_disable_dsc(struct drm_atomic_state *state,
 	int max_kbps_increase;
 	int next_index;
 	int remaining_to_try = 0;
+	int ret;
 
 	for (i = 0; i < count; i++) {
 		if (vars[i + k].dsc_enabled
@@ -840,49 +850,52 @@ static bool try_disable_dsc(struct drm_atomic_state *state,
 			break;
 
 		vars[next_index].pbn = kbps_to_peak_pbn(params[next_index].bw_range.stream_kbps);
-		if (drm_dp_atomic_find_time_slots(state,
-						  params[next_index].port->mgr,
-						  params[next_index].port,
-						  vars[next_index].pbn) < 0)
-			return false;
+		ret = drm_dp_atomic_find_time_slots(state,
+						    params[next_index].port->mgr,
+						    params[next_index].port,
+						    vars[next_index].pbn);
+		if (ret < 0)
+			return ret;
 
-		if (!drm_dp_mst_atomic_check(state)) {
+		ret = drm_dp_mst_atomic_check(state);
+		if (ret == 0) {
 			vars[next_index].dsc_enabled = false;
 			vars[next_index].bpp_x16 = 0;
 		} else {
 			vars[next_index].pbn = kbps_to_peak_pbn(params[next_index].bw_range.max_kbps);
-			if (drm_dp_atomic_find_time_slots(state,
-							  params[next_index].port->mgr,
-							  params[next_index].port,
-							  vars[next_index].pbn) < 0)
-				return false;
+			ret = drm_dp_atomic_find_time_slots(state,
+							    params[next_index].port->mgr,
+							    params[next_index].port,
+							    vars[next_index].pbn);
+			if (ret < 0)
+				return ret;
 		}
 
 		tried[next_index] = true;
 		remaining_to_try--;
 	}
-	return true;
+	return 0;
 }
 
-static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
-					     struct dc_state *dc_state,
-					     struct dc_link *dc_link,
-					     struct dsc_mst_fairness_vars *vars,
-					     struct drm_dp_mst_topology_mgr *mgr,
-					     int *link_vars_start_index)
+static int compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
+					    struct dc_state *dc_state,
+					    struct dc_link *dc_link,
+					    struct dsc_mst_fairness_vars *vars,
+					    struct drm_dp_mst_topology_mgr *mgr,
+					    int *link_vars_start_index)
 {
 	struct dc_stream_state *stream;
 	struct dsc_mst_fairness_params params[MAX_PIPES];
 	struct amdgpu_dm_connector *aconnector;
 	struct drm_dp_mst_topology_state *mst_state = drm_atomic_get_mst_topology_state(state, mgr);
 	int count = 0;
-	int i, k;
+	int i, k, ret;
 	bool debugfs_overwrite = false;
 
 	memset(params, 0, sizeof(params));
 
 	if (IS_ERR(mst_state))
-		return false;
+		return PTR_ERR(mst_state);
 
 	mst_state->pbn_div = dm_mst_get_pbn_divider(dc_link);
 #if defined(CONFIG_DRM_AMD_DC_DCN)
@@ -933,7 +946,7 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 
 	if (count == 0) {
 		ASSERT(0);
-		return true;
+		return 0;
 	}
 
 	/* k is start index of vars for current phy link used by mst hub */
@@ -947,13 +960,17 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 		vars[i + k].pbn = kbps_to_peak_pbn(params[i].bw_range.stream_kbps);
 		vars[i + k].dsc_enabled = false;
 		vars[i + k].bpp_x16 = 0;
-		if (drm_dp_atomic_find_time_slots(state, params[i].port->mgr, params[i].port,
-						  vars[i + k].pbn) < 0)
-			return false;
+		ret = drm_dp_atomic_find_time_slots(state, params[i].port->mgr, params[i].port,
+						    vars[i + k].pbn);
+		if (ret < 0)
+			return ret;
 	}
-	if (!drm_dp_mst_atomic_check(state) && !debugfs_overwrite) {
+	ret = drm_dp_mst_atomic_check(state);
+	if (ret == 0 && !debugfs_overwrite) {
 		set_dsc_configs_from_fairness_vars(params, vars, count, k);
-		return true;
+		return 0;
+	} else if (ret != -ENOSPC) {
+		return ret;
 	}
 
 	/* Try max compression */
@@ -962,31 +979,36 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 			vars[i + k].pbn = kbps_to_peak_pbn(params[i].bw_range.min_kbps);
 			vars[i + k].dsc_enabled = true;
 			vars[i + k].bpp_x16 = params[i].bw_range.min_target_bpp_x16;
-			if (drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
-							  params[i].port, vars[i + k].pbn) < 0)
-				return false;
+			ret = drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
+							    params[i].port, vars[i + k].pbn);
+			if (ret < 0)
+				return ret;
 		} else {
 			vars[i + k].pbn = kbps_to_peak_pbn(params[i].bw_range.stream_kbps);
 			vars[i + k].dsc_enabled = false;
 			vars[i + k].bpp_x16 = 0;
-			if (drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
-							  params[i].port, vars[i + k].pbn) < 0)
-				return false;
+			ret = drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
+							    params[i].port, vars[i + k].pbn);
+			if (ret < 0)
+				return ret;
 		}
 	}
-	if (drm_dp_mst_atomic_check(state))
-		return false;
+	ret = drm_dp_mst_atomic_check(state);
+	if (ret != 0)
+		return ret;
 
 	/* Optimize degree of compression */
-	if (!increase_dsc_bpp(state, mst_state, dc_link, params, vars, count, k))
-		return false;
+	ret = increase_dsc_bpp(state, mst_state, dc_link, params, vars, count, k);
+	if (ret < 0)
+		return ret;
 
-	if (!try_disable_dsc(state, dc_link, params, vars, count, k))
-		return false;
+	ret = try_disable_dsc(state, dc_link, params, vars, count, k);
+	if (ret < 0)
+		return ret;
 
 	set_dsc_configs_from_fairness_vars(params, vars, count, k);
 
-	return true;
+	return 0;
 }
 
 static bool is_dsc_need_re_compute(
@@ -1087,15 +1109,16 @@ static bool is_dsc_need_re_compute(
 	return is_dsc_need_re_compute;
 }
 
-bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
-				       struct dc_state *dc_state,
-				       struct dsc_mst_fairness_vars *vars)
+int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
+				      struct dc_state *dc_state,
+				      struct dsc_mst_fairness_vars *vars)
 {
 	int i, j;
 	struct dc_stream_state *stream;
 	bool computed_streams[MAX_PIPES];
 	struct amdgpu_dm_connector *aconnector;
 	int link_vars_start_index = 0;
+	int ret = 0;
 
 	for (i = 0; i < dc_state->stream_count; i++)
 		computed_streams[i] = false;
@@ -1118,17 +1141,19 @@ bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 			continue;
 
 		if (dcn20_remove_stream_from_ctx(stream->ctx->dc, dc_state, stream) != DC_OK)
-			return false;
+			return -EINVAL;
 
 		if (!is_dsc_need_re_compute(state, dc_state, stream->link))
 			continue;
 
 		mutex_lock(&aconnector->mst_mgr.lock);
-		if (!compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars,
-						      &aconnector->mst_mgr,
-						      &link_vars_start_index)) {
+
+		ret = compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars,
+						       &aconnector->mst_mgr,
+						       &link_vars_start_index);
+		if (ret != 0) {
 			mutex_unlock(&aconnector->mst_mgr.lock);
-			return false;
+			return ret;
 		}
 		mutex_unlock(&aconnector->mst_mgr.lock);
 
@@ -1143,22 +1168,22 @@ bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 
 		if (stream->timing.flags.DSC == 1)
 			if (dc_stream_add_dsc_to_resource(stream->ctx->dc, dc_state, stream) != DC_OK)
-				return false;
+				return -EINVAL;
 	}
 
-	return true;
+	return ret;
 }
 
-static bool
-	pre_compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
-					      struct dc_state *dc_state,
-					      struct dsc_mst_fairness_vars *vars)
+static int pre_compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
+						 struct dc_state *dc_state,
+						 struct dsc_mst_fairness_vars *vars)
 {
 	int i, j;
 	struct dc_stream_state *stream;
 	bool computed_streams[MAX_PIPES];
 	struct amdgpu_dm_connector *aconnector;
 	int link_vars_start_index = 0;
+	int ret;
 
 	for (i = 0; i < dc_state->stream_count; i++)
 		computed_streams[i] = false;
@@ -1184,11 +1209,12 @@ static bool
 			continue;
 
 		mutex_lock(&aconnector->mst_mgr.lock);
-		if (!compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars,
-						      &aconnector->mst_mgr,
-						      &link_vars_start_index)) {
+		ret = compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars,
+						       &aconnector->mst_mgr,
+						       &link_vars_start_index);
+		if (ret != 0) {
 			mutex_unlock(&aconnector->mst_mgr.lock);
-			return false;
+			return ret;
 		}
 		mutex_unlock(&aconnector->mst_mgr.lock);
 
@@ -1198,7 +1224,7 @@ static bool
 		}
 	}
 
-	return true;
+	return ret;
 }
 
 static int find_crtc_index_in_state_by_stream(struct drm_atomic_state *state,
@@ -1253,9 +1279,9 @@ static bool is_dsc_precompute_needed(struct drm_atomic_state *state)
 	return ret;
 }
 
-bool pre_validate_dsc(struct drm_atomic_state *state,
-		      struct dm_atomic_state **dm_state_ptr,
-		      struct dsc_mst_fairness_vars *vars)
+int pre_validate_dsc(struct drm_atomic_state *state,
+		     struct dm_atomic_state **dm_state_ptr,
+		     struct dsc_mst_fairness_vars *vars)
 {
 	int i;
 	struct dm_atomic_state *dm_state;
@@ -1264,11 +1290,12 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
 
 	if (!is_dsc_precompute_needed(state)) {
 		DRM_INFO_ONCE("DSC precompute is not needed.\n");
-		return true;
+		return 0;
 	}
-	if (dm_atomic_get_state(state, dm_state_ptr)) {
+	ret = dm_atomic_get_state(state, dm_state_ptr);
+	if (ret != 0) {
 		DRM_INFO_ONCE("dm_atomic_get_state() failed\n");
-		return false;
+		return ret;
 	}
 	dm_state = *dm_state_ptr;
 
@@ -1280,7 +1307,7 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
 
 	local_dc_state = kmemdup(dm_state->context, sizeof(struct dc_state), GFP_KERNEL);
 	if (!local_dc_state)
-		return false;
+		return -ENOMEM;
 
 	for (i = 0; i < local_dc_state->stream_count; i++) {
 		struct dc_stream_state *stream = dm_state->context->streams[i];
@@ -1316,9 +1343,9 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
 	if (ret != 0)
 		goto clean_exit;
 
-	if (!pre_compute_mst_dsc_configs_for_state(state, local_dc_state, vars)) {
+	ret = pre_compute_mst_dsc_configs_for_state(state, local_dc_state, vars);
+	if (ret != 0) {
 		DRM_INFO_ONCE("pre_compute_mst_dsc_configs_for_state() failed\n");
-		ret = -EINVAL;
 		goto clean_exit;
 	}
 
@@ -1349,7 +1376,7 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
 
 	kfree(local_dc_state);
 
-	return (ret == 0);
+	return ret;
 }
 
 static unsigned int kbps_from_pbn(unsigned int pbn)
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
index b92a7c5671aa..97fd70df531b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
@@ -53,15 +53,15 @@ struct dsc_mst_fairness_vars {
 	struct amdgpu_dm_connector *aconnector;
 };
 
-bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
-				       struct dc_state *dc_state,
-				       struct dsc_mst_fairness_vars *vars);
+int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
+				      struct dc_state *dc_state,
+				      struct dsc_mst_fairness_vars *vars);
 
 bool needs_dsc_aux_workaround(struct dc_link *link);
 
-bool pre_validate_dsc(struct drm_atomic_state *state,
-		      struct dm_atomic_state **dm_state_ptr,
-		      struct dsc_mst_fairness_vars *vars);
+int pre_validate_dsc(struct drm_atomic_state *state,
+		     struct dm_atomic_state **dm_state_ptr,
+		     struct dsc_mst_fairness_vars *vars);
 
 enum dc_status dm_dp_mst_is_port_support_mode(
 	struct amdgpu_dm_connector *aconnector,

