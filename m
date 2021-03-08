Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7317F330DEC
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhCHMeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:34:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:42700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhCHMdz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:33:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0650F651CF;
        Mon,  8 Mar 2021 12:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206834;
        bh=v2FBf0X09CiW7usYJwSOJlAuObJPIpNcLlyzap3ZZN0=;
        h=From:To:Cc:Subject:Date:From;
        b=GomU0XBgezOGQDxO5kOC3pdPh7w3rZNCLp3QnIRjv9pxaQgJ6+XVLVA84WOgUi0d6
         OKzfIPaFvnSa6HQnydowi2ohzIDqPYhEDgJrKU0jqiJ4cLlb9oHPbkfwS+kVZuoEqb
         tRa75wE7b6JArIIrieY9lnahNge8E6+OioHecHk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/42] 5.10.22-rc1 review
Date:   Mon,  8 Mar 2021 13:30:26 +0100
Message-Id: <20210308122718.120213856@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.10.22-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.22-rc1
X-KernelTest-Deadline: 2021-03-10T12:27+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.22 release.
There are 42 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.22-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.22-rc1

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix resuming from suspend on RTL8105e if machine runs on battery

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tomoyo: recognize kernel threads correctly

Catalin Marinas <catalin.marinas@arm.com>
    of: unittest: Fix build on architectures without CONFIG_OF_ADDRESS

Neil Armstrong <narmstrong@baylibre.com>
    Revert "arm64: dts: amlogic: add missing ethernet reset ID"

Zenghui Yu <yuzenghui@huawei.com>
    iommu/vt-d: Fix status code for Allocate/Free PASID command

Dan Carpenter <dan.carpenter@oracle.com>
    rsxx: Return -EFAULT if copy_to_user() fails

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

Colin Ian King <colin.king@canonical.com>
    ALSA: ctxfi: cthw20k2: fix mask on conf to allow 4 bits

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    mm: Remove examples from enum zone_type comment

Ard Biesheuvel <ardb@kernel.org>
    arm64: mm: Set ZONE_DMA size based on early IORT scan

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    arm64: mm: Set ZONE_DMA size based on devicetree's dma-ranges

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    of: unittest: Add test for of_dma_get_max_cpu_address()

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    of/address: Introduce of_dma_get_max_cpu_address()

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    arm64: mm: Move zone_dma_bits initialization into zone_sizes_init()

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    arm64: mm: Move reserve_crashkernel() into mem_init()

Ard Biesheuvel <ardb@kernel.org>
    crypto - shash: reduce minimum alignment of shash_desc structure

Kevin Wang <kevin1.wang@amd.com>
    drm/amdgpu: fix parameter error of RREG32_PCIE() in amdgpu_regs_pcie

Asher.Song <Asher.Song@amd.com>
    drm/amdgpu:disable VCN for Navi12 SKU

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

Nikolay Borisov <nborisov@suse.com>
    btrfs: free correct amount of space in btrfs_delayed_inode_reserve_metadata

Dan Carpenter <dancarpenter@oracle.com>
    btrfs: validate qgroup inherit for SNAP_CREATE_V2 ioctl

Nikolay Borisov <nborisov@suse.com>
    btrfs: fix race between extent freeing/allocation when using bitmaps

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
    ALSA: usb-audio: Drop bogus dB range in too low level

Andrea Fagiani <andfagiani@gmail.com>
    ALSA: usb-audio: use Corsair Virtuoso mapping for Corsair Virtuoso SE

Chris Chiu <chris.chiu@canonical.com>
    ALSA: hda/realtek: Enable headset mic of Acer SWIFT with ALC256


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi        |  2 -
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi |  2 -
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi         |  3 --
 arch/arm64/mm/init.c                              | 22 ++++----
 drivers/acpi/arm64/iort.c                         | 55 ++++++++++++++++++++
 drivers/base/power/runtime.c                      | 62 ++++++++++++++---------
 drivers/block/rsxx/core.c                         |  8 +--
 drivers/char/tpm/tpm_tis_core.c                   | 30 +++++++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c       |  4 +-
 drivers/gpu/drm/amd/amdgpu/nv.c                   |  6 ++-
 drivers/infiniband/core/cm.c                      |  5 +-
 drivers/infiniband/hw/mlx5/devx.c                 |  4 +-
 drivers/infiniband/sw/rxe/Kconfig                 |  1 +
 drivers/iommu/intel/pasid.h                       |  4 +-
 drivers/md/dm-bufio.c                             |  4 ++
 drivers/md/dm-verity-fec.c                        | 23 +++++----
 drivers/net/ethernet/realtek/r8169_main.c         |  2 +
 drivers/of/address.c                              | 42 +++++++++++++++
 drivers/of/unittest.c                             | 21 ++++++++
 fs/btrfs/block-group.c                            | 33 +++++++++++-
 fs/btrfs/block-group.h                            |  9 ++++
 fs/btrfs/ctree.h                                  |  5 ++
 fs/btrfs/delayed-inode.c                          |  2 +-
 fs/btrfs/file.c                                   |  5 +-
 fs/btrfs/free-space-cache.c                       | 14 ++---
 fs/btrfs/inode.c                                  | 40 +++++++++++++--
 fs/btrfs/ioctl.c                                  | 19 ++++++-
 fs/btrfs/raid56.c                                 | 21 ++++----
 fs/btrfs/reflink.c                                | 18 +++++++
 fs/btrfs/scrub.c                                  |  9 +++-
 fs/btrfs/xattr.c                                  | 31 ++++++++++--
 fs/io_uring.c                                     |  3 ++
 include/crypto/hash.h                             |  8 +--
 include/linux/acpi_iort.h                         |  4 ++
 include/linux/crypto.h                            |  9 ++--
 include/linux/mmzone.h                            | 20 --------
 include/linux/of.h                                |  7 +++
 include/sound/intel-nhlt.h                        |  5 ++
 kernel/trace/ring_buffer.c                        | 11 ++++
 scripts/recordmcount.c                            |  2 +-
 security/tomoyo/network.c                         |  2 +-
 sound/hda/intel-nhlt.c                            | 54 ++++++++++++++++----
 sound/pci/ctxfi/cthw20k2.c                        |  2 +-
 sound/pci/hda/patch_realtek.c                     | 13 +++++
 sound/usb/mixer.c                                 | 11 ++++
 sound/usb/mixer_maps.c                            | 10 ++++
 47 files changed, 532 insertions(+), 139 deletions(-)


