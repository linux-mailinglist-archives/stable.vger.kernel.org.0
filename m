Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76480164FE3
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 21:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgBSUbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 15:31:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgBSUbM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Feb 2020 15:31:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BC5C208C4;
        Wed, 19 Feb 2020 20:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582144271;
        bh=k4PUQnp6CSIAY/4KU/MVXPMzLc2GyzpnO+CA680AnOs=;
        h=Date:From:To:Cc:Subject:From;
        b=f4NVogddQU6S/bIhSfLniX15VLJSCTHaVVJ1EAYd4aUx1V+870+g03Kn47jmbjaT1
         cuKVfdZcV4OS5ICD4GIjPEiuykDKY3aJdgvEtBgxrXqvSk4HGeJ8mWKjAkl0upP7DE
         Pgnyt32jcyjr6kFaaZ2DWdysVFBichLfqMX1Qq0o=
Date:   Wed, 19 Feb 2020 21:31:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.5.5
Message-ID: <20200219203109.GA2883850@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.5.5 kernel.

All users of the 5.5 kernel series must upgrade.

The updated 5.5.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.5.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                              |    2=20
 arch/arm/mach-npcm/Kconfig                            |    2=20
 arch/arm64/boot/dts/arm/fvp-base-revc.dts             |    8 -
 arch/arm64/kernel/process.c                           |    7 +
 arch/s390/boot/uv.c                                   |    3=20
 arch/s390/include/asm/timex.h                         |    2=20
 arch/x86/events/amd/core.c                            |    1=20
 arch/x86/events/intel/ds.c                            |    2=20
 arch/x86/kvm/mmu/paging_tmpl.h                        |    2=20
 arch/x86/kvm/vmx/nested.c                             |   28 +++++
 arch/x86/kvm/vmx/vmx.c                                |    3=20
 arch/x86/kvm/x86.c                                    |    8 +
 drivers/acpi/acpica/achware.h                         |    2=20
 drivers/acpi/acpica/evxfgpe.c                         |   32 ++++++
 drivers/acpi/acpica/hwgpe.c                           |   71 ++++++++++++++
 drivers/acpi/ec.c                                     |   44 +++++---
 drivers/acpi/sleep.c                                  |   50 +++++++--
 drivers/bus/moxtet.c                                  |    2=20
 drivers/char/ipmi/ipmb_dev_int.c                      |    2=20
 drivers/edac/edac_mc.c                                |   12 --
 drivers/edac/edac_mc_sysfs.c                          |   18 ---
 drivers/gpio/gpio-xilinx.c                            |    5=20
 drivers/gpio/gpiolib-of.c                             |    4=20
 drivers/gpio/gpiolib.c                                |   11 ++
 drivers/gpu/drm/amd/powerplay/inc/smu_v11_0_pptable.h |   46 ++++++---
 drivers/gpu/drm/amd/powerplay/navi10_ppt.c            |   22 ++--
 drivers/gpu/drm/drm_dp_mst_topology.c                 |    3=20
 drivers/gpu/drm/i915/i915_pmu.c                       |   12 ++
 drivers/gpu/drm/panfrost/panfrost_drv.c               |    1=20
 drivers/gpu/drm/panfrost/panfrost_gem.h               |    6 +
 drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c      |    3=20
 drivers/gpu/drm/panfrost/panfrost_job.c               |    7 +
 drivers/gpu/drm/sun4i/sun4i_drv.c                     |    1=20
 drivers/gpu/drm/vgem/vgem_drv.c                       |    9 +
 drivers/hwmon/pmbus/ltc2978.c                         |    4=20
 drivers/infiniband/core/security.c                    |   24 +---
 drivers/infiniband/core/user_mad.c                    |    5=20
 drivers/infiniband/core/uverbs_cmd.c                  |   15 +-
 drivers/infiniband/hw/cxgb4/cm.c                      |    4=20
 drivers/infiniband/hw/cxgb4/qp.c                      |    4=20
 drivers/infiniband/hw/hfi1/affinity.c                 |    2=20
 drivers/infiniband/hw/hfi1/file_ops.c                 |   52 ++++++----
 drivers/infiniband/hw/hfi1/hfi.h                      |    5=20
 drivers/infiniband/hw/hfi1/user_exp_rcv.c             |    5=20
 drivers/infiniband/hw/hfi1/user_sdma.c                |   17 ++-
 drivers/infiniband/hw/mlx5/qp.c                       |    9 +
 drivers/infiniband/sw/rdmavt/qp.c                     |   84 ++++++++++---=
