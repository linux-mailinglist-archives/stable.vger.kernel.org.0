Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF39A186D
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbfH2L05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:26:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbfH2L05 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 07:26:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D9E922CF5;
        Thu, 29 Aug 2019 11:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567078015;
        bh=GEF6S5EtBR5btYibk2nRFFa43N2wCTcQFichDEfeq8o=;
        h=Date:From:To:Cc:Subject:From;
        b=hpX46rcqaXSbHYPAQ6cP9IKqw+TOOeWyEjobf+bGOzSqqEeP0KfZke1+XgqibzWfu
         mTEYsGrj4Ty4+ebtCqSlT6t6blVvrbVfsMWDvEj0JHRMQozkRY5cbCIuW29C4lWQG+
         l6IegVfMZ1JZtp7LWHH1T9TRbTJa0Bn8jLW4rH/0=
Date:   Thu, 29 Aug 2019 13:26:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.2.11
Message-ID: <20190829112652.GA25049@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.2.11 kernel.

All users of the 5.2 kernel series must upgrade.

The updated 5.2.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.2.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt         |    7 +
 Documentation/devicetree/bindings/riscv/sifive.yaml     |    2=20
 Makefile                                                |    2=20
 arch/arm/kvm/coproc.c                                   |   23 ++-
 arch/arm64/kvm/sys_regs.c                               |   32 ++--
 arch/mips/kernel/cacheinfo.c                            |    2=20
 arch/mips/kernel/i8253.c                                |    3=20
 arch/powerpc/kernel/misc_64.S                           |    4=20
 arch/s390/boot/ipl_parm.c                               |    2=20
 arch/s390/kernel/ipl.c                                  |    9 -
 arch/s390/kernel/vmlinux.lds.S                          |   10 -
 arch/s390/mm/dump_pagetables.c                          |   12 -
 arch/x86/include/asm/bootparam_utils.h                  |   63 +++++++--
 arch/x86/include/asm/msr-index.h                        |    1=20
 arch/x86/include/asm/nospec-branch.h                    |    2=20
 arch/x86/kernel/apic/apic.c                             |   68 ++++++++--
 arch/x86/kernel/cpu/amd.c                               |   66 ++++++++++
 arch/x86/kvm/mmu.c                                      |   33 -----
 arch/x86/lib/cpu.c                                      |    1=20
 arch/x86/power/cpu.c                                    |   86 +++++++++++=
