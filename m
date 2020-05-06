Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C961C70B0
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 14:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgEFMrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 08:47:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728330AbgEFMrT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 08:47:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80D6F206DD;
        Wed,  6 May 2020 12:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588769239;
        bh=yR71UCvW1ssLAQZDTc46h9TGX7aVk58Ff2Wzq675EBE=;
        h=Date:From:To:Cc:Subject:From;
        b=EWIN31IDGaPUyyC5tGQO9tisJm2HyW2I6YTmUGRmhIx6y3iVUSXutpUixdbzNm2V3
         FcG12NIMww+vp46poq5DQYqB44S9sP4yAOtik5C3oRfAOb7MKBFZiUb4l1/+Na0DDO
         YY0lE6ZgM8nasqlTOLIwliNUwZwWxd15iaV0fp28=
Date:   Wed, 6 May 2020 14:47:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.6.11
Message-ID: <20200506124716.GA3146555@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.6.11 kernel.

All users of the 5.6 kernel series must upgrade.

The updated 5.6.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.6.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                          |    2=20
 arch/arm/boot/dts/imx6qdl-sr-som-ti.dtsi          |    1=20
 arch/arm64/kernel/vdso/Makefile                   |    2=20
 arch/x86/hyperv/hv_init.c                         |   12 +++
 block/partition-generic.c                         |    2=20
 drivers/acpi/device_pm.c                          |    4 -
 drivers/crypto/caam/caamalg.c                     |    2=20
 drivers/dma-buf/dma-buf.c                         |    3=20
 drivers/dma/Kconfig                               |    3=20
 drivers/dma/dmaengine.c                           |   60 ++++++++----------
 drivers/dma/dmatest.c                             |    6 -
 drivers/dma/ti/k3-psil.c                          |    1=20
 drivers/gpu/drm/amd/amdgpu/navi10_sdma_pkt_open.h |   16 +++++
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c            |   14 ++++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   38 +++++++++--
 drivers/gpu/drm/drm_edid.c                        |    2=20
 drivers/gpu/drm/i915/gem/i915_gem_tiling.c        |   20 +++++-
 drivers/gpu/drm/i915/gem/selftests/huge_pages.c   |   12 ++-
 drivers/gpu/drm/i915/gt/intel_timeline.c          |    2=20
 drivers/gpu/drm/i915/i915_irq.c                   |    6 -
 drivers/gpu/drm/i915/i915_vma.c                   |   10 +--
 drivers/gpu/drm/qxl/qxl_cmd.c                     |   10 +--
 drivers/gpu/drm/qxl/qxl_display.c                 |    6 -
 drivers/gpu/drm/qxl/qxl_draw.c                    |    7 +-
 drivers/gpu/drm/qxl/qxl_ioctl.c                   |    5 -
 drivers/gpu/drm/scheduler/sched_main.c            |    2=20
 drivers/hv/vmbus_drv.c                            |   43 ++++++++++---
 drivers/i2c/busses/i2c-amd-mp2-pci.c              |    2=20
 drivers/i2c/busses/i2c-aspeed.c                   |    5 +
 drivers/i2c/busses/i2c-bcm-iproc.c                |    3=20
 drivers/infiniband/core/cm.c                      |   27 +++-----
 drivers/infiniband/core/rdma_core.c               |    9 +-
 drivers/infiniband/core/uverbs_main.c             |    4 +
 drivers/infiniband/hw/mlx4/main.c                 |    3=20
 drivers/infiniband/hw/mlx5/qp.c                   |    4 -
 drivers/infiniband/sw/rdmavt/cq.c                 |    4 -
 drivers/infiniband/sw/rdmavt/mmap.c               |    4 -
 drivers/infiniband/sw/rdmavt/qp.c                 |    4 -
 drivers/infiniband/sw/rdmavt/srq.c                |    4 -
 drivers/infiniband/sw/siw/siw_qp_tx.c             |   15 +++-
 drivers/iommu/amd_iommu_init.c                    |    2=20
 drivers/iommu/intel-iommu.c                       |    4 -
 drivers/iommu/iommu.c                             |    2=20
 drivers/iommu/qcom_iommu.c                        |    5 +
 drivers/md/dm-mpath.c                             |    6 +
 drivers/md/dm-verity-fec.c                        |    2=20
 drivers/md/dm-writecache.c                        |   52 +++++++++++-----
 drivers/mmc/host/cqhci.c                          |   21 +++---
 drivers/mmc/host/meson-mx-sdio.c                  |   11 ---
 drivers/mmc/host/sdhci-msm.c                      |    2=20
 drivers/mmc/host/sdhci-pci-core.c                 |    3=20
 drivers/mmc/host/sdhci-xenon.c                    |   10 +++
 drivers/nvme/host/core.c                          |    2=20
 drivers/scsi/qla2xxx/qla_os.c                     |   35 +++++------
 drivers/target/target_core_iblock.c               |    2=20
 drivers/vfio/vfio_iommu_type1.c                   |    6 -
 fs/btrfs/block-group.c                            |   16 +++--
 fs/btrfs/relocation.c                             |    1=20
 fs/btrfs/transaction.c                            |   13 +++-
 fs/btrfs/tree-log.c                               |   43 ++++++++++++-
 fs/io_uring.c                                     |   12 +++
 fs/nfs/nfs3acl.c                                  |   22 ++++--
 fs/nfs/nfs4proc.c                                 |    8 ++
 fs/ocfs2/dlmfs/dlmfs.c                            |   27 +++-----
 fs/super.c                                        |    2=20
 include/linux/dmaengine.h                         |    4 -
 include/linux/nfs_xdr.h                           |    2=20
 include/linux/sunrpc/clnt.h                       |    5 +
 include/uapi/linux/dma-buf.h                      |    6 +
 kernel/power/hibernate.c                          |    7 ++
 security/selinux/hooks.c                          |   70 ++++++++++++++---=
