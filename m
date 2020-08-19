Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD81249FB6
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgHSNZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:25:36 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:46651 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728364AbgHSNZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:25:23 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 5592CC76;
        Wed, 19 Aug 2020 09:25:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 09:25:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=BeIKsN
        vVGmY/xBndEkDkhOWocp4TpwibwigYIXwgnWY=; b=vDDhxsRI3dDUl6aCm+iBFs
        Eqr1orunhrbu8LJUEb/tVneNWKS1TuBreRWCXya5Ar7/cjSrmAGbOvA3+/+bIyjm
        HmHfL1wMPQBRlMT4b39IYBL++8YLhsG7+UKqRX416lgn2ZUBIgTzRWToi564PbLF
        udCN9ZUl5EADvJh8kekHShAj851OOYLNhCG1/BwnTtjuqbMQXzA8u8tt9eNtix+e
        2uyKKXcvEpMPCn4pNrv4Uew3SNb7VIs5G+s+w/fhb83PV+lgSGmW868bcI/s3N2B
        62e00zMgiymi9VforSjp8VyI0yzaE1v7/PiG/TeJ3oU32Hk84tuDgJabzU4I2G/w
        ==
X-ME-Sender: <xms:QSg9XwK4cnuOoE7sF_d3WDeJEEJMTjOk-4q5NxIL8f_qO27ZyVKC_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedvnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:QSg9XwJB-EbP4wfTRdzM0PwBPUr-jLzmsTSLgOFiLyLZLzOgV0e9HA>
    <xmx:QSg9XwvSU-MYbqQ9hGmk0rBEi5XZa-3xw7z8dzwGX0FekZKR4nM_Sw>
    <xmx:QSg9X9a8bYrW7dVoxN1zDJYGS45IXzi8C2E7BsSIyUebeV8XGvXyXQ>
    <xmx:QSg9Xx3SbmmhmywhGWtECRzKaD6thgnBCdfkDz63pVMXQYW3KzjF7sGbFTc>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7C07B30600B4;
        Wed, 19 Aug 2020 09:25:21 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/panel-simple: Fix inverted V/H SYNC for Frida" failed to apply to 5.7-stable tree
To:     paul@crapouillou.net, sam@ravnborg.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 15:25:34 +0200
Message-ID: <159784353427162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
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

