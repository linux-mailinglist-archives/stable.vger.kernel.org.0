Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80A0261B6C
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgIHTDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:03:12 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:54771 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731283AbgIHQHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 12:07:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 8F52BFA9;
        Tue,  8 Sep 2020 11:00:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 08 Sep 2020 11:00:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/c95t0
        SzJQII0oaHtKC3V1mFUu87qyJoJbnZdMtaAUc=; b=KDdpsZe4DPsRMt8la7gaBq
        aBC1CC8gwCjOq3wgTcYYokJ8/s7Uxfm944RAtJuAMWc/RdxfSxMXacZCtI0B5IJH
        4rx/pKDcODHLhdgdWZRtVCn94BBr1GEQ5yIn2nNv/YOqCXDgXcGI8YNUfpPeeabc
        MLad8SrliWyiBY4ttiIuJG5rlE+toV/MGIorxzYftQVRefxlCGHPCurm19vqRwRF
        Heuzv1Y4AqjRQzdd+sOA125aia6KPm1WTFYkMwqJl3iUo7XIaAjcBGX1UdM2XBKp
        9lwQcZFxf4JxEPNY95QlJyKOeRBQSA/exTuZ4YXpfylW27P1rqimx2nMgow86n5A
        ==
X-ME-Sender: <xms:npxXX0g_nCPQrcGsjOoQipmnXG4Xw35Be_4L8Z_uYX4fyMsVAqOXTQ>
    <xme:npxXX9C9t5jiW76JKLRo0LOgfNyAOcLZkVK_4XYn51Cp-UARvLvcfrTIDYBm90q0r
    12Gl78S53zCGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehfedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdetuefgffekieehffdvgeekteegjedujedtieeugf
    ekieeikeegjeefkeetkeegnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdprgguughr
    rdguvghvpdgruggurhdrnhgvthenucfkphepkeefrdekiedrjeegrdeigeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgr
    hhdrtghomh
X-ME-Proxy: <xmx:npxXX8EJ5W1MvMQvmC6oGx6JyAmKbZx7kV6FlAiUNXLB30PaStjmLg>
    <xmx:npxXX1T5FzLlk9nkm_nNUaY9knsMvRGMxTwvWaK9HVUTnE58uDd6_A>
    <xmx:npxXXxxl6ss0MV1p7UnEcYSmoz89ZySf41fowDDK9dM2o__DtfArVw>
    <xmx:n5xXXypbbakhZBcK5do9lmFCaRfdnzFykJlETL7x6AojYyLMpb5uWDeMAT8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 175433064680;
        Tue,  8 Sep 2020 11:00:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] RDMA/cma: Execute rdma_cm destruction from a handler properly" failed to apply to 5.8-stable tree
To:     jgg@ziepe.ca, jgg@nvidia.com, leonro@mellanox.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Sep 2020 17:00:58 +0200
Message-ID: <159957725810195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f6a9d47ae6854980fc4b1676f1fe9f9fa45ea4e2 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgg@ziepe.ca>
Date: Thu, 23 Jul 2020 10:07:07 +0300
Subject: [PATCH] RDMA/cma: Execute rdma_cm destruction from a handler properly

When a rdma_cm_id needs to be destroyed after a handler callback fails,
part of the destruction pattern is open coded into each call site.

Unfortunately the blind assignment to state discards important information
needed to do cma_cancel_operation(). This results in active operations
being left running after rdma_destroy_id() completes, and the
use-after-free bugs from KASAN.

Consolidate this entire pattern into destroy_id_handler_unlock() and
manage the locking correctly. The state should be set to
RDMA_CM_DESTROYING under the handler_lock to atomically ensure no futher
handlers are called.

Link: https://lore.kernel.org/r/20200723070707.1771101-5-leon@kernel.org
Reported-by: syzbot+08092148130652a6faae@syzkaller.appspotmail.com
Reported-by: syzbot+a929647172775e335941@syzkaller.appspotmail.com
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index e07498dceb59..172cc16bd231 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -428,19 +428,6 @@ static int cma_comp_exch(struct rdma_id_private *id_priv,
 	return ret;
 }
 
