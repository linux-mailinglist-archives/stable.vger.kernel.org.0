Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEF0246673
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 14:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgHQMgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 08:36:17 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:38297 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726809AbgHQMgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 08:36:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id B4C8B19415D9;
        Mon, 17 Aug 2020 08:36:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 08:36:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ILfGXl
        Tgeri+SK9bst6BT9MKUExS6Fec4AjyhmPSuR8=; b=SoygqNs5ML1SNHsezxN0MD
        BZxVZ6Je/QKTtxG/1UtPmiN/5XtdqLfVx7/PNb4D85GGOBnsNys7Btpp/ea8hMJU
        Amoh6JA4Puq4RjnUxkW1Ef3cK/H0eeMg1yeNQ9Bz+GWRcn1bCrCK8rcJgkjQXVTJ
        YcGe5ZuJ8PTebc42j3GLyW4UCgiWO/BpxPMXmCtewWt1lgzlgbL9WUZPyC8zEFvs
        WY7uBhmJCj4g4fc6B43TX//ggWoYCvwHGdV7nlBzwUk/KTo9+0llrDULJtRFY/iA
        36roJC6y/ki6DtLPIDMydAXxeLBAApNZdKWVvoODvfi77nSAr02bCLE/I3PVsDzg
        ==
X-ME-Sender: <xms:v3k6XzfXaOzAi_3MRihlO1hLGOkAXpNM8kZWQUM3W5yE8eh2-a-9Iw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:v3k6X5MoqTpeuz8-R1pgsMuJhnkqDsI2tYMXbM6vGe1MRL8V1DqywQ>
    <xmx:v3k6X8iwXs3miIkPgMhML6PpShLgv3Q_QB6syKW7Ad86qOE1jiD0Gw>
    <xmx:v3k6X09haDGQ1R5c3ulFAPi_PHBLmeber8qjppoZzTxyDbn-BK2dxw>
    <xmx:v3k6X95Rcmc6EzbNkqN9KdqamO17xgKnxuvP8vykm9mkhwY6lY2Dyw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5292A3280065;
        Mon, 17 Aug 2020 08:36:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PM / devfreq: Fix indentaion of devfreq_summary debugfs node" failed to apply to 4.19-stable tree
To:     cw00.choi@samsung.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 14:36:34 +0200
Message-ID: <1597667794240196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 0aae11bcdefb4894b6100656ad24cbd85ff34b52 Mon Sep 17 00:00:00 2001
From: Chanwoo Choi <cw00.choi@samsung.com>
Date: Thu, 9 Jul 2020 15:51:34 +0900
Subject: [PATCH] PM / devfreq: Fix indentaion of devfreq_summary debugfs node

The commit 66d0e797bf09 ("Revert "PM / devfreq: Modify the device name
as devfreq(X) for sysfs"") roll back the device name from 'devfreqX'
to device name explained in DT. After applied commit 66d0e797bf09,
the indentation of devfreq_summary debugfs node was broken.

So, fix indentaion of devfreq_summary debugfs node as following:

For example on Exynos5422-based Odroid-XU3 board,
$ cat /sys/kernel/debug/devfreq/devfreq_summary
dev                            parent_dev                     governor        polling_ms  cur_freq_Hz  min_freq_Hz  max_freq_Hz
------------------------------ ------------------------------ --------------- ---------- ------------ ------------ ------------
10c20000.memory-controller     null                           simple_ondemand          0    413000000    165000000    825000000
soc:bus_wcore                  null                           simple_ondemand         50     88700000     88700000    532000000
soc:bus_noc                    soc:bus_wcore                  passive                  0     66600000     66600000    111000000
soc:bus_fsys_apb               soc:bus_wcore                  passive                  0    111000000    111000000    222000000
soc:bus_fsys                   soc:bus_wcore                  passive                  0     75000000     75000000    200000000
soc:bus_fsys2                  soc:bus_wcore                  passive                  0     75000000     75000000    200000000
soc:bus_mfc                    soc:bus_wcore                  passive                  0     83250000     83250000    333000000
soc:bus_gen                    soc:bus_wcore                  passive                  0     88700000     88700000    266000000
soc:bus_peri                   soc:bus_wcore                  passive                  0     66600000     66600000     66600000
soc:bus_g2d                    soc:bus_wcore                  passive                  0     83250000     83250000    333000000
soc:bus_g2d_acp                soc:bus_wcore                  passive                  0            0     66500000    266000000
soc:bus_jpeg                   soc:bus_wcore                  passive                  0            0     75000000    300000000
soc:bus_jpeg_apb               soc:bus_wcore                  passive                  0            0     83250000    166500000
soc:bus_disp1_fimd             soc:bus_wcore                  passive                  0            0    120000000    200000000
soc:bus_disp1                  soc:bus_wcore                  passive                  0            0    120000000    300000000
soc:bus_gscl_scaler            soc:bus_wcore                  passive                  0            0    150000000    300000000
soc:bus_mscl                   soc:bus_wcore                  passive                  0            0     84000000    666000000

Cc: stable@vger.kernel.org
Fixes: 66d0e797bf09 ("Revert "PM / devfreq: Modify the device name as devfreq(X) for sysfs"")
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 286957f760f1..9d324ff87ee6 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -1767,8 +1767,7 @@ static int devfreq_summary_show(struct seq_file *s, void *data)
 	unsigned long cur_freq, min_freq, max_freq;
 	unsigned int polling_ms;
 
-	seq_printf(s, "%-30s %-10s %-10s %-15s %10s %12s %12s %12s\n",
-			"dev_name",
+	seq_printf(s, "%-30s %-30s %-15s %10s %12s %12s %12s\n",
 			"dev",
 			"parent_dev",
 			"governor",
@@ -1776,10 +1775,9 @@ static int devfreq_summary_show(struct seq_file *s, void *data)
 			"cur_freq_Hz",
 			"min_freq_Hz",
 			"max_freq_Hz");
-	seq_printf(s, "%30s %10s %10s %15s %10s %12s %12s %12s\n",
+	seq_printf(s, "%30s %30s %15s %10s %12s %12s %12s\n",
+			"------------------------------",
 			"------------------------------",
-			"----------",
-			"----------",
 			"---------------",
 			"----------",
 			"------------",
@@ -1808,8 +1806,7 @@ static int devfreq_summary_show(struct seq_file *s, void *data)
 		mutex_unlock(&devfreq->lock);
 
 		seq_printf(s,
-			"%-30s %-10s %-10s %-15s %10d %12ld %12ld %12ld\n",
-			dev_name(devfreq->dev.parent),
+			"%-30s %-30s %-15s %10d %12ld %12ld %12ld\n",
 			dev_name(&devfreq->dev),
 			p_devfreq ? dev_name(&p_devfreq->dev) : "null",
 			devfreq->governor_name,

