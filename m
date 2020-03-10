Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D38F17F509
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 11:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgCJK2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 06:28:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56379 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725845AbgCJK23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 06:28:29 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 613A821C57;
        Tue, 10 Mar 2020 06:28:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 10 Mar 2020 06:28:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3H0oR8
        fZjbU6hVYXJMeyoTChy46tvCT1zw/9G9/qNfA=; b=iUg8QrEekt0CbJqNrXHy8l
        k1FLAsiA4quiSjLHpIehWFzlpTFaRg2Dfs88o5hdSAwqpbve1NAFOX522KrNpHB6
        eHbBIFx5t3gV6OzWR3RfBGqkZ3A+2jIcwC9UlvC39Y5bRRzyXtg5FyxVG3HrGtvO
        xLnE2nDqmVwsb9WEKdzBx46L1xaf4sTTVUl81t6uzcRCYsD7y9kCR0rIl8HjDIUI
        gtENExIvb7JaQisaI5RRE40jPZyG4OgUNWlhRYSQSJXrX2wNdk6HCwYvzqAD3osZ
        GR4hbYfTknz3pp1gnfSX/C8YFquG+k8bgKHjnnoh+QhWQG2Ovyz8anSh8VaJavSA
        ==
X-ME-Sender: <xms:zGtnXpUWr5RJX1P5hhEbI9xBaCxiFoQ9wLq5UHDyCHT3k0h2sRqjQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddvtddgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:zGtnXv7DmzexA8E4LkLsmF9uw3K1YPYpuxWJOQ-M1FkgOANKWtuIdQ>
    <xmx:zGtnXrYcHYMpu-Qm7Zgy8S7S7tAZLWPMCUH7kVuP_MGg6ylSpUTJNw>
    <xmx:zGtnXppe9aVtBEZ_hj7LDeyq3HvEbZMAZS9-SErwhjXMND7NIosSmQ>
    <xmx:zGtnXkeiUHuhxBZZFm4RbVBCEceK5hU_GiN1e_Tav4ZLHf80OPMKqg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1104330614FA;
        Tue, 10 Mar 2020 06:28:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/hfi1, qib: Ensure RCU is locked when accessing list" failed to apply to 4.4-stable tree
To:     dennis.dalessandro@intel.com, jgg@mellanox.com,
        mike.marciniszyn@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Mar 2020 11:28:18 +0100
Message-ID: <158383609820158@kroah.com>
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

From 817a68a6584aa08e323c64283fec5ded7be84759 Mon Sep 17 00:00:00 2001
From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Date: Tue, 25 Feb 2020 14:54:45 -0500
Subject: [PATCH] IB/hfi1, qib: Ensure RCU is locked when accessing list

The packet handling function, specifically the iteration of the qp list
for mad packet processing misses locking RCU before running through the
list. Not only is this incorrect, but the list_for_each_entry_rcu() call
can not be called with a conditional check for lock dependency. Remedy
this by invoking the rcu lock and unlock around the critical section.

This brings MAD packet processing in line with what is done for non-MAD
packets.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Link: https://lore.kernel.org/r/20200225195445.140896.41873.stgit@awfm-01.aw.intel.com
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 089e201d7550..2f6323ad9c59 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -515,10 +515,11 @@ static inline void hfi1_handle_packet(struct hfi1_packet *packet,
 				       opa_get_lid(packet->dlid, 9B));
 		if (!mcast)
 			goto drop;
+		rcu_read_lock();
 		list_for_each_entry_rcu(p, &mcast->qp_list, list) {
 			packet->qp = p->qp;
 			if (hfi1_do_pkey_check(packet))
-				goto drop;
+				goto unlock_drop;
 			spin_lock_irqsave(&packet->qp->r_lock, flags);
 			packet_handler = qp_ok(packet);
 			if (likely(packet_handler))
@@ -527,6 +528,7 @@ static inline void hfi1_handle_packet(struct hfi1_packet *packet,
 				ibp->rvp.n_pkt_drops++;
 			spin_unlock_irqrestore(&packet->qp->r_lock, flags);
 		}
+		rcu_read_unlock();
 		/*
 		 * Notify rvt_multicast_detach() if it is waiting for us
 		 * to finish.
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 33778d451b82..5ef93f8f17a1 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -329,8 +329,10 @@ void qib_ib_rcv(struct qib_ctxtdata *rcd, void *rhdr, void *data, u32 tlen)
 		if (mcast == NULL)
 			goto drop;
 		this_cpu_inc(ibp->pmastats->n_multicast_rcv);
+		rcu_read_lock();
 		list_for_each_entry_rcu(p, &mcast->qp_list, list)
 			qib_qp_rcv(rcd, hdr, 1, data, tlen, p->qp);
+		rcu_read_unlock();
 		/*
 		 * Notify rvt_multicast_detach() if it is waiting for us
 		 * to finish.

