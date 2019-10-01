Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEBEC2E04
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 09:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbfJAHOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 03:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725777AbfJAHOd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 03:14:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD0C021906;
        Tue,  1 Oct 2019 07:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569914072;
        bh=N2Xo6igw/Gmq7iy0EAFasi67TocyY1ZrP/PiradId1o=;
        h=Date:From:To:Cc:Subject:From;
        b=NT6rDzcqmggtUWW4o5htCgHvtVkdk4TWA6zt4cgf8nTusMNjt6zIlc0E5nWGYETvN
         u9tYxB+prRMvJLmoIsNWs+MudGWxdQ+UlBrZhorZscIe0piXTnDQZEwYSjRJZk/BWE
         0KekWfOBSNuBz/fdhXu77dTTBjAaF7L4SgV3/9+0=
Date:   Tue, 1 Oct 2019 09:14:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.76
Message-ID: <20191001071429.GA2894646@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.76 kernel.

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

 Makefile                                             |    2=20
 arch/powerpc/include/asm/opal.h                      |    2=20
 arch/powerpc/platforms/powernv/opal-wrappers.S       |    2=20
 arch/powerpc/sysdev/xive/native.c                    |   11 +
 block/blk-core.c                                     |    2=20
 block/blk-flush.c                                    |    6=20
 block/blk-mq.c                                       |   19 +-
 block/blk-sysfs.c                                    |    3=20
 block/blk.h                                          |    2=20
 drivers/acpi/acpi_video.c                            |   37 +++++
 drivers/bluetooth/btrtl.c                            |   20 ++
 drivers/bluetooth/btrtl.h                            |    6=20
 drivers/bluetooth/btusb.c                            |    4=20
 drivers/crypto/talitos.c                             |    1=20
 drivers/gpu/drm/amd/display/dc/calcs/Makefile        |    4=20
 drivers/gpu/drm/amd/display/dc/dml/Makefile          |    4=20
 drivers/gpu/drm/amd/powerplay/hwmgr/smu8_hwmgr.c     |    5=20
 drivers/gpu/drm/drm_probe_helper.c                   |    9 +
 drivers/gpu/drm/nouveau/dispnv50/head.c              |   28 +++
 drivers/hid/hid-ids.h                                |    1=20
 drivers/hid/hid-lg.c                                 |   10 -
 drivers/hid/hid-lg4ff.c                              |    1=20
 drivers/hid/hid-prodikeys.c                          |   12 +
 drivers/hid/hid-quirks.c                             |    1=20
 drivers/hid/hid-sony.c                               |    2=20
 drivers/hid/hidraw.c                                 |    2=20
 drivers/infiniband/core/cq.c                         |    8 -
 drivers/infiniband/core/device.c                     |   15 +-
 drivers/infiniband/core/mad.c                        |    2=20
 drivers/infiniband/core/restrack.c                   |    4=20
 drivers/irqchip/irq-gic-v3-its.c                     |    9 -
 drivers/md/bcache/super.c                            |    1=20
 drivers/md/dm-zoned-target.c                         |    2=20
 drivers/media/i2c/tvp5150.c                          |    2=20
 drivers/mtd/chips/cfi_cmdset_0002.c                  |   18 +-
 drivers/net/ethernet/ibm/ibmvnic.c                   |    9 -
 drivers/net/ethernet/mellanox/mlx5/core/en.h         |    3=20
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |   28 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |    8 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c      |  126 ++++++++++++++=
+--
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c   |    9 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h   |    6=20
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c       |    5=20
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c          |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h          |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c          |    2=20
 drivers/pci/controller/pci-hyperv.c                  |    2=20
 drivers/pinctrl/sprd/pinctrl-sprd.c                  |    6=20
 drivers/power/supply/power_supply_sysfs.c            |    3=20
 drivers/scsi/qla2xxx/qla_gs.c                        |  134 +++++++++-----=
