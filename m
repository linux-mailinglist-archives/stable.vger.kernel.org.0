Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB0F6AF46F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbjCGTQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjCGTQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:00 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8AF9FE6F;
        Tue,  7 Mar 2023 10:59:29 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id p20so15138192plw.13;
        Tue, 07 Mar 2023 10:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678215569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KOXF001rhRxZuqFFDlNcwqSqhf9g7Mw9x8kZ8yl6lH8=;
        b=pXW4sldrNoI1/DCOpMzWxDH740WtYrVE7E1BxA1dscco7kL5VvwXX+rK91yUZP9TrC
         yrRKVeUYEZrEa46YwSM8AFHpgXlLmH9IbmAzCI2+fVAvd6SdmyHAtcLqB9FRV/jP60uK
         CsJ9RM7tbBv8m3Ji3jiD0huYpP9UwN+oBorCLOSh5/3NXkZCZp86JEJn09Vhu9xrFf2f
         NmU0Lz2GXhik4PT0JeGrn0cpgYYdLTazLWG8rwE9uB4xvm/eGsMN0AzJs6vC3qJnNMK5
         MgFe6uLWTO11LZHfUcOtOmZt0s2e7/4m+lJ908YU9Y3TJTycdEVwtDkUEEOswEVbEwKO
         DgGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678215569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KOXF001rhRxZuqFFDlNcwqSqhf9g7Mw9x8kZ8yl6lH8=;
        b=TU7hYJbeMfrqwrFrtA9CRSqlMFFG08E861ulQMknIJZesBHFRreXxTmoyq6vlGxyJr
         GRnkm4/jA/zQ6FFq2PSLjQR/9H3EsB+opyE7akLT/PqLeqfJfDFqgfC5NE+iW7nhOUR6
         Dsi16iTO/FCNftqDXgMQfXVTUMh+c7G3mznU0RJpz0UhMVlH0SFd6LVeVL64jCLbYvB2
         QGLkWaO42Gd3pylwBHqI8sbiEthLOH4uXA3kGBgCV8ZRZNt5WE+sDQwH5Gd6r484YOyj
         NSADJsm//OixMqKz1U3w0VdzUM+x0gWTO3qRPxqulOlgZIhnskq6kSDSdipva9BzQBGv
         ZExQ==
X-Gm-Message-State: AO0yUKX2ulCrDP3j7CvdRyk3NDqSXZbZdpwzVaCYqmCUM7DapSMVMbGf
        h14BXjykAcOl42F5l4KEsVK2FQmzVHA1JA==
X-Google-Smtp-Source: AK7set84HdqY+mXTzkl/AOQcapYHtvlZ+FGxAOT3cDo+doddvtLrCFJfYUktX5LTMz1i2oNEJDe8hw==
X-Received: by 2002:a17:902:d4cf:b0:19c:eb9a:7712 with SMTP id o15-20020a170902d4cf00b0019ceb9a7712mr21434710plg.1.1678215569114;
        Tue, 07 Mar 2023 10:59:29 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:6f2b:1857:847c:366c])
        by smtp.gmail.com with ESMTPSA id ku4-20020a170903288400b001943d58268csm8745658plb.55.2023.03.07.10.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 10:59:28 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 02/11] xfs: remove XFS_PREALLOC_SYNC
Date:   Tue,  7 Mar 2023 10:59:13 -0800
Message-Id: <20230307185922.125907-3-leah.rumancik@gmail.com>
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

commit 472c6e46f589c26057596dcba160712a5b3e02c5 upstream.

[partial backport for dependency -
 xfs_ioc_space() still uses XFS_PREALLOC_SYNC]

Callers can acheive the same thing by calling xfs_log_force_inode()
after making their modifications. There is no need for
xfs_update_prealloc_flags() to do this.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 13 +++++++------
 fs/xfs/xfs_pnfs.c |  6 ++++--
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 240eb932c014..752b676c92e3 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -95,8 +95,6 @@ xfs_update_prealloc_flags(
 		ip->i_diflags &= ~XFS_DIFLAG_PREALLOC;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	if (flags & XFS_PREALLOC_SYNC)
-		xfs_trans_set_sync(tp);
 	return xfs_trans_commit(tp);
 }
 
@@ -1059,9 +1057,6 @@ xfs_file_fallocate(
 		}
 	}
 
-	if (file->f_flags & O_DSYNC)
-		flags |= XFS_PREALLOC_SYNC;
-
 	error = xfs_update_prealloc_flags(ip, flags);
 	if (error)
 		goto out_unlock;
@@ -1084,8 +1079,14 @@ xfs_file_fallocate(
 	 * leave shifted extents past EOF and hence losing access to
 	 * the data that is contained within them.
 	 */
-	if (do_file_insert)
+	if (do_file_insert) {
 		error = xfs_insert_file_space(ip, offset, len);
+		if (error)
+			goto out_unlock;
+	}
+
+	if (file->f_flags & O_DSYNC)
+		error = xfs_log_force_inode(ip);
 
 out_unlock:
 	xfs_iunlock(ip, iolock);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 8865f7d4404a..3a82a13d880c 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -164,10 +164,12 @@ xfs_fs_map_blocks(
 		 * that the blocks allocated and handed out to the client are
 		 * guaranteed to be present even after a server crash.
 		 */
-		error = xfs_update_prealloc_flags(ip,
-				XFS_PREALLOC_SET | XFS_PREALLOC_SYNC);
+		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
+		if (!error)
+			error = xfs_log_force_inode(ip);
 		if (error)
 			goto out_unlock;
+
 	} else {
 		xfs_iunlock(ip, lock_flags);
 	}
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