--
 block/bfq-iosched.c                                     |   14 +-
 drivers/ata/libata-scsi.c                               |   21 +++
 drivers/ata/libata-sff.c                                |    6=20
 drivers/ata/pata_rb532_cf.c                             |    1=20
 drivers/block/aoe/aoedev.c                              |   13 +-
 drivers/clk/socfpga/clk-periph-s10.c                    |    2=20
 drivers/gpio/gpiolib.c                                  |    6=20
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c                   |   40 ++++++
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                   |    4=20
 drivers/gpu/drm/amd/amdgpu/soc15.c                      |    5=20
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c           |   24 ++-
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c         |    2=20
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                     |    4=20
 drivers/hid/hid-a4tech.c                                |   30 ++++
 drivers/hid/hid-ids.h                                   |    1=20
 drivers/hid/hid-logitech-hidpp.c                        |   32 ++++
 drivers/hid/hid-quirks.c                                |    1=20
 drivers/hid/hid-tmff.c                                  |   12 +
 drivers/hid/wacom_wac.c                                 |    4=20
 drivers/hv/channel.c                                    |    2=20
 drivers/infiniband/hw/hfi1/tid_rdma.c                   |   77 ++++-------
 drivers/isdn/hardware/mISDN/hfcsusb.c                   |   13 +-
 drivers/md/dm-bufio.c                                   |    4=20
 drivers/md/dm-dust.c                                    |   11 +
 drivers/md/dm-integrity.c                               |   15 ++
 drivers/md/dm-kcopyd.c                                  |    5=20
 drivers/md/dm-raid.c                                    |    2=20
 drivers/md/dm-table.c                                   |    5=20
 drivers/md/dm-zoned-metadata.c                          |   59 ++++++---
 drivers/md/dm-zoned-reclaim.c                           |   44 +++++-
 drivers/md/dm-zoned-target.c                            |   67 +++++++++-
 drivers/md/dm-zoned.h                                   |   10 +
 drivers/md/persistent-data/dm-btree.c                   |   31 ++--
 drivers/md/persistent-data/dm-space-map-metadata.c      |    2=20
 drivers/misc/habanalabs/firmware_if.c                   |   19 --
 drivers/net/bonding/bond_main.c                         |    9 +
 drivers/net/can/dev.c                                   |    2=20
 drivers/net/can/sja1000/peak_pcmcia.c                   |    2=20
 drivers/net/can/spi/mcp251x.c                           |   49 +++----
 drivers/net/can/usb/peak_usb/pcan_usb_core.c            |    2=20
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c         |    5=20
 drivers/net/ethernet/freescale/enetc/Kconfig            |    2=20
 drivers/net/ethernet/hisilicon/hip04_eth.c              |   28 ++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c         |    6=20
 drivers/net/ethernet/qlogic/qed/qed_int.c               |    2=20
 drivers/net/ethernet/qlogic/qed/qed_rdma.c              |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c       |    4=20
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c     |    4=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c   |    7 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c         |    2=20
 drivers/net/phy/phy_led_triggers.c                      |    3=20
 drivers/net/usb/qmi_wwan.c                              |    1=20
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c            |    4=20
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c       |   53 ++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h            |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c             |   65 +++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h             |    7 -
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c            |    8 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h            |    1=20
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c          |    4=20
 drivers/net/wireless/mac80211_hwsim.c                   |    8 -
 drivers/nfc/st-nci/se.c                                 |    2=20
 drivers/nfc/st21nfca/se.c                               |    2=20
 drivers/nvmem/nvmem-sysfs.c                             |   15 +-
 drivers/regulator/axp20x-regulator.c                    |   10 -
 drivers/scsi/ufs/ufshcd.c                               |    3=20
 drivers/spi/spi-pxa2xx.c                                |   14 +-
 drivers/staging/fbtft/fb_bd663474.c                     |    2=20
 drivers/staging/fbtft/fb_ili9163.c                      |    2=20
 drivers/staging/fbtft/fb_ili9325.c                      |    2=20
 drivers/staging/fbtft/fb_s6d1121.c                      |    2=20
 drivers/staging/fbtft/fb_ssd1289.c                      |    2=20
 drivers/staging/fbtft/fb_ssd1331.c                      |    4=20
 drivers/staging/fbtft/fb_upd161704.c                    |    2=20
 drivers/staging/fbtft/fbtft-bus.c                       |    2=20
 drivers/staging/fbtft/fbtft-core.c                      |    4=20
 fs/ceph/addr.c                                          |    5=20
 fs/ceph/locks.c                                         |    3=20
 fs/cifs/smb2ops.c                                       |   39 ++++--
 fs/io_uring.c                                           |   66 +++++++---
 fs/nfs/delegation.c                                     |   23 ++-
 fs/nfs/fscache.c                                        |    7 -
 fs/nfs/fscache.h                                        |    2=20
 fs/nfs/nfs4_fs.h                                        |    3=20
 fs/nfs/nfs4client.c                                     |    5=20
 fs/nfs/nfs4proc.c                                       |   70 ++++++----
 fs/nfs/nfs4state.c                                      |   43 +++++-
 fs/nfs/super.c                                          |    1=20
 fs/userfaultfd.c                                        |   25 ++-
 fs/xfs/xfs_iops.c                                       |    1=20
 include/net/cfg80211.h                                  |   15 ++
 include/sound/simple_card_utils.h                       |    4=20
 include/trace/events/rxrpc.h                            |    6=20
 include/uapi/sound/sof/fw.h                             |   16 +-
 include/uapi/sound/sof/header.h                         |   14 +-
 kernel/irq/irqdesc.c                                    |   15 ++
 kernel/sched/deadline.c                                 |    8 -
 kernel/sched/psi.c                                      |   12 +
 mm/huge_memory.c                                        |    4=20
 mm/kasan/common.c                                       |   10 +
 mm/memcontrol.c                                         |   60 +++++++++
 mm/page_alloc.c                                         |   19 --
 mm/z3fold.c                                             |   89 +++++++++++=
