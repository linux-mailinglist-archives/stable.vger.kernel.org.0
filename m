Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5B7B9CAC
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 08:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407418AbfIUGgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 02:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407251AbfIUGgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Sep 2019 02:36:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E36120673;
        Sat, 21 Sep 2019 06:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569047769;
        bh=e1WAgk+2fvfnZkFb3Yw08ADRPr4EiUxQlIU5QrnBi4c=;
        h=Date:From:To:Cc:Subject:From;
        b=MPfvT1PpEdNlPbUr0R2JI+RGJ2RpKkDftWR729eSedxAXcy4sOCTnPJcbq/S/BxAY
         qESSaWC5vWxjuXrzpA20odZmVI78sWbgLbyarUyKvjPS4MzXLOOAlHtnFbOyyGgTa+
         +Yi4xpKSrPeY6eDopUZA7zRqxs0yR1ihoiuIbLqo=
Date:   Sat, 21 Sep 2019 08:36:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.75
Message-ID: <20190921063607.GA1083276@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.75 kernel.

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

 Documentation/filesystems/overlayfs.txt                         |    2=20
 Makefile                                                        |    2=20
 arch/arm/boot/dts/am571x-idk.dts                                |    7=20
 arch/arm/boot/dts/am572x-idk.dts                                |    7=20
 arch/arm/boot/dts/am574x-idk.dts                                |    7=20
 arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi                 |    1=20
 arch/arm/boot/dts/am57xx-beagle-x15-revb1.dts                   |    7=20
 arch/arm/boot/dts/am57xx-beagle-x15-revc.dts                    |    7=20
 arch/arm/boot/dts/dra74x-mmc-iodelay.dtsi                       |   50 +++=
---
 arch/arm/mach-omap1/ams-delta-fiq-handler.S                     |    3=20
 arch/arm/mach-omap1/ams-delta-fiq.c                             |    4=20
 arch/arm/mach-omap2/omap4-common.c                              |    3=20
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c                       |    3=20
 arch/arm/mm/init.c                                              |    8 -
 arch/arm64/kernel/cpufeature.c                                  |    6=20
 arch/powerpc/mm/pgtable-radix.c                                 |   16 --
 arch/s390/net/bpf_jit_comp.c                                    |   12 -
 arch/x86/events/amd/ibs.c                                       |   13 +
 arch/x86/events/intel/core.c                                    |    6=20
 arch/x86/hyperv/mmu.c                                           |    8 -
 arch/x86/include/asm/perf_event.h                               |   12 +
 arch/x86/include/asm/uaccess.h                                  |    4=20
 arch/x86/kernel/apic/io_apic.c                                  |    8 -
 drivers/atm/Kconfig                                             |    2=20
 drivers/block/floppy.c                                          |    4=20
 drivers/bus/ti-sysc.c                                           |   19 +-
 drivers/dma/ti/dma-crossbar.c                                   |    4=20
 drivers/dma/ti/omap-dma.c                                       |    4=20
 drivers/firmware/google/vpd.c                                   |    4=20
 drivers/firmware/google/vpd_decode.c                            |   55 +++=
+---
 drivers/firmware/google/vpd_decode.h                            |    6=20
 drivers/fpga/altera-ps-spi.c                                    |   11 -
 drivers/hid/wacom_sys.c                                         |   10 -
 drivers/hid/wacom_wac.c                                         |    4=20
 drivers/i2c/busses/i2c-designware-slave.c                       |    1=20
 drivers/infiniband/core/cma.c                                   |    7=20
 drivers/infiniband/core/restrack.c                              |    6=20
 drivers/input/mouse/elan_i2c_core.c                             |    2=20
 drivers/iommu/amd_iommu.c                                       |   40 +++=
