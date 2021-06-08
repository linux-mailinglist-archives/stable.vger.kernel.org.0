Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBBF39F855
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 16:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbhFHOC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 10:02:58 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:39751 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233148AbhFHOC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 10:02:56 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 365B42CE;
        Tue,  8 Jun 2021 10:01:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 08 Jun 2021 10:01:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=VaxquA
        DDB92MdFMM46uCiMoVbFUlQNp7jTNFpFiJTgs=; b=TfllYPp4tgl9YpwqSwRp2Q
        XMydBE6HpRYRBzNG6t1bSBdaymox/0ikEVdSGYV1qwC5Q5N7rFRfhfDj5C5uHHnl
        SMcnc9NGM/gF9kAO0j17wbnlsYaL915GqcdgBiRdKC13ylJlDcyDgCIgWxAwxaY1
        Z+V1Iim4qjSXCGx3Gip0iz8ijGS2zcXwsVX9PKihv3I0A7GJda4BRBDBhP6KwxPe
        vlVbzZvcmVE/MnbmPjCe7NXJBWMR9a0qE0LAzoMG44xSoi4o8Mi8obHCXJGjglyt
        TnmQdkIN4D1pq1QaOqr4d4vg0/kTo2aYacPzmfxrH+/hs8bhxxdxvtCNDDk1dHvQ
        ==
X-ME-Sender: <xms:Hni_YCJKNNWQBw0_d5vNIuPUzAUHF3iuwFKNTAIJfDehUTNd-NciaA>
    <xme:Hni_YKI4LN3EVdLeeBi-mYJDvkfKnngkbNRf7OF2OMOIkjzH8lMfg-qM7go1k7Zff
    ciq6BcxtmFrnA>
X-ME-Received: <xmr:Hni_YCsBbo8WPmczZMDRLFMMSQ3iZcidlCOfJAUJ3_2xsP2Ns3Ol7TiNMlLsxua_eqWHEZ0q2LBmcCH8Mfc5Hgc3MU8uIOsZ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Hni_YHaNaomRRXHrqXP0l5aTOf0qlpYSOGswkz0O1IrXzGf0l0TvyA>
    <xmx:Hni_YJYDgja4c6350iGi7jOffDgEOLnBFhrK70BTmxWtugG4B10GCg>
    <xmx:Hni_YDDnwufVDr8cuTlOXIZUvSkVEpzVVnRh7vYfyr0nq5-wuBxgJA>
    <xmx:Hni_YNECTw05YZJ1bbxTlDMvOFS97bI7rJUJLjUhHl6iP3VnvlJkfWkx80A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 10:01:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: check error value from btrfs_update_inode in tree log" failed to apply to 5.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 16:00:46 +0200
Message-ID: <162316084652237@kroah.com>
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
 

