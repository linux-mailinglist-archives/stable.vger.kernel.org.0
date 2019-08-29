Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F755A1860
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfH2L0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:26:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbfH2L0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 07:26:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C538E2173E;
        Thu, 29 Aug 2019 11:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567077964;
        bh=AZUQkQs0uDCgJgfpnddfXjszJDdDJDSObM9R9fLIvZE=;
        h=Date:From:To:Cc:Subject:From;
        b=BubB/CWgf53ct0wUMkDJKAjt2pkavEp/uWaVEHQQMpjES/4bNTo5O0WqlFwawdNbC
         0LYntfmacSoh4/ecXQ0WeJogszbeulBp4TPQhcHpZls+PbAp/MMqwH138JhjV2obDl
         /AFS+20mofTt5KP8dTuPP7/s4u8ddWYPgPyiBU3g=
Date:   Thu, 29 Aug 2019 13:26:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.141
Message-ID: <20190829112601.GA24853@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.141 kernel.

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

 Documentation/admin-guide/kernel-parameters.txt    |    7 +
 Makefile                                           |    2=20
 arch/mips/kernel/cacheinfo.c                       |    2=20
 arch/mips/kernel/i8253.c                           |    3=20
 arch/powerpc/kernel/misc_64.S                      |    4=20
 arch/x86/include/asm/bootparam_utils.h             |   61 +++++++++++---
 arch/x86/include/asm/msr-index.h                   |    1=20
 arch/x86/include/asm/nospec-branch.h               |    2=20
 arch/x86/kernel/apic/apic.c                        |   68 ++++++++++++----
 arch/x86/kernel/cpu/amd.c                          |   66 ++++++++++++++++
 arch/x86/lib/cpu.c                                 |    1=20
 arch/x86/power/cpu.c                               |   86 ++++++++++++++++=
+----
 drivers/ata/libata-scsi.c                          |   21 +++++
 drivers/ata/libata-sff.c                           |    6 +
 drivers/gpio/gpiolib.c                             |    6 -
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c      |   24 ++++-
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                |    4=20
 drivers/hid/hid-a4tech.c                           |   30 ++++++-
 drivers/hid/hid-tmff.c                             |   12 ++
 drivers/hid/wacom_wac.c                            |    4=20
 drivers/isdn/hardware/mISDN/hfcsusb.c              |   13 ++-
 drivers/md/dm-bufio.c                              |    4=20
 drivers/md/dm-kcopyd.c                             |    5 -
 drivers/md/dm-table.c                              |    5 -
 drivers/md/dm-zoned-metadata.c                     |   59 ++++++++++----
 drivers/md/dm-zoned-reclaim.c                      |   44 ++++++++--
 drivers/md/dm-zoned-target.c                       |   67 ++++++++++++++--
 drivers/md/dm-zoned.h                              |   10 ++
 drivers/md/persistent-data/dm-btree.c              |   31 +++----
 drivers/md/persistent-data/dm-space-map-metadata.c |    2=20
 drivers/net/bonding/bond_main.c                    |    9 ++
 drivers/net/can/dev.c                              |    2=20
 drivers/net/can/sja1000/peak_pcmcia.c              |    2=20
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |    2=20
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |    5 -
 drivers/net/ethernet/hisilicon/hip04_eth.c         |   28 +++---
 drivers/net/ethernet/qlogic/qed/qed_int.c          |    2=20
 drivers/net/ethernet/qlogic/qed/qed_rdma.c         |    2=20
 drivers/net/usb/qmi_wwan.c                         |    1=20
 drivers/nfc/st-nci/se.c                            |    2=20
 drivers/nfc/st21nfca/se.c                          |    2=20
 fs/ceph/locks.c                                    |    3=20
 fs/cifs/smb2ops.c                                  |   10 ++
 fs/nfs/nfs4_fs.h                                   |    3=20
 fs/nfs/nfs4client.c                                |    5 -
 fs/nfs/nfs4state.c                                 |   27 +++++-
 fs/userfaultfd.c                                   |   25 +++---
 fs/xfs/xfs_iops.c                                  |    1=20
 kernel/irq/irqdesc.c                               |   15 +++
 mm/huge_memory.c                                   |    4=20
 mm/zsmalloc.c                                      |   78 ++++++++++++++++=
