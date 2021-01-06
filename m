Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188352EC1A0
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 18:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbhAFRB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 12:01:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbhAFRB0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 12:01:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CE8423123;
        Wed,  6 Jan 2021 17:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609952444;
        bh=RnBV6ycCBeKADH6mVmYNN6BtLdCFaC1Kh1NmnKi9t64=;
        h=From:To:Cc:Subject:Date:From;
        b=H0pjX1IeoeXHIyFKRPnkRSE6jMwft4O6aUg6DrYX9t8lsIfeiDuOXoUfEFh7Y+kDk
         mxsjO/DvS7glB4/0hNBBlgMn/BA7rMGQS0Cyhkld6UnJgI9tFPrwUUVw7NrN1Rr3bm
         pQW+0602VLkJZbqSa8aCYqvBObZdRk23e6YoPxWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.87
Date:   Wed,  6 Jan 2021 18:02:03 +0100
Message-Id: <1609952522189204@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.87 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                |    2 
 arch/powerpc/include/asm/bitops.h       |   23 +++
 arch/powerpc/sysdev/mpic_msgr.c         |    2 
 arch/um/drivers/ubd_kern.c              |  191 +++++++++++++++++++-------------
 arch/x86/kvm/cpuid.h                    |   14 ++
 arch/x86/kvm/svm.c                      |   17 +-
 arch/x86/kvm/vmx/vmx.c                  |   13 +-
 arch/x86/kvm/x86.c                      |   22 +++
 arch/x86/kvm/x86.h                      |    1 
 block/blk-pm.c                          |   15 +-
 drivers/block/null_blk_zoned.c          |   19 ++-
 drivers/bluetooth/hci_h5.c              |    8 +
 drivers/i3c/master.c                    |    5 
 drivers/md/dm-verity-target.c           |   12 +-
 drivers/md/raid10.c                     |    3 
 drivers/media/usb/dvb-usb/gp8psk.c      |    2 
 drivers/misc/vmw_vmci/vmci_context.c    |    2 
 drivers/rtc/rtc-pl031.c                 |    6 -
 drivers/rtc/rtc-sun6i.c                 |    8 -
 drivers/scsi/cxgbi/cxgb4i/Kconfig       |    1 
 drivers/thermal/cpu_cooling.c           |    9 +
 drivers/vfio/pci/vfio_pci.c             |    3 
 fs/bfs/inode.c                          |    2 
 fs/btrfs/ioctl.c                        |   39 ++++++
 fs/crypto/fscrypt_private.h             |    5 
 fs/crypto/hooks.c                       |   10 -
 fs/crypto/keysetup.c                    |    2 
 fs/crypto/policy.c                      |    6 -
 fs/ext4/namei.c                         |    3 
 fs/ext4/super.c                         |   14 +-
 fs/f2fs/checkpoint.c                    |    2 
 fs/f2fs/debug.c                         |   11 +
 fs/f2fs/f2fs.h                          |   12 +-
 fs/f2fs/node.c                          |   29 +++-
 fs/f2fs/node.h                          |    4 
 fs/f2fs/shrinker.c                      |    4 
 fs/f2fs/super.c                         |    9 -
 fs/fcntl.c                              |   10 +
 fs/jffs2/jffs2_fs_sb.h                  |    1 
 fs/jffs2/super.c                        |   17 +-
 fs/namespace.c                          |    9 +
 fs/nfs/nfs4super.c                      |    2 
 fs/nfs/pnfs.c                           |   33 +++++
 fs/nfs/pnfs.h                           |    5 
 fs/pnode.h                              |    2 
 fs/quota/quota_tree.c                   |    8 -
 fs/reiserfs/stree.c                     |    6 +
 fs/ubifs/dir.c                          |   17 ++
 include/linux/fscrypt.h                 |   34 +++++
 include/linux/of.h                      |    1 
 include/uapi/linux/const.h              |    5 
 include/uapi/linux/ethtool.h            |    2 
 include/uapi/linux/fscrypt.h            |    5 
 include/uapi/linux/kernel.h             |    9 -
 include/uapi/linux/lightnvm.h           |    2 
 include/uapi/linux/mroute6.h            |    2 
 include/uapi/linux/netfilter/x_tables.h |    2 
 include/uapi/linux/netlink.h            |    2 
 include/uapi/linux/sysctl.h             |    2 
 kernel/cgroup/cgroup-v1.c               |    2 
 kernel/module.c                         |    6 -
 kernel/time/tick-sched.c                |    7 -
 net/sched/sch_taprio.c                  |   17 ++
 sound/core/pcm_native.c                 |    9 +
 sound/core/rawmidi.c                    |   49 +++++---
 sound/core/seq/seq_queue.h              |    8 -
 tools/include/uapi/linux/const.h        |    5 
 67 files changed, 562 insertions(+), 247 deletions(-)

