Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEAA1B706B
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 11:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgDXJPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 05:15:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgDXJPA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 05:15:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4F0D20724;
        Fri, 24 Apr 2020 09:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587719699;
        bh=3H3GWdPtDDkaE8Dh9Hi1DtQkbbiKkpECDG7Do//mob4=;
        h=Date:From:To:Cc:Subject:From;
        b=fX1/YVcFqcS6SuJSqFimu/N/FNteni76dqsW4yQ9l9xsB7gzwt+X06NIQiRCsCeEA
         ByNQVrYptfD1BmVDXPFcFo5fBIgrU4RuXB+UXE2wRJvXdJPgWUQo88gYNzBxLO3o0l
         iDbGRHSxZKj1SjtiJXd6fBicDxupv03J2OXcS24k=
Date:   Fri, 24 Apr 2020 11:14:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.118
Message-ID: <20200424091457.GA359802@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.118 kernel.

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

 Makefile                                 |    2=20
 arch/arm/boot/dts/imx6qdl.dtsi           |    5 --
 arch/arm/boot/dts/imx6qp.dtsi            |    1=20
 arch/arm/net/bpf_jit_32.c                |   52 ++++++++++++++--------
 arch/powerpc/platforms/maple/setup.c     |   34 +++++++-------
 arch/s390/kernel/perf_cpum_sf.c          |    1=20
 arch/s390/kernel/processor.c             |    5 +-
 arch/s390/mm/gmap.c                      |    1=20
 arch/um/drivers/ubd_kern.c               |    4 +
 arch/x86/hyperv/hv_init.c                |    6 ++
 arch/x86/include/asm/mshyperv.h          |    2=20
 arch/x86/kernel/acpi/cstate.c            |    3 -
 arch/x86/kernel/cpu/mshyperv.c           |   10 ++++
 drivers/acpi/processor_throttling.c      |    7 --
 drivers/block/rbd.c                      |   25 +++++++---
 drivers/clk/at91/clk-usb.c               |    3 +
 drivers/clk/tegra/clk-tegra-pmc.c        |   12 ++---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c  |    4 -
 drivers/gpu/drm/vc4/vc4_hdmi.c           |   20 ++++++--
 drivers/hv/channel_mgmt.c                |    3 +
 drivers/hv/vmbus_drv.c                   |   60 ++++++++++++++++++-------
 drivers/iio/light/si1133.c               |   37 ++++++++++-----
 drivers/iommu/amd_iommu_types.h          |    2=20
 drivers/iommu/intel-svm.c                |    7 +-
 drivers/irqchip/irq-mbigen.c             |    8 ++-
 drivers/mtd/devices/phram.c              |   15 +++---
 drivers/mtd/lpddr/lpddr_cmds.c           |    1=20
 drivers/mtd/nand/spi/core.c              |    1=20
 drivers/net/dsa/bcm_sf2_cfp.c            |    9 +--
 drivers/nvdimm/bus.c                     |    6 +-
 drivers/of/overlay.c                     |    2=20
 drivers/of/unittest.c                    |   16 +++++-
 drivers/power/supply/axp288_fuel_gauge.c |    4 -
 drivers/power/supply/bq27xxx_battery.c   |    5 +-
 drivers/rtc/rtc-88pm860x.c               |   14 +++--
 drivers/scsi/sg.c                        |    4 +
 drivers/soc/imx/gpc.c                    |   24 +++++-----
 drivers/tty/ehv_bytechan.c               |   21 +++++++-
 drivers/video/fbdev/core/fbmem.c         |    2=20
 drivers/video/fbdev/sis/init301.c        |    4 -
 drivers/watchdog/sp805_wdt.c             |    4 +
 fs/buffer.c                              |   11 ++++
 fs/cifs/transport.c                      |   28 +++++++----
 fs/ext2/xattr.c                          |    8 +--
 fs/ext4/inode.c                          |    2=20
 fs/ext4/super.c                          |    5 +-
 fs/f2fs/node.c                           |    7 +-
 fs/f2fs/super.c                          |    5 +-
 fs/nfs/callback_proc.c                   |    2=20
 fs/nfs/direct.c                          |    2=20
 fs/nfs/pagelist.c                        |   17 +++----
 include/acpi/processor.h                 |    8 +++
 include/keys/big_key-type.h              |    2=20
 include/keys/user-type.h                 |    3 -
 include/linux/buffer_head.h              |    8 +++
 include/linux/compiler.h                 |    2=20
 include/linux/key-type.h                 |    2=20
 include/linux/percpu_counter.h           |    4 -
 include/linux/swapops.h                  |    3 -
 kernel/bpf/verifier.c                    |   45 ++++++++++++++-----
 kernel/locking/locktorture.c             |    8 +--
 lib/raid6/neon.uc                        |    5 --
 lib/raid6/recov_neon_inner.c             |    7 --
 net/dns_resolver/dns_key.c               |    2=20
 net/netfilter/nf_tables_api.c            |    4 -
 net/rxrpc/key.c                          |   27 +++--------
 net/xdp/xdp_umem.c                       |    5 --
 security/keys/big_key.c                  |   11 +---
 security/keys/encrypted-keys/encrypted.c |    7 +-
 security/keys/keyctl.c                   |   73 ++++++++++++++++++++++++--=