+-
 drivers/media/usb/dvb-usb/technisat-usb2.c                      |   22 +--
 drivers/media/usb/tm6000/tm6000-dvb.c                           |    3=20
 drivers/net/ethernet/amd/xgbe/xgbe-main.c                       |   10 +
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c                 |    3=20
 drivers/net/ethernet/ibm/ibmvnic.c                              |    6=20
 drivers/net/ethernet/marvell/sky2.c                             |    7=20
 drivers/net/ethernet/qlogic/qed/qed_main.c                      |    4=20
 drivers/net/ethernet/seeq/sgiseeq.c                             |    7=20
 drivers/net/ieee802154/mac802154_hwsim.c                        |    8 -
 drivers/net/usb/r8152.c                                         |    5=20
 drivers/net/wireless/marvell/mwifiex/ie.c                       |    3=20
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c                  |    9 +
 drivers/net/xen-netfront.c                                      |    2=20
 drivers/pci/controller/dwc/pcie-kirin.c                         |    4=20
 drivers/phy/renesas/phy-rcar-gen3-usb2.c                        |    2=20
 drivers/tty/serial/atmel_serial.c                               |    1=20
 drivers/tty/serial/sprd_serial.c                                |    2=20
 drivers/usb/core/config.c                                       |   12 +
 drivers/usb/host/xhci-tegra.c                                   |   10 +
 fs/binfmt_elf.c                                                 |   11 +
 fs/cifs/connect.c                                               |   22 +++
 fs/nfs/dir.c                                                    |    2=20
 fs/nfs/nfs4file.c                                               |   12 -
 fs/nfs/pagelist.c                                               |    2=20
 fs/nfs/proc.c                                                   |    7=20
 fs/overlayfs/ovl_entry.h                                        |    1=20
 fs/overlayfs/super.c                                            |   73 +++=
+++----
 include/net/sock_reuseport.h                                    |   21 ++
 include/uapi/linux/netfilter/xt_nfacct.h                        |    5=20
 kernel/kallsyms.c                                               |    6=20
 net/batman-adv/bat_v_ogm.c                                      |   18 +-
 net/bridge/netfilter/ebtables.c                                 |    8 -
 net/core/filter.c                                               |    8 -
 net/core/sock_reuseport.c                                       |   15 +-
 net/ipv4/datagram.c                                             |    2=20
 net/ipv4/udp.c                                                  |    5=20
 net/ipv6/datagram.c                                             |    2=20
 net/ipv6/ip6_gre.c                                              |    2=20
 net/ipv6/udp.c                                                  |    5=20
 net/netfilter/nf_conntrack_ftp.c                                |    2=20
 net/netfilter/nf_flow_table_core.c                              |    2=20
 net/netfilter/nft_flow_offload.c                                |    6=20
 net/netfilter/xt_nfacct.c                                       |   36 +++-
 net/netfilter/xt_physdev.c                                      |    6=20
 net/sched/sch_generic.c                                         |    6=20
 net/wireless/nl80211.c                                          |    4=20
 net/xdp/xdp_umem.c                                              |    4=20
 security/keys/request_key_auth.c                                |    6=20
 tools/bpf/bpftool/prog.c                                        |    4=20
 tools/power/x86/turbostat/turbostat.c                           |    2=20
 tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c |   28 ++-
 tools/testing/selftests/bpf/test_sock.c                         |    7=20
 virt/kvm/coalesced_mmio.c                                       |   17 +-
 92 files changed, 562 insertions(+), 290 deletions(-)

Aaron Armstrong Skomra (1):
      HID: wacom: generic: read HID_DG_CONTACTMAX from any feature report

Alan Stern (1):
      USB: usbcore: Fix slab-out-of-bounds bug during device reset

Amir Goldstein (1):
      ovl: fix regression caused by overlapping layers detection

Aneesh Kumar K.V (1):
      powerpc/mm/radix: Use the right page size for vmemmap mapping

Ben Hutchings (1):
      tools/power x86_energy_perf_policy: Fix "uninitialized variable" warn=
ings at -O2

Benjamin Tissoires (1):
      Input: elan_i2c - remove Lenovo Legion Y7000 PnpID

Christophe JAILLET (2):
      Kconfig: Fix the reference to the IDT77105 Phy driver in the descript=
ion of ATM_NICSTAR_USE_IDT77105
      net: seeq: Fix the function used to release some memory in an error h=
andling path

Chunyan Zhang (1):
      serial: sprd: correct the wrong sequence of arguments

