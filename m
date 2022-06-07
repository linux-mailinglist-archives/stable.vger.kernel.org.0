Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20068540FB9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354787AbiFGTLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354363AbiFGTJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:09:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F95E192C73;
        Tue,  7 Jun 2022 11:06:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04FC7B80B66;
        Tue,  7 Jun 2022 18:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66233C385A5;
        Tue,  7 Jun 2022 18:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625188;
        bh=kn6sAE0YkITH3uwY7tqEKQQ1ZIy1Yzl46v+yJv1v1i0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjhNes7kQQOCoH0q5hDXSQmgxaBcP/6C+pnSNNVV8bCulVJgJOBu4pQdPB51DJk4W
         lRKDJcJRyr1KYkhe2au1xWU123hqdR5AclZPRm6rxlkGiAFT5N+kVfsy0uywLWZISz
         /P86zUv9mLQsvxdcGitiH08qTTgFH5KRuRpVdjqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.15 570/667] selftests/landlock: Normalize array assignment
Date:   Tue,  7 Jun 2022 19:03:55 +0200
Message-Id: <20220607164951.789386463@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mickaël Salaün <mic@digikod.net>

commit 135464f9d29c5b306d7201220f1d00dab30fea89 upstream.

Add a comma after each array value to make clang-format keep the
current array formatting.  See the following commit.

Automatically modified with:
sed -i 's/\t\({}\|NULL\)$/\0,/' tools/testing/selftests/landlock/fs_test.c

Link: https://lore.kernel.org/r/20220506160513.523257-5-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/fs_test.c |  112 ++++++++++++++---------------
 1 file changed, 56 insertions(+), 56 deletions(-)

--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -514,7 +514,7 @@ TEST_F_FORK(layout1, proc_nsfs)
 			.access = LANDLOCK_ACCESS_FS_READ_FILE |
 				LANDLOCK_ACCESS_FS_WRITE_FILE,
 		},
-		{}
+		{},
 	};
 	struct landlock_path_beneath_attr path_beneath;
 	const int ruleset_fd = create_ruleset(_metadata, rules[0].access |
@@ -560,7 +560,7 @@ TEST_F_FORK(layout1, unpriv) {
 			.path = dir_s1d2,
 			.access = ACCESS_RO,
 		},
-		{}
+		{},
 	};
 	int ruleset_fd;
 
@@ -588,7 +588,7 @@ TEST_F_FORK(layout1, effective_access)
 			.access = LANDLOCK_ACCESS_FS_READ_FILE |
 				LANDLOCK_ACCESS_FS_WRITE_FILE,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
 	char buf;
@@ -635,7 +635,7 @@ TEST_F_FORK(layout1, unhandled_access)
 			.path = dir_s1d2,
 			.access = ACCESS_RO,
 		},
-		{}
+		{},
 	};
 	/* Here, we only handle read accesses, not write accesses. */
 	const int ruleset_fd = create_ruleset(_metadata, ACCESS_RO, rules);
@@ -669,7 +669,7 @@ TEST_F_FORK(layout1, ruleset_overlap)
 			.access = LANDLOCK_ACCESS_FS_READ_FILE |
 				LANDLOCK_ACCESS_FS_READ_DIR,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
 
@@ -703,14 +703,14 @@ TEST_F_FORK(layout1, non_overlapping_acc
 			.path = dir_s1d2,
 			.access = LANDLOCK_ACCESS_FS_MAKE_REG,
 		},
-		{}
+		{},
 	};
 	const struct rule layer2[] = {
 		{
 			.path = dir_s1d3,
 			.access = LANDLOCK_ACCESS_FS_REMOVE_FILE,
 		},
-		{}
+		{},
 	};
 	int ruleset_fd;
 
@@ -767,7 +767,7 @@ TEST_F_FORK(layout1, interleaved_masked_
 			.path = file1_s1d3,
 			.access = LANDLOCK_ACCESS_FS_READ_FILE,
 		},
