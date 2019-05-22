Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706E625E1C
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 08:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbfEVGdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 02:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbfEVGdF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 02:33:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0164920863;
        Wed, 22 May 2019 06:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558506784;
        bh=wgKVZIQZh8Id9vt7Mz6Eiq6eO62ihitVU5FuMVmwOS8=;
        h=Date:From:To:Cc:Subject:From;
        b=DqPN4Mn+EQmMFuJWHX4bFzK3A9UXDMPuLcEORw/EUwUJQy+nii9SKbC1/t54QrJR3
         mboSL/pW19nqYY5uUGDHtfD5ROV9HDpw5QW/WD9hDGbbT3tLV/0kzXHhTPh3O1F1+F
         +7d/M7vg1HLVjVAs5iE+Qvssd/YnIszoItUGzkAc=
Date:   Wed, 22 May 2019 08:33:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.121
Message-ID: <20190522063302.GA20625@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.121 kernel.

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

 Documentation/x86/mds.rst                          |   44 ++-------------
 Makefile                                           |    2=20
 arch/arm/boot/dts/exynos5260.dtsi                  |    2=20
 arch/arm/boot/dts/exynos5422-odroidxu3-audio.dtsi  |    2=20
 arch/arm/crypto/aes-neonbs-glue.c                  |    2=20
 arch/arm/mach-exynos/firmware.c                    |    1=20
 arch/arm/mach-exynos/suspend.c                     |    2=20
 arch/arm64/crypto/aes-neonbs-glue.c                |    2=20
 arch/arm64/include/asm/processor.h                 |    8 ++
 arch/arm64/kernel/debug-monitors.c                 |    1=20
 arch/arm64/mm/proc.S                               |   34 ++++++-----
 arch/arm64/net/bpf_jit.h                           |    6 --
 arch/arm64/net/bpf_jit_comp.c                      |    1=20
 arch/x86/crypto/crct10dif-pclmul_glue.c            |   13 +---
 arch/x86/entry/entry_32.S                          |    2=20
 arch/x86/entry/entry_64.S                          |    2=20
 arch/x86/include/asm/switch_to.h                   |    1=20
 arch/x86/kernel/process_32.c                       |    7 ++
 arch/x86/kernel/process_64.c                       |    8 ++
 arch/x86/kernel/traps.c                            |    8 --
 arch/x86/kvm/x86.c                                 |   37 ++++++++----
 crypto/ccm.c                                       |   44 ++++++---------
 crypto/chacha20poly1305.c                          |    4 -
 crypto/crct10dif_generic.c                         |   11 +--
 crypto/gcm.c                                       |   34 +++--------
 crypto/salsa20_generic.c                           |    2=20
 crypto/skcipher.c                                  |    9 ++-
 drivers/char/ipmi/ipmi_ssif.c                      |    6 +-
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |   25 ++++++--
 drivers/crypto/vmx/aesp8-ppc.pl                    |    4 -
 drivers/md/bcache/journal.c                        |   11 ++-
 drivers/md/bcache/super.c                          |    2=20
 drivers/mtd/spi-nor/intel-spi.c                    |    8 ++
 drivers/pci/host/pci-hyperv.c                      |   21 +++++++
 drivers/power/supply/axp288_charger.c              |    4 +
 drivers/tty/vt/keyboard.c                          |   33 +++++++++--
 drivers/tty/vt/vt.c                                |    2=20
 fs/btrfs/backref.c                                 |   34 +++++++----
 fs/ext4/extents.c                                  |   17 +++++
 fs/ext4/file.c                                     |    7 ++
 fs/ext4/inode.c                                    |    2=20
 fs/ext4/ioctl.c                                    |    2=20
 fs/ext4/mballoc.c                                  |    2=20
 fs/ext4/namei.c                                    |    5 +
 fs/ext4/resize.c                                   |    1=20
 fs/ext4/super.c                                    |   60 ++++++++++++----=
