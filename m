Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46AD541E07
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380552AbiFGWXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385210AbiFGWVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:21:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A1C265FAD;
        Tue,  7 Jun 2022 12:21:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74D6A60906;
        Tue,  7 Jun 2022 19:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E91C34115;
        Tue,  7 Jun 2022 19:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629671;
        bh=a4eiVjuiMdl5Kk9U/T8ygeO3MRd4Li27yrcvZKUmnlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njHr9hm/vVOeGgpJsUREdt7za45em6VZ5GB0rbqvwJjsJXb7s4GPhS00pTR1B1oFM
         wPKzJY1gssRtJt/gWXenJugAYFAFDGEMG/KUn1ZdTFBcYNMkR0dJ7kl3hRKokvuLb4
         uwuFN+w4tG5DV+DBsj+k85J/JhLGuU1x7671nJd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.18 776/879] samples/landlock: Format with clang-format
Date:   Tue,  7 Jun 2022 19:04:54 +0200
Message-Id: <20220607165025.393543562@linuxfoundation.org>
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

commit 81709f3dccacf4104a4bc2daa80bdd767a9c4c54 upstream.

Let's follow a consistent and documented coding style.  Everything may
not be to our liking but it is better than tacit knowledge.  Moreover,
this will help maintain style consistency between different developers.

This contains only whitespace changes.

Automatically formatted with:
clang-format-14 -i samples/landlock/*.[ch]

Link: https://lore.kernel.org/r/20220506160513.523257-8-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/landlock/sandboxer.c |   96 +++++++++++++++++++++++--------------------
 1 file changed, 52 insertions(+), 44 deletions(-)

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
@@ -32,17 +32,18 @@ static inline int landlock_create_rulese
 
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
@@ -79,9 +80,8 @@ static int parse_path(char *env_path, co
 
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
@@ -171,55 +170,64 @@ int main(const int argc, char *const arg
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
@@ -236,7 +244,7 @@ int main(const int argc, char *const arg
 	cmd_argv = argv + 1;
 	execvpe(cmd_path, cmd_argv, envp);
 	fprintf(stderr, "Failed to execute \"%s\": %s\n", cmd_path,
-			strerror(errno));
+		strerror(errno));
 	fprintf(stderr, "Hint: access to the binary, the interpreter or "
 			"shared libraries may be denied.\n");
 	return 1;


