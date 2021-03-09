Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D5D33232B
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 11:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhCIKgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 05:36:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:42710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230437AbhCIKgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Mar 2021 05:36:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 465FD65266;
        Tue,  9 Mar 2021 10:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615286181;
        bh=j4QxTXBK8EUro3eBJmjfaqtI9uxk+7h4+oJhf7t+lK8=;
        h=From:To:Cc:Subject:Date:From;
        b=2mbvnVGTeqmvCIu+wu9Q6EsGXyY1m8wINnc+LZIVabMEbWYVaRzU2I8MFLoERjDZx
         9ssh9dopKsyNuQ2VAbtZ6U5HuQ0FD3MUwhymGZtU5zaawhqy5L3hAYUhicH//FobJ3
         q0bIU7CV5ybPK2jIxrwWE9h0YXJahGfLXycEJQdM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.11.5
Date:   Tue,  9 Mar 2021 11:36:15 +0100
Message-Id: <161528617373244@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I'm announcing the release of the 5.11.5 kernel.

All users of the 5.11 kernel series must upgrade.

The updated 5.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.11.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                       |    2 
 arch/ia64/kernel/signal.c                      |    3 -
 drivers/base/power/runtime.c                   |   62 ++++++++++++---------
 drivers/block/rsxx/core.c                      |    8 +-
 drivers/char/tpm/tpm_tis_core.c                |   30 ++++++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c       |    3 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c    |    4 -
 drivers/gpu/drm/amd/amdgpu/nv.c                |    6 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c |   15 ++++-
 drivers/infiniband/core/cm.c                   |    5 +
 drivers/infiniband/hw/mlx5/devx.c              |    4 +
 drivers/infiniband/sw/rxe/Kconfig              |    1 
 drivers/iommu/dma-iommu.c                      |   15 ++---
 drivers/iommu/intel/pasid.h                    |    4 -
 drivers/iommu/tegra-smmu.c                     |   72 ++++++++++++++++++++++++-
 drivers/md/dm-bufio.c                          |    4 +
 drivers/md/dm-verity-fec.c                     |   23 ++++---
 drivers/net/ethernet/realtek/r8169_main.c      |    2 
 fs/btrfs/block-group.c                         |   33 +++++++++++
 fs/btrfs/block-group.h                         |    9 +++
 fs/btrfs/ctree.h                               |    5 +
 fs/btrfs/delayed-inode.c                       |    2 
 fs/btrfs/file.c                                |    5 +
 fs/btrfs/free-space-cache.c                    |   14 ++--
 fs/btrfs/inode.c                               |   40 ++++++++++++-
 fs/btrfs/ioctl.c                               |   19 ++++++
 fs/btrfs/raid56.c                              |   21 +++----
 fs/btrfs/reflink.c                             |   18 ++++++
 fs/btrfs/scrub.c                               |    9 ++-
 fs/btrfs/super.c                               |    4 -
 fs/btrfs/tree-checker.c                        |   16 +----
 fs/btrfs/xattr.c                               |   31 +++++++++-
 fs/btrfs/zoned.c                               |    4 -
 fs/io_uring.c                                  |    3 +
 include/crypto/hash.h                          |    8 +-
 include/linux/crypto.h                         |    9 ++-
 include/sound/intel-nhlt.h                     |    5 +
 kernel/trace/ring_buffer.c                     |   11 +++
 scripts/recordmcount.c                         |    2 
 security/tomoyo/network.c                      |    2 
 sound/hda/intel-nhlt.c                         |   54 +++++++++++++++---
 sound/pci/ctxfi/cthw20k2.c                     |    2 
 sound/pci/hda/patch_realtek.c                  |   13 ++++
 sound/usb/clock.c                              |    8 +-
 sound/usb/mixer.c                              |   11 +++
 sound/usb/mixer_maps.c                         |   10 +++
 sound/usb/pcm.c                                |   12 +++-
 sound/usb/quirks.c                             |    2 
 48 files changed, 506 insertions(+), 139 deletions(-)

Alex Deucher (1):
      drm/amdgpu: Only check for S0ix if AMD_PMC is configured

