Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A3639F83A
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 15:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhFHN7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 09:59:13 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:42123 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232109AbhFHN7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 09:59:13 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id 91980B81;
        Tue,  8 Jun 2021 09:57:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 08 Jun 2021 09:57:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tB36u/
        zuhRWRv0udZMyvKMnllNRQEgt2+EdZ52IdOaE=; b=WAf17F8Owtf0ccSyuzOiiY
        2EnI/tGxaTNX92aDLGFtrVH6DXA36LWL+hWAMeL3YUzmKEEkJr8M/JvcFyUUi2vF
        Ctdt2QozvEfH9dfj9qNDGkQDIobaC9wtGDz2NGsx3X8et5/LqjbC5RW77mLu2oxz
        BrIQCKdASSVRRh5eLDfmlaUTS7/b2lW0Powp2yyX0RyZubyg8tpYU8ZXqpSjbOBw
        YUdNZDztKz6UN9sEs2ECa8ezKktb+rPXXf4JmxNfhdh9Q7tyZ1lbE1iK80MSw6Q6
        dtYscki34eE0zeFZe0E104lHpA7e3dH7MhKeZRC+yDr/f+DN9PhjiTWzl6yPUaWQ
        ==
X-ME-Sender: <xms:Pne_YDPYxaiE4z1EnvAgRlYRveNsrh0B5qMh1GiPUPCLuRjMXuIqbA>
    <xme:Pne_YN_7dG1C3qNKqJv9OMrBWhV7hTti4doMoMh5-6K0FXI7FS4cAc7E4G-C615WH
    ptQPxWpYxeRUw>
X-ME-Received: <xmr:Pne_YCTwDUAltSjzy6aFwWfAyIs37aM6Bg0pr6vBYR9ldk-ALrRLcCZ1juKI2nIkVdPcojkcZBNJVigB_FffYq2VFogr9aRF>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Pne_YHsDw6k6zfbycK0Bg9LZ_nUtODxIoQEfgzrPbN0yaox05tLAuw>
    <xmx:Pne_YLfB0JgJy49BWe_FM1aYYfQ5-B9LnFtZyYTWGjJU5RRNOdHIXw>
    <xmx:Pne_YD2Bh2a_jOTAwfq1VXRsjFjnzVkkNJ-SUTyFiBNrlLsQ_FP45w>
    <xmx:P3e_YMqud8A_Z_pdMLrrMxuYIwkSHrjZscRaPMifXjaFkSoFXGkaQ57R2B8>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 09:57:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix error handling in btrfs_del_csums" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 15:57:15 +0200
Message-ID: <1623160635164241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b86652be7c83f70bf406bed18ecf55adb9bfb91b Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 19 May 2021 10:52:45 -0400
Subject: [PATCH] btrfs: fix error handling in btrfs_del_csums

Error injection stress would sometimes fail with checksums on disk that
did not have a corresponding extent.  This occurred because the pattern
in btrfs_del_csums was

	while (1) {
		ret = btrfs_search_slot();
		if (ret < 0)
			break;
	}
	ret = 0;
out:
	btrfs_free_path(path);
	return ret;

If we got an error from btrfs_search_slot we'd clear the error because
we were breaking instead of goto out.  Instead of using goto out, simply
handle the cases where we may leave a random value in ret, and get rid
of the

	ret = 0;
out:

pattern and simply allow break to have the proper error reporting.  With
this fix we properly abort the transaction and do not commit thinking we
successfully deleted the csum.

Reviewed-by: Qu Wenruo <wqu@suse.com>
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 294602f139ef..a5a8dac334e8 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -788,7 +788,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 	u64 end_byte = bytenr + len;
 	u64 csum_end;
 	struct extent_buffer *leaf;
-	int ret;
+	int ret = 0;
 	const u32 csum_size = fs_info->csum_size;
 	u32 blocksize_bits = fs_info->sectorsize_bits;
 
@@ -806,6 +806,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 
 		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 		if (ret > 0) {
+			ret = 0;
 			if (path->slots[0] == 0)
 				break;
 			path->slots[0]--;
@@ -862,7 +863,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 			ret = btrfs_del_items(trans, root, path,
 					      path->slots[0], del_nr);
 			if (ret)
-				goto out;
+				break;
 			if (key.offset == bytenr)
 				break;
 		} else if (key.offset < bytenr && csum_end > end_byte) {
@@ -906,8 +907,9 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 			ret = btrfs_split_item(trans, root, path, &key, offset);
 			if (ret && ret != -EAGAIN) {
 				btrfs_abort_transaction(trans, ret);
-				goto out;
+				break;
 			}
+			ret = 0;
 
 			key.offset = end_byte - 1;
 		} else {
@@ -917,8 +919,6 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 		}
 		btrfs_release_path(path);
 	}
-	ret = 0;
-out:
 	btrfs_free_path(path);
 	return ret;
 }

