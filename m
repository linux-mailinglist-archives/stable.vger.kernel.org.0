Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAD950FA90
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 12:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349041AbiDZKdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 06:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349130AbiDZKda (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 06:33:30 -0400
Received: from mail1.bemta36.messagelabs.com (mail1.bemta36.messagelabs.com [85.158.142.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E13152796;
        Tue, 26 Apr 2022 03:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1650967853; i=@fujitsu.com;
        bh=8H4EYBmAmvlD4ppPy7czpIZvvSugYPtrUgavqYgtwHU=;
        h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=gjIsZW/AWk7M/XjvMS2pZ8n9BXA1IqIEqdxvSlJmIoP6+U0NTbD1JqJxiF1yg6ZzL
         E9z83my0iCXePoD31kRpR1zcgtDmOFMpHnVyYI7E3JnTqZeT2GDFVdaCiBcO0b2iO0
         0jW0WYOz5968oFYxGFefHphj9vpxBhARifxwUCl5y5/SznhLCyurJx84mWtkFAcRUa
         Xc+PKzgyMv4ZE1PXJZhrooMC3Sa40+JYgQRVWethGgCXZmoUaEoQ0iQX1Vrm0RvpSR
         dZyO/vvLh5bHpKE4KJJRGSVc7oUHOnH0EfuuPWTaQcFE1xNSBH0SDL8/kBfXi6f43X
         I8qL4VnexuZ1Q==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleJIrShJLcpLzFFi42Kxs+FI1NU5mp5
  k8GWeusXrw58YLT7cnMRkseXYPUaLy0/4LH4uW8VusWfvSRaLBRsfMVqc/3uc1eL3jzlsDpwe
  pxZJeGxeoeWxaVUnm8fnTXIem568ZQpgjWLNzEvKr0hgzZi79y1zwSbOig0TdrE3MHZwdDFyc
  QgJbGGUuDz5JBOEs4BJYvW5Q4xdjJxAzh5GiZ8bokFsNgFNiWedC5hBbBEBR4kX7TNYQBqYBc
  4ySnTMWMQOkhAWcJL4dnsTE4jNIqAq8XTVWjYQm1fAQ6L1zEWwZgkBBYkpD9+D2ZwCnhJv+6d
  ALfOQuLW8jwmiXlDi5MwnLCA2s4CExMEXL6B6FSUudXxjhLArJGbNamOCsNUkrp7bxDyBUXAW
  kvZZSNoXMDKtYrRLKspMzyjJTczM0TU0MNA1NDTVNTPTNbQw00us0k3USy3VTU7NKylKBErrJ
  ZYX66UWF+sVV+Ym56To5aWWbGIExk9KsdOuHYwH+37qHWKU5GBSEuXV2ZeeJMSXlJ9SmZFYnB
  FfVJqTWnyIUYaDQ0mCN/AQUE6wKDU9tSItMwcYyzBpCQ4eJRHet4eB0rzFBYm5xZnpEKlTjIp
  S4rzL9wIlBEASGaV5cG2w9HGJUVZKmJeRgYFBiKcgtSg3swRV/hWjOAejkjDEeJ7MvBK46a+A
  FjMBLf5UmwqyuCQRISXVwKTiqe2+ZdlRq+D6dR3PQq+4WpzUq/x54+AqgcxHcwyNlkTNPZ52/
  cwe4/UVS0r+8mZbSYoELBPbdCX+do/P/jqtr87XmQR0Nus9UHrt+26C+EQOTY4DCifkbbQ8Hl
  R6SXXfnvPTKv7at/cHGgMNg75w27pwSd3z/GP0T5f9lt+rA918MfzVapFVL5VvvdfZcWPZlvl
  5QuHiRXtubdV5I3lUsjLr5eFP+09yrqu5WGF2zkrSUMJhNc9KvwcXQvQ/P6rbsKP5eFVpj7pX
  y/nfmw1aDjxVPF84xXV/a9n5O/2+POF3tvFELpty0kRpufFbDf11YhlH29KPCegZntfXWj1Le
  kroRDbLi/XzNt7xO6bEUpyRaKjFXFScCABvv5xnmgMAAA==
X-Env-Sender: xuyang2018.jy@fujitsu.com
X-Msg-Ref: server-17.tower-545.messagelabs.com!1650967852!237794!1
X-Originating-IP: [62.60.8.97]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.85.8; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 18532 invoked from network); 26 Apr 2022 10:10:52 -0000
Received: from unknown (HELO n03ukasimr01.n03.fujitsu.local) (62.60.8.97)
  by server-17.tower-545.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 26 Apr 2022 10:10:52 -0000
Received: from n03ukasimr01.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTP id EF25F1001A2;
        Tue, 26 Apr 2022 11:10:51 +0100 (BST)
Received: from R01UKEXCASM126.r01.fujitsu.local (unknown [10.183.43.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTPS id CCFB9100181;
        Tue, 26 Apr 2022 11:10:51 +0100 (BST)
Received: from localhost.localdomain (10.167.220.84) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Tue, 26 Apr 2022 11:10:39 +0100
From:   Yang Xu <xuyang2018.jy@fujitsu.com>
To:     <linux-fsdevel@vger.kernel.org>, <ceph-devel@vger.kernel.org>
CC:     <viro@zeniv.linux.org.uk>, <david@fromorbit.com>,
        <djwong@kernel.org>, <brauner@kernel.org>, <willy@infradead.org>,
        <jlayton@kernel.org>, Yang Xu <xuyang2018.jy@fujitsu.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v8 2/4] fs: Add missing umask strip in vfs_tmpfile
Date:   Tue, 26 Apr 2022 19:11:28 +0800
Message-ID: <1650971490-4532-2-git-send-email-xuyang2018.jy@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1650971490-4532-1-git-send-email-xuyang2018.jy@fujitsu.com>
References: <1650971490-4532-1-git-send-email-xuyang2018.jy@fujitsu.com>
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

