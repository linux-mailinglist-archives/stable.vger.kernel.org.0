Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CA724ED28
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 14:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgHWMZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 08:25:04 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:57205 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727823AbgHWMYv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 08:24:51 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 352CB1941174;
        Sun, 23 Aug 2020 08:24:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 23 Aug 2020 08:24:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8XImlG
        0tpHTwhQ0pluL1nPQbJajUAHDHjyuX7U1eN/k=; b=o/vxke8iGt0Zi3EUC41iWM
        UAnkvMTuAiuqrA434iP5VSkjWDAKo0WXaHaoQ266xUGyWusVplltwDaHUI6uN7Sk
        puCkP+vgBSSsd/tG5mYFEd1TLnaBMRY7cIIDveDbR4cJHc5ubmHeG0TJbRIvmRly
        ysVfhEGHisU17uBo5pfIlrAUUy4pSNWG5EnRF6F18yx7pUv+T7sHSUhYIFeGexoJ
        XFUOXXOd2XuCp1NWTSMVCrAkUkrzSSYP6Lku35iUEDtw/EzcOKPLHNM9vKXqQDtW
        2OJrSTs3h+M2w2tGixpjlLDPbwbU7bQtqRETeLez+8tEuPu6xBKwhMoK8Tskzthw
        ==
X-ME-Sender: <xms:EGBCX4vyZz7ZSKei1jQ2smlqVLueDvxkYHI7epgBYXdvorBNacpwEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduiedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:EGBCX1dDRWDCECBPwEO6u6pJ2yfK_qkaDmQddpVFp1TGt8uPgPlyFA>
    <xmx:EGBCXzwukrXUBgkKY4Di3uWHzaDZw6Rp7KOsGYOn-kPCq9OJTSGYUQ>
    <xmx:EGBCX7MD-5BIm6YdFkVWopdBizT0ZErs1SzW5MtU4mrXeo98MBUP6Q>
    <xmx:EGBCXxLqF6J5ywNlVfZyy42CehRkwVtIAx9GJNhMkcLiFc9trO8n2A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B4F8D30600A9;
        Sun, 23 Aug 2020 08:24:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: fix checking of directory entry validity for inline" failed to apply to 4.9-stable tree
To:     jack@suse.cz, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Aug 2020 14:24:59 +0200
Message-ID: <15981854995219@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 7303cb5bfe845f7d43cd9b2dbd37dbb266efda9b Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 31 Jul 2020 18:21:35 +0200
Subject: [PATCH] ext4: fix checking of directory entry validity for inline
 directories

ext4_search_dir() and ext4_generic_delete_entry() can be called both for
standard director blocks and for inline directories stored inside inode
or inline xattr space. For the second case we didn't call
ext4_check_dir_entry() with proper constraints that could result in
accepting corrupted directory entry as well as false positive filesystem
errors like:

EXT4-fs error (device dm-0): ext4_search_dir:1395: inode #28320400:
block 113246792: comm dockerd: bad entry in directory: directory entry too
close to block end - offset=0, inode=28320403, rec_len=32, name_len=8,
size=4096

Fix the arguments passed to ext4_check_dir_entry().

Fixes: 109ba779d6cc ("ext4: check for directory entries too close to block end")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200731162135.8080-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index cb2eb1967e73..b92571beab72 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1396,8 +1396,8 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 		    ext4_match(dir, fname, de)) {
 			/* found a match - just to be sure, do
 			 * a full check */
-			if (ext4_check_dir_entry(dir, NULL, de, bh, bh->b_data,
-						 bh->b_size, offset))
+			if (ext4_check_dir_entry(dir, NULL, de, bh, search_buf,
+						 buf_size, offset))
 				return -1;
 			*res_dir = de;
 			return 1;
@@ -2482,7 +2482,7 @@ int ext4_generic_delete_entry(handle_t *handle,
 	de = (struct ext4_dir_entry_2 *)entry_buf;
 	while (i < buf_size - csum_size) {
 		if (ext4_check_dir_entry(dir, NULL, de, bh,
-					 bh->b_data, bh->b_size, i))
+					 entry_buf, buf_size, i))
 			return -EFSCORRUPTED;
 		if (de == de_del)  {
 			if (pde)

