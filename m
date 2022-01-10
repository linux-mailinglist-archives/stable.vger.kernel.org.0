Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0911B4895C9
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 10:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243470AbiAJJ4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 04:56:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32520 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243455AbiAJJ4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 04:56:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641808592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wJr2+TRe6SBb1BM5UDY1ejbky83MU/0sD3dvYedx6MA=;
        b=J4ZOZtmCIds8/MwCUrWz/SS2nQNAVJ5EeyzV5uefZMGGOa6nEnmxSdx/2ed2b+3Ve2ZoFI
        qbSn1IrqtEtqURijjBDdZSpf4hOw5wjit6pAN0ZxpNkdz/3/a67bx99MnduDj5rSdk2nrC
        rU1EALk8oYxYKasYPAbPU15Q8OPsyac=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-yCLKsr1xMg28DmaA4_Kw2Q-1; Mon, 10 Jan 2022 04:56:31 -0500
X-MC-Unique: yCLKsr1xMg28DmaA4_Kw2Q-1
Received: by mail-wr1-f69.google.com with SMTP id k14-20020adfb34e000000b001a5d060e1edso2406491wrd.7
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 01:56:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wJr2+TRe6SBb1BM5UDY1ejbky83MU/0sD3dvYedx6MA=;
        b=qVXcOMNdzAudPpYW8f3/rWrNdmz6Fl0Jai66HA2qMczz2QasvRy85VzwnJIDOFRnO6
         4LsrzABfeXBuTUMdc8dr4p9kwmUz9vwHq3epgVXqmTjxre3hnBdfD7AVhu//4pvKsaHk
         gowXsofx+KA/xC8JepmBGdbjU9JW3t3ZbLqRxboN4GBTosBG5+jQq/UVAid488mNgCnP
         nIwTXrfj4TExtWwYsa/bup/NviVj+sbwjWHR8pwfTSEAjB91uF1z7LujvY0kLiYXyidQ
         TPulPrGTVItgjRSDKKHTTR0Drp7x9YjSus4Jzs+lutMF2g6wvvA9fWkI40XDDP7r11I2
         x5Bg==
X-Gm-Message-State: AOAM5321wjhdiEoz8PaT8nyKjqMSME+PeKiPNMVgq8sySpFn6iYBUj8i
        4Ny11w9+wEVuFMxTGXeMNmLxEsLooIKwctAbnuHSjhocyMKMk4Leqe/vk9vmOfo2Ay7lytmgiaQ
        FhoP5/UqoxYkTo6oO
X-Received: by 2002:a05:6000:11c9:: with SMTP id i9mr6134109wrx.544.1641808590195;
        Mon, 10 Jan 2022 01:56:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzvF1fUNv4N+g4L82v97FbltLNWdtemC8wnOpy3eswOBvCDx6S9Wvq2C8LmHTKllcM2hylVhA==
X-Received: by 2002:a05:6000:11c9:: with SMTP id i9mr6134090wrx.544.1641808589966;
        Mon, 10 Jan 2022 01:56:29 -0800 (PST)
Received: from minerva.home ([92.176.231.205])
        by smtp.gmail.com with ESMTPSA id b13sm6315167wrf.64.2022.01.10.01.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 01:56:29 -0800 (PST)
From:   Javier Martinez Canillas <javierm@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Kris Karas <bugs-a21@moonlit-rail.com>,
        Peter Robinson <pbrobinson@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH v2 2/2] video: vga16fb: Only probe for EGA and VGA 16 color graphic cards
Date:   Mon, 10 Jan 2022 10:56:25 +0100
Message-Id: <20220110095625.278836-3-javierm@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220110095625.278836-1-javierm@redhat.com>
References: <20220110095625.278836-1-javierm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The vga16fb framebuffer driver only supports Enhanced Graphics Adapter
(EGA) and Video Graphics Array (VGA) 16 color graphic cards.

But it doesn't check if the adapter is one of those or if a VGA16 mode
is used. This means that the driver will be probed even if a VESA BIOS
Extensions (VBE) or Graphics Output Protocol (GOP) interface is used.

This issue has been present for a long time but it was only exposed by
commit d391c5827107 ("drivers/firmware: move x86 Generic System
Framebuffers support") since the platform device registration to match
the {vesa,efi}fb drivers is done later as a consequence of that change.

All non-x86 architectures though treat orig_video_isVGA as a boolean so
only do the supported video mode check for x86 and not for other arches.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215001
Fixes: d391c5827107 ("drivers/firmware: move x86 Generic System Framebuffers support")
Reported-by: Kris Karas <bugs-a21@moonlit-rail.com>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Tested-by: Kris Karas <bugs-a21@moonlit-rail.com>
---

Changes in v2:
- Only check the suppported video mode for x86 (Geert Uytterhoeven).

 drivers/video/fbdev/vga16fb.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/video/fbdev/vga16fb.c b/drivers/video/fbdev/vga16fb.c
index 8c464409eb99..d21f68f3ee44 100644
--- a/drivers/video/fbdev/vga16fb.c
+++ b/drivers/video/fbdev/vga16fb.c
@@ -184,6 +184,25 @@ static inline void setindex(int index)
 	vga_io_w(VGA_GFX_I, index);
 }
 
+/* Check if the video mode is supported by the driver */
+static inline int check_mode_supported(void)
+{
+	/* non-x86 architectures treat orig_video_isVGA as a boolean flag */
+#if defined(CONFIG_X86)
+	/* only EGA and VGA in 16 color graphic mode are supported */
+	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EGAC &&
+	    screen_info.orig_video_isVGA != VIDEO_TYPE_VGAC)
+		return -ENODEV;
+
+	if (screen_info.orig_video_mode != 0x0D &&	/* 320x200/4 (EGA) */
+	    screen_info.orig_video_mode != 0x0E &&	/* 640x200/4 (EGA) */
+	    screen_info.orig_video_mode != 0x10 &&	/* 640x350/4 (EGA) */
+	    screen_info.orig_video_mode != 0x12)	/* 640x480/4 (VGA) */
+		return -ENODEV;
+#endif
+	return 0;
+}
+
 static void vga16fb_pan_var(struct fb_info *info, 
 			    struct fb_var_screeninfo *var)
 {
@@ -1427,6 +1446,11 @@ static int __init vga16fb_init(void)
 
 	vga16fb_setup(option);
 #endif
+
+	ret = check_mode_supported();
+	if (ret)
+		return ret;
+
 	ret = platform_driver_register(&vga16fb_driver);
 
 	if (!ret) {
-- 
2.33.1

