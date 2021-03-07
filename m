Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E354330167
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhCGNuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:50:23 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:44525 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231467AbhCGNtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:49:50 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id F05B519BE;
        Sun,  7 Mar 2021 08:49:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:49:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=JMD2pM
        ZkAEe/n7yikTuKsnO8S/pwpnWvnI/AChmzvcE=; b=nvDPgLXYHk5ITQWsiCYzsN
        cBgDyFt4lhVrWi/UIRR6SwPyfEZKFUDHlZYU2jmS22iFq67DYUPU5PZpJQyaPdeO
        9ZL4ofpwatOZM4IqUsd4QNCFoWyNZCVC33PC5NUdI3KHtBZY4nbiDkhXnsXOD9sL
        Ot6Xu0v5eGSMQjRo5ep0+/F7iVDe7dk4KQ47h1ZV4biOwlGLS5qsP5hRlEJxowmr
        hXCUMJUVRr4FdA/AtPKxAWIoh7OWyzdHmTWC52dc/FJxqmff3RwK0mBFdcwhpMHP
        b4CxCUzenYaT3qYkSaQ8I3SEL0TH1JvfI5dpCbmB5/4ACBz1ulmyk3h08BB3pc9w
        ==
X-ME-Sender: <xms:_dlEYGsBJFpXjMi4IbBCp3BBreLRbEgyjke7zhYj0eZhsqYrf0yCpA>
    <xme:_dlEYLfYNBtOLmINinSs0Nb93GZ83RBCBjSLNgPyn2oUEO_KVPVPKbNtY8JuqPMcd
    AaQSd-UNlZvVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgoufhorhhtvggutfgvtghiphdvucdlgedtmdenuc
    fjughrpefuvffhfffkgggtgfesthekredttddtlfenucfhrhhomhepoehgrhgvghhkhhes
    lhhinhhugihfohhunhgurghtihhonhdrohhrgheqnecuggftrfgrthhtvghrnhepieetve
    ehuedvhfdtgfdvieeiheehfeelveevheejudetveeuveeludejjefgteehnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepuddtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:_dlEYBwISYImMbu7aP-oVl_Y_j7ZT3EttvmWlBPGR0C14GyDCFlDug>
    <xmx:_dlEYBMIFR2lIRs10-dQetr3sjjp6aA_Iw08w1n8VzCeE7SSqcgJlg>
    <xmx:_dlEYG9G_W4x3llOR9bG17OCbe57s0GXKX9ZyCSHX8tJBLFJzlzCiw>
    <xmx:_dlEYMniz-J6yb2hOBKwU1tg2wifgLtMtxmHN7EMGhN-1qdMppz7Bo1HzGc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2183924005E;
        Sun,  7 Mar 2021 08:49:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: validate qgroup inherit for SNAP_CREATE_V2 ioctl" failed to apply to 4.4-stable tree
To:     dancarpenter@oracle.com, dan.carpenter@oracle.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:49:47 +0100
Message-ID: <1615124987190101@kroah.com>
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

From 5011c5a663b9c6d6aff3d394f11049b371199627 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dancarpenter@oracle.com>
Date: Wed, 17 Feb 2021 09:04:34 +0300
Subject: [PATCH] btrfs: validate qgroup inherit for SNAP_CREATE_V2 ioctl

The problem is we're copying "inherit" from user space but we don't
necessarily know that we're copying enough data for a 64 byte
struct.  Then the next problem is that 'inherit' has a variable size
array at the end, and we have to verify that array is the size we
expected.

Fixes: 6f72c7e20dba ("Btrfs: add qgroup inheritance")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a8c60d46d19c..1b837c08ca90 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1935,7 +1935,10 @@ static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
 	if (vol_args->flags & BTRFS_SUBVOL_RDONLY)
 		readonly = true;
 	if (vol_args->flags & BTRFS_SUBVOL_QGROUP_INHERIT) {
-		if (vol_args->size > PAGE_SIZE) {
+		u64 nums;
+
+		if (vol_args->size < sizeof(*inherit) ||
+		    vol_args->size > PAGE_SIZE) {
 			ret = -EINVAL;
 			goto free_args;
 		}
@@ -1944,6 +1947,20 @@ static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
 			ret = PTR_ERR(inherit);
 			goto free_args;
 		}
+
+		if (inherit->num_qgroups > PAGE_SIZE ||
+		    inherit->num_ref_copies > PAGE_SIZE ||
+		    inherit->num_excl_copies > PAGE_SIZE) {
+			ret = -EINVAL;
+			goto free_inherit;
+		}
+
+		nums = inherit->num_qgroups + 2 * inherit->num_ref_copies +
+		       2 * inherit->num_excl_copies;
+		if (vol_args->size != struct_size(inherit, qgroups, nums)) {
+			ret = -EINVAL;
+			goto free_inherit;
+		}
 	}
 
 	ret = __btrfs_ioctl_snap_create(file, vol_args->name, vol_args->fd,

