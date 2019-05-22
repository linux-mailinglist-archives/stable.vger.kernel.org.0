Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 679AE25E0F
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 08:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfEVGcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 02:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbfEVGcu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 02:32:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E9BB20644;
        Wed, 22 May 2019 06:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558506768;
        bh=1Ivf6W7TV1gkfnLDfSHftG1+x4wnQXV40zJEhFg48+E=;
        h=Date:From:To:Cc:Subject:From;
        b=qxm3DexnQxzlOTE/qAWBVVJ7ZwPHQVJoC0QYXoK11XahpHyCoFwPeXYC8OQMXr1OW
         Nrz2k/Z1wb6FHrIjPlK9dx/LkAv5tTHFfuoZ6+b2Egtsbneza+pI+wyWpCC4z4uwEp
         Sy4HBK8+UNf2aceUUfWhvHzQKe64nOTK8Mws2/wE=
Date:   Wed, 22 May 2019 08:32:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.178
Message-ID: <20190522063245.GA20539@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.178 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/x86/mds.rst               |   44 +++------------------------
 Makefile                                |    2 -
 arch/arm/crypto/aesbs-glue.c            |    4 ++
 arch/arm/mach-exynos/firmware.c         |    1=20
 arch/arm/mach-exynos/suspend.c          |    2 +
 arch/arm64/include/asm/processor.h      |    8 +++++
 arch/arm64/kernel/debug-monitors.c      |    1=20
 arch/x86/crypto/crct10dif-pclmul_glue.c |   13 +++-----
 arch/x86/entry/entry_32.S               |    2 +
 arch/x86/entry/entry_64.S               |    2 +
 arch/x86/include/asm/switch_to.h        |    1=20
 arch/x86/kernel/process_32.c            |    7 ++++
 arch/x86/kernel/process_64.c            |    8 +++++
 arch/x86/kernel/traps.c                 |    8 -----
 arch/x86/kvm/x86.c                      |   33 +++++++++++++-------
 crypto/chacha20poly1305.c               |    4 +-
 crypto/crct10dif_generic.c              |   11 ++----
 crypto/gcm.c                            |   36 +++++++---------------
 crypto/salsa20_generic.c                |    2 -
 drivers/char/ipmi/ipmi_ssif.c           |    6 +++
 drivers/crypto/vmx/aesp8-ppc.pl         |    4 +-
 drivers/md/bcache/journal.c             |   11 ++++--
 drivers/md/bcache/super.c               |    2 -
 drivers/pci/host/pci-hyperv.c           |    1=20
 drivers/power/supply/axp288_charger.c   |    4 ++
 drivers/tty/vt/keyboard.c               |   33 ++++++++++++++++----
 fs/btrfs/backref.c                      |   18 +++++++----
 fs/ext4/extents.c                       |   17 +++++++++-
 fs/ext4/file.c                          |    7 ++++
 fs/ext4/ioctl.c                         |    2 -
 fs/ext4/super.c                         |    2 -
 fs/fs-writeback.c                       |   51 +++++++++++++++++++++++++++=
+----
 fs/jbd2/journal.c                       |    4 ++
 fs/ocfs2/export.c                       |   30 ++++++++++++++++++
 include/linux/backing-dev-defs.h        |    1=20
 include/linux/list.h                    |   30 ++++++++++++++++++
 include/linux/mfd/da9063/registers.h    |    6 +--
 include/linux/mfd/max77620.h            |    4 +-
 kernel/locking/rwsem-xadd.c             |   44 ++++++++++++++++++---------
 mm/backing-dev.c                        |    1=20
 mm/mincore.c                            |   23 +++++++++++++-
 net/core/fib_rules.c                    |    1=20
 sound/pci/hda/patch_hdmi.c              |   11 +++++-
 sound/pci/hda/patch_realtek.c           |    5 +--
 sound/soc/codecs/max98090.c             |   12 +++----
 sound/soc/codecs/rt5677-spi.c           |   35 ++++++++++-----------
 sound/usb/mixer.c                       |    2 +
 tools/objtool/check.c                   |    3 +
 48 files changed, 378 insertions(+), 181 deletions(-)

