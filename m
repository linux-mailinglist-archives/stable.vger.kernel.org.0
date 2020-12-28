Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B992E35FA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 11:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbgL1Knf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 05:43:35 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:56835 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbgL1Kne (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 05:43:34 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id D16562D0;
        Mon, 28 Dec 2020 05:42:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 05:42:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=uUlQVj
        jCVG70J4WMU3qOMRky0TjN+fYrCcE2RnGQ5Hc=; b=oK/xqFzue1KHSxoS4zqUkK
        I0CH7okEpORtXjiOqGfRBdoG3bxx0xRry4ET/y7JqonO1UURNqJ/q+7nYMXPIb4p
        2/69XH74gaDhmYj2x3cNNQPkOHGRWI4+/mTsFzvBg8vlFD/Xr5biOsrjlMPKPhZk
        dKKGrygQ+qFIuD7qGWdY/EFl8gkd/F2/QyyjB4esfbpHrsgdveBZBuquVzmb2E0p
        9oT+SttdOUvYZKDXCaNpcKRZdiVnDoO+eU3xFUFY4NOCb2wYK2jvzHu/XOLg9Qn5
        nbQKYu1ufaG9KCcQXXyA3YRcil7Csx5yW1RM/3YDj0P8PhicIV4CZE2q3e0bJ/5g
        ==
X-ME-Sender: <xms:p7bpXxEBpGYyGHqjyr-FAHrqAgDie0khLnPtNyABiFUY5PVc7v-C7A>
    <xme:p7bpX2XWaw4yw0PBcbwAVOWoC5OHHlbRC7oPPqrYWPAp0944aC_oDBnVUqNIolJeF
    0jQHx0GUTK8sQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:p7bpXzJfBTkNypSQQ_yperqoPvTDEyy7iTS844JpFxJPcoCknWxnSg>
    <xmx:p7bpX3Hgy31cUgmctKNGA2vpUG6e_Je1ijAbiB2TuVwSn4Z0IAVdDQ>
    <xmx:p7bpX3Xa4903XmJ5_rYfa8Mot2CdUO8ToJwszvbLnCt0jjtWAXpNAw>
    <xmx:qLbpX4dwWKiSKqIGCkJGFeFpHi6cyRe5-YcizqorFCmNadUFGfxm8meB4mY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B2A581080064;
        Mon, 28 Dec 2020 05:42:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/panfrost: Fix job timeout handling" failed to apply to 5.4-stable tree
To:     boris.brezillon@collabora.com, stable@vger.kernel.org,
        steven.price@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 11:44:10 +0100
Message-ID: <160915225015161@kroah.com>
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

From 1a11a88cfd9a97e13be8bc880c4795f9844fbbec Mon Sep 17 00:00:00 2001
From: Boris Brezillon <boris.brezillon@collabora.com>
Date: Fri, 2 Oct 2020 14:25:06 +0200
Subject: [PATCH] drm/panfrost: Fix job timeout handling

If more than two jobs end up timeout-ing concurrently, only one of them
(the one attached to the scheduler acquiring the lock) is fully handled.
The other one remains in a dangling state where it's no longer part of
the scheduling queue, but still blocks something in scheduler, leading
to repetitive timeouts when new jobs are queued.

Let's make sure all bad jobs are properly handled by the thread
acquiring the lock.

v3:
- Add Steven's R-b
- Don't take the sched_lock when stopping the schedulers

v2:
- Fix the subject prefix
- Stop the scheduler before returning from panfrost_job_timedout()
- Call cancel_delayed_work_sync() after drm_sched_stop() to make sure
  no timeout handlers are in flight when we reset the GPU (Steven Price)
- Make sure we release the reset lock before restarting the
  schedulers (Steven Price)

Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201002122506.1374183-1-boris.brezillon@collabora.com

diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
index 30e7b7196dab..d0469e944143 100644
--- a/drivers/gpu/drm/panfrost/panfrost_job.c
+++ b/drivers/gpu/drm/panfrost/panfrost_job.c
@@ -25,7 +25,8 @@
 
 struct panfrost_queue_state {
 	struct drm_gpu_scheduler sched;
-
+	bool stopped;
+	struct mutex lock;
 	u64 fence_context;
 	u64 emit_seqno;
 };
@@ -369,6 +370,24 @@ void panfrost_job_enable_interrupts(struct panfrost_device *pfdev)
 	job_write(pfdev, JOB_INT_MASK, irq_mask);
 }
 
