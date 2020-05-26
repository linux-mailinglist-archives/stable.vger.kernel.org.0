Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7201DF730
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 14:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731298AbgEWMWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 08:22:48 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:47955 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731291AbgEWMWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 May 2020 08:22:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 92D9919416B1;
        Sat, 23 May 2020 08:22:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 23 May 2020 08:22:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=d6G713
        yYgwfYrYouRL9zRWi11WwffORJqxJBMK4YzdU=; b=TcvOhqiu//6TVkEukoJeuE
        cjArvwsb6AwQoljlCfOn78/kyWEPAxqh6PfXG5wpTQVpEMi1kkmQ0UOsRiKEQ0uX
        FRQg9oGNdNWZNbE45u6MSNVOY/bO+X/2dRq8Fsp+/VcYxyCXdniyfWfD2R1Q2fPK
        JtLAtQeN8MH9Ftl5h5TzNYgpmYP1exi3S2iLEHCv4wbARkM74x0/M/WBnn+oU5Wr
        BefZVUjtNjRPAv942e6lo+4BYZw5+LXvuBn9/d72fe4PNqxCXVSibO7RLobwlpTR
        pv2g0mFIBvCh0qEA5HYa6PQ9MyCL/8VeKr66U8gSxpVravAM3Cz/fmJcjSMAv18g
        ==
X-ME-Sender: <xms:lhXJXkKnfAN7oNE6GBb74BH9DSi4X_t9FaTFBmSHw-aC7kC8bjvd8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduhedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieffjeffudevvdeijeehgeeflefffeffvddvieevte
    egjeegfeeuffevfffgtedvnecuffhomhgrihhnpehlihgrmhgurdgtohhmnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:lhXJXkKfJi-Ym7JjMYmjLb7jcsR-zr8rfAylpOjgX_guiocVPEEofg>
    <xmx:lhXJXktzv8qkXV1I19ouoDYAgWPQmN8CcX68Pw7Njl2yXXBPRVsc6g>
    <xmx:lhXJXhblIO33kb1ieFU8WXoTVCSVTam0COdhdZk6oE_hhcFuFltvtQ>
    <xmx:lhXJXiw9C-Hc0NO5a2MCGy9YXuTXtA1_xb12AggsxvFxz_RJWRxWlw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 22EE130664B6;
        Sat, 23 May 2020 08:22:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amd/display: Fix vblank and pageflip event handling for" failed to apply to 5.6-stable tree
To:     nicholas.kazlauskas@amd.com, alexander.deucher@amd.com,
        mario.kleiner.de@gmail.com, sunpeng.li@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 23 May 2020 14:22:10 +0200
Message-ID: <159023653076174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2346ef47e871536cf4e36b77859bfdeb39b49024 Mon Sep 17 00:00:00 2001
From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Date: Wed, 6 May 2020 15:47:54 -0400
Subject: [PATCH] drm/amd/display: Fix vblank and pageflip event handling for
 FreeSync

[Why]
We're sending the drm vblank event a frame too early in the case where
the pageflip happens close to VUPDATE and ends up blocking the signal.

The implementation in DM was previously correct *before* we started
sending vblank events from VSTARTUP unconditionally to handle cases
where HUBP was off, OTG was ON and userspace was still requesting some
DRM planes enabled. As part of that patch series we dropped VUPDATE
since it was deemed close enough to VSTARTUP, but there's a key
difference betweeen VSTARTUP and VUPDATE - the VUPDATE signal can be
blocked if we're holding the pipe lock.

There was a fix recently to revert the unconditional behavior for the
DCN VSTARTUP vblank event since it was sending the pageflip event on
the wrong frame - once again, due to blocking VUPDATE and having the
address start scanning out two frames later.

The problem with this fix is it didn't update the logic that calls
drm_crtc_handle_vblank(), so the timestamps are totally bogus now.

[How]
Essentially reverts most of the original VSTARTUP series but retains
the behavior to send back events when active planes == 0.

Some refactoring/cleanup was done to not have duplicated code in both
the handlers.

