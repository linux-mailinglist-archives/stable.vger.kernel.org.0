Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9481018F6E6
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 15:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgCWO22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 10:28:28 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42341 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725991AbgCWO22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 10:28:28 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 728EF5C0236;
        Mon, 23 Mar 2020 10:28:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 23 Mar 2020 10:28:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=E/UYTd
        AucnsbtIdkfveN6/gJ5GdXxcgbVuO53GsfhNg=; b=B1sDoKiyVffaYC268gOoEj
        FH9lyCj0zOJ2Ks9cqnxYNLVgECDkIIE96VQ6cAYSPbLyKr3xKgZWSmYePhMbrR1n
        dYEgpJK+efJpuWlEIzxAPW6DTogxqpcP9oCxY73+/oQStM/rs93IAefv0cRvTKov
        U43gCBzmN2g2LiysNAwm0yBoXemrPm2I+aPSq7LgvPj4Bc5EhVkmLqGkJuB+9CB/
        XHn25mH3oR9X6NxXtua4HZYsavOZPAj143XcCb3AYuDYk+WUB0Syw1VZVaK0Cjda
        jH/FXJuroEXEwc4GHV4V1Qxqvtqth58KXOT2PzU1vY4Cwh45F6th9BQYzoR2Hxsg
        ==
X-ME-Sender: <xms:i8d4Xnb5CBt_nbv_Zmce55oCA8h_vjfapzITGu-5i8C_ZIX5sffErg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudegkedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedune
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:i8d4XtcHTGEyyd1Oozr7tAihp-CVh3KMdXP61J78qaEinMgfYktcpg>
    <xmx:i8d4Xh_J07cIcncu6gvnE7fvMGQP6ZMMKlYvPvQg1huRoXzoFuTRQA>
    <xmx:i8d4XvWI0lbOPy5UbaZXHPgQEsS6bNvnLl6eRWByqov8ndrFnH7O3w>
    <xmx:i8d4Xlkv7Hocz_4KeFb0JXv9xt00VJWfV3pCNjUscSLM3CtvMAOQ7w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1F2DD328005E;
        Mon, 23 Mar 2020 10:28:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] CIFS: Increment num_remote_opens stats counter even in case" failed to apply to 5.4-stable tree
To:     nspmangalore@gmail.com, aaptel@suse.com, pshilov@microsoft.com,
        stable@vger.kernel.org, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Mar 2020 15:28:17 +0100
Message-ID: <1584973697134113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 1be1fa42ebb73ad8fd67d2c846931361b4e3dd0a Mon Sep 17 00:00:00 2001
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 9 Mar 2020 01:35:09 -0700
Subject: [PATCH] CIFS: Increment num_remote_opens stats counter even in case
 of smb2_query_dir_first

The num_remote_opens counter keeps track of the number of open files which must be
maintained by the server at any point. This is a per-tree-connect counter, and the value
of this counter gets displayed in the /proc/fs/cifs/Stats output as a following...

Open files: 0 total (local), 1 open on server
                             ^^^^^^^^^^^^^^^^
As a thumb-rule, we want to increment this counter for each open/create that we
successfully execute on the server. Similarly, we should decrement the counter when
we successfully execute a close.

In this case, an increment was being missed in case of smb2_query_dir_first,
in case of successful open. As a result, we would underflow the counter and we
could even see the counter go to negative after sufficient smb2_query_dir_first calls.

I tested the stats counter for a bunch of filesystem operations with the fix.
And it looks like the counter looks correct to me.

I also check if we missed the increments and decrements elsewhere. It does not
seem so. Few other cases where an open is done and we don't increment the counter are
the compound calls where the corresponding close is also sent in the request.

Signed-off-by: Shyam Prasad N <nspmangalore@gmail.com>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c31e84ee3c39..3dddd20c5e2b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2222,6 +2222,8 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 		goto qdf_free;
 	}
 
+	atomic_inc(&tcon->num_remote_opens);
+
 	qd_rsp = (struct smb2_query_directory_rsp *)rsp_iov[1].iov_base;
 	if (qd_rsp->sync_hdr.Status == STATUS_NO_MORE_FILES) {
 		trace_smb3_query_dir_done(xid, fid->persistent_fid,

