Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E9B2E0150
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 20:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgLUTyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 14:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgLUTyA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 14:54:00 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC9AC0613D3
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 11:53:20 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id v14so46511wml.1
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 11:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uuPY0CQ5Pg5RJus7LV7SldZ9CpkwpeioinKADBvFUMc=;
        b=UL6wYwFMsG5nKPnWNbfiwZ+r+tAW/hwpeomPs0B+7fJuPmWODpBlaWzC6EPE7hFTSL
         mrSv9TCP8B1IDn8m3b92fNgyWHKL/F4Gccy13Z9McB1mRIN7r94A3IAGPHeMswuoU/p+
         zOibAU4Ih0wcyQBa+htLR0E6V4LPwHGZLoquEjMug+rg9yJsvTtWkLrN7lIwl9c8twMM
         ghlhs9GoJKRE9HS9QwgfRIZHpN37HRd6pHU8HBfNJ0VxyFbie6vvNBn7Lc7ZpTDef6n0
         PqqAVQr8cROilkAIPnMevHqvbZxv/EIIf6fH+A/zCH+69mQ0NZykue1hOgRr9kEQWXWC
         RF0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uuPY0CQ5Pg5RJus7LV7SldZ9CpkwpeioinKADBvFUMc=;
        b=AepMs+tKiXoYe0HJhSqp6+XoWmyAIDM7+MdU0th8v9z46zzkCHe+Kc26DV6B7AMedo
         2xLRokAMzw0MZGYHVNnnGTfuvOARyGCvmqmvmRZL3dHLyJBjdOH/Ivhf9pplkOPPVd5M
         5cjdNdfNIf0/KfTaaGKmDas6rsiDmRP2ZA0UlS09jax+6bii1UcwmqwA4+4/B8UPd3yY
         zIsJ2nTRlsx5aPChauh87tV4cMwR/exSeuhyMR8kAIyigBK75vTPakto9nDBgN+XIWeA
         Ne2JnTyeBIr9sAjqe79jZt7ALSDust3kzR0HpdMIQGtY9kS5WX8Kp3iR2QHZmD1Yae4p
         8J9g==
X-Gm-Message-State: AOAM530OXzqMhCUxTJ+XAitarfaho6wO3dqtHz/RbyFx5vGRkhkFZWJE
        WSpYTynXzvHEJ6rvXA3+pJbi2BpRqA+1GyKJ
X-Google-Smtp-Source: ABdhPJwG8M2z3MLuHZf/T3x/JDSxCHQMH1QNosQNtufnPNifBHhQyZD8y4wEgea3iDuu+KqzsoJGiw==
X-Received: by 2002:a7b:c397:: with SMTP id s23mr18066687wmj.63.1608580399234;
        Mon, 21 Dec 2020 11:53:19 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id c4sm25387717wmf.19.2020.12.21.11.53.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 21 Dec 2020 11:53:18 -0800 (PST)
Date:   Mon, 21 Dec 2020 19:53:16 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     wqu@suse.com, dsterba@suse.com, fdmanana@suse.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: trim: fix underflow in trim length
 to prevent access" failed to apply to 5.4-stable tree
Message-ID: <20201221195316.2ghzag6fblousbu7@debian>
References: <15978369934613@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rjv344vw4tbv43i4"
Content-Disposition: inline
In-Reply-To: <15978369934613@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rjv344vw4tbv43i4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Wed, Aug 19, 2020 at 01:36:33PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--rjv344vw4tbv43i4
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-btrfs-trim-fix-underflow-in-trim-length-to-prevent-a.patch"

From 310079d12dd563fe3a065b6dfe66629e3b6611ee Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Fri, 31 Jul 2020 19:29:11 +0800
Subject: [PATCH] btrfs: trim: fix underflow in trim length to prevent access beyond device boundary

commit c57dd1f2f6a7cd1bb61802344f59ccdc5278c983 upstream

