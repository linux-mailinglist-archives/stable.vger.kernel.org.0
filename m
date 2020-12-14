Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5122E2D99DA
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 15:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395074AbgLNOY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 09:24:58 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:38279 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731029AbgLNOYy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 09:24:54 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id A6EC21942886;
        Mon, 14 Dec 2020 09:23:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 14 Dec 2020 09:23:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=cMELJQ
        4jCEYmm9FAyB7Kzjqm2goXpC7VlRACVt1vXDA=; b=K5xkdYvK9o9cMhsx6z5d07
        fiH9LAu4Odu2YblBsU3abI5nsrlLnrB2eFZOSnCdIe8UbMK9Gabk4jBSynZ0PqT+
        0MUgDDTFFjJwEgscJ8CjeQvSFes8Y0oN7FuRvHoTXiEkWV+hkum583972cilOXhJ
        DOfC4gBERq29ZvB0J4ODQsMHToFbp/MdvTKOLuYY+2x345Zaju1uLDCXfPl36Y7W
        hpUUVJ9dJH0yRSDaweXKQ5EyO2IGLRftTHL1wUde6yDszvIUiPvXUIYlzuGKhXZd
        Q9yGaqpOQIueZgCek/EpuQLiXiBmvAzv8LoUeyd+tVcWTmeKQ+cdFRZwdELY1SKw
        ==
X-ME-Sender: <xms:bXXXX665IdFBxIrJQZ99v8CKAa5jtwzhMNrdP0_V7IDy_DNXm7PSqA>
    <xme:bXXXXz5_jLDOeEzQxIL0U008ixfztKryxRMcPFQYlT0NP-A-Plm_qzkyOPlggOSZx
    bLkWh0TkKY-NQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:bXXXX5c5rG7FHh1kpTpl_vSdr4V0J6QVP1wpeSp3pYpM9fKgr1LCDg>
    <xmx:bXXXX3KbKSkN9FjdCidpvbH5zsyRNGCmlAWr6W-RnqNt3qCWw-SIYg>
    <xmx:bXXXX-Jfu01KQEf-vYCOAjWZDk9zAq89Ovh-KnC641cURCA16y8eRQ>
    <xmx:bnXXXwjjuYZ8tOI7NJWmSWyEflIy4fNSAu-R4iwK5uKMRVvjOlaiyA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id ACA3C1080059;
        Mon, 14 Dec 2020 09:23:41 -0500 (EST)
Subject: FAILED: patch "[PATCH] membarrier: Explicitly sync remote cores when SYNC_CORE is" failed to apply to 5.9-stable tree
To:     luto@kernel.org, mathieu.desnoyers@efficios.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Dec 2020 15:24:48 +0100
Message-ID: <1607955888117249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 758c9373d84168dc7d039cf85a0e920046b17b41 Mon Sep 17 00:00:00 2001
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 3 Dec 2020 21:07:05 -0800
Subject: [PATCH] membarrier: Explicitly sync remote cores when SYNC_CORE is
 requested

membarrier() does not explicitly sync_core() remote CPUs; instead, it
relies on the assumption that an IPI will result in a core sync.  On x86,
this may be true in practice, but it's not architecturally reliable.  In
particular, the SDM and APM do not appear to guarantee that interrupt
delivery is serializing.  While IRET does serialize, IPI return can
schedule, thereby switching to another task in the same mm that was
sleeping in a syscall.  The new task could then SYSRET back to usermode
without ever executing IRET.

Make this more robust by explicitly calling sync_core_before_usermode()
on remote cores.  (This also helps people who search the kernel tree for
instances of sync_core() and sync_core_before_usermode() -- one might be
surprised that the core membarrier code doesn't currently show up in a
such a search.)

Fixes: 70216e18e519 ("membarrier: Provide core serializing command, *_SYNC_CORE")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/776b448d5f7bd6b12690707f5ed67bcda7f1d427.1607058304.git.luto@kernel.org

diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index 7d98ef5d3bcd..1c278dff4f2d 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -38,6 +38,23 @@ static void ipi_mb(void *info)
 	smp_mb();	/* IPIs should be serializing but paranoid. */
 }
 
+static void ipi_sync_core(void *info)
+{
+	/*
+	 * The smp_mb() in membarrier after all the IPIs is supposed to
+	 * ensure that memory on remote CPUs that occur before the IPI
+	 * become visible to membarrier()'s caller -- see scenario B in
+	 * the big comment at the top of this file.
+	 *
+	 * A sync_core() would provide this guarantee, but
+	 * sync_core_before_usermode() might end up being deferred until
+	 * after membarrier()'s smp_mb().
+	 */
+	smp_mb();	/* IPIs should be serializing but paranoid. */
+
+	sync_core_before_usermode();
+}
+
 static void ipi_rseq(void *info)
 {
 	/*
@@ -162,6 +179,7 @@ static int membarrier_private_expedited(int flags, int cpu_id)
 		if (!(atomic_read(&mm->membarrier_state) &
 		      MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE_READY))
 			return -EPERM;
+		ipi_func = ipi_sync_core;
 	} else if (flags == MEMBARRIER_FLAG_RSEQ) {
 		if (!IS_ENABLED(CONFIG_RSEQ))
 			return -EINVAL;

