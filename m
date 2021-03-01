Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20DE327B83
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhCAKF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:05:59 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:36335 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231919AbhCAKE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:04:59 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id B63861940E70;
        Mon,  1 Mar 2021 05:03:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:03:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Vaw5YQ
        5Iul4yNkkN5lz44h/4tyo7UDdQz1k666aFTrE=; b=c2LtbZZCvFoXFY0Zk3GkcZ
        UB0gQnzFU2/hUed8Tx07ZonXjvFNIQq1eEFTQ5ni7aPF7NLBLYfoHCRwmWy22kvU
        AC792/tl8azYAG+gkSH6LxsR1S8VmWF0h++pP9ddL6jCVaafZzm976gSCZdnTsy5
        +5ruAHByF2RBwMuS0oVaD0PS1ibkh3tAG+ulyo2G7CajruA5E1NOwIb+6GVBVtOb
        KPN0my1VZn7po3TqNvYEUeRcNssM/C/Ij3DuP5lXamC9VgDvnhtiw75jhHaTnEw3
        HyXAGd770hcIGag/Ve19TiWLHi05XZepaZ1gU7TT4v4k4ccA2afzxXdGWsomGi5g
        ==
X-ME-Sender: <xms:6bs8YEm58Jfbr2PX3_HaCkFsmtcLGvvpeAaBPXw8egefzojteVq82A>
    <xme:6bs8YD2WOF2hVdw_FsGH2PHsv1Pal27DXPxpCHAVOm35gqmNMHDywLF3pu5VJlx-W
    qhLubXAEiIVnw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:6bs8YCoer-XNc8_gdKcXUHspLVx5gOylojlqp30qQZ8FUqNo-OPRRw>
    <xmx:6bs8YAkARaBk4S9pFgEy1HL0pZFZ5umG-FkLnXEc8FiOEDJBKnN5-g>
    <xmx:6bs8YC3e-E2FOToota1xC9DAxywWMJgQ1tTN1Gsm_DdTPUjhw__XkQ>
    <xmx:6bs8YACkXmvkp3nBh_4cCkv471POMSz0Fmr1FUgMa7y4-fmFzsfj_Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 62AF21080066;
        Mon,  1 Mar 2021 05:03:21 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amd/display: Fix system hang after multiple hotplugs (v3)" failed to apply to 5.10-stable tree
To:     qingqing.zhuo@amd.com, alexander.deucher@amd.com, bindu.r@amd.com,
        daniel.wheeler@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:03:11 +0100
Message-ID: <1614592991955@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ea3b4242bc9ca197762119382b37e125815bd67f Mon Sep 17 00:00:00 2001
From: Qingqing Zhuo <qingqing.zhuo@amd.com>
Date: Tue, 9 Feb 2021 16:36:41 -0500
Subject: [PATCH] drm/amd/display: Fix system hang after multiple hotplugs (v3)

[Why]
mutex_lock() was introduced in dm_disable_vblank(), which could
be called in an IRQ context. Waiting in IRQ would cause issues
like kernel lockup, etc.

[How]
Handle code that requires mutex lock on a different thread.

v2: squash in compilation fix without CONFIG_DRM_AMD_DC_DCN (Alex)
v3: squash in warning fix (Wei)

