Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4905E37B97E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhELJrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:47:36 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:47967 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230109AbhELJrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:47:35 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 381BB1311;
        Wed, 12 May 2021 05:46:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 05:46:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/b9O+r
        jAxRcMg5EBbVpKEo40s0QdSm3lzfWweIH4DYY=; b=vxGd5FEbAcyXhMUuWCNlS6
        LjnLkeeiJxneu4+PSHtNBVW009mnQgkCDXOHkQLIoGeRmGL1sEGnqfwQL089YgX9
        h+5yWcAANwhc+PbhIIrBQ17888TUsbDCZZTQ4+7HLdsDBVerB5hO1FRItF1+0+Z5
        A4FO8J0oz7tlrIWAC+uMuKdbMZ9CE7KEbqQxXH0mXapW1OKfoxzv1s1zEPQrSw9m
        vo4jzedXH/LZhk1HboPPNN6b7nvyJp60C1XzGfEAmoM5LWkMBqGl9Apr0XX3OWsP
        kyBl8ksLlUL+qFek7ncX2Htgj5U56uB0c66iZrvaXgfi10vMLet0SWsTOgiGmvDw
        ==
X-ME-Sender: <xms:8KObYGhAiEQ1leuufJ0u2I9YDYlaF8ORNbW6rQdEc74WbCEO_Uo3ig>
    <xme:8KObYHD4tm9K5T6a_EXD9mMPqg9RzKd97Qdp-2gH4GKV5PGzd3nea6DtvQQs6HXJP
    1GiTJnyHRwXbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:8KObYOG_vBLHx-XqrB5gzGKxFXBk8nCIx_mRl_GnjigR1nwrXrScXA>
    <xmx:8KObYPREEdWoumC05EUanguLLqrwb_PNPb8koTPxUasIcLw8n9UoOQ>
    <xmx:8KObYDxYgaEHfdnLKaN_PbkNNDSR_p3hm8SxQOivThS8K1THhBADRg>
    <xmx:8KObYKmPplGC4TBEoLtrM2s5pGyxkSLlipD91WIjQdpbZaPo43rOcQhFZqY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:46:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm: bridge/panel: Cleanup connector on bridge detach" failed to apply to 4.19-stable tree
To:     paul@crapouillou.net, Laurent.pinchart@ideasonboard.com,
        a.hajda@samsung.com, jernej.skrabec@siol.net, jonas@kwiboo.se,
        laurent.pinchart@ideasonboard.com, narmstrong@baylibre.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:46:13 +0200
Message-ID: <16208127736999@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4d906839d321c2efbf3fed4bc31ffd9ff55b75c0 Mon Sep 17 00:00:00 2001
From: Paul Cercueil <paul@crapouillou.net>
Date: Sat, 27 Mar 2021 11:57:40 +0000
Subject: [PATCH] drm: bridge/panel: Cleanup connector on bridge detach

If we don't call drm_connector_cleanup() manually in
panel_bridge_detach(), the connector will be cleaned up with the other
DRM objects in the call to drm_mode_config_cleanup(). However, since our
drm_connector is devm-allocated, by the time drm_mode_config_cleanup()
will be called, our connector will be long gone. Therefore, the
connector must be cleaned up when the bridge is detached to avoid
use-after-free conditions.

v2: Cleanup connector only if it was created

v3: Add FIXME

v4: (Use connector->dev) directly in if() block

Fixes: 13dfc0540a57 ("drm/bridge: Refactor out the panel wrapper from the lvds-encoder bridge.")
Cc: <stable@vger.kernel.org> # 4.12+
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Jonas Karlman <jonas@kwiboo.se>
Cc: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210327115742.18986-2-paul@crapouillou.net

diff --git a/drivers/gpu/drm/bridge/panel.c b/drivers/gpu/drm/bridge/panel.c
index 0ddc37551194..c916f4b8907e 100644
--- a/drivers/gpu/drm/bridge/panel.c
+++ b/drivers/gpu/drm/bridge/panel.c
@@ -87,6 +87,18 @@ static int panel_bridge_attach(struct drm_bridge *bridge,
 
 static void panel_bridge_detach(struct drm_bridge *bridge)
 {
+	struct panel_bridge *panel_bridge = drm_bridge_to_panel_bridge(bridge);
+	struct drm_connector *connector = &panel_bridge->connector;
+
+	/*
+	 * Cleanup the connector if we know it was initialized.
+	 *
+	 * FIXME: This wouldn't be needed if the panel_bridge structure was
+	 * allocated with drmm_kzalloc(). This might be tricky since the
+	 * drm_device pointer can only be retrieved when the bridge is attached.
+	 */
+	if (connector->dev)
+		drm_connector_cleanup(connector);
 }
 
 static void panel_bridge_pre_enable(struct drm_bridge *bridge)

