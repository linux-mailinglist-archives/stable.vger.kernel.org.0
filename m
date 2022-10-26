Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C489660DFDF
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 13:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbiJZLnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 07:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbiJZLm4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 07:42:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F0C4C025;
        Wed, 26 Oct 2022 04:40:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FB2E61E52;
        Wed, 26 Oct 2022 11:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EEADC433C1;
        Wed, 26 Oct 2022 11:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666784406;
        bh=ZwOtTUEAkUYrJCN5/CWx5IIUAuCaF7JzAE/G//flO5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PS7984wncmsOTkzF9AYt2BK1CoKduGWKL7hl28KW6D/JSOoqR7Csof3BdWCBjRvqD
         ohXe6GVomH8GsLHgr0Bkb6zKCOy/mtHTom1afQgJpV18AvYlZ0Ga5FmR7nG8at+mDF
         /aA3rRGl9LFsjlTj/wAdSb83GV/Hwvx2fB6UhLR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.0.5
Date:   Wed, 26 Oct 2022 13:39:55 +0200
Message-Id: <1666784315230246@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <166678431512192@kroah.com>
References: <166678431512192@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index f2e41dccdd89..62a7398c8d06 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 0
-SUBLEVEL = 4
+SUBLEVEL = 5
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index f7405a58877e..73303458e886 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -1166,6 +1166,7 @@ static struct tegra_clk_init_table init_table[] __initdata = {
 	{ TEGRA114_CLK_I2S3_SYNC, TEGRA114_CLK_CLK_MAX, 24000000, 0 },
 	{ TEGRA114_CLK_I2S4_SYNC, TEGRA114_CLK_CLK_MAX, 24000000, 0 },
 	{ TEGRA114_CLK_VIMCLK_SYNC, TEGRA114_CLK_CLK_MAX, 24000000, 0 },
+	{ TEGRA114_CLK_PWM, TEGRA114_CLK_PLL_P, 408000000, 0 },
 	/* must be the last entry */
 	{ TEGRA114_CLK_CLK_MAX, TEGRA114_CLK_CLK_MAX, 0, 0 },
 };
diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 934520aab6e3..7628cc470a27 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -1330,6 +1330,7 @@ static struct tegra_clk_init_table common_init_table[] __initdata = {
 	{ TEGRA124_CLK_I2S3_SYNC, TEGRA124_CLK_CLK_MAX, 24576000, 0 },
 	{ TEGRA124_CLK_I2S4_SYNC, TEGRA124_CLK_CLK_MAX, 24576000, 0 },
 	{ TEGRA124_CLK_VIMCLK_SYNC, TEGRA124_CLK_CLK_MAX, 24576000, 0 },
+	{ TEGRA124_CLK_PWM, TEGRA124_CLK_PLL_P, 408000000, 0 },
 	/* must be the last entry */
 	{ TEGRA124_CLK_CLK_MAX, TEGRA124_CLK_CLK_MAX, 0, 0 },
 };
diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index 8a4514f6d503..422d78247553 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -1044,6 +1044,7 @@ static struct tegra_clk_init_table init_table[] = {
 	{ TEGRA20_CLK_GR2D, TEGRA20_CLK_PLL_C, 300000000, 0 },
 	{ TEGRA20_CLK_GR3D, TEGRA20_CLK_PLL_C, 300000000, 0 },
 	{ TEGRA20_CLK_VDE, TEGRA20_CLK_PLL_C, 300000000, 0 },
+	{ TEGRA20_CLK_PWM, TEGRA20_CLK_PLL_P, 48000000, 0 },
 	/* must be the last entry */
 	{ TEGRA20_CLK_CLK_MAX, TEGRA20_CLK_CLK_MAX, 0, 0 },
 };
