Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B23F330165
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhCGNtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:49:16 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:39605 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231463AbhCGNtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:49:06 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id AD5E819BE;
        Sun,  7 Mar 2021 08:49:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:49:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hgr3U7
        yDx9SswwhnzwxX7fS9t1PtSnRuzHz7ZPukue4=; b=SLVmYwesp1PJHPljH91ixm
        5YtQsqHaA9UfYNkgupu9hkVVhszJn4zumwsuuFVzsOwCqEkuQghFVaH91YEMQG9j
        mZLfnDN/xMq9BH2m101q1AyfQskisXD2KR+7vN6AfOxWzOpIaXkIoOvkN7AmG5SP
        q6zIS++1b11rLUBJcDhE63k+ovbCH8ggr2WUCW2eo7U0KDrSRqQLp9lQ2C62U33l
        tlUVYi7fTEAU8F6xwwJKSnsQRS7EBByl2qXSCKLXyrSVFuB9LUrKafV14zkVEDnx
        Y1h2OOpmDUJvtCPRRKuPU2a5IZUUk03FdMEVN5tYqghREm89odx/pGJ7OeJXQemg
        ==
X-ME-Sender: <xms:0dlEYHVO_X73_w37-PWag9w-1PDmYVAu1zN7olGTl_cCt-W_jvVtqQ>
    <xme:0dlEYPmhKbjjaoFB4_8I33bIIOM102g3PyxCvhPVoMXmQHFSJG1Wr5anEFmjQ2xks
    9aR0vNB_pggWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepleenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:0dlEYDYFLAhZJlpR7pGQnbNAVoBGheB1iNQsfyaR0a05SoXfXr9Msg>
    <xmx:0dlEYCUoGO4Gkl1egyjs2Milsh-NIDfkbJrmw1qC4T7jCrCbKwkhew>
    <xmx:0dlEYBkaumgRxWviX3z7Yrjx9dH5YP28oTewdUO76hh82L1k5CRLEg>
    <xmx:0dlEYBszvJXuS6J6Q2LZjagshWt4Zb4EMSSuAQu27y1_P6fcaAmIdJxARxE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CEB631080054;
        Sun,  7 Mar 2021 08:49:04 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: fix race between extent freeing/allocation when using" failed to apply to 5.4-stable tree
To:     nborisov@suse.com, dsterba@suse.com, josef@toxicpanda.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:48:57 +0100
Message-ID: <161512493792148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 3c17916510428dbccdf657de050c34e208347089 Mon Sep 17 00:00:00 2001
From: Nikolay Borisov <nborisov@suse.com>
Date: Mon, 8 Feb 2021 10:26:54 +0200
Subject: [PATCH] btrfs: fix race between extent freeing/allocation when using
 bitmaps

During allocation the allocator will try to allocate an extent using
cluster policy. Once the current cluster is exhausted it will remove the
entry under btrfs_free_cluster::lock and subsequently acquire
btrfs_free_space_ctl::tree_lock to dispose of the already-deleted entry
and adjust btrfs_free_space_ctl::total_bitmap. This poses a problem
because there exists a race condition between removing the entry under
one lock and doing the necessary accounting holding a different lock
since extent freeing only uses the 2nd lock. This can result in the
following situation:

T1:                                    T2:
btrfs_alloc_from_cluster               insert_into_bitmap <holds tree_lock>
 if (entry->bytes == 0)                   if (block_group && !list_empty(&block_group->cluster_list)) {
    rb_erase(entry)

 spin_unlock(&cluster->lock);
   (total_bitmaps is still 4)           spin_lock(&cluster->lock);
                                         <doesn't find entry in cluster->root>
 spin_lock(&ctl->tree_lock);             <goes to new_bitmap label, adds
<blocked since T2 holds tree_lock>       <a new entry and calls add_new_bitmap>
					    recalculate_thresholds  <crashes,
                                              due to total_bitmaps
					      becoming 5 and triggering
					      an ASSERT>

To fix this ensure that once depleted, the cluster entry is deleted when
both cluster lock and tree locks are held in the allocator (T1), this
ensures that even if there is a race with a concurrent
insert_into_bitmap call it will correctly find the entry in the cluster
and add the new space to it.

CC: <stable@vger.kernel.org> # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 5400294bd271..abcf951e6b44 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3125,8 +3125,6 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group *block_group,
 			entry->bytes -= bytes;
 		}
 
-		if (entry->bytes == 0)
-			rb_erase(&entry->offset_index, &cluster->root);
 		break;
 	}
 out:
@@ -3143,7 +3141,10 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group *block_group,
 	ctl->free_space -= bytes;
 	if (!entry->bitmap && !btrfs_free_space_trimmed(entry))
 		ctl->discardable_bytes[BTRFS_STAT_CURR] -= bytes;
+
+	spin_lock(&cluster->lock);
 	if (entry->bytes == 0) {
+		rb_erase(&entry->offset_index, &cluster->root);
 		ctl->free_extents--;
 		if (entry->bitmap) {
 			kmem_cache_free(btrfs_free_space_bitmap_cachep,
@@ -3156,6 +3157,7 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group *block_group,
 		kmem_cache_free(btrfs_free_space_cachep, entry);
 	}
 
+	spin_unlock(&cluster->lock);
 	spin_unlock(&ctl->tree_lock);
 
 	return ret;

