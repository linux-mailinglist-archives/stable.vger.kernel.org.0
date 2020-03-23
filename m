Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22AF418F6E5
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 15:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgCWO2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 10:28:20 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40169 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725991AbgCWO2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 10:28:20 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 4052E5C010E;
        Mon, 23 Mar 2020 10:28:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 23 Mar 2020 10:28:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ByNxSI
        k1eEh3VJPT5J1y6xn9uh6R9+5VP7sR+LqVyUw=; b=SRfxQ3N9jDiBxi0IW+yRJW
        enftbSQlDesH+7TOxL+0twJUTVwV1CP74zsPjA50czucgwF885u8lAYnS24OI5Lp
        z7yCqvaypLcCY+x+KEsRruhCfuNur9YYk9lvAxghNA2XEFWtxZ8KM6juyMa9+gCO
        dlSi5bJ+HXDsDrb5Rs/U0XuQ1MgxWhfR7Wq40tZH7MQbHHLQ4+j+MGu9dFZ60LDx
        j/1YiPcXh4y/ZXpN+4CRUozU5gMHDccvI/mXTCmpWtJ0dPMoW2gSbzEHoUb7NQWU
        UtymT3tcKesSWXN17Q9yhPmD0dpAoKbDujeF2f6KMKqRabfM29COqMkUNuTJZtGA
        ==
X-ME-Sender: <xms:g8d4XoLfgNCDJ_6rpzWjXJROEL0JMyaBuqMo6X5zrGST-_2xkQ2Rrw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudegkedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:g8d4XrP3-odzu0pEkPqzBABL18ljoyRbeEMSc72mNyI791f6l0PHCw>
    <xmx:g8d4XjUhiE-0pYW8cBZQfAuT0e7VPwFHzz9eA-1-U87zgoyXyM5EuA>
    <xmx:g8d4Xhk5qpbZFBbmwL7lG6NIGsnUKr1QNrQ9aQuFlzz2_XPI0q77XA>
    <xmx:g8d4Xjnz_kDimBuVekVYDL9Pdd3nKACaaz1mY9oYgqypwJ5Gr9yYfg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C409530618C1;
        Mon, 23 Mar 2020 10:28:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] CIFS: Increment num_remote_opens stats counter even in case" failed to apply to 5.5-stable tree
To:     nspmangalore@gmail.com, aaptel@suse.com, pshilov@microsoft.com,
        stable@vger.kernel.org, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Mar 2020 15:28:16 +0100
Message-ID: <1584973696312@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
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