diff --git a/drivers/clk/tegra/clk-tegra210.c b/drivers/clk/tegra/clk-tegra210.c
index 499f999e91e1..a3488aaac3f7 100644
--- a/drivers/clk/tegra/clk-tegra210.c
+++ b/drivers/clk/tegra/clk-tegra210.c
@@ -3597,6 +3597,7 @@ static struct tegra_clk_init_table init_table[] __initdata = {
 	{ TEGRA210_CLK_VIMCLK_SYNC, TEGRA210_CLK_CLK_MAX, 24576000, 0 },
 	{ TEGRA210_CLK_HDA, TEGRA210_CLK_PLL_P, 51000000, 0 },
 	{ TEGRA210_CLK_HDA2CODEC_2X, TEGRA210_CLK_PLL_P, 48000000, 0 },
+	{ TEGRA210_CLK_PWM, TEGRA210_CLK_PLL_P, 48000000, 0 },
 	/* This MUST be the last entry. */
 	{ TEGRA210_CLK_CLK_MAX, TEGRA210_CLK_CLK_MAX, 0, 0 },
 };
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index 04b496123820..98ec1a50e854 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1237,6 +1237,7 @@ static struct tegra_clk_init_table init_table[] = {
 	{ TEGRA30_CLK_VIMCLK_SYNC, TEGRA30_CLK_CLK_MAX, 24000000, 0 },
 	{ TEGRA30_CLK_HDA, TEGRA30_CLK_PLL_P, 102000000, 0 },
 	{ TEGRA30_CLK_HDA2CODEC_2X, TEGRA30_CLK_PLL_P, 48000000, 0 },
+	{ TEGRA30_CLK_PWM, TEGRA30_CLK_PLL_P, 48000000, 0 },
 	/* must be the last entry */
 	{ TEGRA30_CLK_CLK_MAX, TEGRA30_CLK_CLK_MAX, 0, 0 },
 };
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 015b0440df5d..85404c62a1c2 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -48,25 +48,6 @@ static void bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
 			      struct btrfs_free_space *info, u64 offset,
 			      u64 bytes, bool update_stats);
 
-static void __btrfs_remove_free_space_cache_locked(
-				struct btrfs_free_space_ctl *ctl)
-{
-	struct btrfs_free_space *info;
-	struct rb_node *node;
-
-	while ((node = rb_last(&ctl->free_space_offset)) != NULL) {
-		info = rb_entry(node, struct btrfs_free_space, offset_index);
-		if (!info->bitmap) {
-			unlink_free_space(ctl, info, true);
-			kmem_cache_free(btrfs_free_space_cachep, info);
-		} else {
-			free_bitmap(ctl, info);
-		}
-
-		cond_resched_lock(&ctl->tree_lock);
-	}
-}
-
 static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
 					       struct btrfs_path *path,
 					       u64 offset)
@@ -900,14 +881,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 	return ret;
 free_cache:
 	io_ctl_drop_pages(&io_ctl);
-
-	/*
-	 * We need to call the _locked variant so we don't try to update the
-	 * discard counters.
-	 */
-	spin_lock(&ctl->tree_lock);
-	__btrfs_remove_free_space_cache_locked(ctl);
-	spin_unlock(&ctl->tree_lock);
+	__btrfs_remove_free_space_cache(ctl);
 	goto out;
 }
 
@@ -1033,13 +1007,7 @@ int load_free_space_cache(struct btrfs_block_group *block_group)
 		if (ret == 0)
 			ret = 1;
 	} else {
-		/*
-		 * We need to call the _locked variant so we don't try to update
-		 * the discard counters.
-		 */
-		spin_lock(&tmp_ctl.tree_lock);
 		__btrfs_remove_free_space_cache(&tmp_ctl);
-		spin_unlock(&tmp_ctl.tree_lock);
 		btrfs_warn(fs_info,
 			   "block group %llu has wrong amount of free space",
 			   block_group->start);
@@ -3002,6 +2970,25 @@ static void __btrfs_return_cluster_to_free_space(
 	btrfs_put_block_group(block_group);
 }
 
+static void __btrfs_remove_free_space_cache_locked(
+				struct btrfs_free_space_ctl *ctl)
+{
+	struct btrfs_free_space *info;
+	struct rb_node *node;
+
+	while ((node = rb_last(&ctl->free_space_offset)) != NULL) {
+		info = rb_entry(node, struct btrfs_free_space, offset_index);
+		if (!info->bitmap) {
+			unlink_free_space(ctl, info, true);
+			kmem_cache_free(btrfs_free_space_cachep, info);
+		} else {
+			free_bitmap(ctl, info);
+		}
+
+		cond_resched_lock(&ctl->tree_lock);
+	}
+}
+
 void __btrfs_remove_free_space_cache(struct btrfs_free_space_ctl *ctl)
 {
 	spin_lock(&ctl->tree_lock);
