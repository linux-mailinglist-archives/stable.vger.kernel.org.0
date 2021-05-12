Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8329E37B99B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhELJuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:50:51 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:51663 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhELJuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:50:50 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3DF661940EB1;
        Wed, 12 May 2021 05:49:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 05:49:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PReRNv
        1UG+ctg6NCIc70iMSr5U1WY+Jd/c4d8Bv3Coc=; b=kG9sSbnpW8s5Yii/OOmPXy
        Vxjp8tssX/6N6Vb+aGy2EOK+BWgWrl7peJ1D1HT7JWPPG2euRYJJmJKG9IQJaW7X
        WkKIuyH4edCZMa4YNLvXEx9fC3cy7q9BQiTqD7He0OiuMw+qtCEsQgvMsY5V2pGP
        afAEs2AMJm/mrXbqCo45voZwHj4Nfx0R6IlH3zz64FeHkurrq9M8RbUEUOMqJ4xz
        ftHiGrOPcl41e6Fko2wwipunGDteKLEBCdsPd8+Cr/tQrSB8qEgjNIRsCx1qHOgI
        m9bqRMXL+sYyzmBdwHAgnniko3iuB2A2UInlNkUB8o8agmvEHkoCl7QT40/zcHiQ
        ==
X-ME-Sender: <xms:tqSbYHcVwHOQ-zdlVnO0_vNWu1I7TI3aKXsEiB_cYQ6P5_oxQvpptA>
    <xme:tqSbYNMpvB947E3OOKZ3iFaiaOpGpKuy2DUjGGAGpGheEu1PbLXVI4FCaHqC8Vdrh
    nlOA2__xAtH9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:tqSbYAi5lRDyFHXizM5-1qKYaGyvWHBeG7vJEgxF5PF_cWwfssp7ow>
    <xmx:tqSbYI9kQFynprFyhpW24SwA6x-XDIZ-CgKIv2Kk_pMm5lBo2bDwYg>
    <xmx:tqSbYDsP2xPZvFet5pUS1vA4gpKjVsdtTGjvnuXcXv6asqQCEnALaA>
    <xmx:tqSbYM6oBDOWHN--DN5GPwjW1a70vvUYAEpBdpwzE0IKNy9VfDcY4A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:49:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amd/display: Fix system hang after multiple hotplugs (v3)" failed to apply to 5.12-stable tree
To:     qingqing.zhuo@amd.com, alexander.deucher@amd.com, bindu.r@amd.com,
        daniel.wheeler@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:49:40 +0200
Message-ID: <162081298013848@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d7faf6f5347baec5cc774f3d46557f8782d87ee9 Mon Sep 17 00:00:00 2001
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
index a7713c2a3f31..9de5b28af8be 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -938,7 +938,49 @@ static void mmhub_read_system_context(struct amdgpu_device *adev, struct dc_phy_
 
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
@@ -958,6 +1000,9 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 
 	mutex_init(&adev->dm.dc_lock);
 	mutex_init(&adev->dm.audio_lock);
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+	spin_lock_init(&adev->dm.vblank_lock);
+#endif
 
 	if(amdgpu_dm_irq_init(adev)) {
 		DRM_ERROR("amdgpu: failed to initialize DM IRQ support.\n");
@@ -1072,6 +1117,17 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 
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
@@ -5376,7 +5432,10 @@ static inline int dm_set_vblank(struct drm_crtc *crtc, bool enable)
 	struct amdgpu_crtc *acrtc = to_amdgpu_crtc(crtc);
 	struct amdgpu_device *adev = drm_to_adev(crtc->dev);
 	struct dm_crtc_state *acrtc_state = to_dm_crtc_state(crtc->state);
+#if defined(CONFIG_DRM_AMD_DC_DCN)
 	struct amdgpu_display_manager *dm = &adev->dm;
+	unsigned long flags;
+#endif
 	int rc = 0;
 
 	if (enable) {
@@ -5399,22 +5458,15 @@ static inline int dm_set_vblank(struct drm_crtc *crtc, bool enable)
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
index 0bb974ca89ed..bbf68cb6cfec 100644
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
 

