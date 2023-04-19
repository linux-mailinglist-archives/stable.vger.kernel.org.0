Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411BB6E76DE
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbjDSJzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbjDSJze (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:55:34 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF097A87;
        Wed, 19 Apr 2023 02:55:30 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1a645fd0c6dso23593035ad.1;
        Wed, 19 Apr 2023 02:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681898130; x=1684490130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IiWyux5S3e1BSFyC1VbfywWD5d2fuL5H/Z5Jr7uKayI=;
        b=mTSMJzPAShrfG9W8IpvpvPrWRhp5JbTXhlZBRtyE1mcsw/NKbpuPznT5pd1Oe4HUfb
         62UKBrYaSIURk28KG+xVaq9PLYBcdNo7CKSdYaZbC93zs/WBSJpEi7zNIFrdSyHJEdal
         DZx5bl8QEAUBJ6TogkTRXJsHZgkxz6Oq4ZMwPlzBANtfwtIxGTzU9//KmFn2ruJMrTzY
         d4STJy6N+tbJsdIilMzYV2utX0Yu+F+BCrNnCFNZzeb21avbMxJR3JrZdgFuXu6qGWwc
         v0WIzpDTd63ZQ/SRfc2H15HZAQyXtrz2h13XSPmSxgHQw/gGeNShKV0tGnBlaLtG/E56
         CEnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681898130; x=1684490130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IiWyux5S3e1BSFyC1VbfywWD5d2fuL5H/Z5Jr7uKayI=;
        b=AeiIcsmBT3j+Nmyy8UIi2wsOk1gmhIK5bKLTse4F8XVW8XvvdFMwC5b67+J0yCEcei
         CthkIssGSrvdaLMlOjqIlYY6CyPPm6EZoOg4xUjgHMTKf4fVAZUTTI2P6kUElERgQ/du
         IVKjBGx2ekN1UV+4UwaEWTIf/oyrfWHTkxS7V56xmK3AqpA+hVv5H2dgzVlspMFP0/Ms
         x4XJqIgtjK8o3cfBSw/0C+BVWnR9VPFnvEusRQdN9CClvd+S583rgEUKOmCFCMXRhIM9
         9xR5xIDyeJZbe9jHaktZNB/ZjZwfvUhi5AW2ECvassBfZFd/av3chQYrG1Kjr+bSqZyH
         SopQ==
X-Gm-Message-State: AAQBX9eubYZdmH6K0k3gIJJu9vF2PzEeEU17iTXIfONEwNDZtaQQvNSu
        po/c+LPB9pWABg0e3QtYcLAu+LoXXModmfOe
X-Google-Smtp-Source: AKy350b8azgM9Q/ql0GuFbM/gui8uHHJ/5kIB/cix9tNSc1uVknXH5n+ONnYHTvYAdI+NMkjzXwtpQ==
X-Received: by 2002:a17:903:1c6:b0:1a0:f8ba:ae55 with SMTP id e6-20020a17090301c600b001a0f8baae55mr5593511plh.7.1681898129861;
        Wed, 19 Apr 2023 02:55:29 -0700 (PDT)
Received: from localhost.localdomain ([120.26.165.80])
        by smtp.gmail.com with ESMTPSA id jm16-20020a17090304d000b001a69c759af3sm9195428plb.35.2023.04.19.02.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 02:55:29 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
        Zhang Tianci <zhangtianci.1997@bytedance.com>,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 1/1] fuse: always revalidate rename target dentry
Date:   Wed, 19 Apr 2023 17:55:17 +0800
Message-Id: <20230419095518.51373-2-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230419095518.51373-1-yb203166@antfin.com>
References: <20230419095518.51373-1-yb203166@antfin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>

commit ccc031e26afe60d2a5a3d93dabd9c978210825fb upstream.

[backport for 6.1.y]

The previous commit df8629af2934 ("fuse: always revalidate if exclusive
create") ensures that the dentries are revalidated on O_EXCL creates.  This
commit complements it by also performing revalidation for rename target
dentries.  Otherwise, a rename target file that only exists in kernel
dentry cache but not in the filesystem will result in EEXIST if
RENAME_NOREPLACE flag is used.

Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Yang Bo <yb203166@antfin.com>
---
 fs/fuse/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index bb97a384dc5d..904673a4f690 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -214,7 +214,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 	if (inode && fuse_is_bad(inode))
 		goto invalid;
 	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64()) ||
-		 (flags & (LOOKUP_EXCL | LOOKUP_REVAL))) {
+		 (flags & (LOOKUP_EXCL | LOOKUP_REVAL | LOOKUP_RENAME_TARGET))) {
 		struct fuse_entry_out outarg;
 		FUSE_ARGS(args);
 		struct fuse_forget_link *forget;
-- 
2.40.0

