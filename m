Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B68037BC4F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhELMMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:12:55 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:60383 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230494AbhELMMy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 08:12:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 3A719FA1;
        Wed, 12 May 2021 08:11:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 08:11:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lAUFno
        3QthMgwiwrn5Tpm7fV1+6qaBe+L3NBjrWC9f8=; b=A2GyGLm9cXYwWbeHGuPxSM
        aHViT4DQoojPq6iuRZ2qVzJ9bRTEHZTfFE9JpOliAjZAuS1Fc2Sm5LNB4ZZWRHkj
        iOFv2zZI1hR+beTm1t2REnSAy5l8D2sz2Zkj0OHMK5Fss720JoBjxf+80Z3GFc7h
        9h8w7esN7XgcH9JB3gjN1SUcCbeww62J5siwCEpmg5q2zJdcWDTnIBeEY9ZSBC7K
        IrDUA+qZQBi+lNQT+4NnHG8aKv5dmLCZ4YmMKJ8r64BOt3rG6VHmot3P8ly00MCA
        xR6W8frQZqtreUxjhsp+NnjHZjSKzDB8oGiDu95BloW+NL/pYVOUcO0Uia16KK9w
        ==
X-ME-Sender: <xms:AcabYIw0DXXevzVqfCeA5DWGr7DwXTraXbX5l2O3jakxdOQs94WCpg>
    <xme:AcabYMRD29T7-XH9ozbIyn2QAxiZVYhwUBYLBF80fDwlYTCUpmg-iTawR7HLJk-S1
    zABXkoN4gkTjg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:AcabYKVKTggqOw676g09sfvspJ_MzLhkHMkowy6Hs-EvAVTFQv48Gw>
    <xmx:AcabYGhyZQuOz5guzrt1s9yUq7UViH_-yDPJl96a3T6XPBhWYQbUvw>
    <xmx:AcabYKDqHuNO-4FKPp76hZUc1DTeY2BVAzwUWFcPNlSY-NyFE6QDpg>
    <xmx:AcabYL5igbb3widb7kMRwRlc57htD6-6I84rgPWl1QtwUi_-_ozV5EJtMTI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 08:11:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] sctp: delay auto_asconf init until binding the first addr" failed to apply to 4.9-stable tree
To:     lucien.xin@gmail.com, davem@davemloft.net,
        orcohen@paloaltonetworks.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 14:11:36 +0200
Message-ID: <1620821496258@kroah.com>
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

From 34e5b01186858b36c4d7c87e1a025071e8e2401f Mon Sep 17 00:00:00 2001
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 3 May 2021 05:11:42 +0800
Subject: [PATCH] sctp: delay auto_asconf init until binding the first addr

As Or Cohen described:

  If sctp_destroy_sock is called without sock_net(sk)->sctp.addr_wq_lock
  held and sp->do_auto_asconf is true, then an element is removed
  from the auto_asconf_splist without any proper locking.

  This can happen in the following functions:
  1. In sctp_accept, if sctp_sock_migrate fails.
  2. In inet_create or inet6_create, if there is a bpf program
     attached to BPF_CGROUP_INET_SOCK_CREATE which denies
     creation of the sctp socket.

This patch is to fix it by moving the auto_asconf init out of
sctp_init_sock(), by which inet_create()/inet6_create() won't
need to operate it in sctp_destroy_sock() when calling
sk_common_release().

It also makes more sense to do auto_asconf init while binding the
first addr, as auto_asconf actually requires an ANY addr bind,
see it in sctp_addr_wq_timeout_handler().

This addresses CVE-2021-23133.

Fixes: 610236587600 ("bpf: Add new cgroup attach type to enable sock modifications")
Reported-by: Or Cohen <orcohen@paloaltonetworks.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 76a388b5021c..40f9f6c4a0a1 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -357,6 +357,18 @@ static struct sctp_af *sctp_sockaddr_af(struct sctp_sock *opt,
 	return af;
 }
 
+static void sctp_auto_asconf_init(struct sctp_sock *sp)
+{
+	struct net *net = sock_net(&sp->inet.sk);
+
+	if (net->sctp.default_auto_asconf) {
+		spin_lock(&net->sctp.addr_wq_lock);
+		list_add_tail(&sp->auto_asconf_list, &net->sctp.auto_asconf_splist);
+		spin_unlock(&net->sctp.addr_wq_lock);
+		sp->do_auto_asconf = 1;
+	}
+}
+
 /* Bind a local address either to an endpoint or to an association.  */
 static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
 {
@@ -418,8 +430,10 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
 		return -EADDRINUSE;
 
 	/* Refresh ephemeral port.  */
-	if (!bp->port)
+	if (!bp->port) {
 		bp->port = inet_sk(sk)->inet_num;
+		sctp_auto_asconf_init(sp);
+	}
 
 	/* Add the address to the bind address list.
 	 * Use GFP_ATOMIC since BHs will be disabled.
@@ -4993,19 +5007,6 @@ static int sctp_init_sock(struct sock *sk)
 	sk_sockets_allocated_inc(sk);
 	sock_prot_inuse_add(net, sk->sk_prot, 1);
 
-	/* Nothing can fail after this block, otherwise
-	 * sctp_destroy_sock() will be called without addr_wq_lock held
-	 */
-	if (net->sctp.default_auto_asconf) {
-		spin_lock(&sock_net(sk)->sctp.addr_wq_lock);
-		list_add_tail(&sp->auto_asconf_list,
-		    &net->sctp.auto_asconf_splist);
-		sp->do_auto_asconf = 1;
-		spin_unlock(&sock_net(sk)->sctp.addr_wq_lock);
-	} else {
-		sp->do_auto_asconf = 0;
-	}
-
 	local_bh_enable();
 
 	return 0;
@@ -9401,6 +9402,8 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 			return err;
 	}
 
+	sctp_auto_asconf_init(newsp);
+
 	/* Move any messages in the old socket's receive queue that are for the
 	 * peeled off association to the new socket's receive queue.
 	 */