-----
 security/keys/keyring.c                  |    6 --
 security/keys/request_key_auth.c         |    7 +-
 security/keys/trusted.c                  |   14 -----
 security/keys/user_defined.c             |    5 --
 sound/pci/hda/hda_intel.c                |   19 ++------
 tools/objtool/check.c                    |    5 --
 76 files changed, 507 insertions(+), 308 deletions(-)

Adrian Huang (1):
      iommu/amd: Fix the configuration of GCR3 table root pointer

Alexander Gordeev (1):
      s390/cpuinfo: fix wrong output when CPU0 is offline

Alexandre Belloni (1):
      rtc: 88pm860x: fix possible race condition

Chao Yu (2):
      f2fs: fix NULL pointer dereference in f2fs_write_begin()
      f2fs: fix to wait all node page writeback

Claudiu Beznea (1):
      clk: at91: usb: continue if clk_hw_round_rate() return zero

Dan Carpenter (3):
      libnvdimm: Out of bounds read in __nd_ioctl()
      fbdev: potential information leak in do_fb_ioctl()
      mtd: lpddr: Fix a double free in probe()

Daniel Borkmann (1):
      bpf: fix buggy r0 retval refinement for tracing helpers

David Hildenbrand (1):
      KVM: s390: vsie: Fix possible race when shadowing region 3 tables

Dmitry Osipenko (1):
      power: supply: bq27xxx_battery: Silence deferred-probe error

Eric Sandeen (1):
      ext4: do not commit super on read-only bdev

Florian Fainelli (1):
      net: dsa: bcm_sf2: Fix overflow checks

Frank Rowand (4):
      of: unittest: kmemleak on changeset destroy
      of: unittest: kmemleak in of_unittest_platform_populate()
      of: unittest: kmemleak in of_unittest_overlay_high_level()
      of: overlay: kmemleak in dup_and_fixup_symbol_prop()

Frieder Schrempf (1):
      mtd: spinand: Explicitly use MTD_OPS_RAW to write the bad block marke=
r to OOB

Gabriel Krisman Bertazi (1):
      um: ubd: Prevent buffer overrun on command completion

Greg Kroah-Hartman (1):
      Linux 4.19.118

Ilya Dryomov (2):
      rbd: avoid a deadlock on header_rwsem when flushing notifies
      rbd: call rbd_dev_unprobe() after unwatching and flushing notifies

Jack Zhang (1):
      drm/amdkfd: kfree the wrong pointer

Jacob Pan (1):
      iommu/vt-d: Fix mm reference leak

Jan Kara (1):
      ext2: fix debug reference to ext2_xattr_cache

Jeffery Miller (1):
      power: supply: axp288_fuel_gauge: Broaden vendor check for Intel Comp=
ute Sticks.

Josh Poimboeuf (1):
      objtool: Fix switch table detection in .text.unlikely

Li Bin (1):
      scsi: sg: add sg_remove_request in sg_common_write

Long Li (1):
      cifs: Allocate encryption header through kmalloc

Lucas Stach (1):
      soc: imx: gpc: fix power up sequencing

Luke Nelson (2):
      arm, bpf: Fix offset overflow for BPF_MEM BPF_DW
      arm, bpf: Fix bugs with ALU64 {RSH, ARSH} BPF_K shift by 0

Magnus Karlsson (1):
      xsk: Add missing check on user supplied headroom size

Martin Fuzzey (1):
      ARM: dts: imx6: Use gpc for FEC interrupt controller to fix wake on L=
AN.

