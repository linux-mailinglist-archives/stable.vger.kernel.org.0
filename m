Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDF7377E11
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhEJIYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:24:49 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:42545 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230098AbhEJIYs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:24:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id C46C619402C9;
        Mon, 10 May 2021 04:23:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 10 May 2021 04:23:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1UCG/M
        7hykve/w10bGKvQrJ3cCe7ljYQLnRd7RJtflY=; b=AZadmrVQ+Qrh05Q4+L6D6f
        10M3Wt8RI3fBs+BU1kmVhyOmASpEqejWLKBKsow6JaSbI8wx2GeHELk86domnD7u
        4bMCtWTKQ7884WdU4UDJFSFavhSQXMlzB//JtfTa86/3IitPXx9Pj+DGqhWdxLRn
        YvW2Nf77Wt8ejAxAsIZUEPBEk8LsIg/CkOWrLFYr+6OUUnppU5uuPRtij5wkzGRx
        +Q8j5HmH/vKShp89alyMMx3yHWymloV4ANoLIR7vr8lwunPqvH4gb2qCPeyFrfWZ
        7xw6eWVJDuLHiw+HBVET+TZB4KirOqFqLSQ05L04KKoz7OlcnXj/Y/WlfoJWdSAA
        ==
X-ME-Sender: <xms:je2YYIoLbMIO_qWoow4DHaCF57Cv-7Zvzsd3WP5QfJ3-JMc_pmGf7g>
    <xme:je2YYOoBjXEQOxhbteeh6L8xZe16gtrp03AfCXkcaZRTH8agaTk5BC8CxmRD1Z076
    UAy-O9doL5UTw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:je2YYNNk2q-mril8UEdw6eoPkh6HezPCBeJhP4naJkszp8SPKmbMfQ>
    <xmx:je2YYP7r-Uevfbp-zDQGS0Y7BFZPOfln8hwzy7fOMpkLYLOcOhf2HQ>
    <xmx:je2YYH5z2z1kn9o0ucIegg60_fZjPrZ7mAD2fBOpJPA8d76aIofroQ>
    <xmx:je2YYBQ513kOitR-C8hrZHKwC9sJtd1iNvKcLRTXTsAwcf6QJIOadg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:23:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/compat: Clear bounce structures" failed to apply to 5.10-stable tree
To:     daniel.vetter@ffwll.ch, daniel.vetter@intel.com, mripard@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:23:32 +0200
Message-ID: <1620635012119159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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

