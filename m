Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 920501387DB
	for <lists+stable@lfdr.de>; Sun, 12 Jan 2020 20:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387425AbgALTEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jan 2020 14:04:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:51342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733212AbgALTEO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Jan 2020 14:04:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F24D9222D9;
        Sun, 12 Jan 2020 19:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578855852;
        bh=zGrGAN0PmFQYtxGEVzL/RCJcvuL7L9zTsqm5aNg6KLE=;
        h=Date:From:To:Cc:Subject:From;
        b=aLvA/FHhPP5DRXFY/cO0zn60t0SGtq1mC4h5JzlOM2DU0gWqNwnBF8KuuRG/7e5bX
         4mQ+O3VG5DE5YedWanwYU8o4Hy3OfGXocduqeOowPzFgPhpfFI/J9E5KA4CNErvjbN
         x1tsFUyDk84CpAb91PVXcKnlNoqYsACnzyzwuQPk=
Date:   Sun, 12 Jan 2020 20:04:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.11
Message-ID: <20200112190410.GA1364648@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.11 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                                  =
                |    2=20
 arch/arm/boot/dts/am335x-sancloud-bbe.dts                                 =
                |    2=20
 arch/arm/boot/dts/am437x-gp-evm.dts                                       =
                |    2=20
 arch/arm/boot/dts/am43x-epos-evm.dts                                      =
                |    2=20
 arch/arm/boot/dts/bcm-cygnus.dtsi                                         =
                |    4=20
 arch/arm/boot/dts/bcm283x.dtsi                                            =
                |    2=20
 arch/arm/boot/dts/bcm5301x.dtsi                                           =
                |    4=20
 arch/arm/boot/dts/imx6ul-14x14-evk.dtsi                                   =
                |    2=20
 arch/arm/configs/exynos_defconfig                                         =
                |    1=20
 arch/arm/configs/imx_v6_v7_defconfig                                      =
                |    1=20
 arch/arm/configs/omap2plus_defconfig                                      =
                |    1=20
 arch/arm/mach-vexpress/spc.c                                              =
                |   12=20
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi                            =
                |   10=20
 arch/arm64/kernel/cpu_errata.c                                            =
                |    1=20
 arch/mips/net/ebpf_jit.c                                                  =
                |    9=20
 arch/parisc/include/asm/cmpxchg.h                                         =
                |   10=20
 arch/parisc/include/asm/kexec.h                                           =
                |    4=20
 arch/parisc/kernel/Makefile                                               =
                |    2=20
 arch/parisc/kernel/drivers.c                                              =
                |    2=20
 arch/powerpc/include/asm/spinlock.h                                       =
                |    5=20
 arch/powerpc/mm/mem.c                                                     =
                |    8=20
 arch/powerpc/platforms/pseries/setup.c                                    =
                |    7=20
 arch/riscv/net/bpf_jit_comp.c                                             =
                |    4=20
 arch/s390/purgatory/Makefile                                              =
                |    6=20
 arch/s390/purgatory/string.c                                              =
                |    3=20
 arch/x86/events/core.c                                                    =
                |   19=20
 arch/x86/kernel/early-quirks.c                                            =
                |    2=20
 arch/x86/platform/efi/quirks.c                                            =
                |    6=20
 block/blk-core.c                                                          =
                |   11=20
 block/blk-flush.c                                                         =
                |    5=20
 block/blk-map.c                                                           =
                |    2=20
 block/blk.h                                                               =
                |    1=20
 drivers/bus/ti-sysc.c                                                     =
                |    4=20
 drivers/char/tpm/tpm_ftpm_tee.c                                           =
                |   22=20
 drivers/clk/at91/at91sam9260.c                                            =
                |    2=20
 drivers/clk/at91/at91sam9rl.c                                             =
                |    2=20
 drivers/clk/at91/at91sam9x5.c                                             =
                |    2=20
 drivers/clk/at91/pmc.c                                                    =
                |    2=20
 drivers/clk/at91/sama5d2.c                                                =
                |    2=20
 drivers/clk/at91/sama5d4.c                                                =
                |    2=20
 drivers/clk/clk.c                                                         =
                |   62 +
 drivers/firmware/efi/earlycon.c                                           =
                |   40 +
 drivers/firmware/efi/libstub/gop.c                                        =
                |   80 --
 drivers/gpio/gpiolib-of.c                                                 =
                |   27=20
 drivers/gpu/drm/exynos/exynos_drm_gsc.c                                   =
                |    1=20
 drivers/iommu/dma-iommu.c                                                 =
                |   17=20
 drivers/iommu/iova.c                                                      =
                |    2=20
 drivers/misc/habanalabs/command_submission.c                              =
                |    5=20
 drivers/misc/habanalabs/context.c                                         =
                |    2=20
 drivers/misc/habanalabs/goya/goya.c                                       =
                |   15=20
 drivers/misc/ocxl/context.c                                               =
                |    8=20
 drivers/net/dsa/mv88e6xxx/global1.c                                       =
                |    5=20
 drivers/net/dsa/mv88e6xxx/global1.h                                       =
                |    1=20
 drivers/net/dsa/mv88e6xxx/port.c                                          =
                |   12=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h                           =
                |    2=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c                          =
                |   12=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h                         =
                |    1=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c                          =
                |   12=20
 drivers/net/ethernet/cadence/macb_main.c                                  =
                |    4=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c                        =
                |    4=20
 drivers/net/ethernet/freescale/fec_main.c                                 =
                |    9=20
 drivers/net/ethernet/intel/i40e/i40e.h                                    =
                |    2=20
 drivers/net/ethernet/intel/i40e/i40e_main.c                               =
                |   10=20
 drivers/net/ethernet/intel/i40e/i40e_xsk.c                                =
                |    4=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                             =
                |    7=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c                              =
                |    8=20
 drivers/net/ethernet/mellanox/mlx5/core/en.h                              =
                |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h                           =
                |   16=20
 drivers/net/ethernet/mellanox/mlx5/core/en/health.c                       =
                |    7=20
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h                          =
                |   22=20
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c                    =
                |    1=20
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c                       =
                |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c                           =
                |   16=20
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                         =
                |   19=20
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                           =
                |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/main.c                            =
                |   16=20
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c                =
                |    5=20
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c                 =
                |   10=20
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h               =
                |   14=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c                      =
                |    7=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c                         =
                |    3=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c                         =
                |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h                            =
                |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c                        =
                |    3=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                         =
                |   40 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c                     =
                |    2=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c                    =
                |    4=20
 drivers/net/gtp.c                                                         =
                |    5=20
 drivers/net/hyperv/hyperv_net.h                                           =
                |    3=20
 drivers/net/hyperv/netvsc_drv.c                                           =
                |    4=20
 drivers/net/hyperv/rndis_filter.c                                         =
                |   10=20
 drivers/net/macvlan.c                                                     =
                |    2=20
 drivers/net/usb/lan78xx.c                                                 =
                |   11=20
 drivers/net/vxlan.c                                                       =
                |    4=20
 drivers/net/wireless/marvell/mwifiex/tdls.c                               =
                |   70 +-
 drivers/perf/arm_smmuv3_pmu.c                                             =
                |    4=20
 drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c                                =
                |   24=20
 drivers/pinctrl/pinmux.c                                                  =
                |    2=20
 drivers/platform/x86/pcengines-apuv2.c                                    =
                |    2=20
 drivers/regulator/core.c                                                  =
                |   12=20
 drivers/regulator/rn5t618-regulator.c                                     =
                |    1=20
 drivers/reset/core.c                                                      =
                |    4=20
 drivers/s390/block/dasd_eckd.c                                            =
                |   28=20
 drivers/s390/cio/device_ops.c                                             =
                |    2=20
 drivers/s390/net/qeth_core_main.c                                         =
                |   14=20
 drivers/s390/net/qeth_core_mpc.h                                          =
                |    5=20
 drivers/s390/net/qeth_core_sys.c                                          =
                |    2=20
 drivers/s390/net/qeth_l2_main.c                                           =
                |    1=20
 drivers/s390/net/qeth_l2_sys.c                                            =
                |    3=20
 drivers/s390/net/qeth_l3_main.c                                           =
                |    1=20
 drivers/spi/spi-cavium-thunderx.c                                         =
                |    2=20
 drivers/spi/spi-fsl-spi.c                                                 =
                |   15=20
 drivers/spi/spi-nxp-fspi.c                                                =
                |    2=20
 drivers/spi/spi-pxa2xx.c                                                  =
                |    4=20
 drivers/spi/spi-ti-qspi.c                                                 =
                |    6=20
 drivers/staging/axis-fifo/Kconfig                                         =
                |    2=20
 drivers/usb/core/config.c                                                 =
                |   70 +-
 drivers/usb/core/hub.c                                                    =
                |    2=20
 drivers/usb/dwc3/gadget.c                                                 =
                |    7=20
 drivers/usb/gadget/udc/dummy_hcd.c                                        =
                |    8=20
 drivers/usb/serial/option.c                                               =
                |    2=20
 drivers/usb/typec/tcpm/Kconfig                                            =
                |    1=20
 fs/btrfs/extent-tree.c                                                    =
                |   20=20
 fs/btrfs/file.c                                                           =
                |    4=20
 fs/btrfs/ioctl.c                                                          =
                |   16=20
 fs/btrfs/qgroup.c                                                         =
                |    4=20
 fs/drop_caches.c                                                          =
                |    2=20
 fs/inode.c                                                                =
                |    7=20
 fs/io_uring.c                                                             =
                |    4=20
 fs/notify/fsnotify.c                                                      =
                |    4=20
 fs/quota/dquot.c                                                          =
                |    1=20
 fs/super.c                                                                =
                |    4=20
 include/linux/if_ether.h                                                  =
                |    8=20
 include/uapi/linux/netfilter/xt_sctp.h                                    =
                |    6=20
 kernel/bpf/verifier.c                                                     =
                |    9=20
 kernel/locking/spinlock_debug.c                                           =
                |   32=20
 kernel/sched/psi.c                                                        =
                |    5=20
 kernel/trace/ring_buffer.c                                                =
                |    6=20
 kernel/trace/trace.c                                                      =
                |   17=20
 lib/sbitmap.c                                                             =
                |    2=20
 net/8021q/vlan.h                                                          =
                |    1=20
 net/8021q/vlan_dev.c                                                      =
                |    3=20
 net/8021q/vlan_netlink.c                                                  =
                |   19=20
 net/core/filter.c                                                         =
                |    1=20
 net/ipv4/tcp_input.c                                                      =
                |    5=20
 net/llc/llc_station.c                                                     =
                |    4=20
 net/mac80211/tx.c                                                         =
                |    9=20
 net/netfilter/nf_conntrack_netlink.c                                      =
                |    3=20
 net/netfilter/nf_tables_api.c                                             =
                |   18=20
 net/netfilter/nf_tables_offload.c                                         =
                |    6=20
 net/netfilter/nft_bitwise.c                                               =
                |    4=20
 net/netfilter/nft_cmp.c                                                   =
                |    6=20
 net/netfilter/nft_range.c                                                 =
                |   10=20
 net/netfilter/nft_set_rbtree.c                                            =
                |   21=20
 net/rfkill/core.c                                                         =
                |    7=20
 net/sched/sch_cake.c                                                      =
                |    2=20
 net/sched/sch_fq.c                                                        =
                |    6=20
 net/sched/sch_prio.c                                                      =
                |   10=20
 net/sctp/sm_sideeffect.c                                                  =
                |   28=20
 net/wireless/core.c                                                       =
                |    1=20
 net/xdp/xsk.c                                                             =
                |   22=20
 samples/bpf/syscall_tp_kern.c                                             =
                |   18=20
 samples/bpf/trace_event_user.c                                            =
                |    4=20
 scripts/kconfig/expr.c                                                    =
                |    7=20
 scripts/package/mkdebian                                                  =
                |    2=20
 sound/soc/codecs/max98090.c                                               =
                |    8=20
 sound/soc/codecs/max98090.h                                               =
                |    1=20
 sound/soc/codecs/rt5682.c                                                 =
                |    2=20
 sound/soc/codecs/wm8962.c                                                 =
                |    4=20
 sound/soc/intel/boards/bytcr_rt5640.c                                     =
                |    8=20
 sound/soc/soc-topology.c                                                  =
                |   27=20
 sound/soc/sof/intel/byt.c                                                 =
                |    7=20
 sound/soc/sof/loader.c                                                    =
                |    2=20
 tools/bpf/bpftool/prog.c                                                  =
                |    2=20
 tools/bpf/bpftool/xlated_dumper.c                                         =
                |    2=20
 tools/lib/traceevent/Makefile                                             =
                |    6=20
 tools/perf/util/header.c                                                  =
                |   21=20
 tools/perf/util/metricgroup.c                                             =
                |    7=20
 tools/testing/selftests/ftrace/test.d/ftrace/func-filter-stacktrace.tc    =
                |    2=20
 tools/testing/selftests/ftrace/test.d/ftrace/func_cpumask.tc              =
                |    5=20
 tools/testing/selftests/ftrace/test.d/functions                           =
                |    5=20
 tools/testing/selftests/ftrace/test.d/kprobe/multiple_kprobes.tc          =
                |    6=20
 tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-action-h=
