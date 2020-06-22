Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BF3203EBC
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 20:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbgFVSGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 14:06:04 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:46581 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730241AbgFVSGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 14:06:04 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 1792012F1;
        Mon, 22 Jun 2020 14:06:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 22 Jun 2020 14:06:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Ej5rWQ
        JzxMXPZwPFO/CWUkGG4Lg+ShDKcCUPKlHC3po=; b=QnFwBEapUjuqerbEaReOzQ
        Q5iXbicAsPqeS12GPNkV/R+sQc/d+bS5PLwxDD4WXpZi2ntShEwS/HakFyprsGwZ
        FrFIxRRfQE5bnWFNsS+G5zglpxQ7itgQh3xomTujIdWaVN/oDRrpeU5s/49CtKzA
        i+omJv8P3N3emGODqzizagjJn5J0NsGYQsJjMTOkXEak15PFTZTKH3ZxFXrBU70R
        tTojvAnGy/f6Ldw62BV5FVvrV6L/TMux6cPxASAwzD1G6PvHCinKhid6kuDU1MrR
        XH5gP6pSYMAfFOtmAB+fc4CRDkFZ3Sm3gRn0MM1amEJI4LbGiG79Jc8zKPuRaOfg
        ==
X-ME-Sender: <xms:CvPwXvFjq_AHYrwPTtCU24PvM523vMOLeijm1uHjvPVktsVcP43FuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekvddguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtud
    eujefhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhr
    ghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepheenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:CvPwXsUv5tyZXYw15p7wc67VdMswQXxJc96TKx9JHl8YqNUi6e2s_w>
    <xmx:CvPwXhKt6bPiA5N_w3u2_iPAn07-ijWAZuCYFGHHBzOJ-151tFjiMA>
    <xmx:CvPwXtFIePlc4p6iydA4lfJH0c2d55VaLEj7zy07x81BPHiN8sIwww>
    <xmx:CvPwXmeahK2k3S7GOwdSTPiE_yn6Zka7yWIdXlaJUZPvQ9OyCnf97tGDRkI>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 37E7530673D8;
        Mon, 22 Jun 2020 14:06:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/dp_mst: Kill the second sideband tx slot, save the world" failed to apply to 4.4-stable tree
To:     lyude@redhat.com, Wayne.Lin@amd.com, sean@poorly.run,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Jun 2020 20:05:57 +0200
Message-ID: <15928491578180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d308a881a5917bdb46472c861a1dabe54b46c423 Mon Sep 17 00:00:00 2001
From: Lyude Paul <lyude@redhat.com>
Date: Fri, 24 Apr 2020 14:13:08 -0400
Subject: [PATCH] drm/dp_mst: Kill the second sideband tx slot, save the world

While we support using both tx slots for sideband transmissions, it
appears that DisplayPort devices in the field didn't end up doing a very
good job of supporting it. From section 5.2.1 of the DP 2.0
specification:

  There are MST Sink/Branch devices in the field that do not handle
  interleaved message transactions.

  To facilitate message transaction handling by downstream devices, an
  MST Source device shall generate message transactions in an atomic
  manner (i.e., the MST Source device shall not concurrently interleave
  multiple message transactions). Therefore, an MST Source device shall
  clear the Message_Sequence_No value in the Sideband_MSG_Header to 0.

This might come as a bit of a surprise since the vast majority of hubs
will support using both tx slots even if they don't support interleaved
message transactions, and we've also been using both tx slots since MST
was introduced into the kernel.

However, there is one device we've had trouble getting working
consistently with MST for so long that we actually assumed it was just
broken: the infamous Dell P2415Qb. Previously this monitor would appear
to work sometimes, but in most situations would end up timing out
LINK_ADDRESS messages almost at random until you power cycled the whole
display. After reading section 5.2.1 in the DP 2.0 spec, some closer
investigation into this infamous display revealed it was only ever
timing out on sideband messages in the second TX slot.

Sure enough, avoiding the second TX slot has suddenly made this monitor
function perfectly for the first time in five years. And since they
explicitly mention this in the specification, I doubt this is the only
monitor out there with this issue. This might even explain explain the
seemingly harmless garbage sideband responses we would occasionally see
with MST hubs!

