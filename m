Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8FE574453
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 07:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbiGNFL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 01:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiGNFL2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 01:11:28 -0400
Received: from mail1.bemta32.messagelabs.com (mail1.bemta32.messagelabs.com [195.245.230.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26E81B2;
        Wed, 13 Jul 2022 22:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1657775485; i=@fujitsu.com;
        bh=ce5rFtpD63i9NoWjofskEeaLg2B6cdYBQg8AJsl2P0E=;
        h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=c3B/TqJqOIVn0/toSoCIe+IJrYvBaonA+I8xX+CxmGX4QAnX9/Os4hHxkiSePS9sq
         tzM0EdBR8HLgdaxo90BzQR8XQE4GCDKkDS4DZP1yni9TxeopSwB8caiXxUauLOZM0y
         b8THwMYNw7E3pTV9BNCu0RtQmgBCZxpPqnyiOeJeCXxulokmjWcOvvsLDcYQ3LidxQ
         4M0NSM6OzoM7dJkBLSXg3s0AfZzqHSYnvsaZHsIE3rf6Gq26nZgXnaBfjghaTiaNQb
         pEWvKlJjeYhKyQDPPH9ZXv2oXvAzk7pmh0h4e0KlN60Pbwe5y/wGXmSztdKVtio9KS
         IVJ7pf4jDt0hQ==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleJIrShJLcpLzFFi42Kxs+FI1K1Zej7
  J4PN6EYvXhz8xWny4OYnJYsuxe4wWl5/wWfxctordYs/ekywWP27dYLFYsPERo8X5v8dZLX7/
  mMPmwOVxapGEx+YVWh6bVnWyeZxZcITd4/MmOY9NT94yBbBFsWbmJeVXJLBmbPrVwlLwmrPix
  SnvBsa9HF2MnBxCAlsYJZbuc+li5AKylzNJnOyZzwSR2MMosbqLGcRmE9CUeNa5AMwWEXCUeN
  E+gwXEZha4zigxs90MxBYWcJY4+XsVK4jNIqAqsWL7TLAaXgEPiTNHzoPFJQQUJKY8fA82h1P
  AU+L4rc2MELs8JJbfWsgEUS8ocXLmE6j5EhIHX7xghuhVlLjU8Y0Rwq6QeH34ElRcTeLquU3M
  ExgFZyFpn4WkfQEj0ypGy6SizPSMktzEzBxdQwMDXUNDU11DXVNLvcQq3US91FLd8tTiEl1Dv
  cTyYr3U4mK94src5JwUvbzUkk2MwBhKKWa03sHY0fdT7xCjJAeTkijv7UXnk4T4kvJTKjMSiz
  Pii0pzUosPMcpwcChJ8MovBsoJFqWmp1akZeYA4xkmLcHBoyTC+xSklbe4IDG3ODMdInWKUVF
  KnDdmCVBCACSRUZoH1wZLIZcYZaWEeRkZGBiEeApSi3IzS1DlXzGKczAqCfPKg0zhycwrgZv+
  CmgxE9BiucgzIItLEhFSUg1M810fCs4Sll/f7fogrqihzY5BYJ7OcTP2ew6fDDs8suPsY1lDH
  94+nmSX7zXX2kleMvdAz+ZLqvvstjPWnomJLHi8tvZ+2jrj9Ir6/Ss5Z8qKn1un77lxy07rrk
  XMRae7rhbuqRYRPz9ftlg4wi2hKumUT7Nf8vIQh9k3w3MSDy568G3Ogu+un5l5q5JFj6hNWH/
  Y5crhvU6eN0xvXmRU2GUvk91wSexL48L4pcYSfqZyvYpFqlqbjN18U+U4L/exptosTRY/oWaj
  soFJ8U+i3iGNeR0Loz54NDXPtWs22XHt+HSnTC0mw0a9JN67hj0M23O2ys0o3/dcfbqUqf9+4
  37ZUA+WOJf/RS05SizFGYmGWsxFxYkAmG7HoZwDAAA=
X-Env-Sender: xuyang2018.jy@fujitsu.com
X-Msg-Ref: server-6.tower-591.messagelabs.com!1657775484!253594!1
X-Originating-IP: [62.60.8.97]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 16192 invoked from network); 14 Jul 2022 05:11:24 -0000
Received: from unknown (HELO n03ukasimr01.n03.fujitsu.local) (62.60.8.97)
  by server-6.tower-591.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 14 Jul 2022 05:11:24 -0000
Received: from n03ukasimr01.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTP id DCDB5100197;
        Thu, 14 Jul 2022 06:11:23 +0100 (BST)
Received: from R01UKEXCASM126.r01.fujitsu.local (R01UKEXCASM126 [10.183.43.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTPS id CF4F3100190;
        Thu, 14 Jul 2022 06:11:23 +0100 (BST)
Received: from localhost.localdomain (10.167.220.84) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Thu, 14 Jul 2022 06:11:19 +0100
From:   Yang Xu <xuyang2018.jy@fujitsu.com>
To:     <linux-fsdevel@vger.kernel.org>, <ceph-devel@vger.kernel.org>
CC:     <viro@zeniv.linux.org.uk>, <david@fromorbit.com>,
        <djwong@kernel.org>, <brauner@kernel.org>, <willy@infradead.org>,
        <jlayton@kernel.org>, <xuyang2018.jy@fujitsu.com>,
        <pvorel@suse.cz>, <stable@vger.kernel.org>
Subject: [PATCH v10 2/4] fs: Add missing umask strip in vfs_tmpfile
Date:   Thu, 14 Jul 2022 14:11:26 +0800
Message-ID: <1657779088-2242-2-git-send-email-xuyang2018.jy@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1657779088-2242-1-git-send-email-xuyang2018.jy@fujitsu.com>
References: <1657779088-2242-1-git-send-email-xuyang2018.jy@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.220.84]
X-ClientProxiedBy: G08CNEXCHPEKD08.g08.fujitsu.local (10.167.33.83) To
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178)
X-Virus-Scanned: ClamAV using ClamSMTP
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-and-Tested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
---
 fs/namei.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/namei.c b/fs/namei.c
index 1f28d3f463c3..ac4225ad6ac4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3565,6 +3565,8 @@ struct dentry *vfs_tmpfile(struct user_namespace *mnt_userns,
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