-----
 sound/core/oss/pcm_plugin.c                       |   20 +++---
 sound/isa/opti9xx/miro.c                          |    9 +-
 sound/isa/opti9xx/opti92x-ad1848.c                |    9 +-
 sound/pci/hda/patch_hdmi.c                        |    4 -
 sound/pci/hda/patch_realtek.c                     |    1=20
 sound/usb/line6/podhd.c                           |   22 +-----
 sound/usb/quirks.c                                |    2=20
 78 files changed, 553 insertions(+), 296 deletions(-)

Adrian Hunter (1):
      mmc: sdhci-pci: Fix eMMC driver strength for BYT-based controllers

Aharon Landau (1):
      RDMA/mlx5: Set GRH fields in query QP on RoCE

Al Viro (1):
      dlmfs_file_write(): fix the bogosity in handling non-zero *ppos

Alaa Hleihel (1):
      RDMA/mlx4: Initialize ib_spec on the stack

Andreas Gruenbacher (1):
      nfs: Fix potential posix_acl refcnt leak in nfs3_set_acl

Andy Shevchenko (2):
      dmaengine: dmatest: Fix iteration non-stop logic
      dmaengine: dmatest: Fix process hang when reading 'wait' parameter

Arnd Bergmann (1):
      ALSA: opti9xx: shut up gcc-10 range warning

Chris Wilson (2):
      drm/i915/gem: Hold obj->vma.lock over for_each_ggtt_vma()
      drm/i915/gt: Check cacheline is valid before acquiring

Christian K=C3=B6nig (1):
      drm/scheduler: fix drm_sched_get_cleanup_job

Christoph Hellwig (1):
      block: remove the bd_openers checks in blk_drop_partitions

Dan Carpenter (2):
      i2c: amd-mp2-pci: Fix Oops in amd_mp2_pci_init() error handling
      RDMA/cm: Fix an error check in cm_alloc_id_priv()

Daniel Vetter (1):
      dma-buf: Fix SET_NAME ioctl uapi

Dave Jiang (1):
      dmaengine: fix channel index enumeration

David Disseldorp (1):
      scsi: target/iblock: fix WRITE SAME zeroing

David Howells (1):
      Fix use after free in get_tree_bdev()

Dexuan Cui (3):
      x86/hyperv: Suspend/resume the VP assist page for hibernation
      Drivers: hv: vmbus: Fix Suspend-to-Idle for Generation-2 VM
      PM: hibernate: Freeze kernel threads in software_resume()

Douglas Anderson (1):
      mmc: cqhci: Avoid false "cqhci: CQE stuck on" by not open-coding time=
out loop

Filipe Manana (1):
      btrfs: fix partial loss of prealloc extent past i_size after fsync

Gabriel Krisman Bertazi (1):
      dm multipath: use updated MPATHF_QUEUE_IO on mapping for bio-based mp=
ath

Greg Kroah-Hartman (2):
      iommu: Properly export iommu_group_get_for_dev()
      Linux 5.6.11

Grygorii Strashko (1):
      dmaengine: ti: k3-psil: fix deadlock on error path

Hui Wang (1):
      ALSA: hda/realtek - Two front mics on a Lenovo ThinkCenter

Iuliana Prodan (1):
      crypto: caam - fix the address of the last entry of S/G

Jason Gunthorpe (3):
      RDMA/uverbs: Fix a race with disassociate and exit_mmap()
      RDMA/siw: Fix potential siw_mem refcnt leak in siw_fastreg_mr()
      RDMA/cm: Fix ordering of xa_alloc_cyclic() in ib_create_cm_id()

Jens Axboe (1):
      io_uring: statx must grab the file table for valid fd

Kai-Heng Feng (1):
      PM: ACPI: Output correct message on target power state

Leon Romanovsky (3):
      RDMA/core: Prevent mixed use of FDs between shared ufiles
      RDMA/core: Fix overwriting of uobj in case of error
      RDMA/core: Fix race between destroy and release FD object

Lu Baolu (1):
      iommu/vt-d: Use right Kconfig option name

Marek Beh=C3=BAn (1):
      mmc: sdhci-xenon: fix annoying 1.8V regulator warning

