Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2B939F851
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 16:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhFHOCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 10:02:50 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:40809 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232675AbhFHOCt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 10:02:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 83DC61C03;
        Tue,  8 Jun 2021 10:00:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Jun 2021 10:00:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=4ydlX/
        hmGBaRsGaaYbZO8pwWAOYhQ4rT2cHt6lyEsq0=; b=TnCoOZawURZByrB2dCnBTY
        4dG2E5b2qEmwz6Z9wf64Y1/mmjeydtBnDwiK1cxLydYC4fClpd+egNlDoKTZs0F9
        8jS8NAtEOQIsUZYQEPDxYt2tsDilpIODnueDQZ+cTF3qt00zj2icjfbz4vqpgKGl
        06OuOuH/X6h+RMkp40C9SPIJAnMjdFmttmRUxYQe/NAHtDTkl1H2EgnSRkP8Qe+3
        WAm+L4NImD5v99P7Kz51SCVChW68g6U7NQfkCYmNbUR7ZOc00RM783M8L+3tpGSA
        t8ZUg/m8uaSF+kou8CdgJFGIN+CpcFBbfRPqqWIUFDqursmCpjkTXk6FA2grUG4Q
        ==
X-ME-Sender: <xms:F3i_YOC0YVIv_S6N2p0ky00D_FdnMiKhtw8UN52ErHKE_MRLC4nSPg>
    <xme:F3i_YIhfkSID61hcDytOZndaMmhVVsBWpr5o5MXn58EaIo95VTdNdFZH5h7zxc7rY
    CF0U9GdCywSXA>
X-ME-Received: <xmr:F3i_YBk1ekwDWxpx8xY2_NN-ThlwxXIABkNpnmjKu1j9KfOIcS1RmuTaMfcvJ2zC4E4ynmbSjIWeaRsQSq0BUc3r0XvuIghh>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:F3i_YMx9rEFA5PxI37I5DSgoIPlU6aVUdfMwiewj47hOE2Y8p2qyWg>
    <xmx:F3i_YDScyguJQZOyxOzJ_75acbH1MIOstsu6RdX3RmyIs7RfPNOKgQ>
    <xmx:F3i_YHbWcabuuD5bSl_Xus42bCfQYuGwrPdiCbjztOwPVqz1aIN8ww>
    <xmx:GHi_YNdUllcbv5E3uAL1llbyZbZm1Wsxvhz2bjA3HMFDXN82r4JZNDsyMyw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 10:00:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: check error value from btrfs_update_inode in tree log" failed to apply to 4.14-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 16:00:45 +0200
Message-ID: <1623160845204201@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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
 

