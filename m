Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D452E9A25
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbhADQAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:00:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:36550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728271AbhADQAQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:00:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E2A422519;
        Mon,  4 Jan 2021 15:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775990;
        bh=/A+0PPU8oD04tPrGRxmPMk3CYXBpm6qDL81YlBXsRc4=;
        h=From:To:Cc:Subject:Date:From;
        b=FWjTnsw2iyuaglnn8wCCn5GDm64TvPq9jiSGHa+PH8qbyzDg1uu4lHLMe6BHN8rTG
         MFN5q6sOQngWLZKVHON8fQgGW6gmrIPl+lWavybzLvfSxefR2lQHZFuRsYRLLPJaJQ
         vSc5uqf/VrJmgHSKUIh1VWq3dZIkPo8VyYs0aDSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.4 00/47] 5.4.87-rc1 review
Date:   Mon,  4 Jan 2021 16:56:59 +0100
Message-Id: <20210104155705.740576914@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.87-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.87-rc1
X-KernelTest-Deadline: 2021-01-06T15:57+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.87 release.
There are 47 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 06 Jan 2021 15:56:52 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.87-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.87-rc1

Hyeongseok Kim <hyeongseok@gmail.com>
    dm verity: skip verity work if I/O error when system is shutting down

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Clear the full allocated memory at hw_params

Thomas Gleixner <tglx@linutronix.de>
    tick/sched: Remove bogus boot "safety" check

Gabriel Krisman Bertazi <krisman@collabora.com>
    um: ubd: Submit all data segments atomically

Eric Biggers <ebiggers@google.com>
    fs/namespace.c: WARN if mnt_count has become negative

Jessica Yu <jeyu@kernel.org>
    module: delay kobject uevent until after module init call

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: avoid race condition for shrinker count

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix a pNFS layout related use-after-free race when freeing the inode

Qinglang Miao <miaoqinglang@huawei.com>
    i3c master: fix missing destroy_workqueue() on error in i3c_master_register

Qinglang Miao <miaoqinglang@huawei.com>
    powerpc: sysdev: add missing iounmap() on error in mpic_msgr_probe()

Zheng Liang <zhengliang6@huawei.com>
    rtc: pl031: fix resource leak in pl031_probe

Jan Kara <jack@suse.cz>
    quota: Don't overflow quota file offsets

Miroslav Benes <mbenes@suse.cz>
    module: set MODULE_STATE_GOING state when a module fails to load

Dinghao Liu <dinghao.liu@zju.edu.cn>
    rtc: sun6i: Fix memleak in sun6i_rtc_clk_init

Boqun Feng <boqun.feng@gmail.com>
    fcntl: Fix potential deadlock in send_sig{io, urg}()

Randy Dunlap <rdunlap@infradead.org>
    bfs: don't use WARNING: string when it's just info.

Takashi Iwai <tiwai@suse.de>
    ALSA: rawmidi: Access runtime->avail always in spinlock

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Use bool for snd_seq_queue internal flags

Chao Yu <chao@kernel.org>
    f2fs: fix shift-out-of-bounds in sanity_check_raw_super()

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: gp8psk: initialize stats at power control logic

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    misc: vmw_vmci: fix kernel info-leak by initializing dbells in vmci_ctx_get_chkpt_doorbells()

Rustam Kovhaev <rkovhaev@gmail.com>
    reiserfs: add check for an invalid ih_entry_count

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    Bluetooth: hci_h5: close serdev device and free hu in h5_close

Randy Dunlap <rdunlap@infradead.org>
    scsi: cxgb4i: Fix TLS dependency

Qinglang Miao <miaoqinglang@huawei.com>
    cgroup: Fix memory leak when parsing multiple source parameters

Johan Hovold <johan@kernel.org>
    of: fix linker-section match-table corruption

Damien Le Moal <damien.lemoal@wdc.com>
    null_blk: Fix zone size initialization

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools headers UAPI: Sync linux/const.h with the kernel headers

Petr Vorel <petr.vorel@gmail.com>
    uapi: move constants from <linux/kernel.h> to <linux/const.h>

Bart Van Assche <bvanassche@acm.org>
    scsi: block: Fix a race in the runtime power management code

Jamie Iles <jamie@nuviainc.com>
    jffs2: Fix NULL pointer dereference in rp_size fs option parsing

lizhe <lizhe67@huawei.com>
    jffs2: Allow setting rp_size to zero during remounting

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/bitops: Fix possible undefined behaviour with fls() and fls64()

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: reinstate vendor-agnostic check on SPEC_CTRL cpuid bits

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SVM: relax conditions for allowing MSR_IA32_SPEC_CTRL accesses

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: avoid incorrect writes to host MSR_IA32_SPEC_CTRL

Jan Kara <jack@suse.cz>
    ext4: don't remount read-only with errors=continue on reboot

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race when defragmenting leads to unnecessary IO

Eric Auger <eric.auger@redhat.com>
    vfio/pci: Move dummy_resources_list init in vfio_pci_probe()