[BUG]
The following script can lead to tons of beyond device boundary access:

  mkfs.btrfs -f $dev -b 10G
  mount $dev $mnt
  trimfs $mnt
  btrfs filesystem resize 1:-1G $mnt
  trimfs $mnt

[CAUSE]
Since commit 929be17a9b49 ("btrfs: Switch btrfs_trim_free_extents to
find_first_clear_extent_bit"), we try to avoid trimming ranges that's
already trimmed.

So we check device->alloc_state by finding the first range which doesn't
have CHUNK_TRIMMED and CHUNK_ALLOCATED not set.

But if we shrunk the device, that bits are not cleared, thus we could
easily got a range starts beyond the shrunk device size.

This results the returned @start and @end are all beyond device size,
then we call "end = min(end, device->total_bytes -1);" making @end
smaller than device size.

Then finally we goes "len = end - start + 1", totally underflow the
result, and lead to the beyond-device-boundary access.

[FIX]
This patch will fix the problem in two ways:

- Clear CHUNK_TRIMMED | CHUNK_ALLOCATED bits when shrinking device
  This is the root fix

- Add extra safety check when trimming free device extents
  We check and warn if the returned range is already beyond current
  device.

Link: https://github.com/kdave/btrfs-progs/issues/282
Fixes: 929be17a9b49 ("btrfs: Switch btrfs_trim_free_extents to find_first_clear_extent_bit")
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[sudip: adjust context and use extent_io.h]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/btrfs/extent-tree.c | 14 ++++++++++++++
 fs/btrfs/extent_io.h   |  2 ++
 fs/btrfs/volumes.c     |  4 ++++
 3 files changed, 20 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c6d9e8c07c23..833266de785c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -32,6 +32,7 @@
 #include "block-rsv.h"
 #include "delalloc-space.h"
 #include "block-group.h"
+#include "rcu-string.h"
 
 #undef SCRAMBLE_DELAYED_REFS
 
@@ -5618,6 +5619,19 @@ static int btrfs_trim_free_extents(struct btrfs_device *device, u64 *trimmed)
 					    &start, &end,
 					    CHUNK_TRIMMED | CHUNK_ALLOCATED);
 
+		/* Check if there are any CHUNK_* bits left */
+		if (start > device->total_bytes) {
+			WARN_ON(IS_ENABLED(CONFIG_BTRFS_DEBUG));
+			btrfs_warn_in_rcu(fs_info,
+"ignoring attempt to trim beyond device size: offset %llu length %llu device %s device size %llu",
+					  start, end - start + 1,
+					  rcu_str_deref(device->name),
+					  device->total_bytes);
+			mutex_unlock(&fs_info->chunk_mutex);
+			ret = 0;
+			break;
+		}
+
 		/* Ensure we skip the reserved area in the first 1M */
 		start = max_t(u64, start, SZ_1M);
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index bc858c8cef0a..fcf1807cc8dd 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -35,6 +35,8 @@
  */
 #define CHUNK_ALLOCATED EXTENT_DIRTY
 #define CHUNK_TRIMMED   EXTENT_DEFRAG
+#define CHUNK_STATE_MASK			(CHUNK_ALLOCATED |		\
+						 CHUNK_TRIMMED)
 
 /*
  * flags for bio submission. The high bits indicate the compression
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 457f8f858a3f..67ffbe92944c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4908,6 +4908,10 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	}
 
 	mutex_lock(&fs_info->chunk_mutex);
+	/* Clear all state bits beyond the shrunk device size */
+	clear_extent_bits(&device->alloc_state, new_size, (u64)-1,
+			  CHUNK_STATE_MASK);
+
 	btrfs_device_set_disk_total_bytes(device, new_size);
 	if (list_empty(&device->post_commit_list))
 		list_add_tail(&device->post_commit_list,
-- 
2.11.0


--rjv344vw4tbv43i4--
