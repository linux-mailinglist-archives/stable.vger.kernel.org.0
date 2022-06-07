Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D67540F83
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352464AbiFGTJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351439AbiFGTIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:08:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC5D326C1;
        Tue,  7 Jun 2022 11:05:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67738B82182;
        Tue,  7 Jun 2022 18:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3137C385A5;
        Tue,  7 Jun 2022 18:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625157;
        bh=Lq/jRnzkyNONRUKmF97mm3qk9+VbxEssjuIM6/KLqFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GI0Tdtmqv729jxSR7RSGULGxZ0RzonKcCHm5H7xWyJN67BJwkFWlnlbn33nyDEtdT
         OSUQNp1ZA1VfqK9DOtKhmW+apwBREVjY9uF6Gi2lSyyU9Auur0KvYk8QYtpnMx7oSh
         GqRvScSUv9e65Eo9UuL9liYNQu1qaJ3PiAYu5VcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.15 569/667] selftests/landlock: Add clang-format exceptions
Date:   Tue,  7 Jun 2022 19:03:54 +0200
Message-Id: <20220607164951.759727258@linuxfoundation.org>
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

commit 4598d9abf4215e1e371a35683350d50122793c80 upstream.

In preparation to a following commit, add clang-format on and
clang-format off stanzas around constant definitions and the TEST_F_FORK
macro.  This enables to keep aligned values, which is much more readable
than packed definitions.

Add other clang-format exceptions for FIXTURE() and
FIXTURE_VARIANT_ADD() declarations to force space before open brace,
which is reported by checkpatch.pl .

Link: https://lore.kernel.org/r/20220506160513.523257-4-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/common.h      |    2 ++
 tools/testing/selftests/landlock/fs_test.c     |   23 +++++++++++++++++------
 tools/testing/selftests/landlock/ptrace_test.c |   20 +++++++++++++++++++-
 3 files changed, 38 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/landlock/common.h
+++ b/tools/testing/selftests/landlock/common.h
@@ -29,6 +29,7 @@
  * this to be possible, we must not call abort() but instead exit smoothly
  * (hence the step print).
  */
+/* clang-format off */
 #define TEST_F_FORK(fixture_name, test_name) \
 	static void fixture_name##_##test_name##_child( \
 		struct __test_metadata *_metadata, \
@@ -75,6 +76,7 @@
 		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self, \
 		const FIXTURE_VARIANT(fixture_name) \
 			__attribute__((unused)) *variant)
+/* clang-format on */
 
 #ifndef landlock_create_ruleset
 static inline int landlock_create_ruleset(
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -221,8 +221,9 @@ static void remove_layout1(struct __test
 	EXPECT_EQ(0, remove_path(dir_s3d2));
 }
 
-FIXTURE(layout1) {
-};
+/* clang-format off */
+FIXTURE(layout1) {};
+/* clang-format on */
 
 FIXTURE_SETUP(layout1)
 {
@@ -376,6 +377,8 @@ TEST_F_FORK(layout1, inval)
 	ASSERT_EQ(0, close(ruleset_fd));
 }
 
+/* clang-format off */
+
 #define ACCESS_FILE ( \
 	LANDLOCK_ACCESS_FS_EXECUTE | \
 	LANDLOCK_ACCESS_FS_WRITE_FILE | \
@@ -396,6 +399,8 @@ TEST_F_FORK(layout1, inval)
 	LANDLOCK_ACCESS_FS_MAKE_BLOCK | \
 	ACCESS_LAST)
 
+/* clang-format on */
+
 TEST_F_FORK(layout1, file_access_rights)
 {
 	__u64 access;
@@ -452,6 +457,8 @@ struct rule {
 	__u64 access;
 };
 
+/* clang-format off */
+
 #define ACCESS_RO ( \
 	LANDLOCK_ACCESS_FS_READ_FILE | \
 	LANDLOCK_ACCESS_FS_READ_DIR)
@@ -460,6 +467,8 @@ struct rule {
 	ACCESS_RO | \
 	LANDLOCK_ACCESS_FS_WRITE_FILE)
 
+/* clang-format on */
+
 static int create_ruleset(struct __test_metadata *const _metadata,
 		const __u64 handled_access_fs, const struct rule rules[])
 {
@@ -2070,8 +2079,9 @@ TEST_F_FORK(layout1, proc_pipe)
 	ASSERT_EQ(0, close(pipe_fds[1]));
 }
 
