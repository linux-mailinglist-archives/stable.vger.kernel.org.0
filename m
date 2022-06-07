Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA11541DDE
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350819AbiFGWWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385116AbiFGWVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:21:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE8A265F98;
        Tue,  7 Jun 2022 12:21:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDA38609FA;
        Tue,  7 Jun 2022 19:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DA6C385A2;
        Tue,  7 Jun 2022 19:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629669;
        bh=Xj4t98qVdkLPZQTS7OXQAoSx8M/pu0ePvUGCBZ8pXgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ynzRyZABg5Op+lHFnC5U/78OoQMk7/TEgyP55hwvIarbtz4Vun3HkxSsrkiiaU7O5
         L3nWXz7riDIxWp0A6roZkWgotI+WNKJA1K2MVoRe8BCl6CGXHrtS4rzZQA31sziwhR
         io628VIueKYwZOBjQxVHQeup+LInm6cDV9K8DgCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.18 775/879] samples/landlock: Add clang-format exceptions
Date:   Tue,  7 Jun 2022 19:04:53 +0200
Message-Id: <20220607165025.355203392@linuxfoundation.org>
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

commit 9805a722db071e1772b80e6e0ff33f35355639ac upstream.

In preparation to a following commit, add clang-format on and
clang-format off stanzas around constant definitions.  This enables to
keep aligned values, which is much more readable than packed
definitions.

Link: https://lore.kernel.org/r/20220506160513.523257-7-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/landlock/sandboxer.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/samples/landlock/sandboxer.c
+++ b/samples/landlock/sandboxer.c
@@ -70,11 +70,15 @@ static int parse_path(char *env_path, co
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
@@ -139,6 +143,8 @@ out_free_name:
 	return ret;
 }
 
+/* clang-format off */
+
 #define ACCESS_FS_ROUGHLY_READ ( \
 	LANDLOCK_ACCESS_FS_EXECUTE | \
 	LANDLOCK_ACCESS_FS_READ_FILE | \
@@ -156,6 +162,8 @@ out_free_name:
 	LANDLOCK_ACCESS_FS_MAKE_BLOCK | \
 	LANDLOCK_ACCESS_FS_MAKE_SYM)
 
+/* clang-format on */
+
 int main(const int argc, char *const argv[], char *const *const envp)
 {
 	const char *cmd_path;


