Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8681288AB
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 11:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfLUKmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 05:42:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbfLUKmG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Dec 2019 05:42:06 -0500
Received: from localhost (unknown [38.98.37.136])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96F9121927;
        Sat, 21 Dec 2019 10:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576924924;
        bh=ewVagbkvnIslUa37SfhzJfGgZeau9IibOOpO0YPAQhY=;
        h=Date:From:To:Cc:Subject:From;
        b=Z3elYubcibl1B6auLGJYEQ/2fhm/SV1fh9LmES3Mhnfq8b22OuKtzz4AxMCwjoXk8
         PLYmxFjgtvk4WalMkgerCTafkPqado4epNG3BSDPznFJMpw+9HGZWnl4fSgmK+t5Pi
         SVm8JlDio8gTB7KqOY3dUk2DJfdnYsppx91OE3yE=
Date:   Sat, 21 Dec 2019 11:41:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.6
Message-ID: <20191221104148.GA61938@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.6 kernel.

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

 Makefile                                                 |    2=20
 arch/arm/boot/dts/s3c6410-mini6410.dts                   |    4=20
 arch/arm/boot/dts/s3c6410-smdk6410.dts                   |    4=20
 arch/arm/mach-tegra/reset-handler.S                      |    6=20
 arch/xtensa/include/asm/syscall.h                        |    2=20
 arch/xtensa/mm/kasan_init.c                              |    4=20
 arch/xtensa/mm/tlb.c                                     |    4=20
 block/bio.c                                              |    4=20
 drivers/dma-buf/sync_file.c                              |    2=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.h                  |    1=20
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                   |   57 ++++-
 drivers/gpu/drm/amd/amdgpu/gfxhub_v1_0.c                 |    2=20
 drivers/gpu/drm/amd/amdgpu/gfxhub_v2_0.c                 |    2=20
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c                   |   57 +++++
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c                    |   73 +++++++
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c                  |    2=20
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c                  |    2=20
 drivers/gpu/drm/amd/amdgpu/mmhub_v9_4.c                  |    4=20
 drivers/gpu/drm/amd/amdgpu/soc15.h                       |    4=20
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c |    3=20
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c       |   19 +
 drivers/gpu/drm/drm_dp_mst_topology.c                    |    6=20
 drivers/gpu/drm/i915/display/intel_fbc.c                 |    2=20
 drivers/gpu/drm/i915/gvt/cmd_parser.c                    |    6=20
 drivers/gpu/drm/meson/meson_venc_cvbs.c                  |   48 ++--
 drivers/gpu/drm/mgag200/mgag200_drv.c                    |   36 +++
 drivers/gpu/drm/mgag200/mgag200_drv.h                    |   18 +
 drivers/gpu/drm/mgag200/mgag200_main.c                   |    3=20
 drivers/gpu/drm/nouveau/dispnv50/atom.h                  |    1=20
 drivers/gpu/drm/nouveau/dispnv50/disp.c                  |  102 ++++++----
 drivers/gpu/drm/nouveau/dispnv50/head.c                  |    5=20
 drivers/gpu/drm/panfrost/panfrost_drv.c                  |   18 -
 drivers/gpu/drm/panfrost/panfrost_gem.c                  |   15 -
 drivers/gpu/drm/radeon/r100.c                            |    4=20
 drivers/gpu/drm/radeon/r200.c                            |    4=20
 drivers/md/dm-clone-metadata.c                           |  136 +++++++++-=
---
 drivers/md/dm-clone-metadata.h                           |   17 +
 drivers/md/dm-clone-target.c                             |   53 ++++-
 drivers/md/dm-mpath.c                                    |   37 ---
 drivers/md/dm-thin-metadata.c                            |   29 ++
 drivers/md/dm-thin-metadata.h                            |    7=20
 drivers/md/dm-thin.c                                     |   42 +++-
 drivers/md/persistent-data/dm-btree-remove.c             |    8=20
 drivers/mmc/core/block.c                                 |  151 +++++-----=
