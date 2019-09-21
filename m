Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B33DB9CB0
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 08:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407439AbfIUGgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 02:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405234AbfIUGgn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Sep 2019 02:36:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEB7620673;
        Sat, 21 Sep 2019 06:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569047801;
        bh=AXHKdUtLv72/lMA8cO4cA3e6jQe6CDwPegaCOvKECBU=;
        h=Date:From:To:Cc:Subject:From;
        b=rfgpr31bhxfPdcrzWlfB5XKukUcdvowh0tsPzosiC3z6I43fhhweSxXCT6nuqeLkG
         Y6Wkj1OEDbgRORd/0FjmahCS6dtBTdc8Rh6z0Z/WBsm9Fi2UI3k4twYi8o5WnK0WCO
         3jNWiP4ruYCzIFiQi4SIvIHJL3cZPQPQoB1pXcCA=
Date:   Sat, 21 Sep 2019 08:36:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.2.17
Message-ID: <20190921063639.GA1083370@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.2.17 kernel.

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

 Documentation/filesystems/overlayfs.txt                         |    2=20
 Makefile                                                        |    2=20
 arch/arm/boot/dts/am33xx-l4.dtsi                                |   16 +-
 arch/arm/boot/dts/am33xx.dtsi                                   |   32 +++-
 arch/arm/boot/dts/am4372.dtsi                                   |   32 +++-
 arch/arm/boot/dts/am437x-l4.dtsi                                |    4=20
 arch/arm/boot/dts/am571x-idk.dts                                |    7=20
 arch/arm/boot/dts/am572x-idk.dts                                |    7=20
 arch/arm/boot/dts/am574x-idk.dts                                |    7=20
 arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi                 |    3=20
 arch/arm/boot/dts/am57xx-beagle-x15-revb1.dts                   |    7=20
 arch/arm/boot/dts/am57xx-beagle-x15-revc.dts                    |    7=20
 arch/arm/boot/dts/dra7-evm.dts                                  |    2=20
 arch/arm/boot/dts/dra7-l4.dtsi                                  |    6=20
 arch/arm/boot/dts/dra74x-mmc-iodelay.dtsi                       |   50 +++=
---
 arch/arm/mach-omap1/ams-delta-fiq-handler.S                     |    3=20
 arch/arm/mach-omap1/ams-delta-fiq.c                             |    4=20
 arch/arm/mach-omap2/omap4-common.c                              |    3=20
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c                       |    3=20
 arch/arm/mm/init.c                                              |    8 -
 arch/arm64/boot/dts/amlogic/meson-g12a.dtsi                     |    1=20
 arch/arm64/boot/dts/renesas/r8a77995-draak.dts                  |    6=20
 arch/arm64/include/asm/pgtable.h                                |   12 +
 arch/powerpc/mm/book3s64/radix_pgtable.c                        |   16 --
 arch/riscv/include/asm/fixmap.h                                 |    4=20
 arch/riscv/include/asm/pgtable.h                                |   12 +
 arch/s390/net/bpf_jit_comp.c                                    |   12 -
 arch/x86/events/amd/ibs.c                                       |   13 +
 arch/x86/events/intel/core.c                                    |    6=20
 arch/x86/hyperv/mmu.c                                           |    8 -
 arch/x86/include/asm/perf_event.h                               |   12 +
 arch/x86/include/asm/uaccess.h                                  |    4=20
 arch/x86/kernel/apic/io_apic.c                                  |    8 -
 drivers/atm/Kconfig                                             |    2=20
 drivers/block/floppy.c                                          |    4=20
 drivers/bus/ti-sysc.c                                           |   24 +--
 drivers/dma/sh/rcar-dmac.c                                      |   28 ++-
 drivers/dma/sprd-dma.c                                          |   10 +
 drivers/dma/ti/dma-crossbar.c                                   |    4=20
 drivers/dma/ti/omap-dma.c                                       |    4=20
 drivers/firmware/google/vpd.c                                   |    4=20
 drivers/firmware/google/vpd_decode.c                            |   55 +++=
+---
 drivers/firmware/google/vpd_decode.h                            |    6=20
 drivers/fpga/altera-ps-spi.c                                    |   11 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c                         |   27 ++-
 drivers/gpu/drm/amd/powerplay/hwmgr/vega20_hwmgr.c              |   60 +++=
