Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 071F9158A67
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 08:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbgBKH3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 02:29:13 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:60291 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727041AbgBKH3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Feb 2020 02:29:03 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 8405C5BD;
        Tue, 11 Feb 2020 02:29:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 11 Feb 2020 02:29:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=xNUtUsfuH4Ly9
        iDTvm5saY9gUrnZ7LMYvcmrJ/q0E6s=; b=bfnYxy9F7N64LwBxzVC3DS449tbj5
        Jwf3KQNviW2ODLRY8W5dHdOXEbjCafBP90cctCDrKAtXidFW/G+qovNeMFdcdgjw
        oYc3vYfi50KEIyBfdsEiowxqdJvD6Mw0QPWguHwRXuaQ5f5CKLkyd97DYdgSkn4h
        ljuxGzL+r4DT+dIXCngBQ/Uw9k8e2npyZhzFjJpfYcgpL/UpRax50Lfexf9BO96v
        BBv9OXF/2wDIEukZV9gOrg6AEvnSCCm/s2MiIdw+nBElnCV1Uf2ehYB/LPHDa1Bs
        /Xoay+RzvgjS2mozyXX3RQXJoQyUeiNjaohJbgRdWU2N8lKCMsaMD8+DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=xNUtUsfuH4Ly9iDTvm5saY9gUrnZ7LMYvcmrJ/q0E6s=; b=pVPi4DQo
        skN3idrvv1MplozuyLT9cK8AFlkvx3ikvm55mNJQxMi6DXge8yzy5p+3mPqhlNhd
        J0CHbMNGmYlce2ABoBarh96c//bGpOM5j6I22j3VVKftGtILSej8gdMaALnKjgsR
        nogYSMPgfWxvpl2Q5zj/shJLYK/+FPVB8apY88O2ZBOKDA2DphjuzSRwSZl7G53U
        7ZEHsF7Nuxm2QaqqD2VdduO8eSsO2J8jAM/7Z5VNoTnoPFh8l4d39nWDlpPuA0Vw
        2WtuGROLdXr5Z+XsON82bjiQ6ERTl1KsZIniFXTbQTy47B8Ww5fJnRXQicivHot9
        3rlPPzXXzqwcxg==
X-ME-Sender: <xms:u1dCXry3XWNFpDLa_PUxG9meBIKjk60AXRTXH0jDLVmKaH9xeX_9iA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedriedvgddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucfkph
    epjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghnugdrohhrgh
X-ME-Proxy: <xmx:vFdCXtmdn2RREsi470vECnjucS2d6Zi8yC5PDufhWvoxI9YsXWZpiA>
    <xmx:vFdCXtikszpPq6QlKZ-Ru7Qcy3JWx__cUMgCuR_KLxyaV3ZbvBCeLg>
    <xmx:vFdCXgdcp3dlXnr5dyWVQNpI2xwfOvNAy7Cbqv9M8RBS2DCsfhMF9A>
    <xmx:vVdCXg2NVFBE1Y2L9WHZrXDHiot55XXzfLBgzU4TA4a0A_AR_-pEEQ>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9002C3060840;
        Tue, 11 Feb 2020 02:28:59 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>
Subject: [PATCH 2/4] drm/sun4i: dsi: Use NULL to signify "no panel"
Date:   Tue, 11 Feb 2020 01:28:56 -0600
Message-Id: <20200211072858.30784-2-samuel@sholland.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211072858.30784-1-samuel@sholland.org>
References: <20200211072858.30784-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The continued use of an ERR_PTR to signify "no panel" outside of
sun6i_dsi_attach is confusing because it is a double negative. Because
the connector always reports itself as connected, there is also the
possibility of sending an ERR_PTR to drm_panel_get_modes(), which would
crash.

Solve both of these by only storing the panel pointer if it is valid.

Fixes: 133add5b5ad4 ("drm/sun4i: Add Allwinner A31 MIPI-DSI controller support")
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
index c07290541fff..019fdf4ec274 100644
--- a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
+++ b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
@@ -748,7 +748,7 @@ static void sun6i_dsi_encoder_enable(struct drm_encoder *encoder)
 	phy_configure(dsi->dphy, &opts);
 	phy_power_on(dsi->dphy);
 
-	if (!IS_ERR(dsi->panel))
+	if (dsi->panel)
 		drm_panel_prepare(dsi->panel);
 
 	/*
@@ -763,7 +763,7 @@ static void sun6i_dsi_encoder_enable(struct drm_encoder *encoder)
 	 * ordering on the panels I've tested it with, so I guess this
 	 * will do for now, until that IP is better understood.
 	 */
-	if (!IS_ERR(dsi->panel))
+	if (dsi->panel)
 		drm_panel_enable(dsi->panel);
 
 	sun6i_dsi_start(dsi, DSI_START_HSC);
@@ -779,7 +779,7 @@ static void sun6i_dsi_encoder_disable(struct drm_encoder *encoder)
 
 	DRM_DEBUG_DRIVER("Disabling DSI output\n");
 
-	if (!IS_ERR(dsi->panel)) {
+	if (dsi->panel) {
 		drm_panel_disable(dsi->panel);
 		drm_panel_unprepare(dsi->panel);
 	}
@@ -941,11 +941,13 @@ static int sun6i_dsi_attach(struct mipi_dsi_host *host,
 			    struct mipi_dsi_device *device)
 {
 	struct sun6i_dsi *dsi = host_to_sun6i_dsi(host);
+	struct drm_panel *panel = of_drm_find_panel(device->dev.of_node);
 
+	if (IS_ERR(panel))
+		return PTR_ERR(panel);
+
+	dsi->panel = panel;
 	dsi->device = device;
-	dsi->panel = of_drm_find_panel(device->dev.of_node);
-	if (IS_ERR(dsi->panel))
-		return PTR_ERR(dsi->panel);
 
 	dev_info(host->dev, "Attached device %s\n", device->name);
 
-- 
2.24.1