-----
 drivers/mmc/core/core.c                                  |   12 -
 drivers/mmc/core/core.h                                  |    2=20
 drivers/mmc/core/sdio.c                                  |   28 ++
 drivers/mmc/core/sdio_bus.c                              |    9=20
 drivers/pci/controller/pcie-rcar.c                       |    6=20
 drivers/pci/hotplug/pciehp.h                             |    2=20
 drivers/pci/hotplug/pciehp_ctrl.c                        |    6=20
 drivers/pci/hotplug/pciehp_hpc.c                         |    2=20
 drivers/pci/msi.c                                        |    3=20
 drivers/pci/pci-driver.c                                 |   17 +
 drivers/pci/probe.c                                      |   16 +
 drivers/pci/quirks.c                                     |   22 +-
 drivers/pci/switch/switchtec.c                           |    2=20
 drivers/rpmsg/qcom_glink_native.c                        |   53 ++++-
 drivers/rpmsg/qcom_glink_smem.c                          |    2=20
 drivers/scsi/libiscsi.c                                  |    4=20
 drivers/scsi/qla2xxx/qla_attr.c                          |    1=20
 drivers/scsi/qla2xxx/qla_bsg.c                           |    2=20
 drivers/scsi/qla2xxx/qla_fw.h                            |    4=20
 drivers/scsi/qla2xxx/qla_init.c                          |    2=20
 drivers/scsi/qla2xxx/qla_sup.c                           |   35 ++-
 drivers/scsi/qla2xxx/qla_target.c                        |    1=20
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                       |    2=20
 drivers/scsi/ufs/cdns-pltfrm.c                           |    6=20
 drivers/usb/core/hcd.c                                   |   42 ++--
 drivers/usb/storage/scsiglue.c                           |    3=20
 drivers/vfio/pci/vfio_pci_intrs.c                        |    2=20
 fs/cifs/cifs_debug.c                                     |    5=20
 fs/cifs/cifsglob.h                                       |    1=20
 fs/cifs/connect.c                                        |   53 +++--
 fs/cifs/file.c                                           |    7=20
 fs/cifs/smb2misc.c                                       |   59 ++++-
 fs/cifs/smb2ops.c                                        |    8=20
 fs/cifs/smb2pdu.c                                        |   16 +
 fs/cifs/smb2proto.h                                      |    3=20
 fs/cifs/smbdirect.c                                      |   36 ++-
 fs/cifs/transport.c                                      |   17 +
 fs/gfs2/file.c                                           |   15 -
 fs/gfs2/log.c                                            |    8=20
 fs/gfs2/log.h                                            |    1=20
 fs/gfs2/lops.c                                           |    5=20
 fs/gfs2/trans.c                                          |    2=20
 include/linux/mmc/card.h                                 |    1=20
 include/linux/pm_qos.h                                   |    2=20
 sound/hda/hdac_stream.c                                  |    4=20
 sound/pci/hda/patch_hdmi.c                               |    2=20
 90 files changed, 1095 insertions(+), 442 deletions(-)

Alex Deucher (3):
      drm/radeon: fix r1xx/r2xx register checker for POT textures
      drm/amd/display: re-enable wait in pipelock, but add timeout
      drm/amd/display: add default clocks if not able to fetch them

Andreas Gruenbacher (2):
      block: fix "check bi_size overflow before merge"
      gfs2: Multi-block allocations in gfs2_page_mkwrite

Arun Kumar Neelakantam (2):
      rpmsg: glink: Fix reuse intents memory leak issue
      rpmsg: glink: Fix use after free in open_ack TIMEOUT case

Bart Van Assche (1):
      scsi: iscsi: Fix a potential deadlock in the timeout handler

Bjorn Andersson (2):
      rpmsg: glink: Don't send pending rx_done during remove
      rpmsg: glink: Free pending deferred work on remove

Bob Peterson (1):
      gfs2: fix glock reference problem in gfs2_trans_remove_revoke

