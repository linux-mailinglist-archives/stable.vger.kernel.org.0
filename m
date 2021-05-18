Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46B3387790
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 13:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhERL30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 07:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbhERL3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 07:29:25 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CCBC061573
        for <stable@vger.kernel.org>; Tue, 18 May 2021 04:28:07 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id p7so6077623wru.10
        for <stable@vger.kernel.org>; Tue, 18 May 2021 04:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DBZYTwBjlgIUJh90JAijG8YFeudnF6JrxuRLB0DtebM=;
        b=HMGgZv6NNq8l9NC1VeRwRLoXs3PT1U13wN5eWSfYyjAyi5br4LPNIDVgmZuY3M9KQH
         Buwu6vpOu9W4XUgjyYWQSwfHiWiBCL8u8/LPiUEeiIYyZOpdwVGwSQRkplLxSbYQ6abo
         9+ClwEM9iAnfASbClcN/3e63+mWhtLBES0HHZxAF5WrzGjs64MGcNFYYzNf3JJNr3jkM
         o5SsZ0AWc5KqXHc8y7N1Hbpf7V5mmfJPaCTP8uaSTGG/e9qeEQ6cOHA5XG5CPjKLR4hi
         98bDQ6W+jJB2bgRJG7MifjrNJsnfuE4xvy7CQV2fhMsTVn/gNIR+tuaBnWJdfgSqtJzn
         GU/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DBZYTwBjlgIUJh90JAijG8YFeudnF6JrxuRLB0DtebM=;
        b=UqS8B1XstLNe3z6RyEaap5siygJ5ddVw82seKgAirUpiZurQSBm3fFh6JiEtWYDsus
         FFhDrUVaHMLhfL/8aVhNIl9/b17JUXmNknFwfIASi5GXQ8Y/pphX6jqVzhvGX8CYhNSk
         Yk0dH5YewiTBT6d0Y3BxasI668L4KMfmUCitf3KGbq6rlh9Yw+Be2tJ0vNfe8tUTzvLh
         Z/GFthCN7823RhT/qGiVGPgToo4k9gF2w71TJau100ABnKU6tYA7VsA7Drmu/L/imMc9
         FBMKe/iLB3Bjr5eFqtq/+fIqC9Z8heiffpKi4ePuGfrynpdRVPNhtA6yaWJH3mrqTiSs
         ye0g==
X-Gm-Message-State: AOAM532SCo7K5jEJ1x0LpRT2s0171E6/VF5rA+0vtS6VihkBsV3IPZS1
        WZG+0ped5coBfYpk9oF4Fzk=
X-Google-Smtp-Source: ABdhPJztIpYFVR8N2vxVCwJJbiBnqVQK84aPYzVh/OrQPemiwgocbRl6tvCJp167mztLKS2xRPYmZQ==
X-Received: by 2002:a5d:534f:: with SMTP id t15mr6116986wrv.206.1621337285835;
        Tue, 18 May 2021 04:28:05 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id y2sm2723709wmq.45.2021.05.18.04.28.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 May 2021 04:28:05 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     bjorn@kernel.org, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, bganne@cisco.com, stable@vger.kernel.org
Subject: Backport of 11cc2d21499c for 5.4.y and 4.19.y
Date:   Tue, 18 May 2021 13:27:39 +0200
Message-Id: <20210518112739.14086-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Hi Greg and Sasha,

