Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB9E6ABE28
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 12:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjCFL2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 06:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjCFL2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 06:28:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890E72279F
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 03:28:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47A2BB80D70
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 11:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC05C433D2;
        Mon,  6 Mar 2023 11:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678102119;
        bh=ztd4aCUwxCj4LwwojGijIFKGIusKY6512C3PRZo2LXg=;
        h=Subject:To:Cc:From:Date:From;
        b=UdBiFrSkdoVFgMRMsUJP9BUo4gRt1Pge3QNKSjMxndNyEFEZIev5KtzyIdrIoXTr4
         yiJF2WhG5eTbS+SzmybjH5hkS62OwUjrVGDcYWn9k4ZI3+qKC4Xtsus1yi/6V3g9Hq
         P8m0Xi55SIcdE+iO2yVtFQp9DimokhSf0J82zhcw=
Subject: FAILED: patch "[PATCH] btrfs: sysfs: update fs features directory asynchronously" failed to apply to 4.19-stable tree
To:     wqu@suse.com, anand.jain@oracle.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 12:28:32 +0100
Message-ID: <167810211211536@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x b7625f461da6734a21c38ba6e7558538a116a2e3
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167810211211536@kroah.com' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

b7625f461da6 ("btrfs: sysfs: update fs features directory asynchronously")
85e79ec7b78f ("btrfs: zoned: enable metadata over-commit for non-ZNS setup")
c52cc7b7acfb ("btrfs: add a BTRFS_FS_NEED_TRANS_COMMIT flag")
7966a6b5959b ("btrfs: move fs_info::flags enum to fs.h")
fc97a410bd78 ("btrfs: move mount option definitions to fs.h")
0d3a9cf8c306 ("btrfs: convert incompat and compat flag test helpers to macros")
ec8eb376e271 ("btrfs: move BTRFS_FS_STATE* definitions and helpers to fs.h")
9b569ea0be6f ("btrfs: move the printk helpers out of ctree.h")
e118578a8df7 ("btrfs: move assert helpers out of ctree.h")
c7f13d428ea1 ("btrfs: move fs wide helpers out of ctree.h")
63a7cb130718 ("btrfs: auto enable discard=async when possible")
f1e5c6185ca1 ("btrfs: move flush related definitions to space-info.h")
4300c58f8090 ("btrfs: move btrfs on-disk definitions out of ctree.h")
d60d956eb41f ("btrfs: remove unused set/clear_pending_info helpers")
8bb808c6ad91 ("btrfs: don't print stack trace when transaction is aborted due to ENOMEM")
0e75f0054a2a ("btrfs: move fs_info forward declarations to the top of ctree.h")
2103da3b0e3a ("btrfs: move btrfs_swapfile_pin into volumes.h")
c2e79e865b87 ("btrfs: move btrfs_pinned_by_swapfile prototype into volumes.h")
43712116f8c8 ("btrfs: move btrfs_init_async_reclaim_work prototype to space-info.h")
83cf709a89fb ("btrfs: move extent state init and alloc functions to their own file")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b7625f461da6734a21c38ba6e7558538a116a2e3 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Fri, 13 Jan 2023 19:11:39 +0800
Subject: [PATCH] btrfs: sysfs: update fs features directory asynchronously

[BUG]
Since the introduction of per-fs feature sysfs interface
(/sys/fs/btrfs/<UUID>/features/), the content of that directory is never
updated.

Thus for the following case, that directory will not show the new
features like RAID56:

  # mkfs.btrfs -f $dev1 $dev2 $dev3
  # mount $dev1 $mnt
  # btrfs balance start -f -mconvert=raid5 $mnt
  # ls /sys/fs/btrfs/$uuid/features/
  extended_iref  free_space_tree  no_holes  skinny_metadata

While after unmount and mount, we got the correct features:

  # umount $mnt
  # mount $dev1 $mnt
  # ls /sys/fs/btrfs/$uuid/features/
  extended_iref  free_space_tree  no_holes  raid56 skinny_metadata

[CAUSE]
Because we never really try to update the content of per-fs features/
directory.

We had an attempt to update the features directory dynamically in commit
14e46e04958d ("btrfs: synchronize incompat feature bits with sysfs
files"), but unfortunately it get reverted in commit e410e34fad91
("Revert "btrfs: synchronize incompat feature bits with sysfs files"").
The problem in the original patch is, in the context of
btrfs_create_chunk(), we can not afford to update the sysfs group.

The exported but never utilized function, btrfs_sysfs_feature_update()
is the leftover of such attempt.  As even if we go sysfs_update_group(),
new files will need extra memory allocation, and we have no way to
specify the sysfs update to go GFP_NOFS.

[FIX]
This patch will address the old problem by doing asynchronous sysfs
update in the cleaner thread.

This involves the following changes:

- Make __btrfs_(set|clear)_fs_(incompat|compat_ro) helpers to set
  BTRFS_FS_FEATURE_CHANGED flag when needed

- Update btrfs_sysfs_feature_update() to use sysfs_update_group()
  And drop unnecessary arguments.

- Call btrfs_sysfs_feature_update() in cleaner_kthread
  If we have the BTRFS_FS_FEATURE_CHANGED flag set.

- Wake up cleaner_kthread in btrfs_commit_transaction if we have
  BTRFS_FS_FEATURE_CHANGED flag

By this, all the previously dangerous call sites like
btrfs_create_chunk() need no new changes, as above helpers would
have already set the BTRFS_FS_FEATURE_CHANGED flag.

The real work happens at cleaner_kthread, thus we pay the cost of
delaying the update to sysfs directory, but the delayed time should be
small enough that end user can not distinguish though it might get
delayed if the cleaner thread is busy with removing subvolumes or
defrag.

CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7586a8e9b718..a6f89ac1c086 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1914,6 +1914,9 @@ static int cleaner_kthread(void *arg)
 			goto sleep;
 		}
 
