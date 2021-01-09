Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758682F00CA
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 16:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbhAIP0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 10:26:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:57202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbhAIP0d (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Jan 2021 10:26:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49B8D23A69;
        Sat,  9 Jan 2021 15:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610205932;
        bh=B7WlYzitE+pDeLm7eXl8xcZS0Dkh1PAf3at05qwOfAI=;
        h=From:To:Cc:Subject:Date:From;
        b=MOuu54RXQzZm4rR++L+5H59jA7cHizEBMlf80a1hdq8FSHrNieusr7DwoN5r1SltP
         RTphyHQKFYgqqFSVXECmvon7KRCSDkxEKPTImTt6wURUHpLhXwxPujEENxJPjh3gYn
         tmwozVa/dFPeWlbwUid/LgCTTMZEf/tllw0eRuUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.88
Date:   Sat,  9 Jan 2021 16:26:44 +0100
Message-Id: <161020600422122@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.88 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 drivers/dma/at_hdmac.c                            |   11 +++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 -
 drivers/iio/imu/bmi160/bmi160.h                   |    7 ++
 drivers/iio/imu/bmi160/bmi160_core.c              |    6 --
 drivers/mtd/nand/spi/core.c                       |    4 -
 drivers/net/wireless/marvell/mwifiex/join.c       |    2 
 fs/exec.c                                         |   12 ++---
 fs/fuse/acl.c                                     |    6 ++
 fs/fuse/dir.c                                     |   37 +++++++++++++--
 fs/fuse/file.c                                    |   19 ++++----
 fs/fuse/fuse_i.h                                  |   12 +++++
 fs/fuse/inode.c                                   |    4 -
 fs/fuse/readdir.c                                 |    4 -
 fs/fuse/xattr.c                                   |    9 +++
 fs/proc/base.c                                    |   10 ++--
 include/linux/kdev_t.h                            |   22 ++++-----
 include/linux/rwsem.h                             |    3 +
 include/linux/sched/signal.h                      |   11 ++--
 init/init_task.c                                  |    2 
 kernel/events/core.c                              |   52 +++++++++++-----------
 kernel/fork.c                                     |    6 +-
 kernel/kcmp.c                                     |   30 ++++++------
 kernel/locking/rwsem.c                            |   40 ++++++++++++++++
 24 files changed, 211 insertions(+), 103 deletions(-)

Alex Deucher (1):
      Revert "drm/amd/display: Fix memory leaks in S3 resume"

Eric W. Biederman (3):
      rwsem: Implement down_read_killable_nested
      rwsem: Implement down_read_interruptible
      exec: Transform exec_update_mutex into a rw_semaphore

Felix Fietkau (1):
      Revert "mtd: spinand: Fix OOB read"

Greg Kroah-Hartman (1):
      Linux 5.4.88

Jonathan Cameron (1):
      iio:imu:bmi160: Fix alignment and data leak issues

Josh Poimboeuf (1):
      kdev_t: always inline major/minor helper functions

Miklos Szeredi (1):
      fuse: fix bad inode

Tudor Ambarus (1):
      dmaengine: at_hdmac: Substitute kzalloc with kmalloc

Yu Kuai (2):
      dmaengine: at_hdmac: add missing put_device() call in at_dma_xlate()
      dmaengine: at_hdmac: add missing kfree() call in at_dma_xlate()

Zhang Xiaohui (1):
      mwifiex: Fix possible buffer overflows in mwifiex_cmd_802_11_ad_hoc_start

peterz@infradead.org (1):
      perf: Break deadlock involving exec_update_mutex