ist-xfail.tc    |    4=20
 tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-onchange=
-action-hist.tc |    2=20
 tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-snapshot=
-action-hist.tc |    4=20
 tools/testing/selftests/kselftest/prefix.pl                               =
                |    1=20
 tools/testing/selftests/kselftest/runner.sh                               =
                |    1=20
 tools/testing/selftests/net/pmtu.sh                                       =
                |    6=20
 tools/testing/selftests/netfilter/nft_nat.sh                              =
                |  332 +++++-----
 tools/testing/selftests/safesetid/Makefile                                =
                |    5=20
 tools/testing/selftests/safesetid/safesetid-test.c                        =
                |   15=20
 191 files changed, 1239 insertions(+), 686 deletions(-)

Aditya Pakki (1):
      rfkill: Fix incorrect check to avoid NULL pointer dereference

Alexander Shishkin (1):
      perf/x86/intel: Fix PT PMI handling

Alexandre Belloni (1):
      clk: at91: fix possible deadlock

Alexandre Torgue (1):
      pinctrl: pinmux: fix a possible null pointer in pinmux_can_be_used_fo=
r_gpio

Andreas Kemnade (1):
      regulator: rn5t618: fix module aliases

Andrew Jeffery (1):
      pinctrl: aspeed-g6: Fix LPC/eSPI mux configuration

