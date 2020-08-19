Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC1F249BDD
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgHSLeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:34:04 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:44015 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727906AbgHSLeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 07:34:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8EED01941CC3;
        Wed, 19 Aug 2020 07:34:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:34:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=gULtqy
        PR83vDU408Qsm1nCItk3qMsO35umkGqPZQlh4=; b=auCWu54Rm3sMM3amUaj0wn
        orryY+xxUBAaDnM7jBN59xByABtl7ffsa6i7mO2XJgS0UAIzWtElnOw1+jmA0W5k
        /aTjbefWRWtjsnNc8DxBLFg8UKPg8Q9eQSjykwEO+3DmUPRBDO7XWMh68kvx1w41
        AA73uz31PcF3hHP1gW2/xPRYLKp9BoST6wOLPyWpBXv7HV92lzA+lRX5bzK+lDSm
        Mu8P7wD6qnGktqD0VB2w5Iy2TGyYV585E3Jv0TDWykWkMPgRLlDGmLf8cdSqUxp7
        7Y13ZEmVThVsJ5GxRbJbXAokSw+LFHoRWNjfF8yfK/Y5bpceZD/qbV+YVv2XlF4Q
        ==
X-ME-Sender: <xms:KA49X646vquUkjItynEbMm83o6E6yMutYUKB7da-Wn6jpDpTTd0B5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:KA49Xz5sFU2pM_9Uo6hFCheT-awxsZqBEOZddmqmT7Gzp8FfEzGbkA>
    <xmx:KA49X5ci55XHEKkMnMTVzY6DmM05i-iCW22GydFM-chuDVoZZW_IwA>
    <xmx:KA49X3LQlJbSxE-A2NZbGbLoA9MoU4VWaPr0ogPvrtNLbFXMGZ_meA>
    <xmx:KA49X4xbZ9LgWGbu8isofKsEUpm0DLx1832-IgiSCohsIV3ZGh18kA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2F63D328005A;
        Wed, 19 Aug 2020 07:34:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: don't show full path of bind mounts in subvol=" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, chris@colorremedies.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:34:22 +0200
Message-ID: <1597836862182239@kroah.com>
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

From 3ef3959b29c4a5bd65526ab310a1a18ae533172a Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 22 Jul 2020 11:12:46 -0400
Subject: [PATCH] btrfs: don't show full path of bind mounts in subvol=

Chris Murphy reported a problem where rpm ostree will bind mount a bunch
of things for whatever voodoo it's doing.  But when it does this
/proc/mounts shows something like

  /dev/sda /mnt/test btrfs rw,relatime,subvolid=256,subvol=/foo 0 0
  /dev/sda /mnt/test/baz btrfs rw,relatime,subvolid=256,subvol=/foo/bar 0 0

Despite subvolid=256 being subvol=/foo.  This is because we're just
spitting out the dentry of the mount point, which in the case of bind
mounts is the source path for the mountpoint.  Instead we should spit
out the path to the actual subvol.  Fix this by looking up the name for
the subvolid we have mounted.  With this fix the same test looks like
this

  /dev/sda /mnt/test btrfs rw,relatime,subvolid=256,subvol=/foo 0 0
  /dev/sda /mnt/test/baz btrfs rw,relatime,subvolid=256,subvol=/foo 0 0

Reported-by: Chris Murphy <chris@colorremedies.com>
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index aa73422b0678..9b4e9c4c4673 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1386,6 +1386,7 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 {
 	struct btrfs_fs_info *info = btrfs_sb(dentry->d_sb);
 	const char *compress_type;
+	const char *subvol_name;
 
 	if (btrfs_test_opt(info, DEGRADED))
 		seq_puts(seq, ",degraded");
@@ -1472,8 +1473,13 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",ref_verify");
 	seq_printf(seq, ",subvolid=%llu",
 		  BTRFS_I(d_inode(dentry))->root->root_key.objectid);
-	seq_puts(seq, ",subvol=");
-	seq_dentry(seq, dentry, " \t\n\\");
+	subvol_name = btrfs_get_subvol_name_from_objectid(info,
+			BTRFS_I(d_inode(dentry))->root->root_key.objectid);
+	if (!IS_ERR(subvol_name)) {
+		seq_puts(seq, ",subvol=");
+		seq_escape(seq, subvol_name, " \t\n\\");
+		kfree(subvol_name);
+	}
 	return 0;
 }
 

