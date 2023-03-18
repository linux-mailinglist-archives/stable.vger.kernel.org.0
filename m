Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A128B6BF977
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 11:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjCRKQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 06:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjCRKQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 06:16:03 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DD03C783;
        Sat, 18 Mar 2023 03:16:00 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id o11-20020a05600c4fcb00b003eb33ea29a8so4726639wmq.1;
        Sat, 18 Mar 2023 03:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679134560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wp5O0Uso/5747JI3g/VP4quGRfaMOOJgNJaJo0zDdP4=;
        b=Ar7e1HbyfilIUQ2zBdtghWRaWA+mJsxW3OOnYY9TOMxsxA8dEVH9SAKk/YmpYShPR7
         CwLCRy4uxRS/QKOCwXr1r5zryMnBMZv9J0E1zBERHzdWjIjO5H/sc9ES9RcEMlmAAVw3
         SOIUG2XLJsDb5i/ZTZRSQuHzwtRn4AJMzeJo0d16gGiDbNbOE7lUGphzqWnOu5l8u3K6
         BFsLFvM/yWMu+uZiAPB9xmmhD1VH2AgS1it0HdIULiORfGHQuDK8mjEEUbG2UnvnqE0f
         r1qmM+pU1SK7dqcx2V+S3JXyxr16IInnMt/gqhW/y3fb49qV0sY1hXEk00x2waMF/76Q
         CFBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679134560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wp5O0Uso/5747JI3g/VP4quGRfaMOOJgNJaJo0zDdP4=;
        b=mthmaI9Hw7XlJbxHSV10h4gV7qWwi/l53QYRKuLzlPdvjUjlloT6KXbaoUVG4Eoz+n
         Jl/S9TEZq9EICCjX138G5JOPSnJKTBSumrx++rM84tOXfPZXRhxUyqETDR8iMKMgsrrr
         eTW/SLAwOuucazzOEw8bQ+rlZyAuu47g7kgYe7yYNY1473nSWoYXlSPBRYsEMmn9tBO+
         ZPKjMVCIseeIlS1Sd8UjGVf+6i3wVzCd8ayG3mAFUndsFSX3lZjL6mVjuPN8nZoBqlFO
         dyuRHc2GGBIIYSo0JQ55bPsKfDIcrm2Tv7HaJhy2bCm5UcaIIt+/EWiH5E7t6VeU5Kkw
         5zkw==
X-Gm-Message-State: AO0yUKWwkR4eUi7X7Aehi32xYnx2aq3wRM5f3J5mC9jkkWbr7WoXNXzu
        LCXipHIuhW1UYwfnOwHc9IY=
X-Google-Smtp-Source: AK7set8+NSpt4bUY/HtBnBhhL4uLbkrDAtl6P2ijPkVSNV8icwmsEzLKoI97DDA8GYyjBtuf9x97XA==
X-Received: by 2002:a1c:4c02:0:b0:3ed:6c71:9dc8 with SMTP id z2-20020a1c4c02000000b003ed6c719dc8mr6965394wmf.22.1679134560222;
        Sat, 18 Mar 2023 03:16:00 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id v26-20020a05600c215a00b003eafc47eb09sm4333965wml.43.2023.03.18.03.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 03:15:59 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.10 15/15] xfs: remove xfs_setattr_time() declaration
Date:   Sat, 18 Mar 2023 12:15:29 +0200
Message-Id: <20230318101529.1361673-16-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230318101529.1361673-1-amir73il@gmail.com>
References: <20230318101529.1361673-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit b0463b9dd7030a766133ad2f1571f97f204d7bdf upstream.

xfs_setattr_time() has been removed since
commit e014f37db1a2 ("xfs: use setattr_copy to set vfs inode
attributes"), so remove it.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_iops.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
index 4d24ff309f59..dd1bd0332f8e 100644
--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -18,7 +18,6 @@ extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
  */
 #define XFS_ATTR_NOACL		0x01	/* Don't call posix_acl_chmod */
 
-extern void xfs_setattr_time(struct xfs_inode *ip, struct iattr *iattr);
 extern int xfs_setattr_nonsize(struct xfs_inode *ip, struct iattr *vap,
 			       int flags);
 extern int xfs_vn_setattr_nonsize(struct dentry *dentry, struct iattr *vap);
-- 
2.34.1

