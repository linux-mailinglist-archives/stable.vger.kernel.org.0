Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05AF5164FDE
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 21:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgBSUav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 15:30:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbgBSUau (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Feb 2020 15:30:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4692208C4;
        Wed, 19 Feb 2020 20:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582144249;
        bh=f/aEBnXRkl4kHx4otcuAH71yDHn1fKKw0rlbBw3heKA=;
        h=Date:From:To:Cc:Subject:From;
        b=MEwxV9R0/RKWFrbISsbSNaq0Vg/SCgqtxJcKuNKIijc0e8vRCoIY1xLJbqMtzl+ZY
         f6MRzTGvJdlNjgW73l8pAS4BMYY8tAdY4edGxUDtybUDp03oTu8HwiyD++bgiy7f6K
         OOtWNXVRg4EPWiTPezA2udQ1HTCLtSnKSD1u+hsQ=
Date:   Wed, 19 Feb 2020 21:30:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.21
Message-ID: <20200219203047.GA2883729@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.21 kernel.

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

 Makefile                                         |    2=20
 arch/arm/mach-npcm/Kconfig                       |    2=20
 arch/arm64/boot/dts/arm/fvp-base-revc.dts        |    8 -
 arch/arm64/kernel/process.c                      |    7 +
 arch/s390/boot/uv.c                              |    3=20
 arch/s390/include/asm/timex.h                    |    2=20
 arch/x86/events/amd/core.c                       |    1=20
 arch/x86/events/intel/ds.c                       |    2=20
 arch/x86/kvm/paging_tmpl.h                       |    2=20
 arch/x86/kvm/vmx/vmx.c                           |    3=20
 arch/x86/kvm/x86.c                               |    8 +
 drivers/acpi/acpica/achware.h                    |    2=20
 drivers/acpi/acpica/evxfgpe.c                    |   32 +++++++
 drivers/acpi/acpica/hwgpe.c                      |   71 ++++++++++++++++
 drivers/acpi/ec.c                                |   44 ++++++----
 drivers/acpi/sleep.c                             |   50 ++++++++---
 drivers/bus/moxtet.c                             |    2=20
 drivers/char/ipmi/ipmb_dev_int.c                 |    2=20
 drivers/edac/edac_mc.c                           |   12 --
 drivers/edac/edac_mc_sysfs.c                     |   18 ----
 drivers/gpio/gpio-xilinx.c                       |    5 -
 drivers/gpio/gpiolib-of.c                        |    4=20
 drivers/gpio/gpiolib.c                           |   11 ++
 drivers/gpu/drm/panfrost/panfrost_drv.c          |    1=20
 drivers/gpu/drm/panfrost/panfrost_gem.h          |    6 +
 drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c |    3=20
 drivers/gpu/drm/panfrost/panfrost_job.c          |    7 +
 drivers/gpu/drm/sun4i/sun4i_drv.c                |    1=20
 drivers/gpu/drm/vgem/vgem_drv.c                  |    9 +-
 drivers/hwmon/pmbus/ltc2978.c                    |    4=20
 drivers/infiniband/core/security.c               |   24 ++---
 drivers/infiniband/core/user_mad.c               |    5 -
 drivers/infiniband/core/uverbs_cmd.c             |   15 +--
 drivers/infiniband/hw/cxgb4/cm.c                 |    4=20
 drivers/infiniband/hw/cxgb4/qp.c                 |    4=20
 drivers/infiniband/hw/hfi1/affinity.c            |    2=20
 drivers/infiniband/hw/hfi1/file_ops.c            |   52 +++++++-----
 drivers/infiniband/hw/hfi1/hfi.h                 |    5 -
 drivers/infiniband/hw/hfi1/user_exp_rcv.c        |    5 -
 drivers/infiniband/hw/hfi1/user_sdma.c           |   17 ++-
 drivers/infiniband/hw/mlx5/qp.c                  |    9 +-
 drivers/infiniband/sw/rdmavt/qp.c                |   84 +++++++++++--------
 drivers/infiniband/sw/rxe/rxe_comp.c             |    8 -
 drivers/input/mouse/synaptics.c                  |    4=20
 drivers/mmc/core/host.c                          |   11 --
 drivers/mmc/core/slot-gpio.c                     |    3=20
 drivers/mmc/host/pxamci.c                        |    8 -
 drivers/mmc/host/sdhci-esdhc-imx.c               |    3=20
 drivers/nvme/host/core.c                         |    2=20
 drivers/s390/crypto/pkey_api.c                   |    2=20
 drivers/spmi/spmi-pmic-arb.c                     |    4=20
 fs/btrfs/disk-io.c                               |    1=20
 fs/btrfs/extent_map.c                            |   11 ++
 fs/btrfs/ref-verify.c                            |    5 +
 fs/btrfs/super.c                                 |    2=20
 fs/cifs/cifsfs.c                                 |    6 +
 fs/cifs/smb2ops.c                                |   35 +++++++-
 fs/ext4/block_validity.c                         |    1=20
 fs/ext4/dir.c                                    |   14 +--
 fs/ext4/ext4.h                                   |    5 -
 fs/ext4/inode.c                                  |   12 ++
 fs/ext4/mmp.c                                    |   12 +-
 fs/ext4/namei.c                                  |    7 +
 fs/ext4/super.c                                  |   55 +++++++-----
 fs/jbd2/commit.c                                 |   46 +++++-----
 fs/jbd2/transaction.c                            |   10 +-
 fs/nfs/nfs4proc.c                                |    2=20
 include/acpi/acpixf.h                            |    1=20
 include/linux/gpio/consumer.h                    |    7 +
 include/linux/suspend.h                          |    2=20
 kernel/power/suspend.c                           |    9 +-
 kernel/sched/core.c                              |    2=20
 net/mac80211/mlme.c                              |    8 -
 net/sunrpc/xprtrdma/frwr_ops.c                   |   13 +--
 sound/pci/hda/patch_realtek.c                    |    4=20
 sound/usb/clock.c                                |   99 +++++++++++++++---=
-----
 sound/usb/clock.h                                |    4=20
 sound/usb/format.c                               |    3=20
 sound/usb/mixer.c                                |   12 ++
 sound/usb/quirks.c                               |    1=20
 tools/perf/util/stat-shadow.c                    |    6 -
 81 files changed, 677 insertions(+), 313 deletions(-)

Alexander Tsoy (1):
      ALSA: usb-audio: Add clock validity quirk for Denon MC7000/MCX8000

Andreas Dilger (1):
      ext4: don't assume that mmp_nodename/bdevname have NUL

Arvind Sankar (1):
      ALSA: usb-audio: Apply sample rate quirk for Audioengine D1

Avihai Horon (1):
      RDMA/core: Fix invalid memory access in spec_filter_size

Benjamin Tissoires (1):
      Input: synaptics - remove the LEN0049 dmi id from topbuttonpad list

Boris Brezillon (1):
      drm/panfrost: Make sure the shrinker does not reclaim referenced BOs

Chengguang Xu (1):
      ext4: choose hardlimit when softlimit is larger than hardlimit in ext=
4_statfs_project()

Christian Borntraeger (1):
      s390/uv: Fix handling of length extensions

Chuck Lever (1):
      xprtrdma: Fix DMA scatter-gather list mapping imbalance

Colin Ian King (1):
      drivers: ipmi: fix off-by-one bounds check that leads to a out-of-bou=
nds write

Daniel Vetter (1):
      drm/vgem: Close use-after-free race in vgem_gem_create

David Sterba (2):
      btrfs: print message when tree-log replay starts
      btrfs: log message when rw remount is attempted with unclean tree-log

Filipe Manana (1):
      Btrfs: fix race between using extent maps and merging them

Gaurav Agrawal (1):
      Input: synaptics - enable SMBus on ThinkPad L470

Greg Kroah-Hartman (1):
      Linux 5.4.21

Harald Freudenberger (1):
      s390/pkey: fix missing length of protected key on return

Jan Kara (1):
      ext4: fix checksum errors with indexed dirs

Jernej Skrabec (1):
      Revert "drm/sun4i: drv: Allow framebuffer modifiers in mode config"

Kaike Wan (2):
      IB/hfi1: Acquire lock to release TID entries when user file is closed
      IB/rdmavt: Reset all QPs when the device is shut down

Kailang Yang (1):
      ALSA: hda/realtek - Add more codec supported Headset Button

Kamal Heib (1):
      RDMA/hfi1: Fix memory leak in _dev_comp_vect_mappings_create

Kan Liang (1):
      perf/x86/intel: Fix inaccurate period in context switch for auto-relo=
ad

Kim Phillips (2):
      perf/x86/amd: Add missing L2 misses event spec to AMD Family 17h's ev=
ent map
      perf stat: Don't report a null stalled cycles per insn metric

Krishnamraju Eraparaju (1):
      RDMA/iw_cxgb4: initiate CLOSE when entering TERM

Krzysztof Kozlowski (1):
      ARM: npcm: Bring back GPIOLIB support

Leon Romanovsky (1):
      RDMA/core: Fix protection fault in get_pkey_idx_qp_list

Lyude Paul (1):
      Input: synaptics - switch T470s to RMI4 by default

Marc Zyngier (1):
      arm64: dts: fast models: Fix FVP PCI interrupt-map property

Marek Beh=C3=BAn (1):
      bus: moxtet: fix potential stack buffer overflow

Mark Zhang (1):
      IB/mlx5: Return failure when rts2rts_qp_counters_set_id is not suppor=
ted

Micha=C5=82 Miros=C5=82aw (2):
      gpio: add gpiod_toggle_active_low()
      mmc: core: Rework wp-gpio handling

Mike Jones (1):
      hwmon: (pmbus/ltc2978) Fix PMBus polling of MFR_COMMON definitions.

Mike Marciniszyn (1):
      IB/hfi1: Close window for pq and request coliding

Nathan Chancellor (1):
      s390/time: Fix clk type in get_tod_clock

Olga Kornievskaia (1):
      NFSv4.1 make cachethis=3Dno for writes

Oliver Upton (1):
      KVM: x86: Mask off reserved bit from #DB exception payload

Paul Thomas (1):
      gpio: xilinx: Fix bug where the wrong GPIO register is written to

Petr Pavlu (1):
      cifs: fix mount option display for sec=3Dkrb5i

Qais Yousef (1):
      sched/uclamp: Reject negative values in cpu_uclamp_write()

Rafael J. Wysocki (4):
      ACPI: EC: Fix flushing of pending work
      ACPI: PM: s2idle: Avoid possible race related to the EC GPE
      ACPICA: Introduce acpi_any_gpe_status_set()
      ACPI: PM: s2idle: Prevent spurious SCIs from waking up the system

Robert Richter (2):
      EDAC/sysfs: Remove csrow objects on errors
      EDAC/mc: Fix use-after-free and memleaks during device removal

Ronnie Sahlberg (1):
      cifs: make sure we do not overflow the max EA buffer size

Sara Sharon (1):
      mac80211: fix quiet mode activation in action frames

Saurav Girepunje (1):
      ALSA: usb-audio: sound: usb: usb true/false for bool return type

Sean Christopherson (2):
      KVM: nVMX: Use correct root level for nested EPT shadow page tables
      KVM: x86/mmu: Fix struct guest_walker arrays for 5-level paging

Shijie Luo (1):
      ext4: add cond_resched() to ext4_protect_reserved_inode

Stephen Boyd (1):
      spmi: pmic-arb: Set lockdep class for hierarchical irq domains

Takashi Iwai (2):
      ALSA: usb-audio: Fix UAC2/3 effect unit parsing
      ALSA: hda/realtek - Fix silent output on MSI-GL73

Theodore Ts'o (2):
      ext4: fix support for inode sizes > 1024 bytes
      ext4: improve explanation of a mount failure caused by a misconfigure=
d kernel

Wenwen Wang (1):
      btrfs: ref-verify: fix memory leaks

Will Deacon (1):
      arm64: ssbs: Fix context-switch when SSBS is present on all CPUs

Yi Zhang (1):
      nvme: fix the parameter order for nvme_get_log in nvme_get_fw_slot_in=
fo

Yonatan Cohen (1):
      IB/umad: Fix kernel crash while unloading ib_umad

Zhu Yanjun (1):
      RDMA/rxe: Fix soft lockup problem due to using tasklets in softirq

zhangyi (F) (2):
      jbd2: move the clearing of b_modified flag to the journal_unmap_buffe=
r()
      jbd2: do not clear the BH_Mapped flag when forgetting a metadata buff=
er


--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5NmvYACgkQONu9yGCS
aT5Ykg/+MFBVzc7ZwIPZ7pZJIz4QOFLM2s1P0BGQv3F9ZLfpsavFOH+6aUjvb0l5
O/roDeRR2FuHh7DG5nsuNOqhatrvcqHFWBZSvPF4rqct651OZCW31o0UfDJ7N5Tr
jyDwawFVI+LafMocQ4xLXdnq806x3xB+5pMfEJuasYdgmf9y54E8vl5+JKeCrK1F
RWNUd+NKrhzw7O1Cb9DzYlJt5HU3e8NNUSnGQXtYnuUdfrxMIPLBP8XBjEcLkBNa
p6dAKF4lWO3/2eszXIczoY3WAND1KgzqgjZRKfcl0niXLPHGP/bJXWINUjCqYHUf
sE3R6PS1W7C677cN0DX7UF2F4BZnE7MAVxoq3IGiwZZa39bLuB0CVbE1L6GUt0Ko
3gH8AJLJhbjHRd2xYIduPy4bj0wBAbRPjtYKn4BdtiGoUm9AqEQ9NdpoDMdEb3CG
r5FE22WRkphdsWn+6MSzlUanhAU9uXkZanrixyMyYrzXCZmAitS8DrsW2/nNHfod
PobKr6zKGte7AeyPggV5vzRJ2lEQhXgalriIMAyhA832AUvv18vHegtmbtA0sYey
DCmjZXhSBaQWfkXWTSd6spQ6Qqn7LLkNnJvLelVZmJkTaC7O2R8zRbXvFTSm7ZT9
DBiDkc9f1eWR6mT9vgz8V+6sxpWjBoEjwS6+kH0ZambUynJ6J3Q=
=/Voh
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
