Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDEA53E2CC
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbiFFHqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiFFHqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:46:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749F479343
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 00:46:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1134E611B3
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CBFC385A9;
        Mon,  6 Jun 2022 07:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654501603;
        bh=iTi0ToQwKBGswRsTPBTsf/0TE99pZxaYHD+3hTcB3RM=;
        h=Subject:To:Cc:From:Date:From;
        b=Bj9B3RS5OPoYFR3/rgY6Eod0gwsanp+YMseGbBKqhyzI+FeF5znOc7LNbZ9TJ71RF
         f0l7KvR9mIpXK5SjDENa+g/jlvnvkGwzteLVrXcR8NgRC09VINQUBwPKEtE3E/A/U3
         /7AlvHVbbyFxuE1YZksZGvcUx8aoJf5r9QFiwWL4=
Subject: WTF: patch "[PATCH] samples/landlock: Add clang-format exceptions" was seriously submitted to be applied to the 5.18-stable tree?
To:     mic@digikod.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 09:46:39 +0200
Message-ID: <1654501599211215@kroah.com>
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

From 9805a722db071e1772b80e6e0ff33f35355639ac Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Fri, 6 May 2022 18:05:12 +0200
Subject: [PATCH] samples/landlock: Add clang-format exceptions
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In preparation to a following commit, add clang-format on and
clang-format off stanzas around constant definitions.  This enables to
keep aligned values, which is much more readable than packed
definitions.

Link: https://lore.kernel.org/r/20220506160513.523257-7-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>

diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
index 8859fc193542..5ce961b5bda7 100644
--- a/samples/landlock/sandboxer.c
+++ b/samples/landlock/sandboxer.c
@@ -70,11 +70,15 @@ static int parse_path(char *env_path, const char ***const path_list)
 	return num_paths;
 }
 
+/* clang-format off */
+
 #define ACCESS_FILE ( \
 	LANDLOCK_ACCESS_FS_EXECUTE | \
 	LANDLOCK_ACCESS_FS_WRITE_FILE | \
 	LANDLOCK_ACCESS_FS_READ_FILE)
 
+/* clang-format on */
+
 static int populate_ruleset(
 		const char *const env_var, const int ruleset_fd,
 		const __u64 allowed_access)
@@ -139,6 +143,8 @@ static int populate_ruleset(
 	return ret;
 }
 
+/* clang-format off */
+
 #define ACCESS_FS_ROUGHLY_READ ( \
 	LANDLOCK_ACCESS_FS_EXECUTE | \
 	LANDLOCK_ACCESS_FS_READ_FILE | \
@@ -156,6 +162,8 @@ static int populate_ruleset(
 	LANDLOCK_ACCESS_FS_MAKE_BLOCK | \
 	LANDLOCK_ACCESS_FS_MAKE_SYM)
 
+/* clang-format on */
+
 int main(const int argc, char *const argv[], char *const *const envp)
 {
 	const char *cmd_path;