Andrew Lunn (2):
      net: dsa: mv88e6xxx: Preserve priority when setting CPU port.
      net: freescale: fec: Fix ethtool -d runtime PM

Andrey Konovalov (1):
      USB: dummy-hcd: use usb_urb_dir_in instead of usb_pipein

Andy Shevchenko (1):
      efi/earlycon: Remap entire framebuffer after page initialization

Arvind Sankar (3):
      efi/gop: Return EFI_NOT_FOUND if there are no usable GOPs
      efi/gop: Return EFI_SUCCESS if a usable GOP was found
      efi/gop: Fix memory leak in __gop_query32/64()

Bart Van Assche (1):
      block: Fix a lockdep complaint triggered by request queue flushing

Baruch Siach (1):
      net: dsa: mv88e6xxx: force cmode write on 6141/6341

Brendan Higgins (1):
      staging: axis-fifo: add unspecified HAS_IOMEM dependency

Chan Shu Tak, Alex (1):
      llc2: Fix return statement of llc_stat_ev_rx_null_dsap_xid_c (and _te=
st_c)

Chen Wandun (1):
      habanalabs: remove variable 'val' set but not used

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

Curtis Malainey (1):
      ASoC: SOF: Intel: split cht and byt debug window sizes

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

David Jeffery (1):
      sbitmap: only queue kyber's wait callback if not already active

