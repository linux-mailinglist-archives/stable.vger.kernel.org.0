Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C292327CF8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhCALSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:18:38 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:45315 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232240AbhCALSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 06:18:37 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 812911941169;
        Mon,  1 Mar 2021 06:17:24 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 01 Mar 2021 06:17:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=X+X2lH
        4zbcpOHk/rLU8tRabeqz5R1RYKuVliZpeDFw8=; b=C7r6BRC5Q5GZlBTYXspoXW
        MNR+yF8VMEGkkk5w7GsmpHwFn/8YNboSCuhfqWBOwQaRLTy3clj4jGySJx76qgW6
        Muq0xVLebWpj4jocomYCsG0LLCHDrBJq91B/gHV0O42m+6L2S5hEphhjz82VEHyR
        x5SNG+UXinrzJFtxxnKQ9fIxGkq2JkigDoHJRAlIyCH5eO1pmRfhs5q1Ban5jg5o
        KWSvwJfh+FQuNwd2WYN0DVcPQEEbSwWQ8hN09yqJJqqGaVUHr+qyYSM0bTtKjwJR
        7/0vQKgglwllhnBoisN/8BFHCIUgWQhJxZiC1O5xGicrzZC7ORM4FpuBkTozZK1w
        ==
X-ME-Sender: <xms:Q808YISP92Nr2tHE25qnfS3VBW3YSVaEaiV6g3CjqYSkmAOZ-jZHMw>
    <xme:Q808YFs0fimuMhlaGuQcAScp6JkE0tJD51zrPXWDXAac_sUWbnUha50s1YgJbPulF
    V3XdEmoFT12OQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:Q808YCsCz9zbbh0lXAv89QpPZLoG5V5_hWRAWzUPp1EQ6CYzs5lZAg>
    <xmx:Q808YDx7ZQuvrLcM82z4OLyZz-VQEsQ4ybxkJDlomBGfk_pl7-xoBA>
    <xmx:Q808YAhqPLlxWhEn2niL8g_ESEaxsSdC39UYMQKcDCDdcBaGEQijnw>
    <xmx:RM08YEmOBAJ0qPjugBtTDDDVxC7NLtaEI-NwemCVOoV7stIQCITTZQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A4F9F1080068;
        Mon,  1 Mar 2021 06:17:23 -0500 (EST)
Subject: FAILED: patch "[PATCH] media: v4l: ioctl: Fix memory leak in video_usercopy" failed to apply to 4.9-stable tree
To:     sakari.ailus@linux.intel.com, arnd@arndb.de, arnd@kernel.org,
        hverkuil-cisco@xs4all.nl, laurent.pinchart@ideasonboard.com,
        mchehab+huawei@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 12:17:20 +0100
Message-ID: <16145974403931@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fb18802a338b36f675a388fc03d2aa504a0d0899 Mon Sep 17 00:00:00 2001
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Sat, 19 Dec 2020 23:29:58 +0100
Subject: [PATCH] media: v4l: ioctl: Fix memory leak in video_usercopy

When an IOCTL with argument size larger than 128 that also used array
arguments were handled, two memory allocations were made but alas, only
the latter one of them was released. This happened because there was only
a single local variable to hold such a temporary allocation.

Fix this by adding separate variables to hold the pointers to the
temporary allocations.

Reported-by: Arnd Bergmann <arnd@kernel.org>
Reported-by: syzbot+1115e79c8df6472c612b@syzkaller.appspotmail.com
Fixes: d14e6d76ebf7 ("[media] v4l: Add multi-planar ioctl handling code")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 3198abdd538c..9906b41004e9 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -3283,7 +3283,7 @@ video_usercopy(struct file *file, unsigned int orig_cmd, unsigned long arg,
 	       v4l2_kioctl func)
 {
 	char	sbuf[128];
-	void    *mbuf = NULL;
+	void    *mbuf = NULL, *array_buf = NULL;
 	void	*parg = (void *)arg;
 	long	err  = -EINVAL;
 	bool	has_array_args;
@@ -3318,27 +3318,21 @@ video_usercopy(struct file *file, unsigned int orig_cmd, unsigned long arg,
 	has_array_args = err;
 
 	if (has_array_args) {
-		/*
-		 * When adding new types of array args, make sure that the
-		 * parent argument to ioctl (which contains the pointer to the
-		 * array) fits into sbuf (so that mbuf will still remain
-		 * unused up to here).
-		 */
-		mbuf = kvmalloc(array_size, GFP_KERNEL);
+		array_buf = kvmalloc(array_size, GFP_KERNEL);
 		err = -ENOMEM;
-		if (NULL == mbuf)
+		if (array_buf == NULL)
 			goto out_array_args;
 		err = -EFAULT;
 		if (in_compat_syscall())
-			err = v4l2_compat_get_array_args(file, mbuf, user_ptr,
-							 array_size, orig_cmd,
-							 parg);
+			err = v4l2_compat_get_array_args(file, array_buf,
+							 user_ptr, array_size,
+							 orig_cmd, parg);
 		else
-			err = copy_from_user(mbuf, user_ptr, array_size) ?
+			err = copy_from_user(array_buf, user_ptr, array_size) ?
 								-EFAULT : 0;
 		if (err)
 			goto out_array_args;
-		*kernel_ptr = mbuf;
+		*kernel_ptr = array_buf;
 	}
 
 	/* Handles IOCTL */
@@ -3360,12 +3354,13 @@ video_usercopy(struct file *file, unsigned int orig_cmd, unsigned long arg,
 		if (in_compat_syscall()) {
 			int put_err;
 
-			put_err = v4l2_compat_put_array_args(file, user_ptr, mbuf,
-							     array_size, orig_cmd,
-							     parg);
+			put_err = v4l2_compat_put_array_args(file, user_ptr,
+							     array_buf,
+							     array_size,
+							     orig_cmd, parg);
 			if (put_err)
 				err = put_err;
-		} else if (copy_to_user(user_ptr, mbuf, array_size)) {
+		} else if (copy_to_user(user_ptr, array_buf, array_size)) {
 			err = -EFAULT;
 		}
 		goto out_array_args;
@@ -3381,6 +3376,7 @@ video_usercopy(struct file *file, unsigned int orig_cmd, unsigned long arg,
 	if (video_put_user((void __user *)arg, parg, cmd, orig_cmd))
 		err = -EFAULT;
 out:
+	kvfree(array_buf);
 	kvfree(mbuf);
 	return err;
 }