++
 mm/zsmalloc.c                                           |   78 +++++++++++-
 net/bridge/netfilter/ebtables.c                         |    4=20
 net/can/gw.c                                            |   48 +++++--
 net/ceph/osd_client.c                                   |    9 -
 net/core/sock_map.c                                     |   19 ++
 net/mac80211/util.c                                     |    7 -
 net/netfilter/ipset/ip_set_bitmap_ipmac.c               |    2=20
 net/netfilter/ipset/ip_set_core.c                       |    2=20
 net/netfilter/ipset/ip_set_hash_ipmac.c                 |    6=20
 net/rxrpc/af_rxrpc.c                                    |    4=20
 net/rxrpc/ar-internal.h                                 |    6=20
 net/rxrpc/input.c                                       |   16 +-
 net/rxrpc/local_object.c                                |  103 +++++++++--=
-----
 net/rxrpc/peer_event.c                                  |    2=20
 net/rxrpc/peer_object.c                                 |   18 ++
 net/rxrpc/sendmsg.c                                     |    1=20
 net/wireless/core.c                                     |    6=20
 net/wireless/nl80211.c                                  |    4=20
 net/wireless/util.c                                     |   27 +++-
 sound/soc/amd/raven/acp3x-pcm-dma.c                     |    6=20
 sound/soc/generic/audio-graph-card.c                    |   30 ++--
 sound/soc/generic/simple-card.c                         |   26 ++--
 sound/soc/intel/boards/bytcht_es8316.c                  |    8 +
 sound/soc/rockchip/rockchip_i2s.c                       |    5=20
 sound/soc/samsung/odroid.c                              |    8 -
 sound/soc/soc-core.c                                    |    7 -
 sound/soc/soc-dapm.c                                    |   10 -
 sound/soc/ti/davinci-mcasp.c                            |   46 +++++--
 tools/lib/bpf/libbpf.c                                  |    9 +
 tools/lib/bpf/xsk.c                                     |   11 -
 tools/perf/bench/numa.c                                 |    6=20
 tools/perf/builtin-ftrace.c                             |    2=20
 tools/perf/pmu-events/jevents.c                         |    1=20
 tools/perf/util/cpumap.c                                |    5=20
 tools/testing/selftests/bpf/progs/sendmsg6_prog.c       |    3=20
 tools/testing/selftests/bpf/verifier/ctx_skb.c          |   11 +
 tools/testing/selftests/kvm/config                      |    3=20
 tools/testing/selftests/net/forwarding/gre_multipath.sh |   28 ++--
 161 files changed, 1816 insertions(+), 702 deletions(-)

Aaron Armstrong Skomra (1):
      HID: wacom: correct misreported EKR ring values

Adrian Hunter (1):
      scsi: ufs: Fix NULL pointer dereference in ufshcd_config_vreg_hpm()

Alastair D'Silva (1):
      powerpc: Allow flush_(inval_)dcache_range to work across ranges >4GB

Alex Deucher (1):
      drm/amdgpu/gfx9: update pg_flags after determining if gfx off is poss=
ible

Andrey Ryabinin (1):
      mm/kasan: fix false positive invalid-free reports with CONFIG_KASAN_S=
W_TAGS=3Dy

Andrii Nakryiko (2):
      libbpf: sanitize VAR to conservative 1-byte INT
      libbpf: silence GCC8 warning about string truncation

Bartosz Golaszewski (1):
      gpiolib: never report open-drain/source lines as 'input' to user-space

Ben Segal (1):
      habanalabs: fix F/W download in BE architecture

Bob Ham (1):
      net: usb: qmi_wwan: Add the BroadMobi BM818 card

Bryan Gurney (1):
      dm dust: use dust block size for badblocklist index

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

