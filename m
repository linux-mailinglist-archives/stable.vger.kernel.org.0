Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7C5137ECC
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbgAKKN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:13:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729781AbgAKKN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:13:57 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0988B206DA;
        Sat, 11 Jan 2020 10:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737636;
        bh=5eqdvSdQKsVfZCIePLZyAkz8xwbMI65ggrJUycU9UfU=;
        h=From:To:Cc:Subject:Date:From;
        b=llu6/0zzTYEZqriviNYmF1hf9c/s/IMfco8xr7S2ysxUOKQs5Ph4TilyJ/J4wHUEp
         UfuGNvWszh05sBB4KPf1fYumdVKQAM64PaqLzCLWzint/OxVvXTLpatQhRJDLf9yYW
         vfhJsB/Wewy5HsS9EtOuIjodDK1pgx9wtA8tIsbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/84] 4.19.95-stable review
Date:   Sat, 11 Jan 2020 10:49:37 +0100
Message-Id: <20200111094845.328046411@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.95-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.95-rc1
X-KernelTest-Deadline: 2020-01-13T09:49+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.95 release.
There are 84 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.95-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.95-rc1

Qi Zhou <atmgnd@outlook.com>
    usb: missing parentheses in USE_NEW_SCHEME

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit ME910G1 0x110a composition

Johan Hovold <johan@kernel.org>
    USB: core: fix check for duplicate endpoints

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix request complete check

Petr Machata <petrm@mellanox.com>
    net: sch_prio: When ungrafting, replace with FIFO

Petr Machata <petrm@mellanox.com>
    mlxsw: spectrum_qdisc: Ignore grafting of invisible FIFO

Eric Dumazet <edumazet@google.com>
    vlan: vlan_changelink() should propagate errors

Eric Dumazet <edumazet@google.com>
    vlan: fix memory leak in vlan_dev_set_egress_priority

Hangbin Liu <liuhangbin@gmail.com>
    vxlan: fix tos value before xmit

Pengcheng Yang <yangpc@wangsu.com>
    tcp: fix "old stuff" D-SACK causing SACK to be treated as D-SACK

Xin Long <lucien.xin@gmail.com>
    sctp: free cmd->obj.chunk for the unprocessed SCTP_CMD_REPLY

Wen Yang <wenyang@linux.alibaba.com>
    sch_cake: avoid possible divide by zero in cake_enqueue()

Eric Dumazet <edumazet@google.com>
    pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM

Eric Dumazet <edumazet@google.com>
    net: usb: lan78xx: fix possible skb leak

Chen-Yu Tsai <wens@csie.org>
    net: stmmac: dwmac-sunxi: Allow all RGMII modes

Chen-Yu Tsai <wens@csie.org>
    net: stmmac: dwmac-sun8i: Allow all RGMII modes

Andrew Lunn <andrew@lunn.ch>
    net: dsa: mv88e6xxx: Preserve priority when setting CPU port.

Eric Dumazet <edumazet@google.com>
    macvlan: do not assume mac_header is set in macvlan_broadcast()

Eric Dumazet <edumazet@google.com>
    gtp: fix bad unlock balance in gtp_encap_enable_socket

Marc Zyngier <marc.zyngier@arm.com>
    arm64: KVM: Trap VM ops when ARM64_WORKAROUND_CAVIUM_TX2_219_TVM is set

Logan Gunthorpe <logang@deltatee.com>
    PCI/switchtec: Read all 64 bits of part_event_bitmap

Anson Huang <Anson.Huang@nxp.com>
    ARM: dts: imx6ul: use nvmem-cells for cpu speed grading

Anson Huang <Anson.Huang@nxp.com>
    cpufreq: imx6q: read OCOTP through nvmem for imx6ul/imx6ull

Jason A. Donenfeld <Jason@zx2c4.com>
    powerpc/spinlocks: Include correct header for static key

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    powerpc/vcpu: Assume dedicated processors as non-preempt

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix unwanted rx_table reset