-----
 drivers/scsi/qla2xxx/qla_init.c                      |   11 -
 fs/cifs/smb2ops.c                                    |   44 ++++++
 fs/f2fs/checkpoint.c                                 |   12 +
 fs/f2fs/data.c                                       |    8 -
 fs/f2fs/f2fs.h                                       |    4=20
 fs/f2fs/gc.c                                         |    2=20
 fs/f2fs/inline.c                                     |    4=20
 fs/f2fs/inode.c                                      |    4=20
 fs/f2fs/node.c                                       |    6=20
 fs/f2fs/recovery.c                                   |    2=20
 fs/f2fs/segment.c                                    |   52 ++++++-
 fs/f2fs/segment.h                                    |    4=20
 fs/f2fs/super.c                                      |    6=20
 fs/f2fs/xattr.c                                      |    4=20
 fs/xfs/libxfs/xfs_bmap.c                             |   29 ++--
 include/rdma/ib_verbs.h                              |    9 -
 init/initramfs.c                                     |    2=20
 kernel/locking/lockdep.c                             |    3=20
 net/bluetooth/hci_event.c                            |    5=20
 net/bluetooth/l2cap_core.c                           |    9 -
 net/ipv4/raw_diag.c                                  |    3=20
 net/netfilter/nft_socket.c                           |    6=20
 net/rds/bind.c                                       |   45 +++---
 net/sched/sch_api.c                                  |    2=20
 sound/firewire/dice/dice-alesis.c                    |    2=20
 sound/pci/hda/hda_intel.c                            |    3=20
 sound/pci/hda/patch_analog.c                         |    1=20
 sound/soc/fsl/fsl_ssi.c                              |    6=20
 sound/soc/intel/boards/cht_bsw_max98090_ti.c         |   47 +++++-
 sound/usb/quirks.c                                   |    2=20
 tools/lib/bpf/bpf.c                                  |   17 +-
 tools/objtool/Makefile                               |    2=20
 82 files changed, 701 insertions(+), 257 deletions(-)

Alaa Hleihel (1):
      net/mlx5e: don't set CHECKSUM_COMPLETE on SCTP packets

Alan Stern (3):
      HID: prodikeys: Fix general protection fault during probe
      HID: logitech: Fix general protection fault caused by Logitech driver
      HID: hidraw: Fix invalid read in hidraw_ioctl

Aurelien Aptel (1):
      CIFS: fix deadlock in cached root handling

Chao Yu (3):
      Revert "f2fs: avoid out-of-range memory access"
      f2fs: fix to do sanity check on segment bitmap of LFS curseg
      f2fs: use generic EFSBADCRC/EFSCORRUPTED

Chris Wilson (1):
      drm: Flush output polling on shutdown

Coly Li (1):
      bcache: remove redundant LIST_HEAD(journal) from run_cache_set()

Cong Wang (2):
      mlx5: fix get_ip_proto()
      net_sched: check cops->tcf_block in tc_bind_tclass()

Darrick J. Wong (1):
      xfs: don't crash on null attr fork xfs_bmapi_read

David Lechner (1):
      power: supply: sysfs: ratelimit property read error message

Dexuan Cui (1):
      PCI: hv: Avoid use of hv_pci_dev->pci_slot after freeing it

Emmanuel Grumbach (1):
      iwlwifi: mvm: send BCAST management frames to the right station

Fernando Fernandez Mancera (1):
      netfilter: nft_socket: fix erroneous socket assignment

Greg Kroah-Hartman (1):
      Linux 4.19.76

Greg Kurz (1):
      powerpc/xive: Fix bogus error code returned by OPAL

Gustavo A. R. Silva (1):
      crypto: talitos - fix missing break in switch statement

Hans de Goede (2):
      ASoC: Intel: cht_bsw_max98090_ti: Enable codec clock once and keep it=
 enabled
      ACPI: video: Add new hw_changes_brightness quirk, set it on PB Easyno=
te MZ35

Himanshu Madhani (1):
      scsi: qla2xxx: Return switch command on a timeout

Ilia Mirkin (1):
      drm/nouveau/disp/nv50-: fix center/aspect-corrected scaling

Ilya Pshonkin (1):
      ALSA: usb-audio: Add Hiby device family to quirks for native DSD supp=
ort

Jack Morgenstein (1):
      IB/core: Add an unbound WQ type to the new CQ API

Jian-Hong Pan (2):
      Bluetooth: btrtl: HCI reset on close for Realtek BT chip
      Bluetooth: btrtl: Additional Realtek 8822CE Bluetooth devices

Jianchao Wang (1):
      blk-mq: change gfp flags to GFP_NOIO in blk_mq_realloc_hw_ctxs

Josh Poimboeuf (1):
      objtool: Clobber user CFLAGS variable

Juliet Kim (1):
      net/ibmvnic: free reset work of removed device from queue

Jussi Laako (1):
      ALSA: usb-audio: Add DSD support for EVGA NU Audio

Ka-Cheong Poon (2):
      net/rds: An rds_sock is added too early to the hash table
      net/rds: Check laddr_check before calling it

Leon Romanovsky (1):
      RDMA/restrack: Protect from reentry to resource return path

