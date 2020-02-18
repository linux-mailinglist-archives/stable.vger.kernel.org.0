Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECD616325A
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgBRT6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:58:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:35460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728096AbgBRT6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:58:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F0BA24655;
        Tue, 18 Feb 2020 19:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055879;
        bh=fXDl+dkyD/KG3eQcqm6gsy4KLwBE/pquu7AkIRMC9OA=;
        h=From:To:Cc:Subject:Date:From;
        b=sLg6xxgZew0b8F8CXpKe0xA+XqhcmWeCvCgZWcAkXZymAO0pdHQK35BTQ5HurhkSU
         mI/7620IW/+ZfXJaFbrKnAoW0WLhxJEwZiw/gv3glTvVgYhNGd89Shtr5ccabxJeUz
         lfrLpdofw4SqC0Mp3ERrUeo95kz11AZ1VFBnNL1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/66] 5.4.21-stable review
Date:   Tue, 18 Feb 2020 20:54:27 +0100
Message-Id: <20200218190428.035153861@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.21-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.21-rc1
X-KernelTest-Deadline: 2020-02-20T19:04+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.21 release.
There are 66 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 20 Feb 2020 19:03:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.21-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.21-rc1

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    mmc: core: Rework wp-gpio handling

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    gpio: add gpiod_toggle_active_low()

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86/mmu: Fix struct guest_walker arrays for 5-level paging

Chengguang Xu <cgxu519@mykernel.net>
    ext4: choose hardlimit when softlimit is larger than hardlimit in ext4_statfs_project()

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: do not clear the BH_Mapped flag when forgetting a metadata buffer

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: move the clearing of b_modified flag to the journal_unmap_buffer()

Jernej Skrabec <jernej.skrabec@siol.net>
    Revert "drm/sun4i: drv: Allow framebuffer modifiers in mode config"

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.1 make cachethis=no for writes

Kim Phillips <kim.phillips@amd.com>
    perf stat: Don't report a null stalled cycles per insn metric

Oliver Upton <oupton@google.com>
    KVM: x86: Mask off reserved bit from #DB exception payload

Marc Zyngier <maz@kernel.org>
    arm64: dts: fast models: Fix FVP PCI interrupt-map property

Petr Pavlu <petr.pavlu@suse.com>
    cifs: fix mount option display for sec=krb5i

Sara Sharon <sara.sharon@intel.com>
    mac80211: fix quiet mode activation in action frames

Mike Jones <michael-a1.jones@analog.com>
    hwmon: (pmbus/ltc2978) Fix PMBus polling of MFR_COMMON definitions.

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix inaccurate period in context switch for auto-reload

Stephen Boyd <swboyd@chromium.org>
    spmi: pmic-arb: Set lockdep class for hierarchical irq domains

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Reject negative values in cpu_uclamp_write()

Nathan Chancellor <natechancellor@gmail.com>
    s390/time: Fix clk type in get_tod_clock

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Fix protection fault in get_pkey_idx_qp_list

Zhu Yanjun <yanjunz@mellanox.com>
    RDMA/rxe: Fix soft lockup problem due to using tasklets in softirq

Kamal Heib <kamalheib1@gmail.com>
    RDMA/hfi1: Fix memory leak in _dev_comp_vect_mappings_create

Krishnamraju Eraparaju <krishna2@chelsio.com>
    RDMA/iw_cxgb4: initiate CLOSE when entering TERM

Avihai Horon <avihaih@mellanox.com>
    RDMA/core: Fix invalid memory access in spec_filter_size

Yonatan Cohen <yonatanc@mellanox.com>
    IB/umad: Fix kernel crash while unloading ib_umad

Kaike Wan <kaike.wan@intel.com>
    IB/rdmavt: Reset all QPs when the device is shut down

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Close window for pq and request coliding

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Acquire lock to release TID entries when user file is closed

Mark Zhang <markz@mellanox.com>
    IB/mlx5: Return failure when rts2rts_qp_counters_set_id is not supported

Colin Ian King <colin.king@canonical.com>
    drivers: ipmi: fix off-by-one bounds check that leads to a out-of-bounds write

Yi Zhang <yi.zhang@redhat.com>
    nvme: fix the parameter order for nvme_get_log in nvme_get_fw_slot_info

Marek Behún <marek.behun@nic.cz>
    bus: moxtet: fix potential stack buffer overflow

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: Make sure the shrinker does not reclaim referenced BOs

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/vgem: Close use-after-free race in vgem_gem_create

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/uv: Fix handling of length extensions

Harald Freudenberger <freude@linux.ibm.com>
    s390/pkey: fix missing length of protected key on return

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd: Add missing L2 misses event spec to AMD Family 17h's event map

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Use correct root level for nested EPT shadow page tables

Robert Richter <rrichter@marvell.com>
    EDAC/mc: Fix use-after-free and memleaks during device removal

Robert Richter <rrichter@marvell.com>
    EDAC/sysfs: Remove csrow objects on errors

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: make sure we do not overflow the max EA buffer size

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Fix DMA scatter-gather list mapping imbalance

Will Deacon <will@kernel.org>
    arm64: ssbs: Fix context-switch when SSBS is present on all CPUs

Paul Thomas <pthomas8589@gmail.com>
    gpio: xilinx: Fix bug where the wrong GPIO register is written to

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

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: s2idle: Prevent spurious SCIs from waking up the system

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Introduce acpi_any_gpe_status_set()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: s2idle: Avoid possible race related to the EC GPE

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: Fix flushing of pending work

