Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659EC6AF45B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbjCGTQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbjCGTP5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:15:57 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99296CD67A;
        Tue,  7 Mar 2023 10:59:27 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so17562530pjh.0;
        Tue, 07 Mar 2023 10:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678215567;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jpC6qvm3z4xmjpkmYnEYFXhm0ukZhZ7VSpBo9i5esAs=;
        b=md4MT1gSu5H7VzD0w18AuWc22nlYpe0Swfgh8hhpoPW7YfBpLewTEoeSdmam9RhP8o
         bOW0ztRve1XTeMBtYoSW9rruXcwM8+QYDGJ4L69c1mNmQlBnQNklZ0THemA0K9ljFvTV
         V7mvDTlggTJILk+WMNaVc/iDhlKnXazHOtkF9zHJHbjWgdO1BbbRkASwdil5ZTanfAfY
         e/QolYi1M5nOB0sMtbnjj2tLBzJWrH5C1uFAg6V92ofDPxrXNaVZ5Wr5MVEoayRhdD7z
         Y/Gyna6Sp89wRFyyOTaNKcGQB037tBmBxJEKIBNL/eKof1RV0xdnZOF6PJPHRqZQqYKK
         ACNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678215567;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jpC6qvm3z4xmjpkmYnEYFXhm0ukZhZ7VSpBo9i5esAs=;
        b=ksPjUGU3tFNvACxbnYknQ5niL3QUyHTMjdAKjorePmYqT2YKnI7Z9leAuTPqEjl3Iu
         Cs0+Skt+Q7PTX1R/n6ECgAiXm0qkT2JLNV6OkjWQp/rE/69HIewmQsZpFEtupXXI83md
         h/8PVlfDCoDiNeSgbsA/Q4Qc+jKXm1nyJuSI7/4nIdHR8UioG/xl7SCl6ecCKcKmIzME
         kgaN29/e84tkKi+wWzxnbEIzbWUdj+1Gq+y3GKkHwluSLL7mk2rcvRFdD3ia/NyTk1U3
         eahSOYM+CAqE1kY4su4UCxjXqvRPWaIvODiCgShbsJheImtIkCw+KtJv0RPE0l3MU/s7
         EJWg==
X-Gm-Message-State: AO0yUKWnbk5bTBhgiyn6qbUhepu40tTEMDZFyEXeeoFOXLSEc67dXtn9
        p2CALQ7xaGvk6xW9H/tAAO8ktUkN5Yk=
X-Google-Smtp-Source: AK7set8lftx0fyFIwyZkKnkfsOtQeqzv2Blv3ch/zVX05l4syJ9Utsv/rXc/p2NfY6rXkFo47JzP5g==
X-Received: by 2002:a17:902:aa4a:b0:19e:3922:b7d8 with SMTP id c10-20020a170902aa4a00b0019e3922b7d8mr13001883plr.12.1678215566817;
        Tue, 07 Mar 2023 10:59:26 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:6f2b:1857:847c:366c])
        by smtp.gmail.com with ESMTPSA id ku4-20020a170903288400b001943d58268csm8745658plb.55.2023.03.07.10.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 10:59:26 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 00/11] sgid fixes for 5.15.y
Date:   Tue,  7 Mar 2023 10:59:11 -0800
Message-Id: <20230307185922.125907-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
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

I finished testing the sgid fixes which Amir graciously backported to
5.15. This series fixes the previously failing generic/673 and
generic/68[3-7]. No regressions were seen in the 25 runs of the auto
group x 8 configs. I also did some extra runs on the perms group and
no regressions there either. The corresponding fixes are already in
6.1.y.

- Leah

Christian Brauner (5):
  attr: add in_group_or_capable()
  fs: move should_remove_suid()
  attr: add setattr_should_drop_sgid()
  attr: use consistent sgid stripping checks
  fs: use consistent setgid checks in is_sxid()

Darrick J. Wong (1):
  xfs: use setattr_copy to set vfs inode attributes

Dave Chinner (3):
  xfs: remove XFS_PREALLOC_SYNC
  xfs: fallocate() should call file_modified()
  xfs: set prealloc flag in xfs_alloc_file_space()

Yang Xu (2):
  fs: add mode_strip_sgid() helper
  fs: move S_ISGID stripping into the vfs_*() helpers

 Documentation/trace/ftrace.rst |  2 +-
 fs/attr.c                      | 72 +++++++++++++++++++++++++--
 fs/fuse/file.c                 |  2 +-
 fs/inode.c                     | 90 ++++++++++++++++++++--------------
 fs/internal.h                  | 10 +++-
 fs/namei.c                     | 82 ++++++++++++++++++++++++++-----
 fs/ocfs2/file.c                |  4 +-
 fs/ocfs2/namei.c               |  1 +
 fs/open.c                      |  8 +--
 fs/xfs/xfs_bmap_util.c         |  9 ++--
 fs/xfs/xfs_file.c              | 24 +++++----
 fs/xfs/xfs_iops.c              | 56 ++-------------------
 fs/xfs/xfs_pnfs.c              |  9 ++--
 include/linux/fs.h             |  6 ++-
 14 files changed, 235 insertions(+), 140 deletions(-)

-- 
2.40.0.rc0.216.gc4246ad0f0-goog

