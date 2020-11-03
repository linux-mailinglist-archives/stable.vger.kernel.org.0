Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780FE2A46E0
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 14:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbgKCNwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 08:52:11 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:44235 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729459AbgKCNvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 08:51:53 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 2FC8C788;
        Tue,  3 Nov 2020 08:51:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 08:51:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=K+2Tke
        1wRn9C+s9P6zJtNHn/c1JXOukphnGUhVyxfUs=; b=q/4MIgyhWGXL0P3w/BrQrP
        xyDvLjD9RQApUI4bMTNiEyI4qheznz8YOvraqqDp5Tnt/a1jyJ3Hro0iZvveNQ7X
        G7Qx+LAqXurT1P51UC36bDaLtZlRu5sfQwBqXnXpldlzpmGH4J+NWYe2oibW18uL
        bEFqJ6LSLweQk41n/gv9cli2ZH7Pr9oNfXqnZhs7GGcm/1BDsokgAYxljih/OVG5
        8kqsqLjZaMFKMKZKNSThkVhLGZcoo6gYmYXIe8vRl27cOMr8+vgAU1gAVxqeGDbE
        yojYLGPxJ/tP4VgtDBFqrCEQv0pENLz7D8GTGKaTDnmM5K/KQorW0oZSW4WhBxWw
        ==
X-ME-Sender: <xms:d2ChX_T_bN0XPinaMdjoUaYf-1-sA8jXWuo4yROk1EeDOPsaHuw23w>
    <xme:d2ChXwxPRAqX7DSoS_RbPNIdnQ4uLiOCP18XI7tgtWm9d5IlJaB_b6LdL-I8tLc4-
    e3bD2xOrUF3dg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:d2ChX03IivyCw5LsQNU16hVPRjQHwvwF1yc7WTCAV0TXRTr4TrYfVA>
    <xmx:d2ChX_Di6-hdgsEw_kteNWK6_VSlqkxoSrewpBRP7JgviyMALbZGqQ>
    <xmx:d2ChX4gE16tNI1vII_jRfFhgSAcmpZONe9_OFsojGEou6OeUSAsKFw>
    <xmx:d2ChXwLCua6kAeLKm66Qdb0wZvZQblk1rfoWv-D_U_srv6W4BoD0Z9UugDE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7300E3280069;
        Tue,  3 Nov 2020 08:51:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: sysfs, rename device_link add/remove functions" failed to apply to 4.9-stable tree
To:     anand.jain@oracle.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 14:52:34 +0100
Message-ID: <160441155428102@kroah.com>
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

From f3cd2c58110dad14ee37cc47fd1473d90ee68ccb Mon Sep 17 00:00:00 2001
From: Anand Jain <anand.jain@oracle.com>
Date: Wed, 12 Feb 2020 17:28:13 +0800
Subject: [PATCH] btrfs: sysfs, rename device_link add/remove functions

