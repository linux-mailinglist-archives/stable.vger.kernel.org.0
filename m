Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25B46793A8
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 10:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbjAXJHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 04:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjAXJG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 04:06:59 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133253D0BC
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 01:06:58 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id f132-20020a636a8a000000b00473d0b600ebso6697166pgc.14
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 01:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XAS1XY9FPtic2jOCrO5wFmtEy1oMe/ZuFNJje84A4r4=;
        b=nfS1gttL6488iR2Dwum7btmaKcW4aPA33yiOgmyo2XmvtBEe0N3EK3/1Ht5RI+yEi/
         fLGkNPd01pBed7J/BgPfI57LSGuAJF/VseUYsI7oTOdFSwdzSZTXBPQ6sTW5t2D0RVfJ
         WrLbV18fDs2cj0cL8ymSaVnJ+s72xdO6WYjCWfIFRWpPxti4Yal75yMEHdK3JszhdwzX
         UMS/74aA2aTqhB43ORAaNWURgHpCeYthVCGz1+J4qqHh2y7zWLYWgvn8gMAPVeaHd7Vs
         NQPcN41t2ip72jGsQbdaaQTzuaJoe19iwbWKT8mGfzsfVM2Qj2kPSBJdOmT8XUggv+R+
         yPnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XAS1XY9FPtic2jOCrO5wFmtEy1oMe/ZuFNJje84A4r4=;
        b=QrDYxcvshOIPT0vEL+iQYQ+go/zRpuU/JSGN5QecfVc72dEvmGZbk0Zd4O/A7tBMq2
         awf/2wJFl4LzF7Lj6KT+9t11iRl6UvNqnwPYPZhVFS6zv7bNksLV2ea/NZgXIE+ZRLuL
         sWh9IEIP3ecPJXt9rnrCiysFXaEY8K+yDJDHZdeI8PquR6v8fxderTTwUCFvJoKFODA4
         xj4N3PZfSCd8qo/tpkEFrwK6WFpM5NZbl6F0JcJFMqXZLyV37iVKPOP78BNhcer/ICeI
         Fl+UmpvcEJ0V1nTea/gMMT6kQr/ljftPw5J/HYo+BEJBbd8fP2UQkSPDRdYYlpd9pwXJ
         uLMQ==
X-Gm-Message-State: AFqh2kp3p7DNNa3rWwr5lVEPA4vfl/MGJOJViedcCD9LHtoLo4lXYUrs
        l+PQPK25krS5Gg8+kPSeli4JXEfTvZLMMbkccvGs0+Xnz8h5KgBbOFSXn3cQ5cvya78PUw4IZ1d
        bpTIIgf0z5Q2S2OzfU6jlis/5fUZO301KRa3mkbb8uLgMKtvDKMaA8Q==
X-Google-Smtp-Source: AMrXdXvGQuRZwQqrDEY+TuttSMkNtaZV5+959e/wTVeYbLpwXYEJQt8I/jxnYdUoX/4+/SFp8u/ugNg=
X-Received: from hmarynka.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:925])
 (user=ovt job=sendgmr) by 2002:a62:fb0f:0:b0:58b:ca3a:fb40 with SMTP id
 x15-20020a62fb0f000000b0058bca3afb40mr3534583pfm.75.1674551217559; Tue, 24
 Jan 2023 01:06:57 -0800 (PST)
Date:   Tue, 24 Jan 2023 09:06:32 +0000
In-Reply-To: <20230124090632.4185289-1-ovt@google.com>
Mime-Version: 1.0
References: <20230124090632.4185289-1-ovt@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230124090632.4185289-2-ovt@google.com>
Subject: [PATCH 5.15 1/1] ext4: fix bad checksum after online resize
From:   Oleksandr Tymoshenko <ovt@google.com>
To:     stable@vger.kernel.org
Cc:     Baokun Li <libaokun1@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
        stable@kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

commit a408f33e895e455f16cf964cb5cd4979b658db7b upstream.

When online resizing is performed twice consecutively, the error message
"Superblock checksum does not match superblock" is displayed for the
second time. Here's the reproducer:

	mkfs.ext4 -F /dev/sdb 100M
	mount /dev/sdb /tmp/test
	resize2fs /dev/sdb 5G
	resize2fs /dev/sdb 6G

To solve this issue, we moved the update of the checksum after the
es->s_overhead_clusters is updated.

Fixes: 026d0d27c488 ("ext4: reduce computation of overhead during resize")
Fixes: de394a86658f ("ext4: update s_overhead_clusters in the superblock during an on-line resize")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20221117040341.1380702-2-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/resize.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 405c68085055..589ed99856f3 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1445,8 +1445,6 @@ static void ext4_update_super(struct super_block *sb,
 	 * active. */
 	ext4_r_blocks_count_set(es, ext4_r_blocks_count(es) +
 				reserved_blocks);
-	ext4_superblock_csum_set(sb);
-	unlock_buffer(sbi->s_sbh);
 
 	/* Update the free space counts */
 	percpu_counter_add(&sbi->s_freeclusters_counter,
@@ -1474,6 +1472,8 @@ static void ext4_update_super(struct super_block *sb,
 	ext4_calculate_overhead(sb);
 	es->s_overhead_clusters = cpu_to_le32(sbi->s_overhead);
 
+	ext4_superblock_csum_set(sb);
+	unlock_buffer(sbi->s_sbh);
 	if (test_opt(sb, DEBUG))
 		printk(KERN_DEBUG "EXT4-fs: added group %u:"
 		       "%llu blocks(%llu free %llu reserved)\n", flex_gd->count,
-- 
2.39.0.246.g2a6d74b583-goog