+		if (test_and_clear_bit(BTRFS_FS_FEATURE_CHANGED, &fs_info->flags))
+			btrfs_sysfs_feature_update(fs_info);
+
 		btrfs_run_delayed_iputs(fs_info);
 
 		again = btrfs_clean_one_deleted_snapshot(fs_info);
diff --git a/fs/btrfs/fs.c b/fs/btrfs/fs.c
index 5553e1f8afe8..31c1648bc0b4 100644
--- a/fs/btrfs/fs.c
+++ b/fs/btrfs/fs.c
@@ -24,6 +24,7 @@ void __btrfs_set_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag,
 				name, flag);
 		}
 		spin_unlock(&fs_info->super_lock);
+		set_bit(BTRFS_FS_FEATURE_CHANGED, &fs_info->flags);
 	}
 }
 
@@ -46,6 +47,7 @@ void __btrfs_clear_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag,
 				name, flag);
 		}
 		spin_unlock(&fs_info->super_lock);
+		set_bit(BTRFS_FS_FEATURE_CHANGED, &fs_info->flags);
 	}
 }
 
@@ -68,6 +70,7 @@ void __btrfs_set_fs_compat_ro(struct btrfs_fs_info *fs_info, u64 flag,
 				name, flag);
 		}
 		spin_unlock(&fs_info->super_lock);
+		set_bit(BTRFS_FS_FEATURE_CHANGED, &fs_info->flags);
 	}
 }
 
@@ -90,5 +93,6 @@ void __btrfs_clear_fs_compat_ro(struct btrfs_fs_info *fs_info, u64 flag,
 				name, flag);
 		}
 		spin_unlock(&fs_info->super_lock);
+		set_bit(BTRFS_FS_FEATURE_CHANGED, &fs_info->flags);
 	}
 }
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 37b86acfcbcf..3d8156fc8523 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -125,6 +125,12 @@ enum {
 	 */
 	BTRFS_FS_NO_OVERCOMMIT,
 
+	/*
+	 * Indicate if we have some features changed, this is mostly for
+	 * cleaner thread to update the sysfs interface.
+	 */
+	BTRFS_FS_FEATURE_CHANGED,
+
 #if BITS_PER_LONG == 32
 	/* Indicate if we have error/warn message printed on 32bit systems */
 	BTRFS_FS_32BIT_ERROR,
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 45615ce36498..108aa3876186 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -2272,36 +2272,23 @@ void btrfs_sysfs_del_one_qgroup(struct btrfs_fs_info *fs_info,
  * Change per-fs features in /sys/fs/btrfs/UUID/features to match current
  * values in superblock. Call after any changes to incompat/compat_ro flags
  */
-void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
-		u64 bit, enum btrfs_feature_set set)
+void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_fs_devices *fs_devs;
 	struct kobject *fsid_kobj;
-	u64 __maybe_unused features;
-	int __maybe_unused ret;
+	int ret;
 
 	if (!fs_info)
 		return;
 
-	/*
-	 * See 14e46e04958df74 and e410e34fad913dd, feature bit updates are not
-	 * safe when called from some contexts (eg. balance)
-	 */
-	features = get_features(fs_info, set);
-	ASSERT(bit & supported_feature_masks[set]);
-
-	fs_devs = fs_info->fs_devices;
-	fsid_kobj = &fs_devs->fsid_kobj;
-
+	fsid_kobj = &fs_info->fs_devices->fsid_kobj;
 	if (!fsid_kobj->state_initialized)
 		return;
 
-	/*
-	 * FIXME: this is too heavy to update just one value, ideally we'd like
-	 * to use sysfs_update_group but some refactoring is needed first.
-	 */
-	sysfs_remove_group(fsid_kobj, &btrfs_feature_attr_group);
-	ret = sysfs_create_group(fsid_kobj, &btrfs_feature_attr_group);
+	ret = sysfs_update_group(fsid_kobj, &btrfs_feature_attr_group);
+	if (ret < 0)
+		btrfs_warn(fs_info,
+			   "failed to update /sys/fs/btrfs/%pU/features: %d",
+			   fs_info->fs_devices->fsid, ret);
 }
 
 int __init btrfs_init_sysfs(void)
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index bacef43f7267..86c7eef12873 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -19,8 +19,7 @@ void btrfs_sysfs_remove_device(struct btrfs_device *device);
 int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs);
 void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs);
 void btrfs_sysfs_update_sprout_fsid(struct btrfs_fs_devices *fs_devices);
-void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
-		u64 bit, enum btrfs_feature_set set);
+void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info);
 void btrfs_kobject_uevent(struct block_device *bdev, enum kobject_action action);
 
 int __init btrfs_init_sysfs(void);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 528efe559866..18329ebcb1cb 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2464,6 +2464,11 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	wake_up(&fs_info->transaction_wait);
 	btrfs_trans_state_lockdep_release(fs_info, BTRFS_LOCKDEP_TRANS_UNBLOCKED);
 
+	/* If we have features changed, wake up the cleaner to update sysfs. */
+	if (test_bit(BTRFS_FS_FEATURE_CHANGED, &fs_info->flags) &&
+	    fs_info->cleaner_kthread)
+		wake_up_process(fs_info->cleaner_kthread);
+
 	ret = btrfs_write_and_wait_transaction(trans);
 	if (ret) {
 		btrfs_handle_fs_error(fs_info, ret,

