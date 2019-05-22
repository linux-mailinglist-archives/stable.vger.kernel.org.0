Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 124F725E23
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 08:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbfEVGdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 02:33:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725850AbfEVGdf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 02:33:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4BD020644;
        Wed, 22 May 2019 06:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558506813;
        bh=E77dU3aFR6NS0XgAbOsrpRPS1seiJqxwOwSpQqsfN/g=;
        h=Date:From:To:Cc:Subject:From;
        b=SwunvAkO0I/TukqyIokk69E8x6cLRuKUJXLsQa5R82Ndqe7X1RvU6ofgK1R8ZEgEH
         kyYujaqALajuQ99G1BWO5lnWqfxV2jRhRsyYoMCisLimgOBFh2sBB+WJt3CChWMc+J
         jQjInFhMz2ug1ftDnNHWKQyvxLqxQcMFVtZ+p9sU=
Date:   Wed, 22 May 2019 08:33:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.45
Message-ID: <20190522063331.GA20715@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.45 kernel.

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

 Documentation/x86/mds.rst                          |   44 +-------
 Makefile                                           |    4=20
 arch/arm/boot/dts/exynos5260.dtsi                  |    2=20
 arch/arm/boot/dts/exynos5422-odroidxu3-audio.dtsi  |    2=20
 arch/arm/crypto/aes-neonbs-glue.c                  |    2=20
 arch/arm/mach-exynos/firmware.c                    |    1=20
 arch/arm/mach-exynos/suspend.c                     |    2=20
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |    1=20
 arch/arm64/crypto/aes-neonbs-glue.c                |    2=20
 arch/arm64/crypto/ghash-ce-glue.c                  |   10 +
 arch/arm64/include/asm/arch_timer.h                |   33 +++++-
 arch/arm64/include/asm/processor.h                 |    8 +
 arch/arm64/kernel/debug-monitors.c                 |    1=20
 arch/arm64/kernel/sys.c                            |    2=20
 arch/arm64/kernel/vdso/gettimeofday.S              |   15 ++
 arch/arm64/mm/proc.S                               |   34 +++---
 arch/arm64/net/bpf_jit.h                           |    6 -
 arch/arm64/net/bpf_jit_comp.c                      |    1=20
 arch/x86/crypto/crct10dif-pclmul_glue.c            |   13 --
 arch/x86/entry/entry_32.S                          |    2=20
 arch/x86/entry/entry_64.S                          |    2=20
 arch/x86/include/asm/switch_to.h                   |    1=20
 arch/x86/kernel/process_32.c                       |    7 +
 arch/x86/kernel/process_64.c                       |    8 +
 arch/x86/kernel/traps.c                            |    8 -
 arch/x86/kvm/lapic.c                               |    2=20
 arch/x86/kvm/x86.c                                 |   37 ++++--
 arch/x86/xen/enlighten_pvh.c                       |    1=20
 crypto/ccm.c                                       |   44 +++-----
 crypto/chacha20poly1305.c                          |    4=20
 crypto/crct10dif_generic.c                         |   11 --
 crypto/gcm.c                                       |   34 ++----
 crypto/salsa20_generic.c                           |    2=20
 crypto/skcipher.c                                  |    9 +
 drivers/acpi/sleep.c                               |    4=20
 drivers/char/ipmi/ipmi_ssif.c                      |    6 -
 drivers/crypto/amcc/crypto4xx_alg.c                |   12 +-
 drivers/crypto/amcc/crypto4xx_core.c               |   31 +++--
 drivers/crypto/ccp/psp-dev.c                       |    2=20
 drivers/crypto/ccree/cc_aead.c                     |   11 +-
 drivers/crypto/ccree/cc_buffer_mgr.c               |  113 ++++++----------=
