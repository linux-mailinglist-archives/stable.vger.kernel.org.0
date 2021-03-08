Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D65330E2D
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhCHMft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:35:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232032AbhCHMf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:35:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23CE3651CF;
        Mon,  8 Mar 2021 12:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206929;
        bh=9sX9tFREOjCaTTspYu2FDmQy7Aa0xl5EfhceXgBOSRU=;
        h=From:To:Cc:Subject:Date:From;
        b=DIJjungmtIX+w9Sj73bkVZMeCgIVWaVrGyH/EYkcjXfEYrh6/ZknUWDq5FEfdbkOd
         4WaT27uGr2EmyWDvi2tslFCtR3veu4FUKEa3BXxesKUE9IwOyp0SWOiNrO/+Jk0oJ1
         ZoUz6JNmIGb19UXVmKK7j1vImyK1r3QdNH712SAs=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.11 00/44] 5.11.5-rc1 review
Date:   Mon,  8 Mar 2021 13:34:38 +0100
Message-Id: <20210308122718.586629218@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.11.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.11.5-rc1
X-KernelTest-Deadline: 2021-03-10T12:27+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 5.11.5 release.
There are 44 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.11.5-rc1

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix resuming from suspend on RTL8105e if machine runs on battery

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tomoyo: recognize kernel threads correctly

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: use sector_t for zone sectors

Zenghui Yu <yuzenghui@huawei.com>
    iommu/vt-d: Fix status code for Allocate/Free PASID command

Lu Baolu <baolu.lu@linux.intel.com>
    iommu: Don't use lazy flush for untrusted device

Nicolin Chen <nicoleotsuka@gmail.com>
    iommu/tegra-smmu: Fix mc errors on tegra124-nyan

Dan Carpenter <dan.carpenter@oracle.com>
    rsxx: Return -EFAULT if copy_to_user() fails

Jens Axboe <axboe@kernel.dk>
    ia64: don't call handle_signal() unless there's actually a signal queued

Chen Jun <chenjun102@huawei.com>
    ftrace: Have recordmcount use w8 to read relp->r_info in arm64_is_fake_mcount

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: hda: intel-nhlt: verify config type

YueHaibing <yuehaibing@huawei.com>
    IB/mlx5: Add missing error code

Julian Braha <julianbraha@gmail.com>
    RDMA/rxe: Fix missing kconfig dependency on CRYPTO

Saeed Mahameed <saeedm@nvidia.com>
    RDMA/cm: Fix IRQ restore in ib_send_cm_sidr_rep

Nicolas MURE <nicolas.mure2019@gmail.com>
    ALSA: usb-audio: Fix Pioneer DJM devices URB_CONTROL request direction to set samplerate

Colin Ian King <colin.king@canonical.com>
    ALSA: ctxfi: cthw20k2: fix mask on conf to allow 4 bits

Ard Biesheuvel <ardb@kernel.org>
    crypto - shash: reduce minimum alignment of shash_desc structure

Kevin Wang <kevin1.wang@amd.com>
    drm/amdgpu: fix parameter error of RREG32_PCIE() in amdgpu_regs_pcie

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: Only check for S0ix if AMD_PMC is configured

Asher.Song <Asher.Song@amd.com>
    drm/amdgpu:disable VCN for Navi12 SKU

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: correct Arcturus mmTHM_BACO_CNTL register address

Milan Broz <gmazyland@gmail.com>
    dm verity: fix FEC for RS roots unaligned to block size

Mikulas Patocka <mpatocka@redhat.com>
    dm bufio: subtract the number of initial sectors in dm_bufio_get_device_size

Jens Axboe <axboe@kernel.dk>
    io_uring: ignore double poll add on the same waitqueue head

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ring-buffer: Force before_stamp and write_stamp to be different on discard

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Update device status before letting suppliers suspend

Filipe Manana <fdmanana@suse.com>
    btrfs: fix warning when creating a directory with smack enabled

Nikolay Borisov <nborisov@suse.com>
    btrfs: unlock extents in btrfs_zero_range in case of quota reservation errors

Boris Burkov <boris@bur.io>
    btrfs: fix spurious free_space_tree remount warning

Nikolay Borisov <nborisov@suse.com>
    btrfs: free correct amount of space in btrfs_delayed_inode_reserve_metadata

Dan Carpenter <dancarpenter@oracle.com>
    btrfs: validate qgroup inherit for SNAP_CREATE_V2 ioctl

