Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D92F50EF1C
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 05:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242880AbiDZDWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 23:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbiDZDWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 23:22:39 -0400
Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com [195.245.231.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C85939B3;
        Mon, 25 Apr 2022 20:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1650943171; i=@fujitsu.com;
        bh=8H4EYBmAmvlD4ppPy7czpIZvvSugYPtrUgavqYgtwHU=;
        h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=jkkgporBoA4Ux3kMbPf/FzsmiT8WrCB0YX7xhPQc7iknsE2PlSgsvVQP2aF0gpAKD
         3UWrWlrgWNFYIJwKY6YkyzUKoHMkTRIqnxz6NRKJrFCPSP+gg1263kip8ZGSJ+aL4O
         NAG5f2uqTg6gOs46MLle5kz7JlQHCjIyyqzf0hKJxlIrO5fYQoIQ2RHv8uckZBzk+l
         OQkU4kspTCDxcIwPAg4bufkOsk8g0O77U9pFl40GKG7dK1VDFjboU2fOwUJBWW46g3
         dkFj+xCAo++ud2H3ob+GwzQfJpxtOrFeO6Zij5AwaPU+dMrQPCyb+q+k9c5//+qBZG
         Kg0YmpP1r1BPw==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleJIrShJLcpLzFFi42Kxs+FI1D2Ykp5
  k0LtD1OL14U+MFh9uTmKy2HLsHqPF5Sd8Fj+XrWK32LP3JIvFgo2PGC3O/z3OavH7xxw2B06P
  U4skPDav0PLYtKqTzePzJjmPTU/eMgWwRrFm5iXlVySwZszd+5a5YBNnxYYJu9gbGDs4uhi5O
  IQEtjBKdK3/wQThLGCSWPx2FxuEs4dRYlrfKpYuRk4ONgFNiWedC5hBbBEBR4kX7TNYQIqYBc
  4ySnTMWMQOkhAWcJLYfPsFWAOLgKrEhtkLmEBsXgEPiZ5Ta8FqJAQUJKY8fA82iFPAU+LX8XY
  2EFsIqGbF0lmMEPWCEidnPgGbwywgIXHwxQtmiF5FiUsd3xgh7AqJWbPamCBsNYmr5zYxT2AU
  nIWkfRaS9gWMTKsYrZOKMtMzSnITM3N0DQ0MdA0NTXWNLXWNDAz0Eqt0E/VSS3XLU4tLdI30E
  suL9VKLi/WKK3OTc1L08lJLNjECYyelWP3EDsanK3/qHWKU5GBSEuXdkpSeJMSXlJ9SmZFYnB
  FfVJqTWnyIUYaDQ0mClxUkJ1iUmp5akZaZA4xjmLQEB4+SCG8ZSJq3uCAxtzgzHSJ1ilFRSpz
  XBRj9QgIgiYzSPLg2WOq4xCgrJczLyMDAIMRTkFqUm1mCKv+KUZyDUUmYlwNkCk9mXgnc9FdA
  i5mAFn+qTQVZXJKIkJJqYNowc+8M34V6f39enJ/y9hTnnqfGF6eGKEhUdp7sP3E6Yd83H7Gzq
  hN2LPG3q153aKaxruy7nz+XqYTycwUfzSzgqLBpr2qxWsCb8XWOVyqb4AGlY8FRmediJe2r50
  ++UR9qE7pxnrrbgkePJlno8HFMeCt74FSS3aNqkcDqV9OueXxWvZe+l0HwwV273IjdohlPvn3
  f+NNA4uJa2bB3U8/K/WvfLt1x+9GhUr+Tv/ff2sGz4FGBErN8dPHGp+kndrjeunTk3M49P6Qv
  TXJjFhJkrsqwvz9POJH59ledbP1IFpb4cDv5Bi7jgJ3JG//0nU6YemXvgm+uzk8Dr+2/m8y34
  SKX7v99Jozbz29Y2rtCiaU4I9FQi7moOBEA7/479JgDAAA=
X-Env-Sender: xuyang2018.jy@fujitsu.com
X-Msg-Ref: server-5.tower-565.messagelabs.com!1650943169!150990!1
X-Originating-IP: [62.60.8.97]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.85.8; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 16073 invoked from network); 26 Apr 2022 03:19:29 -0000
Received: from unknown (HELO n03ukasimr01.n03.fujitsu.local) (62.60.8.97)
  by server-5.tower-565.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 26 Apr 2022 03:19:29 -0000
Received: from n03ukasimr01.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTP id C0BC3100191;
        Tue, 26 Apr 2022 04:19:28 +0100 (BST)
Received: from R01UKEXCASM126.r01.fujitsu.local (unknown [10.183.43.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTPS id 985FA10004D;
        Tue, 26 Apr 2022 04:19:28 +0100 (BST)
Received: from localhost.localdomain (10.167.220.84) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Tue, 26 Apr 2022 04:19:00 +0100
From:   Yang Xu <xuyang2018.jy@fujitsu.com>
To:     <linux-fsdevel@vger.kernel.org>, <ceph-devel@vger.kernel.org>
CC:     <viro@zeniv.linux.org.uk>, <david@fromorbit.com>,
        <djwong@kernel.org>, <brauner@kernel.org>, <willy@infradead.org>,
        <jlayton@kernel.org>, Yang Xu <xuyang2018.jy@fujitsu.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v7 2/4] fs: Add missing umask strip in vfs_tmpfile
Date:   Tue, 26 Apr 2022 12:19:50 +0800
Message-ID: <1650946792-9545-2-git-send-email-xuyang2018.jy@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1650946792-9545-1-git-send-email-xuyang2018.jy@fujitsu.com>
References: <1650946792-9545-1-git-send-email-xuyang2018.jy@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.220.84]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178)
X-Virus-Scanned: ClamAV using ClamSMTP
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

All creation paths except for O_TMPFILE handle umask in the vfs directly
if the filesystem doesn't support or enable POSIX ACLs. If the filesystem
does then umask handling is deferred until posix_acl_create().
Because, O_TMPFILE misses umask handling in the vfs it will not honor
umask settings. Fix this by adding the missing umask handling.

Fixes: 60545d0d4610 ("[O_TMPFILE] it's still short a few helpers, but infrastructure should be OK now...")
Cc: <stable@vger.kernel.org> # 4.19+
Reported-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Acked-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
---
 fs/namei.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/namei.c b/fs/namei.c
index 509657fdf4f5..73646e28fae0 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3521,6 +3521,8 @@ struct dentry *vfs_tmpfile(struct user_namespace *mnt_userns,
 	child = d_alloc(dentry, &slash_name);
 	if (unlikely(!child))
 		goto out_err;
+	if (!IS_POSIXACL(dir))
+		mode &= ~current_umask();
 	error = dir->i_op->tmpfile(mnt_userns, dir, child, mode);
 	if (error)
 		goto out_err;
-- 
2.27.0

