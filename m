Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8513537BC4A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhELMMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:12:39 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:39681 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230484AbhELMMi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 08:12:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id BB5C2FA1;
        Wed, 12 May 2021 08:11:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 08:11:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=oshOtR
        D/uS7CzBsE7Cf1XtHe7bePiR90MH5UCfzM85o=; b=mlb/eUHnV3Bd26c6R75DER
        uZXel7Fw2vmLtMfMiIukOAsHpQw9Lt9+cLT5rl4qQDpA0vaPIPnRNP4+cVhBCzhN
        jgThwHAjFGtQnlgOo+YmJi5QQdU17DnGECzbStAenGH7yCFJOJIHyXyFmDG+UgMT
        Kjko3IOuqz7Nxlgk5mQGqDxAwc95bwxWKejcxjDeTtdGI6SGsml7RWe9P3d7y0Oz
        qde/r5x9rYFKaDEokHzTbHunZlUHlHzdNdBHwtmYmoJ6iJf4YRtCu5zvJxUb8xjU
        MeTi9k20DXnQa3IwOAbTBVcX3g7zF/W/vDnbiSegJmI8U47fWSTuuTyVs6gThieQ
        ==
X-ME-Sender: <xms:8cWbYJ6tbL7n8fwIz99B2i93USth1CijqdUHCOXU4aBpAOvRQ8zH-A>
    <xme:8cWbYG783xG6xRiCAi0i5VnUbs4HxsjEhB-MyRExRkWr5jwvohx-FH_s-3jJQ7970
    rewZcOw32f8Bw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:8cWbYAen8elUnkHerB8f-jY-dUTCtnEFC5XmAWPNDz-LRPDKUB-rvg>
    <xmx:8cWbYCLUSwnBazOFafFD3wVRkrQFldbcUl23Rt0wmSPQU6MTj-JMQQ>
    <xmx:8cWbYNKie11XLw6FIucSDQOvxjHh9bGAIK5N-SYPKO5Eu9AlEyoa8A>
    <xmx:8cWbYLiByC07JP1zKqdjaC-_x0NTMihnCOCEns2U1UjylnA8gd99runFRvQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 08:11:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] sctp: delay auto_asconf init until binding the first addr" failed to apply to 5.11-stable tree
To:     lucien.xin@gmail.com, davem@davemloft.net,
        orcohen@paloaltonetworks.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 14:11:23 +0200
Message-ID: <16208214832387@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
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