Andrea Fagiani (1):
      ALSA: usb-audio: use Corsair Virtuoso mapping for Corsair Virtuoso SE

Ard Biesheuvel (1):
      crypto - shash: reduce minimum alignment of shash_desc structure

Asher.Song (1):
      drm/amdgpu:disable VCN for Navi12 SKU

Boris Burkov (1):
      btrfs: fix spurious free_space_tree remount warning

Chen Jun (1):
      ftrace: Have recordmcount use w8 to read relp->r_info in arm64_is_fake_mcount

Chris Chiu (1):
      ALSA: hda/realtek: Enable headset mic of Acer SWIFT with ALC256

Colin Ian King (1):
      ALSA: ctxfi: cthw20k2: fix mask on conf to allow 4 bits

Dan Carpenter (2):
      btrfs: validate qgroup inherit for SNAP_CREATE_V2 ioctl
      rsxx: Return -EFAULT if copy_to_user() fails

Evan Quan (1):
      drm/amd/pm: correct Arcturus mmTHM_BACO_CNTL register address

Filipe Manana (4):
      btrfs: fix race between writes to swap files and scrub
      btrfs: fix race between swap file activation and snapshot creation
      btrfs: fix stale data exposure after cloning a hole with NO_HOLES enabled
      btrfs: fix warning when creating a directory with smack enabled

Greg Kroah-Hartman (1):
      Linux 5.11.5

Heiner Kallweit (1):
      r8169: fix resuming from suspend on RTL8105e if machine runs on battery

Ira Weiny (1):
      btrfs: fix raid6 qstripe kmap

Jarkko Sakkinen (1):
      tpm, tpm_tis: Decorate tpm_get_timeouts() with request_locality()

Jens Axboe (2):
      io_uring: ignore double poll add on the same waitqueue head
      ia64: don't call handle_signal() unless there's actually a signal queued

Josef Bacik (2):
      btrfs: avoid double put of block group when emptying cluster
      btrfs: tree-checker: do not error out if extent ref hash doesn't match

Julian Braha (1):
      RDMA/rxe: Fix missing kconfig dependency on CRYPTO

Kevin Wang (1):
      drm/amdgpu: fix parameter error of RREG32_PCIE() in amdgpu_regs_pcie

Lu Baolu (1):
      iommu: Don't use lazy flush for untrusted device

Lukasz Majczak (1):
      tpm, tpm_tis: Decorate tpm_tis_gen_interrupt() with request_locality()

Mikulas Patocka (1):
      dm bufio: subtract the number of initial sectors in dm_bufio_get_device_size

Milan Broz (1):
      dm verity: fix FEC for RS roots unaligned to block size

Naohiro Aota (1):
      btrfs: zoned: use sector_t for zone sectors

Nicolas MURE (1):
      ALSA: usb-audio: Fix Pioneer DJM devices URB_CONTROL request direction to set samplerate

Nicolin Chen (1):
      iommu/tegra-smmu: Fix mc errors on tegra124-nyan

Nikolay Borisov (3):
      btrfs: fix race between extent freeing/allocation when using bitmaps
      btrfs: free correct amount of space in btrfs_delayed_inode_reserve_metadata
      btrfs: unlock extents in btrfs_zero_range in case of quota reservation errors

Pierre-Louis Bossart (1):
      ALSA: hda: intel-nhlt: verify config type

Rafael J. Wysocki (1):
      PM: runtime: Update device status before letting suppliers suspend

Saeed Mahameed (1):
      RDMA/cm: Fix IRQ restore in ib_send_cm_sidr_rep

Steven Rostedt (VMware) (1):
      ring-buffer: Force before_stamp and write_stamp to be different on discard

Takashi Iwai (3):
      ALSA: usb-audio: Don't abort even if the clock rate differs
      ALSA: usb-audio: Drop bogus dB range in too low level
      ALSA: usb-audio: Allow modifying parameters with succeeding hw_params calls

Tetsuo Handa (1):
      tomoyo: recognize kernel threads correctly

YueHaibing (1):
      IB/mlx5: Add missing error code

Zenghui Yu (1):
      iommu/vt-d: Fix status code for Allocate/Free PASID command

