Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A51F200A81
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731661AbgFSNoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:44:24 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:56313 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731806AbgFSNoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:44:24 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id F1E00194573B;
        Fri, 19 Jun 2020 09:44:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:44:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=b5UGdy
        nDFUPNMIGWaKeKxyooBfTopuPHN2bjaG6lOtY=; b=u/JeiushlyUmRJ3rN7BlBW
        yANGUNw0dCWYNfisvuELoPrinzha8cYnSguLA6YPZDQLPNiOo0QverM4JWGUVOvC
        iv8Yyt1NQc2l/JynBfgBXeOnjx2eZoAR0HdV1OmBhzoY9eGkp8hiIkvP0WG7gT2G
        mzY/u0YeEYzXeBuwu8sc/oCrupAhC7aBuyy2qEgAFcxAyYI9WlhtUP9al8c4QXgf
        Pp78vMZ/2fZe1QTnZBKEqIA8FDNSEHKDWKJzwFEV+L6WIKb/u67doPwkaXyb92Vm
        1nxQwqwqXN54/U5p681dToULc8Mb6I+tS5iWVfBb4hf7EZZylYucMfY/PjcJUQUA
        ==
X-ME-Sender: <xms:NcHsXrTUW4Pc5FHFLKSCSxyDHZDQmLkVsZ6ksK5VRIjLkk975GIlfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:NcHsXsxkGeV9D4bfsb8GhFYVuzRVHUBNdHNx_IVCHYY3AF5uh_rQEQ>
    <xmx:NcHsXg2Lzycwes79BEeyExf4KBQwCPpQcTpkLsXV3txLr_99e7eFzA>
    <xmx:NcHsXrBOKyVEI_xWV9l045lsvN5qimINR641v38vKgqPAv6Nz9hlWw>
    <xmx:NcHsXsIcTF2xaPUvfsa5BmjI4ebRXFdDGXJPCdlCbP7XJfS7QMY_Pw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7492F3060FE7;
        Fri, 19 Jun 2020 09:44:21 -0400 (EDT)
Subject: FAILED: patch "[PATCH] block: nr_sects_write(): Disable preemption on seqcount write" failed to apply to 4.9-stable tree
To:     a.darwish@linutronix.de, axboe@kernel.dk, bigeasy@linutronix.de,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:43:42 +0200
Message-ID: <15925742226560@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 15b81ce5abdc4b502aa31dff2d415b79d2349d2f Mon Sep 17 00:00:00 2001
From: "Ahmed S. Darwish" <a.darwish@linutronix.de>
Date: Wed, 3 Jun 2020 16:49:48 +0200
Subject: [PATCH] block: nr_sects_write(): Disable preemption on seqcount write

For optimized block readers not holding a mutex, the "number of sectors"
64-bit value is protected from tearing on 32-bit architectures by a
sequence counter.

Disable preemption before entering that sequence counter's write side
critical section. Otherwise, the read side can preempt the write side
section and spin for the entire scheduler tick. If the reader belongs to
a real-time scheduling class, it can spin forever and the kernel will
livelock.

Fixes: c83f6bf98dc1 ("block: add partition resize function to blkpg ioctl")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/blk.h b/block/blk.h
index aa16e524dc35..b5d1f0fc6547 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -420,9 +420,11 @@ static inline sector_t part_nr_sects_read(struct hd_struct *part)
 static inline void part_nr_sects_write(struct hd_struct *part, sector_t size)
 {
 #if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+	preempt_disable();
 	write_seqcount_begin(&part->nr_sects_seq);
 	part->nr_sects = size;
 	write_seqcount_end(&part->nr_sects_seq);
+	preempt_enable();
 #elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPTION)
 	preempt_disable();
 	part->nr_sects = size;