++++-
 drivers/gpu/drm/omapdrm/dss/output.c                            |    4=20
 drivers/gpu/drm/virtio/virtgpu_object.c                         |   10 +
 drivers/hid/wacom_sys.c                                         |   10 -
 drivers/hid/wacom_wac.c                                         |    4=20
 drivers/i2c/busses/i2c-bcm-iproc.c                              |    5=20
 drivers/i2c/busses/i2c-designware-slave.c                       |    1=20
 drivers/i2c/busses/i2c-mt65xx.c                                 |   11 +
 drivers/input/mouse/elan_i2c_core.c                             |    2=20
 drivers/iommu/amd_iommu.c                                       |   40 +++=
+-
 drivers/iommu/intel-svm.c                                       |   36 ++--
 drivers/media/platform/stm32/stm32-dcmi.c                       |    2=20
 drivers/media/usb/dvb-usb/technisat-usb2.c                      |   22 +--
 drivers/media/usb/tm6000/tm6000-dvb.c                           |    3=20
 drivers/net/dsa/microchip/ksz9477_spi.c                         |    1=20
 drivers/net/ethernet/amd/xgbe/xgbe-main.c                       |   10 +
 drivers/net/ethernet/aquantia/atlantic/aq_filters.c             |    5=20
 drivers/net/ethernet/aquantia/atlantic/aq_main.c                |    4=20
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c                 |    2=20
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c                 |    3=20
 drivers/net/ethernet/freescale/enetc/enetc_ptp.c                |    5=20
 drivers/net/ethernet/hisilicon/hns/hns_enet.c                   |   23 +++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c                 |    4=20
 drivers/net/ethernet/ibm/ibmvnic.c                              |    6=20
 drivers/net/ethernet/marvell/sky2.c                             |    7=20
 drivers/net/ethernet/qlogic/qed/qed_main.c                      |    4=20
 drivers/net/ethernet/seeq/sgiseeq.c                             |    7=20
 drivers/net/ieee802154/mac802154_hwsim.c                        |    8 -
 drivers/net/usb/r8152.c                                         |    5=20
 drivers/net/wireless/marvell/mwifiex/ie.c                       |    3=20
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c                  |    9 +
 drivers/net/xen-netfront.c                                      |    2=20
 drivers/phy/renesas/phy-rcar-gen3-usb2.c                        |    2=20
 drivers/tty/serial/atmel_serial.c                               |    1=20
 drivers/tty/serial/sprd_serial.c                                |    2=20
 drivers/usb/core/config.c                                       |   12 +
 drivers/usb/host/xhci-tegra.c                                   |   10 +
 fs/cifs/connect.c                                               |   22 +++
 fs/fs_parser.c                                                  |    1=20
 fs/nfs/dir.c                                                    |    2=20
 fs/nfs/flexfilelayout/flexfilelayout.c                          |   11 +
 fs/nfs/internal.h                                               |   10 +
 fs/nfs/nfs4file.c                                               |   18 +-
 fs/nfs/pagelist.c                                               |    2=20
 fs/nfs/proc.c                                                   |    7=20
 fs/nfs/read.c                                                   |   35 +++-
 fs/nfs/write.c                                                  |   38 ++-=
--
 fs/overlayfs/ovl_entry.h                                        |    1=20
 fs/overlayfs/super.c                                            |   73 +++=
