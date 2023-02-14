Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64E5696F8E
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 22:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjBNV1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 16:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbjBNV1P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 16:27:15 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400B21C580;
        Tue, 14 Feb 2023 13:26:39 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so103184pjq.0;
        Tue, 14 Feb 2023 13:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7pBezWEv5JYaH0rJ9igZpBfQr2zzlapuvLblecnISxw=;
        b=jQLMOBLOwZCJU8jWtiMsD/oWxkgnQk0ClgUt7y5aiD5yvM5A1eC65MkPWBwv8beKe9
         gveek6QI6V4cb3f+V2vwBwwrVuGOTJbdTatY/ovT3/75yJTDcN0i4XzJS7glZv5Jh5kp
         fiZPQRolwNdp6VcjG9pUHCSnHVOoAu0ySuMZe8BpoRiy/qSRoM24GNJHUhDmqC0VFhq+
         kVR+CQdhKEdIDPcfJfg7v9UcUkQTBWMmpAFiQ8L8XQNXTpLMRa/JBlCzAOVYqHS99JvP
         /m+DBd6C9dUtu5ScLE8iQ1QmvMCrrNrxKeNvux2YuCbYN/ox/lWlLNov/IFIdYKMwJQg
         0mkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7pBezWEv5JYaH0rJ9igZpBfQr2zzlapuvLblecnISxw=;
        b=0rJXYJ5Y4Gfc9jVV4xxuIo3HdhdkqTJe2A3mODdVyUiO070i/o9p+hhBozT1UgRrPg
         oFZ7aKCAQZuoLFEoL0upM4lhyrUrHJAQGDNdycVBmUY1ZYa8KfxYJ2uykMt856DEYe9Z
         ad08M4KR9mOc59rwmPvDVwIpvJ+9ZkapNc9qhFHOZkNpkrul0ZulEdRlLIBnqs5hQdiZ
         NXs3Z406BnTZI/LPY75Gmc21S1nwsqBi2mYSfJQZHLiq13qhTkSXSxgsrjqy73UKi38n
         cPwpYCgG8R1ktrbKTiBzxJ5aiGmY5QpNXnNHQl6iXjHGwUyhiozpjlff8ccGIeK6qG47
         TrEg==
X-Gm-Message-State: AO0yUKWZsugxrYtbjrBlCmhhNhaxS3NevMOayiXav7gOjB3g0bKXszxk
        0CWj/jR8pmrWu/0Vic+BoybMzRvws/uMhw==
X-Google-Smtp-Source: AK7set/iVbirS5ppQ3hkiQV54K+LfxPFVAvDMoo9ut2SxblnYt0oresbvwOj3qlKIySJ0GS52MGQtA==
X-Received: by 2002:a17:903:200a:b0:198:fc0a:192b with SMTP id s10-20020a170903200a00b00198fc0a192bmr27112pla.64.1676409974395;
        Tue, 14 Feb 2023 13:26:14 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cf14:3756:2b5e:fb87])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902654e00b00195f0fb0c18sm6692569pln.31.2023.02.14.13.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:26:13 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 08/10] xfs: assert in xfs_btree_del_cursor should take into account error
Date:   Tue, 14 Feb 2023 13:25:32 -0800
Message-Id: <20230214212534.1420323-9-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
In-Reply-To: <20230214212534.1420323-1-leah.rumancik@gmail.com>
References: <20230214212534.1420323-1-leah.rumancik@gmail.com>
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

[ Upstream commit 56486f307100e8fc66efa2ebd8a71941fa10bf6f ]

xfs/538 on a 1kB block filesystem failed with this assert:

XFS: Assertion failed: cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 || xfs_is_shutdown(cur->bc_mp), file: fs/xfs/libxfs/xfs_btree.c, line: 448

The problem was that an allocation failed unexpectedly in
xfs_bmbt_alloc_block() after roughly 150,000 minlen allocation error
injections, resulting in an EFSCORRUPTED error being returned to
xfs_bmapi_write(). The error occurred on extent-to-btree format
conversion allocating the new root block:

 RIP: 0010:xfs_bmbt_alloc_block+0x177/0x210
 Call Trace:
  <TASK>
  xfs_btree_new_iroot+0xdf/0x520
  xfs_btree_make_block_unfull+0x10d/0x1c0
  xfs_btree_insrec+0x364/0x790
  xfs_btree_insert+0xaa/0x210
  xfs_bmap_add_extent_hole_real+0x1fe/0x9a0
  xfs_bmapi_allocate+0x34c/0x420
  xfs_bmapi_write+0x53c/0x9c0
  xfs_alloc_file_space+0xee/0x320
  xfs_file_fallocate+0x36b/0x450
  vfs_fallocate+0x148/0x340
  __x64_sys_fallocate+0x3c/0x70
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xa

Why the allocation failed at this point is unknown, but is likely
that we ran the transaction out of reserved space and filesystem out
of space with bmbt blocks because of all the minlen allocations
being done causing worst case fragmentation of a large allocation.

Regardless of the cause, we've then called xfs_bmapi_finish() which
calls xfs_btree_del_cursor(cur, error) to tear down the cursor.

So we have a failed operation, error != 0, cur->bc_ino.allocated > 0
and the filesystem is still up. The assert fails to take into
account that allocation can fail with an error and the transaction
teardown will shut the filesystem down if necessary. i.e. the
assert needs to check "|| error != 0" as well, because at this point
shutdown is pending because the current transaction is dirty....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index b4b5bf4bfed7..482a4ccc6568 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -445,8 +445,14 @@ xfs_btree_del_cursor(
 			break;
 	}
 
+	/*
+	 * If we are doing a BMBT update, the number of unaccounted blocks
+	 * allocated during this cursor life time should be zero. If it's not
+	 * zero, then we should be shut down or on our way to shutdown due to
+	 * cancelling a dirty transaction on error.
+	 */
 	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 ||
-	       xfs_is_shutdown(cur->bc_mp));
+	       xfs_is_shutdown(cur->bc_mp) || error != 0);
 	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
 		kmem_free(cur->bc_ops);
 	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
-- 
2.39.1.581.gbfd45094c4-goog

