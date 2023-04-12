Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D613A6DEA53
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjDLEUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjDLEU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:20:29 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D754468D;
        Tue, 11 Apr 2023 21:20:28 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id g3so11474966pja.2;
        Tue, 11 Apr 2023 21:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681273227; x=1683865227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KSIQbw75eFFmcyo44AtEoA6kDkKcUqP4sxKGrhsBuD8=;
        b=eYOHExniI1JcCrr/e9OfNjDIB13OkVl5IdSEi9oBLjFitd/RuHKpC9mV/l9NacFmNG
         ay/fCU6taXmlYSIj8J8LkUp4wQoLHa4UoiUEamOV+13ZlqCPEMrZyjjdM17qtqvLgqZL
         JDLFJ4mbslfk53624f2K76orXV2GklQyyX/pLlIx6LGyPwSCnFHW6nbtua1tj/LPsuBz
         Sn6SZe1LbZyMlswCso0GKLnRyfROgC8PQydfuFgMTHWWsS/33RupkvrsaxIMA2k4Cju5
         woChRCKfC2+Y3AKTkDPgVpkS3uUF61ofnCoq4tS9falJ3sKGo03YCxZ/3oiQgo1qqMv6
         lLwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681273227; x=1683865227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KSIQbw75eFFmcyo44AtEoA6kDkKcUqP4sxKGrhsBuD8=;
        b=w3wu8TCXk1UAFKC19oqXTaIa46euVBThB5mOwM0FE1Z7CUtM5FqXkvLl835icIi1IB
         CgYT+3NlYBcueQfMkSNAQ5zSpAuvWItrs+LYNtJa74Cfa8GUv8XquAXGqwbbuLQeIdsp
         EMjyq2g+WQdtiv6B+XhS9I/VgeUBEwg7oZBm+RHpGS4IV6hE6kiw+hzdGX6LEJiho+5X
         /YZ7wZIc4MsS6FjtPCiFNrYok2Zc3EI22qkHWu0/XGkTuvGBV0ls3hbXXSkWCQhcUeoE
         nWA6hjS+CipeSXlvgvjBx2ZCLpvce7BKMWXxPMqUQPZy7FBnbmToePRA7bE1/r+FI9uV
         wnDQ==
X-Gm-Message-State: AAQBX9fYVe5C7UpBrVE9eHSeRm5fIl/YdUzCxb5PWRrcEK2sxeB+B2Qd
        9J9YIQ+MALnq89Za2SM9vOb1xoEF0b6tgg==
X-Google-Smtp-Source: AKy350bW1TUt40HezUce7hCbj3feIWyJ12TdPXMK0bkKC+8eJDYOg72ZqN6LrsI8CBvgc8Jjk7OATg==
X-Received: by 2002:a17:902:f08d:b0:1a0:5bb1:3f0b with SMTP id p13-20020a170902f08d00b001a05bb13f0bmr4735981pla.40.1681273227597;
        Tue, 11 Apr 2023 21:20:27 -0700 (PDT)
Received: from virtualbox.www.tendawifi.com ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id t13-20020a1709028c8d00b001a19196af48sm10412381plo.64.2023.04.11.21.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 21:20:26 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
        Zhang Tianci <zhangtianci.1997@bytedance.com>,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 5/6] fuse: always revalidate rename target dentry
Date:   Wed, 12 Apr 2023 12:19:34 +0800
Message-Id: <20230412041935.1556-6-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412041935.1556-1-yb203166@antfin.com>
References: <20230412041935.1556-1-yb203166@antfin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>

commit ccc031e26afe60d2a5a3d93dabd9c978210825fb upstream.

[backport for 5.10.y]

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
index 80a9e50392a0..bdb04bea0da9 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -205,7 +205,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
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