Darrick J. Wong (1):
      xfs: fix missing ILOCK unlock when xfs_setattr_nonsize fails due to E=
DQUOT

David Howells (6):
      rxrpc: Fix potential deadlock
      rxrpc: Fix the lack of notification when sendmsg() fails on a DATA pa=
cket
      rxrpc: Fix local endpoint refcounting
      rxrpc: Fix read-after-free in rxrpc_queue_local()
      rxrpc: Fix local endpoint replacement
      rxrpc: Fix local refcounting

David Rientjes (1):
      mm, page_alloc: move_freepages should not examine struct page of rese=
rved memory

Dexuan Cui (1):
      Drivers: hv: vmbus: Fix virt_to_hvpfn() for X86_PAE

Dietmar Eggemann (1):
      sched/deadline: Fix double accounting of rq/running bw in push & pull

Dinh Nguyen (1):
      clk: socfpga: stratix10: fix rate caclulationg for cnt_clks

Dmitry Fomichev (4):
      dm kcopyd: always complete failed jobs
      dm zoned: improve error handling in reclaim
      dm zoned: improve error handling in i/o map code
      dm zoned: properly handle backing device failure

Douglas Anderson (1):
      drm/rockchip: Suspend DP late

Eric Dumazet (1):
      selftests/bpf: add another gso_segs access

Erqi Chen (1):
      ceph: clear page dirty before invalidate page

Filipe La=EDns (1):
      HID: logitech-hidpp: add USB PID for a few more supported mice

Greg Kroah-Hartman (1):
      Linux 5.2.11

Gregory Greenman (1):
      iwlwifi: mvm: send LQ command always ASYNC

Gustavo A. R. Silva (1):
      ata: rb532_cf: Fix unused variable warning in rb532_pata_driver_probe

Hans de Goede (1):
      ASoC: Intel: bytcht_es8316: Add quirk for Irbis NB41 netbook

He Zhe (3):
      block: aoe: Fix kernel crash due to atomic sleep when exiting
      perf ftrace: Fix failure to set cpumask when only one cpu is present
      perf cpumap: Fix writing to illegal memory in handling cpumap mask

Henry Burns (3):
      mm/z3fold.c: fix race between migration and destruction
      mm/zsmalloc.c: migration can leave pages in ZS_EMPTY indefinitely
      mm/zsmalloc.c: fix race condition in zs_destroy_pool

Ido Schimmel (2):
      selftests: forwarding: gre_multipath: Enable IPv4 forwarding
      selftests: forwarding: gre_multipath: Fix flower filters

Ilya Dryomov (1):
      libceph: fix PG split vs OSD (re)connect race

Ilya Leoshkevich (1):
      selftests/bpf: fix sendmsg6_prog on s390

Ilya Maximets (1):
      libbpf: fix using uninitialized ioctl results

Ilya Trukhanov (1):
      HID: Add 044f:b320 ThrustMaster, Inc. 2 in 1 DT

Istv=E1n V=E1radi (1):
      HID: quirks: Set the INCREMENT_USAGE_ON_DUPLICATE quirk on Saitek X52

Jan Sebastian G=F6tte (1):
      Staging: fbtft: Fix GPIO handling

Jarkko Nikula (1):
      spi: pxa2xx: Add support for Intel Tiger Lake

Jason Gerecke (1):
      HID: wacom: Correct distance scale for 2nd-gen Intuos devices

Jason Xing (1):
      psi: get poll_work to run when calling poll syscall next time

Jean Delvare (1):
      nvmem: Use the same permissions for eeprom as for nvmem

Jeff Layton (1):
      ceph: don't try fill file_lock on unsuccessful GETFILELOCK reply

Jens Axboe (5):
      libata: have ata_scsi_rw_xlat() fail invalid passthrough requests
      libata: add SG safety checks in SFF pio transfers
      io_uring: fix potential hang with polled IO
      io_uring: don't enter poll loop if we have CQEs pending
      io_uring: add need_resched() check in inner poll loop

Jernej Skrabec (2):
      regulator: axp20x: fix DCDCA and DCDCD for AXP806
      regulator: axp20x: fix DCDC5 and DCDC6 for AXP803

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