Arvind Sankar <nivedita@alum.mit.edu>
    ALSA: usb-audio: Apply sample rate quirk for Audioengine D1

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Fix silent output on MSI-GL73

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add more codec supported Headset Button

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

 Makefile                                         |  4 +-
 arch/arm/mach-npcm/Kconfig                       |  2 +-
 arch/arm64/boot/dts/arm/fvp-base-revc.dts        |  8 +-
 arch/arm64/kernel/process.c                      |  7 ++
 arch/s390/boot/uv.c                              |  3 +-
 arch/s390/include/asm/timex.h                    |  2 +-
 arch/x86/events/amd/core.c                       |  1 +
 arch/x86/events/intel/ds.c                       |  2 +
 arch/x86/kvm/paging_tmpl.h                       |  2 +-
 arch/x86/kvm/vmx/vmx.c                           |  3 +
 arch/x86/kvm/x86.c                               |  8 ++
 drivers/acpi/acpica/achware.h                    |  2 +
 drivers/acpi/acpica/evxfgpe.c                    | 32 ++++++++
 drivers/acpi/acpica/hwgpe.c                      | 71 +++++++++++++++++
 drivers/acpi/ec.c                                | 44 ++++++-----
 drivers/acpi/sleep.c                             | 50 ++++++++----
 drivers/bus/moxtet.c                             |  2 +-
 drivers/char/ipmi/ipmb_dev_int.c                 |  2 +-
 drivers/edac/edac_mc.c                           | 12 +--
 drivers/edac/edac_mc_sysfs.c                     | 18 +----
 drivers/gpio/gpio-xilinx.c                       |  5 +-
 drivers/gpio/gpiolib-of.c                        |  4 -
 drivers/gpio/gpiolib.c                           | 11 +++
 drivers/gpu/drm/panfrost/panfrost_drv.c          |  1 +
 drivers/gpu/drm/panfrost/panfrost_gem.h          |  6 ++
 drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c |  3 +
 drivers/gpu/drm/panfrost/panfrost_job.c          |  7 +-
 drivers/gpu/drm/sun4i/sun4i_drv.c                |  1 -
 drivers/gpu/drm/vgem/vgem_drv.c                  |  9 ++-
 drivers/hwmon/pmbus/ltc2978.c                    |  4 +-
 drivers/infiniband/core/security.c               | 24 +++---
 drivers/infiniband/core/user_mad.c               |  5 +-
 drivers/infiniband/core/uverbs_cmd.c             | 15 ++--
 drivers/infiniband/hw/cxgb4/cm.c                 |  4 +
 drivers/infiniband/hw/cxgb4/qp.c                 |  4 +-
 drivers/infiniband/hw/hfi1/affinity.c            |  2 +
 drivers/infiniband/hw/hfi1/file_ops.c            | 52 ++++++++-----
 drivers/infiniband/hw/hfi1/hfi.h                 |  5 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c        |  5 +-
 drivers/infiniband/hw/hfi1/user_sdma.c           | 17 ++--
 drivers/infiniband/hw/mlx5/qp.c                  |  9 ++-
 drivers/infiniband/sw/rdmavt/qp.c                | 84 ++++++++++++--------
 drivers/infiniband/sw/rxe/rxe_comp.c             |  8 +-
 drivers/input/mouse/synaptics.c                  |  4 +-
 drivers/mmc/core/host.c                          | 11 +--
 drivers/mmc/core/slot-gpio.c                     |  3 +
 drivers/mmc/host/pxamci.c                        |  8 +-
 drivers/mmc/host/sdhci-esdhc-imx.c               |  3 +-
 drivers/nvme/host/core.c                         |  2 +-
 drivers/s390/crypto/pkey_api.c                   |  2 +-
 drivers/spmi/spmi-pmic-arb.c                     |  4 +
 fs/btrfs/disk-io.c                               |  1 +
 fs/btrfs/extent_map.c                            | 11 +++
 fs/btrfs/ref-verify.c                            |  5 ++
 fs/btrfs/super.c                                 |  2 +
 fs/cifs/cifsfs.c                                 |  6 +-
 fs/cifs/smb2ops.c                                | 35 ++++++++-
 fs/ext4/block_validity.c                         |  1 +
 fs/ext4/dir.c                                    | 14 ++--
 fs/ext4/ext4.h                                   |  5 +-
 fs/ext4/inode.c                                  | 12 +++
 fs/ext4/mmp.c                                    | 12 +--
 fs/ext4/namei.c                                  |  7 ++
 fs/ext4/super.c                                  | 55 +++++++------
 fs/jbd2/commit.c                                 | 46 ++++++-----
 fs/jbd2/transaction.c                            | 10 ++-
 fs/nfs/nfs4proc.c                                |  2 +-
 include/acpi/acpixf.h                            |  1 +
 include/linux/gpio/consumer.h                    |  7 ++
 include/linux/suspend.h                          |  2 +-
 kernel/power/suspend.c                           |  9 ++-
 kernel/sched/core.c                              |  2 +-
 net/mac80211/mlme.c                              |  8 +-
 net/sunrpc/xprtrdma/frwr_ops.c                   | 13 ++--
 sound/pci/hda/patch_realtek.c                    |  4 +
 sound/usb/clock.c                                | 99 ++++++++++++++++--------
 sound/usb/clock.h                                |  4 +-
 sound/usb/format.c                               |  3 +-
 sound/usb/mixer.c                                | 12 ++-
 sound/usb/quirks.c                               |  1 +
 tools/perf/util/stat-shadow.c                    |  6 --
 81 files changed, 678 insertions(+), 314 deletions(-)


