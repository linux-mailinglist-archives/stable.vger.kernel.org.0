Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A66541E41
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380455AbiFGW1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383654AbiFGWZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:25:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FDE26EEBC;
        Tue,  7 Jun 2022 12:22:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2F147CE2476;
        Tue,  7 Jun 2022 19:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1079CC385A2;
        Tue,  7 Jun 2022 19:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629769;
        bh=jAfyJdtY7AW8Hezy+hcbPYqE7q7fX2MgEkIpU715TEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9qAgRuQfJ5DJKuGukxR1HGvx0WzGSoLBV7g9Yygg6NUoRDUg2Epgy8qLuesnuf0J
         SR8pWwG0Bq2cXWr+2hxTyt6L6kYjgsHief3vDEdvSLZPYzK13TyDKJQs0IHnHR+fP+
         ZBomMO+ayGG4wsXz7wua4/6E60YU0n1qzQTuQNKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.18 770/879] landlock: Add clang-format exceptions
Date:   Tue,  7 Jun 2022 19:04:48 +0200
Message-Id: <20220607165025.211939028@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

commit 6cc2df8e3a3967e7c13a424f87f6efb1d4a62d80 upstream.

In preparation to a following commit, add clang-format on and
clang-format off stanzas around constant definitions.  This enables to
keep aligned values, which is much more readable than packed
definitions.

Link: https://lore.kernel.org/r/20220506160513.523257-2-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/landlock.h |    4 ++++
 security/landlock/fs.c        |    2 ++
 security/landlock/limits.h    |    4 ++++
 3 files changed, 10 insertions(+)

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
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -141,10 +141,12 @@ retry:
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


