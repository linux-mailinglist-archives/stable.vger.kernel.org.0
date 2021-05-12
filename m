Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6AE437BC4B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhELMMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:12:42 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:43081 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230488AbhELMMl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 08:12:41 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id C7180FA1;
        Wed, 12 May 2021 08:11:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 12 May 2021 08:11:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=BzesU8
        3kMXPFEIrcbbS/WEJaRikl7fGBqxeqvgEcnlY=; b=MdilyvTOC3x+pFQCi1cvTb
        vUzcU067/9ILK/qp87rvpB1DUl07yVaax7e9nRg3U3E2ISexk9owMf7hydhrXOms
        URRjYZ4se59EOjkxQalWeoJfn2yGHfFHHM/QbvyE3+NWh044X8y/UzAK4CWqmnIX
        P3GiueD4F/hUOr4Kai8XfZVfwnWQcAto0BiwnpkBld9OoxVVlpgmom74JDoQHH67
        Eb9tttHst/WNvqljhERx7IvrQevHwAg4AzhCnYqyRZAb7UmVB1Z54E+VDcRZ2uqe
        p8BwRWm0eQjonLp7K2rgmiVcudRdLm7g7mroz5yCwi15ggjqQNC+iQVQ1J+5Shyg
        ==
X-ME-Sender: <xms:9MWbYKOaTAtebZb1nXUJtWfJ-y9iGtn4GuIi1P7JJyHqezo8vHUVRw>
    <xme:9MWbYI9lxtL0FWCDGherKiXY8Qcb1_RwFcdf7sk8S-Ad4E3u4iQEguAtLV1SwmRU1
    A8aGl5xGITL3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:9MWbYBQQ7JZddOJYElS3PhOnGsjFp9imCzDiw4qsjLWkqEDgn65LfQ>
    <xmx:9MWbYKs8SMh7X1xdaiX8yfpfh0eDgpK4UTQz21jiNvegg8x1izQ5nQ>
    <xmx:9MWbYCc7K6GWsvPZs-_o-a4YEL74RC43CXUCBATV6heJdA_neBD0LQ>
    <xmx:9MWbYGESDMQPE9L5K-YMeMlbeKnxF9cocbVhtMNAPn6bJFRPRkFrtZ31bFU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 08:11:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] sctp: delay auto_asconf init until binding the first addr" failed to apply to 5.10-stable tree
To:     lucien.xin@gmail.com, davem@davemloft.net,
        orcohen@paloaltonetworks.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 14:11:26 +0200
Message-ID: <162082148620677@kroah.com>
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