-----
 fs/ext4/xattr.c                                    |    2=20
 fs/fs-writeback.c                                  |   11 ++-
 fs/jbd2/journal.c                                  |    4 +
 fs/ocfs2/export.c                                  |   30 ++++++++++
 include/linux/list.h                               |   30 ++++++++++
 include/linux/mfd/da9063/registers.h               |    6 +-
 include/linux/mfd/max77620.h                       |    4 -
 kernel/fork.c                                      |   31 ++++++++++
 kernel/locking/rwsem-xadd.c                        |   44 ++++++++++-----
 lib/iov_iter.c                                     |   17 +++++
 mm/mincore.c                                       |   23 +++++++-
 net/core/fib_rules.c                               |    1=20
 sound/pci/hda/patch_hdmi.c                         |   11 +++
 sound/pci/hda/patch_realtek.c                      |    5 -
 sound/soc/codecs/max98090.c                        |   12 ++--
 sound/soc/codecs/rt5677-spi.c                      |   35 +++++-------
 sound/usb/mixer.c                                  |    2=20
 tools/objtool/check.c                              |    3 -
 64 files changed, 526 insertions(+), 280 deletions(-)

Alexander Sverdlin (1):
      mtd: spi-nor: intel-spi: Avoid crossing 4K address boundary on read/w=
rite

Andrea Arcangeli (1):
      userfaultfd: use RCU to free the task struct when fork fails

Andy Lutomirski (2):
      x86/speculation/mds: Revert CPU buffer clear on double fault exit
      x86/speculation/mds: Improve CPU buffer clear documentation

Barret Rhoden (1):
      ext4: fix use-after-free race with debug_want_extra_isize

Coly Li (1):
      bcache: never set KEY_PTRS of journal key to 0 in journal_reclaim()

Curtis Malainey (1):
      ASoC: RT5677-SPI: Disable 16Bit SPI Transfers

Daniel Axtens (1):
      crypto: vmx - fix copy-paste error in CTR mode

Daniel Borkmann (1):
      bpf, arm64: remove prefetch insn in xadd mapping

Debabrata Banerjee (1):
      ext4: fix ext4_show_options for file systems w/o journal

Dexuan Cui (3):
      PCI: hv: Fix a memory leak in hv_eject_device_work()
      PCI: hv: Add hv_pci_remove_slots() when we unload the driver
      PCI: hv: Add pci_destroy_slot() in pci_devices_present_work(), if nec=
essary

Dmitry Osipenko (1):
      mfd: max77620: Fix swapped FPS_PERIOD_MAX_US values

Eric Biggers (9):
      crypto: chacha20poly1305 - set cra_name correctly
      crypto: skcipher - don't WARN on unprocessed data after slow walk step
      crypto: crct10dif-generic - fix use via crypto_shash_digest()
      crypto: x86/crct10dif-pcl - fix use via crypto_shash_digest()
      crypto: gcm - fix incompatibility between "gcm" and "gcm_base"
      crypto: arm/aes-neonbs - don't access already-freed walk.iv
      crypto: arm64/aes-neonbs - don't access already-freed walk.iv
      crypto: salsa20 - don't access already-freed walk.iv
      crypto: ccm - fix incompatibility between "ccm" and "ccm_base"

Eric Dumazet (1):
      iov_iter: optimize page_copy_sane()

Filipe Manana (2):
      Btrfs: do not start a transaction during fiemap
      Btrfs: do not start a transaction at iterate_extent_inodes()

