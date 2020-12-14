Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EEF2D99D8
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 15:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgLNOYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 09:24:44 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:36713 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2440174AbgLNOYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 09:24:20 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id CFE22194281D;
        Mon, 14 Dec 2020 09:23:12 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 14 Dec 2020 09:23:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=tC6X0A
        axt2jsE09bJw1/Bc7nCuOmjxMrXbRhoFZm4sc=; b=e99k7PVnaopsHR/Ib+xeYP
        zJpLHfE3IOR2DcES6RykVu4aK/4Eyd1OKTuDaooEu7DZsbtG1y//QcqIFPzbEnTG
        F5ugndHCB5USRxA4vGhqWclnKHeCeuhoo1K3eg8DkAzQNrLSSfxxwbPBcmnQb9KO
        X2SrPVtR2LipNlqontBxiBoUN/W10hh7rub53wcWkCFl7fiN2vX9T8X4jeCv64qX
        cqGRo6zmGEymajwMCMtp6uzjle1qmGIe1mBRS88GefH1uELf8XwS2SYkIfXZWtA0
        UF3w/9lENBexAMwCBdsEvEVK6gfAbvpGZx855UUWX2k7FYA6h3MVNs5yU+q/s4Sg
        ==
X-ME-Sender: <xms:UHXXX8wYy3TVOzUBMnNKJUvJusDol0Uc1w4OsYYbp0jmkB-sXNbYBQ>
    <xme:UHXXXwTzxj4CFp7DtL1Uw-BhibQIQiINHzy0g8Py9AA_f78SJnmZ2mO2LFc_MS_1u
    6fgwwQRd4ivKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:UHXXX-VoG_DeoI7QlokA9MXBTEodhQ11sXsi7rNZfVU7zZQZmZvrIg>
    <xmx:UHXXX6jT6GkkH9Lr1tFbYLGVGFGvaXLtxjHPSuXfYFoppiCGjVvTtA>
    <xmx:UHXXX-DSblHN9SSZzvACbe7zYer7PJe_wtxse7DiLfaTF2x4pLrj0g>
    <xmx:UHXXX_6rF00dygdGdZANmQ7in55IjzYcZrQr8ebqqKljlHn2He_yBw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7F063240065;
        Mon, 14 Dec 2020 09:23:12 -0500 (EST)
Subject: FAILED: patch "[PATCH] membarrier: Add an actual barrier before rseq_preempt()" failed to apply to 5.4-stable tree
To:     luto@kernel.org, mathieu.desnoyers@efficios.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Dec 2020 15:24:09 +0100
Message-ID: <1607955849185224@kroah.com>
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
 