Signed-off-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Acked-by: Bindu Ramamurthy <bindu.r@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 344404c4ac75..3e1fd1e7d09f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -937,7 +937,49 @@ static void mmhub_read_system_context(struct amdgpu_device *adev, struct dc_phy_
 
 }
 #endif
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+static void event_mall_stutter(struct work_struct *work)
+{
+
+	struct vblank_workqueue *vblank_work = container_of(work, struct vblank_workqueue, mall_work);
+	struct amdgpu_display_manager *dm = vblank_work->dm;
+
+	mutex_lock(&dm->dc_lock);
+
+	if (vblank_work->enable)
+		dm->active_vblank_irq_count++;
+	else
+		dm->active_vblank_irq_count--;
+
+
+	dc_allow_idle_optimizations(
+		dm->dc, dm->active_vblank_irq_count == 0 ? true : false);
+
+	DRM_DEBUG_DRIVER("Allow idle optimizations (MALL): %d\n", dm->active_vblank_irq_count == 0);
+
+
+	mutex_unlock(&dm->dc_lock);
+}
+
+static struct vblank_workqueue *vblank_create_workqueue(struct amdgpu_device *adev, struct dc *dc)
+{
+
+	int max_caps = dc->caps.max_links;
+	struct vblank_workqueue *vblank_work;
+	int i = 0;
+
+	vblank_work = kcalloc(max_caps, sizeof(*vblank_work), GFP_KERNEL);
+	if (ZERO_OR_NULL_PTR(vblank_work)) {
+		kfree(vblank_work);
+		return NULL;
+	}
 
+	for (i = 0; i < max_caps; i++)
+		INIT_WORK(&vblank_work[i].mall_work, event_mall_stutter);
+
+	return vblank_work;
+}
+#endif
 static int amdgpu_dm_init(struct amdgpu_device *adev)
 {
 	struct dc_init_data init_data;
@@ -957,6 +999,9 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 
 	mutex_init(&adev->dm.dc_lock);
 	mutex_init(&adev->dm.audio_lock);
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+	spin_lock_init(&adev->dm.vblank_lock);
+#endif
 
 	if(amdgpu_dm_irq_init(adev)) {
 		DRM_ERROR("amdgpu: failed to initialize DM IRQ support.\n");
@@ -1071,6 +1116,17 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 
 	amdgpu_dm_init_color_mod();
 
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+	if (adev->dm.dc->caps.max_links > 0) {
+		adev->dm.vblank_workqueue = vblank_create_workqueue(adev, adev->dm.dc);
+
+		if (!adev->dm.vblank_workqueue)
+			DRM_ERROR("amdgpu: failed to initialize vblank_workqueue.\n");
+		else
+			DRM_DEBUG_DRIVER("amdgpu: vblank_workqueue init done %p.\n", adev->dm.vblank_workqueue);
+	}
+#endif
+
 #ifdef CONFIG_DRM_AMD_DC_HDCP
 	if (adev->dm.dc->caps.max_links > 0 && adev->asic_type >= CHIP_RAVEN) {
 		adev->dm.hdcp_workqueue = hdcp_create_workqueue(adev, &init_params.cp_psp, adev->dm.dc);
@@ -5375,7 +5431,10 @@ static inline int dm_set_vblank(struct drm_crtc *crtc, bool enable)
 	struct amdgpu_crtc *acrtc = to_amdgpu_crtc(crtc);
 	struct amdgpu_device *adev = drm_to_adev(crtc->dev);
 	struct dm_crtc_state *acrtc_state = to_dm_crtc_state(crtc->state);
+#if defined(CONFIG_DRM_AMD_DC_DCN)
 	struct amdgpu_display_manager *dm = &adev->dm;
+	unsigned long flags;
+#endif
 	int rc = 0;
 
 	if (enable) {
@@ -5398,22 +5457,15 @@ static inline int dm_set_vblank(struct drm_crtc *crtc, bool enable)
 	if (amdgpu_in_reset(adev))
 		return 0;
 
-	mutex_lock(&dm->dc_lock);
-
-	if (enable)
-		dm->active_vblank_irq_count++;
-	else
-		dm->active_vblank_irq_count--;
-
 #if defined(CONFIG_DRM_AMD_DC_DCN)
-	dc_allow_idle_optimizations(
-		adev->dm.dc, dm->active_vblank_irq_count == 0 ? true : false);
-
-	DRM_DEBUG_DRIVER("Allow idle optimizations (MALL): %d\n", dm->active_vblank_irq_count == 0);
+	spin_lock_irqsave(&dm->vblank_lock, flags);
+	dm->vblank_workqueue->dm = dm;
+	dm->vblank_workqueue->otg_inst = acrtc->otg_inst;
+	dm->vblank_workqueue->enable = enable;
+	spin_unlock_irqrestore(&dm->vblank_lock, flags);
+	schedule_work(&dm->vblank_workqueue->mall_work);
 #endif
 
-	mutex_unlock(&dm->dc_lock);
-
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index f72930c36c22..8bfe901cf237 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -92,6 +92,20 @@ struct dm_compressor_info {
 	uint64_t gpu_addr;
 };
 
+/**
+ * struct vblank_workqueue - Works to be executed in a separate thread during vblank
+ * @mall_work: work for mall stutter
+ * @dm: amdgpu display manager device
+ * @otg_inst: otg instance of which vblank is being set
+ * @enable: true if enable vblank
+ */
+struct vblank_workqueue {
+	struct work_struct mall_work;
+	struct amdgpu_display_manager *dm;
+	int otg_inst;
+	bool enable;
+};
+
 /**
  * struct amdgpu_dm_backlight_caps - Information about backlight
  *
@@ -243,6 +257,15 @@ struct amdgpu_display_manager {
 	 */
 	struct mutex audio_lock;
 
+	/**
+	 * @vblank_work_lock:
+	 *
+	 * Guards access to deferred vblank work state.
+	 */
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+	spinlock_t vblank_lock;
+#endif
+
 	/**
 	 * @audio_component:
 	 *
@@ -321,6 +344,10 @@ struct amdgpu_display_manager {
 	struct hdcp_workqueue *hdcp_workqueue;
 #endif
 
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+	struct vblank_workqueue *vblank_workqueue;
+#endif
+
 	struct drm_atomic_state *cached_state;
 	struct dc_state *cached_dc_state;
 

