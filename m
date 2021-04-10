Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5415635AE46
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 16:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbhDJO0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 10:26:42 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:43271 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234392AbhDJO0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 10:26:42 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 52AC41940DE0;
        Sat, 10 Apr 2021 10:26:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 10:26:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hN4yVH
        l/M/XvGdixInk8p/GBZT0cftaWMHWde6q2K/U=; b=A8hsp6tY790pschx5h4o0K
        FsZrByxkbT0eXajdG9cV0Gd5awfTRNHp9vEJ6QE8WzUXXlgaun5s2kbaC87nV11M
        WVP7VSLxTYKrWvSIF7C7jHVORgjxE7DTrd2usvAkUVgyqNYaS3dinqfPRe01Y6Ra
        dn9jYkajGrbGeOnfD6gi7WP+KLaBzMmvzWlO6WNSr9tVlrME0jSNNH3wJN/m6mbB
        IgLvK5GEJTVgUfcAqLOQ6TfFixFF3D7jMfR5zlj8rYDRo3vykr/8X3mDpytKNlg+
        BhUEluUeXSolACTZb2Ed9K3UYdGhoQQnHIys/JriH/6u/zpM5+o0W77PGIlO2pDw
        ==
X-ME-Sender: <xms:k7VxYLDBMgjCxUlkobVg4gjYUe2_ZC_sYnUXXJrftmCNr3FNT2-wlg>
    <xme:k7VxYBi01o2JbDuBBPm9ya3kICgVKLKaHU61jH4zynA6qb_E7KdbHZFKIupXtbjHx
    epI8r7Iciu81w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:k7VxYGmWuBdkfDWRECqTrtaMGkhT_xUCuBTfAd1_k0W33LSTDal2bg>
    <xmx:k7VxYNzMaeySsurO93a2mdpK7xGBmtfqe0vd00QFnRZfq-wfmRUvfQ>
    <xmx:k7VxYASmLZY9H0XPdA-T5qohskfAzrsxnEeC2MDhYPLj3jKM2hpMXQ>
    <xmx:k7VxYLIXA4u8OD2vtKL8n-6WK6wm64jHNffDgcE83oeyUG06jKpPqg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E6E8C1080066;
        Sat, 10 Apr 2021 10:26:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net: let skb_orphan_partial wake-up waiters." failed to apply to 4.19-stable tree
To:     pabeni@redhat.com, davem@davemloft.net, edumazet@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Apr 2021 16:26:16 +0200
Message-ID: <1618064776148209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9adc89af724f12a03b47099cd943ed54e877cd59 Mon Sep 17 00:00:00 2001
From: Paolo Abeni <pabeni@redhat.com>
Date: Tue, 30 Mar 2021 18:43:54 +0200
Subject: [PATCH] net: let skb_orphan_partial wake-up waiters.

Currently the mentioned helper can end-up freeing the socket wmem
without waking-up any processes waiting for more write memory.

If the partially orphaned skb is attached to an UDP (or raw) socket,
the lack of wake-up can hang the user-space.

Even for TCP sockets not calling the sk destructor could have bad
effects on TSQ.

Address the issue using skb_orphan to release the sk wmem before
setting the new sock_efree destructor. Additionally bundle the
whole ownership update in a new helper, so that later other
potential users could avoid duplicate code.

v1 -> v2:
 - use skb_orphan() instead of sort of open coding it (Eric)
 - provide an helper for the ownership change (Eric)

Fixes: f6ba8d33cfbb ("netem: fix skb_orphan_partial()")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/net/sock.h b/include/net/sock.h
index 0b6266fd6bf6..3e3a5da2ce5a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2221,6 +2221,15 @@ static inline void skb_set_owner_r(struct sk_buff *skb, struct sock *sk)
 	sk_mem_charge(sk, skb->truesize);
 }
 
+static inline void skb_set_owner_sk_safe(struct sk_buff *skb, struct sock *sk)
+{
+	if (sk && refcount_inc_not_zero(&sk->sk_refcnt)) {
+		skb_orphan(skb);
+		skb->destructor = sock_efree;
+		skb->sk = sk;
+	}
+}
+
 void sk_reset_timer(struct sock *sk, struct timer_list *timer,
 		    unsigned long expires);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index cc31b601ae10..5ec90f99e102 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2132,16 +2132,10 @@ void skb_orphan_partial(struct sk_buff *skb)
 	if (skb_is_tcp_pure_ack(skb))
 		return;
 
-	if (can_skb_orphan_partial(skb)) {
-		struct sock *sk = skb->sk;
-
-		if (refcount_inc_not_zero(&sk->sk_refcnt)) {
-			WARN_ON(refcount_sub_and_test(skb->truesize, &sk->sk_wmem_alloc));
-			skb->destructor = sock_efree;
-		}
-	} else {
+	if (can_skb_orphan_partial(skb))
+		skb_set_owner_sk_safe(skb, skb->sk);
+	else
 		skb_orphan(skb);
-	}
 }
 EXPORT_SYMBOL(skb_orphan_partial);
 

