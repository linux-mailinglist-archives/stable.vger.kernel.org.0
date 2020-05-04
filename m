Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980261C440D
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731572AbgEDSDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:03:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:32846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731567AbgEDSDq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:03:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B0102073B;
        Mon,  4 May 2020 18:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615425;
        bh=YufbUZ9+K34XwftgAXsvCURg8v/qsmAD2SnmGxCtLIc=;
        h=From:To:Cc:Subject:Date:From;
        b=iLbxjYiIR/eYx4vKKlZ4O2ux7wTDDhjq7xIrYdjUndJ/UBhPdA18POR6mKhm+1oDG
         b4jxdhZPG7m+A2RyhpaQ7c6H3BpAY6Nie7qSUBuQpXdBLyR8drPXhpvRKryhZ7n1Nk
         +jLPIQxHfsVwHIQ8HPe0c4SdGb6JQCL+A296ncN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/57] 5.4.39-rc1 review
Date:   Mon,  4 May 2020 19:57:04 +0200
Message-Id: <20200504165456.783676004@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.39-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.39-rc1
X-KernelTest-Deadline: 2020-05-06T16:55+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.39 release.
There are 57 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 06 May 2020 16:52:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.39-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.39-rc1

Paul Moore <paul@paul-moore.com>
    selinux: properly handle multiple messages in selinux_netlink_send()

Vincenzo Frascino <vincenzo.frascino@arm.com>
    arm64: vdso: Add -fasynchronous-unwind-tables to cflags

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dmatest: Fix process hang when reading 'wait' parameter

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dmatest: Fix iteration non-stop logic

Andreas Gruenbacher <agruenba@redhat.com>
    nfs: Fix potential posix_acl refcnt leak in nfs3_set_acl

Niklas Cassel <niklas.cassel@wdc.com>
    nvme: prevent double free in nvme_alloc_ns() error handling

David Howells <dhowells@redhat.com>
    Fix use after free in get_tree_bdev()

Arnd Bergmann <arnd@arndb.de>
    ALSA: opti9xx: shut up gcc-10 range warning

ryan_chen <ryan_chen@aspeedtech.com>
    i2c: aspeed: Avoid i2c interrupt status clear race condition.

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Fix legacy interrupt remapping for x2APIC-enabled system

David Disseldorp <ddiss@suse.de>
    scsi: target/iblock: fix WRITE SAME zeroing

Tang Bin <tangbin@cmss.chinamobile.com>
    iommu/qcom: Fix local_base status check

Sean Christopherson <sean.j.christopherson@intel.com>
    vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()

Yan Zhao <yan.y.zhao@intel.com>
    vfio: avoid possible overflow in vfio_iommu_type1_pin_pages

Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
    i2c: iproc: generate stop event for slave writes

Dan Carpenter <dan.carpenter@oracle.com>
    RDMA/cm: Fix an error check in cm_alloc_id_priv()

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/cm: Fix ordering of xa_alloc_cyclic() in ib_create_cm_id()

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Fix race between destroy and release FD object

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Prevent mixed use of FDs between shared ufiles

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/siw: Fix potential siw_mem refcnt leak in siw_fastreg_mr()

Alaa Hleihel <alaa@mellanox.com>
    RDMA/mlx4: Initialize ib_spec on the stack

Aharon Landau <aharonl@mellanox.com>
    RDMA/mlx5: Set GRH fields in query QP on RoCE

Martin Wilck <mwilck@suse.com>
    scsi: qla2xxx: check UNLOADING before posting async work

Martin Wilck <mwilck@suse.com>
    scsi: qla2xxx: set UNLOADING before waiting for session deletion

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: dts: imx6qdl-sr-som-ti: indicate powering off wifi is safe

Gabriel Krisman Bertazi <krisman@collabora.com>
    dm multipath: use updated MPATHF_QUEUE_IO on mapping for bio-based mpath

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: fix data corruption when reloading the target

Sunwook Eom <speed.eom@samsung.com>
    dm verity fec: fix hash block number in verity_fec_decode

Dexuan Cui <decui@microsoft.com>
    PM: hibernate: Freeze kernel threads in software_resume()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    PM: ACPI: Output correct message on target power state

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    IB/rdmavt: Always return ERR_PTR from rvt_create_mmap_info()

Al Viro <viro@zeniv.linux.org.uk>
    dlmfs_file_write(): fix the bogosity in handling non-zero *ppos

Dexuan Cui <decui@microsoft.com>
    Drivers: hv: vmbus: Fix Suspend-to-Idle for Generation-2 VM

Dan Carpenter <dan.carpenter@oracle.com>
    i2c: amd-mp2-pci: Fix Oops in amd_mp2_pci_init() error handling

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Place the plugin buffer overflow checks correctly

Vasily Khoruzhick <anarsoul@gmail.com>
    ALSA: line6: Fix POD HD500 audio playback

Wu Bo <wubo40@huawei.com>
    ALSA: hda/hdmi: fix without unlocked before return

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Correct a typo of NuPrime DAC-10 USB ID

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - Two front mics on a Lenovo ThinkCenter

Iuliana Prodan <iuliana.prodan@nxp.com>
    crypto: caam - fix the address of the last entry of S/G

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    mmc: meson-mx-sdio: remove the broken ->card_busy() op

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    mmc: meson-mx-sdio: Set MMC_CAP_WAIT_WHILE_BUSY

Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
    mmc: sdhci-msm: Enable host capabilities pertains to R1b response

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci-pci: Fix eMMC driver strength for BYT-based controllers