Eric Biggers <ebiggers@google.com>
    fscrypt: remove kernel-internal constants from UAPI header

Eric Biggers <ebiggers@google.com>
    fscrypt: add fscrypt_is_nokey_name()

Eric Biggers <ebiggers@google.com>
    f2fs: prevent creating duplicate encrypted filenames

Eric Biggers <ebiggers@google.com>
    ubifs: prevent creating duplicate encrypted filenames

Eric Biggers <ebiggers@google.com>
    ext4: prevent creating duplicate encrypted filenames

Zhuguangqing <zhuguangqing@xiaomi.com>
    thermal/drivers/cpufreq_cooling: Update cpufreq_state only if state has changed

Kevin Vigor <kvigor@gmail.com>
    md/raid10: initialize r10_bio->read_slot before use.

Davide Caratti <dcaratti@redhat.com>
    net/sched: sch_taprio: reset child qdiscs before freeing them


-------------

Diffstat:

 Makefile                                |   4 +-
 arch/powerpc/include/asm/bitops.h       |  23 +++-
 arch/powerpc/sysdev/mpic_msgr.c         |   2 +-
 arch/um/drivers/ubd_kern.c              | 191 +++++++++++++++++++-------------
 arch/x86/kvm/cpuid.h                    |  14 +++
 arch/x86/kvm/svm.c                      |  17 +--
 arch/x86/kvm/vmx/vmx.c                  |  13 +--
 arch/x86/kvm/x86.c                      |  22 ++++
 arch/x86/kvm/x86.h                      |   1 +
 block/blk-pm.c                          |  15 ++-
 drivers/block/null_blk_zoned.c          |  19 ++--
 drivers/bluetooth/hci_h5.c              |   8 +-
 drivers/i3c/master.c                    |   5 +-
 drivers/md/dm-verity-target.c           |  12 +-
 drivers/md/raid10.c                     |   3 +-
 drivers/media/usb/dvb-usb/gp8psk.c      |   2 +-
 drivers/misc/vmw_vmci/vmci_context.c    |   2 +-
 drivers/rtc/rtc-pl031.c                 |   6 +-
 drivers/rtc/rtc-sun6i.c                 |   8 +-
 drivers/scsi/cxgbi/cxgb4i/Kconfig       |   1 +
 drivers/thermal/cpu_cooling.c           |   9 +-
 drivers/vfio/pci/vfio_pci.c             |   3 +-
 fs/bfs/inode.c                          |   2 +-
 fs/btrfs/ioctl.c                        |  39 +++++++
 fs/crypto/fscrypt_private.h             |   5 +-
 fs/crypto/hooks.c                       |  10 +-
 fs/crypto/keysetup.c                    |   2 +
 fs/crypto/policy.c                      |   6 +-
 fs/ext4/namei.c                         |   3 +
 fs/ext4/super.c                         |  14 +--
 fs/f2fs/checkpoint.c                    |   2 +-
 fs/f2fs/debug.c                         |  11 +-
 fs/f2fs/f2fs.h                          |  12 +-
 fs/f2fs/node.c                          |  29 +++--
 fs/f2fs/node.h                          |   4 +-
 fs/f2fs/shrinker.c                      |   4 +-
 fs/f2fs/super.c                         |   9 +-
 fs/fcntl.c                              |  10 +-
 fs/jffs2/jffs2_fs_sb.h                  |   1 +
 fs/jffs2/super.c                        |  17 +--
 fs/namespace.c                          |   9 +-
 fs/nfs/nfs4super.c                      |   2 +-
 fs/nfs/pnfs.c                           |  33 +++++-
 fs/nfs/pnfs.h                           |   5 +
 fs/pnode.h                              |   2 +-
 fs/quota/quota_tree.c                   |   8 +-
 fs/reiserfs/stree.c                     |   6 +
 fs/ubifs/dir.c                          |  17 ++-
 include/linux/fscrypt.h                 |  34 ++++++
 include/linux/of.h                      |   1 +
 include/uapi/linux/const.h              |   5 +
 include/uapi/linux/ethtool.h            |   2 +-
 include/uapi/linux/fscrypt.h            |   5 +-
 include/uapi/linux/kernel.h             |   9 +-
 include/uapi/linux/lightnvm.h           |   2 +-
 include/uapi/linux/mroute6.h            |   2 +-
 include/uapi/linux/netfilter/x_tables.h |   2 +-
 include/uapi/linux/netlink.h            |   2 +-
 include/uapi/linux/sysctl.h             |   2 +-
 kernel/cgroup/cgroup-v1.c               |   2 +
 kernel/module.c                         |   6 +-
 kernel/time/tick-sched.c                |   7 --
 net/sched/sch_taprio.c                  |  17 ++-
 sound/core/pcm_native.c                 |   9 +-
 sound/core/rawmidi.c                    |  49 +++++---
 sound/core/seq/seq_queue.h              |   8 +-
 tools/include/uapi/linux/const.h        |   5 +
 67 files changed, 563 insertions(+), 248 deletions(-)


