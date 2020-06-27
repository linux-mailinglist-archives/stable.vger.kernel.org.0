Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C1C20BDEE
	for <lists+stable@lfdr.de>; Sat, 27 Jun 2020 05:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgF0DdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 23:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgF0DdM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 23:33:12 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87FCC2081A;
        Sat, 27 Jun 2020 03:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593228791;
        bh=kYBrWgpkD09EFRRINdXBWE+WX92EPwTLFpw8go+67L0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GMR1KjyOama8yvciOUu3vjptd29wpsI2eRQJQtJQm3hXZverdL+WAX9a9sPLo9FpE
         Glav6k6yVaSQximhWsyspQxtz8dda7FxMxqRQgWhib9EFpLL9uIYYBYFnf69HpM0BT
         IuLTOwRv6adN6tQk/+q8bPtbyZUqdqDNtLzBLQvA=
Date:   Fri, 26 Jun 2020 20:33:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        stable@vger.kernel.org
Subject:  [merged] ocfs2-load-global_inode_alloc.patch removed from
 -mm tree
Message-ID: <20200627033311.UF57j4kmi%akpm@linux-foundation.org>
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: load global_inode_alloc
has been removed from the -mm tree.  Its filename was
     ocfs2-load-global_inode_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: load global_inode_alloc

Set global_inode_alloc as OCFS2_FIRST_ONLINE_SYSTEM_INODE, that will make
it load during mount.  It can be used to test whether some global/system
inodes are valid.  One use case is that nfsd will test whether root inode
is valid.

Link: http://lkml.kernel.org/r/20200616183829.87211-3-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/ocfs2_fs.h~ocfs2-load-global_inode_alloc
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -326,8 +326,8 @@ struct ocfs2_system_inode_info {
 enum {
 	BAD_BLOCK_SYSTEM_INODE = 0,
 	GLOBAL_INODE_ALLOC_SYSTEM_INODE,
+#define OCFS2_FIRST_ONLINE_SYSTEM_INODE GLOBAL_INODE_ALLOC_SYSTEM_INODE
 	SLOT_MAP_SYSTEM_INODE,
-#define OCFS2_FIRST_ONLINE_SYSTEM_INODE SLOT_MAP_SYSTEM_INODE
 	HEARTBEAT_SYSTEM_INODE,
 	GLOBAL_BITMAP_SYSTEM_INODE,
 	USER_QUOTA_SYSTEM_INODE,
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are


