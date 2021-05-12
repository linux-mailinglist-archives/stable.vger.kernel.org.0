Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C6437B981
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhELJrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:47:39 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:52437 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230102AbhELJrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:47:36 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 4319B140F;
        Wed, 12 May 2021 05:46:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 12 May 2021 05:46:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=64qZ+T
        pbPBCrsvqBA4jGbAhaNMKk+ohFH3EsbSUdrBc=; b=j9tL32BsGg4gYEI91OjRkA
        XeCAMTEQkTFX8GTAKpeu8fcr9BArb/obQPPgXfIzQdAVXwcPCkRvdjkBdu4++vw2
        9bI8lyXTqcUOXb7axL1fae8poHkIzTRehjoW1vXqlv/JCZ6laiOdrdd9nsHXM+R/
        8k5vR3utlJT70AzO907mE3Huc5xHbs2ABISAQ8RfPLjlsEIilbXO23gim661Hugg
        WxHJH0aWNFIZZ0t5FKep1ow6sSrvH40l4VgQN6fu4g9Aeq2bia2Y3pb0nh2YqqFt
        i1eFPt6Q3DMYOKgeqUU0w7pO91yK9MHxcrTc10Sw/+NrFMgtwAYAP/YJK4etd5vg
        ==
X-ME-Sender: <xms:86ObYE1pMJcGDV8V6KUHnwZlSvzBsyfH6ahWwcaoPXEJpPzPnm2tUg>
    <xme:86ObYPEfKv-r_7o2z_fxwkBb045swWEZZpf1y78YL-EGQUKYXHcrdKeT1tyiutClc
    aq3nbRPDrVY9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:86ObYM53LuVplU3rKiBlLISgXpQpBr6UceLKzyJbrq5hClSKXCYooA>
    <xmx:86ObYN2CN682rK-cvKZ1GDZdtF11hasbPbidNmy5OeovNIPNm9EjLQ>
    <xmx:86ObYHEKNQDocvqV6R6Lnb2GILmuoXyL-it1FwQQg_ELqfDMItjFqQ>
    <xmx:86ObYM67bgauuRQp6v77KByglmMNzjJa18S7UPkMZRiyq1m0YeSYIlGWQ-Y>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:46:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm: bridge/panel: Cleanup connector on bridge detach" failed to apply to 4.14-stable tree
To:     paul@crapouillou.net, Laurent.pinchart@ideasonboard.com,
        a.hajda@samsung.com, jernej.skrabec@siol.net, jonas@kwiboo.se,
        laurent.pinchart@ideasonboard.com, narmstrong@baylibre.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:46:14 +0200
Message-ID: <162081277452121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

