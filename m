Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 798571387D7
	for <lists+stable@lfdr.de>; Sun, 12 Jan 2020 20:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387405AbgALTDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jan 2020 14:03:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730219AbgALTDy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Jan 2020 14:03:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 653902187F;
        Sun, 12 Jan 2020 19:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578855833;
        bh=kfIA/gywWpt5uZu8xZFC/kvyO1hbzhNkt2yX7C/CgO0=;
        h=Date:From:To:Cc:Subject:From;
        b=ZFHDLyif57vogJKCOrKTP0VeVOcSZW0jHElHuWEkkJuooP3kpIGesX9iCqB469Zbi
         KrnI+vK9Itfixj81CCIivXtTRk6cAdlJKgTpMDwk93ysnAJUbXLwuJb2xQjHHjiYUK
         jWajpE/5rZm3c6v5dkD0/RAUryx1yyjuFQ9aKUrE=
Date:   Sun, 12 Jan 2020 20:03:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.95
Message-ID: <20200112190351.GA1364545@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.95 kernel.

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

 Makefile                                                         |    2=20
 arch/arm/boot/dts/am437x-gp-evm.dts                              |    2=20
 arch/arm/boot/dts/am43x-epos-evm.dts                             |    2=20
 arch/arm/boot/dts/bcm-cygnus.dtsi                                |    4=20
 arch/arm/boot/dts/bcm283x.dtsi                                   |    2=20
 arch/arm/boot/dts/bcm5301x.dtsi                                  |    4=20
 arch/arm/boot/dts/imx6ul-14x14-evk.dtsi                          |    2=20
 arch/arm/boot/dts/imx6ul.dtsi                                    |    6=20
 arch/arm/mach-vexpress/spc.c                                     |   12 +
 arch/mips/net/ebpf_jit.c                                         |    9 -
 arch/parisc/include/asm/cmpxchg.h                                |   10 +
 arch/parisc/kernel/drivers.c                                     |    2=20
 arch/powerpc/include/asm/spinlock.h                              |    5=20
 arch/powerpc/mm/mem.c                                            |    8 +
 arch/powerpc/platforms/pseries/setup.c                           |    7=20
 arch/s390/purgatory/Makefile                                     |    6=20
 arch/s390/purgatory/string.c                                     |    3=20
 arch/x86/events/core.c                                           |    9 -
 arch/x86/platform/efi/quirks.c                                   |    6=20
 block/blk-map.c                                                  |    2=20
 drivers/cpufreq/imx6q-cpufreq.c                                  |   52 ++=
++--
 drivers/firmware/efi/libstub/gop.c                               |   80 ++=
--------
 drivers/gpu/drm/exynos/exynos_drm_gsc.c                          |    1=20
 drivers/iommu/iova.c                                             |    2=20
 drivers/net/dsa/mv88e6xxx/global1.c                              |    5=20
 drivers/net/dsa/mv88e6xxx/global1.h                              |    1=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h                  |    2=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c                 |   12 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h                |    1=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c                 |   12 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                |   38 ++=
+-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h                |    4=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c               |    4=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c             |    7=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c                |    3=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c                |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h                   |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c               |    3=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                |   16 +-
 drivers/net/gtp.c                                                |    5=20
 drivers/net/hyperv/hyperv_net.h                                  |    3=20
 drivers/net/hyperv/netvsc_drv.c                                  |    4=20
 drivers/net/hyperv/rndis_filter.c                                |   10 -
 drivers/net/macvlan.c                                            |    2=20
 drivers/net/usb/lan78xx.c                                        |   11 -
 drivers/net/vxlan.c                                              |    4=20
 drivers/net/wireless/marvell/mwifiex/tdls.c                      |   70 ++=
++++++
 drivers/pci/switch/switchtec.c                                   |    4=20
 drivers/regulator/core.c                                         |    4=20
 drivers/regulator/rn5t618-regulator.c                            |    1=20
 drivers/s390/block/dasd_eckd.c                                   |   28 ---
 drivers/s390/cio/device_ops.c                                    |    2=20
 drivers/spi/spi-cavium-thunderx.c                                |    2=20
 drivers/spi/spi-ti-qspi.c                                        |    6=20
 drivers/usb/core/config.c                                        |   70 ++=
