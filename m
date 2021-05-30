Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66FFB395132
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 15:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhE3OAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 10:00:32 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:50795 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3OAc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 10:00:32 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 54FBC194075D;
        Sun, 30 May 2021 09:58:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 30 May 2021 09:58:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=J0k6gm
        0ITbiG1ndv7BlWu1vp+i5R6g+WvFt9ld4gEmw=; b=wAa0dEhx90/hEzxgAOGK0f
        lkHfXFVFNGlMhy592VKjV6Qmp9HOM5e6lO3uKzyW/plbgtwiFaF7/Oc9owGDjZ7+
        u7FvTTFVDXuikOklQYSsapZY/x0d7MqyYnyeh49RrbEEDabfg4Z/JkZn5ycTY5Hf
        sR542oe6yaxi2BUK1yrLImCjnCkhkMcogO+fceOUzDeXjkX7WlhTwJrLm1wFL7if
        ogqBJzuihgH+k+VbbzrZMaP5xAwwlJ6+U3a2KPO5oC0Vzufr18qwg9l0ujT58O3d
        atxsPFhc5wYGTpzZpUALT7gmV0R+Y+961Co5RhkKcYs2kIGXbJ2Pl9cVaAGJkFuQ
        ==
X-ME-Sender: <xms:HpqzYHLXwIXmwHIQaxnU8gT80CUiaXDzswFeX-_FIdCwRQ9zfp1YBg>
    <xme:HpqzYLJDuvWMTunCUOOfUODLLrupF-rnFm7-S-XGGRE02PEC8bU8loNV-BtUIBog7
    JfSAxPCwwXOaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:HpqzYPsWmbRq1pY98CnKiuGf9opNBMF6h_t0eQcOFMaxBCr-rSQ-Wg>
    <xmx:HpqzYAa3G45o2GGiKvMDzJ748NK6O0glj1g6QApY6ws2YxutHL33nw>
    <xmx:HpqzYOYVCJKgEis6rk5W6X1VmvUROyQ274p3ouNVOoAhvg5nsbLF5g>
    <xmx:HpqzYHD4lbwexeX1fitJZMWBHM2G5EBGVuwdKsx7TY-niyi0IxzCLg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 09:58:53 -0400 (EDT)
Subject: FAILED: patch "[PATCH] SUNRPC in case of backlog, hand free slots directly to" failed to apply to 4.14-stable tree
To:     neilb@suse.de, trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 15:58:43 +0200
Message-ID: <1622383123158238@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e877a88d1f069edced4160792f42c2a8e2dba942 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 17 May 2021 09:59:10 +1000
Subject: [PATCH] SUNRPC in case of backlog, hand free slots directly to
 waiting task

If sunrpc.tcp_max_slot_table_entries is small and there are tasks
on the backlog queue, then when a request completes it is freed and the
first task on the queue is woken.  The expectation is that it will wake
and claim that request.  However if it was a sync task and the waiting
process was killed at just that moment, it will wake and NOT claim the
request.

As long as TASK_CONGESTED remains set, requests can only be claimed by
tasks woken from the backlog, and they are woken only as requests are
freed, so when a task doesn't claim a request, no other task can ever
get that request until TASK_CONGESTED is cleared.  Each time this
happens the number of available requests is decreased by one.

With a sufficiently high workload and sufficiently low setting of
max_slot (16 in the case where this was seen), TASK_CONGESTED can remain
set for an extended period, and the above scenario (of a process being
killed just as its task was woken) can repeat until no requests can be
allocated.  Then traffic stops.

This patch addresses the problem by introducing a positive handover of a
request from a completing task to a backlog task - the request is never
freed when there is a backlog.

When a task is woken it might not already have a request attached in
which case it is *not* freed (as with current code) but is initialised
(if needed) and used.  If it isn't used it will eventually be freed by
rpc_exit_task().  xprt_release() is enhanced to be able to correctly
release an uninitialised request.

Fixes: ba60eb25ff6b ("SUNRPC: Fix a livelock problem in the xprt->backlog queue")
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index f555d335e910..42623d6b8f0e 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1677,13 +1677,6 @@ call_reserveresult(struct rpc_task *task)
 		return;
 	}
 
-	/*
-	 * Even though there was an error, we may have acquired
-	 * a request slot somehow.  Make sure not to leak it.
-	 */
-	if (task->tk_rqstp)
-		xprt_release(task);
-
 	switch (status) {
 	case -ENOMEM:
 		rpc_delay(task, HZ >> 2);
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index e5b5a960a69b..5b3981fd3783 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -70,6 +70,7 @@
 static void	 xprt_init(struct rpc_xprt *xprt, struct net *net);
 static __be32	xprt_alloc_xid(struct rpc_xprt *xprt);
 static void	 xprt_destroy(struct rpc_xprt *xprt);
+static void	 xprt_request_init(struct rpc_task *task);
 
 static DEFINE_SPINLOCK(xprt_list_lock);
 static LIST_HEAD(xprt_list);
@@ -1612,10 +1613,26 @@ static void xprt_add_backlog(struct rpc_xprt *xprt, struct rpc_task *task)
 	rpc_sleep_on(&xprt->backlog, task, NULL);
 }
 