-static enum rdma_cm_state cma_exch(struct rdma_id_private *id_priv,
-				   enum rdma_cm_state exch)
-{
-	unsigned long flags;
-	enum rdma_cm_state old;
-
-	spin_lock_irqsave(&id_priv->lock, flags);
-	old = id_priv->state;
-	id_priv->state = exch;
-	spin_unlock_irqrestore(&id_priv->lock, flags);
-	return old;
-}
-
 static inline u8 cma_get_ip_ver(const struct cma_hdr *hdr)
 {
 	return hdr->ip_version >> 4;
@@ -1825,21 +1812,9 @@ static void cma_leave_mc_groups(struct rdma_id_private *id_priv)
 	}
 }
 
-void rdma_destroy_id(struct rdma_cm_id *id)
+static void _destroy_id(struct rdma_id_private *id_priv,
+			enum rdma_cm_state state)
 {
-	struct rdma_id_private *id_priv =
-		container_of(id, struct rdma_id_private, id);
-	enum rdma_cm_state state;
-
-	/*
-	 * Wait for any active callback to finish.  New callbacks will find
-	 * the id_priv state set to destroying and abort.
-	 */
-	mutex_lock(&id_priv->handler_mutex);
-	trace_cm_id_destroy(id_priv);
-	state = cma_exch(id_priv, RDMA_CM_DESTROYING);
-	mutex_unlock(&id_priv->handler_mutex);
-
 	cma_cancel_operation(id_priv, state);
 
 	rdma_restrack_del(&id_priv->res);
@@ -1870,6 +1845,42 @@ void rdma_destroy_id(struct rdma_cm_id *id)
 	put_net(id_priv->id.route.addr.dev_addr.net);
 	kfree(id_priv);
 }
+
+/*
+ * destroy an ID from within the handler_mutex. This ensures that no other
+ * handlers can start running concurrently.
+ */
+static void destroy_id_handler_unlock(struct rdma_id_private *id_priv)
+	__releases(&idprv->handler_mutex)
+{
+	enum rdma_cm_state state;
+	unsigned long flags;
+
+	trace_cm_id_destroy(id_priv);
+
+	/*
+	 * Setting the state to destroyed under the handler mutex provides a
+	 * fence against calling handler callbacks. If this is invoked due to
+	 * the failure of a handler callback then it guarentees that no future
+	 * handlers will be called.
+	 */
+	lockdep_assert_held(&id_priv->handler_mutex);
+	spin_lock_irqsave(&id_priv->lock, flags);
+	state = id_priv->state;
+	id_priv->state = RDMA_CM_DESTROYING;
+	spin_unlock_irqrestore(&id_priv->lock, flags);
+	mutex_unlock(&id_priv->handler_mutex);
+	_destroy_id(id_priv, state);
+}
+
+void rdma_destroy_id(struct rdma_cm_id *id)
+{
+	struct rdma_id_private *id_priv =
+		container_of(id, struct rdma_id_private, id);
+
+	mutex_lock(&id_priv->handler_mutex);
+	destroy_id_handler_unlock(id_priv);
+}
 EXPORT_SYMBOL(rdma_destroy_id);
 
 static int cma_rep_recv(struct rdma_id_private *id_priv)
