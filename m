Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71DCDA1864
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfH2L0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:26:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbfH2L0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 07:26:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2383A2189D;
        Thu, 29 Aug 2019 11:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567077992;
        bh=cROhccJ/JpdREnxgRsM0w9eSYleXrJZezL2jm910KiE=;
        h=Date:From:To:Cc:Subject:From;
        b=Ghk0zI6z+rUxwN4PLOz4ca5zH7zEGe5eYgwHaOf8O+eo5/t6Qbig2yGekmSH01yru
         uS+toqCV+NRDDMaTkXryTqdy+MPfHS7uBpshS2J8gk1aDVRY9ijJL2Dm7xhAr5uP28
         E2aIO30ewCLMP/meJbxERu4f3V6rB97HI8x+A6Bw=
Date:   Thu, 29 Aug 2019 13:26:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.69
Message-ID: <20190829112630.GA24959@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.69 kernel.

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

 Documentation/admin-guide/kernel-parameters.txt         |    7=20
 Makefile                                                |    2=20
 arch/arm/kvm/coproc.c                                   |   23 +
 arch/arm64/kvm/sys_regs.c                               |   32 +-
 arch/mips/kernel/cacheinfo.c                            |    2=20
 arch/mips/kernel/i8253.c                                |    3=20
 arch/powerpc/kernel/misc_64.S                           |    4=20
 arch/s390/kernel/vmlinux.lds.S                          |   10=20
 arch/x86/include/asm/bootparam_utils.h                  |   61 +++-
 arch/x86/include/asm/msr-index.h                        |    1=20
 arch/x86/include/asm/nospec-branch.h                    |    2=20
 arch/x86/kernel/apic/apic.c                             |   68 +++-
 arch/x86/kernel/cpu/amd.c                               |   66 ++++
 arch/x86/lib/cpu.c                                      |    1=20
 arch/x86/power/cpu.c                                    |   86 +++++
 block/bfq-iosched.c                                     |   14=20
 drivers/ata/libata-scsi.c                               |   21 +
 drivers/ata/libata-sff.c                                |    6=20
 drivers/clk/socfpga/clk-periph-s10.c                    |    2=20
 drivers/gpio/gpiolib.c                                  |    6=20
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c           |   24 +
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c         |    2=20
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                     |    4=20
 drivers/hid/hid-a4tech.c                                |   30 +-
 drivers/hid/hid-ids.h                                   |    1=20
 drivers/hid/hid-quirks.c                                |    1=20
 drivers/hid/hid-tmff.c                                  |   12=20
 drivers/hid/wacom_wac.c                                 |    4=20
 drivers/hv/channel.c                                    |    2=20
 drivers/isdn/hardware/mISDN/hfcsusb.c                   |   13=20
 drivers/md/dm-bufio.c                                   |    4=20
 drivers/md/dm-integrity.c                               |   15 +
 drivers/md/dm-kcopyd.c                                  |    5=20
 drivers/md/dm-raid.c                                    |    2=20
 drivers/md/dm-table.c                                   |    5=20
 drivers/md/dm-zoned-metadata.c                          |   59 +++-
 drivers/md/dm-zoned-reclaim.c                           |   44 ++-
 drivers/md/dm-zoned-target.c                            |   67 ++++
 drivers/md/dm-zoned.h                                   |   10=20
 drivers/md/persistent-data/dm-btree.c                   |   31 +-
 drivers/md/persistent-data/dm-space-map-metadata.c      |    2=20
 drivers/net/bonding/bond_main.c                         |    9=20
 drivers/net/can/dev.c                                   |    2=20
 drivers/net/can/sja1000/peak_pcmcia.c                   |    2=20
 drivers/net/can/spi/mcp251x.c                           |   49 +--
 drivers/net/can/usb/peak_usb/pcan_usb_core.c            |    2=20
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c         |    5=20
 drivers/net/ethernet/hisilicon/hip04_eth.c              |   28 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c         |    6=20
 drivers/net/ethernet/qlogic/qed/qed_int.c               |    2=20
 drivers/net/ethernet/qlogic/qed/qed_rdma.c              |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c       |    4=20
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c     |    4=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c         |    2=20
 drivers/net/phy/phy_led_triggers.c                      |    3=20
 drivers/net/usb/qmi_wwan.c                              |    1=20
 drivers/net/wireless/mac80211_hwsim.c                   |    8=20
 drivers/nfc/st-nci/se.c                                 |    2=20
 drivers/nfc/st21nfca/se.c                               |    2=20
 fs/ceph/addr.c                                          |    5=20
 fs/ceph/locks.c                                         |    3=20
 fs/cifs/smb2ops.c                                       |   39 +-
 fs/nfs/fscache.c                                        |    7=20
 fs/nfs/fscache.h                                        |    2=20
 fs/nfs/nfs4_fs.h                                        |    3=20
 fs/nfs/nfs4client.c                                     |    5=20
 fs/nfs/nfs4state.c                                      |   27 +
 fs/nfs/super.c                                          |    1=20
 fs/userfaultfd.c                                        |   25 -
 fs/xfs/libxfs/xfs_attr.c                                |  231 ++++++++---=
