Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF3539F858
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 16:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbhFHODE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 10:03:04 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:36391 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233158AbhFHODD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 10:03:03 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id AF1441BFE;
        Tue,  8 Jun 2021 10:01:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 08 Jun 2021 10:01:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=NN0Ctd
        Z2lgtjVTUiHgWk9Pciq0gd/XkV8u6S3cLSJXE=; b=jIp5/rpkx9RDA3kqNC7kCF
        GCnJn06ZOwIJsILN5ZLxKt2tW55BTLZNWjbA7yNWGSY6GwpqXFqMH11PLgDXsanq
        UYLwiJQOd2yMdPnxJ1izYwGLQO8qkVDCe90hg5tULwtz58CQIuO9bYS57LPi7bFO
        V42ygyd3Um1eUaqs/VrnWuo5wnazBC827Bs0Vr6jzxhKz5y6U3xT0NqxyUV2fISG
        Usok26ZZwMfyyB1w6RYshhyBZp3iubcNRH418qSwIDIqH+sD9aoqmXPAWSWDfTHt
        Qa/wVumZBZCYFWJzdEy7wZScJi3XbAEPC4rYm9OViD4/IOYtHsZjIPeDpTG1udVQ
        ==
X-ME-Sender: <xms:JXi_YGaaQvhP7qrBYHwuvCCP4MupUi8U-yYbAaLliOXNwXMwVjHQmw>
    <xme:JXi_YJZ9EZ2US5b70jAm5M_P67riCQ2_YA7iqrGKhF1H2yZ9LrE0U2-2agr8YKo0U
    6HoAG-NPYFKTw>
X-ME-Received: <xmr:JXi_YA-V72jZfoICUXN5RdHwCfApE7PFB9_erbkr3F3Wq8YIz5VAf9f72bITfRvRSRUkjWif8sCUUx2DckWLhboUVeOcslV4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:JXi_YIpdpZ5Yl1eR0-4NAamZVBo6e4k8fwKO3kL-hPadpiroVsieAg>
    <xmx:JXi_YBqU7kE_IpYlumAOspfWpm9zO-oGEgZ5KtE5nfFRaFiE5Boy9Q>
    <xmx:JXi_YGQHgwB1S1iCzUKxWwPPx1bZ0XLiQWmaVHrDv5EfeNSExsDhDw>
    <xmx:JXi_YIV1l4X3B-QBM_HwNMd1tcy82fg7IQyZ0vkSJAYBZTL8_MUeQ-E0yic>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 10:01:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: check error value from btrfs_update_inode in tree log" failed to apply to 5.10-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 16:00:47 +0200
Message-ID: <16231608475934@kroah.com>
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

From f96d44743a44e3332f75d23d2075bb8270900e1d Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 19 May 2021 11:26:25 -0400
Subject: [PATCH] btrfs: check error value from btrfs_update_inode in tree log

Error injection testing uncovered a case where we ended up with invalid
link counts on an inode.  This happened because we failed to notice an
error when updating the inode while replaying the tree log, and
committed the transaction with an invalid file system.

Fix this by checking the return value of btrfs_update_inode.  This
resolved the link count errors I was seeing, and we already properly
handle passing up the error values in these paths.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 375c4642f480..e4820e88cba0 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1574,7 +1574,9 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 			if (ret)
 				goto out;
 
-			btrfs_update_inode(trans, root, BTRFS_I(inode));
+			ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
+			if (ret)
+				goto out;
 		}
 
 		ref_ptr = (unsigned long)(ref_ptr + ref_struct_size) + namelen;
@@ -1749,7 +1751,9 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
 
 	if (nlink != inode->i_nlink) {
 		set_nlink(inode, nlink);
-		btrfs_update_inode(trans, root, BTRFS_I(inode));
+		ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
+		if (ret)
+			goto out;
 	}
 	BTRFS_I(inode)->index_cnt = (u64)-1;
 

