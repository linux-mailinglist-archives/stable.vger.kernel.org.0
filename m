Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE58330186
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhCGN5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:57:42 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:59535 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231594AbhCGN5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:57:20 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id F12C51A78;
        Sun,  7 Mar 2021 08:57:19 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:57:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Qt33qX
        KOBRSXNrBpOgI1h8BlielDYjQCgWw0fTPhJ+c=; b=YcPPje/WRShLYO+3+UTlC9
        m50qwg7Ye7rcPpqdGhfjZ2z/TLXJueCNQkJTf+ArjPM+MqvsQXRVCKYHTRxkhmvE
        Z5XcIntuLcmhuG7ZxcZ2CvOTF17T5zxb2q1usFRqUt/PZLWSH8S/n1eXi+tnDShI
        MCfm5LPxwIxKhCO37iirvkzYtLU+CmlMcutrrwAo9ivH2IK3fmPw13rgwePZWdMb
        LekSj+Z5ngSBGtAU1SRRumLzh/ify/RSOYOg9EqyKdxz3h2dr+Q7WnBT8ChEBBUQ
        eOiZINKaJsgj5o/fhxabMYRynUBFWKk2wMpwQPow20k4PQg/7Vd4zy9jYoDlraDw
        ==
X-ME-Sender: <xms:v9tEYCZpXqW5BI-x96jpCE1pu0Bllcrb9y35PLm-zAL6O0ULZgDRkA>
    <xme:v9tEYFYFqWbIAeuRo9x3i8RJX9-PTKyzWCjo3rlGO-8oUWcnuRoaaFoXOnkImf7dV
    dj_1pL-xYHUXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgoufhorhhtvggutfgvtghiphdvucdlgedtmdenuc
    fjughrpefuvffhfffkgggtgfesthekredttddtlfenucfhrhhomhepoehgrhgvghhkhhes
    lhhinhhugihfohhunhgurghtihhonhdrohhrgheqnecuggftrfgrthhtvghrnhepieetve
    ehuedvhfdtgfdvieeiheehfeelveevheejudetveeuveeludejjefgteehnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:v9tEYM_hagfqhcyhh9i6ldl0jY4OwM_nbHeTxIQMZpLuJHk9JCaPRw>
    <xmx:v9tEYEqLGSGLwpkUXQqHy8aKgeJAjhfWykhoE78Nd0lhcbYgY2SgAQ>
    <xmx:v9tEYNqOgNs_84Q7nQb1A8OuT2Lc1yNCGlYKtMfglpiZoEEjNwwbdQ>
    <xmx:v9tEYOD11lRknPs2DsJXIrioYGJQfhCvDxOz2VtmjIrG3vsAvflQalVMg8A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 18D3A108005C;
        Sun,  7 Mar 2021 08:57:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: validate qgroup inherit for SNAP_CREATE_V2 ioctl" failed to apply to 4.9-stable tree
To:     dancarpenter@oracle.com, dan.carpenter@oracle.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:57:17 +0100
Message-ID: <161512543777174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