-----
 fs/xfs/libxfs/xfs_attr.h                                |  150 ++++++++++
 fs/xfs/libxfs/xfs_bmap.c                                |   54 ++-
 fs/xfs/libxfs/xfs_bmap.h                                |    1=20
 fs/xfs/libxfs/xfs_defer.c                               |   14=20
 fs/xfs/xfs_attr.h                                       |  148 ----------
 fs/xfs/xfs_dquot.c                                      |   17 -
 fs/xfs/xfs_iops.c                                       |    1=20
 include/trace/events/rxrpc.h                            |    6=20
 kernel/irq/irqdesc.c                                    |   15 -
 mm/huge_memory.c                                        |    4=20
 mm/zsmalloc.c                                           |   78 +++++
 net/bridge/netfilter/ebtables.c                         |    4=20
 net/can/gw.c                                            |   48 ++-
 net/ceph/osd_client.c                                   |    9=20
 net/netfilter/ipset/ip_set_bitmap_ipmac.c               |    2=20
 net/netfilter/ipset/ip_set_core.c                       |    2=20
 net/netfilter/ipset/ip_set_hash_ipmac.c                 |    6=20
 net/rxrpc/af_rxrpc.c                                    |    4=20
 net/rxrpc/ar-internal.h                                 |    6=20
 net/rxrpc/input.c                                       |   16 -
 net/rxrpc/local_object.c                                |  103 ++++---
 net/rxrpc/peer_event.c                                  |    2=20
 net/rxrpc/peer_object.c                                 |   18 +
 net/rxrpc/sendmsg.c                                     |    1=20
 sound/soc/davinci/davinci-mcasp.c                       |   43 ++
 sound/soc/rockchip/rockchip_i2s.c                       |    5=20
 sound/soc/soc-core.c                                    |    7=20
 sound/soc/soc-dapm.c                                    |    8=20
 tools/perf/bench/numa.c                                 |    6=20
 tools/perf/builtin-ftrace.c                             |    2=20
 tools/perf/pmu-events/jevents.c                         |    1=20
 tools/perf/util/cpumap.c                                |    5=20
 tools/testing/selftests/bpf/sendmsg6_prog.c             |    3=20
 tools/testing/selftests/kvm/config                      |    3=20
 tools/testing/selftests/net/forwarding/gre_multipath.sh |   28 +
 105 files changed, 1414 insertions(+), 641 deletions(-)

Aaron Armstrong Skomra (1):
      HID: wacom: correct misreported EKR ring values

Alastair D'Silva (1):
      powerpc: Allow flush_(inval_)dcache_range to work across ranges >4GB

Allison Henderson (4):
      xfs: Move fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
      xfs: Add helper function xfs_attr_try_sf_addname
      xfs: Add attibute set and helper functions
      xfs: Add attibute remove and helper functions

Bartosz Golaszewski (1):
      gpiolib: never report open-drain/source lines as 'input' to user-space

Bob Ham (1):
      net: usb: qmi_wwan: Add the BroadMobi BM818 card

Brian Foster (1):
      xfs: don't trip over uninitialized buffer on extent read of corrupted=
 inode

Charles Keepax (1):
      ASoC: dapm: Fix handling of custom_stop_condition on DAPM graph walks

Cheng-Yi Chiang (1):
      ASoC: rockchip: Fix mono capture

Christophe JAILLET (1):
      net: cxgb3_main: Fix a resource leak in a error path in 'init_one()'

