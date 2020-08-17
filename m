Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5892D246674
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 14:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgHQMgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 08:36:20 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:36495 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726809AbgHQMgT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 08:36:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3FCD31941512;
        Mon, 17 Aug 2020 08:36:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 08:36:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=HlB9T4
        xj5k5roTj3wNfGLXvLd03U5kw2Ibo9au+fyjc=; b=tLf9kETlxX+SVriQqIz8Em
        DoXj87sZ5t1vdD/j8654Q5zpJFgwBEvPWmQbqZurxxUra0Nz7JIZfJjbizLTAMT+
        i4gff6NC7u+LJO0DHzOQITUGHQbYU3dvXym2DLZQJibTC550HuUmOfuJ+KJA8gcV
        VVDHYoKivDpIXBYdqLED9o05XLHphiGHNuaoswY8jF5764S2rzsXA1W308NE6wO5
        d730WP737n3HH/QSTjynE8TdTBBKkqRviITSRxMwbhMJOG0MWxdFp2THx6JnHN8U
        eTo4/U1tp2kU0AL4NiKEMaMr7kGRvT9ngWzk1NyI9v6YGuM9D2LULqJQGQmx1j6A
        ==
X-ME-Sender: <xms:wnk6Xzy7EsXOkU5xHKET_N0Dte3u2d8ELH6fJbnXSZe6VR7kOeBnRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:wnk6X7S8d6iuIPX8yvWFzzWT-xErCtIbtvGNTcQyuS2ETlV4kJ1zmQ>
    <xmx:wnk6X9Vo1VOyExxotmBI-Uvbn0mXk95bXFIG5Ce-14OWW4RUv2LFLQ>
    <xmx:wnk6X9hsTA0mo8sETnbmI7DOG-aM69CeBV-wAcLba_T0xH8-xUJaOg>
    <xmx:wnk6X4PRsOmbvlKN_L6OG1gU-5eShxmhFd4FCW3Cuk2ppwLc44yUQQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D8810328005D;
        Mon, 17 Aug 2020 08:36:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PM / devfreq: Fix indentaion of devfreq_summary debugfs node" failed to apply to 5.4-stable tree
To:     cw00.choi@samsung.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 14:36:35 +0200
Message-ID: <159766779530130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