+--
 net/bridge/netfilter/ebtables.c                    |    4=20
 net/ceph/osd_client.c                              |    9 --
 net/netfilter/ipset/ip_set_core.c                  |    2=20
 sound/soc/davinci/davinci-mcasp.c                  |   43 ++++++++--
 sound/soc/soc-core.c                               |    7 +
 sound/soc/soc-dapm.c                               |    8 -
 tools/perf/bench/numa.c                            |    6 -
 tools/perf/builtin-ftrace.c                        |    2=20
 tools/perf/pmu-events/jevents.c                    |    1=20
 tools/perf/tests/parse-events.c                    |   27 ------
 tools/perf/util/cpumap.c                           |    5 -
 tools/testing/selftests/kvm/config                 |    3=20
 63 files changed, 785 insertions(+), 210 deletions(-)

Aaron Armstrong Skomra (1):
      HID: wacom: correct misreported EKR ring values

Alastair D'Silva (1):
      powerpc: Allow flush_(inval_)dcache_range to work across ranges >4GB

Bartosz Golaszewski (1):
      gpiolib: never report open-drain/source lines as 'input' to user-space

Bob Ham (1):
      net: usb: qmi_wwan: Add the BroadMobi BM818 card

Charles Keepax (1):
      ASoC: dapm: Fix handling of custom_stop_condition on DAPM graph walks

Christophe JAILLET (1):
      net: cxgb3_main: Fix a resource leak in a error path in 'init_one()'

Colin Ian King (1):
      drm/vmwgfx: fix memory leak when too many retries have occurred

Dan Carpenter (1):
      dm zoned: fix potential NULL dereference in dmz_do_reclaim()

Darrick J. Wong (1):
      xfs: fix missing ILOCK unlock when xfs_setattr_nonsize fails due to E=
DQUOT

Dmitry Fomichev (4):
      dm kcopyd: always complete failed jobs
      dm zoned: improve error handling in reclaim
      dm zoned: improve error handling in i/o map code
      dm zoned: properly handle backing device failure

Greg Kroah-Hartman (1):
      Linux 4.14.141

He Zhe (2):
      perf ftrace: Fix failure to set cpumask when only one cpu is present
      perf cpumap: Fix writing to illegal memory in handling cpumap mask

Henry Burns (2):
      mm/zsmalloc.c: migration can leave pages in ZS_EMPTY indefinitely
      mm/zsmalloc.c: fix race condition in zs_destroy_pool

Ilya Dryomov (1):
      libceph: fix PG split vs OSD (re)connect race

Ilya Trukhanov (1):
      HID: Add 044f:b320 ThrustMaster, Inc. 2 in 1 DT

Jason Gerecke (1):
      HID: wacom: Correct distance scale for 2nd-gen Intuos devices

Jeff Layton (1):
      ceph: don't try fill file_lock on unsuccessful GETFILELOCK reply

Jens Axboe (2):
      libata: have ata_scsi_rw_xlat() fail invalid passthrough requests
      libata: add SG safety checks in SFF pio transfers

Jia-Ju Bai (1):
      isdn: mISDN: hfcsusb: Fix possible null-pointer dereferences in start=
_isoc_chain()

Jiangfeng Xiao (3):
      net: hisilicon: make hip04_tx_reclaim non-reentrant
      net: hisilicon: fix hip04-xmit never return TX_BUSY
      net: hisilicon: Fix dma_map_single failed on arm64

Jin Yao (1):
      perf pmu-events: Fix missing "cpu_clk_unhalted.core" event

Jiri Olsa (1):
      perf bench numa: Fix cpu0 binding

John Hubbard (2):
      x86/boot: Save fields explicitly, zero out everything else
      x86/boot: Fix boot regression caused by bootparam sanitizing

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix rename concurrency with listing

Juliana Rodrigueiro (1):
      isdn: hfcsusb: Fix mISDN driver crash caused by transfer buffer on th=
e stack

Lyude Paul (1):
      drm/nouveau: Don't retry infinitely when receiving no data on i2c ove=
r AUX

Michael Kelley (1):
      genirq: Properly pair kobject_del() with kobject_add()

Michal Kalderon (1):
      qed: RDMA - Fix the hw_ver returned in device attributes