Dragos Tarcatu (2):
      ASoC: topology: Check return value for snd_soc_add_dai_link()
      ASoC: topology: Check return value for soc_tplg_pcm_create()

Eli Cohen (1):
      net/mlx5e: Fix hairpin RSS table size

Enrico Weigelt, metux IT consult (2):
      scripts: package: mkdebian: add missing rsync dependency
      platform/x86: pcengines-apuv2: fix simswap GPIO assignment

Eran Ben Elisha (1):
      net/mlx5e: Always print health reporter message to dmesg

Erez Shitrit (1):
      net/mlx5: DR, Init lists that are used in rule's member

Eric Dumazet (6):
      gtp: fix bad unlock balance in gtp_encap_enable_socket
      macvlan: do not assume mac_header is set in macvlan_broadcast()
      net: usb: lan78xx: fix possible skb leak
      pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM
      vlan: fix memory leak in vlan_dev_set_egress_priority
      vlan: vlan_changelink() should propagate errors

Eric Sandeen (2):
      fs: avoid softlockups in s_inodes iterators
      fs: call fsnotify_sb_delete after evict_inodes

Filipe Manana (2):
      Btrfs: fix cloning range with a hole when using the NO_HOLES feature
      Btrfs: fix hole extent items with a zero size after range cloning

