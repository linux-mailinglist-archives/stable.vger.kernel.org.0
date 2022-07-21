Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141EE57D616
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 23:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233608AbiGUVgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 17:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbiGUVgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 17:36:45 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE6B93612;
        Thu, 21 Jul 2022 14:36:45 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id f3-20020a17090ac28300b001f22d62bfbcso2227575pjt.0;
        Thu, 21 Jul 2022 14:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lkr9K8E3g4XVaOmkXtXzuO8KCTnAYiCo1B0JCZ9vFdY=;
        b=Cgnxavb3ik4Z74PuL7hMCtWtVE7LeCmvNqltCKCdwxfW4yzcny8BYhUSnclL0R/wud
         K1uxPuKUh94aoFDCcgofD5J2e1Bz685zyuCbJCn6iWLv9/oAenmk055ls7Ty54m3FUhF
         JBK+Fexl9Hk0Q73Lw8vc5X9WoQkodgrr12ysK0MzqxuOEJUmMbY0DvT13R4d/kB2YBxB
         ksJM0DD6HaSQpEr5zoyBfUWNIsC9PjrebCU0232v0C+KhDDwRmVlU0CLm9rx81EljAId
         LQ2EQG5paIkPm+zK/lPWZt0mP2OIB0wukv9oL6fpz0K7fGMImXN/VidvDU9nndshc1ri
         gTeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lkr9K8E3g4XVaOmkXtXzuO8KCTnAYiCo1B0JCZ9vFdY=;
        b=MNK5dPeQ5KpPCulY6T2izQsCaH9X6YzDJJc+absUY9uV5jLFGKm/j3GQ2FigoKiLUv
         wFeS7TOAGV4MF+/45brq1xFhcIktBN8SZvE6sWTGDe7JRxvT1HbwV+F12OzRdi1UmDsa
         PH/AICxnpASC2hopZO8oDhrBnkRFyF9MNGhPNNOxOAGLsRUjr2dtJ8yIZVfI8uUrwWTV
         xQer6XxZxLntNj61+uVnjCQ032ECebY65zRJohSaD0pzEb04+zgjR0FtjxaIf3mzZpy8
         3A5EDadsIowEnm/ZPb1isRN4bvZxUM9/HWEZgULdtdkDeaWYN/9iUblT3YNJjXoTdv7j
         2a1Q==
X-Gm-Message-State: AJIora+teft+GaapyGh+Hyitos67RWtqDlqxRCctU3oyNVQ+BO7kqn3l
        VJR6XCLZRlriZl/E7U+5T3qHYe4I9LM=
X-Google-Smtp-Source: AGRyM1sHcLjbBLG1NOdDRj64/OwvItdwDQ2pdgyvqVmRA0ginigXrrDql9rHXP0ujSInQqyAGYpWFw==
X-Received: by 2002:a17:902:8645:b0:16d:2b60:bc80 with SMTP id y5-20020a170902864500b0016d2b60bc80mr459457plt.126.1658439404281;
        Thu, 21 Jul 2022 14:36:44 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:ea45:e7f2:4e46:fc7a])
        by smtp.gmail.com with ESMTPSA id c26-20020a634e1a000000b004114cc062f0sm1919502pgb.65.2022.07.21.14.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 14:36:25 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 v2 0/6] xfs stable candidate patches for 5.15.y (part 3)
Date:   Thu, 21 Jul 2022 14:36:04 -0700
Message-Id: <20220721213610.2794134-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
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

Hi again,

This set contains fixes from 5.16 to 5.17. The normal testing was run
for this set with no regressions found.

Some refactoring patches were included in this set as dependencies:

bf2307b19513 xfs: fold perag loop iteration logic into helper function
    dependency for f1788b5e5ee25bedf00bb4d25f82b93820d61189
f1788b5e5ee2 xfs: rename the next_agno perag iteration variable
    dependency for 8ed004eb9d07a5d6114db3e97a166707c186262d

Thanks,
Leah

v1->v2:
- Dropped 3 patches of scrub fixes
- Added Ack's

v1: https://lore.kernel.org/linux-xfs/20220718202959.1611129-1-leah.rumancik@gmail.com/

Brian Foster (4):
  xfs: fold perag loop iteration logic into helper function
  xfs: rename the next_agno perag iteration variable
  xfs: terminate perag iteration reliably on agcount
  xfs: fix perag reference leak on iteration race with growfs

Dan Carpenter (1):
  xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()

Darrick J. Wong (1):
  xfs: fix maxlevels comparisons in the btree staging code

 fs/xfs/libxfs/xfs_ag.h            | 36 ++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_btree_staging.c |  4 ++--
 fs/xfs/xfs_ioctl.c                |  2 +-
 fs/xfs/xfs_ioctl.h                |  5 +++--
 4 files changed, 27 insertions(+), 20 deletions(-)

-- 
2.37.1.359.gd136c6c3e2-goog

