Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55EB139E847
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 22:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhFGUWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 16:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbhFGUWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 16:22:03 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF52C061574
        for <stable@vger.kernel.org>; Mon,  7 Jun 2021 13:20:00 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 3-20020a05600c0243b029019f2f9b2b8aso425850wmj.2
        for <stable@vger.kernel.org>; Mon, 07 Jun 2021 13:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L99ghj7DK9xZAikBkJVJyskjTAZPRrFsp+Viav8tQH0=;
        b=oT5GGcOLY827sm3JAbvucl3yWs8fhRUr3IHTVACtDuOn7b135Qqhi3NhVpBh2VzOYg
         j7oh/GqObrdjn7QcxrbBnLd3B05r3v2kV752KO9QnpfZy94FRo94WCtzKDyWMifJ8K/6
         Efq1H9cMvMGI1ydfLNPknyC81ZN88zRXQWdQ2MGZOUmrR3wwyij2bWPcvz1yCgAbRulL
         tIuelE06w+Ykbq9DCEaUA9gpu2tcqcB8FqDeQBIPrd7tjb0RZYUSASpzpZ7cILMD5ZpT
         c1GJ81SHjeyL9PqQ7nWKMF6529EfyQu+IIHek0W2b1Sr+IcSdDKVyJ1G+VvSeJJlClG6
         xbOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L99ghj7DK9xZAikBkJVJyskjTAZPRrFsp+Viav8tQH0=;
        b=W4Ayx1QY22MZCiQW0LCKfXEeasdaIVuZ39uYWO5omcFJewYfqKYyXSd3Il4ftXY/xl
         sPLNpBCAqeRvadWI3uDnOFfkMj1Ui+wbcHXQjIYt4bxhAC/coa7Ca4iRvG29tHqutdI0
         bPb5hRlJjbWRJXUZzCdKrzPd5u9tvgi2h98Uqptn0fw8rbr3J/o8+YFLvaEdLAPKp9Vh
         rrWrNotX+wbPJz7AkSLSy5eAoiK+/zBdssynnd0+rgsoaarDoOAGqfdbf3yXExeApzhL
         kATQtFkwTidnmp8S4tHYuZiZyZF8YcPVZPXYliJcQcRezQM14Awfq2hOjMUL6qlg7WN8
         4QBQ==
X-Gm-Message-State: AOAM533YuwmwlrCXKPWrvufW3Wp2eLslGM8CHiRKNB3tX7jI794BmcoO
        2w4deTaEN78pDONt0wHVc6Uwu7G6QUj1hA==
X-Google-Smtp-Source: ABdhPJwOZfFit+AT0l6e1qbWQgvEIM8ODEaYRf1WiH346J1dOE4byCMS5JgXaTTKHUOsffTyxuaCWA==
X-Received: by 2002:a05:600c:290:: with SMTP id 16mr18808133wmk.162.1623097198544;
        Mon, 07 Jun 2021 13:19:58 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id l13sm16577916wrv.57.2021.06.07.13.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 13:19:57 -0700 (PDT)
Date:   Mon, 7 Jun 2021 21:19:55 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     anand.jain@oracle.com, dsterba@suse.com, fdmanana@suse.com,
        lists@colorremedies.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: fix unmountable seed device after
 fstrim" failed to apply to 5.10-stable tree
Message-ID: <YL5/a+ngsCX28uPz@debian>
References: <1620999891925@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="C+wYWoRybnAwGCq0"
Content-Disposition: inline
In-Reply-To: <1620999891925@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--C+wYWoRybnAwGCq0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Fri, May 14, 2021 at 03:44:51PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backported patch, will also apply to all branches till 4.19-stable.

--
Regards
Sudip

--C+wYWoRybnAwGCq0
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-btrfs-fix-unmountable-seed-device-after-fstrim.patch"