+++----
 include/linux/intel-iommu.h                                     |    3=20
 include/net/pkt_sched.h                                         |    7=20
 include/net/sock_reuseport.h                                    |   21 ++
 include/uapi/linux/netfilter/xt_nfacct.h                        |    5=20
 kernel/kallsyms.c                                               |    6=20
 net/batman-adv/bat_v_ogm.c                                      |   18 +-
 net/bridge/netfilter/ebtables.c                                 |    8 -
 net/ceph/crypto.c                                               |    6=20
 net/core/dev.c                                                  |   16 +-
 net/core/filter.c                                               |    8 -
 net/core/flow_dissector.c                                       |    2=20
 net/core/sock_reuseport.c                                       |   15 +-
 net/dsa/dsa2.c                                                  |    2=20
 net/ipv4/datagram.c                                             |    2=20
 net/ipv4/udp.c                                                  |    5=20
 net/ipv6/datagram.c                                             |    2=20
 net/ipv6/ip6_gre.c                                              |    2=20
 net/ipv6/udp.c                                                  |    5=20
 net/netfilter/nf_conntrack_ftp.c                                |    2=20
 net/netfilter/nf_conntrack_standalone.c                         |    5=20
 net/netfilter/nf_flow_table_core.c                              |    2=20
 net/netfilter/nf_flow_table_ip.c                                |    3=20
 net/netfilter/nft_flow_offload.c                                |    6=20
 net/netfilter/xt_nfacct.c                                       |   36 +++-
 net/netfilter/xt_physdev.c                                      |    6=20
 net/sched/sch_generic.c                                         |    3=20
 net/sunrpc/clnt.c                                               |    2=20
 net/wireless/nl80211.c                                          |    4=20
 net/xdp/xdp_umem.c                                              |    4=20
 scripts/decode_stacktrace.sh                                    |    2=20
 security/keys/request_key_auth.c                                |    6=20
 tools/bpf/bpftool/prog.c                                        |    4=20
 tools/power/x86/turbostat/turbostat.c                           |   38 +++=
--
 tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c |   28 ++-
 tools/testing/selftests/bpf/config                              |    1=20
 tools/testing/selftests/bpf/test_cgroup_storage.c               |    6=20
 tools/testing/selftests/bpf/test_sock.c                         |    7=20
 virt/kvm/coalesced_mmio.c                                       |   19 +-
 132 files changed, 935 insertions(+), 445 deletions(-)

Aaron Armstrong Skomra (1):
      HID: wacom: generic: read HID_DG_CONTACTMAX from any feature report

Alan Stern (1):
      USB: usbcore: Fix slab-out-of-bounds bug during device reset

Amir Goldstein (1):
      ovl: fix regression caused by overlapping layers detection

Anders Roxell (1):
      selftests/bpf: add config fragment BPF_JIT

Andrew Lunn (1):
      net: dsa: Fix load order between DSA drivers and taggers

Aneesh Kumar K.V (1):
      powerpc/mm/radix: Use the right page size for vmemmap mapping

Anup Patel (1):
      RISC-V: Fix FIXMAP area corruption on RV32 systems

Baolin Wang (1):
      dmaengine: sprd: Fix the DMA link-list configuration

Ben Hutchings (1):
      tools/power x86_energy_perf_policy: Fix "uninitialized variable" warn=
ings at -O2

Benjamin Tissoires (1):
      Input: elan_i2c - remove Lenovo Legion Y7000 PnpID

Christian K=F6nig (1):
      drm/amdgpu: fix dma_fence_wait without reference

Christophe JAILLET (3):
      Kconfig: Fix the reference to the IDT77105 Phy driver in the descript=
ion of ATM_NICSTAR_USE_IDT77105
      enetc: Add missing call to 'pci_free_irq_vectors()' in probe and remo=
ve functions
      net: seeq: Fix the function used to release some memory in an error h=
andling path

Chunyan Zhang (1):
      serial: sprd: correct the wrong sequence of arguments

Colin Ian King (1):
      tools/power turbostat: fix leak of file descriptor on error return pa=
th

Cong Wang (1):
      net_sched: let qdisc_put() accept NULL pointer

Dan Carpenter (1):
      cifs: Use kzfree() to zero out the password

Darrick J. Wong (1):
      nfs: disable client side deduplication

David Howells (1):
      vfs: Fix refcounting of filenames in fs_parser

Dmitry Bogdanov (4):
      net: aquantia: fix limit of vlan filters
      net: aquantia: fix removal of vlan 0
      net: aquantia: reapply vlan filters on up
      net: aquantia: fix out of memory condition on rx side

Dongli Zhang (1):
      xen-netfront: do not assume sk_buff_head list is empty in error handl=
ing

Doug Berger (1):
      ARM: 8874/1: mm: only adjust sections of valid mm structures

Emmanuel Vadot (1):
      ARM: dts: am335x: Fix UARTs length

Evan Quan (1):
      drm/amd/powerplay: correct Vega20 dpm level related settings