Cong Wang (1):
      net_sched: let qdisc_put() accept NULL pointer

Dan Carpenter (1):
      cifs: Use kzfree() to zero out the password

Dmitry Bogdanov (1):
      net: aquantia: fix out of memory condition on rx side

Dongli Zhang (1):
      xen-netfront: do not assume sk_buff_head list is empty in error handl=
ing

Doug Berger (1):
      ARM: 8874/1: mm: only adjust sections of valid mm structures

Faiz Abbas (2):
      ARM: dts: am57xx: Disable voltage switching for SD card
      ARM: dts: dra74x: Fix iodelay configuration for mmc3

Greg Kroah-Hartman (1):
      Linux 4.19.75

Hillf Danton (1):
      keys: Fix missing null pointer check in request_key_auth_describe()

Hung-Te Lin (1):
      firmware: google: check if size is valid when decoding VPD data

Ilya Leoshkevich (4):
      s390/bpf: fix lcgr instruction encoding
      s390/bpf: use 32-bit index for tail calls
      selftests/bpf: fix "bind{4, 6} deny specific IP & port" on s390
      bpf: allow narrow loads of some sk_reuseport_md fields with offset > 0

Ivan Khoronzhuk (1):
      xdp: unpin xdp umem pages in error path

Jann Horn (1):
      floppy: fix usercopy direction

Janusz Krzysztofik (1):
      ARM: OMAP1: ams-delta-fiq: Fix missing irq_ack

Jarkko Nikula (1):
      i2c: designware: Synchronize IRQs when unregistering slave client

Joerg Roedel (1):
      iommu/amd: Fix race in increase_address_space()

Josh Hunt (1):
      perf/x86/intel: Restrict period on Nehalem

Juliana Rodrigueiro (1):
      netfilter: xt_nfacct: Fix alignment mismatch in xt_nfacct_match_info

Kees Cook (1):
      binfmt_elf: move brk out of mmap when doing direct loader exec

Kim Phillips (1):
      perf/x86/amd/ibs: Fix sample bias for dispatched micro-ops

Leon Romanovsky (1):
      RDMA/restrack: Release task struct which was hold by CM_ID object

Marc Zyngier (1):
      kallsyms: Don't let kallsyms_lookup_size_offset() fail on retrieving =
the first symbol

Masashi Honma (1):
      nl80211: Fix possible Spectre-v1 for CQM RSSI thresholds

Matt Delco (1):
      KVM: coalesced_mmio: add bounds checking

Nagarjuna Kristam (1):
      usb: host: xhci-tegra: Set DMA mask correctly

Naoya Horiguchi (1):
      tools/power turbostat: fix buffer overrun

Nathan Chancellor (1):
      PCI: kirin: Fix section mismatch warning

Pablo Neira Ayuso (2):
      netfilter: nf_flow_table: set default timeout after successful insert=
ion
      netfilter: nft_flow_offload: missing netlink attribute policy

Peter Zijlstra (1):
      x86/uaccess: Don't leak the AC flags into __get_user() argument evalu=
ation

Phil Reid (1):
      fpga: altera-ps-spi: Fix getting of optional confd gpio

Prashant Malani (1):
      r8152: Set memory to all 0xFFs on failed reg reads

Quentin Monnet (1):
      tools: bpftool: close prog FD before exit on showing a single program

Razvan Stefanescu (1):
      tty/serial: atmel: reschedule TX after RX was started

Ronnie Sahlberg (1):
      cifs: set domainName when a domain-key is used in multiuser

Sean Young (2):
      media: tm6000: double free if usb disconnect while streaming
      media: technisat-usb2: break out of loop at end of buffer

Stuart Hayes (1):
      iommu/amd: Flush old domains in kdump kernel

Suman Anna (1):
      bus: ti-sysc: Simplify cleanup upon failures in sysc_probe()

Sven Eckelmann (1):
      batman-adv: Only read OGM2 tvlv_len after buffer len check

Takashi Iwai (1):
      sky2: Disable MSI on yet another ASUS boards (P6Xxxx)

Thomas Falcon (1):
      ibmvnic: Do not process reset during or after device removal

