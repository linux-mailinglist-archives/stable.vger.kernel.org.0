Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6151E696F78
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 22:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjBNV1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 16:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbjBNV1E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 16:27:04 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC37430283;
        Tue, 14 Feb 2023 13:26:25 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id h4so10518638pll.9;
        Tue, 14 Feb 2023 13:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d8+bOJaJ1DMCI2ipzGuFesKUVSe+97WR5t+OxKErTbo=;
        b=nZkRKMTENJwU53EZ/h21deD7+pDHjmj+Ht+P77lDrgx6zZ7CZWtXOtaQyEPGO+qYu3
         aGpTploV3eohWgNdFvY0NEnWD0eCya8UwtHiHeRa66WzCRw6Hcp2D5dsDBth8AK144AN
         RU1poNdFbN0VPVh7IEAKeoCR9G60/M3ihiaJ0FAvibbxTJY4n+jytQOZ8M0jtnnkquKq
         RI6H5e/Oi+fvIw0p8Gsao6+tDVHCkkpPb3B5pQ6vQ0wgsHT8pg0ne4ARl+CacSM70QLq
         y5mEHuidZ74A/ti1+mi2SdbZyVY3pmaIMig8NNPDXKE4HQF++mkrnr/rVf/vOJ9qZmIv
         z6YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d8+bOJaJ1DMCI2ipzGuFesKUVSe+97WR5t+OxKErTbo=;
        b=pEwKKHz9jycRvNJ9dJUpaM8LFganGBXOye357AQpyebn+a8hsMKIledExIx30Z8zPz
         YjCj+xwrXiCaK6x5tgcfaGAQNhCLUwHh6RuQiP+4FV0BGRDPanpMJB4FBD9SlPu0FLLv
         PQU3yC/gEv5L9ChoGfBbXVr2VR7UB+vVqY3cllZSKmF+gRP+zkznLRn6q4QISz5CU2aq
         iw7zo4EDpGeYVOFUor/WXnxL4rhRffekY1zl1Z3JbatqGqxWAZct31N8imxWv5ZYuJj4
         Gdjt7beJtP1+k5xBjK1u3R1WBDeNNDWVZXykQGHPTod+tNL/oIREtedgYMN6LuzQS5ns
         x/Zw==
X-Gm-Message-State: AO0yUKU8S8Kp8uIx2vtUb60sgbU5AqX8/P8zrpK+lbDka81OxbOqf+p5
        vAF+n9+90O8+g+gH52vP4JGcojsCZvc=
X-Google-Smtp-Source: AK7set/liYi0fNFvSnxWTbdsGPCeE9Jk/4A/dmJRmpVuqLrXj5yPMhEQzOE7A+7X1XS2RdI9d3DbTA==
X-Received: by 2002:a17:902:d4d2:b0:198:9bf8:298e with SMTP id o18-20020a170902d4d200b001989bf8298emr20200plg.60.1676409964569;
        Tue, 14 Feb 2023 13:26:04 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cf14:3756:2b5e:fb87])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902654e00b00195f0fb0c18sm6692569pln.31.2023.02.14.13.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:26:04 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 00/10] xfs backports for 5.15.y
Date:   Tue, 14 Feb 2023 13:25:24 -0800
Message-Id: <20230214212534.1420323-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
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

Hello,

Here is the next batch of backports for 5.15.y. These patches have
already been ACK'd on the xfs mailing list. Testing included
25 runs of auto group on 12 xfs configs. No regressions were seen.
I checked xfs/538 was run without issue as this test was mentioned
in 56486f307100. Also, from 86d40f1e49e9, I ran ran xfs/117 with
XFS compiled as a module and TEST_FS_MODULE_REOLOAD set, but I was
unable to reproduce the issue.

Below I've outlined which series the backports came from:

series "xfs: intent whiteouts" (1):
[01/10] cb512c921639613ce03f87e62c5e93ed9fe8c84d
    xfs: zero inode fork buffer at allocation
[02/10] c230a4a85bcdbfc1a7415deec6caf04e8fca1301
    xfs: fix potential log item leak

series "xfs: fix random format verification issues" (2):
[1/4] dc04db2aa7c9307e740d6d0e173085301c173b1a
    xfs: detect self referencing btree sibling pointers
[2/4] 1eb70f54c445fcbb25817841e774adb3d912f3e8 -> already in 5.15.y
    xfs: validate inode fork size against fork format
[3/4] dd0d2f9755191690541b09e6385d0f8cd8bc9d8f
    xfs: set XFS_FEAT_NLINK correctly
[4/4] f0f5f658065a5af09126ec892e4c383540a1c77f
    xfs: validate v5 feature fields

series "xfs: small fixes for 5.19 cycle" (3):
[1/3] 5672225e8f2a872a22b0cecedba7a6644af1fb84
    xfs: avoid unnecessary runtime sibling pointer endian conversions
[2/3] 5b55cbc2d72632e874e50d2e36bce608e55aaaea
    fs: don't assert fail on perag references on teardown
[2/3] 56486f307100e8fc66efa2ebd8a71941fa10bf6f
    xfs: assert in xfs_btree_del_cursor should take into account error

series "xfs: random fixes for 5.19" (4):
[1/2] 86d40f1e49e9a909d25c35ba01bea80dbcd758cb
    xfs: purge dquots after inode walk fails during quotacheck
[2/2] a54f78def73d847cb060b18c4e4a3d1d26c9ca6d
    xfs: don't leak btree cursor when insrec fails after a split

(1) https://lore.kernel.org/all/20220503221728.185449-1-david@fromorbit.com/
(2) https://lore.kernel.org/all/20220502082018.1076561-1-david@fromorbit.com/
(3) https://lore.kernel.org/all/20220524022158.1849458-1-david@fromorbit.com/
(4) https://lore.kernel.org/all/165337056527.993079.1232300816023906959.stgit@magnolia/

- Leah

Darrick J. Wong (2):
  xfs: purge dquots after inode walk fails during quotacheck
  xfs: don't leak btree cursor when insrec fails after a split

Dave Chinner (8):
  xfs: zero inode fork buffer at allocation
  xfs: fix potential log item leak
  xfs: detect self referencing btree sibling pointers
  xfs: set XFS_FEAT_NLINK correctly
  xfs: validate v5 feature fields
  xfs: avoid unnecessary runtime sibling pointer endian conversions
  xfs: don't assert fail on perag references on teardown
  xfs: assert in xfs_btree_del_cursor should take into account error

 fs/xfs/libxfs/xfs_ag.c         |   3 +-
 fs/xfs/libxfs/xfs_btree.c      | 175 +++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_inode_fork.c |  12 ++-
 fs/xfs/libxfs/xfs_sb.c         |  70 +++++++++++--
 fs/xfs/xfs_bmap_item.c         |   2 +
 fs/xfs/xfs_icreate_item.c      |   1 +
 fs/xfs/xfs_qm.c                |   9 +-
 fs/xfs/xfs_refcount_item.c     |   2 +
 fs/xfs/xfs_rmap_item.c         |   2 +
 9 files changed, 221 insertions(+), 55 deletions(-)

-- 
2.39.1.581.gbfd45094c4-goog