Colin Ian King (1):
      drm/vmwgfx: fix memory leak when too many retries have occurred

Dan Carpenter (1):
      dm zoned: fix potential NULL dereference in dmz_do_reclaim()

Darrick J. Wong (2):
      xfs: fix missing ILOCK unlock when xfs_setattr_nonsize fails due to E=
DQUOT
      xfs: always rejoin held resources during defer roll

David Howells (6):
      rxrpc: Fix potential deadlock
      rxrpc: Fix the lack of notification when sendmsg() fails on a DATA pa=
cket
      rxrpc: Fix local endpoint refcounting
      rxrpc: Fix read-after-free in rxrpc_queue_local()
      rxrpc: Fix local endpoint replacement
      rxrpc: Fix local refcounting

Dexuan Cui (1):
      Drivers: hv: vmbus: Fix virt_to_hvpfn() for X86_PAE

Dinh Nguyen (1):
      clk: socfpga: stratix10: fix rate caclulationg for cnt_clks

Dmitry Fomichev (4):
      dm kcopyd: always complete failed jobs
      dm zoned: improve error handling in reclaim
      dm zoned: improve error handling in i/o map code
      dm zoned: properly handle backing device failure

Douglas Anderson (1):
      drm/rockchip: Suspend DP late

Erqi Chen (1):
      ceph: clear page dirty before invalidate page

Greg Kroah-Hartman (1):
      Linux 4.19.69

He Zhe (2):
      perf ftrace: Fix failure to set cpumask when only one cpu is present
      perf cpumap: Fix writing to illegal memory in handling cpumap mask

Henry Burns (2):
      mm/zsmalloc.c: migration can leave pages in ZS_EMPTY indefinitely
      mm/zsmalloc.c: fix race condition in zs_destroy_pool

Ido Schimmel (2):
      selftests: forwarding: gre_multipath: Enable IPv4 forwarding
      selftests: forwarding: gre_multipath: Fix flower filters

Ilya Dryomov (1):
      libceph: fix PG split vs OSD (re)connect race

Ilya Leoshkevich (1):
      selftests/bpf: fix sendmsg6_prog on s390

Ilya Trukhanov (1):
      HID: Add 044f:b320 ThrustMaster, Inc. 2 in 1 DT

Istv=E1n V=E1radi (1):
      HID: quirks: Set the INCREMENT_USAGE_ON_DUPLICATE quirk on Saitek X52

Jason Gerecke (1):
      HID: wacom: Correct distance scale for 2nd-gen Intuos devices

Jeff Layton (1):
      ceph: don't try fill file_lock on unsuccessful GETFILELOCK reply

Jens Axboe (2):
      libata: have ata_scsi_rw_xlat() fail invalid passthrough requests
      libata: add SG safety checks in SFF pio transfers

Jia-Ju Bai (3):
      isdn: mISDN: hfcsusb: Fix possible null-pointer dereferences in start=
_isoc_chain()
      mac80211_hwsim: Fix possible null-pointer dereferences in hwsim_dump_=
radio_nl()
      net: phy: phy_led_triggers: Fix a possible null-pointer dereference i=
n phy_led_trigger_change_speed()

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

Jose Abreu (2):
      net: stmmac: Fix issues when number of Queues >=3D 4
      net: stmmac: tc: Do not return a fragment entry

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix rename concurrency with listing

Juliana Rodrigueiro (1):
      isdn: hfcsusb: Fix mISDN driver crash caused by transfer buffer on th=
e stack

Lyude Paul (1):
      drm/nouveau: Don't retry infinitely when receiving no data on i2c ove=
r AUX

Marc Zyngier (2):
      KVM: arm64: Don't write junk to sysregs on reset
      KVM: arm: Don't write junk to CP15 registers on reset

Maxime Chevallier (1):
      net: mvpp2: Don't check for 3 consecutive Idle frames for 10G links

Michael Kelley (1):
      genirq: Properly pair kobject_del() with kobject_add()

Michal Kalderon (1):
      qed: RDMA - Fix the hw_ver returned in device attributes

Mikulas Patocka (3):
      Revert "dm bufio: fix deadlock with loop device"
      dm integrity: fix a crash due to BUG_ON in __journal_read_write()
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

Paolo Valente (1):
      block, bfq: handle NULL return value by bfq_init_rq()

