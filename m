Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4334330DAFC
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbhBCNVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbhBCNVK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 08:21:10 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7014C061573
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 05:20:24 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id w4so4200318wmi.4
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 05:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JGqiNDSM68Qn3V8IXurIssOeuOCcGm/h5NhXEh7/qKA=;
        b=BJwx2s+/rMcyX8SlHxWjSF2cYGncceLKYO5msSyxIda5owmH9sNnGw2PNcjA2bCNwv
         aTzeCOXCGb9g8Id/ihgLUfxe5PjI0JtBVZpB0PR4ZTWqx5QO2yCzFWVEAvTu+1zIdEe0
         aTvyG7rK2dqNs0bBFtNI881cghCswwZAyVpT/5975m5SahbMHtrAGQVTnzt0r0DfKa8X
         MNkEYSzPNQzw5U8sAj2utf58eMHjIDVPr8nolwCLcoUJ/xUb4fXIvkp+q06bToH16tS1
         ABqlMvxwBV/3cH/zheih3RwKltw5MxJP0jVMZ/Hs89v85vXJrOoKWiMXosTwwGl28fKm
         B8/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JGqiNDSM68Qn3V8IXurIssOeuOCcGm/h5NhXEh7/qKA=;
        b=GNsXD8EEW6H1x9V0MnG1hHz0R2jK1Ymht95P46EGjsOmOx27Rrpn/itlWpNBDItHMn
         VqH8cv4u3EbjPpwMF9AuYuf02IUzgBY71m7efkXRELedLUC4Zs8fzCc1hEhHh8mQYMjI
         mjKCGcBZNSS8aW+G5ADBNcUYKkgb/dKulaTpDTLolo2qnKqE6vXwG1RkikVVnuzAY67n
         GlJFGjZDptgnygPoHYUkUN0ovtRoq+SJ+gGLerF+5rAe/yNRndScFvi0/SRQffquD8wI
         BVEY8Z3+phnnGYxtuWdOdrAH97AumGr1vBONJjJWJSinQdydENGJcNF1LERckjOZ+T+I
         xVGQ==
X-Gm-Message-State: AOAM53303hAy+LaZSnzRh+2eLsz4VbHcjFDHX5qMo1eHdfUYFkryltYo
        XKtO1hk51eLSKM84yBFKeGdkn4igiqSwAA==
X-Google-Smtp-Source: ABdhPJxoEEhWp2AxpuouHnXsWemztBEZwBidkpGKlG8lkNcfhRw1mDLnGp9wrKIDXZw0+7LDv2f1GQ==
X-Received: by 2002:a1c:a553:: with SMTP id o80mr2792640wme.20.1612358423443;
        Wed, 03 Feb 2021 05:20:23 -0800 (PST)
Received: from jwang-Latitude-5491.fritz.box ([2001:16b8:4947:3c00:7cf4:7472:391:9d0d])
        by smtp.gmail.com with ESMTPSA id d10sm3738430wrn.88.2021.02.03.05.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 05:20:22 -0800 (PST)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [stable-4.19 0/8] Some misc fixes
Date:   Wed,  3 Feb 2021 14:20:14 +0100
Message-Id: <20210203132022.92406-1-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, hi Sasha,

Please consider to include following fixes in to stable tree.
The 6 patches from Ming was fixing a deadlock, they are included around kernel
5.3/4. Would be good to included in 4.19, we hit it during testing, with the fix
we no longer hit the deadlock.

The md fixes is for a panic regarding handle flush.

the last one is simple NULL pointer deref fix.

Thanks!
Jack Wang @ IONOS Cloud.

Ming Lei (6):
  block: don't hold q->sysfs_lock in elevator_init_mq
  blk-mq: don't hold q->sysfs_lock in blk_mq_map_swqueue
  block: add helper for checking if queue is registered
  block: split .sysfs_lock into two locks
  block: fix race between switching elevator and removing queues
  block: don't release queue's sysfs lock during switching elevator

Xiao Ni (1):
  md: Set prev_flush_start and flush_bio in an atomic way

zhengbin (1):
  block: fix NULL pointer dereference in register_disk

 block/blk-core.c       |  1 +
 block/blk-mq-sysfs.c   | 12 +++++------
 block/blk-mq.c         |  7 ------
 block/blk-sysfs.c      | 49 +++++++++++++++++++++++++++---------------
 block/blk-wbt.c        |  2 +-
 block/blk.h            |  2 +-
 block/elevator.c       | 44 +++++++++++++++++++++----------------
 block/genhd.c          | 10 +++++----
 drivers/md/md.c        |  2 ++
 include/linux/blkdev.h |  2 ++
 10 files changed, 76 insertions(+), 55 deletions(-)

-- 
2.25.1

