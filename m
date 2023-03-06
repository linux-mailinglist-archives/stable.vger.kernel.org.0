Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894556ABD79
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 11:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjCFK5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 05:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjCFK5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 05:57:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AAC25B90
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 02:57:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5888660DD3
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 10:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D44C433EF;
        Mon,  6 Mar 2023 10:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678100222;
        bh=zIDEH5yJH1oxTuHa9ja4RplJAV3RwRxshrOuJrA8g+8=;
        h=Subject:To:Cc:From:Date:From;
        b=D/96ipkoC1U9Ctw5l5HvOz9nnM/VGxGOGeTAyjZMG0G8OCvtTLXcGJU6P9UGXtiQC
         CTUiapLDpuQlnoP3PQR2AHKsmF+y2gY6288JrUrDt8uPj2BxUOOd9+4HB5qVu8IKzg
         UqI8V17Y/7Tn0zA0ZOZIWVniRLutpyQuA5059WFM=
Subject: FAILED: patch "[PATCH] media: uvcvideo: Fix race condition with usb_kill_urb" failed to apply to 5.10-stable tree
To:     ribalda@chromium.org, laurent.pinchart@ideasonboard.com,
        yunkec@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 11:56:55 +0100
Message-ID: <1678100215149200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x 619d9b710cf06f7a00a17120ca92333684ac45a8
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678100215149200@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

619d9b710cf0 ("media: uvcvideo: Fix race condition with usb_kill_urb")
40140eda661e ("media: uvcvideo: Implement mask for V4L2_CTRL_TYPE_MENU")
adfd3910c27f ("media: uvcvideo: Remove void casting for the status endpoint")
382075604a68 ("media: uvcvideo: Limit power line control for Quanta UVC Webcam")
710871163510 ("media: uvcvideo: Add missing value for power_line_frequency")
70fa906d6fce ("media: uvcvideo: Use control names from framework")
9b31ea808a44 ("media: uvcvideo: Add support for V4L2_CTRL_TYPE_CTRL_CLASS")
866c6bdd5663 ("media: uvcvideo: refactor __uvc_ctrl_add_mapping")
9e56380ae625 ("media: uvcvideo: Rename debug functions")
ed4c5fa4d804 ("media: uvcvideo: use dev_printk() for uvc_trace()")
59e92bf62771 ("media: uvcvideo: New macro uvc_trace_cont")
69df09547e7a ("media: uvcvideo: Use dev_ printk aliases")
6f6a87eb8266 ("media: uvcvideo: Add Privacy control based on EXT_GPIO")
2886477ff987 ("media: uvcvideo: Implement UVC_EXT_GPIO_UNIT")
d9c8763e6129 ("media: uvcvideo: Provide sync and async uvc_ctrl_status_event")
351509c604dc ("media: uvcvideo: Move guid to entity")
dc9455ffae02 ("media: uvcvideo: Accept invalid bFormatIndex and bFrameIndex values")
b400b6f28af0 ("media: uvcvideo: Force UVC version to 1.0a for 1bcf:0b40")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 619d9b710cf06f7a00a17120ca92333684ac45a8 Mon Sep 17 00:00:00 2001
From: Ricardo Ribalda <ribalda@chromium.org>
Date: Thu, 5 Jan 2023 15:31:29 +0100
Subject: [PATCH] media: uvcvideo: Fix race condition with usb_kill_urb

usb_kill_urb warranties that all the handlers are finished when it
returns, but does not protect against threads that might be handling
asynchronously the urb.

For UVC, the function uvc_ctrl_status_event_async() takes care of
control changes asynchronously.

If the code is executed in the following order:

CPU 0					CPU 1
===== 					=====
uvc_status_complete()
					uvc_status_stop()
uvc_ctrl_status_event_work()
					uvc_status_start() -> FAIL

Then uvc_status_start will keep failing and this error will be shown:

<4>[    5.540139] URB 0000000000000000 submitted while active
drivers/usb/core/urb.c:378 usb_submit_urb+0x4c3/0x528

Let's improve the current situation, by not re-submiting the urb if
we are stopping the status event. Also process the queued work
(if any) during stop.

CPU 0					CPU 1
===== 					=====
uvc_status_complete()
					uvc_status_stop()
					uvc_status_start()
uvc_ctrl_status_event_work() -> FAIL

Hopefully, with the usb layer protection this should be enough to cover
all the cases.

Cc: stable@vger.kernel.org
Fixes: e5225c820c05 ("media: uvcvideo: Send a control event when a Control Change interrupt arrives")
Reviewed-by: Yunke Cao <yunkec@chromium.org>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index ee58f0db2763..c3aeba3fe31b 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -6,6 +6,7 @@
  *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  */
 
+#include <asm/barrier.h>
 #include <linux/bitops.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
@@ -1571,6 +1572,10 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
 
 	uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
 
+	/* The barrier is needed to synchronize with uvc_status_stop(). */
+	if (smp_load_acquire(&dev->flush_status))
+		return;
+
 	/* Resubmit the URB. */
 	w->urb->interval = dev->int_ep->desc.bInterval;
 	ret = usb_submit_urb(w->urb, GFP_KERNEL);
diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index 602830a8023e..a78a88c710e2 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -6,6 +6,7 @@
  *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  */
 
+#include <asm/barrier.h>
 #include <linux/kernel.h>
 #include <linux/input.h>
 #include <linux/slab.h>
@@ -311,5 +312,41 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags)
 
 void uvc_status_stop(struct uvc_device *dev)
 {
+	struct uvc_ctrl_work *w = &dev->async_ctrl;
+
+	/*
+	 * Prevent the asynchronous control handler from requeing the URB. The
+	 * barrier is needed so the flush_status change is visible to other
+	 * CPUs running the asynchronous handler before usb_kill_urb() is
+	 * called below.
+	 */
+	smp_store_release(&dev->flush_status, true);
+
+	/*
+	 * Cancel any pending asynchronous work. If any status event was queued,
+	 * process it synchronously.
+	 */
+	if (cancel_work_sync(&w->work))
+		uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
+
+	/* Kill the urb. */
 	usb_kill_urb(dev->int_urb);
+
+	/*
+	 * The URB completion handler may have queued asynchronous work. This
+	 * won't resubmit the URB as flush_status is set, but it needs to be
+	 * cancelled before returning or it could then race with a future
+	 * uvc_status_start() call.
+	 */
+	if (cancel_work_sync(&w->work))
+		uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
+
+	/*
+	 * From this point, there are no events on the queue and the status URB
+	 * is dead. No events will be queued until uvc_status_start() is called.
+	 * The barrier is needed to make sure that flush_status is visible to
+	 * uvc_ctrl_status_event_work() when uvc_status_start() will be called
+	 * again.
+	 */
+	smp_store_release(&dev->flush_status, false);
 }
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index e85df8deb965..c0e706fcd2cb 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -577,6 +577,7 @@ struct uvc_device {
 	struct usb_host_endpoint *int_ep;
 	struct urb *int_urb;
 	struct uvc_status *status;
+	bool flush_status;
 
 	struct input_dev *input;
 	char input_phys[64];

