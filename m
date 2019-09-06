Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4250EAB993
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 15:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393415AbfIFNqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 09:46:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393403AbfIFNqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Sep 2019 09:46:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24E54206B8;
        Fri,  6 Sep 2019 13:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567777575;
        bh=oDpwK6L9z/ttrTZSW3mflxlnbdIZZNQ4rlUuLabp2Ac=;
        h=Date:From:To:Cc:Subject:From;
        b=P92lu4ba7i9iuRY6DtreIp9MIVSIKNLLcNko4DSqnVkfi3S5xI49CgEwt4mEs9rSg
         oJJfJjxSTv2m8bWnIBcrFIKPkYyyOGqpcCv0cIKz9IZ/b2fGxNpSLbqRyHrf0AwQnw
         zBX/mFJkCpQ6CoBEY0eSbxJK/qmFC9hy4Du7Q0Ls=
Date:   Fri, 6 Sep 2019 15:46:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.191
Message-ID: <20190906134613.GA6845@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.191 kernel.

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

 Documentation/kernel-parameters.txt                |    7 +
 Makefile                                           |    2=20
 arch/mips/kernel/i8253.c                           |    3=20
 arch/x86/include/asm/bootparam_utils.h             |   60 +++++++++++---
 arch/x86/include/asm/msr-index.h                   |    1=20
 arch/x86/include/asm/nospec-branch.h               |    2=20
 arch/x86/include/asm/ptrace.h                      |    6 +
 arch/x86/kernel/apic/apic.c                        |   72 +++++++++++++----
 arch/x86/kernel/apic/bigsmp_32.c                   |   24 -----
 arch/x86/kernel/cpu/amd.c                          |   66 ++++++++++++++++
 arch/x86/kernel/ptrace.c                           |    3=20
 arch/x86/kernel/uprobes.c                          |   17 ++--
 arch/x86/kvm/x86.c                                 |    9 +-
 arch/x86/lib/cpu.c                                 |    1=20
 arch/x86/power/cpu.c                               |   86 ++++++++++++++++=
+----
 drivers/ata/libata-sff.c                           |    6 +
 drivers/block/xen-blkback/xenbus.c                 |    6 -
 drivers/dma/ste_dma40.c                            |    4=20
 drivers/gpio/gpiolib.c                             |    6 -
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                |    4=20
 drivers/hid/hid-a4tech.c                           |   30 ++++++-
 drivers/hid/hid-tmff.c                             |   12 ++
 drivers/hid/wacom_wac.c                            |    4=20
 drivers/hwtracing/stm/core.c                       |    1=20
 drivers/i2c/busses/i2c-emev2.c                     |   16 ++-
 drivers/i2c/busses/i2c-piix4.c                     |   12 +-
 drivers/iommu/dma-iommu.c                          |    2=20
 drivers/isdn/hardware/mISDN/hfcsusb.c              |   13 ++-
 drivers/md/dm-bufio.c                              |    4=20
 drivers/md/dm-table.c                              |    5 -
 drivers/md/persistent-data/dm-btree.c              |   31 +++----
 drivers/md/persistent-data/dm-space-map-metadata.c |    2=20
 drivers/misc/vmw_vmci/vmci_doorbell.c              |    6 -
 drivers/mmc/core/sd.c                              |    6 +
 drivers/mmc/host/sdhci-of-at91.c                   |    3=20
 drivers/net/bonding/bond_main.c                    |    9 ++
 drivers/net/can/dev.c                              |    2=20
 drivers/net/can/sja1000/peak_pcmcia.c              |    2=20
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |    2=20
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |    5 -
 drivers/net/ethernet/hisilicon/hip04_eth.c         |   28 +++---
 drivers/net/usb/qmi_wwan.c                         |    1=20
 drivers/nfc/st-nci/se.c                            |    2=20
 drivers/nfc/st21nfca/se.c                          |    2=20
 drivers/scsi/ufs/unipro.h                          |    2=20
 drivers/usb/chipidea/udc.c                         |   32 +++++--
 drivers/usb/class/cdc-wdm.c                        |   16 ++-
 drivers/usb/gadget/composite.c                     |    1=20
 drivers/usb/host/fotg210-hcd.c                     |    4=20
 drivers/usb/host/ohci-hcd.c                        |   15 ++-
 drivers/usb/host/xhci-rcar.c                       |    2=20
 drivers/usb/storage/realtek_cr.c                   |   15 ++-
 drivers/usb/storage/unusual_devs.h                 |    2=20
 drivers/watchdog/bcm2835_wdt.c                     |    1=20
 fs/nfs/nfs4_fs.h                                   |    3=20
 fs/nfs/nfs4client.c                                |    5 -
 fs/nfs/nfs4state.c                                 |   27 +++++-
 fs/userfaultfd.c                                   |   25 +++---
 fs/xfs/xfs_iops.c                                  |    1=20
 include/net/tcp.h                                  |    4=20
 kernel/irq/irqdesc.c                               |   15 +++
 mm/huge_memory.c                                   |    4=20
 mm/zsmalloc.c                                      |   80 ++++++++++++++++=
