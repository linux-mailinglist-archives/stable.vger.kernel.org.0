Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB1F249FB4
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgHSNZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:25:22 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:59691 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728540AbgHSNZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:25:15 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 543BEC8D;
        Wed, 19 Aug 2020 09:25:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 09:25:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=CNvlcO
        Cna/DxkcztjOcbog9LEsZu1FJ2jHE6qGidaVc=; b=g9QhkOvcJdTFP0etVnMOBa
        7i6JLzV8sXSmMr9e2QbsncFBlEg9pRIs6534weHAlD8ChRwbL/Dfu/xsXbSqHpv/
        7i9iwEwrryhQPsgdQCGJOBICgtZtwY2ku13GZb+fIX19BmfIDOoylHTTUT4Xstse
        invDzQSw2dAJT2R6yXrODYsl6X3E+S4edVJgpltBBuNwpkRZupWAqz0LyWJQAPe4
        /9IfDhfMHl1VuX3NkT52X1CHPB8Ss9aQw+NBIikCyDOOwOLdXghNuPv7zl+ehGo5
        R4Lwj1tmRZB1NC21rmLJmPR3cWDKtKEEX9jjIAZxmgngD36SBL/81JcmNC7K5xEQ
        ==
X-ME-Sender: <xms:Nyg9X-DlYvz8OWJTiAJQO_k8loMN4eCo1uOtzPTZEcjElWNrAZqd_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Nyg9X4g8GcOPmnW6V6tc0pB3x5Weo8aN3yltrSUGbg5ZUnuhvIDYKg>
    <xmx:Nyg9XxlO4XLQWUYfHA_PnT0X6hZGyiWuzBrifDMS-ZznOW88pKSakA>
    <xmx:Nyg9X8wiCEjBKncuGCEcJVSo-M9FaoRodwAl7JHpNkgLzp__ww4MFA>
    <xmx:Nyg9X2N4RXqEjWVRAqYu35MwoaRhAro8kYEth16muwJzvZLV9a_YwX6KVhg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0E70B30600A6;
        Wed, 19 Aug 2020 09:25:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/panel-simple: Fix inverted V/H SYNC for Frida" failed to apply to 5.8-stable tree
To:     paul@crapouillou.net, sam@ravnborg.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 15:25:34 +0200
Message-ID: <15978435341358@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bad20a2dbfdfaf01560026909506b6ed69d65ba2 Mon Sep 17 00:00:00 2001
From: Paul Cercueil <paul@crapouillou.net>
Date: Thu, 16 Jul 2020 14:56:46 +0200
Subject: [PATCH] drm/panel-simple: Fix inverted V/H SYNC for Frida
 FRD350H54004 panel

The FRD350H54004 panel was marked as having active-high VSYNC and HSYNC
signals, which sorts-of worked, but resulted in the picture fading out
under certain circumstances.

Fix this issue by marking VSYNC and HSYNC signals active-low.

v2: Rebase on drm-misc-next

Fixes: 7b6bd8433609 ("drm/panel: simple: Add support for the Frida FRD350H54004 panel")
Cc: stable@vger.kernel.org # v5.5
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200716125647.10964-1-paul@crapouillou.net

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index f42249b72548..8b0bab9dd075 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1763,7 +1763,7 @@ static const struct drm_display_mode frida_frd350h54004_mode = {
 	.vsync_start = 240 + 2,
 	.vsync_end = 240 + 2 + 6,
 	.vtotal = 240 + 2 + 6 + 2,
-	.flags = DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC,
+	.flags = DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_NVSYNC,
 };
 
 static const struct panel_desc frida_frd350h54004 = {

