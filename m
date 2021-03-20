Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80425342C3A
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbhCTLdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:33:01 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:43715 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229585AbhCTLcz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 07:32:55 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4F6F21940722;
        Sat, 20 Mar 2021 07:32:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 20 Mar 2021 07:32:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=//UBHC
        qyojW7wFLZqIm577qQ1n0eX7J+k0uUNkGoFNI=; b=OyYyRLHgYoD4GkjEW5EB8Y
        S2XG/29H7CLn4ZcIJm89wa1sH5DrzaQ8Q4tNdjlEILAiCrgOEsTJh4Q5DC+0klwi
        5dE0wZCdRmwqXtfvd+mFny7b9cjvugq5w3hdC3MjbeqMuvb3AzNM82g9ZghT2QjH
        MFY5oSuP/98XzUDedBbScRZ+bTK82idYL12M12yVEdS6LS+dmfPJedlwXewqycFO
        JS4qnLcT3c25PEM7HzAci2iA/awP84+ZFFQzb83tBKiSD5UpGPxH3dOHTESlQhv9
        gFab86h5jMbHym3YUo76C3DjhXgIFid2gMMlaDlCDZbHRQeK7UkhGjU97wows2Bg
        ==
X-ME-Sender: <xms:Z91VYLmtlqWNO_Phbwa80U0HJzoqcAyrYIv4OFwtRya__w_wobIHBw>
    <xme:Z91VYO1Jvr2Nw_7NjiM30gqJmbu-JkqBMCCOORL8UjoO9XP_WlqZcr5zUaO6_pBoZ
    MSFM8gQWEpdgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegtddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:Z91VYBrATGRqhbo5W4mKFWmOa5KGw8JERllV-rdq5f-FNGaqymXxmg>
    <xmx:Z91VYDmTIJKridppaRbSKqQOWoG7I3q5IC019Xd866IU9ZVxZAIYcA>
    <xmx:Z91VYJ2p895LAsJJgDrMrTQcHbtdxGzp_PP--QUQ6KK6G51FDO_KMA>
    <xmx:Z91VYHBtPdcKlViBpmjcy6wVAcGm_74GxmoFWhR8KKPZoeoZMNbm2Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CF1FF1080057;
        Sat, 20 Mar 2021 07:32:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix qgroup data rsv leak caused by falloc failure" failed to apply to 5.10-stable tree
To:     wqu@suse.com, dsterba@suse.com, dsterba@suse.cz, nborisov@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 20 Mar 2021 12:32:52 +0100
Message-ID: <1616239972232227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a3ee79bd8fe17812d2305ccc4bf81bfeab395576 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Wed, 3 Mar 2021 18:41:52 +0800
Subject: [PATCH] btrfs: fix qgroup data rsv leak caused by falloc failure

[BUG]
When running fsstress with only falloc workload, and a very low qgroup
limit set, we can get qgroup data rsv leak at unmount time.

 BTRFS warning (device dm-0): qgroup 0/5 has unreleased space, type 0 rsv 20480
 BTRFS error (device dm-0): qgroup reserved space leaked

The minimal reproducer looks like:

  #!/bin/bash
  dev=/dev/test/test
  mnt="/mnt/btrfs"
  fsstress=~/xfstests-dev/ltp/fsstress
  runtime=8

  workload()
  {
          umount $dev &> /dev/null
          umount $mnt &> /dev/null
          mkfs.btrfs -f $dev > /dev/null
          mount $dev $mnt

          btrfs quota en $mnt
          btrfs quota rescan -w $mnt
          btrfs qgroup limit 16m 0/5 $mnt

          $fsstress -w -z -f creat=10 -f fallocate=10 -p 2 -n 100 \
  		-d $mnt -v > /tmp/fsstress

          umount $mnt
          if dmesg | grep leak ; then
		echo "!!! FAILED !!!"
  		exit 1
          fi
  }

  for (( i=0; i < $runtime; i++)); do
          echo "=== $i/$runtime==="
          workload
  done

Normally it would fail before round 4.

[CAUSE]
In function insert_prealloc_file_extent(), we first call
btrfs_qgroup_release_data() to know how many bytes are reserved for
qgroup data rsv.

Then use that @qgroup_released number to continue our work.

But after we call btrfs_qgroup_release_data(), we should either queue
@qgroup_released to delayed ref or free them manually in error path.

Unfortunately, we lack the error handling to free the released bytes,
leaking qgroup data rsv.

All the error handling function outside won't help at all, as we have
released the range, meaning in inode io tree, the EXTENT_QGROUP_RESERVED
bit is already cleared, thus all btrfs_qgroup_free_data() call won't
free any data rsv.

[FIX]
Add free_qgroup tag to manually free the released qgroup data rsv.

Reported-by: Nikolay Borisov <nborisov@suse.com>
Reported-by: David Sterba <dsterba@suse.cz>
Fixes: 9729f10a608f ("btrfs: inode: move qgroup reserved space release to the callers of insert_reserved_file_extent()")
CC: stable@vger.kernel.org # 5.10+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 77182be403c5..ea5ede619220 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9895,7 +9895,7 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 						  file_offset, &stack_fi,
 						  true, qgroup_released);
 		if (ret)
-			return ERR_PTR(ret);
+			goto free_qgroup;
 		return trans;
 	}
 
@@ -9910,17 +9910,31 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	extent_info.insertions = 0;
 
 	path = btrfs_alloc_path();
-	if (!path)
-		return ERR_PTR(-ENOMEM);
+	if (!path) {
+		ret = -ENOMEM;
+		goto free_qgroup;
+	}
 
 	ret = btrfs_replace_file_extents(&inode->vfs_inode, path, file_offset,
 				     file_offset + len - 1, &extent_info,
 				     &trans);
 	btrfs_free_path(path);
 	if (ret)
-		return ERR_PTR(ret);
-
+		goto free_qgroup;
 	return trans;
+
+free_qgroup:
+	/*
+	 * We have released qgroup data range at the beginning of the function,
+	 * and normally qgroup_released bytes will be freed when committing
+	 * transaction.
+	 * But if we error out early, we have to free what we have released
+	 * or we leak qgroup data reservation.
+	 */
+	btrfs_qgroup_free_refroot(inode->root->fs_info,
+			inode->root->root_key.objectid, qgroup_released,
+			BTRFS_QGROUP_RSV_DATA);
+	return ERR_PTR(ret);
 }
 
 static int __btrfs_prealloc_file_range(struct inode *inode, int mode,

