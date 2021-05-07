Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F92037678D
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 17:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbhEGPGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 11:06:37 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:44291 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233118AbhEGPGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 11:06:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 5EF3612F1;
        Fri,  7 May 2021 11:05:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 07 May 2021 11:05:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm2; bh=SudjKN4UEIfT0
        /YepqLSU7wGC8AZ2ev0B9T1BBipTNo=; b=hTxsRX3EMtYdRvmlUd//K/1rRCnDq
        GyPlEGIJgnGKxjnzHFVMKtNJJrfTUzLD1YBbOc4GUkyg1UAtLC16Es9ixefWB0+s
        rd/GmOcCUgq7/b5D5eJUjsloCV39E2XVW/C+y8D3TJSfbmlWW2HbvxqfuK9q+jqQ
        R8eX04NsqQ4X6jCJtgPPTCMQiwfPdhYsucxjyO2xktz267BhAh49KgL3ybayERSz
        Ic1ekCDKKNLxZpuX6QAEGFEqSRua3kSzKXBMdDUK0LR71uf1emMgkv+pMh2tviKx
        dM+XM/zar5qj+C4ItbVhyNKg6tM/imyn301GKXq87EEmQwS7UCRK9rOGw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=SudjKN4UEIfT0/YepqLSU7wGC8AZ2ev0B9T1BBipTNo=; b=godHAfnM
        WQ6z2L4vdd7zmXh7icV7eubwRH6D0uvIwQej6n/ou71lxzzrPqWLn0n7U5Z8WSqL
        xypasSrvTzfUjDYGdU/DESLQ26MOdkciW+8rW6yW/Qs9Uxmwj+A6eUVCGRKNscPN
        ZkSiCXprnPIcOw4PyDrfKaHbzNYHxJeJ9+8yCWJ/W4bBa3QMQ2GD9cTEXiLPvlw7
        HJCYYMY58Or55R6/QCEf+3Nkwzunni7OGiGBNyXOnSrV3dNbjxa/NdY832izchIB
        YfnR/agzLBVjsNL5TQFtdoHHFKcXflBTb2W3cvO++sMXutwqP2pI3Xmte2oiCVFh
        sIN6Vc40O1eLBg==
X-ME-Sender: <xms:PFeVYDgrdbELTTm8NXAucsDrTyKz54AdqnPZgKIoF8aRnNal1RIzJw>
    <xme:PFeVYADTTYNo5LN0aRK2liMw358XEKYVr2f3ZZ91-XGJ4o8VPgJszXEVF82HKkRQ2
    CgH7gSoto-HZ7XVpXo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegvddgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepvdekleevfeffkeejhfffueelteelfeduieefheduudfggffhhfffheevveeh
    hedvnecukfhppeeltddrkeelrdeikedrjeeinecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:PFeVYDEvFU_W0InTm2ip4mD8KkKJNTMsd-8C_k9WFZ20-3pdJptCdw>
    <xmx:PFeVYASKevie-TnDlTxiaopxEsml4BwW6HSQVxjYe_NnZHBpoNSohQ>
    <xmx:PFeVYAwgINTpR_dy3U2EUxKa4X4Jt-t8zvJkhWaQnL4N6mGt_-GZlw>
    <xmx:PVeVYMj-uecn1JodmrgoYH5lFsd3yGxQfm-_VSL6uVHaSmVov3z3EBPLRBM>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri,  7 May 2021 11:05:32 -0400 (EDT)
From:   Maxime Ripard <maxime@cerno.tech>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Maxime Ripard <maxime@cerno.tech>,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Phil Elwell <phil@raspberrypi.com>,
        Tim Gover <tim.gover@raspberrypi.com>,
        Dom Cobley <dom@raspberrypi.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v4 02/12] drm/vc4: crtc: Skip the TXP
Date:   Fri,  7 May 2021 17:05:05 +0200
Message-Id: <20210507150515.257424-3-maxime@cerno.tech>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210507150515.257424-1-maxime@cerno.tech>
References: <20210507150515.257424-1-maxime@cerno.tech>
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
2.31.1