Lorenz Bauer (1):
      bpf: libbpf: retry loading program on EAGAIN

Marc Zyngier (1):
      irqchip/gic-v3-its: Fix LPI release for Multi-MSI devices

Marcel Holtmann (1):
      Revert "Bluetooth: validate BLE connection interval updates"

Marco Felsch (1):
      media: tvp5150: fix switch exit in set control handler

Michal Suchanek (1):
      net/ibmvnic: Fix missing { in __ibmvnic_reset

Mikulas Patocka (1):
      dm zoned: fix invalid memory access

Naftali Goldstein (1):
      iwlwifi: mvm: always init rs_fw with 20MHz bandwidth rates

Natali Shechtman (1):
      net/mlx5e: Set ECN for received packets using CQE indication

Nathan Chancellor (1):
      pinctrl: sprd: Use define directive for sprd_pinconf_params values

Nick Desaulniers (1):
      drm/amd/display: readd -msse2 to prevent Clang from emitting libcalls=
 to undefined SW FP routines

Or Gerlitz (1):
      net/mlx5e: Allow reporting of checksum unnecessary

Quinn Tran (2):
      scsi: qla2xxx: Turn off IOCB timeout timer on IOCB completion
      scsi: qla2xxx: Remove all rports if fabric scan retry fails

Roderick Colenbrander (1):
      HID: sony: Fix memory corruption issue on cleanup.

Saeed Mahameed (3):
      net/mlx5e: XDP, Avoid checksum complete when XDP prog is loaded
      net/mlx5e: Rx, Fixup skb checksum for packets with tail padding
      net/mlx5e: Rx, Check ip headers sanity

Sebastian Parschauer (1):
      HID: Add quirk for HP X500 PIXART OEM mouse

Shih-Yuan Lee (FourDollars) (1):
      ALSA: hda - Add laptop imic fixup for ASUS M9V laptop

Shirish S (1):
      Revert "drm/amd/powerplay: Enable/Disable NBPSTATE on On/OFF of UVD"

Stephen Hemminger (1):
      net: don't warn in inet diag when IPV6 is disabled

Steven Price (1):
      initramfs: don't free a non-existent initrd

Surbhi Palande (1):
      f2fs: check all the data segments against all node ones

Takashi Iwai (2):
      ASoC: fsl: Fix of-node refcount unbalance in fsl_ssi_probe_from_dt()
      ALSA: hda - Apply AMD controller workaround for Raven platform

Takashi Sakamoto (1):
      ALSA: dice: fix wrong packet parameter for Alesis iO26

Tokunori Ikegami (1):
      mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()

Waiman Long (1):
      locking/lockdep: Add debug_locks check in __lock_downgrade()

zhengbin (1):
      blk-mq: move cancel of requeue_work to the front of blk_exit_queue


--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2S/NUACgkQONu9yGCS
aT7MMhAAgrPiLMM+EBaVOOY1aD4rd/ca1dZhakKTAm2HoJiqUpIlfxReinl0Owyr
VqmryjkxdseIRSukeSGvXyFaQVIrmKiyB+OnKhaZj5hRe8Nft7v6h2HPpkP94hXh
CRIPFMPmsnzQBSLV/jks4P28aan9TjrhZhl8VDAMYGtQwCGtl+MQn+QEJ0zCFLtA
mNOQIU0iHEeEAA3Bk23FgWFT/hMYQrWhLc84UJnT3xa9+2+xdfkxl7iSCFhIgPBw
OkX/Eu5LwCTyhFJVtr+ICF+eUJX6i+VEa/4yRpMlOyfJOTIYLN1uWolrNCI8CttQ
LvnldF47ipbXAmRmdglkJN5RPpdnuioiBXNzVDz4zLf61HtQgnc0F2Qdp3I4xWom
VnADg+UY3zCO2MMMsZR3Us6fQlJoAiYPQGtWd0oIKLpWa753XmSEUMZ8kyOnLS+7
jYhY0gvxB+4KVNpx2YMM9g+1kk/f0cd5/M6jMMvcDXIMvYn1zwMDFrJUTZOiPmjN
9Dpmb99nOe61BgnFm6PcNglK/+MUqWeJcW0hseujq351yzSp/Z7XZlJAYKxbJUxd
G3GSckPwud36uy3CkRIeYi65vcmFLOSVOuG9d/s+Bf5wRXOs1XBEMVsVueSvYUjk
kX/GGqbdNBQUZX/lTDmkbhYeo4FO4mgNH2Hfz//nNlFapTr9mh4=
=cWIu
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