Fixes: 16f17eda8bad ("drm/amd/display: Send vblank and user events at vsartup for DCN")
Fixes: 3a2ce8d66a4b ("drm/amd/display: Disable VUpdate interrupt for DCN hardware")
Fixes: 2b5aed9ac3f7 ("drm/amd/display: Fix pageflip event race condition for DCN.")

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-and-Tested-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.6.x

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 9c83c1303f08..c3df6ef9f101 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -441,7 +441,7 @@ static void dm_vupdate_high_irq(void *interrupt_params)
 
 /**
  * dm_crtc_high_irq() - Handles CRTC interrupt
- * @interrupt_params: ignored
+ * @interrupt_params: used for determining the CRTC instance
  *
  * Handles the CRTC/VSYNC interrupt by notfying DRM's VBLANK
  * event handler.
@@ -455,70 +455,6 @@ static void dm_crtc_high_irq(void *interrupt_params)
 	unsigned long flags;
 
 	acrtc = get_crtc_by_otg_inst(adev, irq_params->irq_src - IRQ_TYPE_VBLANK);
-
-	if (acrtc) {
-		acrtc_state = to_dm_crtc_state(acrtc->base.state);
-
-		DRM_DEBUG_VBL("crtc:%d, vupdate-vrr:%d\n",
-			      acrtc->crtc_id,
-			      amdgpu_dm_vrr_active(acrtc_state));
-
-		/* Core vblank handling at start of front-porch is only possible
-		 * in non-vrr mode, as only there vblank timestamping will give
-		 * valid results while done in front-porch. Otherwise defer it
-		 * to dm_vupdate_high_irq after end of front-porch.
-		 */
-		if (!amdgpu_dm_vrr_active(acrtc_state))
-			drm_crtc_handle_vblank(&acrtc->base);
-
-		/* Following stuff must happen at start of vblank, for crc
-		 * computation and below-the-range btr support in vrr mode.
-		 */
-		amdgpu_dm_crtc_handle_crc_irq(&acrtc->base);
-
-		if (acrtc_state->stream && adev->family >= AMDGPU_FAMILY_AI &&
-		    acrtc_state->vrr_params.supported &&
-		    acrtc_state->freesync_config.state == VRR_STATE_ACTIVE_VARIABLE) {
-			spin_lock_irqsave(&adev->ddev->event_lock, flags);
-			mod_freesync_handle_v_update(
-				adev->dm.freesync_module,
-				acrtc_state->stream,
-				&acrtc_state->vrr_params);
-
-			dc_stream_adjust_vmin_vmax(
-				adev->dm.dc,
-				acrtc_state->stream,
-				&acrtc_state->vrr_params.adjust);
-			spin_unlock_irqrestore(&adev->ddev->event_lock, flags);
-		}
-	}
-}
-
-#if defined(CONFIG_DRM_AMD_DC_DCN)
-/**
- * dm_dcn_crtc_high_irq() - Handles VStartup interrupt for DCN generation ASICs
- * @interrupt params - interrupt parameters
- *
- * Notify DRM's vblank event handler at VSTARTUP
- *
- * Unlike DCE hardware, we trigger the handler at VSTARTUP. at which:
- * * We are close enough to VUPDATE - the point of no return for hw
- * * We are in the fixed portion of variable front porch when vrr is enabled
- * * We are before VUPDATE, where double-buffered vrr registers are swapped
- *
- * It is therefore the correct place to signal vblank, send user flip events,
- * and update VRR.
- */
-static void dm_dcn_crtc_high_irq(void *interrupt_params)
-{
-	struct common_irq_params *irq_params = interrupt_params;
-	struct amdgpu_device *adev = irq_params->adev;
-	struct amdgpu_crtc *acrtc;
-	struct dm_crtc_state *acrtc_state;
-	unsigned long flags;
-
-	acrtc = get_crtc_by_otg_inst(adev, irq_params->irq_src - IRQ_TYPE_VBLANK);
-
 	if (!acrtc)
 		return;
 
@@ -528,22 +464,35 @@ static void dm_dcn_crtc_high_irq(void *interrupt_params)
 			 amdgpu_dm_vrr_active(acrtc_state),
 			 acrtc_state->active_planes);
 
+	/**
+	 * Core vblank handling at start of front-porch is only possible
+	 * in non-vrr mode, as only there vblank timestamping will give
+	 * valid results while done in front-porch. Otherwise defer it
+	 * to dm_vupdate_high_irq after end of front-porch.
+	 */
+	if (!amdgpu_dm_vrr_active(acrtc_state))
+		drm_crtc_handle_vblank(&acrtc->base);
+
+	/**
+	 * Following stuff must happen at start of vblank, for crc
+	 * computation and below-the-range btr support in vrr mode.
+	 */
 	amdgpu_dm_crtc_handle_crc_irq(&acrtc->base);
-	drm_crtc_handle_vblank(&acrtc->base);
+
+	/* BTR updates need to happen before VUPDATE on Vega and above. */
+	if (adev->family < AMDGPU_FAMILY_AI)
+		return;
 
 	spin_lock_irqsave(&adev->ddev->event_lock, flags);
 
