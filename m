Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1E11C452E
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730738AbgEDSNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:13:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730681AbgEDSBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:01:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C209206B8;
        Mon,  4 May 2020 18:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615306;
        bh=up1WAryaEnywBl7PrgwmcTIVYiFt4LShBdH/1kMNoNA=;
        h=From:To:Cc:Subject:Date:From;
        b=vS105xbM02ik/Af/3dbElc5D7wF1UCJlGQSlWBmZ2qZAquy2kEjQxdhO/+Froqpxe
         dTgSMZX3HxiEOln7bT/ZO0gWIDoT6CUrg91Ud7zhHT/xPrpqUtUV5z2M0TVVMRV0sy
         hBr4diZpOAR1dXycNYdbtR84TY8qpusmqBUbw4Xo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/37] 4.19.121-rc1 review
Date:   Mon,  4 May 2020 19:57:13 +0200
Message-Id: <20200504165448.264746645@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.121-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.121-rc1
X-KernelTest-Deadline: 2020-05-06T16:54+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.121 release.
There are 37 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 06 May 2020 16:52:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.121-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.121-rc1

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

Paul Moore <paul@paul-moore.com>
    selinux: properly handle multiple messages in selinux_netlink_send()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dmatest: Fix iteration non-stop logic

Andreas Gruenbacher <agruenba@redhat.com>
    nfs: Fix potential posix_acl refcnt leak in nfs3_set_acl

Arnd Bergmann <arnd@arndb.de>
    ALSA: opti9xx: shut up gcc-10 range warning

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

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Fix race between destroy and release FD object

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Prevent mixed use of FDs between shared ufiles

Alaa Hleihel <alaa@mellanox.com>
    RDMA/mlx4: Initialize ib_spec on the stack

Aharon Landau <aharonl@mellanox.com>
    RDMA/mlx5: Set GRH fields in query QP on RoCE

Martin Wilck <mwilck@suse.com>
    scsi: qla2xxx: check UNLOADING before posting async work

Martin Wilck <mwilck@suse.com>
    scsi: qla2xxx: set UNLOADING before waiting for session deletion

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

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Place the plugin buffer overflow checks correctly

Wu Bo <wubo40@huawei.com>
    ALSA: hda/hdmi: fix without unlocked before return

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Correct a typo of NuPrime DAC-10 USB ID

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - Two front mics on a Lenovo ThinkCenter

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    btrfs: fix block group leak when removing fails

Vasily Averin <vvs@virtuozzo.com>
    drm/qxl: qxl_release use after free

Vasily Averin <vvs@virtuozzo.com>
    drm/qxl: qxl_release leak in qxl_hw_surface_alloc()

Vasily Averin <vvs@virtuozzo.com>
    drm/qxl: qxl_release leak in qxl_draw_dirty_fb()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/edid: Fix off-by-one in DispID DTD pixel clock


-------------

Diffstat:

 Makefile                            |  4 +--
 drivers/acpi/device_pm.c            |  4 +--
 drivers/dma/dmatest.c               |  4 +--
 drivers/gpu/drm/drm_edid.c          |  2 +-
 drivers/gpu/drm/qxl/qxl_cmd.c       | 10 +++---
 drivers/gpu/drm/qxl/qxl_display.c   |  6 ++--
 drivers/gpu/drm/qxl/qxl_draw.c      | 13 +++----
 drivers/gpu/drm/qxl/qxl_ioctl.c     |  5 +--
 drivers/infiniband/core/rdma_core.c |  4 +--
 drivers/infiniband/hw/mlx4/main.c   |  3 +-
 drivers/infiniband/hw/mlx5/qp.c     |  4 ++-
 drivers/iommu/amd_iommu_init.c      |  2 +-
 drivers/iommu/qcom_iommu.c          |  5 ++-
 drivers/md/dm-mpath.c               |  6 ++--
 drivers/md/dm-verity-fec.c          |  2 +-
 drivers/md/dm-writecache.c          | 52 +++++++++++++++++++--------
 drivers/mmc/host/cqhci.c            | 21 ++++++-----
 drivers/mmc/host/meson-mx-sdio.c    | 11 +-----
 drivers/mmc/host/sdhci-msm.c        |  2 ++
 drivers/mmc/host/sdhci-pci-core.c   |  3 ++
 drivers/mmc/host/sdhci-xenon.c      | 10 ++++++
 drivers/scsi/qla2xxx/qla_os.c       | 35 +++++++++----------
 drivers/target/target_core_iblock.c |  2 +-
 drivers/vfio/vfio_iommu_type1.c     |  6 ++--
 fs/btrfs/extent-tree.c              | 16 +++++----
 fs/btrfs/transaction.c              | 13 +++++--
 fs/btrfs/tree-log.c                 | 43 +++++++++++++++++++++--
 fs/nfs/nfs3acl.c                    | 22 ++++++++----
 kernel/power/hibernate.c            |  7 ++++
 security/selinux/hooks.c            | 70 ++++++++++++++++++++++++-------------
 sound/core/oss/pcm_plugin.c         | 20 ++++++-----
 sound/isa/opti9xx/miro.c            |  9 +++--
 sound/isa/opti9xx/opti92x-ad1848.c  |  9 +++--
 sound/pci/hda/patch_hdmi.c          |  4 ++-
 sound/pci/hda/patch_realtek.c       |  1 +
 sound/usb/quirks.c                  |  2 +-
 36 files changed, 281 insertions(+), 151 deletions(-)


