Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4AE39513B
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 16:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhE3OFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 10:05:05 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:44385 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3OFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 10:05:04 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6E2CD1940174;
        Sun, 30 May 2021 10:03:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 30 May 2021 10:03:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Jfq6jx
        4KU9zuTsNYzBAIHIeqw/qMUhbgTy20i1x2rxg=; b=udgbEhBy0qlumnYDGm46ov
        nAVE0/ezAuepYFm5S+hlT4gkOhJ4DRcGANZSKL0HH27McnEhHpZMNbR9iOxnvtTH
        pEbjX7Auxolu6QxehsRV0wA5WyOpk7LbB6ZF0vaWotXlQ+cylGyCDjecoMFWQjo6
        H54W3ZXRGQRGId/VSJNDgNKPvkCNYyZ7VvdqVFjT7MRcdpOqrlADTWWGyeH+ZatX
        1f0rHgSVFBrxc0n7KhpAeFEFmsmT5yykEzXq7gHw9lYIi+mYnZDjfvkDYFbnfBSc
        sGsFGc2n2n+932mG6x4dS9nSrHk2MXLOvUVdzf4o+eUdDwtA184dXtpCMRJItDZg
        ==
X-ME-Sender: <xms:LpuzYCp0IEwesFonDywAsnrkoqWBC1VBD04jBDcb3Vx6moCGa7O4dA>
    <xme:LpuzYApO3VzmqCPhjYrWuNDVdHKFR4DaeQa8vtsWW-849JT6DK7211yEg9H5_vFnu
    2xRzyfBQNrddQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:LpuzYHOO7_K9SfDL6t84boR1L8zSvanr3QgQnxmHW5QrVcQqU11gOw>
    <xmx:LpuzYB5l4vraxXCdrEpULlRwqJFvKPSwWwAi2RP4j0-fUd1PURr_lw>
    <xmx:LpuzYB7GKbFgcwpInGlJ4Lv47ffbIcouEngFcRhS9H-T3cUjExReIw>
    <xmx:LpuzYBE5kMlrntcUiNUjaXkxdkfg27OsgjeEuEPsjwM_llSG8qSGUw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 10:03:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tipc: wait and exit until all work queues are done" failed to apply to 4.14-stable tree
To:     lucien.xin@gmail.com, davem@davemloft.net, jmaloy@redhat.com,
        shuali@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 16:03:15 +0200
Message-ID: <162238339514660@kroah.com>
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

From 04c26faa51d1e2fe71cf13c45791f5174c37f986 Mon Sep 17 00:00:00 2001
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 17 May 2021 02:28:58 +0800
Subject: [PATCH] tipc: wait and exit until all work queues are done

On some host, a crash could be triggered simply by repeating these
commands several times:

  # modprobe tipc
  # tipc bearer enable media udp name UDP1 localip 127.0.0.1
  # rmmod tipc

  [] BUG: unable to handle kernel paging request at ffffffffc096bb00
  [] Workqueue: events 0xffffffffc096bb00
  [] Call Trace:
  []  ? process_one_work+0x1a7/0x360
  []  ? worker_thread+0x30/0x390
  []  ? create_worker+0x1a0/0x1a0
  []  ? kthread+0x116/0x130
  []  ? kthread_flush_work_fn+0x10/0x10
  []  ? ret_from_fork+0x35/0x40

When removing the TIPC module, the UDP tunnel sock will be delayed to
release in a work queue as sock_release() can't be done in rtnl_lock().
If the work queue is schedule to run after the TIPC module is removed,
kernel will crash as the work queue function cleanup_beareri() code no
longer exists when trying to invoke it.

To fix it, this patch introduce a member wq_count in tipc_net to track
the numbers of work queues in schedule, and  wait and exit until all
work queues are done in tipc_exit_net().

Fixes: d0f91938bede ("tipc: add ip/udp media type")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/tipc/core.c b/net/tipc/core.c
index 5cc1f0307215..72f3ac73779b 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -119,6 +119,8 @@ static void __net_exit tipc_exit_net(struct net *net)
 #ifdef CONFIG_TIPC_CRYPTO
 	tipc_crypto_stop(&tipc_net(net)->crypto_tx);
 #endif
+	while (atomic_read(&tn->wq_count))
+		cond_resched();
 }
 
 static void __net_exit tipc_pernet_pre_exit(struct net *net)
diff --git a/net/tipc/core.h b/net/tipc/core.h
index 03de7b213f55..5741ae488bb5 100644
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -149,6 +149,8 @@ struct tipc_net {
 #endif
 	/* Work item for net finalize */
 	struct tipc_net_work final_work;
+	/* The numbers of work queues in schedule */
+	atomic_t wq_count;
 };
 
 static inline struct tipc_net *tipc_net(struct net *net)
diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index e556d2cdc064..c2bb818704c8 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -814,6 +814,7 @@ static void cleanup_bearer(struct work_struct *work)
 		kfree_rcu(rcast, rcu);
 	}
 
+	atomic_dec(&tipc_net(sock_net(ub->ubsock->sk))->wq_count);
 	dst_cache_destroy(&ub->rcast.dst_cache);
 	udp_tunnel_sock_release(ub->ubsock);
 	synchronize_net();
@@ -834,6 +835,7 @@ static void tipc_udp_disable(struct tipc_bearer *b)
 	RCU_INIT_POINTER(ub->bearer, NULL);
 
 	/* sock_release need to be done outside of rtnl lock */
+	atomic_inc(&tipc_net(sock_net(ub->ubsock->sk))->wq_count);
 	INIT_WORK(&ub->work, cleanup_bearer);
 	schedule_work(&ub->work);
 }

