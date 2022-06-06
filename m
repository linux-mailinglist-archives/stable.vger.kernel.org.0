Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD39E53E364
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbiFFHqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbiFFHqf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:46:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA40996BC
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 00:46:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0121611B5
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0434BC385A9;
        Mon,  6 Jun 2022 07:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654501592;
        bh=aO7ZDi+bbq0IGWM28kJoTjqv+7uZBSXnuU/6ckbOn5E=;
        h=Subject:To:Cc:From:Date:From;
        b=mOXYV3eh7lRJ/x8GwdMTs4O54KUCJODBQekIiztLpYgD5ps8KK/2jRat8kKzMQJeM
         40UYGwnJDgh8q6BzcOh+SbkU4RVrXG+Y4HeWuxqLx9MqsdVjRU0P0VNfVtml4UsmBc
         h4Jvx9aAuUsuQt99ZJRZH+zr7KY/YkJvII9DJyiE=
Subject: WTF: patch "[PATCH] samples/landlock: Format with clang-format" was seriously submitted to be applied to the 5.18-stable tree?
To:     mic@digikod.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 09:46:28 +0200
Message-ID: <1654501588118192@kroah.com>
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

From 81709f3dccacf4104a4bc2daa80bdd767a9c4c54 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Fri, 6 May 2022 18:05:13 +0200
Subject: [PATCH] samples/landlock: Format with clang-format
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Let's follow a consistent and documented coding style.  Everything may
not be to our liking but it is better than tacit knowledge.  Moreover,
this will help maintain style consistency between different developers.

This contains only whitespace changes.

Automatically formatted with:
clang-format-14 -i samples/landlock/*.[ch]

Link: https://lore.kernel.org/r/20220506160513.523257-8-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>

diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
index 5ce961b5bda7..c089e9cdaf32 100644
--- a/samples/landlock/sandboxer.c
+++ b/samples/landlock/sandboxer.c
@@ -22,9 +22,9 @@
 #include <unistd.h>
 
 #ifndef landlock_create_ruleset
-static inline int landlock_create_ruleset(
-		const struct landlock_ruleset_attr *const attr,
-		const size_t size, const __u32 flags)
+static inline int
+landlock_create_ruleset(const struct landlock_ruleset_attr *const attr,
+			const size_t size, const __u32 flags)
 {
 	return syscall(__NR_landlock_create_ruleset, attr, size, flags);
 }
@@ -32,17 +32,18 @@ static inline int landlock_create_ruleset(
 
 #ifndef landlock_add_rule
 static inline int landlock_add_rule(const int ruleset_fd,
-		const enum landlock_rule_type rule_type,
-		const void *const rule_attr, const __u32 flags)
+				    const enum landlock_rule_type rule_type,
+				    const void *const rule_attr,
+				    const __u32 flags)
 {
-	return syscall(__NR_landlock_add_rule, ruleset_fd, rule_type,
-			rule_attr, flags);
+	return syscall(__NR_landlock_add_rule, ruleset_fd, rule_type, rule_attr,
+		       flags);
 }
 #endif
 
 #ifndef landlock_restrict_self
 static inline int landlock_restrict_self(const int ruleset_fd,
-		const __u32 flags)
+					 const __u32 flags)
 {
 	return syscall(__NR_landlock_restrict_self, ruleset_fd, flags);
 }
@@ -79,9 +80,8 @@ static int parse_path(char *env_path, const char ***const path_list)
 
 /* clang-format on */
 
