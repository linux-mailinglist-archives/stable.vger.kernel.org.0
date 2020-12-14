Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138D12D99D5
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 15:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440161AbgLNOYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 09:24:19 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:39903 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731635AbgLNOYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 09:24:11 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7815219426AC;
        Mon, 14 Dec 2020 09:23:03 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 14 Dec 2020 09:23:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=u9zZCU
        oIr+3zMAyA8OIkMrldzpRWR9DRtxCvxKWvGSY=; b=ELOCkd0Q15r/aG7zxiMmMj
        x1Zj2LWoX+h9hPKZu8V7tBR0zqhNtVePSJgOIkckJWhDM80KK1zg+mnhyYugFkt7
        PsR2z+r5J4aFDnsERJa5Ho0w30W8u6pfG5WZyJFvL3oGLlY6l973MYVA5vnGH5Bi
        RkT3/idgeq81kNhz8kfm28qLk1uUfOLJFK/toIp+HJDRC2pv/lje4gSSEvteXUcI
        RsJHAssCCSFdBY7BBgdGamj7L9KT4l5l9aZNSj66BnBc/iYIV1sqJE5DHP7MiMDk
        6wA75XIk9/M1iVP6rtJ+sB76k1W5NN52xLPCYWuSL9Pl4oLH3IUBYu/M5vZal0gw
        ==
X-ME-Sender: <xms:RnXXX9HR8xAOIAPdBwGx_0otmKyleMv9LPCfM3z4vfOLZJp6YDxK2A>
    <xme:RnXXXyU49DhWH4CfVWoSOYDdCymPbNnBPAUHsHfAbnVMawgOyb2lar84FcW92sVGt
    dWs2hAoQR49TQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:RnXXX_J96XlurIn2YXng8yVzapkuDjPzjouR2FXa8Kenlhd7NbKLeA>
    <xmx:RnXXXzF4jevNdA-0GLfkdHAD1YUI6Yx7zwWQwhw4G3VNkRseltWZ1g>
    <xmx:RnXXXzX3p-wmJnN70qsXmsw8TPy84KJr4P9fhvzZPfUC0lXBl5c6cg>
    <xmx:R3XXX6f4TiTfyMf-W4IK_W8ZUe67tKgStFD6GH6AfWDuENAGaPo73g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6153524005A;
        Mon, 14 Dec 2020 09:23:02 -0500 (EST)
Subject: FAILED: patch "[PATCH] membarrier: Add an actual barrier before rseq_preempt()" failed to apply to 4.19-stable tree
To:     luto@kernel.org, mathieu.desnoyers@efficios.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Dec 2020 15:24:08 +0100
Message-ID: <1607955848218183@kroah.com>
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
 

