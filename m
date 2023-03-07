Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D123B6AF479
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbjCGTRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbjCGTQL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:11 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611F0B78B1;
        Tue,  7 Mar 2023 10:59:37 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so12764621pjg.4;
        Tue, 07 Mar 2023 10:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678215576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LeZLdQs5ukpKkEndJo4iQKes4wfuvpMlzUJLIUAJDBU=;
        b=gbRMxFnlfZtjtfDzo0iEB4++od/qToZuDgx2l0g3ep6Bz0uh4LjtLzyDBNyfFd5GTI
         GaoDP39YlhK8MEC8tNF59d6CNgyiX6qpbVLpe5QHvxGY0xaDUFS7amX5KqeIkWYDRnz0
         6OHrYMEVXkTdfhENQD6KAiwIKezFsJdI1BO1yr3n/1xnMFuQbrDNtKywyXlG7LuQBEp6
         v0Xtt8hYzqrhILAxTjifPUk0UZHTx1C9LPPae0jgwSbWa1LuF0AXSad/BoIJ+Mj9P8Pn
         +apsZBkxzBSaPsYld41R3mJJrEL52pxsEPq6AopYF6W1HmvUWtB2DF3IuG5BkOi4EUd2
         B2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678215576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LeZLdQs5ukpKkEndJo4iQKes4wfuvpMlzUJLIUAJDBU=;
        b=SDagEfRkNDNIfMhJ9JVnRZLmUQxdOqVSZfELwegHYYSTK7xaMNQFH2MVsyol9l7FCl
         Tkdo3HaMutJoHF8k/hUHY8A8FNSFtBvEbf5ijp1bjycc5mA36gCyvsp5MI45J89HOAsD
         UejIXr+6rQRYl1zUjJALl0rseSPi+qaD+bA7bwBtBoY148g07rxp8YokeoOTys+maSSb
         gHonklyw6pN9BSaTTYjSsLmay1WZ7x/NHazCIad9WVG9ILarZqS35v6EktEz9EuCsQxK
         X+s46Tvzy22Wbh3bASGqH1/1y3GjEpIDzEPIti7vzl1vf2Xy1I43Eki4K/3zIRd7sKzy
         fYAQ==
X-Gm-Message-State: AO0yUKWEXmSiVg7ZoMRG/3gYsPwkMsv8HbiJ7UUjzaGrOCOrltlLC+0P
        uiig156QgI4KVDdwU58Ez3l8gaC2ddjrbg==
X-Google-Smtp-Source: AK7set96vFw3FB7rTNYejKR9IOg2586gF5sxHcigfJYFwphVwQ6qA9gldw3EodrOsc3cN2wsOGIxRA==
X-Received: by 2002:a17:903:328e:b0:197:19f7:52b4 with SMTP id jh14-20020a170903328e00b0019719f752b4mr13668375plb.42.1678215576491;
        Tue, 07 Mar 2023 10:59:36 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:6f2b:1857:847c:366c])
        by smtp.gmail.com with ESMTPSA id ku4-20020a170903288400b001943d58268csm8745658plb.55.2023.03.07.10.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 10:59:36 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Christian Brauner <brauner@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 5.15 08/11] fs: move should_remove_suid()
Date:   Tue,  7 Mar 2023 10:59:19 -0800
Message-Id: <20230307185922.125907-9-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230307185922.125907-1-leah.rumancik@gmail.com>
References: <20230307185922.125907-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

commit e243e3f94c804ecca9a8241b5babe28f35258ef4 upstream.

Move the helper from inode.c to attr.c. This keeps the the core of the
set{g,u}id stripping logic in one place when we add follow-up changes.
It is the better place anyway, since should_remove_suid() returns
ATTR_KILL_S{G,U}ID flags.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/attr.c  | 29 +++++++++++++++++++++++++++++
 fs/inode.c | 29 -----------------------------
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 686840aa91c8..f045431bab1a 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -20,6 +20,35 @@
 
 #include "internal.h"
 
+/*
+ * The logic we want is
+ *
+ *	if suid or (sgid and xgrp)
+ *		remove privs
+ */
+int should_remove_suid(struct dentry *dentry)
+{
+	umode_t mode = d_inode(dentry)->i_mode;
+	int kill = 0;
+
+	/* suid always must be killed */
+	if (unlikely(mode & S_ISUID))
+		kill = ATTR_KILL_SUID;
+
+	/*
+	 * sgid without any exec bits is just a mandatory locking mark; leave
+	 * it alone.  If some exec bits are set, it's a real sgid; kill it.
+	 */
+	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
+		kill |= ATTR_KILL_SGID;
+
+	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
+		return kill;
+
+	return 0;
+}
+EXPORT_SYMBOL(should_remove_suid);
+
 /**
  * chown_ok - verify permissions to chown inode
  * @mnt_userns:	user namespace of the mount @inode was found from
diff --git a/fs/inode.c b/fs/inode.c
index a71fb82279bb..3811269259e1 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1864,35 +1864,6 @@ void touch_atime(const struct path *path)
 }
 EXPORT_SYMBOL(touch_atime);
 
-/*
- * The logic we want is
- *
- *	if suid or (sgid and xgrp)
- *		remove privs
- */
-int should_remove_suid(struct dentry *dentry)
-{
-	umode_t mode = d_inode(dentry)->i_mode;
-	int kill = 0;
-
-	/* suid always must be killed */
-	if (unlikely(mode & S_ISUID))
-		kill = ATTR_KILL_SUID;
-
-	/*
-	 * sgid without any exec bits is just a mandatory locking mark; leave
-	 * it alone.  If some exec bits are set, it's a real sgid; kill it.
-	 */
-	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
-		kill |= ATTR_KILL_SGID;
-
-	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
-		return kill;
-
-	return 0;
-}
-EXPORT_SYMBOL(should_remove_suid);
-
 /*
  * Return mask of changes for notify_change() that need to be done as a
  * response to write or truncate. Return 0 if nothing has to be changed.
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

