Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CC730D0BA
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 02:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhBCBXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 20:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhBCBXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 20:23:09 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A046C061573
        for <stable@vger.kernel.org>; Tue,  2 Feb 2021 17:22:29 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id n7so24983023oic.11
        for <stable@vger.kernel.org>; Tue, 02 Feb 2021 17:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cg6ynwZZBvXj5V2AuAHJC8Q0nd0vhBxbc9tNF0abv2A=;
        b=aO2lczkithgvH2IyyevNAzDRuxWSCvYWbJMjoc1Y6uQDwR4zVHqS4g0Vh9d9F7DN6I
         6Ec327sV8b7Sc9cTiFt8taum8EFKx9/S4E6PINfkvfWmaBcxs1jbtp396x34sA/Gh2yQ
         tUvtBlz7dY3i3tTRCOtVBqSOCZgzsdtdnwSsqWzLcK4d4eA2dWnbVLTEwlkOHxs71ms+
         biF2anUCvNL8oqL+qE5L3/+S4ee6x5Mlpso+nOCq7n7MGsIoTvNTEz7DDvJPn8CsI7Yu
         4j/3W4vTzFQyF6D3NKRzPe9BAmU0wRa+MXZm5/D5Qr0/+M6wfv+001qVMZMvPfIvGGbe
         RVGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cg6ynwZZBvXj5V2AuAHJC8Q0nd0vhBxbc9tNF0abv2A=;
        b=sH9F0bEw+pC/qk88lseEv7F9nc6oyOtg56m3D6+XUA8Lddc/owtMH/WYBjsPFiAtrQ
         EcF0W1wqkn1y5EeNAkaF+bvTNpv05TgQRczMoQdYtlt+orMIfmCyIrqO32+n3k6O0310
         7risyFz+7GsuXsDvlSpKXaOUxZbEc72sCGJOe7+jm7M9jw/AbnhwBIIC/ACCzorC0Oge
         1RzV9Tm758Od4hsXPY/c+kG4PsSGCe6aR1B7xl08XXhRVIV5ZOdUWHUfjfSRogEpjFhq
         QUH67c6+daluk1OFUoKCcLlqXbfu9mfwtrxBj9ncSmaz7FQJ69lcv/mxM0kv+88/vw7c
         t+Vw==
X-Gm-Message-State: AOAM530NLmK1YS1tJVJ4TBSbfxw1z+H206m4BK2IB9KC8eE2jN8jcPs+
        ltANfleA1HDR40a9rTqY6wQ=
X-Google-Smtp-Source: ABdhPJyuciYM5CdEIecdn12ebRg3untw9c1Fk9DQiI1xVhCiVB030z0+awd9onQ6Ut/PO4VWE6Wjcw==
X-Received: by 2002:a54:478c:: with SMTP id o12mr437516oic.28.1612315348802;
        Tue, 02 Feb 2021 17:22:28 -0800 (PST)
Received: from localhost.localdomain (99-6-134-177.lightspeed.snmtca.sbcglobal.net. [99.6.134.177])
        by smtp.gmail.com with ESMTPSA id o98sm145943ota.0.2021.02.02.17.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 17:22:27 -0800 (PST)
Date:   Tue, 2 Feb 2021 17:22:25 -0800
From:   Enke Chen <enkechen2020@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     edumazet@google.com, kuba@kernel.org, ncardwell@google.com,
        enchen@paloaltonetworks.com, enkechen2020@gmail.com
Subject: Re: FAILED: patch "[PATCH] tcp: make TCP_USER_TIMEOUT accurate for
 zero window probes" failed to apply to 5.4-stable tree
Message-ID: <20210203012225.GA2913@localhost.localdomain>
References: <1612271736170158@kroah.com>
 <CANJ8pZ9z+2+2NnKz+67Dip8SEPhAD-87xVhNyJo0yk2aksQR4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANJ8pZ9z+2+2NnKz+67Dip8SEPhAD-87xVhNyJo0yk2aksQR4A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Greg:

Attach is the ported patch for the 5.4-stable tree.

Thanks.   -- Enke

> From: <gregkh@linuxfoundation.org>
> Date: Tue, Feb 2, 2021 at 5:15 AM
> Subject: FAILED: patch "[PATCH] tcp: make TCP_USER_TIMEOUT accurate for
> zero window probes" failed to apply to 5.4-stable tree
> To: <enchen@paloaltonetworks.com>, <edumazet@google.com>, <kuba@kernel.org>,
> <ncardwell@google.com>
> Cc: <stable@vger.kernel.org>
> 
> 
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 

tcp: make TCP_USER_TIMEOUT accurate for zero window probes

From: Enke Chen <enchen@paloaltonetworks.com>

commit 344db93ae3ee69fc137bd6ed89a8ff1bf5b0db08 upstream.

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
---
 include/net/tcp.h     |  1 +
 net/ipv4/tcp_input.c  |  1 +
 net/ipv4/tcp_output.c |  2 ++
 net/ipv4/tcp_timer.c  | 18 ++++++++++++++++++
 4 files changed, 22 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 377179283c46..424d4f137707 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -619,6 +619,7 @@ static inline void tcp_clear_xmit_timers(struct sock *sk)
 
 unsigned int tcp_sync_mss(struct sock *sk, u32 pmtu);
 unsigned int tcp_current_mss(struct sock *sk);
+u32 tcp_clamp_probe0_to_user_timeout(const struct sock *sk, u32 when);
 
 /* Bound MSS / TSO packet size with the half of the window */
 static inline int tcp_bound_to_half_wnd(struct tcp_sock *tp, int pktsize)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 7411a4313462..30c1b88ae4f7 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3294,6 +3294,7 @@ static void tcp_ack_probe(struct sock *sk)
 	} else {
 		unsigned long when = tcp_probe0_when(sk, TCP_RTO_MAX);
 
+		when = tcp_clamp_probe0_to_user_timeout(sk, when);
 		tcp_reset_xmit_timer(sk, ICSK_TIME_PROBE0,
 				     when, TCP_RTO_MAX, NULL);
 	}
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5da6ffce390c..d0774b4e934d 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3850,6 +3850,8 @@ void tcp_send_probe0(struct sock *sk)
 		 */
 		timeout = TCP_RESOURCE_PROBE_INTERVAL;
 	}
+
+	timeout = tcp_clamp_probe0_to_user_timeout(sk, timeout);
 	tcp_reset_xmit_timer(sk, ICSK_TIME_PROBE0, timeout, TCP_RTO_MAX, NULL);
 }
 
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 7fcd116fbd37..fa2ae96ecdc4 100644
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
-- 
2.29.2

