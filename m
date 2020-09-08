Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94512613C2
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 17:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbgIHPr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 11:47:59 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:60649 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730585AbgIHPrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 11:47:13 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id EF460FC0;
        Tue,  8 Sep 2020 08:27:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 08 Sep 2020 08:27:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=F9Ps5Y
        whDRypAMLNAKuUKZVlnu7n+WCwSTptlNVDPzE=; b=OfBkhnZLfqepfBjwKAztvV
        3cEGMHzF2zVG9dVQhB7aGroEbeWh4xFohaYh6VauVFAwQ6+VgVKx72vXMOtBA8T+
        r0ld/31/IhM/mzwu8Q158SkvRInHVAdR06TC9gY8PMbj6m3BTPxJvRoKdw55+8/D
        KqHqouBl2ofJnRWZHKQt3ltI1ANZVrudiZTNCeI7NzhKfUwj5EtpEQZenOhFnaah
        6RJkxLEOSzv7KmL0dgG4sYJlLX5QHYN8UPYtM5BGZMy/JqP//yqh0fwxrNQuzLhO
        zhpoapU+koI8wMSNS8P8SKTlhsYFmksdt3nJgSUX9UfG0U2H3wbDgrB+k8lH6pmQ
        ==
X-ME-Sender: <xms:vXhXX-jui_Pmx-7oDQMDOaDizloCvqPSEQyV6s6Pr5iZ12LmloZCNw>
    <xme:vXhXX_BEDyH6hl__vsGfBrc8iYuclKha8OOPw-uGENSY04JrHmLAgu1j3ubgl63TO
    s-qZSwxpFAadQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehfedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:vXhXX2FSEHCSAcq_SgWzdj83xDDskwdYURlIAGz06o1jkFTVsFix1Q>
    <xmx:vXhXX3SlRbUW1-_B1XWHgz_KW6wUeDwocfG5LQDQ21EL764TFiMXSQ>
    <xmx:vXhXX7xugRxit4pRoU7ItJ3KKYWuIzXVEJdruToSnVx4CcWp5vPnpw>
    <xmx:vXhXX0pr2LDC5Bi7dlpBK94KpYvIHr66sLNzDSI1oxTfUjotH1__qUBVULg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A49B2306467D;
        Tue,  8 Sep 2020 08:27:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] block: ensure bdi->io_pages is always initialized" failed to apply to 4.14-stable tree
To:     axboe@kernel.dk, hch@lst.de, hirofumi@mail.parknet.co.jp
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Sep 2020 14:27:53 +0200
Message-ID: <15995680734215@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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
 