From d63881edde43fe93d7e5adb36dac46e1075eb386 Mon Sep 17 00:00:00 2001
From: Anand Jain <anand.jain@oracle.com>
Date: Fri, 30 Apr 2021 19:59:51 +0800
Subject: [PATCH] btrfs: fix unmountable seed device after fstrim

commit 5e753a817b2d5991dfe8a801b7b1e8e79a1c5a20 upstream.

The following test case reproduces an issue of wrongly freeing in-use
blocks on the readonly seed device when fstrim is called on the rw sprout
device. As shown below.

Create a seed device and add a sprout device to it:

  $ mkfs.btrfs -fq -dsingle -msingle /dev/loop0
  $ btrfstune -S 1 /dev/loop0
  $ mount /dev/loop0 /btrfs
  $ btrfs dev add -f /dev/loop1 /btrfs
  BTRFS info (device loop0): relocating block group 290455552 flags system
  BTRFS info (device loop0): relocating block group 1048576 flags system
  BTRFS info (device loop0): disk added /dev/loop1
  $ umount /btrfs

Mount the sprout device and run fstrim:

  $ mount /dev/loop1 /btrfs
  $ fstrim /btrfs
  $ umount /btrfs

Now try to mount the seed device, and it fails:

  $ mount /dev/loop0 /btrfs
  mount: /btrfs: wrong fs type, bad option, bad superblock on /dev/loop0, missing codepage or helper program, or other error.

Block 5292032 is missing on the readonly seed device:

 $ dmesg -kt | tail
 <snip>
 BTRFS error (device loop0): bad tree block start, want 5292032 have 0
 BTRFS warning (device loop0): couldn't read-tree root
 BTRFS error (device loop0): open_ctree failed

From the dump-tree of the seed device (taken before the fstrim). Block
5292032 belonged to the block group starting at 5242880:

  $ btrfs inspect dump-tree -e /dev/loop0 | grep -A1 BLOCK_GROUP
  <snip>
  item 3 key (5242880 BLOCK_GROUP_ITEM 8388608) itemoff 16169 itemsize 24
  	block group used 114688 chunk_objectid 256 flags METADATA
  <snip>

From the dump-tree of the sprout device (taken before the fstrim).
fstrim used block-group 5242880 to find the related free space to free:

  $ btrfs inspect dump-tree -e /dev/loop1 | grep -A1 BLOCK_GROUP
  <snip>
  item 1 key (5242880 BLOCK_GROUP_ITEM 8388608) itemoff 16226 itemsize 24
  	block group used 32768 chunk_objectid 256 flags METADATA
  <snip>

BPF kernel tracing the fstrim command finds the missing block 5292032
within the range of the discarded blocks as below:

  kprobe:btrfs_discard_extent {
  	printf("freeing start %llu end %llu num_bytes %llu:\n",
  		arg1, arg1+arg2, arg2);
  }

  freeing start 5259264 end 5406720 num_bytes 147456
  <snip>

Fix this by avoiding the discard command to the readonly seed device.

Reported-by: Chris Murphy <lists@colorremedies.com>
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/btrfs/extent-tree.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 51c18da4792e..8d6134f220e8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1297,16 +1297,20 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 		for (i = 0; i < bbio->num_stripes; i++, stripe++) {
 			u64 bytes;
 			struct request_queue *req_q;
+			struct btrfs_device *device = stripe->dev;
 
-			if (!stripe->dev->bdev) {
+			if (!device->bdev) {
 				ASSERT(btrfs_test_opt(fs_info, DEGRADED));
 				continue;
 			}
-			req_q = bdev_get_queue(stripe->dev->bdev);
+			req_q = bdev_get_queue(device->bdev);
 			if (!blk_queue_discard(req_q))
 				continue;
 
-			ret = btrfs_issue_discard(stripe->dev->bdev,
+			if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
+				continue;
+
+			ret = btrfs_issue_discard(device->bdev,
 						  stripe->physical,
 						  stripe->length,
 						  &bytes);
-- 
2.30.2


--C+wYWoRybnAwGCq0--
