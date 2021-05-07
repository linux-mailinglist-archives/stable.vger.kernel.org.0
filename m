Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F049376787
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 17:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237774AbhEGPGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 11:06:30 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:35871 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237769AbhEGPGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 11:06:30 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 46732FE2;
        Fri,  7 May 2021 11:05:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 07 May 2021 11:05:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm2; bh=GpLrgkM4UcgJ2
        ZncyBkTt4vzSey6iyoCO+a1izkj+do=; b=idR6iW+4fFGSILzHvtWmDXEXYP3JG
        mobWDryv93DqyY7kHHTt/ayPngv1YnSElGxWfnPnBoT5v6EPfW24aPYgF+IVOvxO
        aXUtMkSsGuknyy4E4pV8os+U9j+uIAhCkMzq5iEbwRUFmvMKfYBK1wVxw+eRRERf
        5ge2Y0hN7W3jGe7/mDnCamL8jPP14P0ET/QuGCLp28SmfWlW7Qt9xcGkgroMNSK0
        6Pn+nNzxS5L+RepzymJlJ+7mnPWxomU9Fec4Q+8bxfLp3U3E9GT2mnvJOTdf6k0X
        uVg3cWAuzrWIae9WAMZLjfWoLgTxebDVxt0IH2cgojd9ioQcERaQ+f9ow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=GpLrgkM4UcgJ2ZncyBkTt4vzSey6iyoCO+a1izkj+do=; b=cgZiISm6
        v98u2ZPDP73GXeNfCkZIYeohv5LD6Yd5SZU0MW83Ob9MGzR04enBhbsoi56ybYdY
        68+Pom4YXFhe51WHJlJgIYGKUNfJwg7uAfzpR7YMTHyIz3m9LXvuyK3TjatW7CdP
        3aLw5v0OnNI13rOxfaixE7WKZ1htmYnH2KHzSQOzP2NJNfH35Pteb2Sq7W04BI7i
        Bnq9T74w9YZaZB9AJMh2HmLWA/MDf3nsH1nAKTAIsDoSYpnWg1lZ7OgCpfJInRzy
        WpNyMg2WkRJfQbUUmO6vOgAjt/TTwQ1ltzUJmqw6V5t63DApkC0E3RJgYeYHi0oT
        NXXYK0TSonHeIg==
X-ME-Sender: <xms:OFeVYH1V1Kl5cw1H_ZyjDdpqIedgRdRkmhAQfo_8bDPaeWSoJu48GQ>
    <xme:OFeVYGHQaJEVdyrhPqo6R0t-X_w3zdeFlMF1cbx3gokJwqbZIXhPr1jo7Gq6IXRHe
    mrfxzWMAVWv79JgZp4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegvddgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepvdekleevfeffkeejhfffueelteelfeduieefheduudfggffhhfffheevveeh
    hedvnecukfhppeeltddrkeelrdeikedrjeeinecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:OFeVYH43pEOsHFyQgjs5r7CNRQxNKXIq6v6OtOthwL1bQWXRcGXf5Q>
    <xmx:OFeVYM1A0gcuWVAkwVbjhmmoXh_wHvTYbxQU8pTrZskBaN0v0LdIvQ>
    <xmx:OFeVYKGJ_flQ-SdMy58hjlt3fspKmvW37XmlqyybsmaP16Ckh8cnOQ>
    <xmx:OFeVYGEBpVclnZZ28_coDLpngfEKcRTnGZxLExeY6dYHJdZFHHhOb6hIULY>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri,  7 May 2021 11:05:28 -0400 (EDT)
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
Subject: [PATCH v4 01/12] drm/vc4: txp: Properly set the possible_crtcs mask
Date:   Fri,  7 May 2021 17:05:04 +0200
Message-Id: <20210507150515.257424-2-maxime@cerno.tech>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210507150515.257424-1-maxime@cerno.tech>
References: <20210507150515.257424-1-maxime@cerno.tech>
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
2.31.1

