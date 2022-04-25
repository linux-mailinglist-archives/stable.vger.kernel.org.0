Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D502450D6D7
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 04:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240281AbiDYCM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Apr 2022 22:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234055AbiDYCM1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Apr 2022 22:12:27 -0400
Received: from mail1.bemta36.messagelabs.com (mail1.bemta36.messagelabs.com [85.158.142.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DDC25C68;
        Sun, 24 Apr 2022 19:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1650852563; i=@fujitsu.com;
        bh=30ZvrW538VuKPhtUqh2TRm5bCNN23cqvHbhM9dcZbpI=;
        h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=C2MLwghZNj1dcgd35wsY9mEpJpyphyDfq69zluuvWv9TOOR+Cn13E4GHw1tIPphSG
         xjUeldsqhozJN0Q8f7cAOyV7LC3sfoe269BIoy8z+ueZ9wf1uiayq9W8oZ0hDHz4Nq
         KR3ffRBkPx/OuO2bZtKYmyjO/8ehs//NHrtUubFr9NADhWpRNHF7QTu9ob//pwCoYI
         bLekSCZlNONUk/kBz90nXYwE7Kb+kwWwYtosw7xYqvZ3eEzR4nLcYx/6x4DQa885YI
         MoE8NQotciO1Dk1yVXODkCebgo8USlfuJ+qVIpKEWaCnXOM4rZpt++a7leIw0DRrgz
         7X0bLALPlXqBQ==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRWlGSWpSXmKPExsViZ8MRonuRKS3
  JYM43RYvXhz8xWny4OYnJYsuxe4wWl5/wWfxctordYs/ekywWCzY+YrQ4//c4q8XvH3PYHDg9
  Ti2S8Ni8Qstj06pONo/Pm+Q8Nj15yxTAGsWamZeUX5HAmrF4/l7WgkbOildfihsY77B3MXJyC
  Am8ZpSY9U4Rwt7DKNF4mRPEZhPQlHjWuYAZxBYRcJR40T6DBcRmFrjDKHH6cSiILSzgJLG0/y
  YbiM0ioCrxb/VnVhCbV8BT4vOlf2BxCQEFiSkP34PN4RTwkri24iQbxC5Pib87nzFB1AtKnJz
  5BGq+hMTBFy+YIXoVJS51fGOEsCskZs1qY5rAyD8LScssJC0LGJlWMdolFWWmZ5TkJmbm6Boa
  GOgaGprqmpnpGlqY6SVW6SbqpZbqJqfmlRQlAqX1EsuL9VKLi/WKK3OTc1L08lJLNjEC4yCl2
  GnXDsaDfT/1DjFKcjApifJmMKYlCfEl5adUZiQWZ8QXleakFh9ilOHgUJLgDfufmiQkWJSanl
  qRlpkDjEmYtAQHj5II748fQGne4oLE3OLMdIjUKUZFKXFeB5CZAiCJjNI8uDZYGrjEKCslzMv
  IwMAgxFOQWpSbWYIq/4pRnINRSZi3CmQKT2ZeCdz0V0CLmYAWf6oFW1ySiJCSamDSsVrBtDl/
  6mN2/QUrb6adPrNqp/+er51P07eU7TeY/t/07eJ7xjuZZn33WMXe+mH9aQ/eAypznsTFvtdMu
  Zq/8EuR54K7LvybLGc9WnciRyciume5VI5LwKmXP/1P8Dt9Oj4z6AL7Q1n5vMaFVUFn84/s15
  E3tVB37Nr54+B/s7iSm8dlrRw7vkR2ntvF9yT33KOs3u6Wugnfojh8c9jPPZ050fRk5KVp05Y
  IfXivVj5/4ewjMeuYS+65n/3//LDxvEXL+mfpBMobRzkJd2Z5P7kb0a2nELnIbvu+hf/0JLev
  /SWl+vKg82q1iqmci4Nl5Od2N/0oaZR7ub5h2q8KpRUrKhZwbs4SlHBSLDTPVmIpzkg01GIuK
  k4EACkrF3R+AwAA
X-Env-Sender: xuyang2018.jy@fujitsu.com
X-Msg-Ref: server-17.tower-545.messagelabs.com!1650852561!108109!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.85.8; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 12610 invoked from network); 25 Apr 2022 02:09:21 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-17.tower-545.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 25 Apr 2022 02:09:21 -0000
Received: from R01UKEXCASM126.r01.fujitsu.local ([10.183.43.178])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with ESMTP id 23P2922a010430
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 25 Apr 2022 03:09:08 +0100
Received: from localhost.localdomain (10.167.220.84) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Mon, 25 Apr 2022 03:08:48 +0100
From:   Yang Xu <xuyang2018.jy@fujitsu.com>
To:     <linux-fsdevel@vger.kernel.org>, <ceph-devel@vger.kernel.org>
CC:     <viro@zeniv.linux.org.uk>, <david@fromorbit.com>,
        <djwong@kernel.org>, <brauner@kernel.org>, <willy@infradead.org>,
        <jlayton@kernel.org>, Yang Xu <xuyang2018.jy@fujitsu.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v6 2/4] fs: Add missing umask strip in vfs_tmpfile
Date:   Mon, 25 Apr 2022 11:09:39 +0800
Message-ID: <1650856181-21350-2-git-send-email-xuyang2018.jy@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1650856181-21350-1-git-send-email-xuyang2018.jy@fujitsu.com>
References: <1650856181-21350-1-git-send-email-xuyang2018.jy@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.220.84]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178)
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

