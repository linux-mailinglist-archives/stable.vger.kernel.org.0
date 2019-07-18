Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2FE6D70E
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 01:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391607AbfGRXGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 19:06:24 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42931 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbfGRXGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 19:06:24 -0400
Received: by mail-pg1-f195.google.com with SMTP id t132so13544158pgb.9;
        Thu, 18 Jul 2019 16:06:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VJUF/5trFajgFahlUUYT8qz+0thXGl5ABcEKwOEmlRc=;
        b=kvVBltyLyvqA7pcScUp1FY7c8Ri4TL1PXebnPMYlgZMQft97ege4YSv7zHKBC/vMJE
         1G2zZHL/jCuqphJi9/x5XdgO6Pgp+4dTDzSivzhq/xTZ9pFl81VBUzP5VDWCmrZn7kPU
         2FW78dC8uCE86Con5wmIuHntC/461/boHoj6lBv82hkvt8EgwMUGNBzceOubDhggWo/Y
         riN7d0/u9LuPoKlYb20Oxp2Qwv6ZQK96BWtFZpQvY/3r3lLmw2SEm61PM2Jc4+GQAUNB
         53dYS5M7qxi/VXcvSodHw6NTCmSkAJZbzpB1s9MEu0B/LXilUsyNWd1jg3wRQ/QZidMq
         VJGg==
X-Gm-Message-State: APjAAAWql7v7ptLW17AlUAqU4whgRwStPMYEMqv3RTLN87gnneRMmSYO
        8Adn+ggDUmgzKAnZ0xoLPhk=
X-Google-Smtp-Source: APXvYqwCKFchc13XPEg14/byJx9C1ThXkfzQjYp5e0uxhbDu7fDW7JSaLYy1pMlhRaKSdG99ZVS2/A==
X-Received: by 2002:a17:90a:cb18:: with SMTP id z24mr3762748pjt.108.1563491183476;
        Thu, 18 Jul 2019 16:06:23 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id t26sm22281932pgu.43.2019.07.18.16.06.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 16:06:19 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 44CF040906; Thu, 18 Jul 2019 23:06:19 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org,
        Alexander.Levin@microsoft.com
Cc:     stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org,
        zlang@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 4/9] xfs: rename m_inotbt_nores to m_finobt_nores
Date:   Thu, 18 Jul 2019 23:06:12 +0000
Message-Id: <20190718230617.7439-5-mcgrof@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190718230617.7439-1-mcgrof@kernel.org>
References: <20190718230617.7439-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit e1f6ca11381588e3ef138c10de60eeb34cb8466a upstream.

Rename this flag variable to imply more strongly that it's related to
the free inode btree (finobt) operation.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/libxfs/xfs_ag_resv.c      | 2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c | 4 ++--
 fs/xfs/xfs_inode.c               | 2 +-
 fs/xfs/xfs_mount.h               | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index e701ebc36c06..e2ba2a3b63b2 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -281,7 +281,7 @@ xfs_ag_resv_init(
 			 */
 			ask = used = 0;
 
-			mp->m_inotbt_nores = true;
+			mp->m_finobt_nores = true;
 
 			error = xfs_refcountbt_calc_reserves(mp, tp, agno, &ask,
 					&used);
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 86c50208a143..adb2f6df5a11 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -124,7 +124,7 @@ xfs_finobt_alloc_block(
 	union xfs_btree_ptr	*new,
 	int			*stat)
 {
-	if (cur->bc_mp->m_inotbt_nores)
+	if (cur->bc_mp->m_finobt_nores)
 		return xfs_inobt_alloc_block(cur, start, new, stat);
 	return __xfs_inobt_alloc_block(cur, start, new, stat,
 			XFS_AG_RESV_METADATA);
@@ -157,7 +157,7 @@ xfs_finobt_free_block(
 	struct xfs_btree_cur	*cur,
 	struct xfs_buf		*bp)
 {
-	if (cur->bc_mp->m_inotbt_nores)
+	if (cur->bc_mp->m_finobt_nores)
 		return xfs_inobt_free_block(cur, bp);
 	return __xfs_inobt_free_block(cur, bp, XFS_AG_RESV_METADATA);
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 05db9540e459..ae07baa7bdbf 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1754,7 +1754,7 @@ xfs_inactive_ifree(
 	 * now remains allocated and sits on the unlinked list until the fs is
 	 * repaired.
 	 */
-	if (unlikely(mp->m_inotbt_nores)) {
+	if (unlikely(mp->m_finobt_nores)) {
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ifree,
 				XFS_IFREE_SPACE_RES(mp), 0, XFS_TRANS_RESERVE,
 				&tp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7964513c3128..7e0bf952e087 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -127,7 +127,7 @@ typedef struct xfs_mount {
 	struct mutex		m_growlock;	/* growfs mutex */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
 	uint64_t		m_flags;	/* global mount flags */
-	bool			m_inotbt_nores; /* no per-AG finobt resv. */
+	bool			m_finobt_nores; /* no per-AG finobt resv. */
 	int			m_ialloc_inos;	/* inodes in inode allocation */
 	int			m_ialloc_blks;	/* blocks in inode allocation */
 	int			m_ialloc_min_blks;/* min blocks in sparse inode
-- 
2.20.1