-static void xprt_wake_up_backlog(struct rpc_xprt *xprt)
+static bool __xprt_set_rq(struct rpc_task *task, void *data)
 {
-	if (rpc_wake_up_next(&xprt->backlog) == NULL)
+	struct rpc_rqst *req = data;
+
+	if (task->tk_rqstp == NULL) {
+		memset(req, 0, sizeof(*req));	/* mark unused */
+		task->tk_status = -EAGAIN;
+		task->tk_rqstp = req;
+		return true;
+	}
+	return false;
+}
+
+static bool xprt_wake_up_backlog(struct rpc_xprt *xprt, struct rpc_rqst *req)
+{
+	if (rpc_wake_up_first(&xprt->backlog, __xprt_set_rq, req) == NULL) {
 		clear_bit(XPRT_CONGESTED, &xprt->state);
+		return false;
+	}
+	return true;
 }
 
 static bool xprt_throttle_congested(struct rpc_xprt *xprt, struct rpc_task *task)
@@ -1703,11 +1720,11 @@ EXPORT_SYMBOL_GPL(xprt_alloc_slot);
 void xprt_free_slot(struct rpc_xprt *xprt, struct rpc_rqst *req)
 {
 	spin_lock(&xprt->reserve_lock);
-	if (!xprt_dynamic_free_slot(xprt, req)) {
+	if (!xprt_wake_up_backlog(xprt, req) &&
+	    !xprt_dynamic_free_slot(xprt, req)) {
 		memset(req, 0, sizeof(*req));	/* mark unused */
 		list_add(&req->rq_list, &xprt->free);
 	}
-	xprt_wake_up_backlog(xprt);
 	spin_unlock(&xprt->reserve_lock);
 }
 EXPORT_SYMBOL_GPL(xprt_free_slot);
@@ -1795,6 +1812,10 @@ xprt_request_init(struct rpc_task *task)
 	struct rpc_xprt *xprt = task->tk_xprt;
 	struct rpc_rqst	*req = task->tk_rqstp;
 
+	if (req->rq_task)
+		/* Already initialized */
+		return;
+
 	req->rq_task	= task;
 	req->rq_xprt    = xprt;
 	req->rq_buffer  = NULL;
@@ -1855,8 +1876,10 @@ void xprt_retry_reserve(struct rpc_task *task)
 	struct rpc_xprt *xprt = task->tk_xprt;
 
 	task->tk_status = 0;
-	if (task->tk_rqstp != NULL)
+	if (task->tk_rqstp != NULL) {
+		xprt_request_init(task);
 		return;
+	}
 
 	task->tk_status = -EAGAIN;
 	xprt_do_reserve(xprt, task);
@@ -1881,23 +1904,26 @@ void xprt_release(struct rpc_task *task)
 	}
 
 	xprt = req->rq_xprt;
-	xprt_request_dequeue_xprt(task);
-	spin_lock(&xprt->transport_lock);
-	xprt->ops->release_xprt(xprt, task);
-	if (xprt->ops->release_request)
-		xprt->ops->release_request(task);
-	xprt_schedule_autodisconnect(xprt);
-	spin_unlock(&xprt->transport_lock);
-	if (req->rq_buffer)
-		xprt->ops->buf_free(task);
-	xdr_free_bvec(&req->rq_rcv_buf);
-	xdr_free_bvec(&req->rq_snd_buf);
-	if (req->rq_cred != NULL)
-		put_rpccred(req->rq_cred);
-	task->tk_rqstp = NULL;
-	if (req->rq_release_snd_buf)
-		req->rq_release_snd_buf(req);
+	if (xprt) {
+		xprt_request_dequeue_xprt(task);
+		spin_lock(&xprt->transport_lock);
+		xprt->ops->release_xprt(xprt, task);
+		if (xprt->ops->release_request)
+			xprt->ops->release_request(task);
+		xprt_schedule_autodisconnect(xprt);
+		spin_unlock(&xprt->transport_lock);
+		if (req->rq_buffer)
+			xprt->ops->buf_free(task);
+		xdr_free_bvec(&req->rq_rcv_buf);
+		xdr_free_bvec(&req->rq_snd_buf);
+		if (req->rq_cred != NULL)
+			put_rpccred(req->rq_cred);
+		if (req->rq_release_snd_buf)
+			req->rq_release_snd_buf(req);
+	} else
+		xprt = task->tk_xprt;
 
+	task->tk_rqstp = NULL;
 	if (likely(!bc_prealloc(req)))
 		xprt->ops->free_slot(xprt, req);
 	else

