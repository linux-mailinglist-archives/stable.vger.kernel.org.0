Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0425E52EEC5
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 17:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345840AbiETPK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 11:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241781AbiETPKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 11:10:24 -0400
Received: from mail1.bemta36.messagelabs.com (mail1.bemta36.messagelabs.com [85.158.142.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED58117706D;
        Fri, 20 May 2022 08:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1653059420; i=@fujitsu.com;
        bh=lKY9yswoHVpDbGbLhaeMQH9R5j0Sb+KVNk4RxWU9pOY=;
        h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=Re2la0jQBih2kCHYP7KntPHO6JK/c4nOGBslI7Whb21ofNHmcNHpJv9vB9bmhl+wB
         xosG8cbBOHSfzVZSy5tvvOJameMsUTqmA7yhgwYpgBDuwt28ROQQ7nyTNQvKr7Vb28
         0dvCekYTXLXIFIbs4+kKhuQkClf93MJbqrI/rVOH2uWvCEQKl4bK3qUS9mEu2FF18J
         JAJn0G3iR2yrxtmV4UplUV6HlS/xpS9Es39sWaiZXVdONqENwfzn0JEiMZkOw3FTvf
         B22OwFVg572dNIG2+WS8f3tPz/O/SLsOGgP5Q/wVNYp00waG4rRANiwIRegV9YAXWl
         Ker5Y0TSpDT2Q==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleJIrShJLcpLzFFi42Kxs+GYpBu9vj3
  J4He7kMXrw58YLT7cnMRkseXYPUaLy0/4LH4uW8VusWfvSRaLBRsfMVqc/3uc1eL3jzlsDpwe
  pxZJeGxeoeWxaVUnm8fnTXIem568ZQpgjWLNzEvKr0hgzXj17hZrwWvOivlHX7I2MO7l6GLk4
  hAS2MIo8ebtBsYuRk4gZwGTxLkVoRCJPYwSWx51sYIk2AQ0JZ51LmAGsUUEHCVetM9gASliFj
  jLKNExYxE7SEJYwEli05oFYA0sAqoSbz79YAGxeQU8JBbN2QzWLCGgIDHl4Xswm1PAU2LB9W6
  2LkYOoG0eEksWyECUC0qcnPkErJVZQELi4IsXUK2KEpc6vjFC2BUSrw9fgoqrSVw9t4l5AqPg
  LCTts5C0L2BkWsVol1SUmZ5RkpuYmaNraGCga2hoqmtuqGtobKyXWKWbqJdaqpucmldSlAiU1
  kssL9ZLLS7WK67MTc5J0ctLLdnECIyelGL31h2Ml/t+6h1ilORgUhLlLV3RniTEl5SfUpmRWJ
  wRX1Sak1p8iFGGg0NJgjdnDVBOsCg1PbUiLTMHGMkwaQkOHiURXvm1QGne4oLE3OLMdIjUKUZ
  FKXFeu3VACQGQREZpHlwbLHlcYpSVEuZlZGBgEOIpSC3KzSxBlX/FKM7BqCTMq7oaaApPZl4J
  3PRXQIuZgBbfUm4FWVySiJCSamA6/8/UJGpayuH181vN1z9N8zQIitI5+jOaaZ7YS7lJQgbOE
  ocOvk9Pjjl8Mexptsbt5sokdoYNJ3Me2J5U1zLwtk1a2cbqNffZ50Un3HNZfy6YYK7gdWRDVs
  rCOVNUN5z9OE/9ybHJK+c/3PBhv5nohNQvi+d2stzf7fempbZjTQEbt2ebgJF4wqFLFkfDJiu
  s2rfhVtIRw4Li1EfaD/8lye6eONPBWOjhSvuHgZsnPP60hu1Ovu0jg6L9BX7ZMxX23Nxt7HJX
  oEVw1R2L+MfM/RvX1uXlvK88EhL67wxLzL9u1U/MZlEnluttSV27j2G557G3Zx9wPKvMztrb8
  Eck8L7Asxsal88klblMrErZpMRSnJFoqMVcVJwIAGaXw+2ZAwAA
X-Env-Sender: xuyang2018.jy@fujitsu.com
X-Msg-Ref: server-3.tower-532.messagelabs.com!1653059418!259556!1
X-Originating-IP: [62.60.8.146]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.86.4; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 6613 invoked from network); 20 May 2022 15:10:19 -0000
Received: from unknown (HELO n03ukasimr02.n03.fujitsu.local) (62.60.8.146)
  by server-3.tower-532.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 20 May 2022 15:10:19 -0000
Received: from n03ukasimr02.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTP id BA175100445;
        Fri, 20 May 2022 16:10:18 +0100 (BST)
Received: from R01UKEXCASM126.r01.fujitsu.local (unknown [10.183.43.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTPS id AD180100331;
        Fri, 20 May 2022 16:10:18 +0100 (BST)
Received: from localhost.localdomain (10.167.220.84) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Fri, 20 May 2022 16:10:07 +0100
From:   Yang Xu <xuyang2018.jy@fujitsu.com>
To:     <linux-fsdevel@vger.kernel.org>, <ceph-devel@vger.kernel.org>
CC:     <viro@zeniv.linux.org.uk>, <david@fromorbit.com>,
        <djwong@kernel.org>, <brauner@kernel.org>, <willy@infradead.org>,
        <jlayton@kernel.org>, Yang Xu <xuyang2018.jy@fujitsu.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v9 2/4] fs: Add missing umask strip in vfs_tmpfile
Date:   Sat, 21 May 2022 00:10:35 +0800
Message-ID: <1653063037-2461-2-git-send-email-xuyang2018.jy@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1653063037-2461-1-git-send-email-xuyang2018.jy@fujitsu.com>
References: <1653063037-2461-1-git-send-email-xuyang2018.jy@fujitsu.com>
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