Florian Fainelli (2):
      ARM: dts: BCM5301X: Fix MDIO node address/size cells
      ARM: dts: Cygnus: Fix MDIO node address/size cells

Florian Westphal (2):
      netfilter: ctnetlink: netns exit must wait for callbacks
      selftests: netfilter: use randomized netns names

Frederic Barrat (1):
      ocxl: Fix potential memory leak on context creation

Fredrik Olofsson (1):
      mac80211: fix TID field in monitor mode transmit

Geert Uytterhoeven (1):
      reset: Do not register resource data for missing resets

Greg Kroah-Hartman (1):
      Linux 5.4.11

Haiyang Zhang (1):
      hv_netvsc: Fix unwanted rx_table reset

Hangbin Liu (2):
      selftests: pmtu: fix init mtu value in description
      vxlan: fix tos value before xmit

Hanjun Guo (1):
      perf/smmuv3: Remove the leftover put_cpu() in error path

Hans de Goede (1):
      ASoC: Intel: bytcr_rt5640: Update quirk for Teclast X89

Helge Deller (1):
      parisc: Fix compiler warnings in debug_core.c

Jan H=F6ppner (1):
      s390/dasd/cio: Interpret ccw_device_get_mdc return value correctly

Jarkko Nikula (1):
      spi: pxa2xx: Add support for Intel Jasper Lake

Jason A. Donenfeld (1):
      powerpc/spinlocks: Include correct header for static key

Jerome Brunet (1):
      clk: walk orphan list on clock provider registration

Johan Hovold (1):
      USB: core: fix check for duplicate endpoints

Johannes Weiner (2):
      sched/psi: Fix sampling error and rare div0 crashes with cgroups and =
high uptime
      psi: Fix a division error in psi poll()

Jose Abreu (7):
      net: stmmac: selftests: Needs to check the number of Multicast regs
      net: stmmac: Determine earlier the size of RX buffer
      net: stmmac: Do not accept invalid MTU values
      net: stmmac: xgmac: Clear previous RX buffer size
      net: stmmac: RX buffer size must be 16 byte aligned
      net: stmmac: Always arm TX Timer at end of transmission start
      net: stmmac: Fixed link does not need MDIO Bus

Josef Bacik (1):
      btrfs: handle error in btrfs_cache_block_group

Julian Wiedmann (3):
      s390/qeth: handle error due to unsupported transport mode
      s390/qeth: fix promiscuous mode after reset
      s390/qeth: don't return -ENOTSUPP to userspace

Kai-Heng Feng (1):
      x86/intel: Disable HPET on Intel Ice Lake platforms

Kajol Jain (1):
      perf metricgroup: Fix printing event names of metric group with multi=
ple events

Karol Trzcinski (1):
      ASoC: SOF: loader: snd_sof_fw_parse_ext_data log warning on unknown h=
eader

Leonard Crestez (1):
      ARM: imx_v6_v7_defconfig: Explicitly restore CONFIG_DEBUG_FS

Linus Walleij (3):
      spi: fsl: Fix GPIO descriptor support
      gpio: Handle counting of Freescale chipselects
      spi: fsl: Handle the single hardwired chipselect case

Lorenz Bauer (1):
      bpf: Clear skb->tstamp in bpf_redirect when necessary

Manish Chopra (2):
      bnx2x: Do not handle requests from VFs after parity
      bnx2x: Fix logic to get total no. of PFs per engine

Mans Rullgard (1):
      ARM: dts: am335x-sancloud-bbe: fix phy mode