+++++-
 drivers/usb/core/hub.c                                           |    2=20
 drivers/usb/dwc3/gadget.c                                        |    7=20
 drivers/usb/gadget/udc/dummy_hcd.c                               |   10 -
 drivers/usb/serial/option.c                                      |    2=20
 fs/btrfs/qgroup.c                                                |    4=20
 fs/drop_caches.c                                                 |    2=20
 fs/inode.c                                                       |    7=20
 fs/notify/fsnotify.c                                             |    1=20
 fs/quota/dquot.c                                                 |    1=20
 include/linux/if_ether.h                                         |    8 +
 include/uapi/linux/netfilter/xt_sctp.h                           |    6=20
 kernel/bpf/verifier.c                                            |    9 -
 kernel/locking/spinlock_debug.c                                  |   32 ++=
--
 net/8021q/vlan.h                                                 |    1=20
 net/8021q/vlan_dev.c                                             |    3=20
 net/8021q/vlan_netlink.c                                         |   19 +-
 net/core/filter.c                                                |    1=20
 net/ipv4/tcp_input.c                                             |    5=20
 net/llc/llc_station.c                                            |    4=20
 net/netfilter/nf_conntrack_netlink.c                             |    3=20
 net/netfilter/nf_tables_api.c                                    |   16 +-
 net/netfilter/nft_bitwise.c                                      |    4=20
 net/netfilter/nft_cmp.c                                          |    6=20
 net/netfilter/nft_range.c                                        |   10 +
 net/netfilter/nft_set_rbtree.c                                   |   21 ++
 net/rfkill/core.c                                                |    7=20
 net/sched/sch_cake.c                                             |    2=20
 net/sched/sch_fq.c                                               |    6=20
 net/sched/sch_prio.c                                             |   10 +
 net/sctp/sm_sideeffect.c                                         |   28 ++-
 samples/bpf/syscall_tp_kern.c                                    |   18 ++
 samples/bpf/trace_event_user.c                                   |    4=20
 scripts/kconfig/expr.c                                           |    7=20
 sound/soc/codecs/max98090.c                                      |    8 -
 sound/soc/codecs/max98090.h                                      |    1=20
 sound/soc/codecs/wm8962.c                                        |    4=20
 sound/soc/intel/boards/bytcr_rt5640.c                            |    8 -
 sound/soc/soc-topology.c                                         |    8 -
 tools/lib/traceevent/Makefile                                    |    1=20
 tools/testing/selftests/ftrace/test.d/kprobe/multiple_kprobes.tc |    6=20
 95 files changed, 607 insertions(+), 271 deletions(-)

Aditya Pakki (1):
      rfkill: Fix incorrect check to avoid NULL pointer dereference

Alexander Shishkin (1):
      perf/x86/intel: Fix PT PMI handling

Andreas Kemnade (1):
      regulator: rn5t618: fix module aliases

Andrew Lunn (1):
      net: dsa: mv88e6xxx: Preserve priority when setting CPU port.

Andrey Konovalov (2):
      USB: dummy-hcd: use usb_urb_dir_in instead of usb_pipein
      USB: dummy-hcd: increase max number of devices to 32

Anson Huang (2):
      cpufreq: imx6q: read OCOTP through nvmem for imx6ul/imx6ull
      ARM: dts: imx6ul: use nvmem-cells for cpu speed grading

Arvind Sankar (3):
      efi/gop: Return EFI_NOT_FOUND if there are no usable GOPs
      efi/gop: Return EFI_SUCCESS if a usable GOP was found
      efi/gop: Fix memory leak in __gop_query32/64()

Chan Shu Tak, Alex (1):
      llc2: Fix return statement of llc_stat_ev_rx_null_dsap_xid_c (and _te=
st_c)