Since commit 668e48af7a94 ("btrfs: sysfs, add devid/dev_state kobject and
device attributes"), the functions btrfs_sysfs_add_device_link() and
btrfs_sysfs_rm_device_link() do more than just adding and removing the
device link as its name indicated. Rename them to be more specific
that's about the directory with the attirbutes

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 2aad07cdaea8..db93909b25e0 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -512,7 +512,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	atomic64_set(&dev_replace->num_uncorrectable_read_errors, 0);
 	up_write(&dev_replace->rwsem);
 
-	ret = btrfs_sysfs_add_device_link(tgt_device->fs_devices, tgt_device);
+	ret = btrfs_sysfs_add_devices_dir(tgt_device->fs_devices, tgt_device);
 	if (ret)
 		btrfs_err(fs_info, "kobj add dev failed %d", ret);
 
@@ -743,7 +743,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
 	/* replace the sysfs entry */
-	btrfs_sysfs_rm_device_link(fs_info->fs_devices, src_device);
+	btrfs_sysfs_remove_devices_dir(fs_info->fs_devices, src_device);
 	btrfs_sysfs_update_devid(tgt_device);
 	btrfs_rm_dev_replace_free_srcdev(src_device);
 
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 119edd4341d6..651aa65b1f3f 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -960,7 +960,7 @@ void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
 	addrm_unknown_feature_attrs(fs_info, false);
 	sysfs_remove_group(&fs_info->fs_devices->fsid_kobj, &btrfs_feature_attr_group);
 	sysfs_remove_files(&fs_info->fs_devices->fsid_kobj, btrfs_attrs);
-	btrfs_sysfs_rm_device_link(fs_info->fs_devices, NULL);
+	btrfs_sysfs_remove_devices_dir(fs_info->fs_devices, NULL);
 }
 
 static const char * const btrfs_feature_set_names[FEAT_MAX] = {
@@ -1149,7 +1149,7 @@ int btrfs_sysfs_add_space_info_type(struct btrfs_fs_info *fs_info,
 
 /* when one_device is NULL, it removes all device links */
 
-int btrfs_sysfs_rm_device_link(struct btrfs_fs_devices *fs_devices,
+int btrfs_sysfs_remove_devices_dir(struct btrfs_fs_devices *fs_devices,
 		struct btrfs_device *one_device)
 {
 	struct hd_struct *disk;
@@ -1269,7 +1269,7 @@ static struct kobj_type devid_ktype = {
 	.release	= btrfs_release_devid_kobj,
 };
 
-int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
+int btrfs_sysfs_add_devices_dir(struct btrfs_fs_devices *fs_devices,
 				struct btrfs_device *one_device)
 {
 	int error = 0;
@@ -1395,13 +1395,13 @@ int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
 
 	btrfs_set_fs_info_ptr(fs_info);
 
-	error = btrfs_sysfs_add_device_link(fs_devs, NULL);
+	error = btrfs_sysfs_add_devices_dir(fs_devs, NULL);
 	if (error)
 		return error;
 
 	error = sysfs_create_files(fsid_kobj, btrfs_attrs);
 	if (error) {
-		btrfs_sysfs_rm_device_link(fs_devs, NULL);
+		btrfs_sysfs_remove_devices_dir(fs_devs, NULL);
 		return error;
 	}
 
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index c68582add92e..718a26c97833 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -14,9 +14,9 @@ enum btrfs_feature_set {
 
 char *btrfs_printable_features(enum btrfs_feature_set set, u64 flags);
 const char * const btrfs_feature_set_name(enum btrfs_feature_set set);
-int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
+int btrfs_sysfs_add_devices_dir(struct btrfs_fs_devices *fs_devices,
 		struct btrfs_device *one_device);
-int btrfs_sysfs_rm_device_link(struct btrfs_fs_devices *fs_devices,
+int btrfs_sysfs_remove_devices_dir(struct btrfs_fs_devices *fs_devices,
                 struct btrfs_device *one_device);
 int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs);
 void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b092021e41e9..387f80656476 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2054,7 +2054,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	if (device->bdev) {
 		cur_devices->open_devices--;
 		/* remove sysfs entry */
-		btrfs_sysfs_rm_device_link(fs_devices, device);
+		btrfs_sysfs_remove_devices_dir(fs_devices, device);
 	}
 
 	num_devices = btrfs_super_num_devices(fs_info->super_copy) - 1;
@@ -2174,7 +2174,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev)
 
 	mutex_lock(&fs_devices->device_list_mutex);
 
-	btrfs_sysfs_rm_device_link(fs_devices, tgtdev);
+	btrfs_sysfs_remove_devices_dir(fs_devices, tgtdev);
 
 	if (tgtdev->bdev)
 		fs_devices->open_devices--;
@@ -2522,7 +2522,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 				    orig_super_num_devices + 1);
 
 	/* add sysfs device entry */
-	btrfs_sysfs_add_device_link(fs_devices, device);
+	btrfs_sysfs_add_devices_dir(fs_devices, device);
 
 	/*
 	 * we've got more storage, clear any full flags on the space
@@ -2590,7 +2590,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	return ret;
 
 error_sysfs:
-	btrfs_sysfs_rm_device_link(fs_devices, device);
+	btrfs_sysfs_remove_devices_dir(fs_devices, device);
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	mutex_lock(&fs_info->chunk_mutex);
 	list_del_rcu(&device->dev_list);