Johannes Berg (2):
      iwlwifi: fix locking in delayed GTK setting
      iwlwifi: mvm: disable TX-AMSDU on older NICs

John Fastabend (3):
      bpf: sockmap, sock_map_delete needs to use xchg
      bpf: sockmap, synchronize_rcu before free'ing map
      bpf: sockmap, only create entry if ulp is not already enabled

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

Kaike Wan (5):
      IB/hfi1: Unsafe PSN checking for TID RDMA READ Resp packet
      IB/hfi1: Add additional checks when handling TID RDMA READ RESP packet
      IB/hfi1: Add additional checks when handling TID RDMA WRITE DATA pack=
et
      IB/hfi1: Drop stale TID RDMA packets that cause TIDErr
      IB/hfi1: Drop stale TID RDMA packets

Kuninori Morimoto (2):
      ASoC: simple_card_utils.h: care NULL dai at asoc_simple_debug_dai()
      ASoC: audio-graph-card: add missing const at graph_get_dai_id()

Likun Gao (1):
      drm/amdgpu: pin the csb buffer on hw init for gfx v8

Lubomir Rintel (1):
      spi: pxa2xx: Balance runtime PM enable/disable on error

Lyude Paul (1):
      drm/nouveau: Don't retry infinitely when receiving no data on i2c ove=
r AUX

Manikanta Pubbisetty (1):
      {nl,mac}80211: fix interface combinations on crypto controlled devices

Marc Zyngier (2):
      KVM: arm64: Don't write junk to sysregs on reset
      KVM: arm: Don't write junk to CP15 registers on reset

Martin Blumenstingl (1):
      net: stmmac: manage errors returned by of_get_mac_address()

Masahiro Yamada (1):
      ASoC: SOF: use __u32 instead of uint32_t in uapi headers

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

Mordechay Goodstein (1):
      iwlwifi: mvm: avoid races in rate init and rate perform

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

Paolo Bonzini (1):
      Revert "KVM: x86/mmu: Zap only the relevant pages when removing a mem=
slot"

Paolo Valente (1):
      block, bfq: handle NULL return value by bfq_init_rq()

Paul Walmsley (1):
      dt-bindings: riscv: fix the schema compatible string for the HiFive U=
nleashed board

Pavel Shilovsky (1):
      SMB3: Fix potential memory leak when processing compound chain

Peter Ujfalusi (2):
      ASoC: ti: davinci-mcasp: Fix clk PDIR handling for i2s master mode
      ASoC: ti: davinci-mcasp: Correct slot_width posed constraint

Peter Zijlstra (1):
      sched/psi: Reduce psimon FIFO priority

Rasmus Villemoes (1):
      can: dev: call netif_carrier_off() in register_candev()

Ricard Wanderlof (1):
      ASoC: Fail card instantiation if DAI format setup fails

Roman Gushchin (2):
      mm: memcontrol: flush percpu vmstats before releasing memcg
      mm: memcontrol: flush percpu vmevents before releasing memcg

Sean Christopherson (1):
      x86/retpoline: Don't clobber RFLAGS during CALL_NOSPEC on i386

Sebastien Tisserant (1):
      SMB3: Kernel oops mounting a encryptData share with CONFIG_DEBUG_VIRT=
UAL

Shahar S Matityahu (2):
      iwlwifi: dbg_ini: move iwl_dbg_tlv_load_bin out of debug override ifd=
ef
      iwlwifi: dbg_ini: move iwl_dbg_tlv_free outside of debugfs ifdef

Stefano Brivio (2):
      netfilter: ipset: Actually allow destination MAC address for hash:ip,=
mac sets too
      netfilter: ipset: Copy the right MAC address in bitmap:ip,mac and has=
h:ip,mac sets

Suren Baghdasaryan (1):
      sched/psi: Do not require setsched permission from the trigger creator

Thomas Bogendoerfer (1):
      MIPS: kernel: only use i8253 clocksource with periodic clockevent