Chen-Yu Tsai (2):
      net: stmmac: dwmac-sun8i: Allow all RGMII modes
      net: stmmac: dwmac-sunxi: Allow all RGMII modes

Christian Borntraeger (1):
      s390/purgatory: do not build purgatory with kcov, kasan and friends

Chuhong Yuan (2):
      spi: spi-cavium-thunderx: Add missing pci_release_regions()
      drm/exynos: gsc: add missed component_del

Cristian Birsan (1):
      net: usb: lan78xx: Fix error message format specifier

Daniel Borkmann (1):
      bpf: Fix passing modified ctx to ld/abs/ind instruction

Daniel T. Lee (2):
      samples: bpf: Replace symbol compare of trace_event
      samples: bpf: fix syscall_tp due to unused syscall

Daniele Palmas (1):
      USB: serial: option: add Telit ME910G1 0x110a composition

Dave Young (1):
      x86/efi: Update e820 with reserved EFI boot services data to fix kexe=
c breakage

Dragos Tarcatu (1):
      ASoC: topology: Check return value for soc_tplg_pcm_create()

Eric Dumazet (6):
      gtp: fix bad unlock balance in gtp_encap_enable_socket
      macvlan: do not assume mac_header is set in macvlan_broadcast()
      net: usb: lan78xx: fix possible skb leak
      pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM
      vlan: fix memory leak in vlan_dev_set_egress_priority
      vlan: vlan_changelink() should propagate errors

Eric Sandeen (1):
      fs: avoid softlockups in s_inodes iterators

Florian Fainelli (2):
      ARM: dts: BCM5301X: Fix MDIO node address/size cells
      ARM: dts: Cygnus: Fix MDIO node address/size cells

Florian Westphal (1):
      netfilter: ctnetlink: netns exit must wait for callbacks

Greg Kroah-Hartman (1):
      Linux 4.19.95

Haiyang Zhang (1):
      hv_netvsc: Fix unwanted rx_table reset

Hangbin Liu (1):
      vxlan: fix tos value before xmit

Hans de Goede (1):
      ASoC: Intel: bytcr_rt5640: Update quirk for Teclast X89

Helge Deller (1):
      parisc: Fix compiler warnings in debug_core.c

Jan H=F6ppner (1):
      s390/dasd/cio: Interpret ccw_device_get_mdc return value correctly

Jason A. Donenfeld (1):
      powerpc/spinlocks: Include correct header for static key

Johan Hovold (1):
      USB: core: fix check for duplicate endpoints

Jose Abreu (4):
      net: stmmac: Do not accept invalid MTU values
      net: stmmac: xgmac: Clear previous RX buffer size
      net: stmmac: RX buffer size must be 16 byte aligned
      net: stmmac: Always arm TX Timer at end of transmission start

Logan Gunthorpe (1):
      PCI/switchtec: Read all 64 bits of part_event_bitmap

Lorenz Bauer (1):
      bpf: Clear skb->tstamp in bpf_redirect when necessary

Manish Chopra (2):
      bnx2x: Do not handle requests from VFs after parity
      bnx2x: Fix logic to get total no. of PFs per engine

Marco Elver (1):
      locking/spinlock/debug: Fix various data races

Masami Hiramatsu (1):
      selftests/ftrace: Fix multiple kprobe testcase

Mike Rapoport (1):
      powerpc: Ensure that swiotlb buffer is allocated from low memory

Nikolay Borisov (1):
      btrfs: Fix error messages in qgroup_rescan_init

Pablo Neira Ayuso (3):
      netfilter: nft_set_rbtree: bogus lookup/get on consecutive elements i=
n named sets
      netfilter: nf_tables: validate NFT_SET_ELEM_INTERVAL_END
      netfilter: nf_tables: validate NFT_DATA_VALUE after nft_data_init()

Paul Chaignon (1):
      bpf, mips: Limit to 33 tail calls

Pengcheng Yang (1):
      tcp: fix "old stuff" D-SACK causing SACK to be treated as D-SACK

