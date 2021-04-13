Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F3A35E1F7
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 16:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhDMOzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 10:55:09 -0400
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:45321 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231721AbhDMOzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 10:55:09 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id A48B22D5;
        Tue, 13 Apr 2021 10:54:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 13 Apr 2021 10:54:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm2; bh=WTTxhz7TT0y6m
        FK14ROq7Hd8G4QJsosdSX03P/4q+SQ=; b=W1f+iG5AQRFA7Rqci6l/PLRA3pk/j
        3ii7OB73GBXFjrjnd5SVrIAQtDcJqASqW/3lX7lQQS3oFBKUk1jWYmJxIYlmpUE8
        o3O05Hwj2IcMqD8tmQNqOrE8GqSfLOGMGwDgnmS73yTftsP35bLr9XZPsRS8DMby
        VJNXDsKPTkeiGpWRWENkI0kpCjEgvHl9lQkcBUxAKMUtgSC8jecoVWOG0wJvYj45
        xPQcbpVeRK+auS3VK1F43sae6UGbt2jP76cheV6JaKXVAFq5BtMMks84oZNcmDMx
        oJI39MhIOZ0u/qZf84UJzkOtxmNNdREh+Mzhh8ck6ukCcgp9bkm/R16qg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=WTTxhz7TT0y6mFK14ROq7Hd8G4QJsosdSX03P/4q+SQ=; b=Ei1JX/Bf
        bStkwigCilkmw9rKo2AuX748DFFs+lyM7RaFM3RY+NlXOhpc5RQpG1FcCqaUbJl5
        uaDiR+sBI9gnDFe2jB8HUSd6vDwqWyt4/kQSN2LY8xm7rddefhSnrs0KC+HYICto
        e1uYEBhoLPwT6gEvIZ2reIqw7r75imKq/ajYtS0VGNxfnkDcV+ojuuW1pNvhtYMQ
        03AqR5sa45CZmytS2ZB1JKrDXPcCnjM6xF5Q388JmDGNTqRRCKOFWxDJ+f5lBdwF
        dr1FmCCprXKQv3diYtiz/RSz7n/b7w9HWO5TDs4rhBJFaM8zoqgavOgoaaGdLdPv
        7n+x+zoXN1AIfg==
X-ME-Sender: <xms:trB1YABDtPii95SlqoDpHTupGQ-6Evqtq7XrnxgksU1ssvaFfGXerw>
    <xme:trB1YCij6OSPhTest40MM2KjyQ10mH_0KSvHhMtUZeX-C1IKx6rrLAutzy_7GkvZz
    i19q2R1bRPJxv30njs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekledgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepvdekleevfeffkeejhfffueelteelfeduieefheduudfggffhhfffheevveeh
    hedvnecukfhppeeltddrkeelrdeikedrjeeinecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:trB1YDnA44nMK_RqC2IrBe_Z5KW4W3UP97EvxafbIvE3rneErChuQQ>
    <xmx:trB1YGx6Gzytfwbemj3L0so0uwuaTQwH_onNZwkZ2T2wx4eHw5fxjw>
    <xmx:trB1YFTsgwfOYnLL868QF7O05h5UguThCoOlTc_gbKqqfsyTv1iTPA>
    <xmx:t7B1YKI7zhaJQRWxOVPUxUu_uVNB8LitRbgCIZpItAnsG4Hut4Qk1maQ1CE>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id DB31F24005E;
        Tue, 13 Apr 2021 10:54:45 -0400 (EDT)
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
Subject: [PATCH v3 1/9] drm/vc4: txp: Properly set the possible_crtcs mask
Date:   Tue, 13 Apr 2021 16:54:33 +0200
Message-Id: <20210413145441.483977-2-maxime@cerno.tech>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210413145441.483977-1-maxime@cerno.tech>
References: <20210413145441.483977-1-maxime@cerno.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The current code does a binary OR on the possible_crtcs variable of the
TXP encoder, while we want to set it to that value instead.

Cc: <stable@vger.kernel.org> # v5.9+
Fixes: 39fcb2808376 ("drm/vc4: txp: Turn the TXP into a CRTC of its own")
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
---
 drivers/gpu/drm/vc4/vc4_txp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_txp.c b/drivers/gpu/drm/vc4/vc4_txp.c
index c0122d83b651..2fc7f4b5fa09 100644
--- a/drivers/gpu/drm/vc4/vc4_txp.c
+++ b/drivers/gpu/drm/vc4/vc4_txp.c
@@ -507,7 +507,7 @@ static int vc4_txp_bind(struct device *dev, struct device *master, void *data)
 		return ret;
 
 	encoder = &txp->connector.encoder;
-	encoder->possible_crtcs |= drm_crtc_mask(crtc);
+	encoder->possible_crtcs = drm_crtc_mask(crtc);
 
 	ret = devm_request_irq(dev, irq, vc4_txp_interrupt, 0,
 			       dev_name(dev), txp);
-- 
2.30.2

