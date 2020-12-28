Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF38B2E3509
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 09:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgL1I3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 03:29:18 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:47993 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726354AbgL1I3R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 03:29:17 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 1494A746;
        Mon, 28 Dec 2020 03:28:31 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 03:28:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=krh29I
        bxnz1lszqQD4X+aMoxQA3R9oN0W4Y5f+DFPGA=; b=juyYNhpwQfxGLxscl9CFUm
        q45et1XLTk51yntY9VoP9GpKYnokfk+N+Fwozbre/rRgrrHPVoJVB5s9KRH32yuV
        N1ah3bgFb80TpkrG8ueW6wYy4UoJGmXoloR8mZDU9netFlbAy/EdaoWjPHY603OJ
        qbOEkEwYPb/8kmzRcCp1ync1eBXM72mPCR/MH61wF9UjNHy4p7HDn/3yyiNOLt5Z
        dZTT4n5J+tdxAP/yDRzCCXOEAIpl5EZROkAAxeCOR63SOR8uwwAxrnriDvIy+6SP
        gh4q2M6KhDlweaCe7FVF9MT62NHjKoIQgfYvtz0hndPmcFwO1N64Q40kRIq50zcA
        ==
X-ME-Sender: <xms:L5fpXxeXRxOClRdCI0YoqJEXMsFcg_VqeOGZaaoejoX_bDs1TZw-mg>
    <xme:L5fpX_MaZAoxZzM-FGcpwoYUOz7iRWCP2fn3HqoCjhBcmfVgnjl0QwO_u47h6Wu4P
    HA4mw5cxOg1wQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddukedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:L5fpX6gjOuZuiv_yMTdIEmSKcn0WABSc7iJZKo2P_xL0xmUqVwugyQ>
    <xmx:L5fpX6-KjRbMMvnOzd1Dv5QlbT8VH0Uo2o3KjduHG72IoAIhS5CjNQ>
    <xmx:L5fpX9sKdZwMGAetQi-qRgYmqgHb7oA3FEHjh3vlmPDtxGSEKfp1UQ>
    <xmx:L5fpX-WcA6lKQW7suEHojzpxZm0t-dF-ALfs8M-lOHyTKowiBVKMWuKgTxU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A46B51080063;
        Mon, 28 Dec 2020 03:28:30 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390/smp: perform initial CPU reset also for SMT siblings" failed to apply to 4.4-stable tree
To:     svens@linux.ibm.com, hca@linux.ibm.com, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 09:29:54 +0100
Message-ID: <16091441941247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b5e438ebd7e808d1d2435159ac4742e01a94b8da Mon Sep 17 00:00:00 2001
From: Sven Schnelle <svens@linux.ibm.com>
Date: Tue, 8 Dec 2020 07:35:21 +0100
Subject: [PATCH] s390/smp: perform initial CPU reset also for SMT siblings

Not resetting the SMT siblings might leave them in unpredictable
state. One of the observed problems was that the CPU timer wasn't
reset and therefore large system time values where accounted during
CPU bringup.

Cc: <stable@kernel.org> # 4.0
Fixes: 10ad34bc76dfb ("s390: add SMT support")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 647226e50c80..27c763014114 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -890,24 +890,12 @@ static void __no_sanitize_address smp_start_secondary(void *cpuvoid)
 /* Upping and downing of CPUs */
 int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
-	struct pcpu *pcpu;
-	int base, i, rc;
+	struct pcpu *pcpu = pcpu_devices + cpu;
+	int rc;
 
-	pcpu = pcpu_devices + cpu;
 	if (pcpu->state != CPU_STATE_CONFIGURED)
 		return -EIO;
-	base = smp_get_base_cpu(cpu);
-	for (i = 0; i <= smp_cpu_mtid; i++) {
-		if (base + i < nr_cpu_ids)
-			if (cpu_online(base + i))
-				break;
-	}
-	/*
-	 * If this is the first CPU of the core to get online
-	 * do an initial CPU reset.
-	 */
-	if (i > smp_cpu_mtid &&
-	    pcpu_sigp_retry(pcpu_devices + base, SIGP_INITIAL_CPU_RESET, 0) !=
+	if (pcpu_sigp_retry(pcpu, SIGP_INITIAL_CPU_RESET, 0) !=
 	    SIGP_CC_ORDER_CODE_ACCEPTED)
 		return -EIO;
 