-FIXTURE(layout1_bind) {
-};
+/* clang-format off */
+FIXTURE(layout1_bind) {};
+/* clang-format on */
 
 FIXTURE_SETUP(layout1_bind)
 {
@@ -2411,8 +2421,9 @@ static const char (*merge_sub_files[])[]
  *         └── work
  */
 
-FIXTURE(layout2_overlay) {
-};
+/* clang-format off */
+FIXTURE(layout2_overlay) {};
+/* clang-format on */
 
 FIXTURE_SETUP(layout2_overlay)
 {
--- a/tools/testing/selftests/landlock/ptrace_test.c
+++ b/tools/testing/selftests/landlock/ptrace_test.c
@@ -59,7 +59,9 @@ static int test_ptrace_read(const pid_t
 	return 0;
 }
 
-FIXTURE(hierarchy) { };
+/* clang-format off */
+FIXTURE(hierarchy) {};
+/* clang-format on */
 
 FIXTURE_VARIANT(hierarchy) {
 	const bool domain_both;
@@ -83,7 +85,9 @@ FIXTURE_VARIANT(hierarchy) {
  *       \              P2 -> P1 : allow
  *        'P2
  */
+/* clang-format off */
 FIXTURE_VARIANT_ADD(hierarchy, allow_without_domain) {
+	/* clang-format on */
 	.domain_both = false,
 	.domain_parent = false,
 	.domain_child = false,
@@ -98,7 +102,9 @@ FIXTURE_VARIANT_ADD(hierarchy, allow_wit
  *        |  P2  |
  *        '------'
  */
+/* clang-format off */
 FIXTURE_VARIANT_ADD(hierarchy, allow_with_one_domain) {
+	/* clang-format on */
 	.domain_both = false,
 	.domain_parent = false,
 	.domain_child = true,
@@ -112,7 +118,9 @@ FIXTURE_VARIANT_ADD(hierarchy, allow_wit
  *            '
  *            P2
  */
+/* clang-format off */
 FIXTURE_VARIANT_ADD(hierarchy, deny_with_parent_domain) {
+	/* clang-format on */
 	.domain_both = false,
 	.domain_parent = true,
 	.domain_child = false,
@@ -127,7 +135,9 @@ FIXTURE_VARIANT_ADD(hierarchy, deny_with
  *         |  P2  |
  *         '------'
  */
+/* clang-format off */
 FIXTURE_VARIANT_ADD(hierarchy, deny_with_sibling_domain) {
+	/* clang-format on */
 	.domain_both = false,
 	.domain_parent = true,
 	.domain_child = true,
@@ -142,7 +152,9 @@ FIXTURE_VARIANT_ADD(hierarchy, deny_with
  * |         P2  |
  * '-------------'
  */
+/* clang-format off */
 FIXTURE_VARIANT_ADD(hierarchy, allow_sibling_domain) {
+	/* clang-format on */
 	.domain_both = true,
 	.domain_parent = false,
 	.domain_child = false,
@@ -158,7 +170,9 @@ FIXTURE_VARIANT_ADD(hierarchy, allow_sib
  * |        '------' |
  * '-----------------'
  */
+/* clang-format off */
 FIXTURE_VARIANT_ADD(hierarchy, allow_with_nested_domain) {
+	/* clang-format on */
 	.domain_both = true,
 	.domain_parent = false,
 	.domain_child = true,
@@ -174,7 +188,9 @@ FIXTURE_VARIANT_ADD(hierarchy, allow_wit
  * |             P2  |
  * '-----------------'
  */
+/* clang-format off */
 FIXTURE_VARIANT_ADD(hierarchy, deny_with_nested_and_parent_domain) {
+	/* clang-format on */
 	.domain_both = true,
 	.domain_parent = true,
 	.domain_child = false,
@@ -192,7 +208,9 @@ FIXTURE_VARIANT_ADD(hierarchy, deny_with
  * |        '------' |
  * '-----------------'
  */
+/* clang-format off */
 FIXTURE_VARIANT_ADD(hierarchy, deny_with_forked_domain) {
+	/* clang-format on */
 	.domain_both = true,
 	.domain_parent = true,
 	.domain_child = true,


