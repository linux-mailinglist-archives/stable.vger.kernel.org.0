Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985B02D99D4
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 15:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733017AbgLNOYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 09:24:13 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:58643 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2440161AbgLNOYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 09:24:01 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 786A4194282A;
        Mon, 14 Dec 2020 09:23:11 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 14 Dec 2020 09:23:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=C/bDPn
        palRWgKHxgnNwF9p7+CVUsjqpm3DbZtTulQCU=; b=Kf3QU//ysG6I/YRkOZvai4
        pfiOWyUDQp885TlPeJvQZYp17mhwQXGxfxX7+LecWs1N4xVVlV0soqgZ/J4TjX7m
        8UR+4+NRC8VOeTPzlV71/QKJO4n4kfkvQYOS9q4z+5K5Vs9fAT4SpcjLcrDwMgqk
        CjQaZ2Cku+XhXCDMMKnYu8eJ3qs9oozF6PNGyvNWkSBQdTpH3eLM+zWqzcxUkum4
        NAQ0RMwCQWfST6A2ZUEqDYRCLBNRpTiPxxIrEFWm26xIQMsVPfon1MyfWV8kpGX5
        ZN4eLqObNE7Ed278fDsvmXOQMW5evcVeufG4t72W42c5mAxl8Q5dmzlxtF7SBW+Q
        ==
X-ME-Sender: <xms:T3XXX91D_-9OyQ0Ub16oM4A0x3JrtMHN1YWzROeZrgd6OA9hDdwe8Q>
    <xme:T3XXX0GPWgS6mgQYArFG2_YnL1GZaejQf0qZYMibA4jugOcm9mcr3Cs-THEyC4h2b
    BS8QspQzE0vtw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:T3XXX968j5xCSLf1bEfX7Uak7mgjxj4p5PVN3PHQTIX5tsREoN5hdA>
    <xmx:T3XXX61KbrJ-aSZbE1h2NGKmgmml3NWcW_xZhF-iSqHloygeTHQ0_A>
    <xmx:T3XXXwH-zCnaM_wlj2gOwM1eMwSqHuqj_m2QK0tByy9UAAPgXfiGWw>
    <xmx:T3XXX6Me8dkcLhanXKaZGHwOWq7DHj7QAwVAZHWHxvSxlIpYrWfw5w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 10B9A1080067;
        Mon, 14 Dec 2020 09:23:10 -0500 (EST)
Subject: FAILED: patch "[PATCH] membarrier: Add an actual barrier before rseq_preempt()" failed to apply to 5.9-stable tree
To:     luto@kernel.org, mathieu.desnoyers@efficios.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Dec 2020 15:24:09 +0100
Message-ID: <160795584916461@kroah.com>
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

From 2ecedd7569080fd05c1a457e8af2165afecfa29f Mon Sep 17 00:00:00 2001
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 3 Dec 2020 21:07:04 -0800
Subject: [PATCH] membarrier: Add an actual barrier before rseq_preempt()

It seems that most RSEQ membarrier users will expect any stores done before
the membarrier() syscall to be visible to the target task(s).  While this
is extremely likely to be true in practice, nothing actually guarantees it
by a strict reading of the x86 manuals.  Rather than providing this
guarantee by accident and potentially causing a problem down the road, just
add an explicit barrier.

Fixes: 70216e18e519 ("membarrier: Provide core serializing command, *_SYNC_CORE")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/d3e7197e034fa4852afcf370ca49c30496e58e40.1607058304.git.luto@kernel.org

diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index e23e74d52db5..7d98ef5d3bcd 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -40,6 +40,14 @@ static void ipi_mb(void *info)
 
 static void ipi_rseq(void *info)
 {
+	/*
+	 * Ensure that all stores done by the calling thread are visible
+	 * to the current task before the current task resumes.  We could
+	 * probably optimize this away on most architectures, but by the
+	 * time we've already sent an IPI, the cost of the extra smp_mb()
+	 * is negligible.
+	 */
+	smp_mb();
 	rseq_preempt(current);
 }
 

