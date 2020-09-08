Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B985F261B90
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731421AbgIHTDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:03:12 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:45631 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731278AbgIHQHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 12:07:53 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 613BCF66;
        Tue,  8 Sep 2020 08:27:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 08 Sep 2020 08:27:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=4odmrf
        kmPz61Cq6VFogVCyBAzeimFahkzh0EkgebJ+0=; b=L/FkIBzZVzr/tmdStLh3J5
        SHxdLlIkzNjZEe8Jk+mMKDQTUZTQV5i2m5qLK4QCULZQh4Xh0EiiHV0DPjUYHy3M
        15imn9HwMBVMAQ47UZjki8MREHFgk9k4dBZDF855jP9q3SPffztyz7A91ItOFxbj
        /OYwxRHW8B3UOuC1/pXhi5POGUe059eiO+j68I2/j/LHSX+SwGo6CrPpc5KYc6La
        K+KSfIuaFBoUQCVfFEz+OCYhlY43qh1o9vqt6zPnsQCGFuxklcsg0MKZzQp+CKLl
        d760rl7wwiRU7DUCms2CXT0R6PnZF5ecEdUqpjc6wrtAu/QB8X4zGIfur/WdoJzg
        ==
X-ME-Sender: <xms:xHhXX2f3GSKwaNoIbzdnQd6ks-0syUKGecHA5KnNImhCvwD9d5UvLw>
    <xme:xHhXXwP9PobToPdtd6RIGwk8jduC9zFl6-8oqwDhmOR3mutKfB2xNmg2oeC_TnrB8
    gTXMX8xPM2Abw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehfedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:xHhXX3jERpCXCTOeHVq4eiORZYO6Vb7F-sPtQU5CUHzSh-BatE9fSQ>
    <xmx:xHhXXz_jKHbRM1QYVCg17ZDiDlG9GJPdsK0ZOZo24I_X3SyuKNvecw>
    <xmx:xHhXXysg62ert2-2FuxcBW1YNiIcopzDBTjf12i2TZ7S-hdG-EEV1g>
    <xmx:xXhXX3V327SQ1wXMCMoM7U0TAqo79X0a5nmTLPJ4Eevp46MEJV563LfuYR8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A12B33280065;
        Tue,  8 Sep 2020 08:27:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] block: ensure bdi->io_pages is always initialized" failed to apply to 4.19-stable tree
To:     axboe@kernel.dk, hch@lst.de, hirofumi@mail.parknet.co.jp
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Sep 2020 14:27:54 +0200
Message-ID: <159956807487205@kroah.com>
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

From de1b0ee490eafdf65fac9eef9925391a8369f2dc Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 31 Aug 2020 11:20:02 -0600
Subject: [PATCH] block: ensure bdi->io_pages is always initialized

If a driver leaves the limit settings as the defaults, then we don't
initialize bdi->io_pages. This means that file systems may need to
work around bdi->io_pages == 0, which is somewhat messy.

Initialize the default value just like we do for ->ra_pages.

Cc: stable@vger.kernel.org
Fixes: 9491ae4aade6 ("mm: don't cap request size based on read-ahead setting")
Reported-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/blk-core.c b/block/blk-core.c
index d9d632639bd1..10c08ac50697 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -539,6 +539,7 @@ struct request_queue *blk_alloc_queue(int node_id)
 		goto fail_stats;
 
 	q->backing_dev_info->ra_pages = VM_READAHEAD_PAGES;
+	q->backing_dev_info->io_pages = VM_READAHEAD_PAGES;
 	q->backing_dev_info->capabilities = BDI_CAP_CGROUP_WRITEBACK;
 	q->node = node_id;
 

