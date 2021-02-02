Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B77C30BF30
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhBBNSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:18:30 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:33279 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231497AbhBBNRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 08:17:53 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id B8C96F66;
        Tue,  2 Feb 2021 08:15:41 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 02 Feb 2021 08:15:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=q9mNMG
        8kvs3nGXzRJ7OSw19ATHGkSnd3PebyOFUsZgQ=; b=klhHzwnfihO3JZIqbYjgkW
        TPozUPjQtGjBdwPMA/rhJ5Cgbxt2sU0tTWLtx7BmHjWhJQBYDH3SLglykZCeGnG7
        oSKlROLJp00vNBoLY3qrfbku7Zld+VVXRi/Q9zVvV408FGe+aumlJFU5PUVYsvCo
        B6o5XDz+8DPfXs5txHmawFAEoMXU3pEsLRAoWzx3PC5TWYLd/tQcWx6eK4e2Doc/
        3Kky7plN+FMUMy7XR8MRRiB4N3clPx9qPl3BzgrQVoelqRf8SQbrFUnydk86J68A
        Hm6JULY8+zVjNO7m2EhKRkRaehpHyqZJYzTGoStmcqRdeEKIAo42V9WpXE3BVK4w
        ==
X-ME-Sender: <xms:fVAZYDIvwhDeqfQEmn3MJty71baPzhLrT2phXbEbVtIl-tsh1K3GlA>
    <xme:fVAZYHGFot_-spYm2kPElCFwyzA6Jf-NXlmJgF2_TtIcbiEIsloTlRJgQX_M_mfpW
    pIQlXBgFHmFZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrgedtgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:fVAZYIlMZ9_KKTxXEsVVVK0UoCMSer0Rh8bl4d_8cv0ftEQFum5U4A>
    <xmx:fVAZYEKZtQt9U7NdSY9h9N04ov_-T-MVZLEH3eYgh1AW4o6hXnmd2A>
    <xmx:fVAZYJaW2rdDwnA3Nawi44qS0wYd8qMXwEra5bd2AZnBY9DzzXvx3A>
    <xmx:fVAZYFWN38GsR1ZE9xhXHBS0BNBQr2iJe2BZsp4EmM5EqEUyTfwgzrJzkOs>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D0112108006A;
        Tue,  2 Feb 2021 08:15:40 -0500 (EST)
Subject: FAILED: patch "[PATCH] tcp: make TCP_USER_TIMEOUT accurate for zero window probes" failed to apply to 5.4-stable tree
To:     enchen@paloaltonetworks.com, edumazet@google.com, kuba@kernel.org,
        ncardwell@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Feb 2021 14:15:36 +0100
Message-ID: <1612271736170158@kroah.com>
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

From 344db93ae3ee69fc137bd6ed89a8ff1bf5b0db08 Mon Sep 17 00:00:00 2001
From: Enke Chen <enchen@paloaltonetworks.com>
Date: Fri, 22 Jan 2021 11:13:06 -0800
Subject: [PATCH] tcp: make TCP_USER_TIMEOUT accurate for zero window probes

The TCP_USER_TIMEOUT is checked by the 0-window probe timer. As the
timer has backoff with a max interval of about two minutes, the
actual timeout for TCP_USER_TIMEOUT can be off by up to two minutes.

In this patch the TCP_USER_TIMEOUT is made more accurate by taking it
into account when computing the timer value for the 0-window probes.

This patch is similar to and builds on top of the one that made
TCP_USER_TIMEOUT accurate for RTOs in commit b701a99e431d ("tcp: Add
tcp_clamp_rto_to_user_timeout() helper to improve accuracy").

Fixes: 9721e709fa68 ("tcp: simplify window probe aborting on USER_TIMEOUT")
Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20210122191306.GA99540@localhost.localdomain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 78d13c88720f..ca7e2c6cc663 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -630,6 +630,7 @@ static inline void tcp_clear_xmit_timers(struct sock *sk)
 
 unsigned int tcp_sync_mss(struct sock *sk, u32 pmtu);
 unsigned int tcp_current_mss(struct sock *sk);
+u32 tcp_clamp_probe0_to_user_timeout(const struct sock *sk, u32 when);
 
 /* Bound MSS / TSO packet size with the half of the window */
 static inline int tcp_bound_to_half_wnd(struct tcp_sock *tp, int pktsize)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a7dfca0a38cd..55c6fd6b5d13 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3392,8 +3392,8 @@ static void tcp_ack_probe(struct sock *sk)
 	} else {
 		unsigned long when = tcp_probe0_when(sk, TCP_RTO_MAX);
 
-		tcp_reset_xmit_timer(sk, ICSK_TIME_PROBE0,
-				     when, TCP_RTO_MAX);
+		when = tcp_clamp_probe0_to_user_timeout(sk, when);
+		tcp_reset_xmit_timer(sk, ICSK_TIME_PROBE0, when, TCP_RTO_MAX);
 	}
 }
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index ab458697881e..8478cf749821 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4099,6 +4099,8 @@ void tcp_send_probe0(struct sock *sk)
 		 */
 		timeout = TCP_RESOURCE_PROBE_INTERVAL;
 	}
+
+	timeout = tcp_clamp_probe0_to_user_timeout(sk, timeout);
 	tcp_reset_xmit_timer(sk, ICSK_TIME_PROBE0, timeout, TCP_RTO_MAX);
 }
 
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index faa92948441b..4ef08079ccfa 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -40,6 +40,24 @@ static u32 tcp_clamp_rto_to_user_timeout(const struct sock *sk)
 	return min_t(u32, icsk->icsk_rto, msecs_to_jiffies(remaining));
 }
 
+u32 tcp_clamp_probe0_to_user_timeout(const struct sock *sk, u32 when)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+	u32 remaining;
+	s32 elapsed;
+
+	if (!icsk->icsk_user_timeout || !icsk->icsk_probes_tstamp)
+		return when;
+
+	elapsed = tcp_jiffies32 - icsk->icsk_probes_tstamp;
+	if (unlikely(elapsed < 0))
+		elapsed = 0;
+	remaining = msecs_to_jiffies(icsk->icsk_user_timeout) - elapsed;
+	remaining = max_t(u32, remaining, TCP_TIMEOUT_MIN);
+
+	return min_t(u32, remaining, when);
+}
+
 /**
  *  tcp_write_err() - close socket and save error info
  *  @sk:  The socket the error has appeared on.