Maxime Roussin-B=E9langer (1):
      iio: si1133: read 24-bit signed integer for measurement

Michael Walle (1):
      watchdog: sp805: fix restart handler

Misono Tomohiro (1):
      NFS: direct.c: Fix memory leak of dreq when nfs_get_lock_context fails

Nathan Chancellor (2):
      video: fbdev: sis: Remove unnecessary parentheses and commented code
      powerpc/maple: Fix declaration made after definition

Nicolas Saenz Julienne (1):
      drm/vc4: Fix HDMI mode validation

Pablo Neira Ayuso (1):
      netfilter: nf_tables: report EOPNOTSUPP on unsupported flags/object t=
ype

Paul E. McKenney (1):
      locktorture: Print ratio of acquisitions, not failures

Qian Cai (2):
      percpu_counter: fix a data race at vm_committed_as
      x86: ACPI: fix CPU hotplug deadlock

Randy Dunlap (1):
      ext2: fix empty body warnings when -Wextra is used

Roman Gushchin (1):
      ext4: use non-movable memory for superblock readahead

Sowjanya Komatineni (1):
      clk: tegra: Fix Tegra PMC clock out parents

Stephen Rothwell (1):
      tty: evh_bytechan: Fix out of bounds accesses

Steven Price (1):
      include/linux/swapops.h: correct guards for non_swap_entry()

Takashi Iwai (1):
      ALSA: hda: Don't release card at firmware loading error

Thomas Richter (1):
      s390/cpum_sf: Fix wrong page count in error message

Tianyu Lan (6):
      x86/Hyper-V: Report crash register data or kmsg before running crash =
kernel
      x86/Hyper-V: Unload vmbus channel in hv panic callback
      x86/Hyper-V: Free hv_panic_page when fail to register kmsg dump
      x86/Hyper-V: Trigger crash enlightenment only once during system cras=
h.
      x86/Hyper-V: Report crash register data when sysctl_record_panic_msg =
is not set
      x86/Hyper-V: Report crash data in die() when panic_on_oops is set

Trond Myklebust (2):
      NFSv4/pnfs: Return valid stateids in nfs_layout_find_inode_by_stateid=
()
      NFS: Fix memory leaks in nfs_pageio_stop_mirroring()

Vegard Nossum (1):
      compiler.h: fix error in BUILD_BUG_ON() reporting

Waiman Long (1):
      KEYS: Don't write out to userspace while holding key semaphore

Wen Yang (1):
      mtd: phram: fix a double free issue in error path

Zenghui Yu (1):
      irqchip/mbigen: Free msi_desc on device teardown

ndesaulniers@google.com (1):
      lib/raid6: use vdupq_n_u8 to avoid endianness warnings


--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6irhAACgkQONu9yGCS
aT5g0BAAhaMo078zxaSDRc/goLmzGxiNicbyTbZyf5SPX2ePw6nUjmSNbUEDOhlD
cFoc3S9nlMEWoTwCnymfpDwFuNLL6k7XQdrAONfzzzzbFI/aOkRQB1h57QUu/laG
kBw4e/BBU3hFV+0ZD8bjy2t/eJdwIP/MbOjzJi4fzbT7+eqNwXDLsXIEvwC+iw8u
h7Bf0qahHzIOgdfdloTAJGBjxH88W/mS9oNKjsI3tpjq1RViyO+nc6FiLoGQnD1F
wmTEcUOdtyUd1D8Oi7Q/PgFmqYDgVexq1IGDrqw69ePODcQ1KNSOVmGBz2uHJOzR
18Dn6N3UZSBnFucLPhu+r+5/ijmbgRlVjDyPB/E8bf4YRRzz1I0RDXomekSJAo3X
BrH2K/M6Dj2dKiCto3Awh9SewOVEezt6yD+wYCOUT8PEicUxykVxsVL8DudVIypJ
aTvi/+1P/xWzL8e0ILkXeMT2rteGx2O3Fpr+6Yr5o/um/Dk9sqZT4o6xCARsmVtr
/QrCOIDfqKM9ZFRANMrwR5/qw2x0VwdZaGdwjf/z+qjWFm5a2UUWAy15JSZzt9Yw
K4QurXv7C8/puaM5jBfmRJsWUv8xHKnSGzyKnM+qko7dfsBn0I+puwcG7AXs0LNk
3e2EOKUCPKnBKmEw4NifrCA6OF151aGSEjCCram757t9FiLvsfU=
=R80E
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
