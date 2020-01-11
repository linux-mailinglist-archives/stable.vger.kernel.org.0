Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4105137E60
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgAKKJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:09:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729097AbgAKKJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:09:08 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8C7F2084D;
        Sat, 11 Jan 2020 10:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737347;
        bh=PEwOsFMQOxumsX4xKqb6JUTlevSFnqhG0x90YoRBBGc=;
        h=From:To:Cc:Subject:Date:From;
        b=VEq0991ylLYnMDIsz4KCOn9OEdQ1NjSxnX7IXRoRws1fJ2J9tCWGQuH+zjHkG8eGm
         193XZWGHRRprBv5rL9cjHy55dmx3ei/GSmb7FfLuRHBlaAfYEqfCkmuO+KfyCrCvf+
         RvYkXxV82+L0geOV/4EBXKhPhb7Qfb8uuYIe8WqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/62] 4.14.164-stable review
Date:   Sat, 11 Jan 2020 10:49:42 +0100
Message-Id: <20200111094837.425430968@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.164-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.164-rc1
X-KernelTest-Deadline: 2020-01-13T09:48+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.164 release.
There are 62 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.164-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.164-rc1

Eric Dumazet <edumazet@google.com>
    vlan: fix memory leak in vlan_dev_set_egress_priority

Petr Machata <petrm@mellanox.com>
    net: sch_prio: When ungrafting, replace with FIFO

Eric Dumazet <edumazet@google.com>
    vlan: vlan_changelink() should propagate errors

Hangbin Liu <liuhangbin@gmail.com>
    vxlan: fix tos value before xmit

Pengcheng Yang <yangpc@wangsu.com>
    tcp: fix "old stuff" D-SACK causing SACK to be treated as D-SACK

Xin Long <lucien.xin@gmail.com>
    sctp: free cmd->obj.chunk for the unprocessed SCTP_CMD_REPLY

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit ME910G1 0x110a composition

Johan Hovold <johan@kernel.org>
    USB: core: fix check for duplicate endpoints

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

Mathieu Malaterre <malat@debian.org>
    mmc: block: propagate correct returned value in mmc_rpmb_ioctl

Alexander Kappner <agk@godking.net>
    mmc: core: Prevent bus reference leak in mmc_blk_init()

Linus Walleij <linus.walleij@linaro.org>
    mmc: block: Fix bug when removing RPMB chardev

Linus Walleij <linus.walleij@linaro.org>
    mmc: block: Delete mmc_access_rpmb()

Linus Walleij <linus.walleij@linaro.org>
    mmc: block: Convert RPMB to a character device

Logan Gunthorpe <logang@deltatee.com>
    PCI/switchtec: Read all 64 bits of part_event_bitmap

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix passing modified ctx to ld/abs/ind instruction

Daniel Borkmann <daniel@iogearbox.net>
    bpf: reject passing modified ctx to helper functions

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

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: RX buffer size must be 16 byte aligned

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: Do not accept invalid MTU values

Eric Sandeen <sandeen@redhat.com>
    fs: avoid softlockups in s_inodes iterators

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    perf/x86/intel: Fix PT PMI handling

Thomas Hebb <tommyhebb@gmail.com>
    kconfig: don't crash on NULL expressions in expr_eq()

Andreas Kemnade <andreas@kemnade.info>
    regulator: rn5t618: fix module aliases

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: wm8962: fix lambda value

Aditya Pakki <pakki001@umn.edu>
    rfkill: Fix incorrect check to avoid NULL pointer dereference

Cristian Birsan <cristian.birsan@microchip.com>
    net: usb: lan78xx: Fix error message format specifier

Manish Chopra <manishc@marvell.com>
    bnx2x: Fix logic to get total no. of PFs per engine

Manish Chopra <manishc@marvell.com>
    bnx2x: Do not handle requests from VFs after parity

Mike Rapoport <rppt@linux.ibm.com>
    powerpc: Ensure that swiotlb buffer is allocated from low memory

Daniel T. Lee <danieltimlee@gmail.com>
    samples: bpf: fix syscall_tp due to unused syscall

Daniel T. Lee <danieltimlee@gmail.com>
    samples: bpf: Replace symbol compare of trace_event

Tomi Valkeinen <tomi.valkeinen@ti.com>
    ARM: dts: am437x-gp/epos-evm: fix panel compatible

Paul Chaignon <paul.chaignon@orange.com>
    bpf, mips: Limit to 33 tail calls

Stefan Wahren <wahrenst@gmx.net>
    ARM: dts: bcm283x: Fix critical trip point

Dragos Tarcatu <dragos_tarcatu@mentor.com>
    ASoC: topology: Check return value for soc_tplg_pcm_create()

Chuhong Yuan <hslester96@gmail.com>
    spi: spi-cavium-thunderx: Add missing pci_release_regions()

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: Cygnus: Fix MDIO node address/size cells

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: validate NFT_SET_ELEM_INTERVAL_END