Anant Thazhemadam (2):
      Bluetooth: hci_h5: close serdev device and free hu in h5_close
      misc: vmw_vmci: fix kernel info-leak by initializing dbells in vmci_ctx_get_chkpt_doorbells()

Arnaldo Carvalho de Melo (1):
      tools headers UAPI: Sync linux/const.h with the kernel headers

Bart Van Assche (1):
      scsi: block: Fix a race in the runtime power management code

Boqun Feng (1):
      fcntl: Fix potential deadlock in send_sig{io, urg}()

Chao Yu (1):
      f2fs: fix shift-out-of-bounds in sanity_check_raw_super()

Christophe Leroy (1):
      powerpc/bitops: Fix possible undefined behaviour with fls() and fls64()

Damien Le Moal (1):
      null_blk: Fix zone size initialization

Davide Caratti (1):
      net/sched: sch_taprio: reset child qdiscs before freeing them

Dinghao Liu (1):
      rtc: sun6i: Fix memleak in sun6i_rtc_clk_init

Eric Auger (1):
      vfio/pci: Move dummy_resources_list init in vfio_pci_probe()

Eric Biggers (6):
      ext4: prevent creating duplicate encrypted filenames
      ubifs: prevent creating duplicate encrypted filenames
      f2fs: prevent creating duplicate encrypted filenames
      fscrypt: add fscrypt_is_nokey_name()
      fscrypt: remove kernel-internal constants from UAPI header
      fs/namespace.c: WARN if mnt_count has become negative

Filipe Manana (1):
      btrfs: fix race when defragmenting leads to unnecessary IO

Gabriel Krisman Bertazi (1):
      um: ubd: Submit all data segments atomically

Greg Kroah-Hartman (1):
      Linux 5.4.87

Hyeongseok Kim (1):
      dm verity: skip verity work if I/O error when system is shutting down

Jaegeuk Kim (1):
      f2fs: avoid race condition for shrinker count

Jamie Iles (1):
      jffs2: Fix NULL pointer dereference in rp_size fs option parsing

Jan Kara (2):
      ext4: don't remount read-only with errors=continue on reboot
      quota: Don't overflow quota file offsets

Jessica Yu (1):
      module: delay kobject uevent until after module init call

Johan Hovold (1):
      of: fix linker-section match-table corruption

Kevin Vigor (1):
      md/raid10: initialize r10_bio->read_slot before use.

Mauro Carvalho Chehab (1):
      media: gp8psk: initialize stats at power control logic

Miroslav Benes (1):
      module: set MODULE_STATE_GOING state when a module fails to load

Paolo Bonzini (3):
      KVM: x86: avoid incorrect writes to host MSR_IA32_SPEC_CTRL
      KVM: SVM: relax conditions for allowing MSR_IA32_SPEC_CTRL accesses
      KVM: x86: reinstate vendor-agnostic check on SPEC_CTRL cpuid bits

Petr Vorel (1):
      uapi: move constants from <linux/kernel.h> to <linux/const.h>

Qinglang Miao (3):
      cgroup: Fix memory leak when parsing multiple source parameters
      powerpc: sysdev: add missing iounmap() on error in mpic_msgr_probe()
      i3c master: fix missing destroy_workqueue() on error in i3c_master_register

Randy Dunlap (2):
      scsi: cxgb4i: Fix TLS dependency
      bfs: don't use WARNING: string when it's just info.

Rustam Kovhaev (1):
      reiserfs: add check for an invalid ih_entry_count

Takashi Iwai (3):
      ALSA: seq: Use bool for snd_seq_queue internal flags
      ALSA: rawmidi: Access runtime->avail always in spinlock
      ALSA: pcm: Clear the full allocated memory at hw_params

Thomas Gleixner (1):
      tick/sched: Remove bogus boot "safety" check

Trond Myklebust (1):
      NFSv4: Fix a pNFS layout related use-after-free race when freeing the inode

Zheng Liang (1):
      rtc: pl031: fix resource leak in pl031_probe

Zhuguangqing (1):
      thermal/drivers/cpufreq_cooling: Update cpufreq_state only if state has changed

lizhe (1):
      jffs2: Allow setting rp_size to zero during remounting

