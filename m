Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2927653E2BF
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbiFFHqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiFFHqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:46:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D5D9728C
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 00:46:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D2078CE16FA
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D42C385A9;
        Mon,  6 Jun 2022 07:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654501569;
        bh=MxT6w9tk4l+8jXDwrriIwZxL6hECTUfsUbMl47vrHUU=;
        h=Subject:To:Cc:From:Date:From;
        b=LABbD5Pz12g6t/z8KGL5pqurhUoj4h39wYJw0vyMT2iQveSINdGZCBcBtf9X9Bip5
         90DwWK2Kz5dovKnumG7V+G2H9smTzyrmHlckTL1Lx0ocCa0qbmU9iJUOUVBn7TpSIN
         syPQgbpGeKxOQqDibO+TJ/oPoKrqQja9weAHTfYQ=
Subject: WTF: patch "[PATCH] landlock: Add clang-format exceptions" was seriously submitted to be applied to the 5.18-stable tree?
To:     mic@digikod.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 09:46:04 +0200
Message-ID: <1654501564224121@kroah.com>
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

The patch below was submitted to be applied to the 5.18-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6cc2df8e3a3967e7c13a424f87f6efb1d4a62d80 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Fri, 6 May 2022 18:05:07 +0200
Subject: [PATCH] landlock: Add clang-format exceptions
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In preparation to a following commit, add clang-format on and
clang-format off stanzas around constant definitions.  This enables to
keep aligned values, which is much more readable than packed
definitions.

Link: https://lore.kernel.org/r/20220506160513.523257-2-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>

diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
index b3d952067f59..15c31abb0d76 100644
--- a/include/uapi/linux/landlock.h
+++ b/include/uapi/linux/landlock.h
@@ -33,7 +33,9 @@ struct landlock_ruleset_attr {
  * - %LANDLOCK_CREATE_RULESET_VERSION: Get the highest supported Landlock ABI
  *   version.
  */
+/* clang-format off */
 #define LANDLOCK_CREATE_RULESET_VERSION			(1U << 0)
+/* clang-format on */
 
 /**
  * enum landlock_rule_type - Landlock rule type
@@ -120,6 +122,7 @@ struct landlock_path_beneath_attr {
  *   :manpage:`access(2)`.
  *   Future Landlock evolutions will enable to restrict them.
  */
+/* clang-format off */
 #define LANDLOCK_ACCESS_FS_EXECUTE			(1ULL << 0)
 #define LANDLOCK_ACCESS_FS_WRITE_FILE			(1ULL << 1)
 #define LANDLOCK_ACCESS_FS_READ_FILE			(1ULL << 2)
@@ -133,5 +136,6 @@ struct landlock_path_beneath_attr {
 #define LANDLOCK_ACCESS_FS_MAKE_FIFO			(1ULL << 10)
 #define LANDLOCK_ACCESS_FS_MAKE_BLOCK			(1ULL << 11)
 #define LANDLOCK_ACCESS_FS_MAKE_SYM			(1ULL << 12)
+/* clang-format on */
 
 #endif /* _UAPI_LINUX_LANDLOCK_H */
diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index 97b8e421f617..4195a6be60b2 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -141,10 +141,12 @@ static struct landlock_object *get_inode_object(struct inode *const inode)
 }
 
 /* All access rights that can be tied to files. */
+/* clang-format off */
 #define ACCESS_FILE ( \
 	LANDLOCK_ACCESS_FS_EXECUTE | \
 	LANDLOCK_ACCESS_FS_WRITE_FILE | \
 	LANDLOCK_ACCESS_FS_READ_FILE)
+/* clang-format on */
 
 /*
  * @path: Should have been checked by get_path_from_fd().
diff --git a/security/landlock/limits.h b/security/landlock/limits.h
index 2a0a1095ee27..a274ae6b5570 100644
--- a/security/landlock/limits.h
+++ b/security/landlock/limits.h
@@ -12,10 +12,14 @@
 #include <linux/limits.h>
 #include <uapi/linux/landlock.h>
 
+/* clang-format off */
+
 #define LANDLOCK_MAX_NUM_LAYERS		64
 #define LANDLOCK_MAX_NUM_RULES		U32_MAX
 
 #define LANDLOCK_LAST_ACCESS_FS		LANDLOCK_ACCESS_FS_MAKE_SYM
 #define LANDLOCK_MASK_ACCESS_FS		((LANDLOCK_LAST_ACCESS_FS << 1) - 1)
 
+/* clang-format on */
+
 #endif /* _SECURITY_LANDLOCK_LIMITS_H */