Boris Brezillon (3):
      drm/panfrost: Fix a race in panfrost_ioctl_madvise()
      drm/panfrost: Fix a BO leak in panfrost_ioctl_mmap_bo()
      drm/panfrost: Fix a race in panfrost_gem_free_object()

Chaotian Jing (2):
      mmc: block: Make card_busy_detect() a bit more generic
      mmc: block: Add CMD13 polling for MMC IOCTLS with R1B response

Chris Lew (3):
      rpmsg: glink: Set tail pointer to 0 at end of FIFO
      rpmsg: glink: Put an extra reference during cleanup
      rpmsg: glink: Fix rpmsg_register_device err handling

Dexuan Cui (1):
      PCI/PM: Always return devices to D0 when thawing

Dmitry Osipenko (1):
      ARM: tegra: Fix FLOW_CTLR_HALT register clobbering by tegra_resume()

Fredrik Noring (1):
      USB: Fix incorrect DMA allocations for local memory pool drivers

George Cherian (1):
      PCI: Apply Cavium ACS quirk to ThunderX2 and ThunderX3

Greg Kroah-Hartman (1):
      Linux 5.4.6

Himanshu Madhani (1):
      scsi: qla2xxx: Correctly retrieve and interpret active flash region

Hou Tao (1):
      dm btree: increase rebalance threshold in __rebalance2()

Jian-Hong Pan (1):
      PCI/MSI: Fix incorrect MSI-X masking on resume

Jiang Yi (1):
      vfio/pci: call irq_bypass_unregister_producer() before freeing irq

Leonard Crestez (1):
      PM / QoS: Redefine FREQ_QOS_MAX_DEFAULT_VALUE to S32_MAX

Lihua Yao (1):
      ARM: dts: s3c64xx: Fix init order of clock providers

Logan Gunthorpe (1):
      PCI/switchtec: Read all 64 bits of part_event_bitmap

Long Li (6):
      cifs: smbd: Return -EAGAIN when transport is reconnecting
      cifs: smbd: Only queue work for error recovery on memory registration
      cifs: smbd: Add messages on RDMA session destroy and reconnection
      cifs: smbd: Return -EINVAL when the number of iovs exceeds SMBDIRECT_=
MAX_SGE
      cifs: smbd: Return -ECONNABORTED when trasnport is not in connected s=
tate
      cifs: Don't display RDMA transport on reconnect

Lukas Wunner (1):
      PCI: pciehp: Avoid returning prematurely from sysfs requests

Lyude Paul (3):
      drm/nouveau/kms/nv50-: Call outp_atomic_check_view() before handling =
PBN
      drm/nouveau/kms/nv50-: Store the bpc we're using in nv50_head_atom
      drm/nouveau/kms/nv50-: Limit MST BPC to 8

Martin Blumenstingl (1):
      drm: meson: venc: cvbs: fix CVBS mode matching

Max Filippov (3):
      xtensa: use MEMBLOCK_ALLOC_ANYWHERE for KASAN shadow map
      xtensa: fix TLB sanity checker
      xtensa: fix syscall_set_return_value

Michael Hernandez (2):
      scsi: qla2xxx: Added support for MPI and PEP regions for ISP28XX
      scsi: qla2xxx: Fix incorrect SFUB length used for Secure Flash Update=
 MB Cmd

Mike Snitzer (1):
      dm mpath: remove harmful bio-based optimization

Navid Emamdoost (1):
      dma-buf: Fix memory leak in sync_file_merge()

Nikos Tsironis (5):
      dm clone metadata: Track exact changes per transaction
      dm clone metadata: Use a two phase commit
      dm clone: Flush destination device before committing metadata
      dm thin metadata: Add support for a pre-commit callback
      dm thin: Flush data device before committing metadata

Paulo Alcantara (SUSE) (1):
      cifs: Fix retrieval of DFS referrals in cifs_mount()

Pavel Shilovsky (4):
      CIFS: Respect O_SYNC and O_DIRECT flags during reconnect
      CIFS: Close open handle after interrupted close
      CIFS: Do not miss cancelled OPEN responses
      CIFS: Fix NULL pointer dereference in mid callback

