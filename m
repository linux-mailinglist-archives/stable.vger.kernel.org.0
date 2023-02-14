Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F03696F83
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 22:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbjBNV1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 16:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbjBNV1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 16:27:09 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A7F30295;
        Tue, 14 Feb 2023 13:26:32 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id e12so835748plh.6;
        Tue, 14 Feb 2023 13:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q0YX+gKKtaapqxx0FnXl+kVggR18Ji7mSBNbdaoJVi4=;
        b=HDc5Ok8E9QADS+lNXh1Vl/GSA5xybqcrBRoEkKCH9/7ix7x2wgbFFU178kClAuRS9+
         GtKR1mz4xBUyVd2bgSasPHaE8RA77B+BJIBgjcw/edgZ8NdmlX0tFHTrVYWOwvCuGvLL
         St0AUKYuLuWaVRpS1Xx+av5lA45JVfhH8wb8v7ZghLjnuCzDzYBZCHW9VszMX3BHdmva
         VQqpafEolJv83YSvxcBwSgCmirTi5n1px8AOyQpFfhlkv92cvNGQH/uCoPGxI69lFfcO
         XshXu0Z5AdbAMaCkqKML/so+/sE0XUc30rcjwKsUyJ8fF4DBwlPle4bTHvIHoh8KFzhu
         SquA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q0YX+gKKtaapqxx0FnXl+kVggR18Ji7mSBNbdaoJVi4=;
        b=y/sIY1KIHDQLFYAappaxUh/U4eJApgA806sW3iIHPiUswUCsDO/rqcM81Jd8kdmuK3
         KDxds/gvHZYxgIUBp2EHiWw7urpURwhl/oZdXG1f7QZk93ahibOCY7jcWwdIxHAJNzwV
         WtqTRWKRGrTMBt/6kZWcGxv6iVV7kWqc37wO3LuH86sAPckJQWAgzxEKb59MHXv2xR4G
         LJIjFyQuwNL6gRkaM36tbN9zbvOXyOgt7Yv9pNthiK9rtImrhT2kfnex+L+TlZMXh8eE
         7DK9TZYp8A3gEy6tvvMCatHaAEWzLXSbDcziXM3zkzF64SK07COTXt7vJ2Ue5FXP/GI9
         czXg==
X-Gm-Message-State: AO0yUKUVBgnxGivwCJGmvEqiqPXG1zBxw9MfXr1hwPW2sHXKc2UaW91n
        klfU01L4qbsO7ndE89eOnV+djY6Y9phgxg==
X-Google-Smtp-Source: AK7set9/i9v3IY2Z4x+Qz4ZjUn667Szq4ar5YYayC17e4QFOA8Rh6+mO4nrWHDs9Wy0kQpML7hJSAA==
X-Received: by 2002:a17:902:fa83:b0:194:9b4e:1c90 with SMTP id lc3-20020a170902fa8300b001949b4e1c90mr13806plb.57.1676409969754;
        Tue, 14 Feb 2023 13:26:09 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cf14:3756:2b5e:fb87])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902654e00b00195f0fb0c18sm6692569pln.31.2023.02.14.13.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:26:09 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 04/10] xfs: set XFS_FEAT_NLINK correctly
Date:   Tue, 14 Feb 2023 13:25:28 -0800
Message-Id: <20230214212534.1420323-5-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
In-Reply-To: <20230214212534.1420323-1-leah.rumancik@gmail.com>
References: <20230214212534.1420323-1-leah.rumancik@gmail.com>
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

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit dd0d2f9755191690541b09e6385d0f8cd8bc9d8f ]

While xfs_has_nlink() is not used in kernel, it is used in userspace
(e.g. by xfs_db) so we need to set the XFS_FEAT_NLINK flag correctly
in xfs_sb_version_to_features().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index e58349be78bd..72c05485c870 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -70,6 +70,8 @@ xfs_sb_version_to_features(
 	/* optional V4 features */
 	if (sbp->sb_rblocks > 0)
 		features |= XFS_FEAT_REALTIME;
+	if (sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT)
+		features |= XFS_FEAT_NLINK;
 	if (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT)
 		features |= XFS_FEAT_ATTR;
 	if (sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT)
-- 
2.39.1.581.gbfd45094c4-goog