Andy Lutomirski (2):
      x86/speculation/mds: Revert CPU buffer clear on double fault exit
      x86/speculation/mds: Improve CPU buffer clear documentation

Coly Li (1):
      bcache: never set KEY_PTRS of journal key to 0 in journal_reclaim()

Curtis Malainey (1):
      ASoC: RT5677-SPI: Disable 16Bit SPI Transfers

Daniel Axtens (1):
      crypto: vmx - fix copy-paste error in CTR mode

Debabrata Banerjee (1):
      ext4: fix ext4_show_options for file systems w/o journal

Dexuan Cui (1):
      PCI: hv: Fix a memory leak in hv_eject_device_work()

Dmitry Osipenko (1):
      mfd: max77620: Fix swapped FPS_PERIOD_MAX_US values

Eric Biggers (6):
      crypto: chacha20poly1305 - set cra_name correctly
      crypto: crct10dif-generic - fix use via crypto_shash_digest()
      crypto: x86/crct10dif-pcl - fix use via crypto_shash_digest()
      crypto: gcm - fix incompatibility between "gcm" and "gcm_base"
      crypto: salsa20 - don't access already-freed walk.iv
      crypto: arm/aes-neonbs - don't access already-freed walk.iv

Filipe Manana (1):
      Btrfs: do not start a transaction at iterate_extent_inodes()

Greg Kroah-Hartman (2):
      fib_rules: fix error in backport of e9919a24d302 ("fib_rules: return =
0...")
      Linux 4.9.178

Gustavo A. R. Silva (1):
      power: supply: axp288_charger: Fix unchecked return value

Hui Wang (2):
      ALSA: hda/hdmi - Read the pin sense from register when repolling
      ALSA: hda/hdmi - Consider eld_valid when reporting jack event

Jean-Philippe Brucker (1):
      arm64: Clear OSDLR_EL1 on CPU boot

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

Peter Zijlstra (1):
      sched/x86: Save [ER]FLAGS on context switch

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

Tejun Heo (1):
      writeback: synchronize sync(2) against cgroup writeback membership sw=
itches

Vincenzo Frascino (1):
      arm64: compat: Reduce address limit

Waiman Long (1):
      locking/rwsem: Prevent decrement of reader count before increment

Wei Yongjun (1):
      crypto: gcm - Fix error return code in crypto_gcm_create_common()

Wen Yang (1):
      ARM: exynos: Fix a leaked reference by adding missing of_node_put

Wenwen Wang (1):
      ALSA: usb-audio: Fix a memory leak bug


--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzk7QgACgkQONu9yGCS
aT7GHQ/9FQjVMmX/WDqj2WhxmQYzrCQ8zTvdz1pSC/uCXMRqRdQhpSwIpNCmOdEN
gob658M6QnseWkyJP2SZeyAxygNL5stHwbilxLCcYZ91WlyFRbpptEgZIYVya9/e
JlwVuI4bXkX3SMeCitjnYEJRFVgCmx+EdKFdN3zzG/x3QNw2/MsP0uVBXWt+bdGn
pntfP2BGc5DRwyjf7Tifdn7JWFcmj4HKLOK786yz1iQjGNjQJpqsj3v+dA+XNz+E
xeNY6ZH5s2fVu6McOKNK2cag+8MWBuiy+JLXVdHLhwIzRO65HFL9eK6nldYgvizf
+CkFvrjvWPyv8FzqbpUM/UiOXwGihb+vLnAX6djbDmGEPrSrPQN6odLQLQ5vM4jT
deBIp17n8IhdPxZl8VJdlC5AClz8TtBkw0E3ZgXYPloo0NcEJ2X7a02Hh3mlGCI1
O6isKgl7dh14xo8PuxR/l6otGVbX4aTUgbH0PfGIg2A4McK8OvRbkdlCcc7+Eug3
zHQoRoOlkNiTHXX1vkQ4obtsCQnd571FqFKsLH17wdEdS0ejNaVdWha1FFIPCMbZ
TIMeOBVwxwdb4siqmWjxB+dcuiXRAFqRGCIULimGKZ08guDrTrzI5OGl6igmye9V
b0+BnD2DvbvL/I16Y4I+7J9Rtt+3mrrF1J1++lNzmyFqjdv+3fk=
=d1X1
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