++-
 net/bridge/netfilter/ebtables.c                    |    4=20
 net/core/stream.c                                  |   16 ++-
 net/mac80211/cfg.c                                 |    9 +-
 net/wireless/reg.c                                 |    2=20
 sound/core/seq/seq_clientmgr.c                     |    3=20
 sound/core/seq/seq_fifo.c                          |   17 ++++
 sound/core/seq/seq_fifo.h                          |    2=20
 sound/soc/davinci/davinci-mcasp.c                  |   43 ++++++++--
 sound/soc/soc-dapm.c                               |    8 -
 sound/usb/line6/pcm.c                              |   18 ++--
 sound/usb/mixer.c                                  |   30 ++++++-
 tools/hv/hv_kvp_daemon.c                           |    2=20
 tools/hv/hv_vss_daemon.c                           |    2=20
 tools/perf/bench/numa.c                            |    6 -
 tools/perf/pmu-events/jevents.c                    |    1=20
 tools/perf/tests/parse-events.c                    |   27 ------
 tools/testing/selftests/kvm/config                 |    3=20
 virt/kvm/arm/vgic/vgic-mmio.c                      |   18 ++++
 virt/kvm/arm/vgic/vgic-v2.c                        |    5 -
 virt/kvm/arm/vgic/vgic-v3.c                        |    5 -
 virt/kvm/arm/vgic/vgic.c                           |    7 +
 84 files changed, 804 insertions(+), 263 deletions(-)

Aaron Armstrong Skomra (1):
      HID: wacom: correct misreported EKR ring values

Adrian Vladu (1):
      tools: hv: fix KVP and VSS daemons exit code

Andrew Cooks (1):
      i2c: piix4: Fix port selection for AMD Family 16h Model 30h

Andrew Morton (1):
      mm/zsmalloc.c: fix build when CONFIG_COMPACTION=3Dn

Arnd Bergmann (1):
      dmaengine: ste_dma40: fix unneeded variable warning

Bandan Das (2):
      x86/apic: Do not initialize LDR and DFR for bigsmp
      x86/apic: Include the LDR when clearing out APIC registers

Bartosz Golaszewski (1):
      gpiolib: never report open-drain/source lines as 'input' to user-space

Benjamin Herrenschmidt (1):
      usb: gadget: composite: Clear "suspended" on reset/disconnect

Bob Ham (1):
      net: usb: qmi_wwan: Add the BroadMobi BM818 card

Charles Keepax (1):
      ASoC: dapm: Fix handling of custom_stop_condition on DAPM graph walks

Christophe JAILLET (1):
      net: cxgb3_main: Fix a resource leak in a error path in 'init_one()'

Colin Ian King (1):
      drm/vmwgfx: fix memory leak when too many retries have occurred

Darrick J. Wong (1):
      xfs: fix missing ILOCK unlock when xfs_setattr_nonsize fails due to E=
DQUOT

Ding Xiang (1):
      stm class: Fix a double free of stm_source_device

Eric Dumazet (1):
      tcp: make sure EPOLLOUT wont be missed

Eugen Hristev (1):
      mmc: sdhci-of-at91: add quirk for broken HS200

Geert Uytterhoeven (1):
      usb: host: xhci: rcar: Fix typo in compatible string matching

Greg Kroah-Hartman (2):
      x86/ptrace: fix up botched merge of spectrev1 fix
      Linux 4.9.191

Hans Ulli Kroll (1):
      usb: host: fotg2: restart hcd after port reset

Henk van der Laan (1):
      usb-storage: Add new JMS567 revision to unusual_devs

Henry Burns (2):
      mm/zsmalloc.c: migration can leave pages in ZS_EMPTY indefinitely
      mm/zsmalloc.c: fix race condition in zs_destroy_pool

Heyi Guo (1):
      KVM: arm/arm64: vgic: Fix potential deadlock when ap_list is long

Hodaszi, Robert (1):
      Revert "cfg80211: fix processing world regdomain when non modular"

Hui Peng (2):
      ALSA: usb-audio: Fix a stack buffer overflow bug in check_input_term
      ALSA: usb-audio: Fix an OOB bug in parse_audio_mixer_unit

Ilya Trukhanov (1):
      HID: Add 044f:b320 ThrustMaster, Inc. 2 in 1 DT

Jason Gerecke (1):
      HID: wacom: Correct distance scale for 2nd-gen Intuos devices

Jens Axboe (1):
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

Johannes Berg (1):
      mac80211: fix possible sta leak

John Hubbard (2):
      x86/boot: Save fields explicitly, zero out everything else
      x86/boot: Fix boot regression caused by bootparam sanitizing

Juliana Rodrigueiro (1):
      isdn: hfcsusb: Fix mISDN driver crash caused by transfer buffer on th=
e stack

Kai-Heng Feng (2):
      USB: storage: ums-realtek: Update module parameter description for au=
to_delink_en
      USB: storage: ums-realtek: Whitelist auto-delink support