Please find attached backports of commit 11cc2d21499c ("xsk: Simplify
detection of empty and full rings") for the 5.4.y and 4.19.y stable
series. It solves a reproducible race between poll() and sendmsg()
when used concurrently by two different processes using the same
AF_XDP socket. Note that the commit above unknowingly (read: by sheer
luck) fixed the bug as it was about simplification and performance
improvement only. I have included two backports that are code wise
equivallent to the commit above, however, they contain a commit message
that describes the race in question and how it is fixed by the
patch. Sorry, but I do not know the correct procedure in these kind of
situations, but if you prefer to pick the original commit, please
ignore the "backports" below.

Please let me know if there are any problems.

Thanks: Magnus


>From aa84d8c8e0ba1e83a3454df04cd6bd417ee2bc8e Mon Sep 17 00:00:00 2001
From: Magnus Karlsson <magnus.karlsson@intel.com>
Date: Thu, 19 Dec 2019 13:39:21 +0100
Subject: [PATCH 4.19] xsk: fix race between poll and the driver

commit 11cc2d21499cabe7e7964389634ed1de3ee91d33 upstream

Fix a race between poll() and the driver that can result in one or
more packets being transmitted or received twice. The problem is that
poll() uses the same function the driver uses to access the Rx and Tx
rings in user space, and this function will update the state of one of
these rings under certain conditions. E.g., if the poll() call from
one process updates the Tx ring state while at the same time the
driver in zero-copy mode is processing entries in the ring (invoked by
sendmsg() or an interrupt), some packets will be sent twice. All the
AF_XDP rings are single producer / single consumer, so modifying one
from two places at the same time will corrupt it. Similarly, on the Rx
side packets might be received twice.

Fix this by changing the poll() function to not use the same function
as the driver uses and instead only read state from the ring.

Fixes: 35fcde7f8deb ("xsk: support for Tx")
Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reported-by: Benoit Ganne <bganne@cisco.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/BYAPR11MB365382C5DB1E5FCC53242609C1549@BYAPR11MB3653.namprd11.prod.outlook.com/
---
 net/xdp/xsk_queue.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index fe96c0d039f2..cf7cbb5dd918 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -245,12 +245,15 @@ static inline void xskq_produce_flush_desc(struct xsk_queue *q)

 static inline bool xskq_full_desc(struct xsk_queue *q)
 {
-	return xskq_nb_avail(q, q->nentries) == q->nentries;
+	/* No barriers needed since data is not accessed */
+	return READ_ONCE(q->ring->producer) - READ_ONCE(q->ring->consumer) ==
+		q->nentries;
 }

 static inline bool xskq_empty_desc(struct xsk_queue *q)
 {
-	return xskq_nb_free(q, q->prod_tail, q->nentries) == q->nentries;
+	/* No barriers needed since data is not accessed */
+	return READ_ONCE(q->ring->consumer) == READ_ONCE(q->ring->producer);
 }

 void xskq_set_umem(struct xsk_queue *q, struct xdp_umem_props *umem_props);

base-commit: 3c8c23092588a23bf1856a64f58c37f477a413be
--
2.29.0


>From 07f2ccb39bd20e90293c59ffcc977c14cf0ce577 Mon Sep 17 00:00:00 2001
From: Magnus Karlsson <magnus.karlsson@intel.com>
Date: Thu, 19 Dec 2019 13:39:21 +0100
Subject: [PATCH 5.4] xsk: fix race between poll and the driver

commit 11cc2d21499cabe7e7964389634ed1de3ee91d33 upstream

Fix a race between poll() and the driver that can result in one or
more packets being transmitted or received twice. The problem is that
poll() uses the same function the driver uses to access the Rx and Tx
rings in user space, and this function will update the state of one of
these rings under certain conditions. E.g., if the poll() call from
one process updates the Tx ring state while at the same time the
driver in zero-copy mode is processing entries in the ring (invoked by
sendmsg() or an interrupt), some packets will be sent twice. All the
AF_XDP rings are single producer / single consumer, so modifying one
from two places at the same time will corrupt it. Similarly, on the Rx
side packets might be received twice.

Fix this by changing the poll() function to not use the same function
as the driver uses and instead only read state from the ring.

Fixes: 35fcde7f8deb ("xsk: support for Tx")
Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reported-by: Benoit Ganne <bganne@cisco.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/BYAPR11MB365382C5DB1E5FCC53242609C1549@BYAPR11MB3653.namprd11.prod.outlook.com/
---
 net/xdp/xsk_queue.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index eddae4688862..ee3f8c857dd8 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -363,12 +363,15 @@ static inline void xskq_produce_flush_desc(struct xsk_queue *q)

 static inline bool xskq_full_desc(struct xsk_queue *q)
 {
-	return xskq_nb_avail(q, q->nentries) == q->nentries;
+	/* No barriers needed since data is not accessed */
+	return READ_ONCE(q->ring->producer) - READ_ONCE(q->ring->consumer) ==
+		q->nentries;
 }

 static inline bool xskq_empty_desc(struct xsk_queue *q)
 {
-	return xskq_nb_free(q, q->prod_tail, q->nentries) == q->nentries;
+	/* No barriers needed since data is not accessed */
+	return READ_ONCE(q->ring->consumer) == READ_ONCE(q->ring->producer);
 }

 void xskq_set_umem(struct xsk_queue *q, u64 size, u64 chunk_mask);

base-commit: b82e5721a17325739adef83a029340a63b53d4ad
--
2.29.0