Roman Bolshakov (3):
      scsi: qla2xxx: Ignore NULL pointer in tcm_qla2xxx_free_mcmd
      scsi: qla2xxx: Initialize free_work before flushing it
      scsi: qla2xxx: Change discovery state before PLOGI

Steffen Liebergeld (1):
      PCI: Fix Intel ACS quirk UPDCR register address

Subbaraya Sundeep (1):
      PCI: Do not use bus number zero from EA capability

Takashi Iwai (1):
      ALSA: hda: Fix regression by strip mask fix

Thomas Zimmermann (4):
      drm/mgag200: Extract device type from flags
      drm/mgag200: Store flags from PCI driver data in device structure
      drm/mgag200: Add workaround for HW that does not support 'startadd'
      drm/mgag200: Flag all G200 SE A machines as broken wrt <startadd>

Ulf Hansson (2):
      mmc: core: Drop check for mmc_card_is_removable() in mmc_rescan()
      mmc: core: Re-work HW reset for SDIO cards

Ville Syrj=E4l=E4 (1):
      drm/i915/fbc: Disable fbc by default on all glk+

Wayne Lin (1):
      drm/dp_mst: Correct the bug in drm_dp_update_payload_part1()

Xiaojie Yuan (2):
      drm/amdgpu/gfx10: explicitly wait for cp idle after halt/unhalt
      drm/amdgpu/gfx10: re-init clear state buffer after gpu reset

Yoshihiro Shimoda (1):
      PCI: rcar: Fix missing MACCTLR register setting in initialization seq=
uence

Zhenyu Wang (1):
      drm/i915/gvt: Fix cmd length check for MI_ATOMIC

changzhu (4):
      drm/amdgpu: initialize vm_inv_eng0_sem for gfxhub and mmhub
      drm/amdgpu: invalidate mmhub semaphore workaround in gmc9/gmc10
      drm/amdgpu: avoid using invalidate semaphore for picasso
      drm/amdgpu: add invalidate semaphore limit for SRIOV and picasso in g=
mc9

sheebab (1):
      scsi: ufs: Disable autohibern8 feature in Cadence UFS


--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl399usACgkQONu9yGCS
aT5U+A/+MQJ+mIosdKuXzmuCwoBHb72+/k1JiCeBWL8dhuuEd/VLW/Mit4T7ew5N
aAj+uAF+Yrp+rvbsCtVbFSQwdq/om+g930AD8FvgchTxP1EcRVIvrE6yB+R6eFhe
aasd4rPcH95ijQV4o3qjMHD8tD0k9Oaz28rNFOW9e7x2DMYkCVivo0QYVz7yrdDI
SkwZvC8RqHf30vylPWZuXkwpCtd3NLsQ1QEVg6Ui82+EqdxDDPaiHSNsrkQEs8yp
2cTkjyDv3P34pj4c5LivsYDpdEsIblW6bNOCvU7Hk63a46fa8+YsXOfubp/Zu1sp
zclRfU5+8BsmnkcWOzAiCeHBD6en6J7VGbCSzcNtNMiEZ11+7z9b/OxBZOurcofK
Mwr02vURQpLe0GDiU4lFJ5UQDQov0h+H9fMNN8+juh6dWaDQaMhHuQaugYCinXYE
Te4HGlBf2QkISYXaxoYB4oBDGppyWGJ+yhAb1Hwa0UkpNp0GdbyOUty7h9mBXOEV
319a4hXofxahpzKH6uwn4pN0VCbmyAG42NuGHBu3iJg6wCtK6trR0o8QgcJbP21J
6SiO2FS0XNYbfGIDYAjcoxTfbU1cmd9CCfUHKt45wXzphQioCQr29NwiilIn3wpr
LlMUFX23ANfBgpDUWwsBOqM2+cyGbWRctOTuVkYX1G5ul+ZfvJU=
=M3Ft
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
