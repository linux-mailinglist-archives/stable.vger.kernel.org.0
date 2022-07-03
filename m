Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57A3564541
	for <lists+stable@lfdr.de>; Sun,  3 Jul 2022 07:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiGCFFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jul 2022 01:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiGCFFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jul 2022 01:05:15 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F6EAE6A;
        Sat,  2 Jul 2022 22:05:14 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r14so2975137wrg.1;
        Sat, 02 Jul 2022 22:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=taaW9WV/agj93cPScPKsI7Gh4xXE49LDvKSkPAGzzPc=;
        b=FZziPwDAmSBaPjHBbfwpOYKbtb7iDBPMNGqE/xihsYlXCh05Vwcgyur08K5CZ1jZad
         2bscWGutnxm7Kx5FBXFP1tczAHC+665izcTKTx5hN3kGNwPkEgHSo9qCLhE3wRMWX09k
         vX7Z/V4RgPb5R09OIZciAG8gKRkDd4SG29bYiwi8uKgwB3fHwxu2XcPPaRNTl8TseBCV
         cENzSS3jzK+Xr5WVPYkoSqlbHzmQduP5DBvWQd7mEPzUiPp/T7W0S8OqUyhd6F9MeeAe
         7/2+7qW9Vv/rQE46mRAOCpWcDq8hSi2h6vf8PPXYMr/q3gdb7hJ/yuQAPIVIdpywfMvX
         tK+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=taaW9WV/agj93cPScPKsI7Gh4xXE49LDvKSkPAGzzPc=;
        b=7dS4tWv5Nf7rpZBLGOKeDeLxB9vwvDPWriBtGExadwEgxj0QnwoEbPOtF3N5llg4+O
         +XEMIlUixqIo77Br0gmiOdd7AmYIhW2l9M/7ekaQjGCEwHoEsmNwgb/3Tk3hL0y/GvJv
         QvFv71t1dDffqXvUUW3LE2zyLE6BNZruOmDwE9bKa9glSSSyqQeQ9Dr/ycEW6S08CxWL
         4TRZl7aK2D9NgxuMWteeRco/Ksh1qpWChHhSAZUz4xLPDmSI4+bWNkGw4f9xGwbZg6Na
         CniwfOPPFz6FzyHodWxELhzWnYEoH8HQ33Nfinv/jrTBs1eX9xjGfa2YJCeCB3mk4Mnj
         OHCA==
X-Gm-Message-State: AJIora+J/B4ZcZLAhldW7quXVDjmJbUdZYkA6soRSJCmmak9wthbW5bP
        H2QqNbiYcD2Ofctywu5WxMQ=
X-Google-Smtp-Source: AGRyM1tUi9OGTNNGAnA9LmD+9vcFD5ok6whcqd/TlKNypxN89A63aySH+KG1O8IbIG90kfYm5k8UmQ==
X-Received: by 2002:a5d:47a5:0:b0:21d:19b8:f8fe with SMTP id 5-20020a5d47a5000000b0021d19b8f8femr20664141wrb.23.1656824713751;
        Sat, 02 Jul 2022 22:05:13 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id e2-20020adfdbc2000000b0021b9f126fd3sm27028952wrj.14.2022.07.02.22.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 22:05:13 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5.10 v3 7/7] xfs: fix xfs_reflink_unshare usage of filemap_write_and_wait_range
Date:   Sun,  3 Jul 2022 08:04:56 +0300
Message-Id: <20220703050456.3222610-8-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220703050456.3222610-1-amir73il@gmail.com>
References: <20220703050456.3222610-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit d4f74e162d238ce00a640af5f0611c3f51dad70e upstream.

The final parameter of filemap_write_and_wait_range is the end of the
range to flush, not the length of the range to flush.

Fixes: 46afb0628b86 ("xfs: only flush the unshared range in xfs_reflink_unshare")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 6fa05fb78189..aa46b75d75af 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1503,7 +1503,8 @@ xfs_reflink_unshare(
 	if (error)
 		goto out;
 
-	error = filemap_write_and_wait_range(inode->i_mapping, offset, len);
+	error = filemap_write_and_wait_range(inode->i_mapping, offset,
+			offset + len - 1);
 	if (error)
 		goto out;
 
-- 
2.25.1