Phil Sutter <phil@nwl.cc>
    netfilter: uapi: Avoid undefined left-shift in xt_sctp.h

Sudeep Holla <sudeep.holla@arm.com>
    ARM: vexpress: Set-up shared OPP table instead of individual for each CPU

Arvind Sankar <nivedita@alum.mit.edu>
    efi/gop: Fix memory leak in __gop_query32/64()

Arvind Sankar <nivedita@alum.mit.edu>
    efi/gop: Return EFI_SUCCESS if a usable GOP was found

Arvind Sankar <nivedita@alum.mit.edu>
    efi/gop: Return EFI_NOT_FOUND if there are no usable GOPs

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

Andrey Konovalov <andreyknvl@google.com>
    USB: dummy-hcd: increase max number of devices to 32

Andrey Konovalov <andreyknvl@google.com>
    USB: dummy-hcd: use usb_urb_dir_in instead of usb_pipein


-------------

Diffstat:

 Makefile                                          |   4 +-
 arch/arm/boot/dts/am437x-gp-evm.dts               |   2 +-
 arch/arm/boot/dts/am43x-epos-evm.dts              |   2 +-
 arch/arm/boot/dts/bcm-cygnus.dtsi                 |   4 +-
 arch/arm/boot/dts/bcm283x.dtsi                    |   2 +-
 arch/arm/mach-vexpress/spc.c                      |  12 +-
 arch/mips/net/ebpf_jit.c                          |   9 +-
 arch/parisc/include/asm/cmpxchg.h                 |  10 +-
 arch/powerpc/mm/mem.c                             |   8 +
 arch/x86/events/core.c                            |   9 +-
 arch/x86/platform/efi/quirks.c                    |   6 +-
 block/blk-map.c                                   |   2 +-
 drivers/firmware/efi/libstub/gop.c                |  80 ++----
 drivers/mmc/core/block.c                          | 300 +++++++++++++++++++---
 drivers/mmc/core/queue.c                          |   2 +-
 drivers/mmc/core/queue.h                          |   4 +-
 drivers/net/dsa/mv88e6xxx/global1.c               |   5 +
 drivers/net/dsa/mv88e6xxx/global1.h               |   1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  12 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h |   1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c  |  12 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c |   3 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  14 +-
 drivers/net/gtp.c                                 |   5 +-
 drivers/net/hyperv/hyperv_net.h                   |   3 +-
 drivers/net/hyperv/netvsc_drv.c                   |   4 +-
 drivers/net/hyperv/rndis_filter.c                 |  10 +-
 drivers/net/macvlan.c                             |   2 +-
 drivers/net/usb/lan78xx.c                         |  11 +-
 drivers/net/vxlan.c                               |   4 +-
 drivers/net/wireless/marvell/mwifiex/tdls.c       |  70 ++++-
 drivers/pci/switch/switchtec.c                    |   4 +-
 drivers/regulator/rn5t618-regulator.c             |   1 +
 drivers/s390/block/dasd_eckd.c                    |  28 +-
 drivers/s390/cio/device_ops.c                     |   2 +-
 drivers/spi/spi-cavium-thunderx.c                 |   2 +
 drivers/usb/core/config.c                         |  70 ++++-
 drivers/usb/gadget/udc/dummy_hcd.c                |  10 +-
 drivers/usb/serial/option.c                       |   2 +
 fs/drop_caches.c                                  |   2 +-
 fs/inode.c                                        |   7 +
 fs/notify/fsnotify.c                              |   1 +
 fs/quota/dquot.c                                  |   1 +
 include/linux/if_ether.h                          |   8 +
 include/uapi/linux/netfilter/xt_sctp.h            |   6 +-
 kernel/bpf/verifier.c                             |  54 ++--
 kernel/locking/spinlock_debug.c                   |  32 +--
 net/8021q/vlan.h                                  |   1 +
 net/8021q/vlan_dev.c                              |   3 +-
 net/8021q/vlan_netlink.c                          |  19 +-
 net/ipv4/tcp_input.c                              |   5 +-
 net/llc/llc_station.c                             |   4 +-
 net/netfilter/nf_conntrack_netlink.c              |   3 +
 net/netfilter/nf_tables_api.c                     |  12 +-
 net/rfkill/core.c                                 |   7 +-
 net/sched/sch_fq.c                                |   2 +-
 net/sched/sch_prio.c                              |  10 +-
 net/sctp/sm_sideeffect.c                          |  28 +-
 samples/bpf/syscall_tp_kern.c                     |  18 +-
 samples/bpf/trace_event_user.c                    |   4 +-
 scripts/kconfig/expr.c                            |   7 +
 sound/soc/codecs/wm8962.c                         |   4 +-
 sound/soc/soc-topology.c                          |   8 +-
 tools/lib/traceevent/Makefile                     |   1 +
 tools/testing/selftests/bpf/test_verifier.c       |  58 ++++-
 67 files changed, 778 insertions(+), 263 deletions(-)