-		{}
+		{},
 	};
 	/* First rule with write restrictions. */
 	const struct rule layer2_read_write[] = {
@@ -782,7 +782,7 @@ TEST_F_FORK(layout1, interleaved_masked_
 			.path = dir_s1d2,
 			.access = LANDLOCK_ACCESS_FS_WRITE_FILE,
 		},
-		{}
+		{},
 	};
 	const struct rule layer3_read[] = {
 		/* Allows read access via its great-grandparent directory. */
@@ -790,7 +790,7 @@ TEST_F_FORK(layout1, interleaved_masked_
 			.path = dir_s1d1,
 			.access = LANDLOCK_ACCESS_FS_READ_FILE,
 		},
-		{}
+		{},
 	};
 	const struct rule layer4_read_write[] = {
 		/*
@@ -801,7 +801,7 @@ TEST_F_FORK(layout1, interleaved_masked_
 			.path = dir_s1d2,
 			.access = LANDLOCK_ACCESS_FS_READ_FILE,
 		},
-		{}
+		{},
 	};
 	const struct rule layer5_read[] = {
 		/*
@@ -812,7 +812,7 @@ TEST_F_FORK(layout1, interleaved_masked_
 			.path = dir_s1d2,
 			.access = LANDLOCK_ACCESS_FS_READ_FILE,
 		},
-		{}
+		{},
 	};
 	const struct rule layer6_execute[] = {
 		/*
@@ -823,7 +823,7 @@ TEST_F_FORK(layout1, interleaved_masked_
 			.path = dir_s2d1,
 			.access = LANDLOCK_ACCESS_FS_EXECUTE,
 		},
-		{}
+		{},
 	};
 	const struct rule layer7_read_write[] = {
 		/*
@@ -834,7 +834,7 @@ TEST_F_FORK(layout1, interleaved_masked_
 			.path = dir_s1d2,
 			.access = LANDLOCK_ACCESS_FS_WRITE_FILE,
 		},
-		{}
+		{},
 	};
 	int ruleset_fd;
 
@@ -932,7 +932,7 @@ TEST_F_FORK(layout1, inherit_subset)
 			.access = LANDLOCK_ACCESS_FS_READ_FILE |
 				LANDLOCK_ACCESS_FS_READ_DIR,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
 
@@ -1048,7 +1048,7 @@ TEST_F_FORK(layout1, inherit_superset)
 			.path = dir_s1d3,
 			.access = ACCESS_RO,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
 
@@ -1084,7 +1084,7 @@ TEST_F_FORK(layout1, max_layers)
 			.path = dir_s1d2,
 			.access = ACCESS_RO,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
 
@@ -1146,7 +1146,7 @@ TEST_F_FORK(layout1, rule_on_mountpoint)
 			.path = dir_s3d2,
 			.access = ACCESS_RO,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
 
@@ -1175,7 +1175,7 @@ TEST_F_FORK(layout1, rule_over_mountpoin
 			.path = dir_s3d1,
 			.access = ACCESS_RO,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
 
@@ -1203,7 +1203,7 @@ TEST_F_FORK(layout1, rule_over_root_allo
 			.path = "/",
 			.access = ACCESS_RO,
 		},
-		{}
+		{},
 	};
 	int ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
 
@@ -1233,7 +1233,7 @@ TEST_F_FORK(layout1, rule_over_root_deny
 			.path = "/",
 			.access = LANDLOCK_ACCESS_FS_READ_FILE,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
 
@@ -1253,7 +1253,7 @@ TEST_F_FORK(layout1, rule_inside_mount_n
 			.path = "s3d3",
 			.access = ACCESS_RO,
 		},
-		{}
+		{},
 	};
 	int ruleset_fd;
 
@@ -1280,7 +1280,7 @@ TEST_F_FORK(layout1, mount_and_pivot)
 			.path = dir_s3d2,
 			.access = ACCESS_RO,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
 
@@ -1303,7 +1303,7 @@ TEST_F_FORK(layout1, move_mount)
 			.path = dir_s3d2,
 			.access = ACCESS_RO,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
 
@@ -1344,7 +1344,7 @@ TEST_F_FORK(layout1, release_inodes)
 			.path = dir_s3d3,
 			.access = ACCESS_RO,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
 
@@ -1382,7 +1382,7 @@ static void test_relative_path(struct __
 			.path = TMP_DIR,
 			.access = ACCESS_RO,
 		},
-		{}
+		{},
 	};
 	const struct rule layer2_subs[] = {
 		{
@@ -1393,7 +1393,7 @@ static void test_relative_path(struct __
 			.path = dir_s2d2,
 			.access = ACCESS_RO,
 		},
-		{}
+		{},
 	};
 	int dirfd, ruleset_fd;
 
@@ -1558,7 +1558,7 @@ TEST_F_FORK(layout1, execute)
 			.path = dir_s1d2,
 			.access = LANDLOCK_ACCESS_FS_EXECUTE,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, rules[0].access,
 			rules);
@@ -1591,7 +1591,7 @@ TEST_F_FORK(layout1, link)
 			.path = dir_s1d2,
 			.access = LANDLOCK_ACCESS_FS_MAKE_REG,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, rules[0].access,
 			rules);
@@ -1628,7 +1628,7 @@ TEST_F_FORK(layout1, rename_file)
 			.path = dir_s2d2,
 			.access = LANDLOCK_ACCESS_FS_REMOVE_FILE,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, rules[0].access,
 			rules);
@@ -1705,7 +1705,7 @@ TEST_F_FORK(layout1, rename_dir)
 			.path = dir_s2d1,
 			.access = LANDLOCK_ACCESS_FS_REMOVE_DIR,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, rules[0].access,
 			rules);
@@ -1759,7 +1759,7 @@ TEST_F_FORK(layout1, remove_dir)
 			.path = dir_s1d2,
 			.access = LANDLOCK_ACCESS_FS_REMOVE_DIR,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, rules[0].access,
 			rules);
@@ -1796,7 +1796,7 @@ TEST_F_FORK(layout1, remove_file)
 			.path = dir_s1d2,
 			.access = LANDLOCK_ACCESS_FS_REMOVE_FILE,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, rules[0].access,
 			rules);
@@ -1821,7 +1821,7 @@ static void test_make_file(struct __test
 			.path = dir_s1d2,
 			.access = access,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, access, rules);
 
@@ -1907,7 +1907,7 @@ TEST_F_FORK(layout1, make_sym)
 			.path = dir_s1d2,
 			.access = LANDLOCK_ACCESS_FS_MAKE_SYM,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, rules[0].access,
 			rules);
@@ -1952,7 +1952,7 @@ TEST_F_FORK(layout1, make_dir)
 			.path = dir_s1d2,
 			.access = LANDLOCK_ACCESS_FS_MAKE_DIR,
 		},
-		{}
+		{},
 	};
 	const int ruleset_fd = create_ruleset(_metadata, rules[0].access,
 			rules);
@@ -1992,7 +1992,7 @@ TEST_F_FORK(layout1, proc_unlinked_file)
 			.path = file1_s1d2,
 			.access = LANDLOCK_ACCESS_FS_READ_FILE,
 		},
-		{}
+		{},
 	};
 	int reg_fd, proc_fd;
 	const int ruleset_fd = create_ruleset(_metadata,
@@ -2034,7 +2034,7 @@ TEST_F_FORK(layout1, proc_pipe)
 			.access = LANDLOCK_ACCESS_FS_READ_FILE |
 				LANDLOCK_ACCESS_FS_WRITE_FILE,
 		},
-		{}
+		{},
 	};
 	/* Limits read and write access to files tied to the filesystem. */
 	const int ruleset_fd = create_ruleset(_metadata, rules[0].access,
@@ -2171,7 +2171,7 @@ TEST_F_FORK(layout1_bind, same_content_s
 			.path = dir_s2d1,
 			.access = ACCESS_RW,
 		},
-		{}
+		{},
 	};
 	/*
 	 * Sets access rights on the same bind-mounted directories.  The result
@@ -2187,7 +2187,7 @@ TEST_F_FORK(layout1_bind, same_content_s
 			.path = dir_s2d2,
 			.access = ACCESS_RW,
 		},
-		{}
+		{},
 	};
 	/* Only allow read-access to the s1d3 hierarchies. */
 	const struct rule layer3_source[] = {
@@ -2195,7 +2195,7 @@ TEST_F_FORK(layout1_bind, same_content_s
 			.path = dir_s1d3,
 			.access = LANDLOCK_ACCESS_FS_READ_FILE,
 		},
-		{}
+		{},
 	};
 	/* Removes all access rights. */
 	const struct rule layer4_destination[] = {
@@ -2203,7 +2203,7 @@ TEST_F_FORK(layout1_bind, same_content_s
 			.path = bind_file1_s1d3,
 			.access = LANDLOCK_ACCESS_FS_WRITE_FILE,
 		},
-		{}
+		{},
 	};
 	int ruleset_fd;
 
@@ -2305,18 +2305,18 @@ static const char lower_do1_fl3[] = LOWE
 static const char (*lower_base_files[])[] = {
 	&lower_fl1,
 	&lower_fo1,
-	NULL
+	NULL,
 };
 static const char (*lower_base_directories[])[] = {
 	&lower_dl1,
 	&lower_do1,
-	NULL
+	NULL,
 };
 static const char (*lower_sub_files[])[] = {
 	&lower_dl1_fl2,
 	&lower_do1_fo2,
 	&lower_do1_fl3,
-	NULL
+	NULL,
 };
 
 #define UPPER_BASE	TMP_DIR "/upper"
@@ -2333,18 +2333,18 @@ static const char upper_do1_fu3[] = UPPE
 static const char (*upper_base_files[])[] = {
 	&upper_fu1,
 	&upper_fo1,
-	NULL
+	NULL,
 };
 static const char (*upper_base_directories[])[] = {
 	&upper_du1,
 	&upper_do1,
-	NULL
+	NULL,
 };
 static const char (*upper_sub_files[])[] = {
 	&upper_du1_fu2,
 	&upper_do1_fo2,
 	&upper_do1_fu3,
-	NULL
+	NULL,
 };
 
 #define MERGE_BASE	TMP_DIR "/merge"
@@ -2365,13 +2365,13 @@ static const char (*merge_base_files[])[
 	&merge_fl1,
 	&merge_fu1,
 	&merge_fo1,
-	NULL
+	NULL,
 };
 static const char (*merge_base_directories[])[] = {
 	&merge_dl1,
 	&merge_du1,
 	&merge_do1,
-	NULL
+	NULL,
 };
 static const char (*merge_sub_files[])[] = {
 	&merge_dl1_fl2,
@@ -2379,7 +2379,7 @@ static const char (*merge_sub_files[])[]
 	&merge_do1_fo2,
 	&merge_do1_fl3,
 	&merge_do1_fu3,
-	NULL
+	NULL,
 };
 
 /*
@@ -2544,7 +2544,7 @@ TEST_F_FORK(layout2_overlay, same_conten
 			.path = MERGE_BASE,
 			.access = ACCESS_RW,
 		},
-		{}
+		{},
 	};
 	const struct rule layer2_data[] = {
 		{
@@ -2559,7 +2559,7 @@ TEST_F_FORK(layout2_overlay, same_conten
 			.path = MERGE_DATA,
 			.access = ACCESS_RW,
 		},
-		{}
+		{},
 	};
 	/* Sets access right on directories inside both layers. */
 	const struct rule layer3_subdirs[] = {
@@ -2591,7 +2591,7 @@ TEST_F_FORK(layout2_overlay, same_conten
 			.path = merge_do1,
 			.access = ACCESS_RW,
 		},
-		{}
+		{},
 	};
 	/* Tighten access rights to the files. */
 	const struct rule layer4_files[] = {
@@ -2644,7 +2644,7 @@ TEST_F_FORK(layout2_overlay, same_conten
 			.access = LANDLOCK_ACCESS_FS_READ_FILE |
 				LANDLOCK_ACCESS_FS_WRITE_FILE,
 		},
-		{}
+		{},
 	};
 	const struct rule layer5_merge_only[] = {
 		{
@@ -2652,7 +2652,7 @@ TEST_F_FORK(layout2_overlay, same_conten
 			.access = LANDLOCK_ACCESS_FS_READ_FILE |
 				LANDLOCK_ACCESS_FS_WRITE_FILE,
 		},
-		{}
+		{},
 	};
 	int ruleset_fd;
 	size_t i;