Marek Ol=C5=A1=C3=A1k (1):
      drm/amdgpu: invalidate L2 before SDMA IBs (v2)

Martin Blumenstingl (2):
      mmc: meson-mx-sdio: Set MMC_CAP_WAIT_WHILE_BUSY
      mmc: meson-mx-sdio: remove the broken ->card_busy() op

Martin Wilck (2):
      scsi: qla2xxx: set UNLOADING before waiting for session deletion
      scsi: qla2xxx: check UNLOADING before posting async work

Matt Roper (1):
      drm/i915: Use proper fault mask in interrupt postinstall too

Mikulas Patocka (1):
      dm writecache: fix data corruption when reloading the target

Niklas Cassel (1):
      nvme: prevent double free in nvme_alloc_ns() error handling

Olga Kornievskaia (1):
      NFSv4.1: fix handling of backchannel binding in BIND_CONN_TO_SESSION

Paul Moore (1):
      selinux: properly handle multiple messages in selinux_netlink_send()

Qu Wenruo (1):
      btrfs: transaction: Avoid deadlock due to bad initialization timing o=
f fs_info::journal_info

Rayagonda Kokatanur (1):
      i2c: iproc: generate stop event for slave writes

Rodrigo Siqueira (1):
      drm/amd/display: Fix green screen issue after suspend

Russell King (1):
      ARM: dts: imx6qdl-sr-som-ti: indicate powering off wifi is safe

Sean Christopherson (1):
      vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()

Sudip Mukherjee (1):
      IB/rdmavt: Always return ERR_PTR from rvt_create_mmap_info()

Sunwook Eom (1):
      dm verity fec: fix hash block number in verity_fec_decode

Suravee Suthikulpanit (1):
      iommu/amd: Fix legacy interrupt remapping for x2APIC-enabled system

Takashi Iwai (2):
      ALSA: usb-audio: Correct a typo of NuPrime DAC-10 USB ID
      ALSA: pcm: oss: Place the plugin buffer overflow checks correctly

Tang Bin (1):
      iommu/qcom: Fix local_base status check

Vasily Averin (3):
      drm/qxl: qxl_release leak in qxl_draw_dirty_fb()
      drm/qxl: qxl_release leak in qxl_hw_surface_alloc()
      drm/qxl: qxl_release use after free

Vasily Khoruzhick (1):
      ALSA: line6: Fix POD HD500 audio playback

Veerabhadrarao Badiganti (1):
      mmc: sdhci-msm: Enable host capabilities pertains to R1b response

Ville Syrj=C3=A4l=C3=A4 (1):
      drm/edid: Fix off-by-one in DispID DTD pixel clock

Vincenzo Frascino (1):
      arm64: vdso: Add -fasynchronous-unwind-tables to cflags

Wu Bo (1):
      ALSA: hda/hdmi: fix without unlocked before return

Xiyu Yang (3):
      btrfs: fix transaction leak in btrfs_recover_relocation
      btrfs: fix block group leak when removing fails
      drm/i915/selftests: Fix i915_address_space refcnt leak

Yan Zhao (1):
      vfio: avoid possible overflow in vfio_iommu_type1_pin_pages

YueHaibing (1):
      dmaengine: hisilicon: Fix build error without PCI_MSI

ryan_chen (1):
      i2c: aspeed: Avoid i2c interrupt status clear race condition.


--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6ysdQACgkQONu9yGCS
aT5KhxAAzsU1Zg9MCNEDDxz+p+WYDVTRLrXYGHpPqT+/1XgCNYloDxno27ax2cgy
37fUinD2YaxNJP9oRKxaBwyy1OINyRShGEWjP8mHz8uj+9vEv5lfiab1J3RDVXxN
xMgG1XE70FpzLkSt58u5FooRE0MaxaRaPuh7A7mZw/nbx4oajY0aeCZ1DQplggQZ
z0luCif66L4K0FC5UXhMQ6yOQbyNGfVu3sJR262sjZZ0KHuFW6yu/0FFB02JbBdX
Q4SLgK+WUkGex3EKR98y1NnO1gXENX+4PUq8dWGkPcL74CsXtK3R/3JbzSx4iP8l
ll+vfqVp8xyzjxxtAGnmLFEHj54Jct6u+7d1GokwoTM3Ka5HhZG0JvhRIdCQHDZL
whNuvOcJs8gG1nJiQcNYxruBtq99mIs7ax4wodncWOVmCIFrlQbQieYWtZgHRn+F
P9H5uYrdJP70n65g/tlP/gJSfH/qOuzbpksptAZKkWatWAg7wFfXbwLWdA9yT5c/
6oPP0rA7me3v4LlaAHeGCFbOiuZ6K0ENTfaUSck12cRJaOahTMKK1vWePT33L1xB
OjPBg0wUsmX2KJMse9f1uqS1bmPgbDdNWNKGsFI6Cscx7var/5CexZnJUJq/KXJg
z/ehERU6LPP1f9A8tPKLtPaTPSWvs6LfcWv9YDH0vHKl8Fd5ouA=
=5HOF
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