-static int populate_ruleset(
-		const char *const env_var, const int ruleset_fd,
-		const __u64 allowed_access)
+static int populate_ruleset(const char *const env_var, const int ruleset_fd,
+			    const __u64 allowed_access)
 {
 	int num_paths, i, ret = 1;
 	char *env_path_name;
@@ -111,12 +111,10 @@ static int populate_ruleset(
 	for (i = 0; i < num_paths; i++) {
 		struct stat statbuf;
 
-		path_beneath.parent_fd = open(path_list[i], O_PATH |
-				O_CLOEXEC);
+		path_beneath.parent_fd = open(path_list[i], O_PATH | O_CLOEXEC);
 		if (path_beneath.parent_fd < 0) {
 			fprintf(stderr, "Failed to open \"%s\": %s\n",
-					path_list[i],
-					strerror(errno));
+				path_list[i], strerror(errno));
 			goto out_free_name;
 		}
 		if (fstat(path_beneath.parent_fd, &statbuf)) {
@@ -127,9 +125,10 @@ static int populate_ruleset(
 		if (!S_ISDIR(statbuf.st_mode))
 			path_beneath.allowed_access &= ACCESS_FILE;
 		if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
-					&path_beneath, 0)) {
-			fprintf(stderr, "Failed to update the ruleset with \"%s\": %s\n",
-					path_list[i], strerror(errno));
+				      &path_beneath, 0)) {
+			fprintf(stderr,
+				"Failed to update the ruleset with \"%s\": %s\n",
+				path_list[i], strerror(errno));
 			close(path_beneath.parent_fd);
 			goto out_free_name;
 		}
@@ -171,55 +170,64 @@ int main(const int argc, char *const argv[], char *const *const envp)
 	int ruleset_fd;
 	struct landlock_ruleset_attr ruleset_attr = {
 		.handled_access_fs = ACCESS_FS_ROUGHLY_READ |
-			ACCESS_FS_ROUGHLY_WRITE,
+				     ACCESS_FS_ROUGHLY_WRITE,
 	};
 
 	if (argc < 2) {
-		fprintf(stderr, "usage: %s=\"...\" %s=\"...\" %s <cmd> [args]...\n\n",
-				ENV_FS_RO_NAME, ENV_FS_RW_NAME, argv[0]);
-		fprintf(stderr, "Launch a command in a restricted environment.\n\n");
+		fprintf(stderr,
+			"usage: %s=\"...\" %s=\"...\" %s <cmd> [args]...\n\n",
+			ENV_FS_RO_NAME, ENV_FS_RW_NAME, argv[0]);
+		fprintf(stderr,
+			"Launch a command in a restricted environment.\n\n");
 		fprintf(stderr, "Environment variables containing paths, "
 				"each separated by a colon:\n");
-		fprintf(stderr, "* %s: list of paths allowed to be used in a read-only way.\n",
-				ENV_FS_RO_NAME);
-		fprintf(stderr, "* %s: list of paths allowed to be used in a read-write way.\n",
-				ENV_FS_RW_NAME);
-		fprintf(stderr, "\nexample:\n"
-				"%s=\"/bin:/lib:/usr:/proc:/etc:/dev/urandom\" "
-				"%s=\"/dev/null:/dev/full:/dev/zero:/dev/pts:/tmp\" "
-				"%s bash -i\n",
-				ENV_FS_RO_NAME, ENV_FS_RW_NAME, argv[0]);
+		fprintf(stderr,
+			"* %s: list of paths allowed to be used in a read-only way.\n",
+			ENV_FS_RO_NAME);
+		fprintf(stderr,
+			"* %s: list of paths allowed to be used in a read-write way.\n",
+			ENV_FS_RW_NAME);
+		fprintf(stderr,
+			"\nexample:\n"
+			"%s=\"/bin:/lib:/usr:/proc:/etc:/dev/urandom\" "
+			"%s=\"/dev/null:/dev/full:/dev/zero:/dev/pts:/tmp\" "
+			"%s bash -i\n",
+			ENV_FS_RO_NAME, ENV_FS_RW_NAME, argv[0]);
 		return 1;
 	}
 
-	ruleset_fd = landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
 	if (ruleset_fd < 0) {
 		const int err = errno;
 
 		perror("Failed to create a ruleset");
 		switch (err) {
 		case ENOSYS:
-			fprintf(stderr, "Hint: Landlock is not supported by the current kernel. "
-					"To support it, build the kernel with "
-					"CONFIG_SECURITY_LANDLOCK=y and prepend "
-					"\"landlock,\" to the content of CONFIG_LSM.\n");
+			fprintf(stderr,
+				"Hint: Landlock is not supported by the current kernel. "
+				"To support it, build the kernel with "
+				"CONFIG_SECURITY_LANDLOCK=y and prepend "
+				"\"landlock,\" to the content of CONFIG_LSM.\n");
 			break;
 		case EOPNOTSUPP:
-			fprintf(stderr, "Hint: Landlock is currently disabled. "
-					"It can be enabled in the kernel configuration by "
-					"prepending \"landlock,\" to the content of CONFIG_LSM, "
-					"or at boot time by setting the same content to the "
-					"\"lsm\" kernel parameter.\n");
+			fprintf(stderr,
+				"Hint: Landlock is currently disabled. "
+				"It can be enabled in the kernel configuration by "
+				"prepending \"landlock,\" to the content of CONFIG_LSM, "
+				"or at boot time by setting the same content to the "
+				"\"lsm\" kernel parameter.\n");
 			break;
 		}
 		return 1;
 	}
 	if (populate_ruleset(ENV_FS_RO_NAME, ruleset_fd,
-				ACCESS_FS_ROUGHLY_READ)) {
+			     ACCESS_FS_ROUGHLY_READ)) {
 		goto err_close_ruleset;
 	}
 	if (populate_ruleset(ENV_FS_RW_NAME, ruleset_fd,
-				ACCESS_FS_ROUGHLY_READ | ACCESS_FS_ROUGHLY_WRITE)) {
+			     ACCESS_FS_ROUGHLY_READ |
+				     ACCESS_FS_ROUGHLY_WRITE)) {
 		goto err_close_ruleset;
 	}
 	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
@@ -236,7 +244,7 @@ int main(const int argc, char *const argv[], char *const *const envp)
 	cmd_argv = argv + 1;
 	execvpe(cmd_path, cmd_argv, envp);
 	fprintf(stderr, "Failed to execute \"%s\": %s\n", cmd_path,
-			strerror(errno));
+		strerror(errno));
 	fprintf(stderr, "Hint: access to the binary, the interpreter or "
 			"shared libraries may be denied.\n");
 	return 1;

