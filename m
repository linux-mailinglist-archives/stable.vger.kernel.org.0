Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06870158A5F
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 08:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbgBKH3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 02:29:03 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:48331 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727606AbgBKH3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Feb 2020 02:29:02 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 840095A5;
        Tue, 11 Feb 2020 02:29:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 11 Feb 2020 02:29:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=GtHTk2RJu6ujK
        xGwOZdHmLSPh4ENhg+lM6RYpGuUwsI=; b=EeFeyeCnNikgZ/mwO8W3XIA7IFkP6
        0il+viaFu+mjgVlBJMH0mPyqXKGWHSeYP491tV4QusuLUlgDzSPS4tmIdg6kvEHU
        K7513JqSaXdQQEDbqfJ9VRCLkrz9xCTRpJ3HKh7+ZPkl5iun3leNYj06Y+JJFZbv
        9Hg+OOq+UqF+qotIGJC4XN0WfBVWLE0XStd4zGkh8szxHZ9aV7ONDVTG8MNbTymp
        p4cOAHeHyLyLS5SzHmArs8kB2s4cLxkuJ+lmIlG8CXEV1BO0MIaP2lb2ajANANEK
        f/yu1tAwx3tNNoQI10M2C2iVO7pKodUH0aNUgmfZQP2twGPjFS9B42k9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=GtHTk2RJu6ujKxGwOZdHmLSPh4ENhg+lM6RYpGuUwsI=; b=D7gI5VkL
        iX6ikPA39rL8UMUdHIcNhFRRHEnQ8jRhXTB4xdLbt2wvBphLtEzt57TH3XGLW4+V
        6tTrLk0M/iiSJtlBk/Z+m7JqZINKl1mq4qNKSmieA2jkYfQaToATdYOCpgpnwoR4
        an1uBJ9NsYdizF3C07n/AEFs/7iflafPwNA3H4WKhe3vKrTXLx2saw6ydbJg9r5t
        B8g+DGPk9bmaij6WKYGdAxcnirvH6k6HSUunDjXQZ+DA4zhXO8eE+3T38X+4W0Gv
        yN8HqP6SN9yEugY8K3gW19A6klWsYeRrPM18yQWnw3VIJ6wAssSiEzuqS/zFe1Y9
        cDVOYQtjCuPhfw==
X-ME-Sender: <xms:vFdCXiPFNc07AZQ1Ir4o_IuV-azfo0LybARY5sHnen_yNgBnZXun_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedriedvgddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucfkph
    epjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghnugdrohhrgh
X-ME-Proxy: <xmx:vFdCXgaGreCNiS0kIMFQbEOeApwj09b-46AxLGPfYS06PziZeBDnPQ>
    <xmx:vFdCXqV5_uVly2AXVUFETcPjtBOAQJa9GugC7GYvK4qrUfQQyDYJlA>
    <xmx:vFdCXnB8avwbuLkHGy46NX44NteUkCgrrcwifDnffpWBvdExu4jowQ>
    <xmx:vVdCXhH9HksXZb-NMta0O8VFbg7NkCPZR3-iGXK0ZT3RlGUS8kPHtw>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id F1C583060940;
        Tue, 11 Feb 2020 02:28:59 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>
Subject: [PATCH 3/4] drm/sun4i: dsi: Allow binding the host without a panel
Date:   Tue, 11 Feb 2020 01:28:57 -0600
Message-Id: <20200211072858.30784-3-samuel@sholland.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211072858.30784-1-samuel@sholland.org>
References: <20200211072858.30784-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, the DSI host blocks binding the display pipeline until the
panel is available. This unnecessarily prevents other display outpus
from working, and adds logspam to dmesg when the panel driver is built
as a module (the component master is unsuccessfully brought up several
times during boot).

Flip the dependency, instead requiring the host to be bound before the
panel is attached. The panel driver provides no functionality outside of
the display pipeline anyway.

