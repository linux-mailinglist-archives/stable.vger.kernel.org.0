Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E82D35ADF7
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 16:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbhDJOIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 10:08:12 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:45991 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234392AbhDJOIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 10:08:11 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id C15C0194102F;
        Sat, 10 Apr 2021 10:07:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 10:07:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=03lFOm
        gvD/9IyfOzNYbaKtYcVZejEw6AH5IUk4yvw/4=; b=sz6lKLIDU/fPE6/7beQWbA
        tX5Ffu+QJndsHpyEv6M0rtsrkPSPtk0kjnu5C7lgx7ZU75LR6QWqMZBb7ibzYzOo
        RuS0wMIziPW80GCX9053QD+Ee1zfGUi18jAyc1XydLRJ2YR/nc3j7Vk/3tUwUG6s
        1blWwIo1fBAaw8YZKmekT0Gqw/RHmlWMCgVM+3yVDts5sysCb69td3Fz8N+vEZWe
        FN3TZMz8w3fiW5QjA8KAUJbz7TMjVfti987THRhcdtUU9RhY3su00jovQWd74mcu
        i9S2Gn78hGf2VyZywLFxbX1Noivv3cP3d2btjDs1ET5etPR8v/j1Wxg+uvsVJUuA
        ==
X-ME-Sender: <xms:PLFxYPnd_tTxKd2Yb92X641pDaJx6atWDdvd0Nlqv-KMkStocNMpkg>
    <xme:PLFxYC1VdINcNpf7Pkd24mPbqBo3Fmg2sSIY6iMxVlaqAx46UGs_E6QEbz_qqGAgR
    NLjJYreXmLdxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:PLFxYFoK6_8htsi6HOTXxspqjASuLdohO4kJ_odWxUT6_O9rWUBIhw>
    <xmx:PLFxYHmwO_70XAJ032tK34QoBIDKGzFM0gynH1hS5j7LtiU6AREeLQ>
    <xmx:PLFxYN2dxrkkKM6bAOS23GHV9DUNUPrAFbECU1K3JJY4grjySEU4ow>
    <xmx:PLFxYO_xIJwav72XBBZ_vwBdsTqW2EK5Hc8xRSc6cewZzwXZyu3u7A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 14DF6240054;
        Sat, 10 Apr 2021 10:07:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bpf, sockmap: Fix incorrect fwd_alloc accounting" failed to apply to 5.4-stable tree
To:     john.fastabend@gmail.com, andrii@kernel.org, daniel@iogearbox.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Apr 2021 16:07:54 +0200
Message-ID: <1618063674226238@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 144748eb0c445091466c9b741ebd0bfcc5914f3d Mon Sep 17 00:00:00 2001
From: John Fastabend <john.fastabend@gmail.com>
Date: Thu, 1 Apr 2021 15:00:40 -0700
Subject: [PATCH] bpf, sockmap: Fix incorrect fwd_alloc accounting

Incorrect accounting fwd_alloc can result in a warning when the socket
is torn down,

 [18455.319240] WARNING: CPU: 0 PID: 24075 at net/core/stream.c:208 sk_stream_kill_queues+0x21f/0x230
 [...]
 [18455.319543] Call Trace:
 [18455.319556]  inet_csk_destroy_sock+0xba/0x1f0
 [18455.319577]  tcp_rcv_state_process+0x1b4e/0x2380
 [18455.319593]  ? lock_downgrade+0x3a0/0x3a0
 [18455.319617]  ? tcp_finish_connect+0x1e0/0x1e0
 [18455.319631]  ? sk_reset_timer+0x15/0x70
 [18455.319646]  ? tcp_schedule_loss_probe+0x1b2/0x240
 [18455.319663]  ? lock_release+0xb2/0x3f0
 [18455.319676]  ? __release_sock+0x8a/0x1b0
 [18455.319690]  ? lock_downgrade+0x3a0/0x3a0
 [18455.319704]  ? lock_release+0x3f0/0x3f0
 [18455.319717]  ? __tcp_close+0x2c6/0x790
 [18455.319736]  ? tcp_v4_do_rcv+0x168/0x370
 [18455.319750]  tcp_v4_do_rcv+0x168/0x370
 [18455.319767]  __release_sock+0xbc/0x1b0
 [18455.319785]  __tcp_close+0x2ee/0x790
 [18455.319805]  tcp_close+0x20/0x80

This currently happens because on redirect case we do skb_set_owner_r()
with the original sock. This increments the fwd_alloc memory accounting
on the original sock. Then on redirect we may push this into the queue
of the psock we are redirecting to. When the skb is flushed from the
queue we give the memory back to the original sock. The problem is if
the original sock is destroyed/closed with skbs on another psocks queue
then the original sock will not have a way to reclaim the memory before
being destroyed. Then above warning will be thrown

  sockA                          sockB

  sk_psock_strp_read()
   sk_psock_verdict_apply()
     -- SK_REDIRECT --
     sk_psock_skb_redirect()
                                skb_queue_tail(psock_other->ingress_skb..)

  sk_close()
   sock_map_unref()
     sk_psock_put()
       sk_psock_drop()
         sk_psock_zap_ingress()

At this point we have torn down our own psock, but have the outstanding
skb in psock_other. Note that SK_PASS doesn't have this problem because
the sk_psock_drop() logic releases the skb, its still associated with
our psock.

To resolve lets only account for sockets on the ingress queue that are
still associated with the current socket. On the redirect case we will
check memory limits per 6fa9201a89898, but will omit fwd_alloc accounting
until skb is actually enqueued. When the skb is sent via skb_send_sock_locked
or received with sk_psock_skb_ingress memory will be claimed on psock_other.

Fixes: 6fa9201a89898 ("bpf, sockmap: Avoid returning unneeded EAGAIN when redirecting to self")
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/161731444013.68884.4021114312848535993.stgit@john-XPS-13-9370

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 1261512d6807..5def3a2e85be 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -488,6 +488,7 @@ static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb
 	if (unlikely(!msg))
 		return -EAGAIN;
 	sk_msg_init(msg);
+	skb_set_owner_r(skb, sk);
 	return sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
 }
 
@@ -790,7 +791,6 @@ static void sk_psock_tls_verdict_apply(struct sk_buff *skb, struct sock *sk, int
 {
 	switch (verdict) {
 	case __SK_REDIRECT:
-		skb_set_owner_r(skb, sk);
 		sk_psock_skb_redirect(skb);
 		break;
 	case __SK_PASS:
@@ -808,10 +808,6 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 	rcu_read_lock();
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
-		/* We skip full set_owner_r here because if we do a SK_PASS
-		 * or SK_DROP we can skip skb memory accounting and use the
-		 * TLS context.
-		 */
 		skb->sk = psock->sk;
 		tcp_skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
@@ -880,12 +876,13 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 		kfree_skb(skb);
 		goto out;
 	}
-	skb_set_owner_r(skb, sk);
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
+		skb->sk = sk;
 		tcp_skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
 		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+		skb->sk = NULL;
 	}
 	sk_psock_verdict_apply(psock, skb, ret);
 out:
@@ -956,12 +953,13 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 		kfree_skb(skb);
 		goto out;
 	}
-	skb_set_owner_r(skb, sk);
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
+		skb->sk = sk;
 		tcp_skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
 		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+		skb->sk = NULL;
 	}
 	sk_psock_verdict_apply(psock, skb, ret);
 out:

