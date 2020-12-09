Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E552D4928
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 19:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729615AbgLISj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 13:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728997AbgLISj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 13:39:29 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1016CC0613CF;
        Wed,  9 Dec 2020 10:38:49 -0800 (PST)
Date:   Wed, 09 Dec 2020 18:38:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607539127;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U8ItWNThca6KPkdlpq5Bor2HOLrs0TWGDCTrSos999k=;
        b=iVZpdVyInC/lgDhmRseAQFri24TM0//aghQmEM5OxJ9ojm6CfxzfTXcx9XU7L5yjxo8/vX
        yZnWAAQng8SC4Jp2343L81Vww7VWYlidd8K/9zqEkp+URi46c6Kgg1ZINOvNxEssLSSjkd
        2ztAB1AGUOebDEpyePPnCtzRTHrFMPamX3UBmtYd8ze5R6T+p70LYTp+EuYhAk+XwwoylM
        XKtnrENg9828rQipXyvN0NWl0U/ebSw5gwNco8SQJWUJfSylTRGhaddpkWP+E+UUHYKjwu
        LcqTN0QKmK2H/avBdnHhbKHAtfOQfR1kYv5aVxo9+6RsO52F15S+8KBzzLwK6g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607539127;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U8ItWNThca6KPkdlpq5Bor2HOLrs0TWGDCTrSos999k=;
        b=xk3Km7W1+Tl0oKcCTKoEQRkCgTi7/Cd1M7kuIq587GoZShKB9ESD/415EWbkzMgYCd21g9
        aj5GhnWw4GLqYlCg==
From:   "tip-bot2 for Ahmed S. Darwish" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/core] Documentation: seqlock: s/LOCKTYPE/LOCKNAME/g
Cc:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20201206162143.14387-2-a.darwish@linutronix.de>
References: <20201206162143.14387-2-a.darwish@linutronix.de>
MIME-Version: 1.0
Message-ID: <160753912693.3364.7415240565588650319.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/core branch of tip:

Commit-ID:     cf48647243cc28d15280600292db5777592606c5
Gitweb:        https://git.kernel.org/tip/cf48647243cc28d15280600292db5777592606c5
Author:        Ahmed S. Darwish <a.darwish@linutronix.de>
AuthorDate:    Sun, 06 Dec 2020 17:21:41 +01:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Wed, 09 Dec 2020 17:08:49 +01:00

Documentation: seqlock: s/LOCKTYPE/LOCKNAME/g

Sequence counters with an associated write serialization lock are called
seqcount_LOCKNAME_t. Fix the documentation accordingly.

While at it, remove a paragraph that inappropriately discussed a
seqlock.h implementation detail.

Fixes: 6dd699b13d53 ("seqlock: seqcount_LOCKNAME_t: Standardize naming convention")
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20201206162143.14387-2-a.darwish@linutronix.de
---
 Documentation/locking/seqlock.rst | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/Documentation/locking/seqlock.rst b/Documentation/locking/seqlock.rst
index a334b58..64405e5 100644
--- a/Documentation/locking/seqlock.rst
+++ b/Documentation/locking/seqlock.rst
@@ -89,7 +89,7 @@ Read path::
 
 .. _seqcount_locktype_t:
 
-Sequence counters with associated locks (``seqcount_LOCKTYPE_t``)
+Sequence counters with associated locks (``seqcount_LOCKNAME_t``)
 -----------------------------------------------------------------
 
 As discussed at :ref:`seqcount_t`, sequence count write side critical
@@ -115,27 +115,26 @@ The following sequence counters with associated locks are defined:
   - ``seqcount_mutex_t``
   - ``seqcount_ww_mutex_t``
 
-The plain seqcount read and write APIs branch out to the specific
-seqcount_LOCKTYPE_t implementation at compile-time. This avoids kernel
-API explosion per each new seqcount LOCKTYPE.
+The sequence counter read and write APIs can take either a plain
+seqcount_t or any of the seqcount_LOCKNAME_t variants above.
 
-Initialization (replace "LOCKTYPE" with one of the supported locks)::
+Initialization (replace "LOCKNAME" with one of the supported locks)::
 
 	/* dynamic */
-	seqcount_LOCKTYPE_t foo_seqcount;
-	seqcount_LOCKTYPE_init(&foo_seqcount, &lock);
+	seqcount_LOCKNAME_t foo_seqcount;
+	seqcount_LOCKNAME_init(&foo_seqcount, &lock);
 
 	/* static */
-	static seqcount_LOCKTYPE_t foo_seqcount =
-		SEQCNT_LOCKTYPE_ZERO(foo_seqcount, &lock);
+	static seqcount_LOCKNAME_t foo_seqcount =
+		SEQCNT_LOCKNAME_ZERO(foo_seqcount, &lock);
 
 	/* C99 struct init */
 	struct {
-		.seq   = SEQCNT_LOCKTYPE_ZERO(foo.seq, &lock),
+		.seq   = SEQCNT_LOCKNAME_ZERO(foo.seq, &lock),
 	} foo;
 
 Write path: same as in :ref:`seqcount_t`, while running from a context
-with the associated LOCKTYPE lock acquired.
+with the associated write serialization lock acquired.
 
 Read path: same as in :ref:`seqcount_t`.
 
