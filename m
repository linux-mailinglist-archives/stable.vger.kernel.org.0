Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE8E1630DD
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 20:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgBRT5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:57:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727815AbgBRT5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:57:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7610724125;
        Tue, 18 Feb 2020 19:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055824;
        bh=0NMSIlgeucUhav4NZuD/7fuGpHzVSMpOsAVbdoEeNw0=;
        h=From:To:Cc:Subject:Date:From;
        b=GMRjLNdQaUAMMQQARjuVqrT+GnO61yR8dv6dUOSoiFaaUgF+lb7KcckCt74S/OGcx
         RQ7msRNNpnViMUYgw0xZ9Mg83YZETxdeaqFzocy2wim5/AyKJeFnpZMxoMCluyGL0x
         6iG8+1tk1Ciufr7z/hPZ7FLYZrHrW25jPbrQBIbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/38] 4.19.105-stable review
Date:   Tue, 18 Feb 2020 20:54:46 +0100
Message-Id: <20200218190418.536430858@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.105-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.105-rc1
X-KernelTest-Deadline: 2020-02-20T19:04+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.105 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 20 Feb 2020 19:03:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.105-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.105-rc1

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86/mmu: Fix struct guest_walker arrays for 5-level paging

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: do not clear the BH_Mapped flag when forgetting a metadata buffer

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: move the clearing of b_modified flag to the journal_unmap_buffer()

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.1 make cachethis=no for writes

Mike Jones <michael-a1.jones@analog.com>
    hwmon: (pmbus/ltc2978) Fix PMBus polling of MFR_COMMON definitions.

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix inaccurate period in context switch for auto-reload

Nathan Chancellor <natechancellor@gmail.com>
    s390/time: Fix clk type in get_tod_clock

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Fix protection fault in get_pkey_idx_qp_list

Zhu Yanjun <yanjunz@mellanox.com>
    RDMA/rxe: Fix soft lockup problem due to using tasklets in softirq

Kamal Heib <kamalheib1@gmail.com>
    RDMA/hfi1: Fix memory leak in _dev_comp_vect_mappings_create

Avihai Horon <avihaih@mellanox.com>
    RDMA/core: Fix invalid memory access in spec_filter_size

Kaike Wan <kaike.wan@intel.com>
    IB/rdmavt: Reset all QPs when the device is shut down

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Close window for pq and request coliding

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Acquire lock to release TID entries when user file is closed

Yi Zhang <yi.zhang@redhat.com>
    nvme: fix the parameter order for nvme_get_log in nvme_get_fw_slot_info

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd: Add missing L2 misses event spec to AMD Family 17h's event map

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Use correct root level for nested EPT shadow page tables

Will Deacon <will@kernel.org>
    arm64: ssbs: Fix context-switch when SSBS is present on all CPUs

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: npcm: Bring back GPIOLIB support

David Sterba <dsterba@suse.com>
    btrfs: log message when rw remount is attempted with unclean tree-log

David Sterba <dsterba@suse.com>
    btrfs: print message when tree-log replay starts

Wenwen Wang <wenwen@cs.uga.edu>
    btrfs: ref-verify: fix memory leaks

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race between using extent maps and merging them

Theodore Ts'o <tytso@mit.edu>
    ext4: improve explanation of a mount failure caused by a misconfigured kernel

Shijie Luo <luoshijie1@huawei.com>
    ext4: add cond_resched() to ext4_protect_reserved_inode

Jan Kara <jack@suse.cz>
    ext4: fix checksum errors with indexed dirs

Theodore Ts'o <tytso@mit.edu>
    ext4: fix support for inode sizes > 1024 bytes

Andreas Dilger <adilger@dilger.ca>
    ext4: don't assume that mmp_nodename/bdevname have NUL

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Add clock validity quirk for Denon MC7000/MCX8000

Saurav Girepunje <saurav.girepunje@gmail.com>
    ALSA: usb-audio: sound: usb: usb true/false for bool return type

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: nofpsmid: Handle TIF_FOREIGN_FPSTATE flag cleanly

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: cpufeature: Set the FP/SIMD compat HWCAP bits properly

Arvind Sankar <nivedita@alum.mit.edu>
    ALSA: usb-audio: Apply sample rate quirk for Audioengine D1

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Fix silent output on MSI-GL73

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix UAC2/3 effect unit parsing

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    Input: synaptics - remove the LEN0049 dmi id from topbuttonpad list

Gaurav Agrawal <agrawalgaurav@gnome.org>
    Input: synaptics - enable SMBus on ThinkPad L470

Lyude Paul <lyude@redhat.com>
    Input: synaptics - switch T470s to RMI4 by default


-------------

Diffstat:

 Makefile                                  |  4 +-
 arch/arm/mach-npcm/Kconfig                |  2 +-
 arch/arm64/kernel/cpufeature.c            | 52 +++++++++++++---
 arch/arm64/kernel/fpsimd.c                | 20 ++++++-
 arch/arm64/kernel/process.c               |  7 +++
 arch/arm64/kvm/hyp/switch.c               | 10 +++-
 arch/s390/include/asm/timex.h             |  2 +-
 arch/x86/events/amd/core.c                |  1 +
 arch/x86/events/intel/ds.c                |  2 +
 arch/x86/kvm/paging_tmpl.h                |  2 +-
 arch/x86/kvm/vmx/vmx.c                    |  3 +
 drivers/hwmon/pmbus/ltc2978.c             |  4 +-
 drivers/infiniband/core/security.c        | 24 +++-----
 drivers/infiniband/core/uverbs_cmd.c      | 15 +++--
 drivers/infiniband/hw/hfi1/affinity.c     |  2 +
 drivers/infiniband/hw/hfi1/file_ops.c     | 52 +++++++++-------
 drivers/infiniband/hw/hfi1/hfi.h          |  5 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |  5 +-
 drivers/infiniband/hw/hfi1/user_sdma.c    | 17 ++++--
 drivers/infiniband/sw/rdmavt/qp.c         | 84 +++++++++++++++-----------
 drivers/infiniband/sw/rxe/rxe_comp.c      |  8 +--
 drivers/input/mouse/synaptics.c           |  4 +-
 drivers/nvme/host/core.c                  |  2 +-
 fs/btrfs/disk-io.c                        |  1 +
 fs/btrfs/extent_map.c                     | 11 ++++
 fs/btrfs/ref-verify.c                     |  5 ++
 fs/btrfs/super.c                          |  2 +
 fs/ext4/block_validity.c                  |  1 +
 fs/ext4/dir.c                             | 14 +++--
 fs/ext4/ext4.h                            |  5 +-
 fs/ext4/inode.c                           | 12 ++++
 fs/ext4/mmp.c                             | 12 ++--
 fs/ext4/namei.c                           |  7 +++
 fs/ext4/super.c                           | 32 +++++-----
 fs/jbd2/commit.c                          | 46 +++++++-------
 fs/jbd2/transaction.c                     | 10 ++--
 fs/nfs/nfs4proc.c                         |  2 +-
 sound/pci/hda/patch_realtek.c             |  1 +
 sound/usb/clock.c                         | 99 +++++++++++++++++++++----------
 sound/usb/clock.h                         |  4 +-
 sound/usb/format.c                        |  3 +-
 sound/usb/mixer.c                         | 12 +++-
 sound/usb/quirks.c                        |  1 +
 43 files changed, 405 insertions(+), 202 deletions(-)


