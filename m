Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5293537B97D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhELJr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:47:26 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:42735 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhELJrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:47:25 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 90A5213BB;
        Wed, 12 May 2021 05:46:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 12 May 2021 05:46:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fmIbIz
        py7ev8o4awYs/qKM8v0vueNHj2H5Te+lpn0F4=; b=LSJkGn6IMF/Q0miJ8xZA5M
        z1b3TNEIxhkYr2Ze/bjGI5DooxL1v3J9xK7SlQcCVXOAoduPPBDscqeArxhKTAmD
        eV3n5r4HzoOkMR/dY9Wmu2cxap5SYEauGKoU2Kp1sNU+fUFxktBaDEOWbV7DF/pU
        3RYo4JG657PdEaY/kvryJzlFZkwRk1ZGWlOXHeyHUTfWobSbuMPa31hLKDdDJyVI
        RIWT/Z0WenqmkwHgbSytU1HDMq1BXKvYpn7MjqvO9xrMlhboJbKD8atP+8Ll+NAL
        CjmqJca3wumZi9tShUDCOFHi9+t/4TdPTyoEX/NAdKUE013WXADH5M2SCTuu9OIQ
        ==
X-ME-Sender: <xms:56ObYAaNi33xc5ZRcnPcPwnmZ3J34Qfwd_G3GbBhXjMa4fzKze7XgQ>
    <xme:56ObYLaLnFLfJynygBirRfnR_gkUqnkyRzgLr5x6KKG7uckafo6rjoR--Qp70YR7l
    X9F6fbF5VnzUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:56ObYK9YVWmTu293C51En4u9Z2TwSI49zJsjlk14MdXoTKjestFqTA>
    <xmx:56ObYKpoO0_b_xRRu5gnI3r3EbOIdUmUOapscyFErp2oAhqXF5HSzw>
    <xmx:56ObYLoQUEEiU_ORLFIxBsPDnmp5sV3zwNnswaWltqD4mGhqNlQPLA>
    <xmx:6KObYMc_rskhCGMZqCu2U73eaG4mvTCpOEfeM2VB8uerDRnDHRABmmzJ_Dg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:46:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm: bridge/panel: Cleanup connector on bridge detach" failed to apply to 5.4-stable tree
To:     paul@crapouillou.net, Laurent.pinchart@ideasonboard.com,
        a.hajda@samsung.com, jernej.skrabec@siol.net, jonas@kwiboo.se,
        laurent.pinchart@ideasonboard.com, narmstrong@baylibre.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:46:13 +0200
Message-ID: <1620812773249232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