-----
 drivers/crypto/ccree/cc_driver.h                   |    1=20
 drivers/crypto/ccree/cc_fips.c                     |   23 ++--
 drivers/crypto/ccree/cc_fips.h                     |    2=20
 drivers/crypto/ccree/cc_hash.c                     |   28 ++++-
 drivers/crypto/ccree/cc_ivgen.c                    |    9 -
 drivers/crypto/ccree/cc_pm.c                       |    9 +
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |   25 +++-
 drivers/crypto/vmx/aesp8-ppc.pl                    |    4=20
 drivers/dax/device.c                               |    6 -
 drivers/md/bcache/journal.c                        |   11 +-
 drivers/md/bcache/super.c                          |    2=20
 drivers/mmc/core/queue.c                           |    1=20
 drivers/mmc/host/sdhci-of-arasan.c                 |    5=20
 drivers/mtd/spi-nor/intel-spi.c                    |    8 +
 drivers/nvdimm/label.c                             |   29 ++---
 drivers/nvdimm/namespace_devs.c                    |   15 ++
 drivers/nvdimm/nd.h                                |    4=20
 drivers/power/supply/axp288_charger.c              |    4=20
 drivers/power/supply/axp288_fuel_gauge.c           |   20 +++
 drivers/tty/hvc/hvc_riscv_sbi.c                    |    1=20
 drivers/tty/vt/keyboard.c                          |   33 +++++-
 drivers/tty/vt/vt.c                                |    2=20
 fs/btrfs/backref.c                                 |   34 ++++--
 fs/btrfs/ctree.c                                   |   10 +
 fs/btrfs/disk-io.c                                 |   27 ++---
 fs/btrfs/disk-io.h                                 |    3=20
 fs/btrfs/extent-tree.c                             |   25 +++-
 fs/btrfs/send.c                                    |   36 ++++++
 fs/dax.c                                           |    6 -
 fs/ext4/ext4.h                                     |    6 -
 fs/ext4/extents.c                                  |   17 ++-
 fs/ext4/file.c                                     |    7 +
 fs/ext4/inode.c                                    |    3=20
 fs/ext4/ioctl.c                                    |    2=20
 fs/ext4/mballoc.c                                  |    2=20
 fs/ext4/namei.c                                    |    5=20
 fs/ext4/resize.c                                   |    1=20
 fs/ext4/super.c                                    |   63 ++++++-----
 fs/ext4/xattr.c                                    |    2=20
 fs/fs-writeback.c                                  |   11 +-
 fs/hugetlbfs/inode.c                               |    7 -
 fs/jbd2/journal.c                                  |   53 ++++++---
 fs/jbd2/revoke.c                                   |   32 +++--
 fs/jbd2/transaction.c                              |    8 -
 fs/ocfs2/export.c                                  |   30 +++++
 fs/pstore/inode.c                                  |   11 --
 fs/pstore/internal.h                               |    5=20
 fs/pstore/platform.c                               |   75 +++++++++++--
 fs/pstore/ram.c                                    |    2=20
 include/linux/huge_mm.h                            |    6 -
 include/linux/hugetlb.h                            |    4=20
 include/linux/jbd2.h                               |    8 -
 include/linux/mfd/da9063/registers.h               |    6 -
 include/linux/mfd/max77620.h                       |    4=20
 kernel/fork.c                                      |   31 +++++
 kernel/locking/rwsem-xadd.c                        |   44 +++++---
 lib/iov_iter.c                                     |   17 ++-
 mm/huge_memory.c                                   |   16 +-
 mm/hugetlb.c                                       |   25 +---
 mm/mincore.c                                       |   23 ++++
 mm/userfaultfd.c                                   |    3=20
 sound/pci/hda/patch_hdmi.c                         |   11 +-
 sound/pci/hda/patch_realtek.c                      |   68 +++++++-----
 sound/soc/codecs/hdac_hdmi.c                       |   11 ++
 sound/soc/codecs/max98090.c                        |   12 +-
 sound/soc/codecs/rt5677-spi.c                      |   35 ++----
 sound/soc/fsl/fsl_esai.c                           |    2=20
 sound/usb/line6/toneport.c                         |   16 +-
 sound/usb/mixer.c                                  |    2=20
 tools/objtool/check.c                              |    3=20
 111 files changed, 1023 insertions(+), 583 deletions(-)

Alexander Sverdlin (1):
      mtd: spi-nor: intel-spi: Avoid crossing 4K address boundary on read/w=
rite

Andrea Arcangeli (1):
      userfaultfd: use RCU to free the task struct when fork fails

Andreas Dilger (1):
      ext4: don't update s_rev_level if not required

Andy Lutomirski (2):
      x86/speculation/mds: Revert CPU buffer clear on double fault exit
      x86/speculation/mds: Improve CPU buffer clear documentation

Anup Patel (1):
      tty: Don't force RISCV SBI console as preferred console

Barret Rhoden (1):
      ext4: fix use-after-free race with debug_want_extra_isize

Boyang Zhou (1):
      arm64: mmap: Ensure file offset is treated as unsigned

Chengguang Xu (1):
      jbd2: fix potential double free

Christian Lamparter (2):
      crypto: crypto4xx - fix ctr-aes missing output IV
      crypto: crypto4xx - fix cfb and ofb "overran dst buffer" issues

Christoph Muellner (2):
      arm64: dts: rockchip: Disable DCMDs on RK3399's eMMC controller.
      mmc: sdhci-of-arasan: Add DTS property to disable DCMDs.

