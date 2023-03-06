Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8EC6AB700
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 08:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjCFH0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 02:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjCFH0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 02:26:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25521EBCD
        for <stable@vger.kernel.org>; Sun,  5 Mar 2023 23:26:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E22C60B89
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 07:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39498C433D2;
        Mon,  6 Mar 2023 07:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678087563;
        bh=xneykIU481y9Xs1+whoooHjDQgzTDfmSY7tdTAVp3nk=;
        h=Subject:To:Cc:From:Date:From;
        b=SxDvBFk9CE5odc1HH4T50yhMg9vvHn4fTNCkqoesyoHHNUIPhmDfuS6sDfibnRmJu
         kzzOlVvEO01WvIZ7PxE80TJ8B8Q5gKRSfgnmTGBoDvffydMfC4+bHBMpMi2NDCZSMA
         guTNUgsYfAMbakJ6Xd/ZAmcQ8QFjHr0N442pAGN4=
Subject: FAILED: patch "[PATCH] block: clear bio->bi_bdev when putting a bio back in the" failed to apply to 5.15-stable tree
To:     axboe@kernel.dk, kbusch@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 08:26:01 +0100
Message-ID: <1678087561207107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 11eb695feb636fa5211067189cad25ac073e7fe5
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678087561207107@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

11eb695feb63 ("block: clear bio->bi_bdev when putting a bio back in the cache")
f25cf75a4521 ("bio: split pcpu cache part of bio_put into a helper")
d4347d50407d ("bio: safeguard REQ_ALLOC_CACHE bio put")
0df71650c051 ("block: allow using the per-cpu bio cache from bio_alloc_bioset")
49add4966d79 ("block: pass a block_device and opf to bio_init")
07888c665b40 ("block: pass a block_device and opf to bio_alloc")
b77c88c2100c ("block: pass a block_device and opf to bio_alloc_kiocb")
609be1066731 ("block: pass a block_device and opf to bio_alloc_bioset")
0a3140ea0fae ("block: pass a block_device and opf to blk_next_bio")
3b005bf6acf0 ("block: move blk_next_bio to bio.c")
7d8d0c658d48 ("xen-blkback: bio_alloc can't fail if it is allow to sleep")
d7b78de2b155 ("rnbd-srv: remove struct rnbd_dev_blk_io")
1fe0640ff94f ("rnbd-srv: simplify bio mapping in process_rdma")
4b1dc86d1857 ("drbd: bio_alloc can't fail if it is allow to sleep")
3f868c09ea8f ("dm-crypt: remove clone_init")
53db984e004c ("dm: bio_alloc can't fail if it is allowed to sleep")
39146b6f66ba ("ntfs3: remove ntfs_alloc_bio")
5d2ca2132f88 ("nfs/blocklayout: remove bl_alloc_init_bio")
f0d911927b3c ("nilfs2: remove nilfs_alloc_seg_bio")
d5f68a42da7a ("fs: remove mpage_alloc")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 11eb695feb636fa5211067189cad25ac073e7fe5 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 24 Feb 2023 09:59:44 -0700
Subject: [PATCH] block: clear bio->bi_bdev when putting a bio back in the
 cache

This isn't strictly needed in terms of correctness, but it does allow
polling to know if the bio has been put already by a different task
and hence avoid polling something that we don't need to.

Cc: stable@vger.kernel.org
Fixes: be4d234d7aeb ("bio: add allocation cache abstraction")
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/bio.c b/block/bio.c
index 2693f34afb7e..605c40025068 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -772,6 +772,7 @@ static inline void bio_put_percpu_cache(struct bio *bio)
 
 	if ((bio->bi_opf & REQ_POLLED) && !WARN_ON_ONCE(in_interrupt())) {
 		bio->bi_next = cache->free_list;
+		bio->bi_bdev = NULL;
 		cache->free_list = bio;
 		cache->nr++;
 	} else {