Pavel Shilovsky (1):
      SMB3: Fix potential memory leak when processing compound chain

Peter Ujfalusi (1):
      ASoC: ti: davinci-mcasp: Correct slot_width posed constraint

Rasmus Villemoes (1):
      can: dev: call netif_carrier_off() in register_candev()

Ricard Wanderlof (1):
      ASoC: Fail card instantiation if DAI format setup fails

Sean Christopherson (1):
      x86/retpoline: Don't clobber RFLAGS during CALL_NOSPEC on i386

Sebastien Tisserant (1):
      SMB3: Kernel oops mounting a encryptData share with CONFIG_DEBUG_VIRT=
UAL

Stefano Brivio (2):
      netfilter: ipset: Actually allow destination MAC address for hash:ip,=
mac sets too
      netfilter: ipset: Copy the right MAC address in bitmap:ip,mac and has=
h:ip,mac sets

Thomas Bogendoerfer (1):
      MIPS: kernel: only use i8253 clocksource with periodic clockevent

Thomas Falcon (1):
      bonding: Force slave speed check after link state recovery for 802.3ad

Thomas Gleixner (1):
      x86/apic: Handle missing global clockevent gracefully

Tom Lendacky (1):
      x86/CPU/AMD: Clear RDRAND CPUID bit on AMD family 15h/16h

Trond Myklebust (2):
      NFSv4: Fix a potential sleep while atomic in nfs4_do_reclaim()
      NFS: Fix regression whereby fscache errors are appearing on 'nofsc' m=
ounts

Valdis Kletnieks (1):
      x86/lib/cpu: Address missing prototypes warning

Vasily Gorbik (1):
      s390: put _stext and _etext into .text section

Vladimir Kondratiev (1):
      mips: fix cacheinfo

Vlastimil Babka (1):
      mm, page_owner: handle THP splits correctly

Wang Xiayang (3):
      can: sja1000: force the string buffer NULL-terminated
      can: peak_usb: force the string buffer NULL-terminated
      net/ethernet/qlogic/qed: force the string buffer NULL-terminated

Weitao Hou (1):
      can: mcp251x: add error check when wq alloc failed

Wenwen Wang (2):
      netfilter: ebtables: fix a memory leak bug in compat
      dm raid: add missing cleanup in raid_ctr()

YueHaibing (1):
      can: gw: Fix error path of cgw_module_init

ZhangXiaoxu (2):
      dm btree: fix order of block initialization in btree_split_beneath
      dm space map metadata: fix missing store of apply_bops() return value


--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1ntmYACgkQONu9yGCS
aT7aYQ/+MGnyLchsVYZ0WhhlJGWLr5lPXyJ5Lk1Vbawy+WM5hiTrjdElqZzW5R7L
/0IlooMxCrf3jbuffS47VqeXX3+FC6uOeGVQCArQAd3CHu+TOih1sogURMSVxxNy
bPOy+nxnQKHefZDYHo6WzP75MGWRmrYCqmvDyvUKV4KCkkjbiHzOdX8E5MXhQBk6
7zY4YrtaucJuMuP2OiMopanXGHz8ULe6tZ5EeSK3MpLZbHhhiCCbL7UENYMVFviu
SiH5Imz5AWDKkivGsvswbNxRbeNdBAqPtjNO16hhyhrAr3e1pONFhuUZ6ovcBBsQ
9MS+D2TAtZAS1ItNJU9csn9jWryx8iyBpoMO/Czts21w/kszMA1v9QYdhJ9TbQrH
xQuf1m7yIS4NF5lNPu7uggUqX5OEJjVMirsZoLtR93s4YgXb+vj4ai7JV5Ur7Aam
uiEYLiM8tHz0xGuP2t8wdk4/EHMg1BCiTqqJdHzLOXkP0IzPU1Ou+/ItO6SyepIG
UNTnbGPqtXJPBEQNDo0c2Y3QHnU8lqLjQGFBMLpyEwkuYpBlNHVnEENM8nGGmpNt
eK7bWb1b5ABdQ9Bfz5rz5T80nGdq1uMSxtieGB9JkC+ABjPM4cAKoSYd0xTqzSbn
le6QWZOrvIFS981JD53qB+BCyLycBkUai2HDu/BLEXoK8Ykn0Gw=
=aXAr
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
