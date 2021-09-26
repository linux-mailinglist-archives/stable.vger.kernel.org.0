Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F284188C6
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 14:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbhIZMvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 08:51:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231559AbhIZMvf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 08:51:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A797960FED;
        Sun, 26 Sep 2021 12:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632660599;
        bh=5XsgsKIfiBpKIU+gXb8FQnOj3A898ES8P626jDooEds=;
        h=From:To:Cc:Subject:Date:From;
        b=LDsn2J9AFOTnmMT/GWsvXvWdjfuJj+Ss00nS/aba36lwztaBf8hAm/AuzP4GJD7/H
         fPenL/3Uz0eJFtG/Y+lziPQQha4ndG6BBKI9BsueEo8ZUL+A9oP9GoctW6j4YwGMVQ
         Uo7yj6ttPc8QVHGGlMd5KGXRKSOkBA7clmK6Er44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.208
Date:   Sun, 26 Sep 2021 14:49:47 +0200
Message-Id: <16326605887364@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.208 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/arm64/kernel/cacheinfo.c                     |    7 ---
 arch/mips/kernel/cacheinfo.c                      |    7 ---
 arch/riscv/kernel/cacheinfo.c                     |    7 ---
 arch/s390/net/bpf_jit_comp.c                      |   50 +++++++++++-----------
 arch/x86/kernel/cpu/cacheinfo.c                   |    7 ---
 block/blk-throttle.c                              |    1 
 drivers/crypto/talitos.c                          |    2 
 drivers/dma/Kconfig                               |    2 
 drivers/dma/acpi-dma.c                            |   10 +++-
 drivers/dma/sprd-dma.c                            |    1 
 drivers/dma/xilinx/xilinx_dma.c                   |    2 
 drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c |    2 
 drivers/parisc/dino.c                             |   18 +++----
 drivers/pwm/pwm-img.c                             |   16 -------
 drivers/pwm/pwm-lpc32xx.c                         |   10 ++--
 drivers/pwm/pwm-rockchip.c                        |   14 ------
 drivers/pwm/pwm-stm32-lp.c                        |    2 
 drivers/thermal/samsung/exynos_tmu.c              |    1 
 fs/ceph/caps.c                                    |    2 
 fs/nilfs2/sysfs.c                                 |   26 ++++-------
 fs/nilfs2/the_nilfs.c                             |    9 +--
 include/linux/cacheinfo.h                         |   18 -------
 include/linux/kvm_host.h                          |   11 +---
 kernel/profile.c                                  |   21 ++++-----
 kernel/rcu/tree_exp.h                             |    2 
 kernel/sys.c                                      |    7 ---
 kernel/trace/trace_kprobe.c                       |    3 -
 lib/Kconfig.debug                                 |    1 
 net/9p/trans_virtio.c                             |    4 +
 net/sctp/input.c                                  |    3 +
 net/sctp/sm_make_chunk.c                          |   13 ++++-
 security/apparmor/apparmorfs.c                    |    3 -
 virt/kvm/kvm_main.c                               |    5 +-
 34 files changed, 116 insertions(+), 173 deletions(-)

Andy Shevchenko (2):
      apparmor: remove duplicate macro list_entry_is_head()
      dmaengine: acpi: Avoid comparison GSI with Linux vIRQ

Christophe Leroy (1):
      crypto: talitos - fix max key size for sha384 and sha512

Cyrill Gorcunov (1):
      prctl: allow to setup brk for et_dyn executables

Dan Carpenter (1):
      thermal/drivers/exynos: Fix an error code in exynos_tmu_probe()

Greg Kroah-Hartman (1):
      Linux 4.19.208

Guenter Roeck (2):
      parisc: Move pci_dev_is_behind_card_dino to where it is used
      drm/nouveau/nvkm: Replace -ENOSYS with -ENODEV

Ilya Leoshkevich (1):
      s390/bpf: Fix optimizing out zero-extensions

Jeff Layton (1):
      ceph: lockdep annotations for try_nonblocking_invalidate

Johannes Berg (1):
      dmaengine: ioat: depends on !UML

Li Huafei (1):
      tracing/kprobe: Fix kprobe_on_func_entry() modification

Li Jinlin (1):
      blk-throttle: fix UAF by deleteing timer in blk_throtl_exit()

Lukas Bulwahn (1):
      Kconfig.debug: drop selecting non-existing HARDLOCKUP_DETECTOR_ARCH

Marcelo Ricardo Leitner (2):
      sctp: validate chunk size in __rcv_asconf_lookup
      sctp: add param size validation for SCTP_PARAM_SET_PRIMARY

Nanyong Sun (6):
      nilfs2: fix memory leak in nilfs_sysfs_create_device_group
      nilfs2: fix NULL pointer in nilfs_##name##_attr_release
      nilfs2: fix memory leak in nilfs_sysfs_create_##name##_group
      nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group
      nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
      nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group

Neeraj Upadhyay (1):
      rcu: Fix missed wakeup of exp_wq waiters

Pavel Skripkin (1):
      profiling: fix shift-out-of-bounds bugs

Radhey Shyam Pandey (1):
      dmaengine: xilinx_dma: Set DMA mask for coherent APIs

Radim Krčmář (1):
      KVM: remember position in kvm->vcpus array

Thomas Gleixner (1):
      drivers: base: cacheinfo: Get rid of DEFINE_SMP_CALL_CACHE_FUNCTION()

Uwe Kleine-König (4):
      pwm: lpc32xx: Don't modify HW state in .probe() after the PWM chip was registered
      pwm: img: Don't modify HW state in .remove() callback
      pwm: rockchip: Don't modify HW state in .remove() callback
      pwm: stm32-lp: Don't modify HW state in .remove() callback

Xie Yongji (1):
      9p/trans_virtio: Remove sysfs file on probe failure

Zhen Lei (1):
      nilfs2: use refcount_dec_and_lock() to fix potential UAF

Zou Wei (1):
      dmaengine: sprd: Add missing MODULE_DEVICE_TABLE