Marc Zyngier (1):
      KVM: arm/arm64: vgic-v2: Handle SGI bits in GICD_I{S,C}PENDR0 as WI

Michael Kelley (1):
      genirq: Properly pair kobject_del() with kobject_add()

Mikulas Patocka (2):
      Revert "dm bufio: fix deadlock with loop device"
      dm table: fix invalid memory accesses with too high sector number

Nadav Amit (1):
      VMCI: Release resource if the work is already queued

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

Oliver Neukum (1):
      USB: cdc-wdm: fix race between write and disconnect due to flag abuse

Pedro Sousa (1):
      scsi: ufs: Fix RX_TERMINATION_FORCE_ENABLE define value

Peter Chen (1):
      usb: chipidea: udc: don't do hardware access if gadget has stopped

Peter Ujfalusi (1):
      ASoC: ti: davinci-mcasp: Correct slot_width posed constraint

Rasmus Villemoes (1):
      can: dev: call netif_carrier_off() in register_candev()

Ricardo Neri (1):
      ptrace,x86: Make user_64bit_mode() available to 32-bit builds

Robin Murphy (1):
      iommu/dma: Handle SG length overflow better

Sasha Levin (1):
      Revert "perf test 6: Fix missing kvm module load for s390"

Sean Christopherson (2):
      x86/retpoline: Don't clobber RFLAGS during CALL_NOSPEC on i386
      KVM: x86: Don't update RIP or do single-step on faulting emulation

Sebastian Mayr (1):
      uprobes/x86: Fix detection of 32-bit user mode

Stefan Wahren (1):
      watchdog: bcm2835_wdt: Fix module autoload

Takashi Iwai (2):
      ALSA: line6: Fix memory leak at line6_init_pcm() error path
      ALSA: seq: Fix potential concurrent access to the deleted pool

Thomas Bogendoerfer (1):
      MIPS: kernel: only use i8253 clocksource with periodic clockevent

Thomas Falcon (1):
      bonding: Force slave speed check after link state recovery for 802.3ad

Thomas Gleixner (1):
      x86/apic: Handle missing global clockevent gracefully

Tim Froidcoeur (1):
      tcp: fix tcp_rtx_queue_tail in case of empty retransmit queue

Tom Lendacky (1):
      x86/CPU/AMD: Clear RDRAND CPUID bit on AMD family 15h/16h

Trond Myklebust (1):
      NFSv4: Fix a potential sleep while atomic in nfs4_do_reclaim()

Ulf Hansson (1):
      mmc: core: Fix init of SD cards reporting an invalid VDD range

Valdis Kletnieks (1):
      x86/lib/cpu: Address missing prototypes warning

Vlastimil Babka (1):
      mm, page_owner: handle THP splits correctly

Wang Xiayang (2):
      can: sja1000: force the string buffer NULL-terminated
      can: peak_usb: force the string buffer NULL-terminated

Wenwen Wang (2):
      netfilter: ebtables: fix a memory leak bug in compat
      xen/blkback: fix memory leaks

Wolfram Sang (1):
      i2c: emev2: avoid race when unregistering slave client

Yoshihiro Shimoda (1):
      usb: host: ohci: fix a race condition between shutdown and irq

ZhangXiaoxu (2):
      dm btree: fix order of block initialization in btree_split_beneath
      dm space map metadata: fix missing store of apply_bops() return value


--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1yYyIACgkQONu9yGCS
aT7DuRAAqH4E5DbcDbSlISUaPR443G/03zYLDPyebTtsSVSgUTiW2yx1EtysIRZE
9/asjwyZLgd0pmx8w+SFEVLvjssUs4xJNlQlE3CloGsbiknOzeTldXPA7fIHdPkI
LYby23F7iMDwatKivbF5Uo2JTvZOSNozpa2Xw+JJOy14fVJU625Q4HZIDJrARixb
+Ap4F6vXs8tHhc6owksJA6nKBSuDW0hiv6ghnFTHMazENq6sG6kAIzv+s7Lkghrt
BfyXTulDBsEpm++ywm/a4UMHlHjQi1vfS4uDZAgAHFF0dK5oPQ2XI0Qw42b4OXSk
aecfBXX7oa+M53pIdtUM+U7qFpfxa5e3ynLZxqrP90TzUvWFUmrz/9ChsgVeZCh4
LRvMZR5MGVLU3A02CSRAhvDygPRhvx2E/E2U4qr5Sot7g2ypuqIHE3CD3Yzoj/+1
DHJ31S/VEzHgdR3JHAu2UQWDRAcsu6FnCZJnHMEKTeohrBL/16yMc4SYf/WOyuYp
zjl4hTfJ33329uN02b/q/1O+XPeA92kA+LcPHavhc5xpC1xhk+BrVVo84qsmlQov
JzjOhBZajchOcGlaAEgc4lmtvXiZ1ERBoV+TxNWZVQtuwYMLdKp9XkhhUPLLbE0M
eaVSYCTFVswTpoyDGlEhVyYBPIrUSqn/veJNzTZPkC8nbW8nKek=
=E5Qt
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