Chan Shu Tak, Alex <alexchan@task.com.hk>
    llc2: Fix return statement of llc_stat_ev_rx_null_dsap_xid_c (and _test_c)

Helge Deller <deller@gmx.de>
    parisc: Fix compiler warnings in debug_core.c

Yang Yingliang <yangyingliang@huawei.com>
    block: fix memleak when __blk_rq_map_user_iov() is failed

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix memleak in path handling error case

Jan Höppner <hoeppner@linux.ibm.com>
    s390/dasd/cio: Interpret ccw_device_get_mdc return value correctly

Chuhong Yuan <hslester96@gmail.com>
    drm/exynos: gsc: add missed component_del

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/purgatory: do not build purgatory with kcov, kasan and friends

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: Always arm TX Timer at end of transmission start

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: RX buffer size must be 16 byte aligned

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: xgmac: Clear previous RX buffer size

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: Do not accept invalid MTU values

Eric Sandeen <sandeen@redhat.com>
    fs: avoid softlockups in s_inodes iterators

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    perf/x86/intel: Fix PT PMI handling

Thomas Hebb <tommyhebb@gmail.com>
    kconfig: don't crash on NULL expressions in expr_eq()

Xiaotao Yin <xiaotao.yin@windriver.com>
    iommu/iova: Init the struct iova to fix the possible memleak

Andreas Kemnade <andreas@kemnade.info>
    regulator: rn5t618: fix module aliases

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: wm8962: fix lambda value

Aditya Pakki <pakki001@umn.edu>
    rfkill: Fix incorrect check to avoid NULL pointer dereference

Sven Schnelle <svens@stackframe.org>
    parisc: add missing __init annotation

Cristian Birsan <cristian.birsan@microchip.com>
    net: usb: lan78xx: Fix error message format specifier

Vishal Kulkarni <vishal@chelsio.com>
    cxgb4: Fix kernel panic while accessing sge_info

Manish Chopra <manishc@marvell.com>
    bnx2x: Fix logic to get total no. of PFs per engine

Manish Chopra <manishc@marvell.com>
    bnx2x: Do not handle requests from VFs after parity

Lorenz Bauer <lmb@cloudflare.com>
    bpf: Clear skb->tstamp in bpf_redirect when necessary

Nikolay Borisov <nborisov@suse.com>
    btrfs: Fix error messages in qgroup_rescan_init

Mike Rapoport <rppt@linux.ibm.com>
    powerpc: Ensure that swiotlb buffer is allocated from low memory

Daniel T. Lee <danieltimlee@gmail.com>
    samples: bpf: fix syscall_tp due to unused syscall

Daniel T. Lee <danieltimlee@gmail.com>
    samples: bpf: Replace symbol compare of trace_event

Tomi Valkeinen <tomi.valkeinen@ti.com>
    ARM: dts: am437x-gp/epos-evm: fix panel compatible

Vignesh Raghavendra <vigneshr@ti.com>
    spi: spi-ti-qspi: Fix a bug when accessing non default CS

Paul Chaignon <paul.chaignon@orange.com>
    bpf, mips: Limit to 33 tail calls

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Return error if FW returns more data than dump length

Stefan Wahren <wahrenst@gmx.net>
    ARM: dts: bcm283x: Fix critical trip point

Dragos Tarcatu <dragos_tarcatu@mentor.com>
    ASoC: topology: Check return value for soc_tplg_pcm_create()

Chuhong Yuan <hslester96@gmail.com>
    spi: spi-cavium-thunderx: Add missing pci_release_regions()

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: Cygnus: Fix MDIO node address/size cells

Masami Hiramatsu <mhiramat@kernel.org>
    selftests/ftrace: Fix multiple kprobe testcase

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: BCM5301X: Fix MDIO node address/size cells

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: validate NFT_DATA_VALUE after nft_data_init()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: validate NFT_SET_ELEM_INTERVAL_END

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: bogus lookup/get on consecutive elements in named sets

