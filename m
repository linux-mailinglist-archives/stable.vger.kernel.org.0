Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD354188B9
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 14:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhIZMvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 08:51:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231469AbhIZMvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 08:51:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9691A60F6D;
        Sun, 26 Sep 2021 12:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632660577;
        bh=fdTguQ0s8aFkEqvA84sLuRe9n421hOEESNXVc2xoDok=;
        h=From:To:Cc:Subject:Date:From;
        b=XKqPVFLqGIuUTJLekbl5VxrJOXCs1YvtETHsiQR0ZmHmpu8ZWuQaHsXj+wTshdRNB
         R6Lk+z+M7LxwdIfJsjioCAL4a83Q1t1Kz0+RcObBkhBM86ueGta+Ij/9GaCubaycTP
         VT9L+a3CKk5iJ5Ll/dOukBcMfztE9dzVQc0+RVK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.285
Date:   Sun, 26 Sep 2021 14:49:33 +0200
Message-Id: <1632660573182224@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.285 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/s390/net/bpf_jit_comp.c                      |   50 +++++++++++-----------
 block/blk-throttle.c                              |    1 
 drivers/base/power/wakeirq.c                      |    6 +-
 drivers/dma/Kconfig                               |    2 
 drivers/dma/acpi-dma.c                            |   11 +++-
 drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c |    2 
 drivers/parisc/dino.c                             |   18 +++----
 drivers/thermal/samsung/exynos_tmu.c              |    1 
 fs/ceph/caps.c                                    |    2 
 fs/nilfs2/sysfs.c                                 |   26 ++++-------
 include/net/sctp/structs.h                        |    2 
 kernel/profile.c                                  |   21 ++++-----
 kernel/sys.c                                      |    7 ---
 net/9p/trans_virtio.c                             |    4 +
 net/sctp/bind_addr.c                              |   20 ++++----
 net/sctp/input.c                                  |    9 +++
 net/sctp/ipv6.c                                   |    7 ++-
 net/sctp/protocol.c                               |    7 ++-
 net/sctp/sm_make_chunk.c                          |   42 +++++++++++-------
 20 files changed, 137 insertions(+), 103 deletions(-)

Andy Shevchenko (2):
      dmaengine: acpi-dma: check for 64-bit MMIO address
      dmaengine: acpi: Avoid comparison GSI with Linux vIRQ

Cyrill Gorcunov (1):
      prctl: allow to setup brk for et_dyn executables

Dan Carpenter (1):
      thermal/drivers/exynos: Fix an error code in exynos_tmu_probe()

Greg Kroah-Hartman (1):
      Linux 4.4.285

Guenter Roeck (2):
      parisc: Move pci_dev_is_behind_card_dino to where it is used
      drm/nouveau/nvkm: Replace -ENOSYS with -ENODEV

Ilya Leoshkevich (1):
      s390/bpf: Fix optimizing out zero-extensions

Jeff Layton (1):
      ceph: lockdep annotations for try_nonblocking_invalidate

Johannes Berg (1):
      dmaengine: ioat: depends on !UML

Li Jinlin (1):
      blk-throttle: fix UAF by deleteing timer in blk_throtl_exit()

Marcelo Ricardo Leitner (3):
      sctp: validate chunk size in __rcv_asconf_lookup
      sctp: add param size validation for SCTP_PARAM_SET_PRIMARY
      sctp: validate from_addr_param return

Nanyong Sun (6):
      nilfs2: fix memory leak in nilfs_sysfs_create_device_group
      nilfs2: fix NULL pointer in nilfs_##name##_attr_release
      nilfs2: fix memory leak in nilfs_sysfs_create_##name##_group
      nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group
      nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
      nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group

Pavel Skripkin (1):
      profiling: fix shift-out-of-bounds bugs

Tony Lindgren (1):
      PM / wakeirq: Fix unbalanced IRQ enable for wakeirq

Xie Yongji (1):
      9p/trans_virtio: Remove sysfs file on probe failure