Coly Li (1):
      bcache: never set KEY_PTRS of journal key to 0 in journal_reclaim()

Curtis Malainey (1):
      ASoC: RT5677-SPI: Disable 16Bit SPI Transfers

Dan Williams (2):
      mm/huge_memory: fix vmf_insert_pfn_{pmd, pud}() crash, handle unalign=
ed addresses
      libnvdimm/namespace: Fix label tracking error

Daniel Axtens (1):
      crypto: vmx - fix copy-paste error in CTR mode

Daniel Borkmann (1):
      bpf, arm64: remove prefetch insn in xadd mapping

Debabrata Banerjee (1):
      ext4: fix ext4_show_options for file systems w/o journal

Dmitry Osipenko (1):
      mfd: max77620: Fix swapped FPS_PERIOD_MAX_US values

Eric Biggers (10):
      crypto: salsa20 - don't access already-freed walk.iv
      crypto: chacha20poly1305 - set cra_name correctly
      crypto: skcipher - don't WARN on unprocessed data after slow walk step
      crypto: crct10dif-generic - fix use via crypto_shash_digest()
      crypto: x86/crct10dif-pcl - fix use via crypto_shash_digest()
      crypto: arm64/gcm-aes-ce - fix no-NEON fallback code
      crypto: gcm - fix incompatibility between "gcm" and "gcm_base"
      crypto: arm/aes-neonbs - don't access already-freed walk.iv
      crypto: arm64/aes-neonbs - don't access already-freed walk.iv
      crypto: ccm - fix incompatibility between "ccm" and "ccm_base"

Eric Dumazet (1):
      iov_iter: optimize page_copy_sane()

Filipe Manana (3):
      Btrfs: send, flush dellaloc in order to avoid data loss
      Btrfs: do not start a transaction during fiemap
      Btrfs: do not start a transaction at iterate_extent_inodes()

Gilad Ben-Yossef (5):
      crypto: ccree - remove special handling of chained sg
      crypto: ccree - fix mem leak on error path
      crypto: ccree - don't map MAC key on stack
      crypto: ccree - use correct internal state sizes for export
      crypto: ccree - don't map AEAD key and IV on stack

Greg Kroah-Hartman (1):
      Linux 4.19.45

Gustavo A. R. Silva (1):
      power: supply: axp288_charger: Fix unchecked return value

Hans de Goede (1):
      power: supply: axp288_fuel_gauge: Add ACEPC T8 and T11 mini PCs to th=
e blacklist

Hui Wang (2):
      ALSA: hda/hdmi - Read the pin sense from register when repolling
      ALSA: hda/hdmi - Consider eld_valid when reporting jack event

Jan Kara (2):
      ext4: make sanity check in mballoc more strict
      ext4: avoid panic during forced reboot due to aborted journal

Jean-Philippe Brucker (2):
      arm64: Clear OSDLR_EL1 on CPU boot
      arm64: Save and restore OSDLR_EL1 across suspend/resume

Jeremy Soller (2):
      ALSA: hdea/realtek - Headset fixup for System76 Gazelle (gaze14)
      ALSA: hda/realtek - Corrected fixup for System76 Gazelle (gaze14)

Jiri Kosina (1):
      mm/mincore.c: make mincore() more conservative

Jiufei Xue (2):
      jbd2: check superblock mapped prior to committing
      fs/writeback.c: use rcu_barrier() to wait for inflight wb switches go=
ing into workqueue when umount

Joel Fernandes (Google) (1):
      pstore: Allocate compression during late_initcall()

Jon Hunter (1):
      ASoC: max98090: Fix restore of DAPM Muxes

Josh Poimboeuf (1):
      objtool: Fix function fallthrough detection

Kai Shen (1):
      mm/hugetlb.c: don't put_page in lock of hugetlb_lock

Kailang Yang (2):
      ALSA: hda/realtek - EAPD turn on later
      ALSA: hda/realtek - Fixup headphone noise via runtime suspend

Kamlakant Patel (1):
      ipmi:ssif: compare block number correctly for multi-part return messa=
ges

Kees Cook (2):
      pstore: Centralize init/exit routines
      pstore: Refactor compression initialization

Kirill Tkhai (1):
      ext4: actually request zeroing of inode table after grow

Liang Chen (1):
      bcache: fix a race between cache register and cacheset unregister

Libin Yang (1):
      ASoC: codec: hdac_hdmi add device_link to card device

Lukas Czerner (1):
      ext4: fix data corruption caused by overlapping unaligned and aligned=
 IO

Masahiro Yamada (1):
      kbuild: turn auto.conf.cmd into a mandatory include file

