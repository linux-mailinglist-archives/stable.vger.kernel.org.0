Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF62E23EE3B
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 15:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgHGNaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 09:30:16 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:48345 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726167AbgHGNaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 09:30:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3CFE81940771;
        Fri,  7 Aug 2020 09:29:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 07 Aug 2020 09:29:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ibWEpU
        7+iwsNDzofn/aPZp52OPDhI2zxBvK17pYz2r8=; b=bY7YhzzchIrRi1NbVNJv0P
        4EcVvDnFpOve46cdxtT5iJmEzNRQIaqDoxzs7UfMLjBR+wPzO3bkhg1yQCjsvJwN
        ezTgwPfTU/7SF3OwGzaqE6jtDmRRzKrzRmgWXXliQt3HdQGXNXk8+5MMe6QJEUUB
        5/BzB73sas0A+GIwCRjmUK7Xid2tNXcizETiysf28HlVT2eUu6PqhSwA7Yxke0JS
        v/mzE59CflqzcMkCuZVVEUc3Z20DEf6j65Du8FLinH+TiHo+YUHM3FuI+qKSufFn
        IjU3T+6DAygQPKhX5ahxmfKESeOtT31hcMOVx+jhVX9N+A2K/NB1O3PKL/n4pF4Q
        ==
X-ME-Sender: <xms:T1ctXxKCCeRtABvuTawNUV0LKQf5f2rRsJxV8Fi2toD524PtCwW_7w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkedvgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpedvffegjeejiedtieffjeeijeffgfehvdeiudejheefge
    evhffhvedvfeeuheekleenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:T1ctX9Kpdm9Ajb9VhpEwJgtlbYl_ckl6dMOi9kpjOhPx0swmLMr_tA>
    <xmx:T1ctX5tSEbNQVumqQBeCvziFEzzaVJgprREdBZ06gzM1DnYg19dxMQ>
    <xmx:T1ctXybaXqTtl1KRiA3GRwm2Kkrtc0q8CFLfykdaouYK80Briex3ww>
    <xmx:UVctX2nQFrCdGIlfpMYNbhzLIcyPypEPlWPM50Bqq8290WCEcpDh2t6engI>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3F8733060067;
        Fri,  7 Aug 2020 09:29:51 -0400 (EDT)
Subject: WTF: patch "[PATCH] drm/mgag200: Remove declaration of mgag200_mmap() from header" was seriously submitted to be applied to the 5.8-stable tree?
To:     tzimmermann@suse.de, airlied@redhat.com, alexander.deucher@amd.com,
        armijn@tjaldur.nl, daniel.vetter@ffwll.ch,
        emil.velikov@collabora.com, gregkh@linuxfoundation.org,
        kraxel@redhat.com, krzk@kernel.org, noralf@tronnes.org,
        sam@ravnborg.org, stable@vger.kernel.org, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Aug 2020 15:30:05 +0200
Message-ID: <159680700523135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 5.8-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1d8d42ba365101fa68d210c0e2ed2bc9582fda6c Mon Sep 17 00:00:00 2001
From: Thomas Zimmermann <tzimmermann@suse.de>
Date: Fri, 5 Jun 2020 15:57:50 +0200
Subject: [PATCH] drm/mgag200: Remove declaration of mgag200_mmap() from header
 file
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit 94668ac796a5 ("drm/mgag200: Convert mgag200 driver to VRAM MM")
removed the implementation of mgag200_mmap(). Also remove the declaration.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Fixes: 94668ac796a5 ("drm/mgag200: Convert mgag200 driver to VRAM MM")
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Noralf Trønnes" <noralf@tronnes.org>
Cc: Armijn Hemel <armijn@tjaldur.nl>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Emil Velikov <emil.velikov@collabora.com>
Cc: <stable@vger.kernel.org> # v5.3+
Link: https://patchwork.freedesktop.org/patch/msgid/20200605135803.19811-2-tzimmermann@suse.de

diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.h b/drivers/gpu/drm/mgag200/mgag200_drv.h
index 47df62b1ad29..92b6679029fe 100644
--- a/drivers/gpu/drm/mgag200/mgag200_drv.h
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
@@ -198,6 +198,5 @@ void mgag200_i2c_destroy(struct mga_i2c_chan *i2c);
 
 int mgag200_mm_init(struct mga_device *mdev);
 void mgag200_mm_fini(struct mga_device *mdev);
-int mgag200_mmap(struct file *filp, struct vm_area_struct *vma);
 
 #endif				/* __MGAG200_DRV_H__ */