Nikolay Borisov <nborisov@suse.com>
    btrfs: fix race between extent freeing/allocation when using bitmaps

Josef Bacik <josef@toxicpanda.com>
    btrfs: tree-checker: do not error out if extent ref hash doesn't match

Filipe Manana <fdmanana@suse.com>
    btrfs: fix stale data exposure after cloning a hole with NO_HOLES enabled

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between swap file activation and snapshot creation

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between writes to swap files and scrub

Ira Weiny <ira.weiny@intel.com>
    btrfs: fix raid6 qstripe kmap

Josef Bacik <josef@toxicpanda.com>
    btrfs: avoid double put of block group when emptying cluster

Jarkko Sakkinen <jarkko@kernel.org>
    tpm, tpm_tis: Decorate tpm_get_timeouts() with request_locality()

Lukasz Majczak <lma@semihalf.com>
    tpm, tpm_tis: Decorate tpm_tis_gen_interrupt() with request_locality()

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Allow modifying parameters with succeeding hw_params calls

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Drop bogus dB range in too low level

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Don't abort even if the clock rate differs

Andrea Fagiani <andfagiani@gmail.com>
    ALSA: usb-audio: use Corsair Virtuoso mapping for Corsair Virtuoso SE

Chris Chiu <chris.chiu@canonical.com>
    ALSA: hda/realtek: Enable headset mic of Acer SWIFT with ALC256


-------------

Diffstat:

 Makefile                                       |  4 +-
 arch/ia64/kernel/signal.c                      |  3 +-
 drivers/base/power/runtime.c                   | 62 +++++++++++++---------
 drivers/block/rsxx/core.c                      |  8 +--
 drivers/char/tpm/tpm_tis_core.c                | 30 +++++++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c       |  3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c    |  4 +-
 drivers/gpu/drm/amd/amdgpu/nv.c                |  6 ++-
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c | 15 ++++--
 drivers/infiniband/core/cm.c                   |  5 +-
 drivers/infiniband/hw/mlx5/devx.c              |  4 +-
 drivers/infiniband/sw/rxe/Kconfig              |  1 +
 drivers/iommu/dma-iommu.c                      | 15 +++---
 drivers/iommu/intel/pasid.h                    |  4 +-
 drivers/iommu/tegra-smmu.c                     | 72 +++++++++++++++++++++++++-
 drivers/md/dm-bufio.c                          |  4 ++
 drivers/md/dm-verity-fec.c                     | 23 ++++----
 drivers/net/ethernet/realtek/r8169_main.c      |  2 +
 fs/btrfs/block-group.c                         | 33 +++++++++++-
 fs/btrfs/block-group.h                         |  9 ++++
 fs/btrfs/ctree.h                               |  5 ++
 fs/btrfs/delayed-inode.c                       |  2 +-
 fs/btrfs/file.c                                |  5 +-
 fs/btrfs/free-space-cache.c                    | 14 ++---
 fs/btrfs/inode.c                               | 40 ++++++++++++--
 fs/btrfs/ioctl.c                               | 19 ++++++-
 fs/btrfs/raid56.c                              | 21 ++++----
 fs/btrfs/reflink.c                             | 18 +++++++
 fs/btrfs/scrub.c                               |  9 +++-
 fs/btrfs/super.c                               |  4 +-
 fs/btrfs/tree-checker.c                        | 16 ++----
 fs/btrfs/xattr.c                               | 31 +++++++++--
 fs/btrfs/zoned.c                               |  4 +-
 fs/io_uring.c                                  |  3 ++
 include/crypto/hash.h                          |  8 +--
 include/linux/crypto.h                         |  9 ++--
 include/sound/intel-nhlt.h                     |  5 ++
 kernel/trace/ring_buffer.c                     | 11 ++++
 scripts/recordmcount.c                         |  2 +-
 security/tomoyo/network.c                      |  2 +-
 sound/hda/intel-nhlt.c                         | 54 +++++++++++++++----
 sound/pci/ctxfi/cthw20k2.c                     |  2 +-
 sound/pci/hda/patch_realtek.c                  | 13 +++++
 sound/usb/clock.c                              |  8 +--
 sound/usb/mixer.c                              | 11 ++++
 sound/usb/mixer_maps.c                         | 10 ++++
 sound/usb/pcm.c                                | 12 +++--
 sound/usb/quirks.c                             |  2 +-
 48 files changed, 507 insertions(+), 140 deletions(-)