---
 drivers/infiniband/sw/rxe/rxe_comp.c                  |    8 -
 drivers/input/mouse/synaptics.c                       |    4=20
 drivers/input/touchscreen/ili210x.c                   |    2=20
 drivers/mmc/core/host.c                               |   11 --
 drivers/mmc/core/slot-gpio.c                          |    3=20
 drivers/mmc/host/pxamci.c                             |    8 -
 drivers/mmc/host/sdhci-esdhc-imx.c                    |    3=20
 drivers/nvme/host/core.c                              |    2=20
 drivers/s390/crypto/pkey_api.c                        |    2=20
 drivers/spmi/spmi-pmic-arb.c                          |    4=20
 fs/btrfs/disk-io.c                                    |    1=20
 fs/btrfs/extent_map.c                                 |   11 ++
 fs/btrfs/ref-verify.c                                 |    5=20
 fs/btrfs/super.c                                      |    2=20
 fs/ceph/super.c                                       |    8 -
 fs/cifs/cifsfs.c                                      |    6 -
 fs/cifs/smb2ops.c                                     |   35 ++++++
 fs/ext4/block_validity.c                              |    1=20
 fs/ext4/dir.c                                         |   14 +-
 fs/ext4/ext4.h                                        |    5=20
 fs/ext4/inode.c                                       |   12 ++
 fs/ext4/mmp.c                                         |   12 +-
 fs/ext4/namei.c                                       |    7 +
 fs/ext4/super.c                                       |   55 ++++++----
 fs/io-wq.c                                            |    8 +
 fs/io-wq.h                                            |    4=20
 fs/io_uring.c                                         |   53 +++-------
 fs/jbd2/commit.c                                      |   46 ++++-----
 fs/jbd2/transaction.c                                 |   10 +
 fs/nfs/delegation.c                                   |   47 ++++++---
 fs/nfs/nfs4proc.c                                     |    2=20
 include/acpi/acpixf.h                                 |    1=20
 include/linux/gpio/consumer.h                         |    7 +
 include/linux/suspend.h                               |    2=20
 include/net/mac80211.h                                |   11 --
 kernel/cgroup/cgroup.c                                |   13 +-
 kernel/power/suspend.c                                |    9 -
 kernel/sched/core.c                                   |    2=20
 net/mac80211/cfg.c                                    |    2=20
 net/mac80211/mlme.c                                   |    8 -
 net/mac80211/tx.c                                     |    2=20
 net/sunrpc/xprtrdma/frwr_ops.c                        |   13 +-
 sound/core/pcm_native.c                               |    3=20
 sound/pci/hda/patch_realtek.c                         |    4=20
 sound/usb/clock.c                                     |   91 ++++++++++++-=
-----
 sound/usb/clock.h                                     |    4=20
 sound/usb/format.c                                    |    3=20
 sound/usb/mixer.c                                     |   12 +-
 sound/usb/quirks.c                                    |    1=20
 tools/perf/util/stat-shadow.c                         |    6 -
 97 files changed, 841 insertions(+), 405 deletions(-)

Alex Deucher (2):
      drm/amdgpu: update smu_v11_0_pptable.h
      drm/amdgpu:/navi10: use the ODCAP enum to index the caps array

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

Chris Wilson (1):
      drm/i915/pmu: Correct the rc6 offset upon enabling

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
      Linux 5.5.5

Harald Freudenberger (1):
      s390/pkey: fix missing length of protected key on return

Jan Kara (1):
      ext4: fix checksum errors with indexed dirs

