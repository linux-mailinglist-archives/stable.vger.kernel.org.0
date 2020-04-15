Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E291A9C49
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896997AbgDOLar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:30:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58863 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896984AbgDOLah (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:30:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1D9D75C01F6;
        Wed, 15 Apr 2020 07:30:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:30:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=FRBfBN
        9zmEgD1G3EsFECZw9Nui16cUMMiIWS/JhDoEo=; b=Dxa2v/Q9sgYk2i60lQLjMF
        yyD9A4hs1VjB9t/C9dgfEBUymAEx1kEqS6feom61ExaZfEhczJs2THguqF8XfDZ2
        C1/myirth5pY3Oa3SVfESLzOOOWbkOgKH0hCSO+Y+V/KY/PtSx05N180PBjh5/7b
        WikyxJNeJ0uodBA4eHWkCe+7jxmKlRwFnsu8JOxw1cIjP7+lYL0E2cwxkWVsZlZL
        U6EHtrg676tIIxo08mFqHGFB9eOZ62ZqnyamLaatqWZLCr/XA1nLfPVZSiWObYfO
        cxbWXWSWzCUI30V5eSe9DOfkAx27IjN/3N9WHHZcZNyXF9yNzzxZ13x3DEgp6Sqw
        ==
X-ME-Sender: <xms:WvCWXncSrjcPS3Ky4KtK4NMpseLUtD2SAIsVsS2y5ken8As4dVq9IQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepkeefrdekie
    drkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:WvCWXvhcy_2Gxu4VDA8BZrNsJWvqX0KYqOdcbdlrcuIcokRzLdFnjg>
    <xmx:WvCWXvSMaLYeluXiaquvKMclcPtgwcBnw1DtR95grXZTLTEro8lOqw>
    <xmx:WvCWXjKopitagGdd7hygQ1IIb8BOXQI6YmTmi5g3JyJH0GroTrJWzg>
    <xmx:XPCWXjwBtYk1pO73Vi9fHkmSpFGQFE6le2vnIEv2t0C63-7ojK2jGA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6DFCC328005A;
        Wed, 15 Apr 2020 07:30:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/bridge: analogix-anx78xx: Fix drm_dp_link helper removal" failed to apply to 5.5-stable tree
To:     duwe@lst.de, Laurent.pinchart@ideasonboard.com,
        a.hajda@samsung.com, daniel.vetter@ffwll.ch,
        jernej.skrabec@siol.net, jonas@kwiboo.se, narmstrong@baylibre.com,
        stable@vger.kernel.org, treding@nvidia.com, tzimmermann@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:30:33 +0200
Message-ID: <158695023362255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3e138a63d6674a4567a018a31e467567c40b14d5 Mon Sep 17 00:00:00 2001
From: Torsten Duwe <duwe@lst.de>
Date: Tue, 18 Feb 2020 16:57:44 +0100
Subject: [PATCH] drm/bridge: analogix-anx78xx: Fix drm_dp_link helper removal

drm_dp_link_rate_to_bw_code and ...bw_code_to_link_rate simply divide by
and multiply with 27000, respectively. Avoid an overflow in the u8 dpcd[0]
and the multiply+divide alltogether.

Signed-off-by: Torsten Duwe <duwe@lst.de>
Fixes: ff1e8fb68ea0 ("drm/bridge: analogix-anx78xx: Avoid drm_dp_link helpers")
Cc: Thierry Reding <treding@nvidia.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Jonas Karlman <jonas@kwiboo.se>
Cc: Jernej Skrabec <jernej.skrabec@siol.net>
Cc: <stable@vger.kernel.org> # v5.5+
Reviewed-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20200218155744.9675368BE1@verein.lst.de

diff --git a/drivers/gpu/drm/bridge/analogix/analogix-anx78xx.c b/drivers/gpu/drm/bridge/analogix/analogix-anx78xx.c
index 41867be03751..864423f59d66 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix-anx78xx.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix-anx78xx.c
@@ -722,10 +722,9 @@ static int anx78xx_dp_link_training(struct anx78xx *anx78xx)
 	if (err)
 		return err;
 
-	dpcd[0] = drm_dp_max_link_rate(anx78xx->dpcd);
-	dpcd[0] = drm_dp_link_rate_to_bw_code(dpcd[0]);
 	err = regmap_write(anx78xx->map[I2C_IDX_TX_P0],
-			   SP_DP_MAIN_LINK_BW_SET_REG, dpcd[0]);
+			   SP_DP_MAIN_LINK_BW_SET_REG,
+			   anx78xx->dpcd[DP_MAX_LINK_RATE]);
 	if (err)
 		return err;
 

