Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F89A6AF466
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbjCGTQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233655AbjCGTQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:10 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4622FD6E91;
        Tue,  7 Mar 2023 10:59:32 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so12764410pjg.4;
        Tue, 07 Mar 2023 10:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678215571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pRdmyL8Qwyge+Rj02qOUtmgEn96ygPNBRveL38n1eeE=;
        b=qzRecHSmuKokPRP1CoJroMBeiDxUqXQR7ebQ1nPF3o7Z0vCfEeR6JjLbW4B4blmKUd
         9FsfDurZ33wQEzekLxd2zZWrKeLvocaq+4DUq0P4Cb6BLgU0DYCX6zs4wYgjYbPidUdO
         BnTUm4lUhncZOkTKxGKXsnx1Fx4wYoF08dgDbPZDOfGWpO+9l4aACIiDog/xPRhGEABV
         kR82tiBXq9sMXVPAPD28hoYvGhqHXT19jp0M8lP/ISHYMyO1j9iZUR0FwKOn1O1LGdGm
         VBz0UG0x++2Z59rgolcrC1Tcy7gf+uRuUYyobWes9ZQ692SzNNC93gtbHcvrcMaVCy0p
         Xq4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678215571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pRdmyL8Qwyge+Rj02qOUtmgEn96ygPNBRveL38n1eeE=;
        b=QlH1Sb3Kt/OAOELeIs/JahwsOqxv0jTQhFXCBknXm6Q9k7N8bmnRZgbLFBDEOxc9Uh
         EOQJmYYHOeiSbJQoFd1lO+9EcM1DTeLszdbolHGmKzM5XzMgVwlmZ49j4pzXpBx+ugmL
         /rBtuxMWRv5UCN70pjxPaqb+DGbwFTdDreJDk1kZnQUvsgut22Md1UGKxa4bDhSGqMwA
         5jnXjyWu4n9PQxSKlY4cghvJ5b77Qamm5BvC1fXq1m2w9edeN4xosqgpCRj4WOs4n+W6
         0k4ARPNgt/2pxfmndfZOWbqSmOuWXzU4wq4vFApuH746PLYKnRmIfb+wJY7mdsaYOK2y
         nq1w==
X-Gm-Message-State: AO0yUKUfiy4lpqmPnYpotqxi0faJ+Il/xY1IQlrgteHRSkRm5CyfnP9K
        ChEW0tdXHZDxxV6h0Wlay/2xdjjWIank5w==
X-Google-Smtp-Source: AK7set+cFopbxWiAQ5wLMH/J/f+mkxXjSSw5OFzphbMOxKG9AwI13dsdGKQbw/4gH0TGK/iuLbFXww==
X-Received: by 2002:a17:902:cec1:b0:198:adc4:229d with SMTP id d1-20020a170902cec100b00198adc4229dmr17488408plg.24.1678215571464;
        Tue, 07 Mar 2023 10:59:31 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:6f2b:1857:847c:366c])
        by smtp.gmail.com with ESMTPSA id ku4-20020a170903288400b001943d58268csm8745658plb.55.2023.03.07.10.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 10:59:30 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 04/11] xfs: set prealloc flag in xfs_alloc_file_space()
Date:   Tue,  7 Mar 2023 10:59:15 -0800
Message-Id: <20230307185922.125907-5-leah.rumancik@gmail.com>
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

commit 0b02c8c0d75a738c98c35f02efb36217c170d78c upsream.

Now that we only call xfs_update_prealloc_flags() from
xfs_file_fallocate() in the case where we need to set the
preallocation flag, do this in xfs_alloc_file_space() where we
already have the inode joined into a transaction and get
rid of the call to xfs_update_prealloc_flags() from the fallocate
code.

This also means that we now correctly avoid setting the
XFS_DIFLAG_PREALLOC flag when xfs_is_always_cow_inode() is true, as
these inodes will never have preallocated extents.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 9 +++------
 fs/xfs/xfs_file.c      | 8 --------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 73a36b7be3bd..fd2ad6a3019c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -851,9 +851,6 @@ xfs_alloc_file_space(
 			rblocks = 0;
 		}
 
-		/*
-		 * Allocate and setup the transaction.
-		 */
 		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
 				dblocks, rblocks, false, &tp);
 		if (error)
@@ -870,9 +867,9 @@ xfs_alloc_file_space(
 		if (error)
 			goto error;
 
-		/*
-		 * Complete the transaction
-		 */
+		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
 		error = xfs_trans_commit(tp);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 020e0a412287..8cd0c3df253f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -909,7 +909,6 @@ xfs_file_fallocate(
 	struct inode		*inode = file_inode(file);
 	struct xfs_inode	*ip = XFS_I(inode);
 	long			error;
-	enum xfs_prealloc_flags	flags = 0;
 	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	loff_t			new_size = 0;
 	bool			do_file_insert = false;
@@ -1007,8 +1006,6 @@ xfs_file_fallocate(
 		}
 		do_file_insert = true;
 	} else {
-		flags |= XFS_PREALLOC_SET;
-
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		    offset + len > i_size_read(inode)) {
 			new_size = offset + len;
@@ -1059,11 +1056,6 @@ xfs_file_fallocate(
 			if (error)
 				goto out_unlock;
 		}
-
-		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
-		if (error)
-			goto out_unlock;
-
 	}
 
 	/* Change file size if needed */
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

