Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0629377E14
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhEJIYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:24:50 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:35079 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230201AbhEJIYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:24:50 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 5CE101940BCD;
        Mon, 10 May 2021 04:23:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 10 May 2021 04:23:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/QGFnw
        nXM3U3kGwMhdrqWAXhmmqe/5nJHBmjJHfDrwM=; b=kDz6wRjGI+UvwCpIUgZoA1
        N30StuVGR8iUGBT8SUvtOMkRsKTPkmIbcsEVkgmdVrER3Hz+30rGMdikwuiyMxm/
        wY8WZ3Ccfg/X8SCTFMbolerR/XcTF3+9ANSIxB/5LkAREMj8YkJGtqB6q0d/r774
        1vXQzOtsVHVAkiVOtRYFbMfCJDgBa+RTPZPlRhwNfF7oLU7HZK8n0MsI0/W530Vk
        fHEIoPfuOmZRivdMD+ijnx4t/ZoB0ATXVBmmQnttx8yrJAjpBi6xIeeES0nAviB9
        rouRBNsT979L9mOW9UURar4AWV2Zt6xVlrD9s8OtPTn9Guf47mirGKYyJBfnev2Q
        ==
X-ME-Sender: <xms:ke2YYEcgwotjERhyPpgr07ea9aCkIb9pTv7_CG5mJmUuowTqnU59Kw>
    <xme:ke2YYGOkEYYbpeuTqphNk9fCFCrh4L0cgoKji2PtVuA59Sc8qw1YbozauWCprNL6c
    M36CVGR3vpTEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ke2YYFhI2EsGMi7d6OBG48y8J6-zdwM3X6AaPA7goBcbKsgmUWak5A>
    <xmx:ke2YYJ9JGeKfObp6i7eIm7KrKnURwFuQZwy1jaXoGF1pxQmp3ZLaTQ>
    <xmx:ke2YYAv3wPkSxPIqK9g2LfiydsVioUqMNzXghpZqp4EedamKGPJlgA>
    <xmx:ke2YYNVJTlpyj2-whbqsjBeHsXjiJ7nYjB5DEtYJh4JcCBARu-qzJg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:23:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/compat: Clear bounce structures" failed to apply to 5.4-stable tree
To:     daniel.vetter@ffwll.ch, daniel.vetter@intel.com, mripard@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:23:33 +0200
Message-ID: <162063501380203@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

