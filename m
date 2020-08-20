Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA4124B11B
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgHTIc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:32:56 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:48693 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725852AbgHTIcy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 04:32:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id D2297194008D;
        Thu, 20 Aug 2020 04:32:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 20 Aug 2020 04:32:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ibWEpU
        7+iwsNDzofn/aPZp52OPDhI2zxBvK17pYz2r8=; b=RpMknMG5/qHvJG+U0VCFoy
        vexiYMkYqS5RsbDR8NCiAdybdwDy7cD9xKoADFOdRHv8IrLGQloqlGK115cIXoSw
        +z+mTmLCKX3CMVyqmOU9s6opASruDeTZ+YX/BmHY5hM1iPWSCiyIxuoe8v0vLcoR
        ZOoRnTbWdjgIPiqv4VwTFOPfRlbThXJF1wp/Z5HTB5uKMZXR0H0KP35p6lbrYCv5
        1Jrl1zcciXRf0iQwVnDCI+RYmgK4hxCrsp0hzQFY1CDIglYX6lvrjB7Af7TXKuD6
        2N1gXtKiTb3L193S2d0Cn8uXgLgua2zwxvzXaJ+MxlSXMZaHL2E62yTodHuVF+qQ
        ==
X-ME-Sender: <xms:MzU-XxMZEYW9NHHJwZLgSbb-roRY5vvDZWRvpxK_RQxNsUBaz70BHQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddutddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:MzU-Xz_bSORdrku-uzPUCaHDr1XX9Xq-iBA-wQmVQNrB7B-gZr86hA>
    <xmx:MzU-XwRMdF83b-bcAJpjTPh_xhxEhnTsVW5Z8OskASWBW-fxTm4Xrg>
    <xmx:MzU-X9thY_HTdIpiK1uU8YCNoOtMnIk0VC8fylgUhUjo9tBnNF5inA>
    <xmx:NDU-X16vUKX8k1Q4_qXsl0dI0KKSl8vcNGe0ltqoM-MlRC0coEF-iiC0jT4>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5E9B0328005A;
        Thu, 20 Aug 2020 04:32:51 -0400 (EDT)
Subject: WTF: patch "[PATCH] drm/mgag200: Remove declaration of mgag200_mmap() from header" was seriously submitted to be applied to the 5.8-stable tree?
To:     tzimmermann@suse.de, airlied@redhat.com, alexander.deucher@amd.com,
        armijn@tjaldur.nl, daniel.vetter@ffwll.ch,
        emil.velikov@collabora.com, gregkh@linuxfoundation.org,
        kraxel@redhat.com, krzk@kernel.org, noralf@tronnes.org,
        sam@ravnborg.org, stable@vger.kernel.org, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 20 Aug 2020 10:33:12 +0200
Message-ID: <1597912392179121@kroah.com>
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