Marco Elver (1):
      locking/spinlock/debug: Fix various data races

Marek Szyprowski (1):
      ARM: exynos_defconfig: Restore debugfs support

Masami Hiramatsu (7):
      selftests/ftrace: Fix to check the existence of set_ftrace_filter
      selftests/ftrace: Fix ftrace test cases to check unsupported
      selftests/ftrace: Do not to use absolute debugfs path
      selftests/ftrace: Fix multiple kprobe testcase
      selftests: safesetid: Move link library to LDLIBS
      selftests: safesetid: Check the return value of setuid/setgid
      selftests: safesetid: Fix Makefile to set correct test program

Maxim Mikityanskiy (4):
      xsk: Add rcu_read_lock around the XSK wakeup
      net/mlx5e: Fix concurrency issues between config flow and XSK
      net/i40e: Fix concurrency issues between config flow and XSK
      net/ixgbe: Fix concurrency issues between config flow and XSK

Michael Guralnik (1):
      net/mlx5: Move devlink registration before interfaces load

Michael Petlan (1):
      perf header: Fix false warning when there are no duplicate cache entr=
ies

Michael Walle (3):
      arm64: dts: ls1028a: fix typo in TMU calibration data
      arm64: dts: ls1028a: fix reboot node
      spi: nxp-fspi: Ensure width is respected in spi-mem operations

Mike Rapoport (1):
      powerpc: Ensure that swiotlb buffer is allocated from low memory

Nikolay Borisov (1):
      btrfs: Fix error messages in qgroup_rescan_init

Oded Gabbay (1):
      habanalabs: rate limit error msg on waiting for CS

Olof Johansson (1):
      clk: Move clk_core_reparent_orphans() under CONFIG_OF

Pablo Neira Ayuso (5):
      netfilter: nft_set_rbtree: bogus lookup/get on consecutive elements i=
n named sets
      netfilter: nf_tables: validate NFT_SET_ELEM_INTERVAL_END
      netfilter: nf_tables: validate NFT_DATA_VALUE after nft_data_init()
      netfilter: nf_tables: skip module reference count bump on object upda=
tes
      netfilter: nf_tables_offload: return EOPNOTSUPP if rule specifies no =
actions

Paul Chaignon (2):
      bpf, riscv: Limit to 33 tail calls
      bpf, mips: Limit to 33 tail calls

Pavel Begunkov (1):
      io_uring: don't wait when under-submitting

Pavel Tatashin (1):
      tpm/tpm_ftpm_tee: add shutdown call back

Pengcheng Yang (1):
      tcp: fix "old stuff" D-SACK causing SACK to be treated as D-SACK

Peter Zijlstra (1):
      perf/x86: Fix potential out-of-bounds access

Petr Machata (2):
      mlxsw: spectrum_qdisc: Ignore grafting of invisible FIFO
      net: sch_prio: When ungrafting, replace with FIFO

Phil Sutter (1):
      netfilter: uapi: Avoid undefined left-shift in xt_sctp.h

Qi Zhou (1):
      usb: missing parentheses in USE_NEW_SCHEME

Robin Murphy (1):
      iommu/dma: Relax locking in iommu_dma_prepare_msi()

Roman Penyaev (1):
      block: end bio with BLK_STS_AGAIN in case of non-mq devs and REQ_NOWA=
IT

SeongJae Park (2):
      kselftest/runner: Print new line in print of timeout log
      kselftest: Support old perl versions

Shengjiu Wang (1):
      ASoC: wm8962: fix lambda value

Shuming Fan (1):
      ASoC: rt5682: fix i2c arbitration lost issue

Srikar Dronamraju (1):
      powerpc/vcpu: Assume dedicated processors as non-preempt

Stefan B=FChler (1):
      cfg80211: fix double-free after changing network namespace

Stefan Haberland (1):
      s390/dasd: fix memleak in path handling error case

Stefan Roese (1):
      ARM: dts: imx6ul: imx6ul-14x14-evk.dtsi: Fix SPI NOR probing

Stefan Wahren (1):
      ARM: dts: bcm283x: Fix critical trip point

Stephen Boyd (1):
      macb: Don't unregister clks unconditionally