Mikulas Patocka (2):
      Revert "dm bufio: fix deadlock with loop device"
      dm table: fix invalid memory accesses with too high sector number

Naresh Kamboju (1):
      selftests: kvm: Adding config fragments

Navid Emamdoost (2):
      st21nfca_connectivity_event_received: null check the allocation
      st_nci_hci_connectivity_event_received: null check the allocation

Nicolas Saenz Julienne (1):
      HID: input: fix a4tech horizontal wheel custom usage

Oleg Nesterov (1):
      userfaultfd_release: always remove uffd flags and clear vm_userfaultf=
d_ctx

Peter Ujfalusi (1):
      ASoC: ti: davinci-mcasp: Correct slot_width posed constraint

Rasmus Villemoes (1):
      can: dev: call netif_carrier_off() in register_candev()

Ricard Wanderlof (1):
      ASoC: Fail card instantiation if DAI format setup fails

Sasha Levin (1):
      Revert "perf test 6: Fix missing kvm module load for s390"

Sean Christopherson (1):
      x86/retpoline: Don't clobber RFLAGS during CALL_NOSPEC on i386

Sebastien Tisserant (1):
      SMB3: Kernel oops mounting a encryptData share with CONFIG_DEBUG_VIRT=
UAL

Thomas Bogendoerfer (1):
      MIPS: kernel: only use i8253 clocksource with periodic clockevent

Thomas Falcon (1):
      bonding: Force slave speed check after link state recovery for 802.3ad

Thomas Gleixner (1):
      x86/apic: Handle missing global clockevent gracefully

Tom Lendacky (1):
      x86/CPU/AMD: Clear RDRAND CPUID bit on AMD family 15h/16h

Trond Myklebust (1):
      NFSv4: Fix a potential sleep while atomic in nfs4_do_reclaim()

Valdis Kletnieks (1):
      x86/lib/cpu: Address missing prototypes warning

Vladimir Kondratiev (1):
      mips: fix cacheinfo

Vlastimil Babka (1):
      mm, page_owner: handle THP splits correctly

Wang Xiayang (3):
      can: sja1000: force the string buffer NULL-terminated
      can: peak_usb: force the string buffer NULL-terminated
      net/ethernet/qlogic/qed: force the string buffer NULL-terminated

Wenwen Wang (1):
      netfilter: ebtables: fix a memory leak bug in compat

ZhangXiaoxu (2):
      dm btree: fix order of block initialization in btree_split_beneath
      dm space map metadata: fix missing store of apply_bops() return value


--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1ntkcACgkQONu9yGCS
aT7FQxAAg2uhyYQfmw/CVw5PCMWCfwjJwoSFEWJCdLK1Jxnqv3cS7LSm/EyRBYA9
i/792ehHf3kfxTXouFQjrjWzpQqS4OZbEzK32xE2N6/ZGhW4ruaUmwZnNfpwQdjZ
Dx1pooRfjOsdDu7upIx5GmffNwQZDrDgUdILuTjc/PqURg+dRa+QCTnH7Mgm2HCO
eR5bcCBTzI/OPFfKIYanCszJkUTr+LMAG3nA/ygF36CgC+CAw78QqcRrcRVMEusG
IZrYd0t33war0FFJ2/urSEZMXlvdekc07JXWx8LlB73fZ2mY2+pmj5Su7bLy64uH
hwiW8Lf7saqNHDflSQvE4Ct5Kk6+CPauzsBx1yz/2e6KQxfcsdlWqa3qAzmof6QD
tsOIozYK2/LL2QorT0Iuc0Bjixqryn+LvS1RpQdN6PaOcK2WGS6wNf2BbIJN7Awr
VwJcrqLb/WF9FaiZGlOMztMWbMuc0B+aNv3+2sP9mdbkEWqvWDiHrW37PT73pZ4W
PWL9s9pn+KUaRqcGu7HBjIILrglEHUWYY85xxe1jzV0tJmDCb/CQuZ0rZiJzQub2
cD1yI/3DxaIVyj9MXhsGamwKZMMZmIKbtXFjLTPUkZOTA5OMnOQVr8NZhQ2BKDih
qA781i0JxcK1nuOqyyKLZTpoG6J5SJKZKMUULKqPJtkEpjYxgo0=
=j+0M
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
