Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5782C56452E
	for <lists+stable@lfdr.de>; Sun,  3 Jul 2022 07:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiGCFFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jul 2022 01:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiGCFFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jul 2022 01:05:05 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FF9AE60;
        Sat,  2 Jul 2022 22:05:02 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id i25so8714206wrc.13;
        Sat, 02 Jul 2022 22:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+oS+IckHBHO7HcBXZr9Yd6IQjYU0pxyqNi85eRLDGX8=;
        b=BA6XOXF2YJVj8zBSOiyxAGTjLigbsIIEx2harSwPKnsc15SRufDIF4bFd5M7HortkY
         q1J8nyGhcQx5UfLTV+zBEwoyBJQcP36Q5NQ5QOrnhl6u2eAmjRG2cdfiYYzBGvvrHIQ8
         8F5zfkz+C8mOy5XoLmmrCGmTubGFDTO988Wabk2NjbeV42GKrORTU5LqJPzMlcB+LoYy
         Yp9vyReAFZR/roc9Z3ej8uNE7sxnmXl4Az03BRKIx9q1O7hj6zMETydpulDitAzYKPWa
         PwzhZhSuZHrTo2dPl0f0c01axDlzOdbDWW7jWDlswabO+ZVEYwAc0Sww2lDRGg/MiO7a
         goHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+oS+IckHBHO7HcBXZr9Yd6IQjYU0pxyqNi85eRLDGX8=;
        b=D8qQwquJcLQWNdvnPQgDNyur8BMHpBym9WZnR6x7wBeCnDhvBcCP8RKWpRczv2E/mW
         k8jWHQO9CxLKSoCzqcOqeCRETkvydi03a88tfzNNQ1ynF/eEZ79DCV6ysEqJGQWaPDZB
         QHAVCYo85E0C+a/p5pgXR7wvSjOwvU8UFY7FpmWtg6ZscdNiexLu98/kZFtMgiE9QIFd
         UJp/jXJc2KsMjCQGdLbzzCdKUC6Mxm4FNjC55I6IMdAvGYJKvBDeATkBNlGFSekawX72
         Brz6YoniInYS9s5ToaEztjfLEthjQBZOqBduJ9WiKZNr0j/SDiN2xkrDtlsN2ND72Cdq
         YGbg==
X-Gm-Message-State: AJIora8F5+LdtZdPvBaJ0Ki8qXkWZVGl/pI7mFUF4W6S0cAVJet3yczR
        m6BGjcEm1IQn4hlcc8Uo9QY=
X-Google-Smtp-Source: AGRyM1uetyhHhGttvvAO4clbohlXLkV/XBmGDY+Zq4cG5C4cCchuCEbmVOMt1hBwrQ1vhq8GtVZwrA==
X-Received: by 2002:a05:6000:1f19:b0:21b:98d6:3532 with SMTP id bv25-20020a0560001f1900b0021b98d63532mr21068197wrb.45.1656824701134;
        Sat, 02 Jul 2022 22:05:01 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id e2-20020adfdbc2000000b0021b9f126fd3sm27028952wrj.14.2022.07.02.22.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 22:05:00 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 v3 0/7] xfs stable patches for 5.10.y (from v5.13)
Date:   Sun,  3 Jul 2022 08:04:49 +0300
Message-Id: <20220703050456.3222610-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Hi Greg,

Following the 5.10.y/5.15.y common series, this is another small
"5.10.y only" update.

I have two more of these (from v5.14 and v5.15) and after that,
5.10.y should be mostly following 5.15.y.

The backports from v5.14 are a little more involved, so the next
"5.10.y only" update is going to take a while longer.

Thanks,
Amir.

Anthony Iliopoulos (1):
  xfs: fix xfs_trans slab cache name

Darrick J. Wong (1):
  xfs: fix xfs_reflink_unshare usage of filemap_write_and_wait_range

Dave Chinner (2):
  xfs: use current->journal_info for detecting transaction recursion
  xfs: update superblock counters correctly for !lazysbcount

Gao Xiang (1):
  xfs: ensure xfs_errortag_random_default matches XFS_ERRTAG_MAX

Pavel Reichl (2):
  xfs: rename variable mp to parsing_mp
  xfs: Skip repetitive warnings about mount options

 fs/iomap/buffered-io.c    |   7 ---
 fs/xfs/libxfs/xfs_btree.c |  12 +++-
 fs/xfs/libxfs/xfs_sb.c    |  16 ++++-
 fs/xfs/xfs_aops.c         |  17 +++++-
 fs/xfs/xfs_error.c        |   2 +
 fs/xfs/xfs_reflink.c      |   3 +-
 fs/xfs/xfs_super.c        | 120 +++++++++++++++++++++-----------------
 fs/xfs/xfs_trans.c        |  23 +++-----
 fs/xfs/xfs_trans.h        |  30 ++++++++++
 9 files changed, 148 insertions(+), 82 deletions(-)

-- 
2.25.1