+static bool panfrost_scheduler_stop(struct panfrost_queue_state *queue,
+				    struct drm_sched_job *bad)
+{
+	bool stopped = false;
+
+	mutex_lock(&queue->lock);
+	if (!queue->stopped) {
+		drm_sched_stop(&queue->sched, bad);
+		if (bad)
+			drm_sched_increase_karma(bad);
+		queue->stopped = true;
+		stopped = true;
+	}
+	mutex_unlock(&queue->lock);
+
+	return stopped;
+}
+
 static void panfrost_job_timedout(struct drm_sched_job *sched_job)
 {
 	struct panfrost_job *job = to_panfrost_job(sched_job);
@@ -392,19 +411,39 @@ static void panfrost_job_timedout(struct drm_sched_job *sched_job)
 		job_read(pfdev, JS_TAIL_LO(js)),
 		sched_job);
 
+	/* Scheduler is already stopped, nothing to do. */
+	if (!panfrost_scheduler_stop(&pfdev->js->queue[js], sched_job))
+		return;
+
 	if (!mutex_trylock(&pfdev->reset_lock))
 		return;
 
 	for (i = 0; i < NUM_JOB_SLOTS; i++) {
 		struct drm_gpu_scheduler *sched = &pfdev->js->queue[i].sched;
 
-		drm_sched_stop(sched, sched_job);
-		if (js != i)
-			/* Ensure any timeouts on other slots have finished */
+		/*
+		 * If the queue is still active, make sure we wait for any
+		 * pending timeouts.
+		 */
+		if (!pfdev->js->queue[i].stopped)
 			cancel_delayed_work_sync(&sched->work_tdr);
-	}
 
-	drm_sched_increase_karma(sched_job);
+		/*
+		 * If the scheduler was not already stopped, there's a tiny
+		 * chance a timeout has expired just before we stopped it, and
+		 * drm_sched_stop() does not flush pending works. Let's flush
+		 * them now so the timeout handler doesn't get called in the
+		 * middle of a reset.
+		 */
+		if (panfrost_scheduler_stop(&pfdev->js->queue[i], NULL))
+			cancel_delayed_work_sync(&sched->work_tdr);
+
+		/*
+		 * Now that we cancelled the pending timeouts, we can safely
+		 * reset the stopped state.
+		 */
+		pfdev->js->queue[i].stopped = false;
+	}
 
 	spin_lock_irqsave(&pfdev->js->job_lock, flags);
 	for (i = 0; i < NUM_JOB_SLOTS; i++) {
@@ -421,11 +460,11 @@ static void panfrost_job_timedout(struct drm_sched_job *sched_job)
 	for (i = 0; i < NUM_JOB_SLOTS; i++)
 		drm_sched_resubmit_jobs(&pfdev->js->queue[i].sched);
 
+	mutex_unlock(&pfdev->reset_lock);
+
 	/* restart scheduler after GPU is usable again */
 	for (i = 0; i < NUM_JOB_SLOTS; i++)
 		drm_sched_start(&pfdev->js->queue[i].sched, true);
-
-	mutex_unlock(&pfdev->reset_lock);
 }
 
 static const struct drm_sched_backend_ops panfrost_sched_ops = {
@@ -558,6 +597,7 @@ int panfrost_job_open(struct panfrost_file_priv *panfrost_priv)
 	int ret, i;
 
 	for (i = 0; i < NUM_JOB_SLOTS; i++) {
+		mutex_init(&js->queue[i].lock);
 		sched = &js->queue[i].sched;
 		ret = drm_sched_entity_init(&panfrost_priv->sched_entity[i],
 					    DRM_SCHED_PRIORITY_NORMAL, &sched,
@@ -570,10 +610,14 @@ int panfrost_job_open(struct panfrost_file_priv *panfrost_priv)
 
 void panfrost_job_close(struct panfrost_file_priv *panfrost_priv)
 {
+	struct panfrost_device *pfdev = panfrost_priv->pfdev;
+	struct panfrost_job_slot *js = pfdev->js;
 	int i;
 
-	for (i = 0; i < NUM_JOB_SLOTS; i++)
+	for (i = 0; i < NUM_JOB_SLOTS; i++) {
 		drm_sched_entity_destroy(&panfrost_priv->sched_entity[i]);
+		mutex_destroy(&js->queue[i].lock);
+	}
 }
 
 int panfrost_job_is_idle(struct panfrost_device *pfdev)