Marek Behún <marek.behun@nic.cz>
    mmc: sdhci-xenon: fix annoying 1.8V regulator warning

Douglas Anderson <dianders@chromium.org>
    mmc: cqhci: Avoid false "cqhci: CQE stuck on" by not open-coding timeout loop

Qu Wenruo <wqu@suse.com>
    btrfs: transaction: Avoid deadlock due to bad initialization timing of fs_info::journal_info

Filipe Manana <fdmanana@suse.com>
    btrfs: fix partial loss of prealloc extent past i_size after fsync

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    btrfs: fix block group leak when removing fails

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    btrfs: fix transaction leak in btrfs_recover_relocation

Olga Kornievskaia <olga.kornievskaia@gmail.com>
    NFSv4.1: fix handling of backchannel binding in BIND_CONN_TO_SESSION

Vasily Averin <vvs@virtuozzo.com>
    drm/qxl: qxl_release use after free

Vasily Averin <vvs@virtuozzo.com>
    drm/qxl: qxl_release leak in qxl_hw_surface_alloc()

Vasily Averin <vvs@virtuozzo.com>
    drm/qxl: qxl_release leak in qxl_draw_dirty_fb()

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Fix green screen issue after suspend

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/edid: Fix off-by-one in DispID DTD pixel clock

Daniel Vetter <daniel.vetter@intel.com>
    dma-buf: Fix SET_NAME ioctl uapi


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/arm/boot/dts/imx6qdl-sr-som-ti.dtsi          |  1 +
 arch/arm64/kernel/vdso/Makefile                   |  2 +-
 drivers/acpi/device_pm.c                          |  4 +-
 drivers/crypto/caam/caamalg.c                     |  2 +-
 drivers/dma-buf/dma-buf.c                         |  3 +-
 drivers/dma/dmatest.c                             |  6 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 38 +++++++++---
 drivers/gpu/drm/drm_edid.c                        |  2 +-
 drivers/gpu/drm/qxl/qxl_cmd.c                     | 10 ++--
 drivers/gpu/drm/qxl/qxl_display.c                 |  6 +-
 drivers/gpu/drm/qxl/qxl_draw.c                    |  7 ++-
 drivers/gpu/drm/qxl/qxl_ioctl.c                   |  5 +-
 drivers/hv/vmbus_drv.c                            | 43 +++++++++++---
 drivers/i2c/busses/i2c-amd-mp2-pci.c              |  2 +-
 drivers/i2c/busses/i2c-aspeed.c                   |  5 +-
 drivers/i2c/busses/i2c-bcm-iproc.c                |  3 +
 drivers/infiniband/core/cm.c                      | 27 ++++-----
 drivers/infiniband/core/rdma_core.c               |  4 +-
 drivers/infiniband/hw/mlx4/main.c                 |  3 +-
 drivers/infiniband/hw/mlx5/qp.c                   |  4 +-
 drivers/infiniband/sw/rdmavt/cq.c                 |  4 +-
 drivers/infiniband/sw/rdmavt/mmap.c               |  4 +-
 drivers/infiniband/sw/rdmavt/qp.c                 |  4 +-
 drivers/infiniband/sw/rdmavt/srq.c                |  4 +-
 drivers/infiniband/sw/siw/siw_qp_tx.c             | 15 +++--
 drivers/iommu/amd_iommu_init.c                    |  2 +-
 drivers/iommu/qcom_iommu.c                        |  5 +-
 drivers/md/dm-mpath.c                             |  6 +-
 drivers/md/dm-verity-fec.c                        |  2 +-
 drivers/md/dm-writecache.c                        | 52 ++++++++++++-----
 drivers/mmc/host/cqhci.c                          | 21 ++++---
 drivers/mmc/host/meson-mx-sdio.c                  | 11 +---
 drivers/mmc/host/sdhci-msm.c                      |  2 +
 drivers/mmc/host/sdhci-pci-core.c                 |  3 +
 drivers/mmc/host/sdhci-xenon.c                    | 10 ++++
 drivers/nvme/host/core.c                          |  2 +
 drivers/scsi/qla2xxx/qla_os.c                     | 35 ++++++------
 drivers/target/target_core_iblock.c               |  2 +-
 drivers/vfio/vfio_iommu_type1.c                   |  6 +-
 fs/btrfs/block-group.c                            | 16 ++++--
 fs/btrfs/relocation.c                             |  1 +
 fs/btrfs/transaction.c                            | 13 ++++-
 fs/btrfs/tree-log.c                               | 43 +++++++++++++-
 fs/nfs/nfs3acl.c                                  | 22 ++++---
 fs/nfs/nfs4proc.c                                 |  8 +++
 fs/ocfs2/dlmfs/dlmfs.c                            | 27 ++++-----
 fs/super.c                                        |  2 +-
 include/linux/nfs_xdr.h                           |  2 +
 include/linux/sunrpc/clnt.h                       |  5 ++
 include/uapi/linux/dma-buf.h                      |  6 ++
 kernel/power/hibernate.c                          |  7 +++
 security/selinux/hooks.c                          | 70 +++++++++++++++--------
 sound/core/oss/pcm_plugin.c                       | 20 ++++---
 sound/isa/opti9xx/miro.c                          |  9 ++-
 sound/isa/opti9xx/opti92x-ad1848.c                |  9 ++-
 sound/pci/hda/patch_hdmi.c                        |  4 +-
 sound/pci/hda/patch_realtek.c                     |  1 +
 sound/usb/line6/podhd.c                           | 22 ++-----
 sound/usb/quirks.c                                |  2 +-
 60 files changed, 427 insertions(+), 233 deletions(-)


