Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6CDB164FDA
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 21:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgBSUa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 15:30:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbgBSUa0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Feb 2020 15:30:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F85E208C4;
        Wed, 19 Feb 2020 20:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582144224;
        bh=LH025Khs3m5Cl4tvE1JGGQgH7DR9Zq2kwSXb/EH9clI=;
        h=Date:From:To:Cc:Subject:From;
        b=CbZyY3iXr1kC26sTgWTHnQgVKk+zmuTTiQ9kO3GJA3JR7oCfR6XwMuDHk5TPMGIqq
         laISIS8qIo3Zlt/qcmdpJMSYGDGNd1zplHJfFRgZ4cqSBS8uStNhDsjBcbHvh7mDYJ
         11ONlMDHDks86Wltn9WCL1KmOaFt+LqFwGLP82cg=
Date:   Wed, 19 Feb 2020 21:30:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.105
Message-ID: <20200219203022.GA2883622@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.105 kernel.

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

 Makefile                                  |    2=20
 arch/arm/mach-npcm/Kconfig                |    2=20
 arch/arm64/kernel/cpufeature.c            |   52 +++++++++++++--
 arch/arm64/kernel/fpsimd.c                |   20 +++++-
 arch/arm64/kernel/process.c               |    7 ++
 arch/arm64/kvm/hyp/switch.c               |   10 ++-
 arch/s390/include/asm/timex.h             |    2=20
 arch/x86/events/amd/core.c                |    1=20
 arch/x86/events/intel/ds.c                |    2=20
 arch/x86/kvm/paging_tmpl.h                |    2=20
 arch/x86/kvm/vmx/vmx.c                    |    3=20
 drivers/hwmon/pmbus/ltc2978.c             |    4 -
 drivers/infiniband/core/security.c        |   24 ++-----
 drivers/infiniband/core/uverbs_cmd.c      |   15 ++--
 drivers/infiniband/hw/hfi1/affinity.c     |    2=20
 drivers/infiniband/hw/hfi1/file_ops.c     |   52 +++++++++------
 drivers/infiniband/hw/hfi1/hfi.h          |    5 +
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |    5 -
 drivers/infiniband/hw/hfi1/user_sdma.c    |   17 +++--
 drivers/infiniband/sw/rdmavt/qp.c         |   84 +++++++++++++++----------
 drivers/infiniband/sw/rxe/rxe_comp.c      |    8 +-
 drivers/input/mouse/synaptics.c           |    4 -
 drivers/nvme/host/core.c                  |    2=20
 fs/btrfs/disk-io.c                        |    1=20
 fs/btrfs/extent_map.c                     |   11 +++
 fs/btrfs/ref-verify.c                     |    5 +
 fs/btrfs/super.c                          |    2=20
 fs/ext4/block_validity.c                  |    1=20
 fs/ext4/dir.c                             |   14 ++--
 fs/ext4/ext4.h                            |    5 +
 fs/ext4/inode.c                           |   12 +++
 fs/ext4/mmp.c                             |   12 ++-
 fs/ext4/namei.c                           |    7 ++
 fs/ext4/super.c                           |   32 ++++-----
 fs/jbd2/commit.c                          |   46 +++++++------
 fs/jbd2/transaction.c                     |   10 +--
 fs/nfs/nfs4proc.c                         |    2=20
 sound/pci/hda/patch_realtek.c             |    1=20
 sound/usb/clock.c                         |   99 ++++++++++++++++++++-----=
-----
 sound/usb/clock.h                         |    4 -
 sound/usb/format.c                        |    3=20
 sound/usb/mixer.c                         |   12 +++
 sound/usb/quirks.c                        |    1=20
 43 files changed, 404 insertions(+), 201 deletions(-)

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

David Sterba (2):
      btrfs: print message when tree-log replay starts
      btrfs: log message when rw remount is attempted with unclean tree-log

Filipe Manana (1):
      Btrfs: fix race between using extent maps and merging them

Gaurav Agrawal (1):
      Input: synaptics - enable SMBus on ThinkPad L470