Phil Sutter <phil@nwl.cc>
    netfilter: uapi: Avoid undefined left-shift in xt_sctp.h

Sudeep Holla <sudeep.holla@arm.com>
    ARM: vexpress: Set-up shared OPP table instead of individual for each CPU

Stefan Roese <sr@denx.de>
    ARM: dts: imx6ul: imx6ul-14x14-evk.dtsi: Fix SPI NOR probing

Arvind Sankar <nivedita@alum.mit.edu>
    efi/gop: Fix memory leak in __gop_query32/64()

Arvind Sankar <nivedita@alum.mit.edu>
    efi/gop: Return EFI_SUCCESS if a usable GOP was found

Arvind Sankar <nivedita@alum.mit.edu>
    efi/gop: Return EFI_NOT_FOUND if there are no usable GOPs

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Update quirk for Teclast X89

Dave Young <dyoung@redhat.com>
    x86/efi: Update e820 with reserved EFI boot services data to fix kexec breakage

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    libtraceevent: Fix lib installation with O=

qize wang <wangqize888888888@gmail.com>
    mwifiex: Fix heap overflow in mmwifiex_process_tdls_action_frame()

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: netns exit must wait for callbacks

Marco Elver <elver@google.com>
    locking/spinlock/debug: Fix various data races

Tzung-Bi Shih <tzungbi@google.com>
    ASoC: max98090: fix possible race conditions

Wen Yang <wenyang@linux.alibaba.com>
    regulator: fix use after free issue

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix passing modified ctx to ld/abs/ind instruction

Andrey Konovalov <andreyknvl@google.com>
    USB: dummy-hcd: increase max number of devices to 32

