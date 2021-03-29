Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B915A34C2FC
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 07:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbhC2FXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 01:23:01 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:54431 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229502AbhC2FW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 01:22:28 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 2598C128C;
        Mon, 29 Mar 2021 01:22:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 29 Mar 2021 01:22:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=JbQEun
        wQMKlZWfXa0rBsBywbn36gTk5lgay5M1XxwoI=; b=GsMZGdd3fZZzhykf7gFlgF
        zD45ScOs1JIWTvlOIlRGjFbhIOeKHNnSnhGsNXM68IqOfkYpFU7FT7cD17rk75qB
        UKdseMrTrmpp7YnP8Jrk9Kx8qmL6eXtG33UkUgPEXJYbbrPooh+WwEk4/y2p8go0
        q/Az3RPNqD4TJhjJl1t/heN9ZNEVOgin6WxEERtUFEMceNKF0hdPwhSEMjTTZXbX
        jvqDcqT8UES0dPm5iyI7V9TmmKBi4AmEE1DSyC+Jfe+2v+Y540kqMr9F0fsMltpZ
        7bOlCCxxkEzjAqDBwi3D0n5xZHO5p/n+tj0q2BAZEVBPTjLpDihTvWqUHLZc5Aog
        ==
X-ME-Sender: <xms:EmRhYN5paYIRSpo5EIIMruu1BSesl37ikMbaGFna7bKkAw299OZxqQ>
    <xme:EmRhYK6jnaDD4AltEGCdDaYIRiPlKtBxPDTG_f4qpN0V2BM9aPBIckrPdxqiISTqC
    gu6khW40e7Aow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehjedgleefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:EmRhYEdd9cMZ2-dVAyJVL6b7U9Qx_tz2K1oCgbRxyl4i07jbAiZIWQ>
    <xmx:EmRhYGLtnbXVru0Uxu7V7stoo-O3CrnD2NyLdBhfK0-P4N114f0Ksw>
    <xmx:EmRhYBLjH0b_96SPAmqaoUnP6ot5EVz_e3mkoTta-UvN1nOLYvh5oA>
    <xmx:EmRhYEle5cbs4d0U-5tQRP42SkH1sN93GGXqyxW1V76Dbcxs0mk5XVdIVEk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 67E3A24005A;
        Mon, 29 Mar 2021 01:22:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] smb3: fix cached file size problems in duplicate extents" failed to apply to 4.4-stable tree
To:     stfrench@microsoft.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Mar 2021 07:22:16 +0200
Message-ID: <16169953364068@kroah.com>
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

From cfc63fc8126a93cbf95379bc4cad79a7b15b6ece Mon Sep 17 00:00:00 2001
From: Steve French <stfrench@microsoft.com>
Date: Fri, 26 Mar 2021 18:41:55 -0500
Subject: [PATCH] smb3: fix cached file size problems in duplicate extents
 (reflink)

There were two problems (one of which could cause data corruption)
that were noticed with duplicate extents (ie reflink)
when debugging why various xfstests were being incorrectly skipped
(e.g. generic/138, generic/140, generic/142). First, we were not
updating the file size locally in the cache when extending a
file due to reflink (it would refresh after actimeo expires)
but xfstest was checking the size immediately which was still
0 so caused the test to be skipped.  Second, we were setting
the target file size (which could shrink the file) in all cases
to the end of the reflinked range rather than only setting the
target file size when reflink would extend the file.

CC: <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 3e94f83897e9..f703204fb185 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2038,6 +2038,7 @@ smb2_duplicate_extents(const unsigned int xid,
 {
 	int rc;
 	unsigned int ret_data_len;
+	struct inode *inode;
 	struct duplicate_extents_to_file dup_ext_buf;
 	struct cifs_tcon *tcon = tlink_tcon(trgtfile->tlink);
 
@@ -2054,10 +2055,21 @@ smb2_duplicate_extents(const unsigned int xid,
 	cifs_dbg(FYI, "Duplicate extents: src off %lld dst off %lld len %lld\n",
 		src_off, dest_off, len);
 
-	rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
-	if (rc)
-		goto duplicate_extents_out;
+	inode = d_inode(trgtfile->dentry);
+	if (inode->i_size < dest_off + len) {
+		rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
+		if (rc)
+			goto duplicate_extents_out;
 
+		/*
+		 * Although also could set plausible allocation size (i_blocks)
+		 * here in addition to setting the file size, in reflink
+		 * it is likely that the target file is sparse. Its allocation
+		 * size will be queried on next revalidate, but it is important
+		 * to make sure that file's cached size is updated immediately
+		 */
+		cifs_setsize(inode, dest_off + len);
+	}
 	rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
 			trgtfile->fid.volatile_fid,
 			FSCTL_DUPLICATE_EXTENTS_TO_FILE,