Since the panel is now probed after the DRM connector, we need a hotplug
event to turn on the connector after the panel is attached.

This has the added benefit of fixing panel module removal/insertion.
Previously, the panel would be turned off when its module was removed.
But because the connector state was hardcoded, nothing knew to turn the
panel back on when it was re-attached. Now, with hotplug events
available, the connector state will follow the panel module state, and
the panel will be re-enabled properly.

Fixes: 133add5b5ad4 ("drm/sun4i: Add Allwinner A31 MIPI-DSI controller support")
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c | 22 ++++++++++++++++------
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h |  1 +
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
index 019fdf4ec274..ef35ce5a9bb0 100644
--- a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
+++ b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
@@ -804,7 +804,10 @@ static struct drm_connector_helper_funcs sun6i_dsi_connector_helper_funcs = {
 static enum drm_connector_status
 sun6i_dsi_connector_detect(struct drm_connector *connector, bool force)
 {
-	return connector_status_connected;
+	struct sun6i_dsi *dsi = connector_to_sun6i_dsi(connector);
+
+	return dsi->panel ? connector_status_connected :
+			    connector_status_disconnected;
 }
 
 static const struct drm_connector_funcs sun6i_dsi_connector_funcs = {
@@ -945,10 +948,15 @@ static int sun6i_dsi_attach(struct mipi_dsi_host *host,
 
 	if (IS_ERR(panel))
 		return PTR_ERR(panel);
+	if (!dsi->drm)
+		return -EPROBE_DEFER;
 
 	dsi->panel = panel;
 	dsi->device = device;
 
+	drm_panel_attach(dsi->panel, &dsi->connector);
+	drm_kms_helper_hotplug_event(dsi->drm);
+
 	dev_info(host->dev, "Attached device %s\n", device->name);
 
 	return 0;
@@ -958,10 +966,14 @@ static int sun6i_dsi_detach(struct mipi_dsi_host *host,
 			    struct mipi_dsi_device *device)
 {
 	struct sun6i_dsi *dsi = host_to_sun6i_dsi(host);
+	struct drm_panel *panel = dsi->panel;
 
 	dsi->panel = NULL;
 	dsi->device = NULL;
 
+	drm_panel_detach(panel);
+	drm_kms_helper_hotplug_event(dsi->drm);
+
 	return 0;
 }
 
@@ -1026,9 +1038,6 @@ static int sun6i_dsi_bind(struct device *dev, struct device *master,
 	struct sun6i_dsi *dsi = dev_get_drvdata(dev);
 	int ret;
 
-	if (!dsi->panel)
-		return -EPROBE_DEFER;
-
 	drm_encoder_helper_add(&dsi->encoder,
 			       &sun6i_dsi_enc_helper_funcs);
 	ret = drm_encoder_init(drm,
@@ -1054,7 +1063,8 @@ static int sun6i_dsi_bind(struct device *dev, struct device *master,
 	}
 
 	drm_connector_attach_encoder(&dsi->connector, &dsi->encoder);
-	drm_panel_attach(dsi->panel, &dsi->connector);
+
+	dsi->drm = drm;
 
 	return 0;
 
@@ -1068,7 +1078,7 @@ static void sun6i_dsi_unbind(struct device *dev, struct device *master,
 {
 	struct sun6i_dsi *dsi = dev_get_drvdata(dev);
 
-	drm_panel_detach(dsi->panel);
+	dsi->drm = NULL;
 }
 
 static const struct component_ops sun6i_dsi_ops = {
diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h
index 61e88ea6044d..c863900ae3b4 100644
--- a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h
+++ b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h
@@ -29,6 +29,7 @@ struct sun6i_dsi {
 
 	struct device		*dev;
 	struct mipi_dsi_device	*device;
+	struct drm_device	*drm;
 	struct drm_panel	*panel;
 };
 
-- 
2.24.1

