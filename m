Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9829439F852
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 16:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhFHOCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 10:02:53 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:48277 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232841AbhFHOCx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 10:02:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id 123571BDE;
        Tue,  8 Jun 2021 10:01:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 08 Jun 2021 10:01:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xC6mDV
        pdN+so13eLlKaoBunvQIygDBRqltGKReTDTyA=; b=e9HGrCEwk1PlfCoONmrDbi
        ge2ExZYhbMOm66lBa0OVz7r4dTj9OQg29BwNcwNDvjA734JZ6OujdG4AiA4f7yuU
        Q1vcTgYIvrE4q2PRQki+4V4uLlXMqeeiVN/6ocLwc28T2QTbkj8cn9E3BebyPUGX
        ojJ41tcAP6+q7QZrl6kkfOoPTNgDTDkCLhWD46tCqlOnuesC/ZHpy5Mt5YZ/TkTl
        AqNX+rdlC6q8niKnFxWk6TwxiDmVZRwLzDGLsctKhhpxOlqu5waw9mPKLp1XqcKk
        UG6GSuhvdn9Mn5ZuIEyzLJyJMhFZpbFYxvYZvkLtsnma1iZlTF3wlvMQEwpAGfpQ
        ==
X-ME-Sender: <xms:G3i_YH5exLRCX6-b3_08tmH8yzMh07p53JS_nesyw522EsPnodexuA>
    <xme:G3i_YM6LnwwxtUZmGywUtM9QzFcB1YJjiZSvY2kcQFg-KoHLo9GhqijCN1SgC1nr6
    BJgoLiyI_bEdQ>
X-ME-Received: <xmr:G3i_YOfy0TTd81rW2NEc8T9QyO0EVxbzxP5CLtm_4roxviPWV5Py2kuj3TKPl-Z5ynEyrrPRUIIeJ3Z_GyMwqdDcQdJUor0t>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:G3i_YIJid6H6kN1xbkadYMMvrIPse82mxL0wd6yhwyzX127nB6UeUw>
    <xmx:G3i_YLKBccosPvDk_KktXshcOYasn_8bvdXcqYqX5yFbOwzHlmrEbA>
    <xmx:G3i_YBzB2Jn4qdod5NVrd_9aIMdmW6ZeVDcKxk3ONbMBNld9D3d82Q>
    <xmx:G3i_YD2ulafyQc0qZX2zcc782xAX-kGwILKIRifhS5W_NaEPZL48h7qQnhc>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 10:00:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: check error value from btrfs_update_inode in tree log" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 16:00:45 +0200
Message-ID: <1623160845241239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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
 

