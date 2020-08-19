Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21092249BFC
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgHSLjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:39:44 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:53787 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727930AbgHSLjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 07:39:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2AA6E1942299;
        Wed, 19 Aug 2020 07:39:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:39:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=k+IDun
        dtbsSGJJWJNrrSU+lM6IWmcAM8Vr2VQoFKngM=; b=Ady7+yJWZ/VcYds/BLfCAH
        Qt0C24tVrwI2Mr/qCsGCaGjdJQJD8hEqB5fkneUE02MlrO4qyy9btKuiHrge8kc0
        hq098DgRunOKCibhrad1FIK4BrxliFQp1odNHnerwgt0de43XpkJTpupFy7go61d
        jjSmM+0ub7qmFvpZzsU2U4d6imsYpIIQxqVP23Icve7AKvS+2VMR2+ABPHQL8tvF
        SKeMnYrEeHdU5sVNUcJQnZjHRJD5STBozGl3buoJpI6/FiAiFcrC6c2/XUT4XN+V
        RETS3hllmesEC3XPLMql5sbxHpHnc6WT3VocJDr79IbtZw2oii+5lh6JDyNpY9Ng
        ==
X-ME-Sender: <xms:fA89XwDob7DrhECOLyD9r10eb0ipG3qxAc2B_aVpzO1aO1DVz7i7KA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:fA89XyjkC9KRV4073DOuS6ceTob3fRXgBh7WSceg2_kIiZFT_ZtVjQ>
    <xmx:fA89XzltTBqHiVeu-XVafS_CO0YH10fA2imKz-9eJ5MF131Ae52Y2Q>
    <xmx:fA89X2wjG0AvY9LCjkmrhF9gBENeyXJqm4n0VqvA13pu2mR3Eu8EwA>
    <xmx:fA89X26YOjQf7dWOulbNIxPE-mJvGB9w-YT064xeqTK87i-_OuB1_A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BFE28328005A;
        Wed, 19 Aug 2020 07:39:39 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: don't show full path of bind mounts in subvol=" failed to apply to 5.4-stable tree
To:     josef@toxicpanda.com, chris@colorremedies.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:40:03 +0200
Message-ID: <159783720314113@kroah.com>
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
 