Petr Machata (2):
      mlxsw: spectrum_qdisc: Ignore grafting of invisible FIFO
      net: sch_prio: When ungrafting, replace with FIFO

Phil Sutter (1):
      netfilter: uapi: Avoid undefined left-shift in xt_sctp.h

Qi Zhou (1):
      usb: missing parentheses in USE_NEW_SCHEME

Shengjiu Wang (1):
      ASoC: wm8962: fix lambda value

Srikar Dronamraju (1):
      powerpc/vcpu: Assume dedicated processors as non-preempt

Stefan Haberland (1):
      s390/dasd: fix memleak in path handling error case

Stefan Roese (1):
      ARM: dts: imx6ul: imx6ul-14x14-evk.dtsi: Fix SPI NOR probing

Stefan Wahren (1):
      ARM: dts: bcm283x: Fix critical trip point

Sudeep Holla (1):
      ARM: vexpress: Set-up shared OPP table instead of individual for each=
 CPU

Sudip Mukherjee (1):
      libtraceevent: Fix lib installation with O=3D

Sven Schnelle (1):
      parisc: add missing __init annotation

Thinh Nguyen (1):
      usb: dwc3: gadget: Fix request complete check

Thomas Hebb (1):
      kconfig: don't crash on NULL expressions in expr_eq()

Tomi Valkeinen (1):
      ARM: dts: am437x-gp/epos-evm: fix panel compatible

Tzung-Bi Shih (1):
      ASoC: max98090: fix possible race conditions

Vasundhara Volam (1):
      bnxt_en: Return error if FW returns more data than dump length

Vignesh Raghavendra (1):
      spi: spi-ti-qspi: Fix a bug when accessing non default CS

Vishal Kulkarni (1):
      cxgb4: Fix kernel panic while accessing sge_info

Wen Yang (2):
      regulator: fix use after free issue
      sch_cake: avoid possible divide by zero in cake_enqueue()

Xiaotao Yin (1):
      iommu/iova: Init the struct iova to fix the possible memleak

Xin Long (1):
      sctp: free cmd->obj.chunk for the unprocessed SCTP_CMD_REPLY

Yang Yingliang (1):
      block: fix memleak when __blk_rq_map_user_iov() is failed

qize wang (1):
      mwifiex: Fix heap overflow in mmwifiex_process_tdls_action_frame()


--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4bbZcACgkQONu9yGCS
aT40gA//Wz4q6qymouFWDo9KgEacutbLsAbiAMaxg2245kFnfySw7ZNwYPEUHDF3
qzNoX+b7MoIRyQiKFS9dQPwytL/ve+aPag8RKVXFZdzxW633lYd6E2rfjXLrazQJ
Dd1WJNPzWN/+5qX0/maahy7fzJtXKYmo3rHNCEDPLUv6FH+MMBwLxznXUqfKan+i
4bfaXvzOGEU/vDHNCBPLankJFoR+UgSNr/OqvRkt2MmIiVN4p8QsuWh2UXW1UwyY
inscUdTjEKfTvuL7ReqDmpKX4lMWzMFN+mQEfY6MLq0bCZefxgx4EIQ6ZB2QwANN
kl9uQokQE8E4f8oChxShYkpyLJ0AhtT5exGMj1zz7s3Ogv1boHiJDT7zjC1+7P3+
Zh8xTcMq4IUAeHkBNXHt5NL6KFGkVSnZ0lq53W0Xm6YpbmolLWfRcPpkqVDLrQ6c
YlX85EAxnkExiWRunCudYlTf+B0DUpIPtTTw1UiqsUgNwk2yj5srUT2bLZBMJigZ
t5iu4SbrLaFIOghzyrrkjEsZMOyyFFbmFaR0FZcz7Xx4Iil94AUTCgieRQVP/sB3
S/payWrqy70JxUY1KUiqnFrpmcB3nbGpoxl/X1JR2cpFq09ENy5y/vXXFCfvAWc1
Yk6YTzfFlufE/3EVl/CfoE3qErVIzofk8udq6J4Yuy6GNOnTv7Y=
=SGNR
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
