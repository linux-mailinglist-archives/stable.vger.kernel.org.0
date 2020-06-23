Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB9020555E
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 17:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732845AbgFWPBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 11:01:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53135 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732840AbgFWPBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 11:01:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592924496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=RmYh4NtNJSbsFLzd6Uo3U+bKsNKgtbpj9gWO8IQHdFI=;
        b=dfMOjjcReo5SMQpno1ywFEt9NU2FFe+mgWWgvwP+EZY6jBDKOY7eK8ArkMA7AA4LkLNNIT
        YoZXtrVxaQ33kuaFRPRbxZ7rXlF+WOfYx9Q+LuzAKq9wjw/Ys6iXIzzEuZi+XlapaZi360
        UOLw03K/D2vZeLVh2yHPjcredpxfpLI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-sAyeFg6qMDGIZa5wcfvIjQ-1; Tue, 23 Jun 2020 11:01:34 -0400
X-MC-Unique: sAyeFg6qMDGIZa5wcfvIjQ-1
Received: by mail-wr1-f71.google.com with SMTP id i10so12132188wrn.21
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 08:01:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RmYh4NtNJSbsFLzd6Uo3U+bKsNKgtbpj9gWO8IQHdFI=;
        b=gTShYYyIgmH1kllqtkrO3nYsHLz04FOC0sJwCFW27RGqKj1Z4XN3GjliYJF6JHYUNY
         z8Qr8iglo7ydTAAGEYBrNjTVS9jE/TI9wnOjXga7riCnhrBtjpXX9vvqDYqWFGDmZt+E
         FUDv68+Xjr56Bg6GTF5SUaOj2S1Kr8/L+0YyiBCjsjsQDb5gdECZpVKVg/p5JPekSxwL
         XYKPC5Ta50Jvs3m44IGE2Q9pVjcn2dCxyjy9upuA9D2YJbb1SPFufrIXXmWCff+CQDKZ
         fXm84QJ+Cs7rO2UMIeYPGMHlEreang430dKrnCAIhfprs6n9jn0UWaZYhHh2GLI3Nmed
         dsoQ==
X-Gm-Message-State: AOAM531QEU40r8VZ0k1cwzbpzabgf9OpJcCIqWxyQWvUybZfbgtocWau
        uEsrqr1YJrAcOs69FFY1YDDK764MxpJru3mZYihQUgaBXal+p0h6XGwkaO0FU30q+k5GaCYJfC2
        nTXIraWKen468ePh2
X-Received: by 2002:adf:aad3:: with SMTP id i19mr26117282wrc.359.1592924493259;
        Tue, 23 Jun 2020 08:01:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5ioguoqm446J/LMcEYYgwEjYbY64j2fEsrV5ci5K0MgI4J52Tx3hcRv/2TQ0jxyNAN9Tw1A==
X-Received: by 2002:adf:aad3:: with SMTP id i19mr26117252wrc.359.1592924493029;
        Tue, 23 Jun 2020 08:01:33 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d2sm23111617wrs.95.2020.06.23.08.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 08:01:29 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C8F54181502; Tue, 23 Jun 2020 17:01:28 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 4.4] net: Revert "pkt_sched: fq: use proper locking in fq_dump_stats()"
Date:   Tue, 23 Jun 2020 17:00:53 +0200
Message-Id: <20200623150053.272985-1-toke@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 191cf872190de28a92e1bd2b56d8860e37e07443.

That commit should never have been backported since it relies on a change in
locking semantics that was introduced in v4.8 and not backported. Because of
this, the backported commit to sch_fq leads to lockups because of the double
locking.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 net/sched/sch_fq.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index f4aa2ab4713a..eb814ffc0902 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -830,24 +830,20 @@ nla_put_failure:
 static int fq_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 {
 	struct fq_sched_data *q = qdisc_priv(sch);
-	struct tc_fq_qd_stats st;
-
-	sch_tree_lock(sch);
-
-	st.gc_flows		  = q->stat_gc_flows;
-	st.highprio_packets	  = q->stat_internal_packets;
-	st.tcp_retrans		  = q->stat_tcp_retrans;
-	st.throttled		  = q->stat_throttled;
-	st.flows_plimit		  = q->stat_flows_plimit;
-	st.pkts_too_long	  = q->stat_pkts_too_long;
-	st.allocation_errors	  = q->stat_allocation_errors;
-	st.time_next_delayed_flow = q->time_next_delayed_flow - ktime_get_ns();
-	st.flows		  = q->flows;
-	st.inactive_flows	  = q->inactive_flows;
-	st.throttled_flows	  = q->throttled_flows;
-	st.pad			  = 0;
-
-	sch_tree_unlock(sch);
+	u64 now = ktime_get_ns();
+	struct tc_fq_qd_stats st = {
+		.gc_flows		= q->stat_gc_flows,
+		.highprio_packets	= q->stat_internal_packets,
+		.tcp_retrans		= q->stat_tcp_retrans,
+		.throttled		= q->stat_throttled,
+		.flows_plimit		= q->stat_flows_plimit,
+		.pkts_too_long		= q->stat_pkts_too_long,
+		.allocation_errors	= q->stat_allocation_errors,
+		.flows			= q->flows,
+		.inactive_flows		= q->inactive_flows,
+		.throttled_flows	= q->throttled_flows,
+		.time_next_delayed_flow	= q->time_next_delayed_flow - now,
+	};
 
 	return gnet_stats_copy_app(d, &st, sizeof(st));
 }
-- 
2.27.0