Greg Kroah-Hartman (1):
      Linux 4.19.105

Jan Kara (1):
      ext4: fix checksum errors with indexed dirs

Kaike Wan (2):
      IB/hfi1: Acquire lock to release TID entries when user file is closed
      IB/rdmavt: Reset all QPs when the device is shut down

Kamal Heib (1):
      RDMA/hfi1: Fix memory leak in _dev_comp_vect_mappings_create

Kan Liang (1):
      perf/x86/intel: Fix inaccurate period in context switch for auto-relo=
ad

Kim Phillips (1):
      perf/x86/amd: Add missing L2 misses event spec to AMD Family 17h's ev=
ent map

Krzysztof Kozlowski (1):
      ARM: npcm: Bring back GPIOLIB support

Leon Romanovsky (1):
      RDMA/core: Fix protection fault in get_pkey_idx_qp_list

Lyude Paul (1):
      Input: synaptics - switch T470s to RMI4 by default

Mike Jones (1):
      hwmon: (pmbus/ltc2978) Fix PMBus polling of MFR_COMMON definitions.

Mike Marciniszyn (1):
      IB/hfi1: Close window for pq and request coliding

Nathan Chancellor (1):
      s390/time: Fix clk type in get_tod_clock

Olga Kornievskaia (1):
      NFSv4.1 make cachethis=3Dno for writes

Saurav Girepunje (1):
      ALSA: usb-audio: sound: usb: usb true/false for bool return type

Sean Christopherson (2):
      KVM: nVMX: Use correct root level for nested EPT shadow page tables
      KVM: x86/mmu: Fix struct guest_walker arrays for 5-level paging

Shijie Luo (1):
      ext4: add cond_resched() to ext4_protect_reserved_inode

Suzuki K Poulose (2):
      arm64: cpufeature: Set the FP/SIMD compat HWCAP bits properly
      arm64: nofpsmid: Handle TIF_FOREIGN_FPSTATE flag cleanly

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

Zhu Yanjun (1):
      RDMA/rxe: Fix soft lockup problem due to using tasklets in softirq

zhangyi (F) (2):
      jbd2: move the clearing of b_modified flag to the journal_unmap_buffe=
r()
      jbd2: do not clear the BH_Mapped flag when forgetting a metadata buff=
er


--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5NmtsACgkQONu9yGCS
aT7RIA/+PveWJnSi5UE3ZxcAGCqSeO2gequ9QQ32FRmz5vHVakSEqYOcEXPVojiJ
nePnre675qEgyUK5yLYeGKt4KUHSCYnX6/jXVGDtSigJBPu/LXB32VnVXOO8SHlW
QHTCSt/wD+Vj+6kdS605ZEUv86INDt1PFyxP6O4IgonVIPz7zR3jHkO2WjnJ8hUa
w8Ti1d/Ki3tK1TuWiWfa1qtILSl15hsVxh1sMEiJ9XlleodgAmvoDB6IWyHcSX/M
Zk/v8IDClY5sJltJovxghm6VHw2V3iM4zrtVWN+wrg6NvnLJN2m77x+mzUrr1+8i
dJd+ypgd2GAvDjF2s1Hiq2fUxsW2sktxri0YsPV1UZDI9AKLKeOt2xx9fDIgXwqj
RyWUiHys/pblrVvpeLEstDES1xVK+yh3Wqh+vZJOw4U57Bms+djg5AD4xrgBDWmb
lKausHMvE9HGokJmrM/Y7fzt/4KWxKcHndnvKUgOApVE2XbMi2TGUvHiQqY1Ep0u
GdOs4QITqcxjgUDN3axp+H+vkpZKdeRBRldAaC8APDZVI9jsInsmmS4gO4SMGQFb
mRvu2hcV+JnBS8uAJ+4NjuPWKpAubg0UvC1YtfBHkxNX89q6+cHTj3tzOXWg7Z7i
B8mMq3PgK0U+Au2F1nvGQXmF7S+DxFDzKTBuEsh+upXe9mDtlg4=
=+R7n
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
