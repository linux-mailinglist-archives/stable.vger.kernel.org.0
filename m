Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0366E76D8
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbjDSJzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjDSJz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:55:29 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF4D9014;
        Wed, 19 Apr 2023 02:55:10 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b5465fb99so2718953b3a.1;
        Wed, 19 Apr 2023 02:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681898110; x=1684490110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aapSfZjt4Gj2fxrzlg53gPhqR9zJhtLaiSDvlMrgU5M=;
        b=hwW9sLG3arKph0o+sxvo4pK/XD4LftB90/qHgsP8Z8uCj0kbo6fmHeKpQ/tDoBJUR4
         qb1qF+8p+EF/peln96He4DPCn5zqpGs1MAoReYMPBy5us7WQ2fFFQop8YbN63vl1ZW+g
         lnS2isZmYy2oNJRV3GHsVoy3+b0TFEvL/3jqbjauCIDRFtB90dtHrLdD/hVDlQhx3Kx2
         4Rt8vMuCCsl3vTTSsi57fNcu7Rf8jBPyhqEGR4JqhYCag1a/p2jh1QBoMJ8Olx2/Qgsu
         Evsb6YMrY8edGWqVRehe0gIRQX4/x+LOY2Nctq+TLigNAh8zdoYnDYmDML0PSNzlK5EP
         tDdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681898110; x=1684490110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aapSfZjt4Gj2fxrzlg53gPhqR9zJhtLaiSDvlMrgU5M=;
        b=OC/lEDXKM53uX+rBfRVvW+ZA6kXhwkvMMl5maHveyUNHKPr1dqLQ4CHz5PC3lUwFlW
         a/kG9Tjihq+xRzfcc4sXSLjeNIiZIl00ZPRHsnpV4+jxpjfHAZ0+u7avuC2OttL6zX7k
         q9Xd/k4YGNnDDCAqoERSNECAbKMaZgobaZlVh8buFOuPVxWbs2ten0u0zT1WhlKN5NOe
         WyFROKLtGo1Y3rXyx836izPWhlxMbYRFX8Fw8htusUU3UFMCx1X+JsoduWpvcZPTz5b6
         Xf7QiSgH5V1dQ/bmRJZO1U8zL4b3zWcepxo49/fD+Sp4yGydGx5Q00JqQ1/e37ZS4njc
         0hyw==
X-Gm-Message-State: AAQBX9cF6Toc6bteBs5dsU3ocpX9RM8IAT5VQWc29NYDBCbmgxzBpnNC
        tY+zYiUQ7/0IjDuEOqM9CZ/g+WI88zCxVQ==
X-Google-Smtp-Source: AKy350bfYK5AkpbSC3l1cmYS8zUxFNjffWrMR/5D6qWE2biG/BV4+DdA1uhCQzNu3ERr4S0Fc6TThw==
X-Received: by 2002:a17:902:ce0c:b0:1a1:a800:96a7 with SMTP id k12-20020a170902ce0c00b001a1a80096a7mr4782755plg.8.1681898110058;
        Wed, 19 Apr 2023 02:55:10 -0700 (PDT)
Received: from localhost.localdomain ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id h12-20020a170902f7cc00b0019f9fd10f62sm11108357plw.70.2023.04.19.02.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 02:55:09 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
        Zhang Tianci <zhangtianci.1997@bytedance.com>,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 2/3] fuse: always revalidate rename target dentry
Date:   Wed, 19 Apr 2023 17:54:23 +0800
Message-Id: <20230419095424.51328-3-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230419095424.51328-1-yb203166@antfin.com>
References: <20230419095424.51328-1-yb203166@antfin.com>
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

[backport for 5.15.y]

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
index 80a2181b402b..075266140fac 100644
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