Micha=C5=82 Wadowski (1):
      ALSA: hda/realtek - Fix for Lenovo B50-70 inverted internal microphon=
e bug

Mike Kravetz (1):
      hugetlb: use same fault hash key for shared and private mappings

Nikolay Borisov (2):
      btrfs: Correctly free extent buffer in case btree_read_extent_buffer_=
pages fails
      btrfs: Honour FITRIM range constraints during free space trim

Ofir Drang (4):
      crypto: ccree - pm resume first enable the source clk
      crypto: ccree - HOST_POWER_DOWN_EN should be the last CC access durin=
g suspend
      crypto: ccree - add function to handle cryptocell tee fips error
      crypto: ccree - handle tee fips error during power management resume

Pan Bian (1):
      ext4: avoid drop reference to iloc.bh twice

Peter Zijlstra (1):
      sched/x86: Save [ER]FLAGS on context switch

Qu Wenruo (1):
      btrfs: Check the first key and level for cached extent buffer

Rajat Jain (1):
      ACPI: PM: Set enable_for_wake for wakeup GPEs during suspend-to-idle

Raul E Rangel (1):
      mmc: core: Fix tag set memory leak

Roger Pau Monne (1):
      xen/pvh: set xen_domain_type to HVM in xen_pvh_init

S.j. Wang (1):
      ASoC: fsl_esai: Fix missing break in switch statement

Sahitya Tummala (1):
      ext4: fix use-after-free in dx_release()

Sean Christopherson (2):
      KVM: x86: Skip EFER vs. guest CPUID checks for host-initiated writes
      KVM: lapic: Busy wait for timer to expire when using hv_timer

Sergei Trofimovich (1):
      tty/vt: fix write/write race in ioctl(KDSKBSENT) handler

Shuning Zhang (1):
      ocfs2: fix ocfs2 read inode data panic in ocfs2_iget

Singh, Brijesh (1):
      crypto: ccp - Do not free psp_master when PLATFORM_INIT fails

Sriram Rajagopalan (1):
      ext4: zero out the unused memory region in the extent tree block

Steve Twiss (1):
      mfd: da9063: Fix OTP control register names to match datasheets for D=
A9063/63L

Stuart Menefy (1):
      ARM: dts: exynos: Fix interrupt for shared EINTs on Exynos5260

Sylwester Nawrocki (1):
      ARM: dts: exynos: Fix audio (microphone) routing on Odroid XU3

Takashi Iwai (1):
      ALSA: line6: toneport: Fix broken usage of timer for delayed execution

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

Will Deacon (1):
      arm64: arch_timer: Ensure counter register reads occur with seqlock h=
eld

Yifeng Li (1):
      tty: vt.c: Fix TIOCL_BLANKSCREEN console blanking if blankinterval =
=3D=3D 0

Zhang Zhijie (1):
      crypto: rockchip - update IV buffer to contain the next IV

zhangyi (F) (1):
      ext4: fix compile error when using BUFFER_TRACE


--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzk7TsACgkQONu9yGCS
aT64DQ/+NzUtbUXqNFs5/vqILfRr+bv6krvqoeuS+irzKO9RALcI9JYvryONm7nB
rndVN4Gj2/6bxGc9qH6DGBt/ffiyPvwePJgxKdBjef7n9tJXkNsIKENCj/SpATpg
KQDRKi7sMvHga4E1v/lj1p2VwGslJ+dSmDjqKbQrK4uEImMNgAfQTGday6rZddFv
S6RkdaW2KZRScQBLQhC9VSj/BcpA7pLiZqxjC/NtvH5IcFWarJg+Y4WQpbR7zJB1
up+3tLNS3zz3YXcfz0MMudNAJMnWoxegpkInsSKmunnP7f/aYzJn771pMMWaQs7U
bBC1lJV4lTgxwvDaoQAzr1pIt8l3Iy8WiQ8au3t4ubFUKi6mIfF0X0bcM0ANasrw
sTEXUpQcHVxi6/Ncr0njIWQsartif/OGVnvP8FgRqVq8+pQhOTKGD2n2gUktFLHh
HegE0fcBYWacWx4YVLbB8i24dTqdV9C7E01WCi1Qzp9qfp/pBlsr/3dzkAE0ccUd
9rwKx5neb8guxgrAQl2a39ptmzIw5uzSDiGvdEkq1yn08RXu/3t3FuhHrBsaQDE5
52mFgW10aU0ze9YJ4/i3bFRMCKSBXPKEnfqoX5HIFkvSODfKSMcJcCxTxgC5C6Ey
TuAMmghA4Hic9jGXHj4tNH83WxNliucJ/BFs0rsrgOWOm/tztX0=
=iBkV
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
