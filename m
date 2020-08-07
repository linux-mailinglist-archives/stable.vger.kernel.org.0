Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F76223EE29
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 15:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgHGN0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 09:26:51 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:38539 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbgHGN0t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 09:26:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id EE0B19E4;
        Fri,  7 Aug 2020 09:26:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 07 Aug 2020 09:26:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ful0yB
        IhacoD0wzJ/uI6ssmffRXBMCZ00havLF5AwZI=; b=K9iyGC0IcXmgT28mQg6/4h
        FowF6hc3+smK7JwNu1JQw/kycFTBignlADaQXCp3IjMPYhulYTndOef7uu/hGuAQ
        6pvYgN2AVG4wgjtN+3o388ISnQbn5yoQJwa8T+eSyPpuTQxZNBsC4q6Rsxi/vka2
        RhNggNkn0hCRGy3hrTNxNTu1oxbic7++1zSUyREOnkG20Gw4HEfAhc9y+0Tkjiqj
        LdIad1XZKeAP3TEZUwfH5vACVCuh3kMEBllyK8FwfVmolNmlhGPVjl4frB/5Rwu/
        lPDlP/DegeCZpIXjtdhSV/WipWIW0l9vh0Cd1vHatu82FRFgzEFgLNOxzr14q26A
        ==
X-ME-Sender: <xms:l1YtX4HmGX1eJX9bA9R85OSAr7gA_tYkWxvxIwY5cXzLCwVjFPN7Gw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkedvgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecuogfuuhhsphgvtghtffhomhgrihhnucdlgeelmdenuc
    fjughrpefuvffhfffkgggtgfesthekredttddtlfenucfhrhhomhepoehgrhgvghhkhhes
    lhhinhhugihfohhunhgurghtihhonhdrohhrgheqnecuggftrfgrthhtvghrnhepfeegue
    eggeekffefgeekveeggeffgeeljeekjeekleeuffegheefieduffekuefhnecuffhomhgr
    ihhnpegrphhpshhpohhtrdgtohhmpdhkvghrnhgvlhdrohhrghenucfkphepkeefrdekie
    drkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:l1YtXxUnAS5i6r0hbr3gztKRGzC_3N6TWjAbGHj6pXSKLBtivRyWYg>
    <xmx:l1YtXyLaVtSCSi21oMxiFY7HgLOJEK6facBl0V2olJqZ3B-TQaPSCQ>
    <xmx:l1YtX6HYMEmoXxnxo7MC71AYYAv6pS55fuEGHwhTC99oHZCcTu2iDQ>
    <xmx:l1YtXxf3cy_tscXoxNNQIG9p5eMIKWlG3Fd0-84StqWjRDIsFCsFCrdM73U>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 217B13280064;
        Fri,  7 Aug 2020 09:26:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] binder: Prevent context manager from incrementing ref 0" failed to apply to 4.9-stable tree
To:     jannh@google.com, gregkh@linuxfoundation.org, maco@android.com,
        tkjos@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Aug 2020 15:26:53 +0200
Message-ID: <159680681393175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 4b836a1426cb0f1ef2a6e211d7e553221594f8fc Mon Sep 17 00:00:00 2001
From: Jann Horn <jannh@google.com>
Date: Mon, 27 Jul 2020 14:04:24 +0200
Subject: [PATCH] binder: Prevent context manager from incrementing ref 0

Binder is designed such that a binder_proc never has references to
itself. If this rule is violated, memory corruption can occur when a
process sends a transaction to itself; see e.g.
<https://syzkaller.appspot.com/bug?extid=09e05aba06723a94d43d>.

There is a remaining edgecase through which such a transaction-to-self
can still occur from the context of a task with BINDER_SET_CONTEXT_MGR
access:

 - task A opens /dev/binder twice, creating binder_proc instances P1
   and P2
 - P1 becomes context manager
 - P2 calls ACQUIRE on the magic handle 0, allocating index 0 in its
   handle table
 - P1 dies (by closing the /dev/binder fd and waiting a bit)
 - P2 becomes context manager
 - P2 calls ACQUIRE on the magic handle 0, allocating index 1 in its
   handle table
   [this triggers a warning: "binder: 1974:1974 tried to acquire
   reference to desc 0, got 1 instead"]
 - task B opens /dev/binder once, creating binder_proc instance P3
 - P3 calls P2 (via magic handle 0) with (void*)1 as argument (two-way
   transaction)
 - P2 receives the handle and uses it to call P3 (two-way transaction)
 - P3 calls P2 (via magic handle 0) (two-way transaction)
 - P2 calls P2 (via handle 1) (two-way transaction)

And then, if P2 does *NOT* accept the incoming transaction work, but
instead closes the binder fd, we get a crash.

Solve it by preventing the context manager from using ACQUIRE on ref 0.
There shouldn't be any legitimate reason for the context manager to do
that.

Additionally, print a warning if someone manages to find another way to
trigger a transaction-to-self bug in the future.

Cc: stable@vger.kernel.org
Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
Acked-by: Todd Kjos <tkjos@google.com>
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Martijn Coenen <maco@android.com>
Link: https://lore.kernel.org/r/20200727120424.1627555-1-jannh@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index f50c5f182bb5..5b310eea9e52 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2982,6 +2982,12 @@ static void binder_transaction(struct binder_proc *proc,
 			goto err_dead_binder;
 		}
 		e->to_node = target_node->debug_id;
+		if (WARN_ON(proc == target_proc)) {
+			return_error = BR_FAILED_REPLY;
+			return_error_param = -EINVAL;
+			return_error_line = __LINE__;
+			goto err_invalid_target_handle;
+		}
 		if (security_binder_transaction(proc->tsk,
 						target_proc->tsk) < 0) {
 			return_error = BR_FAILED_REPLY;
@@ -3635,10 +3641,17 @@ static int binder_thread_write(struct binder_proc *proc,
 				struct binder_node *ctx_mgr_node;
 				mutex_lock(&context->context_mgr_node_lock);
 				ctx_mgr_node = context->binder_context_mgr_node;
-				if (ctx_mgr_node)
+				if (ctx_mgr_node) {
+					if (ctx_mgr_node->proc == proc) {
+						binder_user_error("%d:%d context manager tried to acquire desc 0\n",
+								  proc->pid, thread->pid);
+						mutex_unlock(&context->context_mgr_node_lock);
+						return -EINVAL;
+					}
 					ret = binder_inc_ref_for_node(
 							proc, ctx_mgr_node,
 							strong, NULL, &rdata);
+				}
 				mutex_unlock(&context->context_mgr_node_lock);
 			}
 			if (ret)