So - rewrite our sideband TX handlers to only support one TX slot. In
order to simplify our sideband handling now that we don't support
transmitting to multiple MSTBs at once, we also move all state tracking
for down replies from mstbs to the topology manager.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper (v0.6)")
Cc: Sean Paul <sean@poorly.run>
Cc: "Lin, Wayne" <Wayne.Lin@amd.com>
Cc: <stable@vger.kernel.org> # v3.17+
Reviewed-by: Sean Paul <sean@poorly.run>
Link: https://patchwork.freedesktop.org/patch/msgid/20200424181308.770749-1-lyude@redhat.com

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index d2c19791b2b6..b90cca361afe 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -1197,16 +1197,8 @@ static int drm_dp_mst_wait_tx_reply(struct drm_dp_mst_branch *mstb,
 
 		/* remove from q */
 		if (txmsg->state == DRM_DP_SIDEBAND_TX_QUEUED ||
-		    txmsg->state == DRM_DP_SIDEBAND_TX_START_SEND) {
+		    txmsg->state == DRM_DP_SIDEBAND_TX_START_SEND)
 			list_del(&txmsg->next);
-		}
-
-		if (txmsg->state == DRM_DP_SIDEBAND_TX_START_SEND ||
-		    txmsg->state == DRM_DP_SIDEBAND_TX_SENT) {
-			mstb->tx_slots[txmsg->seqno] = NULL;
-		}
-		mgr->is_waiting_for_dwn_reply = false;
-
 	}
 out:
 	if (unlikely(ret == -EIO) && drm_debug_enabled(DRM_UT_DP)) {
@@ -2685,22 +2677,6 @@ static int set_hdr_from_dst_qlock(struct drm_dp_sideband_msg_hdr *hdr,
 	struct drm_dp_mst_branch *mstb = txmsg->dst;
 	u8 req_type;
 
-	/* both msg slots are full */
-	if (txmsg->seqno == -1) {
-		if (mstb->tx_slots[0] && mstb->tx_slots[1]) {
-			DRM_DEBUG_KMS("%s: failed to find slot\n", __func__);
-			return -EAGAIN;
-		}
-		if (mstb->tx_slots[0] == NULL && mstb->tx_slots[1] == NULL) {
-			txmsg->seqno = mstb->last_seqno;
-			mstb->last_seqno ^= 1;
-		} else if (mstb->tx_slots[0] == NULL)
-			txmsg->seqno = 0;
-		else
-			txmsg->seqno = 1;
-		mstb->tx_slots[txmsg->seqno] = txmsg;
-	}
-
 	req_type = txmsg->msg[0] & 0x7f;
 	if (req_type == DP_CONNECTION_STATUS_NOTIFY ||
 		req_type == DP_RESOURCE_STATUS_NOTIFY)
@@ -2712,7 +2688,7 @@ static int set_hdr_from_dst_qlock(struct drm_dp_sideband_msg_hdr *hdr,
 	hdr->lcr = mstb->lct - 1;
 	if (mstb->lct > 1)
 		memcpy(hdr->rad, mstb->rad, mstb->lct / 2);
-	hdr->seqno = txmsg->seqno;
+
 	return 0;
 }
 /*
@@ -2727,15 +2703,15 @@ static int process_single_tx_qlock(struct drm_dp_mst_topology_mgr *mgr,
 	int len, space, idx, tosend;
 	int ret;
 
+	if (txmsg->state == DRM_DP_SIDEBAND_TX_SENT)
+		return 0;
+
 	memset(&hdr, 0, sizeof(struct drm_dp_sideband_msg_hdr));
 
-	if (txmsg->state == DRM_DP_SIDEBAND_TX_QUEUED) {
-		txmsg->seqno = -1;
+	if (txmsg->state == DRM_DP_SIDEBAND_TX_QUEUED)
 		txmsg->state = DRM_DP_SIDEBAND_TX_START_SEND;
-	}
 
-	/* make hdr from dst mst - for replies use seqno
-	   otherwise assign one */
+	/* make hdr from dst mst */
 	ret = set_hdr_from_dst_qlock(&hdr, txmsg);
 	if (ret < 0)
 		return ret;
@@ -2788,42 +2764,17 @@ static void process_single_down_tx_qlock(struct drm_dp_mst_topology_mgr *mgr)
 	if (list_empty(&mgr->tx_msg_downq))
 		return;
 
-	txmsg = list_first_entry(&mgr->tx_msg_downq, struct drm_dp_sideband_msg_tx, next);
+	txmsg = list_first_entry(&mgr->tx_msg_downq,
+				 struct drm_dp_sideband_msg_tx, next);
 	ret = process_single_tx_qlock(mgr, txmsg, false);
-	if (ret == 1) {
-		/* txmsg is sent it should be in the slots now */
-		mgr->is_waiting_for_dwn_reply = true;
-		list_del(&txmsg->next);
-	} else if (ret) {
+	if (ret < 0) {
 		DRM_DEBUG_KMS("failed to send msg in q %d\n", ret);
-		mgr->is_waiting_for_dwn_reply = false;
 		list_del(&txmsg->next);
-		if (txmsg->seqno != -1)
-			txmsg->dst->tx_slots[txmsg->seqno] = NULL;
 		txmsg->state = DRM_DP_SIDEBAND_TX_TIMEOUT;
 		wake_up_all(&mgr->tx_waitq);
 	}
 }
 
-/* called holding qlock */
-static void process_single_up_tx_qlock(struct drm_dp_mst_topology_mgr *mgr,
-				       struct drm_dp_sideband_msg_tx *txmsg)
-{
-	int ret;
-
-	/* construct a chunk from the first msg in the tx_msg queue */
-	ret = process_single_tx_qlock(mgr, txmsg, true);
-
-	if (ret != 1)
-		DRM_DEBUG_KMS("failed to send msg in q %d\n", ret);
-
-	if (txmsg->seqno != -1) {
-		WARN_ON((unsigned int)txmsg->seqno >
-			ARRAY_SIZE(txmsg->dst->tx_slots));
-		txmsg->dst->tx_slots[txmsg->seqno] = NULL;
-	}
-}
-
 static void drm_dp_queue_down_tx(struct drm_dp_mst_topology_mgr *mgr,
 				 struct drm_dp_sideband_msg_tx *txmsg)
 {
@@ -2836,8 +2787,7 @@ static void drm_dp_queue_down_tx(struct drm_dp_mst_topology_mgr *mgr,
 		drm_dp_mst_dump_sideband_msg_tx(&p, txmsg);
 	}
 
-	if (list_is_singular(&mgr->tx_msg_downq) &&
-	    !mgr->is_waiting_for_dwn_reply)
+	if (list_is_singular(&mgr->tx_msg_downq))
 		process_single_down_tx_qlock(mgr);
 	mutex_unlock(&mgr->qlock);
 }
@@ -3457,7 +3407,7 @@ static int drm_dp_encode_up_ack_reply(struct drm_dp_sideband_msg_tx *msg, u8 req
 
 static int drm_dp_send_up_ack_reply(struct drm_dp_mst_topology_mgr *mgr,
 				    struct drm_dp_mst_branch *mstb,
-				    int req_type, int seqno, bool broadcast)
+				    int req_type, bool broadcast)
 {
 	struct drm_dp_sideband_msg_tx *txmsg;
 
@@ -3466,13 +3416,11 @@ static int drm_dp_send_up_ack_reply(struct drm_dp_mst_topology_mgr *mgr,
 		return -ENOMEM;
 
 	txmsg->dst = mstb;
-	txmsg->seqno = seqno;
 	drm_dp_encode_up_ack_reply(txmsg, req_type);
 
 	mutex_lock(&mgr->qlock);
-
-	process_single_up_tx_qlock(mgr, txmsg);
-
+	/* construct a chunk from the first msg in the tx_msg queue */
+	process_single_tx_qlock(mgr, txmsg, true);
 	mutex_unlock(&mgr->qlock);
 
 	kfree(txmsg);
@@ -3697,8 +3645,9 @@ int drm_dp_mst_topology_mgr_resume(struct drm_dp_mst_topology_mgr *mgr,
 }
 EXPORT_SYMBOL(drm_dp_mst_topology_mgr_resume);
 
-static bool drm_dp_get_one_sb_msg(struct drm_dp_mst_topology_mgr *mgr, bool up,
-				  struct drm_dp_mst_branch **mstb, int *seqno)
+static bool
+drm_dp_get_one_sb_msg(struct drm_dp_mst_topology_mgr *mgr, bool up,
+		      struct drm_dp_mst_branch **mstb)
 {
 	int len;
 	u8 replyblock[32];
@@ -3706,13 +3655,13 @@ static bool drm_dp_get_one_sb_msg(struct drm_dp_mst_topology_mgr *mgr, bool up,
 	int ret;
 	u8 hdrlen;
 	struct drm_dp_sideband_msg_hdr hdr;
-	struct drm_dp_sideband_msg_rx *msg;
+	struct drm_dp_sideband_msg_rx *msg =
+		up ? &mgr->up_req_recv : &mgr->down_rep_recv;
 	int basereg = up ? DP_SIDEBAND_MSG_UP_REQ_BASE :
 			   DP_SIDEBAND_MSG_DOWN_REP_BASE;
 
 	if (!up)
 		*mstb = NULL;
-	*seqno = -1;
 
 	len = min(mgr->max_dpcd_transaction_bytes, 16);
 	ret = drm_dp_dpcd_read(mgr->aux, basereg, replyblock, len);
@@ -3729,11 +3678,7 @@ static bool drm_dp_get_one_sb_msg(struct drm_dp_mst_topology_mgr *mgr, bool up,
 		return false;
 	}
 
-	*seqno = hdr.seqno;
-
-	if (up) {
-		msg = &mgr->up_req_recv;
-	} else {
+	if (!up) {
 		/* Caller is responsible for giving back this reference */
 		*mstb = drm_dp_get_mst_branch_device(mgr, hdr.lct, hdr.rad);
 		if (!*mstb) {
@@ -3741,7 +3686,6 @@ static bool drm_dp_get_one_sb_msg(struct drm_dp_mst_topology_mgr *mgr, bool up,
 				      hdr.lct);
 			return false;
 		}
-		msg = &(*mstb)->down_rep_recv[hdr.seqno];
 	}
 
 	if (!drm_dp_sideband_msg_set_header(msg, &hdr, hdrlen)) {
@@ -3785,13 +3729,10 @@ static int drm_dp_mst_handle_down_rep(struct drm_dp_mst_topology_mgr *mgr)
 {
 	struct drm_dp_sideband_msg_tx *txmsg;
 	struct drm_dp_mst_branch *mstb = NULL;
-	struct drm_dp_sideband_msg_rx *msg = NULL;
-	int seqno = -1;
-
-	if (!drm_dp_get_one_sb_msg(mgr, false, &mstb, &seqno))
-		goto out_clear_reply;
+	struct drm_dp_sideband_msg_rx *msg = &mgr->down_rep_recv;
 
-	msg = &mstb->down_rep_recv[seqno];
+	if (!drm_dp_get_one_sb_msg(mgr, false, &mstb))
+		goto out;
 
 	/* Multi-packet message transmission, don't clear the reply */
 	if (!msg->have_eomt)
@@ -3799,11 +3740,12 @@ static int drm_dp_mst_handle_down_rep(struct drm_dp_mst_topology_mgr *mgr)
 
 	/* find the message */
 	mutex_lock(&mgr->qlock);
-	txmsg = mstb->tx_slots[seqno];
-	/* remove from slots */
+	txmsg = list_first_entry_or_null(&mgr->tx_msg_downq,
+					 struct drm_dp_sideband_msg_tx, next);
 	mutex_unlock(&mgr->qlock);
 
-	if (!txmsg) {
+	/* Were we actually expecting a response, and from this mstb? */
+	if (!txmsg || txmsg->dst != mstb) {
 		struct drm_dp_sideband_msg_hdr *hdr;
 		hdr = &msg->initial_hdr;
 		DRM_DEBUG_KMS("Got MST reply with no msg %p %d %d %02x %02x\n",
@@ -3828,8 +3770,7 @@ static int drm_dp_mst_handle_down_rep(struct drm_dp_mst_topology_mgr *mgr)
 
 	mutex_lock(&mgr->qlock);
 	txmsg->state = DRM_DP_SIDEBAND_TX_RX;
-	mstb->tx_slots[seqno] = NULL;
-	mgr->is_waiting_for_dwn_reply = false;
+	list_del(&txmsg->next);
 	mutex_unlock(&mgr->qlock);
 
 	wake_up_all(&mgr->tx_waitq);
@@ -3837,11 +3778,7 @@ static int drm_dp_mst_handle_down_rep(struct drm_dp_mst_topology_mgr *mgr)
 	return 0;
 
 out_clear_reply:
-	mutex_lock(&mgr->qlock);
-	mgr->is_waiting_for_dwn_reply = false;
-	mutex_unlock(&mgr->qlock);
-	if (msg)
-		memset(msg, 0, sizeof(struct drm_dp_sideband_msg_rx));
+	memset(msg, 0, sizeof(struct drm_dp_sideband_msg_rx));
 out:
 	if (mstb)
 		drm_dp_mst_topology_put_mstb(mstb);
@@ -3921,9 +3858,8 @@ static void drm_dp_mst_up_req_work(struct work_struct *work)
 static int drm_dp_mst_handle_up_req(struct drm_dp_mst_topology_mgr *mgr)
 {
 	struct drm_dp_pending_up_req *up_req;
-	int seqno;
 
-	if (!drm_dp_get_one_sb_msg(mgr, true, NULL, &seqno))
+	if (!drm_dp_get_one_sb_msg(mgr, true, NULL))
 		goto out;
 
 	if (!mgr->up_req_recv.have_eomt)
@@ -3947,7 +3883,7 @@ static int drm_dp_mst_handle_up_req(struct drm_dp_mst_topology_mgr *mgr)
 	}
 
 	drm_dp_send_up_ack_reply(mgr, mgr->mst_primary, up_req->msg.req_type,
-				 seqno, false);
+				 false);
 
 	if (up_req->msg.req_type == DP_CONNECTION_STATUS_NOTIFY) {
 		const struct drm_dp_connection_status_notify *conn_stat =
@@ -4692,7 +4628,7 @@ static void drm_dp_tx_work(struct work_struct *work)
 	struct drm_dp_mst_topology_mgr *mgr = container_of(work, struct drm_dp_mst_topology_mgr, tx_work);
 
 	mutex_lock(&mgr->qlock);
-	if (!list_empty(&mgr->tx_msg_downq) && !mgr->is_waiting_for_dwn_reply)
+	if (!list_empty(&mgr->tx_msg_downq))
 		process_single_down_tx_qlock(mgr);
 	mutex_unlock(&mgr->qlock);
 }
@@ -4713,26 +4649,25 @@ static inline void
 drm_dp_delayed_destroy_mstb(struct drm_dp_mst_branch *mstb)
 {
 	struct drm_dp_mst_topology_mgr *mgr = mstb->mgr;
-	struct drm_dp_mst_port *port, *tmp;
+	struct drm_dp_mst_port *port, *port_tmp;
+	struct drm_dp_sideband_msg_tx *txmsg, *txmsg_tmp;
 	bool wake_tx = false;
 
 	mutex_lock(&mgr->lock);
-	list_for_each_entry_safe(port, tmp, &mstb->ports, next) {
+	list_for_each_entry_safe(port, port_tmp, &mstb->ports, next) {
 		list_del(&port->next);
 		drm_dp_mst_topology_put_port(port);
 	}
 	mutex_unlock(&mgr->lock);
 
-	/* drop any tx slots msg */
+	/* drop any tx slot msg */
 	mutex_lock(&mstb->mgr->qlock);
-	if (mstb->tx_slots[0]) {
-		mstb->tx_slots[0]->state = DRM_DP_SIDEBAND_TX_TIMEOUT;
-		mstb->tx_slots[0] = NULL;
-		wake_tx = true;
-	}
-	if (mstb->tx_slots[1]) {
-		mstb->tx_slots[1]->state = DRM_DP_SIDEBAND_TX_TIMEOUT;
-		mstb->tx_slots[1] = NULL;
+	list_for_each_entry_safe(txmsg, txmsg_tmp, &mgr->tx_msg_downq, next) {
+		if (txmsg->dst != mstb)
+			continue;
+
+		txmsg->state = DRM_DP_SIDEBAND_TX_TIMEOUT;
+		list_del(&txmsg->next);
 		wake_tx = true;
 	}
 	mutex_unlock(&mstb->mgr->qlock);
diff --git a/include/drm/drm_dp_mst_helper.h b/include/drm/drm_dp_mst_helper.h
index 96bcf33c03d3..9e1ffcd7cb68 100644
--- a/include/drm/drm_dp_mst_helper.h
+++ b/include/drm/drm_dp_mst_helper.h
@@ -194,11 +194,8 @@ struct drm_dp_sideband_msg_rx {
  * @rad: Relative Address to talk to this branch device.
  * @lct: Link count total to talk to this branch device.
  * @num_ports: number of ports on the branch.
- * @msg_slots: one bit per transmitted msg slot.
  * @port_parent: pointer to the port parent, NULL if toplevel.
  * @mgr: topology manager for this branch device.
- * @tx_slots: transmission slots for this device.
- * @last_seqno: last sequence number used to talk to this.
  * @link_address_sent: if a link address message has been sent to this device yet.
  * @guid: guid for DP 1.2 branch device. port under this branch can be
  * identified by port #.
@@ -239,7 +236,6 @@ struct drm_dp_mst_branch {
 	u8 lct;
 	int num_ports;
 
-	int msg_slots;
 	/**
 	 * @ports: the list of ports on this branch device. This should be
 	 * considered protected for reading by &drm_dp_mst_topology_mgr.lock.
@@ -252,20 +248,11 @@ struct drm_dp_mst_branch {
 	 */
 	struct list_head ports;
 
-	/* list of tx ops queue for this port */
 	struct drm_dp_mst_port *port_parent;
 	struct drm_dp_mst_topology_mgr *mgr;
 
-	/* slots are protected by mstb->mgr->qlock */
-	struct drm_dp_sideband_msg_tx *tx_slots[2];
-	int last_seqno;
 	bool link_address_sent;
 
-	/**
-	 * @down_rep_recv: Message receiver state for down replies.
-	 */
-	struct drm_dp_sideband_msg_rx down_rep_recv[2];
-
 	/* global unique identifier to identify branch devices */
 	u8 guid[16];
 };
@@ -567,6 +554,12 @@ struct drm_dp_mst_topology_mgr {
 	 */
 	struct drm_dp_sideband_msg_rx up_req_recv;
 
+	/**
+	 * @down_rep_recv: Message receiver state for replies to down
+	 * requests.
+	 */
+	struct drm_dp_sideband_msg_rx down_rep_recv;
+
 	/**
 	 * @lock: protects @mst_state, @mst_primary, @dpcd, and
 	 * @payload_id_table_cleared.
@@ -592,11 +585,6 @@ struct drm_dp_mst_topology_mgr {
 	 */
 	bool payload_id_table_cleared : 1;
 
-	/**
-	 * @is_waiting_for_dwn_reply: whether we're waiting for a down reply.
-	 */
-	bool is_waiting_for_dwn_reply : 1;
-
 	/**
 	 * @mst_primary: Pointer to the primary/first branch device.
 	 */
@@ -621,13 +609,12 @@ struct drm_dp_mst_topology_mgr {
 	const struct drm_private_state_funcs *funcs;
 
 	/**
-	 * @qlock: protects @tx_msg_downq, the &drm_dp_mst_branch.txslost and
-	 * &drm_dp_sideband_msg_tx.state once they are queued
+	 * @qlock: protects @tx_msg_downq and &drm_dp_sideband_msg_tx.state
 	 */
 	struct mutex qlock;
 
 	/**
-	 * @tx_msg_downq: List of pending down replies.
+	 * @tx_msg_downq: List of pending down requests
 	 */
 	struct list_head tx_msg_downq;
 

