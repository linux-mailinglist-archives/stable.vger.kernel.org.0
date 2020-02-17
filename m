Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82F92160A3F
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 07:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgBQGJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 01:09:13 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:37913 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725972AbgBQGJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 01:09:13 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 005A950C;
        Mon, 17 Feb 2020 01:09:11 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 17 Feb 2020 01:09:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm2; bh=lzWvnnSAvszDDjSboHP99evSnh
        TQIWH2Dw0zyXVLRx8=; b=kQNDEUGjcAUwdSTl2keQT54cQ1ODJzIGlHSxA/34Cp
        sKNpP+FB/E54+FnwfGuLHKupUyRRcXc7QcSww6/sNbnhBnodgrbuWXbWOaqtoxcx
        IHQCkqQ0mOK25xpc912arh+bcrNMCYsr2Uzp78kUv0OfasrGtWJRDrQvAmMEJq/O
        zAme+b3HAUgoTs4fP3Azlk6kN8GJjxSJ0NzKR5FGBHITdNY7xnHJEvybwY8lppd7
        9JHsGbdAYHCx9GxFCdEL4oLz6plI/fkqQZazSNZVHBWLxIKEls4TO5DwuhCd47F8
        elsEtld9/L936yvL+GqFj2RMSrVGz6kE1z2j0SmxzzUQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lzWvnnSAvszDDjSbo
        HP99evSnhTQIWH2Dw0zyXVLRx8=; b=b+basvKj3oT1MeXlur2bpnXvouWW/abcf
        SfUGqCZQTgsxHZnGOxE7k9V01rxyp0Dx/1ZG+rBuZ87aHiWg7lsFPwY6qA36aW7C
        jaWsXPOqtLE2Ja75WEcZqDyNnea0rIko8TTt3+s2aiIH0L1lwIs1hRAw6gEFpcd/
        aE1Tez5qYX4/0p3e5skv46zo3/yY9hO9suG7cESNNfexTnygsirQN2IO5e+1kqDk
        h9XNKIA9ICfd0fR8M7xamNh6vt2it3cSdRxw2UNt0zHQBXV5Z9fv5cb7JH550kUb
        HiEJBojfemjbI5hAckeyC6vztn/tjGuFmrObLxP1/h8WrFB7ZPrlg==
X-ME-Sender: <xms:BC5KXn5mVWAhFXWLE0c7lv3dRb13JkS2bnHb7Y6XwmRcFz0qsMvINQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeehgdeludcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghlucfj
    ohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecukfhppeejtd
    drudefhedrudegkedrudehudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhg
X-ME-Proxy: <xmx:BC5KXkdfzAuz8-iTRIAC09RnaB260csLavkkCDQIdAEekDX1umrgBw>
    <xmx:BC5KXrazGnIiNzrEgXp4rpeIoBSJupk5SGk7Z3QmU5z4YsvHnDRYcA>
    <xmx:BC5KXmHf6K2lzpjyf47M3qMbAqZad8UDrq84XFyQwbCM0qhZs0z8Ww>
    <xmx:By5KXkyTWgMMHDbZ3vAHUR-XdyhYduHZEtZQ30qCKR_3p7ot3NbbLQ>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id B48E8328005A;
        Mon, 17 Feb 2020 01:09:07 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>
Subject: [PATCH] drm/sun4i: dsi: Avoid hotplug race with DRM driver bind
Date:   Mon, 17 Feb 2020 00:09:06 -0600
Message-Id: <20200217060906.15152-1-samuel@sholland.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We need to make sure that the DRM driver is fully registered before
allowing the panel to be attached. Otherwise, we may trigger a hotplug
event before sun4i_framebuffer_init() sets up drm->mode_config.funcs,
causing a NULL pointer dereference.

Fixes: 1a2703bd7356 ("drm/sun4i: dsi: Allow binding the host without a panel")
Signed-off-by: Samuel Holland <samuel@sholland.org>
---

This fixes a bug in my previous patch series, that I didn't catch until
it was already merged.

---
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
index 9aa78c73873c..9cc1bb69fcda 100644
--- a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
+++ b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
@@ -970,7 +970,7 @@ static int sun6i_dsi_attach(struct mipi_dsi_host *host,
 
 	if (IS_ERR(panel))
 		return PTR_ERR(panel);
-	if (!dsi->drm)
+	if (!dsi->drm || !dsi->drm->registered)
 		return -EPROBE_DEFER;
 
 	dsi->panel = panel;
-- 
2.24.1

