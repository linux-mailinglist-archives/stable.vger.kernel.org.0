Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6D52E350D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 09:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgL1I3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 03:29:46 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:46877 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726282AbgL1I3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 03:29:46 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 6E16E734;
        Mon, 28 Dec 2020 03:28:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 03:28:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=WlE3KE
        cr+o9h9BnAr3VwC1xWSvdFwKuwWDA2bVRANH8=; b=qd4FlrOYQWeuMVg2RQQbeq
        qw7wo0pV0SctC0d4oNALNhLEWs2dcqqtLjDq/xFk7GioO9H7V3MRQSQCz0ivSZqE
        EdcZlCI2p4gcjqY/sfR7ZVZ4iQMr9sbHrWN+07e6XWFSVtJwJPToB6QEWqy2BriE
        GGq8NZuqURHLmbgkHSE/0o1wAlzpRUW58RNJTWrXoP2QY+a65IOaEt9GbElWtgPD
        wlmSDmzb/7DnEvIEiVoNxM6r7pq9knEoY2x0LxLtKz7VEGXjIdnUnoeWwUGCXXQH
        WRU9fzUuEzpn0Rg0bGT5Dk8brU5/OElZhHdTWAyguY+r3jjavOLdSc7KIRdrY9ZA
        ==
X-ME-Sender: <xms:N5fpX-YNJ-4G4HJucaia8Ko7jTB3xSK4AX7Mh7xWLfTa1BKKP4rbbw>
    <xme:N5fpXxarGwk6rq3p_TaWOpJbjBzuez9ljS-gB75jS88iFpAQwkAAjfIWgAqn9_Mtd
    9cgCzA91dwcLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddukedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:OJfpX4_0JYBjR6COIOVQS37pRFsqfeFkEIHA6JiOuX_WQ2hheHLPnQ>
    <xmx:OJfpXwoHmWRjd3jPFnfSj_g_C0JWYzYGHV2fZ2JQoCa6pG7-BSIIZw>
    <xmx:OJfpX5q_9rY76xgNWXYCvjbZlh-1_3sAboGiNpiBNPAyCOzwfCK5TA>
    <xmx:OJfpX6Ap4liGSO1SBsdJpeiwphLvgWK0-j3_xbTX90rvDqfhmEwac1O2OUU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A46DE108005B;
        Mon, 28 Dec 2020 03:28:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390/smp: perform initial CPU reset also for SMT siblings" failed to apply to 4.9-stable tree
To:     svens@linux.ibm.com, hca@linux.ibm.com, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 09:29:54 +0100
Message-ID: <16091441944247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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
 