Andrey Konovalov <andreyknvl@google.com>
    USB: dummy-hcd: use usb_urb_dir_in instead of usb_pipein


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/am437x-gp-evm.dts                |  2 +-
 arch/arm/boot/dts/am43x-epos-evm.dts               |  2 +-
 arch/arm/boot/dts/bcm-cygnus.dtsi                  |  4 +-
 arch/arm/boot/dts/bcm283x.dtsi                     |  2 +-
 arch/arm/boot/dts/bcm5301x.dtsi                    |  4 +-
 arch/arm/boot/dts/imx6ul-14x14-evk.dtsi            |  2 +-
 arch/arm/boot/dts/imx6ul.dtsi                      |  6 ++
 arch/arm/mach-vexpress/spc.c                       | 12 +++-
 arch/arm64/include/asm/cpucaps.h                   |  3 +-
 arch/arm64/kvm/hyp/switch.c                        | 69 ++++++++++++++++++-
 arch/mips/net/ebpf_jit.c                           |  9 +--
 arch/parisc/include/asm/cmpxchg.h                  | 10 ++-
 arch/parisc/kernel/drivers.c                       |  2 +-
 arch/powerpc/include/asm/spinlock.h                |  5 +-
 arch/powerpc/mm/mem.c                              |  8 +++
 arch/powerpc/platforms/pseries/setup.c             |  7 ++
 arch/s390/purgatory/Makefile                       |  6 +-
 arch/s390/purgatory/string.c                       |  3 +
 arch/x86/events/core.c                             |  9 ++-
 arch/x86/platform/efi/quirks.c                     |  6 +-
 block/blk-map.c                                    |  2 +-
 drivers/cpufreq/imx6q-cpufreq.c                    | 52 +++++++++-----
 drivers/firmware/efi/libstub/gop.c                 | 80 +++++-----------------
 drivers/gpu/drm/exynos/exynos_drm_gsc.c            |  1 +
 drivers/iommu/iova.c                               |  2 +-
 drivers/net/dsa/mv88e6xxx/global1.c                |  5 ++
 drivers/net/dsa/mv88e6xxx/global1.h                |  1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h    |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   | 12 +++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h  |  1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c   | 12 ++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 38 +++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h  |  4 ++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |  4 ++
 .../net/ethernet/mellanox/mlxsw/spectrum_qdisc.c   |  7 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |  3 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c  |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |  2 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |  3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 16 ++++-
 drivers/net/gtp.c                                  |  5 +-
 drivers/net/hyperv/hyperv_net.h                    |  3 +-
 drivers/net/hyperv/netvsc_drv.c                    |  4 +-
 drivers/net/hyperv/rndis_filter.c                  | 10 ++-
 drivers/net/macvlan.c                              |  2 +-
 drivers/net/usb/lan78xx.c                          | 11 ++-
 drivers/net/vxlan.c                                |  4 +-
 drivers/net/wireless/marvell/mwifiex/tdls.c        | 70 +++++++++++++++++--
 drivers/pci/switch/switchtec.c                     |  4 +-
 drivers/regulator/core.c                           |  4 +-
 drivers/regulator/rn5t618-regulator.c              |  1 +
 drivers/s390/block/dasd_eckd.c                     | 28 ++------
 drivers/s390/cio/device_ops.c                      |  2 +-
 drivers/spi/spi-cavium-thunderx.c                  |  2 +
 drivers/spi/spi-ti-qspi.c                          |  6 +-
 drivers/usb/core/config.c                          | 70 +++++++++++++++----
 drivers/usb/core/hub.c                             |  2 +-
 drivers/usb/dwc3/gadget.c                          |  7 ++
 drivers/usb/gadget/udc/dummy_hcd.c                 | 10 +--
 drivers/usb/serial/option.c                        |  2 +
 fs/btrfs/qgroup.c                                  |  4 +-
 fs/drop_caches.c                                   |  2 +-
 fs/inode.c                                         |  7 ++
 fs/notify/fsnotify.c                               |  1 +
 fs/quota/dquot.c                                   |  1 +
 include/linux/if_ether.h                           |  8 +++
 include/uapi/linux/netfilter/xt_sctp.h             |  6 +-
 kernel/bpf/verifier.c                              |  9 ++-
 kernel/locking/spinlock_debug.c                    | 32 ++++-----
 net/8021q/vlan.h                                   |  1 +
 net/8021q/vlan_dev.c                               |  3 +-
 net/8021q/vlan_netlink.c                           | 19 +++--
 net/core/filter.c                                  |  1 +
 net/ipv4/tcp_input.c                               |  5 +-
 net/llc/llc_station.c                              |  4 +-
 net/netfilter/nf_conntrack_netlink.c               |  3 +
 net/netfilter/nf_tables_api.c                      | 16 +++--
 net/netfilter/nft_bitwise.c                        |  4 +-
 net/netfilter/nft_cmp.c                            |  6 ++
 net/netfilter/nft_range.c                          | 10 +++
 net/netfilter/nft_set_rbtree.c                     | 21 ++++--
 net/rfkill/core.c                                  |  7 +-
 net/sched/sch_cake.c                               |  2 +-
 net/sched/sch_fq.c                                 |  6 +-
 net/sched/sch_prio.c                               | 10 ++-
 net/sctp/sm_sideeffect.c                           | 28 +++++---
 samples/bpf/syscall_tp_kern.c                      | 18 ++++-
 samples/bpf/trace_event_user.c                     |  4 +-
 scripts/kconfig/expr.c                             |  7 ++
 sound/soc/codecs/max98090.c                        |  8 +--
 sound/soc/codecs/max98090.h                        |  1 -
 sound/soc/codecs/wm8962.c                          |  4 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |  8 ++-
 sound/soc/soc-topology.c                           |  8 ++-
 tools/lib/traceevent/Makefile                      |  1 +
 .../ftrace/test.d/kprobe/multiple_kprobes.tc       |  6 +-
 97 files changed, 677 insertions(+), 275 deletions(-)


