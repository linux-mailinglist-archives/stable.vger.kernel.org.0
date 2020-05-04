Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE82F1C3419
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 10:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgEDIKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 04:10:00 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:36565 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726750AbgEDIJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 04:09:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 014D5652;
        Mon,  4 May 2020 04:09:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 04 May 2020 04:09:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/pjk5x
        og8S9HuL+3SQPZita9jqb2tlYsh7f8LsFvDWA=; b=nYykRWjlL6lnjdS99Z/6Ja
        nDg3Sdjj9sKxyJDi1RxaoM132urkZjdoUY621tts2QmNKZGcFzUrNUM44pE1JZeq
        Bat1xY/qftfPRBmQSqLCBneQ6CnQNAJcZkYxtr/AsLonw4fAwNANzJyQd8h2026y
        em+SwODeW5MR4EeIoo2Fs/R3xxq/qE2tAeZIoUKLZPVqZ5dPAM8DeTmY0YklpSy1
        6MLwXqbls4wdrQGbyl54Xta784Z21VNnU8jNLIuRieAqm4z4W6WU4Z5ar2mwXyD0
        yTiJncVGU8cyvnW8Lkyn5+A/1JzggJR1PwlVKGGzPuLsDqrAz5SM0iDHg8k0YO8g
        ==
X-ME-Sender: <xms:1s2vXrsck-nKn_0PwVyHz3Ik6uBAti2Jdbg7ELocyaNVE2Rj0xOtpw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrjeegucetufdoteggodetrfdotffvucfrrh
    hofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttddtlfenuc
    fhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhrgheqnecu
    ggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejudetveeuve
    eludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:1s2vXquwQvv8VpQ08xBQa1tA6bIkTcb9vg1stJ9wGXVmbWFonqQZhw>
    <xmx:1s2vXo5erxQfXfIuRSVd4acjfYbBARUBYQA-OVAUSvtEtb-B8r9NJw>
    <xmx:1s2vXmkxaXwmlNsmn6Gu3frJ_bly-d3H9WbEYFvzyLxcgi53qAhTmQ>
    <xmx:1s2vXhxtiGNCDvlFeFY7OsJ5FCKTCJmqq1RBaKze1Z7GXXs2D5ULcevSzYo>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0A7933066000;
        Mon,  4 May 2020 04:09:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] NFSv4.1: fix handling of backchannel binding in" failed to apply to 5.4-stable tree
To:     olga.kornievskaia@gmail.com, kolga@netapp.com,
        trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 May 2020 10:09:56 +0200
Message-ID: <158857979623126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From dff58530c4ca8ce7ee5a74db431c6e35362cf682 Mon Sep 17 00:00:00 2001
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Date: Fri, 24 Apr 2020 17:45:50 -0400
Subject: [PATCH] NFSv4.1: fix handling of backchannel binding in
 BIND_CONN_TO_SESSION

Currently, if the client sends BIND_CONN_TO_SESSION with
NFS4_CDFC4_FORE_OR_BOTH but only gets NFS4_CDFS4_FORE back it ignores
that it wasn't able to enable a backchannel.

To make sure, the client sends BIND_CONN_TO_SESSION as the first
operation on the connections (ie., no other session compounds haven't
been sent before), and if the client's request to bind the backchannel
is not satisfied, then reset the connection and retry.

Cc: stable@vger.kernel.org
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 1c710a7834c2..a0c1e653a935 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7891,6 +7891,7 @@ static void
 nfs4_bind_one_conn_to_session_done(struct rpc_task *task, void *calldata)
 {
 	struct nfs41_bind_conn_to_session_args *args = task->tk_msg.rpc_argp;
+	struct nfs41_bind_conn_to_session_res *res = task->tk_msg.rpc_resp;
 	struct nfs_client *clp = args->client;
 
 	switch (task->tk_status) {
@@ -7899,6 +7900,12 @@ nfs4_bind_one_conn_to_session_done(struct rpc_task *task, void *calldata)
 		nfs4_schedule_session_recovery(clp->cl_session,
 				task->tk_status);
 	}
+	if (args->dir == NFS4_CDFC4_FORE_OR_BOTH &&
+			res->dir != NFS4_CDFS4_BOTH) {
+		rpc_task_close_connection(task);
+		if (args->retries++ < MAX_BIND_CONN_TO_SESSION_RETRIES)
+			rpc_restart_call(task);
+	}
 }
 
 static const struct rpc_call_ops nfs4_bind_one_conn_to_session_ops = {
@@ -7921,6 +7928,7 @@ int nfs4_proc_bind_one_conn_to_session(struct rpc_clnt *clnt,
 	struct nfs41_bind_conn_to_session_args args = {
 		.client = clp,
 		.dir = NFS4_CDFC4_FORE_OR_BOTH,
+		.retries = 0,
 	};
 	struct nfs41_bind_conn_to_session_res res;
 	struct rpc_message msg = {
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 440230488025..e5f3e7d8d3d5 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1317,11 +1317,13 @@ struct nfs41_impl_id {
 	struct nfstime4			date;
 };
 
+#define MAX_BIND_CONN_TO_SESSION_RETRIES 3
 struct nfs41_bind_conn_to_session_args {
 	struct nfs_client		*client;
 	struct nfs4_sessionid		sessionid;
 	u32				dir;
 	bool				use_conn_in_rdma_mode;
+	int				retries;
 };
 
 struct nfs41_bind_conn_to_session_res {
diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index 7bd124e06b36..02e7a5863d28 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -242,4 +242,9 @@ static inline int rpc_reply_expected(struct rpc_task *task)
 		(task->tk_msg.rpc_proc->p_decode != NULL);
 }
 
+static inline void rpc_task_close_connection(struct rpc_task *task)
+{
+	if (task->tk_xprt)
+		xprt_force_disconnect(task->tk_xprt);
+}
 #endif /* _LINUX_SUNRPC_CLNT_H */