Thomas Gleixner (1):
      x86/apic: Fix arch_dynirq_lower_bound() bug for DT enabled machines

Thomas Jarosch (1):
      netfilter: nf_conntrack_ftp: Fix debug output

Tianyu Lan (1):
      x86/hyper-v: Fix overflow bug in fill_gva_list()

Todd Seidelmann (2):
      netfilter: ebtables: Fix argument order to ADD_COUNTER
      netfilter: xt_physdev: Fix spurious error message in physdev_mt_check

Tony Lindgren (3):
      ARM: OMAP2+: Fix missing SYSC_HAS_RESET_STATUS for dra7 epwmss
      bus: ti-sysc: Fix using configured sysc mask value
      ARM: OMAP2+: Fix omap4 errata warning on other SoCs

Trond Myklebust (5):
      NFSv4: Fix return values for nfs4_file_open()
      NFSv4: Fix return value in nfs_finish_open()
      NFS: Fix initialisation of I/O result struct in nfs_pgio_rpcsetup
      NFSv2: Fix eof handling
      NFSv2: Fix write regression

Wen Huang (1):
      mwifiex: Fix three heap overflow at parsing element in cfg80211_ap_se=
ttings

Wenwen Wang (3):
      qed: Add cleanup in qed_slowpath_start()
      dmaengine: ti: dma-crossbar: Fix a memory leak bug
      dmaengine: ti: omap-dma: Add cleanup in omap_dma_probe()

Will Deacon (1):
      arm64: kpti: Whitelist Cortex-A CPUs that don't implement the CSV3 fi=
eld

Willem de Bruijn (1):
      udp: correct reuseport selection with connected sockets

Xin Long (1):
      ip6_gre: fix a dst leak in ip6erspan_tunnel_xmit

Yoshihiro Shimoda (1):
      phy: renesas: rcar-gen3-usb2: Disable clearing VBUS in over-current

YueHaibing (3):
      ieee802154: hwsim: Fix error handle path in hwsim_init_module
      ieee802154: hwsim: unregister hw while hwsim_subscribe_all_others fai=
ls
      amd-xgbe: Fix error path in xgbe_mod_init()

Zephaniah E. Loss-Cutler-Hull (1):
      tools/power x86_energy_perf_policy: Fix argument parsing

zhaoyang (1):
      ARM: 8901/1: add a criteria for pfn_valid of arm


--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2FxNcACgkQONu9yGCS
aT6MrA/+KL4aGpVJGTy4jUnRzCxhO4OaDZ5TvMoTNJnMHmQEZwgeF4QSU4R179WE
vxFZa/oELz2CmWEEHRxIlCjYxydnSvgTWssopvs6fmnymwU5IbTlojdjrkcNNdBu
R6v0rAzZ8GNyU8CKKkaRV14Xof1BsJvk0QYoTuVgxZLMWazcAneyO03T8kiQLI27
neKbfIH2gdyeXpBzIwW/PgywjQ/6nqBD0N145dq82dxsTd3i+Lqh/iFAS4/u7UZ+
WS9aOzdHbgXGcG6K+qd//C+IcFINqlmgGYfCytd/4x635Ri+g3MRwZjn26v8dw5+
Gf+d4OFIN/LxE0SGFcsPDlNNwoMEhMb799k434+pV6CaKq0jYyM7DzVPR98sRDPd
NY1T3zQ/MQNJ7FewyPIBwSMmrrC6WO1kqAOjlqEzQwqq86nITDFgEkqvlKMyGtur
/cZSk91wYKIZzeCqjotlzepSgZw/P+gs4b4KT0RmuK3uDufgJg3prc5Cr2wT177b
DPvZIDDwhOw8+oDgq9+mRXb/FrsYJOYKHIpYuVcuZRwdkDgoEzHuvva4KNKBHc7G
QiIhKoqwYT5j7qQrp4P2xwg7P+7j2thG2GCf02tU8bwwT+2K+OpXuf87OT4pe6mQ
X/R0ofwQ7H4Fm/uAAxB8w5aS1pk16+/fEnMaq0tHBC5JdPSve04=
=BGUh
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
