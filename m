Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70A935E1F8
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 16:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhDMOzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 10:55:10 -0400
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:54475 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231784AbhDMOzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 10:55:09 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 50F001655;
        Tue, 13 Apr 2021 10:54:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 13 Apr 2021 10:54:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm2; bh=y7qDDAzlUljmf
        gJcvMpwcbUGoLqCPc7XoRlkwckx1nU=; b=RXNYoaDTJaocwXez05Mqjssz/5KJe
        8tPNIa+LTjZWwb+nkk7AE82IQvxEeI+jdqX9uKh4DpgOA5yMsHcEOh0jg6tOvKrl
        qfrZ+wUyQNZ12bT8JtVNMFUvmlXlrtb0+yntQIT7OzEG+HgGZVOIbteGx7/iG1n+
        V8Er8FwrWJJeIF75yVnBIR9MHl7iQO1e2oORINxPsGPomJPeSIIGlS47KZDMVGU8
        Xf04UzyOFSuIZgfcNbA28so/Rt/BaIhtsoovHVjL3BkcnQOxDHJi04gwdmV0SPu0
        ZoCn9z3q4PWzw7iScF/JDGHEzKZij5On1eauEeH+7SgV9WuaYp0fNN/ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=y7qDDAzlUljmfgJcvMpwcbUGoLqCPc7XoRlkwckx1nU=; b=B6ve7cm0
        AhwmcqBiSddqezNdFFpHHRd8nS4d1NnbNp1ywXOOOFKeUutLiaa2q+P7t6efBuGj
        9oogIe1ALNIMkgRgRBXJ0S3+BSj10m4FKMNyGCl4CdSjOd/tL75E+3xPFWaaZ7lP
        SyYQdQSE3bWklnknbaqwLE/w31gRcuRw37F/y77MEFW9vOGAY9whZ9ts+vOseFVQ
        CZg5sTyT+PHVpjhxYDO92XBWqIz1lGrj2KqpsF5uHTApkhe1KA2wak1TWsWQnXta
        kULQV7M3wRAJ9heUbZYNtxJ72BoG0bHzJb/FRM9H78hq9tZHHFN+swB3P/AYlOKG
        gAJKW73MObW8yg==
X-ME-Sender: <xms:t7B1YPFnFfBr3aDrlclCavKcwRTTUNhOIge3xYqBQoskPAgFvP6g5A>
    <xme:t7B1YMXjoYwObFjr6YGlBfWcmlgOMne_oOLR1Qbo3GVxH9AtxMBfa0FUs40UPElXm
    gjBi4AFMqh16OG_9U0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekledgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepvdekleevfeffkeejhfffueelteelfeduieefheduudfggffhhfffheevveeh
    hedvnecukfhppeeltddrkeelrdeikedrjeeinecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:t7B1YBJRjRrHYZ082f6jtLJFjpnOLWRWuhgKNxpxOp52TZkc-NGq1w>
    <xmx:t7B1YNEcfeJVUzXALqGjK3G2olf9OYbA0q3vRg3-4DXWwRV91mpt6A>
    <xmx:t7B1YFXPGOL22HSBeSWg6n7jB_LiVkzLWP1jAdzkVv_RZJMidZxvdw>
    <xmx:t7B1YOPg1fwMsJYmFJM-GRPzt5418XPjTOC0GbwiDdcWhnLdAUyq55xg35s>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7B0D7240067;
        Tue, 13 Apr 2021 10:54:47 -0400 (EDT)
From:   Maxime Ripard <maxime@cerno.tech>
To:     dri-devel@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Maxime Ripard <maxime@cerno.tech>
Cc:     Phil Elwell <phil@raspberrypi.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Tim Gover <tim.gover@raspberrypi.com>,
        linux-rpi-kernel@lists.infradead.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        bcm-kernel-feedback-list@broadcom.com, stable@vger.kernel.org
Subject: [PATCH v3 2/9] drm/vc4: crtc: Skip the TXP
Date:   Tue, 13 Apr 2021 16:54:34 +0200
Message-Id: <20210413145441.483977-3-maxime@cerno.tech>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210413145441.483977-1-maxime@cerno.tech>
References: <20210413145441.483977-1-maxime@cerno.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The vc4_set_crtc_possible_masks is meant to run over all the encoders
and then set their possible_crtcs mask to their associated pixelvalve.

However, since the commit 39fcb2808376 ("drm/vc4: txp: Turn the TXP into
a CRTC of its own"), the TXP has been turned to a CRTC and encoder of
its own, and while it does indeed register an encoder, it no longer has
an associated pixelvalve. The code will thus run over the TXP encoder
and set a bogus possible_crtcs mask, overriding the one set in the TXP
bind function.

In order to fix this, let's skip any virtual encoder.

Cc: <stable@vger.kernel.org> # v5.9+
Fixes: 39fcb2808376 ("drm/vc4: txp: Turn the TXP into a CRTC of its own")
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
---
 drivers/gpu/drm/vc4/vc4_crtc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_crtc.c b/drivers/gpu/drm/vc4/vc4_crtc.c
index 269390bc586e..f1f2e8cbce79 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -1018,6 +1018,9 @@ static void vc4_set_crtc_possible_masks(struct drm_device *drm,
 		struct vc4_encoder *vc4_encoder;
 		int i;
 
+		if (encoder->encoder_type == DRM_MODE_ENCODER_VIRTUAL)
+			continue;
+
 		vc4_encoder = to_vc4_encoder(encoder);
 		for (i = 0; i < ARRAY_SIZE(pv_data->encoder_types); i++) {
 			if (vc4_encoder->type == encoder_types[i]) {
-- 
2.30.2