Fabien Dessenne (1):
      media: stm32-dcmi: fix irq =3D 0 case

Faiz Abbas (2):
      ARM: dts: am57xx: Disable voltage switching for SD card
      ARM: dts: dra74x: Fix iodelay configuration for mmc3

Florian Westphal (2):
      netfilter: conntrack: make sysctls per-namespace again
      netfilter: nf_flow_table: clear skb tstamp before xmit

Geert Uytterhoeven (1):
      arm64: dts: renesas: r8a77995: draak: Fix backlight regulator name

Gerd Hoffmann (1):
      drm/virtio: use virtio_max_dma_size

Greg Kroah-Hartman (1):
      Linux 5.2.17

Gustavo A. R. Silva (1):
      tools/power turbostat: fix file descriptor leaks

Hillf Danton (1):
      keys: Fix missing null pointer check in request_key_auth_describe()

Hsin-Yi Wang (1):
      i2c: mediatek: disable zero-length transfers for mt8183

Huazhong Tan (1):
      net: hns3: adjust hns3_uninit_phy()'s location in the hns3_client_uni=
nit()

Hung-Te Lin (1):
      firmware: google: check if size is valid when decoding VPD data

Igor Russkikh (1):
      net: aquantia: linkstate irq should be oneshot

Ilya Leoshkevich (5):
      s390/bpf: fix lcgr instruction encoding
      s390/bpf: use 32-bit index for tail calls
      selftests/bpf: fix "bind{4, 6} deny specific IP & port" on s390
      selftests/bpf: fix test_cgroup_storage on s390
      bpf: allow narrow loads of some sk_reuseport_md fields with offset > 0

Ivan Khoronzhuk (1):
      xdp: unpin xdp umem pages in error path

Jacob Pan (1):
      iommu/vt-d: Remove global page flush support

Jakub Sitnicki (1):
      flow_dissector: Fix potential use-after-free on BPF_PROG_DETACH

Jann Horn (1):
      floppy: fix usercopy direction

Janusz Krzysztofik (1):
      ARM: OMAP1: ams-delta-fiq: Fix missing irq_ack

Jarkko Nikula (1):
      i2c: designware: Synchronize IRQs when unregistering slave client

Jia-Ju Bai (1):
      libceph: don't call crypto_free_sync_skcipher() on a NULL tfm

Joerg Roedel (1):
      iommu/amd: Fix race in increase_address_space()

Josh Hunt (1):
      perf/x86/intel: Restrict period on Nehalem

Juliana Rodrigueiro (1):
      netfilter: xt_nfacct: Fix alignment mismatch in xt_nfacct_match_info

Kim Phillips (1):
      perf/x86/amd/ibs: Fix sample bias for dispatched micro-ops

Laurent Pinchart (1):
      drm/omap: Fix port lookup for SDI output

Len Brown (1):
      tools/power turbostat: Fix Haswell Core systems

Lori Hikichi (1):
      i2c: iproc: Stop advertising support of SMBUS quick cmd

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

Neil Armstrong (1):
      arm64: dts: meson-g12a: add missing dwc2 phy-names

Nicolas Boichat (1):
      scripts/decode_stacktrace: match basepath using shell prefix operator=
, not regex

Pablo Neira Ayuso (2):
      netfilter: nf_flow_table: set default timeout after successful insert=
ion
      netfilter: nft_flow_offload: missing netlink attribute policy

Paolo Abeni (1):
      net/sched: fix race between deactivation and dequeue for NOLOCK qdisc

Peter Zijlstra (1):
      x86/uaccess: Don't leak the AC flags into __get_user() argument evalu=
ation

Phil Reid (1):
      fpga: altera-ps-spi: Fix getting of optional confd gpio

Prashant Malani (1):
      r8152: Set memory to all 0xFFs on failed reg reads

Quentin Monnet (1):
      tools: bpftool: close prog FD before exit on showing a single program

Rajneesh Bhardwaj (1):
      tools/power turbostat: Add Ice Lake NNPI support

Razvan Stefanescu (2):
      tty/serial: atmel: reschedule TX after RX was started
      net: dsa: microchip: add KSZ8563 compatibility string

Ronnie Sahlberg (1):
      cifs: set domainName when a domain-key is used in multiuser