Steven Rostedt (VMware) (1):
      tracing: Do not create directories if lockdown is in affect

Sudeep Holla (1):
      ARM: vexpress: Set-up shared OPP table instead of individual for each=
 CPU

Sudip Mukherjee (2):
      libtraceevent: Fix lib installation with O=3D
      libtraceevent: Copy pkg-config file to output folder when using O=3D

Sven Schnelle (2):
      parisc: fix compilation when KEXEC=3Dn and KEXEC_FILE=3Dy
      parisc: add missing __init annotation

Thinh Nguyen (1):
      usb: dwc3: gadget: Fix request complete check

Thomas Hebb (1):
      kconfig: don't crash on NULL expressions in expr_eq()

Toke H=F8iland-J=F8rgensen (1):
      bpftool: Don't crash on missing jited insns or ksyms

Tomi Valkeinen (1):
      ARM: dts: am437x-gp/epos-evm: fix panel compatible

Tony Lindgren (2):
      ARM: omap2plus_defconfig: Add back DEBUG_FS
      bus: ti-sysc: Fix missing reset delay handling

Tzung-Bi Shih (1):
      ASoC: max98090: fix possible race conditions

Vignesh Raghavendra (1):
      spi: spi-ti-qspi: Fix a bug when accessing non default CS

Vishal Kulkarni (1):
      cxgb4: Fix kernel panic while accessing sge_info

Wei Li (1):
      arm64: cpu_errata: Add Hisilicon TSV110 to spectre-v2 safe list

Wen Yang (3):
      regulator: fix use after free issue
      regulator: core: fix regulator_register() error paths to properly rel=
ease rdev
      sch_cake: avoid possible divide by zero in cake_enqueue()

Xiaotao Yin (1):
      iommu/iova: Init the struct iova to fix the possible memleak

Xin Long (1):
      sctp: free cmd->obj.chunk for the unprocessed SCTP_CMD_REPLY

Yang Yingliang (1):
      block: fix memleak when __blk_rq_map_user_iov() is failed

Yevgeny Kliteynik (1):
      net/mlx5: DR, No need for atomic refcount for internal SW steering re=
sources

qize wang (1):
      mwifiex: Fix heap overflow in mmwifiex_process_tdls_action_frame()

wenxu (1):
      netfilter: nf_tables_offload: Check for the NETDEV_UNREGISTER event

zhong jiang (1):
      usb: typec: fusb302: Fix an undefined reference to 'extcon_get_state'


--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4bbaoACgkQONu9yGCS
aT4q0w/9Hr/kjkOJ3NMl3LlCVxjTYSZVOuImQYhN5cPMxyapaydDEiDR+zaM27s3
UeEJbSiOQRCh/Jo79m6c2nYd4qo7M1eB02WpWC36K+VoN/Ea1OWqcfpa3NSsUWcU
225YSQYfTyKpzFAVmqnQ6yCRu6ujwv5Cishj1b99e/f3pZvCoRbUoi0xWLVDceSt
7yCNneRAycDXZ52ROEO+RCT6KgFFvnz/FUwp3/5wE+uP2X+QCkFupcG/NfspQW8p
adxIXukv+bdL5hgJD+3TbUMA6DN8y2sY1Kq+3uCsVYe6CUp5jWmO/y79+8EaUeLE
LitsQvmV0+LPZDZos8aYDQ+iVFa/yCQz6C1wxTi2divqb3r3sIIQ60bXh6uuEW9O
uAmr9JUsOjL/t40hIQTsmrOMcUycJys/Cnh+R0fzjYa83ta52wFhPV0Zmvlnmvy6
j+iWtOf/L4l/LmdQTmX7/cT0s6NE1eI1D+xEdW6EsbSJXmz2jTamcjJweee973Gz
DqDRDlqVF9RnUFnZ3Jd2xQTLjZwGW2zVYZKT1wrKJR/njPgn/bHzwyvPv3/UUmYS
sdcZnE/5HnLfxw5/IW541dYS1f63v7Ouz2sysKK3KqbR5prSsKytXJJ6ta84cSPI
w68q/QNLDUu1rVr3UVuET5iA2cT5tGUDgbpO7JCXtC4jFsQhH0k=
=1xEe
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