Thomas Falcon (1):
      bonding: Force slave speed check after link state recovery for 802.3ad

Thomas Gleixner (1):
      x86/apic: Handle missing global clockevent gracefully

Tom Lendacky (1):
      x86/CPU/AMD: Clear RDRAND CPUID bit on AMD family 15h/16h

Trond Myklebust (7):
      NFSv4: Fix a credential refcount leak in nfs41_check_delegation_state=
id
      NFSv4: When recovering state fails with EAGAIN, retry the same recove=
ry
      NFSv4.1: Fix open stateid recovery
      NFSv4.1: Only reap expired delegations
      NFSv4: Fix a potential sleep while atomic in nfs4_do_reclaim()
      NFS: Fix regression whereby fscache errors are appearing on 'nofsc' m=
ounts
      NFSv4: Ensure state recovery handles ETIMEDOUT correctly

Valdis Kletnieks (1):
      x86/lib/cpu: Address missing prototypes warning

Vasily Gorbik (3):
      s390/protvirt: avoid memory sharing for diag 308 set/store
      s390/mm: fix dump_pagetables top level page table walking
      s390: put _stext and _etext into .text section

Vijendar Mukunda (1):
      ASoC: amd: acp3x: use dma_ops of parent device for acp3x dma driver

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

Wen Yang (6):
      ASoC: simple-card: fix an use-after-free in simple_dai_link_of_dpcm()
      ASoC: simple-card: fix an use-after-free in simple_for_each_link()
      ASoC: audio-graph-card: fix use-after-free in graph_dai_link_of_dpcm()
      ASoC: audio-graph-card: fix an use-after-free in graph_get_dai_id()
      ASoC: samsung: odroid: fix an use-after-free issue for codec
      ASoC: samsung: odroid: fix a double-free issue for cpu_dai

Wenwen Wang (3):
      netfilter: ebtables: fix a memory leak bug in compat
      ASoC: dapm: fix a memory leak bug
      dm raid: add missing cleanup in raid_ctr()

YueHaibing (3):
      can: gw: Fix error path of cgw_module_init
      enetc: Fix build error without PHYLIB
      enetc: Select PHYLIB while CONFIG_FSL_ENETC_VF is set

ZhangXiaoxu (2):
      dm btree: fix order of block initialization in btree_split_beneath
      dm space map metadata: fix missing store of apply_bops() return value


--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1ntnwACgkQONu9yGCS
aT6gjw/7BJHi386isIkdy3/fLf7nESiS2XTESNJDS+S9ulXskfNP3V/9EUXwWi3Z
tme7SG8ZIxdCPmwHGxUnd6ivNc5BV4EGNd+E0acTtzFrdAZlAzzEneAEnPdAR8Zr
131Iyg9nicNz2yNeIvci9Uj5dTig66XX87c8L5X9+lXIyXbGjs2plKvJsTyxNF6G
viGai7G5lVoWI3ZweyB1tEJZXB9y6hBqt9u2/fRy7usgtbsnjauARE3fgDOONaYL
YPV/i6hHm1BIRjHeGiBFfx4PziCjqOszZXfgp/1FCt1hddLQ7fqEzsblfFlwNOdx
nP5ne3mFyeBJATCpa7Vn/fuZB4xBpfF9NQj1pPAkEEvzV2WV4TS3iSM1kxhitypk
gpC1PwQrhTKUosNsz1WCYBO69Kgbw/YuxSpLECWOb7e2D6XEUM6YOy5q3meV8Mi4
C5JGQg65hu9bwofld4hkgM1iXj1fvHrw+YbxIk7uypBUnlGC1ef0/+FIsrN43xun
33doRCTVapNXxj9RciLmk6L2nI3WKoOQyMNV6kkQpUwIYaKfCimZOW19mBd05GYV
Kyvh0KJ0PkxEUCcMfT0aIptXimCN0ZY4/QPYeSJhwLkNW/12ZT4mlGKKme3mc5d9
XTLRg2CmSaeeYbwM9NyoHH8azzGnVJ9+WUvlYbasHSxgYd6BXRY=
=vVhi
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