Sean Young (2):
      media: tm6000: double free if usb disconnect while streaming
      media: technisat-usb2: break out of loop at end of buffer

Srinivas Pandruvada (1):
      tools/power turbostat: Fix CPU%C1 display value

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

Tony Lindgren (7):
      ARM: OMAP2+: Fix missing SYSC_HAS_RESET_STATUS for dra7 epwmss
      bus: ti-sysc: Fix handling of forced idle
      bus: ti-sysc: Fix using configured sysc mask value
      ARM: dts: Fix flags for gpio7
      ARM: dts: Fix incorrect dcan register mapping for am3, am4 and dra7
      ARM: OMAP2+: Fix omap4 errata warning on other SoCs
      ARM: dts: Fix incomplete dts data for am3 and am4 mmc

Trond Myklebust (10):
      SUNRPC: Handle connection breakages correctly in call_status()
      NFSv4: Fix return values for nfs4_file_open()
      NFSv4: Fix return value in nfs_finish_open()
      NFS: Fix initialisation of I/O result struct in nfs_pgio_rpcsetup
      NFS: On fatal writeback errors, we need to call nfs_inode_remove_requ=
est()
      pNFS/flexfiles: Don't time out requests on hard mounts
      NFS: Fix spurious EIO read errors
      NFS: Fix writepage(s) error handling to not report errors twice
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
      Revert "arm64: Remove unnecessary ISBs from set_{pte,pmd,pud}"

Willem de Bruijn (1):
      udp: correct reuseport selection with connected sockets

Xin Long (1):
      ip6_gre: fix a dst leak in ip6erspan_tunnel_xmit

Yonglong Liu (1):
      net: hns: fix LED configuration for marvell phy

Yoshihiro Shimoda (2):
      phy: renesas: rcar-gen3-usb2: Disable clearing VBUS in over-current
      dmaengine: rcar-dmac: Fix DMACHCLR handling if iommu is mapped

YueHaibing (4):
      ieee802154: hwsim: Fix error handle path in hwsim_init_module
      ieee802154: hwsim: unregister hw while hwsim_subscribe_all_others fai=
ls
      NFS: remove set but not used variable 'mapping'
      amd-xgbe: Fix error path in xgbe_mod_init()

Zephaniah E. Loss-Cutler-Hull (1):
      tools/power x86_energy_perf_policy: Fix argument parsing

zhaoyang (1):
      ARM: 8901/1: add a criteria for pfn_valid of arm


--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2FxPYACgkQONu9yGCS
aT65jQ/+LH7VY4xQh369I+BvaGgv+EPH4cDj/JNhkHKI9/fowhlK2hB6StoaGA6s
xfI+1iMfE/I1LY9OvIxnHbzsxmnMLyHjxCHJs/QJwTFiEUhD/YIEJlWc17HQdAdj
FAHHnJvGyz9eLrzTh9gIgl3tB+ChP85T9C+QVT/xtEOYqntrd0nGJgFZV6SplvPr
oy1vPXLtEXaUOwWOD0uwap+xfS3rxHecSM+hl+wLrEINGjIRSPKaxjj508huxEkC
w8p6vxWdm7j2vbFM5u5Ofox8eWWsG/+zR2GJcLu3mAAINSpBi40RneaWjKt1BtIq
vELtIn97YKT4OAUSH4IZvlAdzrjNYiNYSg6MPR+MrMjFcAczcCu1YMAxSsEluP0V
uyiHKBSxOSnY1WImd9RBcR7TGdeNFxYnrrdxgLFh+umrajtwJE5KOZei1PSwTliU
50xoHrVwWasKaWDCd7Q0zTyynU7BnS+3OlgxwdB1Gt/8RCRA+KnBab8zrOifgMK8
GrJsHHD3k4pB7vQmc0h7/XDFmdaBx5qvY3bCC0Fw/Mt9Ux5EgMWAhwim7pxuin1e
bQ4vzGrBoPBcjKzF5vffdf3K8WunbX9grp9kqferimvE/fosjPQp2ZuLds1q6xHI
M0Yj3JWaG1ODsqI7rPeQKFWud+gAdcbbe3+9udTq4nw0RCkyOTo=
=5gdt
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