Jens Axboe (2):
      io_uring: retry raw bdev writes if we hit -EOPNOTSUPP
      io-wq: add support for inheriting ->fs

Jernej Skrabec (1):
      Revert "drm/sun4i: drv: Allow framebuffer modifiers in mode config"

Johannes Berg (1):
      mac80211: use more bits for ack_frame_id

Jos=C3=A9 Roberto de Souza (1):
      drm/mst: Fix possible NULL pointer dereference in drm_dp_mst_process_=
up_req()

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

Luca Weiss (1):
      Input: ili210x - fix return value of is_visible function

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

Oliver Upton (2):
      KVM: x86: Mask off reserved bit from #DB exception payload
      KVM: nVMX: Handle pending #DB when injecting INIT VM-exit

Paul Thomas (1):
      gpio: xilinx: Fix bug where the wrong GPIO register is written to

Pavel Begunkov (1):
      io_uring: fix deferred req iovec leak

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

Sean Christopherson (2):
      KVM: nVMX: Use correct root level for nested EPT shadow page tables
      KVM: x86/mmu: Fix struct guest_walker arrays for 5-level paging

Shijie Luo (1):
      ext4: add cond_resched() to ext4_protect_reserved_inode

Stephen Boyd (1):
      spmi: pmic-arb: Set lockdep class for hierarchical irq domains

Takashi Iwai (3):
      ALSA: usb-audio: Fix UAC2/3 effect unit parsing
      ALSA: pcm: Fix double hw_free calls
      ALSA: hda/realtek - Fix silent output on MSI-GL73

Tejun Heo (1):
      cgroup: init_tasks shouldn't be linked to the root cgroup

Theodore Ts'o (2):
      ext4: fix support for inode sizes > 1024 bytes
      ext4: improve explanation of a mount failure caused by a misconfigure=
d kernel

Trond Myklebust (2):
      NFSv4: Ensure the delegation cred is pinned when we call delegreturn
      NFSv4: Add accounting for the number of active delegations held

Wenwen Wang (1):
      btrfs: ref-verify: fix memory leaks

Will Deacon (1):
      arm64: ssbs: Fix context-switch when SSBS is present on all CPUs

Xiubo Li (1):
      ceph: noacl mount option is effectively ignored

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


--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5Nmw0ACgkQONu9yGCS
aT6UxBAArNy28oNF27QYCNf7qMs8rB1hSKK4uOxMtCCEWzOP9LkEIYNJj4gMhBhR
ieT5rnn40si0y0yEoutypobzsXoLi3SVrAP2TQN1gI8myGxIbdbg5dFAzQcloXb8
c2v4gwDkUQeiCm0tuxXfC596A29gHU2UUyLciG2X0I4pk1Gpx1k/cXzQMyW3l/0e
+P/jMz818Dl42F4+6jvcsJD3XwKZR/u2fvy+W0/+/Qny2yvAqC67vwPyZU0a3ju7
WRsnDtG5fuRtI2S0jM2P5FbFUfyWJaeBc9C4DpvhrIz/FJYdlmSDTA+9lMEmCIwQ
QpDYZupKcJPr0RT3884K6sj8ufDQo2I6Y2c6yBUqKCL2auYnGB8Oiu+qWqs9xmnX
VSvber1u0EKHj68ovUc2P2qyftIxfKo+KWd2TCZ1VCOS0UNBItw2524IKilegCDK
/oJJ3ZOhZ7Qf8BFjI5Ri8SK/B6ISEmA5pQOFAikbtWbZG0fCCLrPEd9Dw7POo8/c
xJ46eud2s/kG09rgIX0rEc3gAaqlFbysSIm7i9TRLXuVP1AeqRClJKl33zMptLz6
F0t4EcvIF5HkBjkD9uXK3AIkTo/ULTrTT5NQ5h/PRWrLZurgmw3ZjveF3qD9DBZA
tueVK3eOeCxN5fRlhYcHUNlXmi2yvrNvPShEV94k2r36qlp6YoU=
=C+9e
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
