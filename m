Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0416676D26
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 14:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjAVN1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 08:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjAVN1K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 08:27:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462A91A4BF
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 05:27:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2A4C60C0D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 13:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A10C433D2;
        Sun, 22 Jan 2023 13:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674394028;
        bh=7FLKMmRj9XOOv9yQ+LIkovIC+pqaLObWmUEp5KLF7OI=;
        h=Subject:To:Cc:From:Date:From;
        b=pAPaeqEW9NvdBzBryuE39suuHJyQ2GHp8qTewW4E4HhSdXZDoGtLJeLyC03CbXdOa
         1+xkv3jnBiCsvk2ybb8CKLmxrDtDVsUKHNGW08SvW/fiob/mBx3kIMkodCdaAQ3LC7
         X6uS8XlgQbjSmFLGakgC/O/wjZVugfptENMLFM/M=
Subject: FAILED: patch "[PATCH] drm/fb-helper: Set framebuffer for vga-switcheroo clients" failed to apply to 6.1-stable tree
To:     tzimmermann@suse.de, Amaranath.Somalapuram@amd.com,
        Bokun.Zhang@amd.com, Felix.Kuehling@amd.com, Hawking.Zhang@amd.com,
        Likun.Gao@amd.com, Stanley.Yang@amd.com, Xiaojian.Du@amd.com,
        YiPeng.Chai@amd.com, airlied@redhat.com, alexander.deucher@amd.com,
        andrey.grodzovsky@amd.com, aurabindo.pillai@amd.com,
        bskeggs@redhat.com, christian.koenig@amd.com,
        daniel.vetter@ffwll.ch, evan.quan@amd.com, guchun.chen@amd.com,
        hamza.mahfooz@amd.com, hdegoede@redhat.com, jani.nikula@intel.com,
        javierm@redhat.com, kai.heng.feng@canonical.com,
        kherbst@redhat.com, laurent.pinchart@ideasonboard.com,
        lyude@redhat.com, marek.olsak@amd.com, mario.limonciello@amd.com,
        sam@ravnborg.org, solomon.chiu@amd.com, stable@vger.kernel.org,
        tianci.yin@amd.com, ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 14:27:05 +0100
Message-ID: <16743940251554@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d1d5101452ab ("drm/fb-helper: Set framebuffer for vga-switcheroo clients")
8ab59da26bc0 ("drm/fb-helper: Move generic fbdev emulation into separate source file")
e7c5c29a9eb1 ("drm/fb-helper: Set flag in struct drm_fb_helper for leaking physical addresses")
7ce19535e9b4 ("drm/fb-helper: Always initialize generic fbdev emulation")
983780918c75 ("drm/fb-helper: Perform all fbdev I/O with the same implementation")
3add5f97734d ("drm/fb-helper: Call fb_sync in I/O functions")
f231af498c29 ("drm/fb-helper: Disconnect damage worker from update logic")
afb0ff78c13c ("drm/fb-helper: Rename drm_fb_helper_unregister_fbi() to use _info postfix")
7fd50bc39d12 ("drm/fb-helper: Rename drm_fb_helper_alloc_fbi() to use _info postfix")
9877d8f6bc37 ("drm/fb_helper: Rename field fbdev to info in struct drm_fb_helper")
2b1966c65b6d ("Merge tag 'drm-misc-next-2022-10-27' of git://anongit.freedesktop.org/drm/drm-misc into drm-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d1d5101452ab04e5a3f010bdd200971d78956e5a Mon Sep 17 00:00:00 2001
From: Thomas Zimmermann <tzimmermann@suse.de>
Date: Mon, 16 Jan 2023 12:54:24 +0100
Subject: [PATCH] drm/fb-helper: Set framebuffer for vga-switcheroo clients
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Set the framebuffer info for drivers that support VGA switcheroo. Only
affects the amdgpu and nouveau drivers, which use VGA switcheroo and
generic fbdev emulation. For other drivers, this does nothing.

This fixes a potential regression in the console code. Both, amdgpu and
nouveau, invoked vga_switcheroo_client_fb_set() from their internal fbdev
code. But the call got lost when the drivers switched to the generic
emulation.

Fixes: 087451f372bf ("drm/amdgpu: use generic fb helpers instead of setting up AMD own's.")
Fixes: 4a16dd9d18a0 ("drm/nouveau/kms: switch to drm fbdev helpers")
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Evan Quan <evan.quan@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Likun Gao <Likun.Gao@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Stanley Yang <Stanley.Yang@amd.com>
Cc: "Tianci.Yin" <tianci.yin@amd.com>
Cc: Xiaojian Du <Xiaojian.Du@amd.com>
Cc: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Cc: YiPeng Chai <YiPeng.Chai@amd.com>
Cc: Somalapuram Amaranath <Amaranath.Somalapuram@amd.com>
Cc: Bokun Zhang <Bokun.Zhang@amd.com>
Cc: Guchun Chen <guchun.chen@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Solomon Chiu <solomon.chiu@amd.com>
Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: "Marek Olšák" <marek.olsak@amd.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: "Ville Syrjälä" <ville.syrjala@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: nouveau@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.17+
Link: https://patchwork.freedesktop.org/patch/msgid/20230116115425.13484-3-tzimmermann@suse.de

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index b3a731b9170a..0d0c26ebab90 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -30,7 +30,9 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/console.h>
+#include <linux/pci.h>
 #include <linux/sysrq.h>
+#include <linux/vga_switcheroo.h>
 
 #include <drm/drm_atomic.h>
 #include <drm/drm_drv.h>
@@ -1909,6 +1911,11 @@ static int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_helper,
 		return ret;
 
 	strcpy(fb_helper->fb->comm, "[fbcon]");
+
+	/* Set the fb info for vgaswitcheroo clients. Does nothing otherwise. */
+	if (dev_is_pci(dev->dev))
+		vga_switcheroo_client_fb_set(to_pci_dev(dev->dev), fb_helper->info);
+
 	return 0;
 }
 