@@ -1934,7 +1945,7 @@ static int cma_ib_handler(struct ib_cm_id *cm_id,
 {
 	struct rdma_id_private *id_priv = cm_id->context;
 	struct rdma_cm_event event = {};
-	int ret = 0;
+	int ret;
 
 	mutex_lock(&id_priv->handler_mutex);
 	if ((ib_event->event != IB_CM_TIMEWAIT_EXIT &&
@@ -2003,14 +2014,12 @@ static int cma_ib_handler(struct ib_cm_id *cm_id,
 	if (ret) {
 		/* Destroy the CM ID by returning a non-zero value. */
 		id_priv->cm_id.ib = NULL;
-		cma_exch(id_priv, RDMA_CM_DESTROYING);
-		mutex_unlock(&id_priv->handler_mutex);
-		rdma_destroy_id(&id_priv->id);
+		destroy_id_handler_unlock(id_priv);
 		return ret;
 	}
 out:
 	mutex_unlock(&id_priv->handler_mutex);
-	return ret;
+	return 0;
 }
 
 static struct rdma_id_private *
@@ -2172,7 +2181,7 @@ static int cma_ib_req_handler(struct ib_cm_id *cm_id,
 	mutex_lock(&listen_id->handler_mutex);
 	if (listen_id->state != RDMA_CM_LISTEN) {
 		ret = -ECONNABORTED;
-		goto err1;
+		goto err_unlock;
 	}
 
 	offset = cma_user_data_offset(listen_id);
@@ -2189,43 +2198,38 @@ static int cma_ib_req_handler(struct ib_cm_id *cm_id,
 	}
 	if (!conn_id) {
 		ret = -ENOMEM;
-		goto err1;
+		goto err_unlock;
 	}
 
 	mutex_lock_nested(&conn_id->handler_mutex, SINGLE_DEPTH_NESTING);
 	ret = cma_ib_acquire_dev(conn_id, listen_id, &req);
-	if (ret)
-		goto err2;
+	if (ret) {
+		destroy_id_handler_unlock(conn_id);
+		goto err_unlock;
+	}
 
 	conn_id->cm_id.ib = cm_id;
 	cm_id->context = conn_id;
 	cm_id->cm_handler = cma_ib_handler;
 
 	ret = cma_cm_event_handler(conn_id, &event);
-	if (ret)
-		goto err3;
+	if (ret) {
+		/* Destroy the CM ID by returning a non-zero value. */
+		conn_id->cm_id.ib = NULL;
+		mutex_unlock(&listen_id->handler_mutex);
+		destroy_id_handler_unlock(conn_id);
+		goto net_dev_put;
+	}
+
 	if (cma_comp(conn_id, RDMA_CM_CONNECT) &&
 	    (conn_id->id.qp_type != IB_QPT_UD)) {
 		trace_cm_send_mra(cm_id->context);
 		ib_send_cm_mra(cm_id, CMA_CM_MRA_SETTING, NULL, 0);
 	}
-	mutex_unlock(&lock);
 	mutex_unlock(&conn_id->handler_mutex);
-	mutex_unlock(&listen_id->handler_mutex);
-	if (net_dev)
-		dev_put(net_dev);
-	return 0;
 
-err3:
-	/* Destroy the CM ID by returning a non-zero value. */
-	conn_id->cm_id.ib = NULL;
-err2:
-	cma_exch(conn_id, RDMA_CM_DESTROYING);
-	mutex_unlock(&conn_id->handler_mutex);
-err1:
+err_unlock:
 	mutex_unlock(&listen_id->handler_mutex);
-	if (conn_id)
-		rdma_destroy_id(&conn_id->id);
 
 net_dev_put:
 	if (net_dev)
@@ -2325,9 +2329,7 @@ static int cma_iw_handler(struct iw_cm_id *iw_id, struct iw_cm_event *iw_event)
 	if (ret) {
 		/* Destroy the CM ID by returning a non-zero value. */
 		id_priv->cm_id.iw = NULL;
-		cma_exch(id_priv, RDMA_CM_DESTROYING);
-		mutex_unlock(&id_priv->handler_mutex);
-		rdma_destroy_id(&id_priv->id);
+		destroy_id_handler_unlock(id_priv);
 		return ret;
 	}
 
@@ -2374,16 +2376,16 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 
 	ret = rdma_translate_ip(laddr, &conn_id->id.route.addr.dev_addr);
 	if (ret) {
-		mutex_unlock(&conn_id->handler_mutex);
-		rdma_destroy_id(new_cm_id);
-		goto out;
+		mutex_unlock(&listen_id->handler_mutex);
+		destroy_id_handler_unlock(conn_id);
+		return ret;
 	}
 
 	ret = cma_iw_acquire_dev(conn_id, listen_id);
 	if (ret) {
-		mutex_unlock(&conn_id->handler_mutex);
-		rdma_destroy_id(new_cm_id);
-		goto out;
+		mutex_unlock(&listen_id->handler_mutex);
+		destroy_id_handler_unlock(conn_id);
+		return ret;
 	}
 
 	conn_id->cm_id.iw = cm_id;
@@ -2397,10 +2399,8 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 	if (ret) {
 		/* User wants to destroy the CM ID */
 		conn_id->cm_id.iw = NULL;
-		cma_exch(conn_id, RDMA_CM_DESTROYING);
-		mutex_unlock(&conn_id->handler_mutex);
 		mutex_unlock(&listen_id->handler_mutex);
-		rdma_destroy_id(&conn_id->id);
+		destroy_id_handler_unlock(conn_id);
 		return ret;
 	}
 
@@ -2638,21 +2638,21 @@ static void cma_work_handler(struct work_struct *_work)
 {
 	struct cma_work *work = container_of(_work, struct cma_work, work);
 	struct rdma_id_private *id_priv = work->id;
-	int destroy = 0;
 
 	mutex_lock(&id_priv->handler_mutex);
 	if (!cma_comp_exch(id_priv, work->old_state, work->new_state))
-		goto out;
+		goto out_unlock;
 
 	if (cma_cm_event_handler(id_priv, &work->event)) {
-		cma_exch(id_priv, RDMA_CM_DESTROYING);
-		destroy = 1;
+		cma_id_put(id_priv);
+		destroy_id_handler_unlock(id_priv);
+		goto out_free;
 	}
-out:
+
+out_unlock:
 	mutex_unlock(&id_priv->handler_mutex);
 	cma_id_put(id_priv);
-	if (destroy)
-		rdma_destroy_id(&id_priv->id);
+out_free:
 	kfree(work);
 }
 
@@ -2660,23 +2660,22 @@ static void cma_ndev_work_handler(struct work_struct *_work)
 {
 	struct cma_ndev_work *work = container_of(_work, struct cma_ndev_work, work);
 	struct rdma_id_private *id_priv = work->id;
-	int destroy = 0;
 
 	mutex_lock(&id_priv->handler_mutex);
 	if (id_priv->state == RDMA_CM_DESTROYING ||
 	    id_priv->state == RDMA_CM_DEVICE_REMOVAL)
-		goto out;
+		goto out_unlock;
 
 	if (cma_cm_event_handler(id_priv, &work->event)) {
-		cma_exch(id_priv, RDMA_CM_DESTROYING);
-		destroy = 1;
+		cma_id_put(id_priv);
+		destroy_id_handler_unlock(id_priv);
+		goto out_free;
 	}
 
-out:
+out_unlock:
 	mutex_unlock(&id_priv->handler_mutex);
 	cma_id_put(id_priv);
-	if (destroy)
-		rdma_destroy_id(&id_priv->id);
+out_free:
 	kfree(work);
 }
 
@@ -3152,9 +3151,7 @@ static void addr_handler(int status, struct sockaddr *src_addr,
 		event.event = RDMA_CM_EVENT_ADDR_RESOLVED;
 
 	if (cma_cm_event_handler(id_priv, &event)) {
-		cma_exch(id_priv, RDMA_CM_DESTROYING);
-		mutex_unlock(&id_priv->handler_mutex);
-		rdma_destroy_id(&id_priv->id);
+		destroy_id_handler_unlock(id_priv);
 		return;
 	}
 out:
@@ -3759,7 +3756,7 @@ static int cma_sidr_rep_handler(struct ib_cm_id *cm_id,
 	struct rdma_cm_event event = {};
 	const struct ib_cm_sidr_rep_event_param *rep =
 				&ib_event->param.sidr_rep_rcvd;
-	int ret = 0;
+	int ret;
 
 	mutex_lock(&id_priv->handler_mutex);
 	if (id_priv->state != RDMA_CM_CONNECT)
@@ -3809,14 +3806,12 @@ static int cma_sidr_rep_handler(struct ib_cm_id *cm_id,
 	if (ret) {
 		/* Destroy the CM ID by returning a non-zero value. */
 		id_priv->cm_id.ib = NULL;
-		cma_exch(id_priv, RDMA_CM_DESTROYING);
-		mutex_unlock(&id_priv->handler_mutex);
-		rdma_destroy_id(&id_priv->id);
+		destroy_id_handler_unlock(id_priv);
 		return ret;
 	}
 out:
 	mutex_unlock(&id_priv->handler_mutex);
-	return ret;
+	return 0;
 }
 
 static int cma_resolve_ib_udp(struct rdma_id_private *id_priv,
@@ -4341,9 +4336,7 @@ static int cma_ib_mc_handler(int status, struct ib_sa_multicast *multicast)
 
 	rdma_destroy_ah_attr(&event.param.ud.ah_attr);
 	if (ret) {
-		cma_exch(id_priv, RDMA_CM_DESTROYING);
-		mutex_unlock(&id_priv->handler_mutex);
-		rdma_destroy_id(&id_priv->id);
+		destroy_id_handler_unlock(id_priv);
 		return 0;
 	}
 
@@ -4784,7 +4777,8 @@ static void cma_send_device_removal_put(struct rdma_id_private *id_priv)
 		 */
 		cma_id_put(id_priv);
 		mutex_unlock(&id_priv->handler_mutex);
-		rdma_destroy_id(&id_priv->id);
+		trace_cm_id_destroy(id_priv);
+		_destroy_id(id_priv, state);
 		return;
 	}
 	mutex_unlock(&id_priv->handler_mutex);

