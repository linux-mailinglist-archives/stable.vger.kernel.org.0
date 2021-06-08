Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C2E39F857
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 16:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbhFHODC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 10:03:02 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:33645 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233148AbhFHODB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 10:03:01 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 636A21A74;
        Tue,  8 Jun 2021 10:01:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 08 Jun 2021 10:01:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=QptLg2
        /ZuLyJdzKHHXV7MvN4EAuUnMoAbnRwxSVdJ8M=; b=UNt/mvT+em86emV7e/jBNg
        InjCnPd7PVi2vnIkuECWf4+r07qhejQoWq/5KZTPDabYeabfrlE3k2xxYTIGqlbZ
        1bTxcRopTLpKyxfkaXFuxrAm3Jn23JyCGel9Qcce0SLTy193auHmMN+vfcQVjSUf
        8eph/KgId/wYNJgg0HvyKR7RMZw/4rBdVxz7f4kjvF7jutPn8MYPCXSTxMdbac9L
        uvI+5XknyANmlNXw8VOXTyj3orCI0Br5FpapCN5KI8qIfl0Osn7PDOrAfhHhE4AM
        Vqj+E2sq93NccqPLXbdCXUxPXbx/oMcIOlEfID+lLX1EK9HMz4ycqbbhKpCl2xAw
        ==
X-ME-Sender: <xms:IXi_YNu-kb0nxZIMLNgjhtssfuPGTcvmr3h_x132QQD4ba1LQzaY5w>
    <xme:IXi_YGchYcydO0wcGsr3r2ARIRHEil1BWSBgH4f9TCuWbe-8kFVsy-rQWwTNRu991
    soDLoRREi_WXA>
X-ME-Received: <xmr:IXi_YAwbsl0I7HCfFFQWdGPrKAl6FhR3VsrF_vFMSAj4SGn3uVKfygKAeVok8VzzdPtSd3vHgNhs6TFvgNRCSgTXyCiR8cZu>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:IXi_YEO4FYWDYPpSIiGrn56JKuAovmpmpuc8Hzkz_TerUWAWIq3Pbg>
    <xmx:IXi_YN9q02GthwyU1BRMnME4TZ7_KDHHXbUVZYPikIfHHptXxJLFLQ>
    <xmx:IXi_YEV3gwGi6yeaIICO-tthv8E5r77jKliOsINWEjOHih3BQ7hTkQ>
    <xmx:Ini_YIagp9a0f-EoUq6q-SnZbiv8jXSeK-E8Fxld7-CDK4zq-VfYYl4SXeI>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 10:01:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: check error value from btrfs_update_inode in tree log" failed to apply to 4.19-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 16:00:46 +0200
Message-ID: <1623160846221239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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
 

