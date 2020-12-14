Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4222A2D99DC
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 15:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgLNOZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 09:25:30 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:46505 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394477AbgLNOZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 09:25:14 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 62B881940ADB;
        Mon, 14 Dec 2020 09:23:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 14 Dec 2020 09:23:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JuIyLO
        +syYkRCl8VzQRmiZND1/5JP4zFFgRx8i+PB+8=; b=esziwIaPbCOLRpHMM5grzF
        UAw+L5QwPIFh8ZcmdxU1WQ03UpA3ET2/TUbaEvaJyYV9KRUPUdfubQoxCo+mx5Yz
        SNrUOiGMv87UP9iWCVZ1n5hz/Mh5mlf6HrcTzVZtq4hNeIHBWOH9x9Katu82m6k8
        16xdIw/0MaTIsYQoUZzb22LR4Zdeg84Ld26F7Go6q4fX8936+KnSTjS9gMeFOoYM
        nnLRyY1wwKSMk+gjSjlvXf2XvaA7tHxENkOEODrA33hW+xWa3sIw6vLgt3hqCXyh
        oLjlOp+YfgwZvf5GNfpadU9pRAN3IcVCXyvpaWfmtue5GPzN+qnlZP5tliL4KsmQ
        ==
X-ME-Sender: <xms:cXXXXzAi_XPcicZqczPWS10vvP5o3x5YS5q-1Jn22RFMEJwpxV9KpQ>
    <xme:cXXXXw-mkKXKpd-jtSBEV_qrnRlCCSml1aUQTxIiSXbch7ERuOaaKGEyz6E62KNpa
    XI5GFXB6l9PZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:cXXXX782GsByrzjqNrXfAnMKf-4m9ka4SrfnWqF243HGSRQrnlG7xg>
    <xmx:cXXXX_dsN1tGL8lm8SQ-TmB-qicGvGOJdLLiUAaTRkTrP1s2Osm-6A>
    <xmx:cXXXX8HKlLKo4SsngafhbfMA85d6lishYquQi4Av5GDSiHLidOaLQw>
    <xmx:cXXXX7kHvi-hXt_LFa-3bTUwBbXdnwy2IJEki3PE487bPn-v5dxTDg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 05F511080067;
        Mon, 14 Dec 2020 09:23:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] membarrier: Explicitly sync remote cores when SYNC_CORE is" failed to apply to 4.19-stable tree
To:     luto@kernel.org, mathieu.desnoyers@efficios.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Dec 2020 15:24:50 +0100
Message-ID: <160795589018104@kroah.com>
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

