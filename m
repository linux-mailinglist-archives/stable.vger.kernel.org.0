Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4D158533F
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 18:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbiG2QQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 12:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiG2QQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 12:16:19 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44281FD29;
        Fri, 29 Jul 2022 09:16:18 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id a89so6413303edf.5;
        Fri, 29 Jul 2022 09:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=3wKLKhoKbB8eVcLHeT16iiMirEQtHQ1RcQkmpLJZhm0=;
        b=aIG0SdkeTkz0q7Sd3Nv1KEaXwf2h967kTP6TB9MTMcot4JmXqBv723mQeTNDFxaNq9
         mx96QqPO0t6PLRCEe2E0QiKS4Oa2YKOF5h75HLdgj0L5Y49fjUuUjwCcQHS9HlsoQris
         7l83eYNkRgT5NUTnFfHbw1byQhTWR7hG5KpdPAqFGrFX2+WkPOd3XM1WjSNIc2cIF5wV
         uOLKtzsXkSn9tdeaBi+qHpCYLVJ2/kbiUnqvbo8FDZX42dmYxavMLwsbrixgFIxduHWV
         c7RTeKr27CB19u9dUbLqKQAxzJtN338ZEkUG9GN1aUJMBwXJcIvVeYW8Jgry+L7O5bTO
         cqGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=3wKLKhoKbB8eVcLHeT16iiMirEQtHQ1RcQkmpLJZhm0=;
        b=Ita5sZ2eDZUOhft25QbY3GpdR0B/8OMf+CLIoweXg2aeKr5aEglw66a70sUO2kQ81C
         uUDP7Hn4g0uEjwTQo4WV7P9DS5AOCEzueOlwt9JW0WiWezJ53Zgr1VUKjHf/sMdlmd2g
         cdrNtgMJUJlQqqSZHNT2XVzk8T8m/WhRZhzcTfaB0aoziz5mQ8VqiNFSbMpKfthYC4fR
         6mWrbiZKVbOfUWhqJ4MH8W/gityJnQSo7dDWbTNUEMElXv9InavhuBCF2uCVZyKHUE2/
         4Z5DYxawQC2e1meyskp+A5Q1s0u+H7bY6y9lwoPAPhEzTh5FlyKCRrJGJi/UgvjTqiVx
         AiFg==
X-Gm-Message-State: AJIora9Af/7FjzcDJH0S51NnDyxAww0QOCA4wXAAhNfFy4FYbliGOBgn
        Y2rdHByZ+G3GhtzC80Yh5dg=
X-Google-Smtp-Source: AGRyM1sdM5RdQ/kTeqyWjqeYBlxjXn3KyibVHd/YyTvzYCWkb857F95WFNTOg1FIHcxjjVZhnwwtqw==
X-Received: by 2002:a05:6402:1006:b0:43a:d397:68c3 with SMTP id c6-20020a056402100600b0043ad39768c3mr4306535edu.170.1659111376716;
        Fri, 29 Jul 2022 09:16:16 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan (4.196.107.92.dynamic.wline.res.cust.swisscom.ch. [92.107.196.4])
        by smtp.gmail.com with ESMTPSA id fm15-20020a1709072acf00b0072b14836087sm1870116ejc.103.2022.07.29.09.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 09:16:16 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 v2 0/9] xfs stable patches for 5.10.y (from v5.13+)
Date:   Fri, 29 Jul 2022 18:16:00 +0200
Message-Id: <20220729161609.4071252-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Hi Greg,

This backport series contains mostly fixes from v5.14 release along
with one fix deferred from the first joint 5.10/5.15 series [1].

The upstream commit f8d92a66e810 ("xfs: prevent UAF in
xfs_log_item_in_current_chkpt") was already applied to 5.15.y, but its
5.10.y backport was more involved (required two non trivial dependency
patches), so it needed more time for review and testing.

Per Darrick's recommendation, on top of the usual regression tests,
I also ran the "recoveryloop" tests group for an extended period of
time to test for rare regressions.

Some recoveryloop tests were failing at rates less frequent than 1/100,
but no change in failure rate was observed between baseline (v5.10.131)
and the backport branch.

There was one exceptional test, xfs/455, that was reporting data
corruptions after crash at very low rate - less frequent than 1/1000
on both baseline and backport branch.

It is hard to draw solid conclusions with such rare failures, but the
test was run >10,000 times on baseline and >20,000 times on backport
branch, so as far as our test coverage can attest, these backports are
not introducing any obvious xfs regressions to 5.10.y.

Thanks,
Amir.

Changes from [v1]:
- Survived a week of crash recovery loop
- Added Acked-by Darrick
- CC stable

[1] https://lore.kernel.org/linux-xfs/20220623203641.1710377-1-leah.rumancik@gmail.com/
[v1] https://lore.kernel.org/linux-xfs/20220726092125.3899077-1-amir73il@gmail.com/

Brian Foster (2):
  xfs: hold buffer across unpin and potential shutdown processing
  xfs: remove dead stale buf unpin handling code

Christoph Hellwig (1):
  xfs: refactor xfs_file_fsync

Darrick J. Wong (3):
  xfs: prevent UAF in xfs_log_item_in_current_chkpt
  xfs: fix log intent recovery ENOSPC shutdowns when inactivating inodes
  xfs: force the log offline when log intent item recovery fails

Dave Chinner (3):
  xfs: xfs_log_force_lsn isn't passed a LSN
  xfs: logging the on disk inode LSN can make it go backwards
  xfs: Enforce attr3 buffer recovery order

 fs/xfs/libxfs/xfs_log_format.h  | 11 ++++-
 fs/xfs/libxfs/xfs_types.h       |  1 +
 fs/xfs/xfs_buf_item.c           | 60 ++++++++++--------------
 fs/xfs/xfs_buf_item_recover.c   |  1 +
 fs/xfs/xfs_dquot_item.c         |  2 +-
 fs/xfs/xfs_file.c               | 81 ++++++++++++++++++++-------------
 fs/xfs/xfs_inode.c              | 10 ++--
 fs/xfs/xfs_inode_item.c         |  4 +-
 fs/xfs/xfs_inode_item.h         |  2 +-
 fs/xfs/xfs_inode_item_recover.c | 39 ++++++++++++----
 fs/xfs/xfs_log.c                | 30 ++++++------
 fs/xfs/xfs_log.h                |  4 +-
 fs/xfs/xfs_log_cil.c            | 32 +++++--------
 fs/xfs/xfs_log_priv.h           | 15 +++---
 fs/xfs/xfs_log_recover.c        |  5 +-
 fs/xfs/xfs_mount.c              | 10 +++-
 fs/xfs/xfs_trans.c              |  6 +--
 fs/xfs/xfs_trans.h              |  4 +-
 18 files changed, 179 insertions(+), 138 deletions(-)

-- 
2.25.1

