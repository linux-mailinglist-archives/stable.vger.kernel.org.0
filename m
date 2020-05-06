Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72D61C709B
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 14:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgEFMp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 08:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728172AbgEFMpZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 08:45:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78C8B206DD;
        Wed,  6 May 2020 12:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588769124;
        bh=Alet1qZnjaqVX7qaZNw5BLEwItIeVmiBabgPCPCkb3A=;
        h=Date:From:To:Cc:Subject:From;
        b=wkUKq0k6GKITel+Y9WuI3e0Faehv1voHzZGVPwV5Ca3EEHqoyMC/2vIbT+0J9jqjB
         X8QjZ+8qfiNK57x1xOQjTJHAK4sV8DbfXzvMRrNBYUq6OIv5b0KsQF4OWtRbUB7n33
         D1pN6/Mh66Gdy+gxqtsSUMRHWR3g+NlU3GxJhhwo=
Date:   Wed, 6 May 2020 14:45:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.179
Message-ID: <20200506124522.GA3144655@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.179 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
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
 drivers/infiniband/hw/mlx4/main.c   |    3 +
 drivers/infiniband/hw/mlx5/qp.c     |    4 +-
 drivers/iommu/amd_iommu_init.c      |    2 -
 drivers/iommu/qcom_iommu.c          |    5 ++
 drivers/md/dm-verity-fec.c          |    2 -
 drivers/mmc/host/sdhci-pci-core.c   |    3 +
 drivers/mmc/host/sdhci-xenon.c      |   10 +++++
 drivers/target/target_core_iblock.c |    2 -
 drivers/vfio/vfio_iommu_type1.c     |    6 +--
 fs/btrfs/extent-tree.c              |   16 +++++---
 fs/btrfs/tree-log.c                 |   43 +++++++++++++++++++++-
 fs/ext4/inode.c                     |    2 -
 fs/nfs/nfs3acl.c                    |   22 +++++++----
 kernel/power/hibernate.c            |    7 +++
 security/selinux/hooks.c            |   68 +++++++++++++++++++++++--------=
-----
 sound/core/oss/pcm_plugin.c         |   20 ++++++----
 sound/isa/opti9xx/miro.c            |    9 +++-
 sound/isa/opti9xx/opti92x-ad1848.c  |    9 +++-
 sound/pci/hda/patch_hdmi.c          |    4 +-
 sound/pci/hda/patch_realtek.c       |    1=20
 28 files changed, 195 insertions(+), 89 deletions(-)

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

Filipe Manana (1):
      btrfs: fix partial loss of prealloc extent past i_size after fsync

Greg Kroah-Hartman (1):
      Linux 4.14.179

Hui Wang (1):
      ALSA: hda/realtek - Two front mics on a Lenovo ThinkCenter

Kai-Heng Feng (1):
      PM: ACPI: Output correct message on target power state

Marek Beh=FAn (1):
      mmc: sdhci-xenon: fix annoying 1.8V regulator warning

Paul Moore (1):
      selinux: properly handle multiple messages in selinux_netlink_send()

Sean Christopherson (1):
      vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()

Sunwook Eom (1):
      dm verity fec: fix hash block number in verity_fec_decode

Suravee Suthikulpanit (1):
      iommu/amd: Fix legacy interrupt remapping for x2APIC-enabled system

Takashi Iwai (1):
      ALSA: pcm: oss: Place the plugin buffer overflow checks correctly

Tang Bin (1):
      iommu/qcom: Fix local_base status check

Theodore Ts'o (1):
      ext4: fix special inode number checks in __ext4_iget()

Vasily Averin (3):
      drm/qxl: qxl_release leak in qxl_draw_dirty_fb()
      drm/qxl: qxl_release leak in qxl_hw_surface_alloc()
      drm/qxl: qxl_release use after free

Ville Syrj=E4l=E4 (1):
      drm/edid: Fix off-by-one in DispID DTD pixel clock

Wu Bo (1):
      ALSA: hda/hdmi: fix without unlocked before return

Xiyu Yang (1):
      btrfs: fix block group leak when removing fails

Yan Zhao (1):
      vfio: avoid possible overflow in vfio_iommu_type1_pin_pages


--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6ysWIACgkQONu9yGCS
aT7owRAAqNd8dkNqQk2cYMe/Dlx7WvjJNsGOmngZps0Z9yUPeY2JQZTgqdVnBwOA
MWDBVm8VNIOjeGCzA6HCVFCUEdGC5F9J+CDdRaBHEC4bJhifkhl3L3B96phdASsD
cjmwwwXofDu9eigjrrILg0AKi5LqdGeXWL3Ro8LW2eoMp+dR+VSNK0IqfGtyBzY1
6oRnSyhLJbGKS2OK5/qWH5FPCkWtyDEenQ0eu+bnBOLu2s3S+yxIKf4dMBjidKR8
vFpNRzCXAJfDE2mT+wZF/aIFTssJc1Ok7jatWuSaWajrRFHGJl0goqt+1u91IY/k
raCobz8sJyUR/sU2bEMWYAYjtusM9pTZuwSavfm/xWzZL/bkOu733tpUAoHbkgKB
BeijR1/m69ASKuQJPak1WBtdzfGIYt0N3hoF31+uy7Xx+I+NXidUBzTewDAy/lGy
IVew3GNEz05WR6hAKj+rFCDNNfRD4J5iYx7p7kMDq3RSpdYuuuq1oO1WXIFik8aR
EBgvgxgONXCAGlJ0TdUGW3oKbyAg00ic7ifOHU2/rbG0wTvyi1y3xqzm+i/NT69Q
ad4N+6/MSngArImx4Prg1NBDoowebyiQzvjN7bEt/wzR2iFzRhHUu7Emp5Gq1kNA
ZSTwEiyyGKlxgqDx5iW9wkcu/AQQQKasBffzX+QbpkWAgsx9K2U=
=7Pbs
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
