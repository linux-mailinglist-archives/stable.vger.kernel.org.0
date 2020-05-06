Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB811C70A3
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 14:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgEFMqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 08:46:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728248AbgEFMqS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 08:46:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B69F0206DD;
        Wed,  6 May 2020 12:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588769177;
        bh=m6PoFH6AUQP7MS3kqLegI5qgM8ppoQywHKEd/3ENm3w=;
        h=Date:From:To:Cc:Subject:From;
        b=euz8mDd4Y51huiYVPP57c9bQJdmwgDT/BKee1OKPgwNXW/sR2bGLURjnojtEM1Lse
         ID55BrERjjrqAA/EsPuW06w7f6/aKwPhTbcNKyB9xVnRRIInZxOg0/+36JodM5c+Ul
         sl48edE5y2oEVt96vnnyaY6hSv9XPQGsQARSw1Ag=
Date:   Wed, 6 May 2020 14:46:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.39
Message-ID: <20200506124615.GA3145866@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.39 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                          |    2=20
 arch/arm/boot/dts/imx6qdl-sr-som-ti.dtsi          |    1=20
 arch/arm64/kernel/vdso/Makefile                   |    2=20
 drivers/acpi/device_pm.c                          |    4 -
 drivers/crypto/caam/caamalg.c                     |    2=20
 drivers/dma-buf/dma-buf.c                         |    3=20
 drivers/dma/dmatest.c                             |    6 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   38 +++++++++--
 drivers/gpu/drm/drm_edid.c                        |    2=20
 drivers/gpu/drm/qxl/qxl_cmd.c                     |   10 +--
 drivers/gpu/drm/qxl/qxl_display.c                 |    6 -
 drivers/gpu/drm/qxl/qxl_draw.c                    |    7 +-
 drivers/gpu/drm/qxl/qxl_ioctl.c                   |    5 -
 drivers/hv/vmbus_drv.c                            |   43 ++++++++++---
 drivers/i2c/busses/i2c-amd-mp2-pci.c              |    2=20
 drivers/i2c/busses/i2c-aspeed.c                   |    5 +
 drivers/i2c/busses/i2c-bcm-iproc.c                |    3=20
 drivers/infiniband/core/cm.c                      |   27 +++-----
 drivers/infiniband/core/rdma_core.c               |    4 -
 drivers/infiniband/hw/mlx4/main.c                 |    3=20
 drivers/infiniband/hw/mlx5/qp.c                   |    4 -
 drivers/infiniband/sw/rdmavt/cq.c                 |    4 -
 drivers/infiniband/sw/rdmavt/mmap.c               |    4 -
 drivers/infiniband/sw/rdmavt/qp.c                 |    4 -
 drivers/infiniband/sw/rdmavt/srq.c                |    4 -
 drivers/infiniband/sw/siw/siw_qp_tx.c             |   15 +++-
 drivers/iommu/amd_iommu_init.c                    |    2=20
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
 fs/nfs/nfs3acl.c                                  |   22 ++++--
 fs/nfs/nfs4proc.c                                 |    8 ++
 fs/ocfs2/dlmfs/dlmfs.c                            |   27 +++-----
 fs/super.c                                        |    2=20
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
 60 files changed, 426 insertions(+), 232 deletions(-)

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

Dan Carpenter (2):
      i2c: amd-mp2-pci: Fix Oops in amd_mp2_pci_init() error handling
      RDMA/cm: Fix an error check in cm_alloc_id_priv()

Daniel Vetter (1):
      dma-buf: Fix SET_NAME ioctl uapi

David Disseldorp (1):
      scsi: target/iblock: fix WRITE SAME zeroing

David Howells (1):
      Fix use after free in get_tree_bdev()

Dexuan Cui (2):
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

Greg Kroah-Hartman (1):
      Linux 5.4.39

Hui Wang (1):
      ALSA: hda/realtek - Two front mics on a Lenovo ThinkCenter

Iuliana Prodan (1):
      crypto: caam - fix the address of the last entry of S/G

Jason Gunthorpe (2):
      RDMA/siw: Fix potential siw_mem refcnt leak in siw_fastreg_mr()
      RDMA/cm: Fix ordering of xa_alloc_cyclic() in ib_create_cm_id()

Kai-Heng Feng (1):
      PM: ACPI: Output correct message on target power state

Leon Romanovsky (2):
      RDMA/core: Prevent mixed use of FDs between shared ufiles
      RDMA/core: Fix race between destroy and release FD object

Marek Beh=FAn (1):
      mmc: sdhci-xenon: fix annoying 1.8V regulator warning

Martin Blumenstingl (2):
      mmc: meson-mx-sdio: Set MMC_CAP_WAIT_WHILE_BUSY
      mmc: meson-mx-sdio: remove the broken ->card_busy() op

Martin Wilck (2):
      scsi: qla2xxx: set UNLOADING before waiting for session deletion
      scsi: qla2xxx: check UNLOADING before posting async work

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

Ville Syrj=E4l=E4 (1):
      drm/edid: Fix off-by-one in DispID DTD pixel clock

Vincenzo Frascino (1):
      arm64: vdso: Add -fasynchronous-unwind-tables to cflags

Wu Bo (1):
      ALSA: hda/hdmi: fix without unlocked before return

Xiyu Yang (2):
      btrfs: fix transaction leak in btrfs_recover_relocation
      btrfs: fix block group leak when removing fails

Yan Zhao (1):
      vfio: avoid possible overflow in vfio_iommu_type1_pin_pages

ryan_chen (1):
      i2c: aspeed: Avoid i2c interrupt status clear race condition.


--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6ysZYACgkQONu9yGCS
aT4Kcw/8DS9j1o9WAP4Le4+QGMdbbscUxelU8R+E8ngIM99qPBKqAml3whY85x3U
ZjijgerFn6UW+1+hv4Ta2EdbZLWQOYylFJiezW3yun45quQ2Mh0VXL8exejCXBo9
+PWEargH/SUkAs+8LXBdY0GXJqF8DboMq8iKnz+9fOeNGoe9YYErRaqxqh8Y/OOI
2/BeanXBaaZib5fgZwoibp+qu8AKd4d9nU6yCLtrwV0EkaffrYp8TEU8QyBjRkSH
qwfB8P9DOqPWFxs+KI2oEuDDxETMs0XDOD3NUy/wKMgW2+ONdQ7pIgpZPMDls4G5
CUE8q2Ya7d+fd9jSR5pmtnFbkg+XYeihSXDvqw2lpSij+jJMzWIdpyo3TP0sW57T
bkAIDDXCpsy/xaTdXLYuf8YJuOotsSVFbMNspQi9kUj1U6mQNKZmFEK1vJFz7LKp
Yo3QRolrlWZYxlseuX9I9kIcntisInc4S+oy5AjYcoIXdJbZlAvx0PWjhZ69hoK/
+hBoCzViRGNIi8C/BPtoVbt25DQtVfRpv5V+RrPeb5n61+U4t8ur0VlK+/D9RCRB
uDmGTccaQ2SCKlfs8TmeuFiXVeC6pFv6qT4YNW9qwXcSdeOQ51f1oMpoA0z5LbAv
jvbN32nSAufvXhDu1G3uQ5uodPD4GBcLbyE9ByNuvN5nnZoZMfs=
=oXCd
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
