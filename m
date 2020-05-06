Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CD11C709F
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 14:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgEFMp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 08:45:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727995AbgEFMp6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 08:45:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9954206DD;
        Wed,  6 May 2020 12:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588769157;
        bh=0nrtNXavH45Mn/B8CmthsF53dYhzUlLpFpNMIqnDZ7I=;
        h=Date:From:To:Cc:Subject:From;
        b=K83IbcZX+MJ7CGtQ7JYgqEI8BP1+C9TTt/rHJL9aR7F8WUYXEp7aQitkr1mjCKbam
         SRg1+8QSZ3cV+LJB7zlAxGk6QtmpQP59OiiphKPvA+vWpf6le3t3r2iFHphVr77K9Y
         I6k1+hSEsQLBP9vl56bsmvtMUTwd9hndscs28h+s=
Date:   Wed, 6 May 2020 14:45:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.121
Message-ID: <20200506124554.GA3145250@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.121 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                            |    2 -
 drivers/acpi/device_pm.c            |    4 +-
 drivers/dma/dmatest.c               |    4 +-
 drivers/gpu/drm/drm_edid.c          |    2 -
 drivers/gpu/drm/qxl/qxl_cmd.c       |   10 ++---
 drivers/gpu/drm/qxl/qxl_display.c   |    6 +--
 drivers/gpu/drm/qxl/qxl_draw.c      |   13 +++---
 drivers/gpu/drm/qxl/qxl_ioctl.c     |    5 --
 drivers/infiniband/core/rdma_core.c |    4 +-
 drivers/infiniband/hw/mlx4/main.c   |    3 +
 drivers/infiniband/hw/mlx5/qp.c     |    4 +-
 drivers/iommu/amd_iommu_init.c      |    2 -
 drivers/iommu/qcom_iommu.c          |    5 ++
 drivers/md/dm-mpath.c               |    6 ++-
 drivers/md/dm-verity-fec.c          |    2 -
 drivers/md/dm-writecache.c          |   52 +++++++++++++++++++-------
 drivers/mmc/host/cqhci.c            |   21 +++++-----
 drivers/mmc/host/meson-mx-sdio.c    |   11 -----
 drivers/mmc/host/sdhci-msm.c        |    2 +
 drivers/mmc/host/sdhci-pci-core.c   |    3 +
 drivers/mmc/host/sdhci-xenon.c      |   10 +++++
 drivers/scsi/qla2xxx/qla_os.c       |   35 ++++++++----------
 drivers/target/target_core_iblock.c |    2 -
 drivers/vfio/vfio_iommu_type1.c     |    6 +--
 fs/btrfs/extent-tree.c              |   16 +++++---
 fs/btrfs/transaction.c              |   13 +++++-
 fs/btrfs/tree-log.c                 |   43 ++++++++++++++++++++--
 fs/nfs/nfs3acl.c                    |   22 +++++++----
 kernel/power/hibernate.c            |    7 +++
 security/selinux/hooks.c            |   70 +++++++++++++++++++++++--------=
-----
 sound/core/oss/pcm_plugin.c         |   20 ++++++----
 sound/isa/opti9xx/miro.c            |    9 +++-
 sound/isa/opti9xx/opti92x-ad1848.c  |    9 +++-
 sound/pci/hda/patch_hdmi.c          |    4 +-
 sound/pci/hda/patch_realtek.c       |    1=20
 sound/usb/quirks.c                  |    2 -
 36 files changed, 280 insertions(+), 150 deletions(-)

Adrian Hunter (1):
      mmc: sdhci-pci: Fix eMMC driver strength for BYT-based controllers

Aharon Landau (1):
      RDMA/mlx5: Set GRH fields in query QP on RoCE

Alaa Hleihel (1):
      RDMA/mlx4: Initialize ib_spec on the stack

Andreas Gruenbacher (1):
      nfs: Fix potential posix_acl refcnt leak in nfs3_set_acl

Andy Shevchenko (1):
      dmaengine: dmatest: Fix iteration non-stop logic

Arnd Bergmann (1):
      ALSA: opti9xx: shut up gcc-10 range warning

David Disseldorp (1):
      scsi: target/iblock: fix WRITE SAME zeroing

Dexuan Cui (1):
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
      Linux 4.19.121

Hui Wang (1):
      ALSA: hda/realtek - Two front mics on a Lenovo ThinkCenter

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

Paul Moore (1):
      selinux: properly handle multiple messages in selinux_netlink_send()

Qu Wenruo (1):
      btrfs: transaction: Avoid deadlock due to bad initialization timing o=
f fs_info::journal_info

Sean Christopherson (1):
      vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()

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

Veerabhadrarao Badiganti (1):
      mmc: sdhci-msm: Enable host capabilities pertains to R1b response

Ville Syrj=E4l=E4 (1):
      drm/edid: Fix off-by-one in DispID DTD pixel clock

Wu Bo (1):
      ALSA: hda/hdmi: fix without unlocked before return

Xiyu Yang (1):
      btrfs: fix block group leak when removing fails

Yan Zhao (1):
      vfio: avoid possible overflow in vfio_iommu_type1_pin_pages


--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6ysYIACgkQONu9yGCS
aT7gYA/+Pk2rV4RqxILDSzFsUbeCUEGHKORuKyQRPJGM/o8bvTc520OAroOORUxm
bh0hv2pmthfiV45m3CS03ii1vqzMS3ZyN3l5WjnZzfqWzUNXUe3Z0/kvG7tBrQVZ
zCae8ez7Y0/pQIl6+1orWc9g61RT9vE3lhspoA4pww2M/90q4lwacwJmvPUZFwXX
X1aSMRVbQC2QsHszPoRSYtn4/09qcyGaiXrgSrvyWj8s9yZ2RFZdHJQhbjit2MvY
ORbbg4EY8BnZbs0UAn6MoqxZqhH11YMDobbx2Yq8PZk1kl0TkzqRrVzJBiJmESvc
BhZwWnypXEcZx92LNOLbuiSLdBV9YAWNWUu2VolY6Wr3ZeDkRKEgSWyYKCOnsfTK
8uIoXSKPi6J5WRBhQABtu3S/+Yb+HZCZar2+1JTyw7sW/RDgPgj/E26IZM8BLBo+
SWWXXfDk1c/M1Cay+5xZLpxythzcU+1btgVNfC989BSqSFjLZJHtDMRb/ivHeadz
e4jUHXOGDFIO6pAVzpLzqcpwhdV2e3+HE+NdOzbdS4QCw3u1d2pz9FCx+uSG/grP
LdMvM8U2FGlIAxbE7W65QMYt/E+VhEl5R0dRRSC0ryb9tyYGafgnLz+3lVdzajxs
RYKHo9LmPDY0sHgepoS0E9insBYjkaR5sSsHQ34ygE+V1rb8zFk=
=qgzo
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