Greg Kroah-Hartman (2):
      fib_rules: fix error in backport of e9919a24d302 ("fib_rules: return =
0...")
      Linux 4.14.121

Gustavo A. R. Silva (1):
      power: supply: axp288_charger: Fix unchecked return value

Hui Wang (2):
      ALSA: hda/hdmi - Read the pin sense from register when repolling
      ALSA: hda/hdmi - Consider eld_valid when reporting jack event

Jan Kara (1):
      ext4: make sanity check in mballoc more strict

Jean-Philippe Brucker (2):
      arm64: Clear OSDLR_EL1 on CPU boot
      arm64: Save and restore OSDLR_EL1 across suspend/resume

Jiri Kosina (1):
      mm/mincore.c: make mincore() more conservative

Jiufei Xue (2):
      jbd2: check superblock mapped prior to committing
      fs/writeback.c: use rcu_barrier() to wait for inflight wb switches go=
ing into workqueue when umount

Jon Hunter (1):
      ASoC: max98090: Fix restore of DAPM Muxes

Josh Poimboeuf (1):
      objtool: Fix function fallthrough detection

Kailang Yang (1):
      ALSA: hda/realtek - EAPD turn on later

Kamlakant Patel (1):
      ipmi:ssif: compare block number correctly for multi-part return messa=
ges

Kirill Tkhai (1):
      ext4: actually request zeroing of inode table after grow

Liang Chen (1):
      bcache: fix a race between cache register and cacheset unregister

Lukas Czerner (1):
      ext4: fix data corruption caused by overlapping unaligned and aligned=
 IO

Micha=C5=82 Wadowski (1):
      ALSA: hda/realtek - Fix for Lenovo B50-70 inverted internal microphon=
e bug

Pan Bian (1):
      ext4: avoid drop reference to iloc.bh twice

Peter Zijlstra (1):
      sched/x86: Save [ER]FLAGS on context switch

Sahitya Tummala (1):
      ext4: fix use-after-free in dx_release()

Sasha Levin (1):
      net: core: another layer of lists, around PF_MEMALLOC skb handling

Sean Christopherson (1):
      KVM: x86: Skip EFER vs. guest CPUID checks for host-initiated writes

Sergei Trofimovich (1):
      tty/vt: fix write/write race in ioctl(KDSKBSENT) handler

Shuning Zhang (1):
      ocfs2: fix ocfs2 read inode data panic in ocfs2_iget

Sriram Rajagopalan (1):
      ext4: zero out the unused memory region in the extent tree block

Steve Twiss (1):
      mfd: da9063: Fix OTP control register names to match datasheets for D=
A9063/63L

Stuart Menefy (1):
      ARM: dts: exynos: Fix interrupt for shared EINTs on Exynos5260

Sylwester Nawrocki (1):
      ARM: dts: exynos: Fix audio (microphone) routing on Odroid XU3

Theodore Ts'o (1):
      ext4: ignore e_value_offs for xattrs with value-in-ea-inode

Vincenzo Frascino (1):
      arm64: compat: Reduce address limit

Waiman Long (1):
      locking/rwsem: Prevent decrement of reader count before increment

Wen Yang (1):
      ARM: exynos: Fix a leaked reference by adding missing of_node_put

Wenwen Wang (1):
      ALSA: usb-audio: Fix a memory leak bug

Yifeng Li (1):
      tty: vt.c: Fix TIOCL_BLANKSCREEN console blanking if blankinterval =
=3D=3D 0

Zhang Zhijie (1):
      crypto: rockchip - update IV buffer to contain the next IV

zhangyi (F) (1):
      ext4: fix compile error when using BUFFER_TRACE


--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzk7R0ACgkQONu9yGCS
aT7Fvw/+N286W9TmHERVAUAE0YaWT+XYMsSabYc6ZG0CxEfm+ubw07tTqIH3joWW
7zKT7aUpRBEX7HvB9rUUs6xCCEvORpu3UOOhHYvLR5YvLXuVP+cWo2FWIjcAUlnb
zr0F9U4r6N+8WIZVNB5HHnC6wboPY5mien70TGdZCelKMw8GcgIkyhhKSu/N+3LX
swZMVCAwoGc/bmi6N50+7p8+p7x1hEWH2l/FfbxHeGihccagOUwr6fsiPf8qlK71
/kbXoL6Iz22DgfeOu8uLvuU+s/62e/JdUqU20mdb/6HY7LDAl+dfeGY2kRW5pI/y
hK7pV7jzaxCikIZ4K2E3m45yv+J8yxc5aE7QupEnZ2OIdAI4cvLAXdw7Ys/JrF2W
Eifl9wWPDKc4mBxw60dpS+1v381AFM7NdMxrBna/P0zDv8CMbs9p97JH+73KhF1Y
T5dvw1DPk38cJT/DdljdYzE4nNrB84CA5LjyP8vFa/TNWJ5gKILBhwFPcSQtls83
nPkeXync2huKwduY39ELPvjeFUfS2S2PLRBAUdkNjxnl2KMA5maUl4T5FrpyiNd4
jL14nKATiXC7xvibXkfcyWIPGT71ErfosBFDV2gq99b8HFLIJsE0mnuIGiySFwq3
4sLdjoQJ/OutZ6t9bXwfdnsfMp1d5eVmP2ru7IsLxDyYb1wVQRk=
=miwQ
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
