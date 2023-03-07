Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB8D6AF47C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbjCGTRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbjCGTP7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:15:59 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3A8D6E8E;
        Tue,  7 Mar 2023 10:59:30 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u5so15167814plq.7;
        Tue, 07 Mar 2023 10:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678215570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rRwd4y2CL9MgXEkMrjTHLqtYjZ1aeFX8aqeqmMGCm58=;
        b=ApeTZjbC4tczaTcklWa47crmSBYizvjhuicla9VTJYg7J9V6ikJuxhDqeWdhOBiYfI
         kBPv6xIapfLnzLcusZMoHPoMHAFYpVsDsKRhKnjJtVhyEOxUKXPVbbjRs+aw/oyo8nnz
         Rm9aT486rVraiK1HOwC+iWzq/XMjvQprHkp6it1uNKCyljXQauuBNrU94i0vaFiJQVH2
         YuEZhWhGeTg2870ynqBFxxKRJAUGFPmf0gTWQhcMovFhFboAp7nUogEMxLVGLN6JMi82
         xRs0JfxU/a2euxM9YcHxjovasRRayphm7QeaUNyZCtrNEG9f4jSHIA06s/5fwRup0hbV
         i0gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678215570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rRwd4y2CL9MgXEkMrjTHLqtYjZ1aeFX8aqeqmMGCm58=;
        b=FYD9l/a4Gvs0DZfGUnk8sCcbTOvUMBlr2eLScH6BNAC90nKHXLXvXjK4HTPARIHZ8L
         I6bzsKaF9EzluKs7v0+2bqUeLgA56TojzbbyIXOsaafhtxveyqlM8wZCFAYKGHNdz/yl
         SqhHboXZl1yLJTzma8Ppg3ffhQmmssvjv9W+4C9bmDC1qkayHfT93zdbgZ/onr/GD0In
         1u/IetQk0Q7A3kV4NHUL+vaZWCGxdM2WsPR9DqLVWkEU/JQeaeV2iMX23HqX/jDJ1Xkd
         BQbagLVCYPsxgkQnUFWjtSQXHSzEoNjx+eezDYyd97U8nAViCbWh6tor8KBEJNyeKqEE
         m7VQ==
X-Gm-Message-State: AO0yUKUz45E2MgxDTxCKxycCJD+g/htLxLhpL82SuqE4yqFE9t9Cz55U
        foaXM+3UbKPz0/0IwlI02M3Pz2BRqNeKFA==
X-Google-Smtp-Source: AK7set8fz4gE/jqiW+mW9U4OApcISBcQxqBp20TQMiyQWB8OofhHW1leV+RSUlIGzXIAHb48CGfISQ==
X-Received: by 2002:a17:902:e884:b0:19e:845d:d898 with SMTP id w4-20020a170902e88400b0019e845dd898mr16955433plg.14.1678215570140;
        Tue, 07 Mar 2023 10:59:30 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:6f2b:1857:847c:366c])
        by smtp.gmail.com with ESMTPSA id ku4-20020a170903288400b001943d58268csm8745658plb.55.2023.03.07.10.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 10:59:29 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 03/11] xfs: fallocate() should call file_modified()
Date:   Tue,  7 Mar 2023 10:59:14 -0800
Message-Id: <20230307185922.125907-4-leah.rumancik@gmail.com>
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

From: Dave Chinner <dchinner@redhat.com>

commit fbe7e520036583a783b13ff9744e35c2a329d9a4 upsream.

In XFS, we always update the inode change and modification time when
any fallocate() operation succeeds.  Furthermore, as various
fallocate modes can change the file contents (extending EOF,
punching holes, zeroing things, shifting extents), we should drop
file privileges like suid just like we do for a regular write().
There's already a VFS helper that figures all this out for us, so
use that.

The net effect of this is that we no longer drop suid/sgid if the
caller is root, but we also now drop file capabilities.

We also move the xfs_update_prealloc_flags() function so that it now
is only called by the scope that needs to set the the prealloc flag.

Based on a patch from Darrick Wong.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 752b676c92e3..020e0a412287 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -954,6 +954,10 @@ xfs_file_fallocate(
 			goto out_unlock;
 	}
 
+	error = file_modified(file);
+	if (error)
+		goto out_unlock;
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
@@ -1055,11 +1059,12 @@ xfs_file_fallocate(
 			if (error)
 				goto out_unlock;
 		}
-	}
 
-	error = xfs_update_prealloc_flags(ip, flags);
-	if (error)
-		goto out_unlock;
+		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
+		if (error)
+			goto out_unlock;
+
+	}
 
 	/* Change file size if needed */
 	if (new_size) {
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