-	if (acrtc_state->vrr_params.supported &&
+	if (acrtc_state->stream && acrtc_state->vrr_params.supported &&
 	    acrtc_state->freesync_config.state == VRR_STATE_ACTIVE_VARIABLE) {
-		mod_freesync_handle_v_update(
-		adev->dm.freesync_module,
-		acrtc_state->stream,
-		&acrtc_state->vrr_params);
+		mod_freesync_handle_v_update(adev->dm.freesync_module,
+					     acrtc_state->stream,
+					     &acrtc_state->vrr_params);
 
-		dc_stream_adjust_vmin_vmax(
-			adev->dm.dc,
-			acrtc_state->stream,
-			&acrtc_state->vrr_params.adjust);
+		dc_stream_adjust_vmin_vmax(adev->dm.dc, acrtc_state->stream,
+					   &acrtc_state->vrr_params.adjust);
 	}
 
 	/*
@@ -556,7 +505,8 @@ static void dm_dcn_crtc_high_irq(void *interrupt_params)
 	 * avoid race conditions between flip programming and completion,
 	 * which could cause too early flip completion events.
 	 */
-	if (acrtc->pflip_status == AMDGPU_FLIP_SUBMITTED &&
+	if (adev->family >= AMDGPU_FAMILY_RV &&
+	    acrtc->pflip_status == AMDGPU_FLIP_SUBMITTED &&
 	    acrtc_state->active_planes == 0) {
 		if (acrtc->event) {
 			drm_crtc_send_vblank_event(&acrtc->base, acrtc->event);
@@ -568,7 +518,6 @@ static void dm_dcn_crtc_high_irq(void *interrupt_params)
 
 	spin_unlock_irqrestore(&adev->ddev->event_lock, flags);
 }
-#endif
 
 static int dm_set_clockgating_state(void *handle,
 		  enum amd_clockgating_state state)
@@ -2445,8 +2394,36 @@ static int dcn10_register_irq_handlers(struct amdgpu_device *adev)
 		c_irq_params->adev = adev;
 		c_irq_params->irq_src = int_params.irq_source;
 
+		amdgpu_dm_irq_register_interrupt(
+			adev, &int_params, dm_crtc_high_irq, c_irq_params);
+	}
+
+	/* Use VUPDATE_NO_LOCK interrupt on DCN, which seems to correspond to
+	 * the regular VUPDATE interrupt on DCE. We want DC_IRQ_SOURCE_VUPDATEx
+	 * to trigger at end of each vblank, regardless of state of the lock,
+	 * matching DCE behaviour.
+	 */
+	for (i = DCN_1_0__SRCID__OTG0_IHC_V_UPDATE_NO_LOCK_INTERRUPT;
+	     i <= DCN_1_0__SRCID__OTG0_IHC_V_UPDATE_NO_LOCK_INTERRUPT + adev->mode_info.num_crtc - 1;
+	     i++) {
+		r = amdgpu_irq_add_id(adev, SOC15_IH_CLIENTID_DCE, i, &adev->vupdate_irq);
+
+		if (r) {
+			DRM_ERROR("Failed to add vupdate irq id!\n");
+			return r;
+		}
+
+		int_params.int_context = INTERRUPT_HIGH_IRQ_CONTEXT;
+		int_params.irq_source =
+			dc_interrupt_to_irq_source(dc, i, 0);
+
+		c_irq_params = &adev->dm.vupdate_params[int_params.irq_source - DC_IRQ_SOURCE_VUPDATE1];
+
+		c_irq_params->adev = adev;
+		c_irq_params->irq_src = int_params.irq_source;
+
 		amdgpu_dm_irq_register_interrupt(adev, &int_params,
-				dm_dcn_crtc_high_irq, c_irq_params);
+				dm_vupdate_high_irq, c_irq_params);
 	}
 
 	/* Use GRPH_PFLIP interrupt */
@@ -4453,10 +4430,6 @@ static inline int dm_set_vupdate_irq(struct drm_crtc *crtc, bool enable)
 	struct amdgpu_device *adev = crtc->dev->dev_private;
 	int rc;
 
-	/* Do not set vupdate for DCN hardware */
-	if (adev->family > AMDGPU_FAMILY_AI)
-		return 0;
-
 	irq_source = IRQ_TYPE_VUPDATE + acrtc->otg_inst;
 
 	rc = dc_interrupt_set(adev->dm.dc, irq_source, enable) ? 0 : -EBUSY;

