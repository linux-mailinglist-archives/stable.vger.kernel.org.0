Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61462A8250
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 16:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730721AbgKEPf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 10:35:59 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:41339 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730943AbgKEPf7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 10:35:59 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 7FA64E95;
        Thu,  5 Nov 2020 10:35:58 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 05 Nov 2020 10:35:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=2wZrMX
        KS1zX34cFtlZqid1/GRMqfyD2PD3/DGbGpz7s=; b=R2IOr/W6aYle/RSQvggMHC
        9ERJz0nNB+3O80uM7xPMFuKGOUPTjdQlkOsJyBupCHX1mOvS8SDawWL2oD6g85qr
        E6TqGrWu4C8DqW7C9AFi6IT/+wc/FPxpI1j4h4KvaQCrReN3QK8pBBMRKTfRyyps
        1bWJmUgS0qfnREhKSqUKt2F2SCC5AIKplbosXbzBYGKTx6WX1o8ExSh5Aq4It8yh
        PGE/DSJXXLn2M+JS2f0iF05ULrx9soNP4u30PCxVfc/4gpJ5HYnCJXlK9JyMuhWG
        4SlWyh7TeNoJ0OtZozReuugVqoVsPwv0EMvQly1cGlzH+f553of23fFwxpUMZ4qg
        ==
X-ME-Sender: <xms:3RukXz3I4p1yN4yD4A1BAJGMFMeA8PCcaox3zLEVZLBsnCVeL3OgGQ>
    <xme:3RukXyEsqL8mlUhTL_23sFYxdvoKaIiDujhxTWU7lNJ3NY9EFZZTazdRCEltf-aOY
    jW7BhzSyU10vA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtjedgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:3RukXz7IDPYY2Iv9n50zrVdg9gbncVKiSgWIDVxwzssYTkTQQgpuow>
    <xmx:3RukX41iZOFmk59uzD54dQauMVhap78_uMs1UAEHksFIgvPEjb1d6w>
    <xmx:3RukX2FoiIRBKODsOD6tOytog9h3jVAHsreP3bsSVccNtCrA2Igumg>
    <xmx:3hukX4NS3lMNh5Q96niIBrgsOKlEP_nEVPhDRP159NoX56lzEZ3hJ24lAsE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7CF03306005F;
        Thu,  5 Nov 2020 10:35:57 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/nouveau/kms/nv50-: Get rid of bogus" failed to apply to 5.9-stable tree
To:     lyude@redhat.com, bskeggs@redhat.com, stable@vger.kernel.org,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 05 Nov 2020 16:36:47 +0100
Message-ID: <160459060724988@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2d831155cf0607566e43d8465da33774b2dc7221 Mon Sep 17 00:00:00 2001
From: Lyude Paul <lyude@redhat.com>
Date: Tue, 29 Sep 2020 18:31:31 -0400
Subject: [PATCH] drm/nouveau/kms/nv50-: Get rid of bogus
 nouveau_conn_mode_valid()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Ville also pointed out that I got a lot of the logic here wrong as well, whoops.
While I don't think anyone's likely using 3D output with nouveau, the next patch
will make nouveau_conn_mode_valid() make a lot less sense. So, let's just get
rid of it and open-code it like before, while taking care to move the 3D frame
packing calculations on the dot clock into the right place.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: d6a9efece724 ("drm/nouveau/kms/nv50-: Share DP SST mode_valid() handling with MST")
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.8+
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 49dd0cbc332f..6f21f36719fc 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -1023,29 +1023,6 @@ get_tmds_link_bandwidth(struct drm_connector *connector)
 		return 112000 * duallink_scale;
 }
 
-enum drm_mode_status
-nouveau_conn_mode_clock_valid(const struct drm_display_mode *mode,
-			      const unsigned min_clock,
-			      const unsigned max_clock,
-			      unsigned int *clock_out)
-{
-	unsigned int clock = mode->clock;
-
-	if ((mode->flags & DRM_MODE_FLAG_3D_MASK) ==
-	    DRM_MODE_FLAG_3D_FRAME_PACKING)
-		clock *= 2;
-
-	if (clock < min_clock)
-		return MODE_CLOCK_LOW;
-	if (clock > max_clock)
-		return MODE_CLOCK_HIGH;
-
-	if (clock_out)
-		*clock_out = clock;
-
-	return MODE_OK;
-}
-
 static enum drm_mode_status
 nouveau_connector_mode_valid(struct drm_connector *connector,
 			     struct drm_display_mode *mode)
@@ -1053,7 +1030,7 @@ nouveau_connector_mode_valid(struct drm_connector *connector,
 	struct nouveau_connector *nv_connector = nouveau_connector(connector);
 	struct nouveau_encoder *nv_encoder = nv_connector->detected_encoder;
 	struct drm_encoder *encoder = to_drm_encoder(nv_encoder);
-	unsigned min_clock = 25000, max_clock = min_clock;
+	unsigned int min_clock = 25000, max_clock = min_clock, clock = mode->clock;
 
 	switch (nv_encoder->dcb->type) {
 	case DCB_OUTPUT_LVDS:
@@ -1082,8 +1059,15 @@ nouveau_connector_mode_valid(struct drm_connector *connector,
 		return MODE_BAD;
 	}
 
-	return nouveau_conn_mode_clock_valid(mode, min_clock, max_clock,
-					     NULL);
+	if ((mode->flags & DRM_MODE_FLAG_3D_MASK) == DRM_MODE_FLAG_3D_FRAME_PACKING)
+		clock *= 2;
+
+	if (clock < min_clock)
+		return MODE_CLOCK_LOW;
+	if (clock > max_clock)
+		return MODE_CLOCK_HIGH;
+
+	return MODE_OK;
 }
 
 static struct drm_encoder *
diff --git a/drivers/gpu/drm/nouveau/nouveau_dp.c b/drivers/gpu/drm/nouveau/nouveau_dp.c
index 7b640e05bd4c..93e3751ad7f1 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
@@ -232,12 +232,14 @@ nv50_dp_mode_valid(struct drm_connector *connector,
 		   unsigned *out_clock)
 {
 	const unsigned min_clock = 25000;
-	unsigned max_clock, ds_clock, clock;
-	enum drm_mode_status ret;
+	unsigned max_clock, ds_clock, clock = mode->clock;
 
 	if (mode->flags & DRM_MODE_FLAG_INTERLACE && !outp->caps.dp_interlace)
 		return MODE_NO_INTERLACE;
 
+	if ((mode->flags & DRM_MODE_FLAG_3D_MASK) == DRM_MODE_FLAG_3D_FRAME_PACKING)
+		clock *= 2;
+
 	max_clock = outp->dp.link_nr * outp->dp.link_bw;
 	ds_clock = drm_dp_downstream_max_dotclock(outp->dp.dpcd,
 						  outp->dp.downstream_ports);
@@ -245,9 +247,13 @@ nv50_dp_mode_valid(struct drm_connector *connector,
 		max_clock = min(max_clock, ds_clock);
 
 	clock = mode->clock * (connector->display_info.bpc * 3) / 10;
-	ret = nouveau_conn_mode_clock_valid(mode, min_clock, max_clock,
-					    &clock);
+	if (clock < min_clock)
+		return MODE_CLOCK_LOW;
+	if (clock > max_clock)
+		return MODE_CLOCK_HIGH;
+
 	if (out_clock)
 		*out_clock = clock;
-	return ret;
+
+	return MODE_OK;
 }

