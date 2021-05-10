Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8396377E12
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhEJIYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:24:50 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:44785 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230237AbhEJIYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:24:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8406519407F3;
        Mon, 10 May 2021 04:23:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 10 May 2021 04:23:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=n1u9bl
        08qgpf1OhKt7l9YEjRA9dVCwkrEEQenGpcaP4=; b=IoNtafUmfkJ+om2xg/DeUN
        8E384jOEHpW3aAvRIrI3PWyoMFHIuY3SDKLCCM6AkXqZxcujFdnatKzuFAUIWLwq
        xFTaD2MMOos9lbXQH3meWoankQoANxQTGffxkejvrYEi6u954b4vRN8zw00U4XJF
        wS4AjT4Fp0GQfx+eRIHXQ5f6cG3uMAbG8RvEc9hHW2shvhWOnaJ293GP8jdwEtdj
        hjflzvbDFFiXc3Vr1hHr6xXhJjYCysFeo2kalOv4OaxL4mt0FKYKtq+Z/DRNtsUI
        2aWVHl7kh5CYUCUT8Bp6sTgxaM4gFkhKyrovLOjcvE3h4jPiJMCulb0MwmsJP9Ag
        ==
X-ME-Sender: <xms:j-2YYBPtNx7PHuI_Oxs7-PSHWbC3PLnQfO9frTOgke0p1vIKsnZnbQ>
    <xme:j-2YYD8fSWy9H472hI_vTIZKwoj2Wav65fJnnqIZapngdX4LItCiQajAnov94frus
    TmXJO27cvz6ig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:j-2YYARAqTR2WAzjvH4CXrpoDd-UdrNHO_qakMWay8-_Y5rrsTi3Ng>
    <xmx:j-2YYNtFJzz6r65-1CPhqEbV4JJ7MpeoOq8KdADcyDWD_N8-rwFsjw>
    <xmx:j-2YYJdEo3FLatgAincWN2TMiwuN50WMsvTcIROJsIynscMjwZNQhA>
    <xmx:j-2YYJERcV5yMXi49e5hpKOwYVLY8e2_gXV2_91q4FTtdNtOgIyhYQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:23:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/compat: Clear bounce structures" failed to apply to 5.11-stable tree
To:     daniel.vetter@ffwll.ch, daniel.vetter@intel.com, mripard@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:23:32 +0200
Message-ID: <162063501221647@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e926c474ebee404441c838d18224cd6f246a71b7 Mon Sep 17 00:00:00 2001
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Mon, 22 Feb 2021 11:06:43 +0100
Subject: [PATCH] drm/compat: Clear bounce structures

Some of them have gaps, or fields we don't clear. Native ioctl code
does full copies plus zero-extends on size mismatch, so nothing can
leak. But compat is more hand-rolled so need to be careful.

None of these matter for performance, so just memset.

Also I didn't fix up the CONFIG_DRM_LEGACY or CONFIG_DRM_AGP ioctl, those
are security holes anyway.

Acked-by: Maxime Ripard <mripard@kernel.org>
Reported-by: syzbot+620cf21140fc7e772a5d@syzkaller.appspotmail.com # vblank ioctl
Cc: syzbot+620cf21140fc7e772a5d@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210222100643.400935-1-daniel.vetter@ffwll.ch

diff --git a/drivers/gpu/drm/drm_ioc32.c b/drivers/gpu/drm/drm_ioc32.c
index f86448ab1fe0..dc734d4828a1 100644
--- a/drivers/gpu/drm/drm_ioc32.c
+++ b/drivers/gpu/drm/drm_ioc32.c
@@ -99,6 +99,8 @@ static int compat_drm_version(struct file *file, unsigned int cmd,
 	if (copy_from_user(&v32, (void __user *)arg, sizeof(v32)))
 		return -EFAULT;
 
+	memset(&v, 0, sizeof(v));
+
 	v = (struct drm_version) {
 		.name_len = v32.name_len,
 		.name = compat_ptr(v32.name),
@@ -137,6 +139,9 @@ static int compat_drm_getunique(struct file *file, unsigned int cmd,
 
 	if (copy_from_user(&uq32, (void __user *)arg, sizeof(uq32)))
 		return -EFAULT;
+
+	memset(&uq, 0, sizeof(uq));
+
 	uq = (struct drm_unique){
 		.unique_len = uq32.unique_len,
 		.unique = compat_ptr(uq32.unique),
@@ -265,6 +270,8 @@ static int compat_drm_getclient(struct file *file, unsigned int cmd,
 	if (copy_from_user(&c32, argp, sizeof(c32)))
 		return -EFAULT;
 
+	memset(&client, 0, sizeof(client));
+
 	client.idx = c32.idx;
 
 	err = drm_ioctl_kernel(file, drm_getclient, &client, 0);
@@ -852,6 +859,8 @@ static int compat_drm_wait_vblank(struct file *file, unsigned int cmd,
 	if (copy_from_user(&req32, argp, sizeof(req32)))
 		return -EFAULT;
 
+	memset(&req, 0, sizeof(req));
+
 	req.request.type = req32.request.type;
 	req.request.sequence = req32.request.sequence;
 	req.request.signal = req32.request.signal;
@@ -889,6 +898,8 @@ static int compat_drm_mode_addfb2(struct file *file, unsigned int cmd,
 	struct drm_mode_fb_cmd2 req64;
 	int err;
 
+	memset(&req64, 0, sizeof(req64));
+
 	if (copy_from_user(&req64, argp,
 			   offsetof(drm_mode_fb_cmd232_t, modifier)))
 		return -EFAULT;

