Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E98D1137F8C
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgAKKUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:20:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729413AbgAKKUx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:20:53 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E41B4205F4;
        Sat, 11 Jan 2020 10:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738051;
        bh=Th964owD6ZNFcg7pfFeWWXFQNB4vPWEUFD6CkUASc+M=;
        h=From:To:Cc:Subject:Date:From;
        b=aSoWEbaHqnud/+066fHeBPZbHQsUKf2XFZob9TSuC26oyUaASFE0q9amxLZ8Y7XJ5
         dQvpcZLNOW25bO9XULc7q2UEc0ablXKkOEf+yjIwoKVKlxTjHrpkQaqrZyI7w0e6t0
         BWIkeaL+cabi8aCCdO0BcFalWzA1IV29J1VmtHKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/165] 5.4.11-stable review
Date:   Sat, 11 Jan 2020 10:48:39 +0100
Message-Id: <20200111094921.347491861@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.11-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.11-rc1
X-KernelTest-Deadline: 2020-01-13T09:49+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.11 release.
There are 165 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.11-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.11-rc1

Qi Zhou <atmgnd@outlook.com>
    usb: missing parentheses in USE_NEW_SCHEME

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit ME910G1 0x110a composition

Johan Hovold <johan@kernel.org>
    USB: core: fix check for duplicate endpoints

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix request complete check

Erez Shitrit <erezsh@mellanox.com>
    net/mlx5: DR, Init lists that are used in rule's member

Eli Cohen <eli@mellanox.com>
    net/mlx5e: Fix hairpin RSS table size

Yevgeny Kliteynik <kliteyn@mellanox.com>
    net/mlx5: DR, No need for atomic refcount for internal SW steering resources

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx5e: Always print health reporter message to dmesg

Baruch Siach <baruch@tkos.co.il>
    net: dsa: mv88e6xxx: force cmode write on 6141/6341

Michael Guralnik <michaelgur@mellanox.com>
    net/mlx5: Move devlink registration before interfaces load

Stephen Boyd <sboyd@kernel.org>
    macb: Don't unregister clks unconditionally

Eric Dumazet <edumazet@google.com>
    vlan: vlan_changelink() should propagate errors

Eric Dumazet <edumazet@google.com>
    vlan: fix memory leak in vlan_dev_set_egress_priority

Petr Machata <petrm@mellanox.com>
    net: sch_prio: When ungrafting, replace with FIFO

Petr Machata <petrm@mellanox.com>
    mlxsw: spectrum_qdisc: Ignore grafting of invisible FIFO

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

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: Fixed link does not need MDIO Bus

Chen-Yu Tsai <wens@csie.org>
    net: stmmac: dwmac-sunxi: Allow all RGMII modes

Chen-Yu Tsai <wens@csie.org>
    net: stmmac: dwmac-sun8i: Allow all RGMII modes

Andrew Lunn <andrew@lunn.ch>
    net: freescale: fec: Fix ethtool -d runtime PM

Andrew Lunn <andrew@lunn.ch>
    net: dsa: mv88e6xxx: Preserve priority when setting CPU port.

Eric Dumazet <edumazet@google.com>
    macvlan: do not assume mac_header is set in macvlan_broadcast()

Eric Dumazet <edumazet@google.com>
    gtp: fix bad unlock balance in gtp_encap_enable_socket

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Do not create directories if lockdown is in affect

Hangbin Liu <liuhangbin@gmail.com>
    selftests: pmtu: fix init mtu value in description

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix unwanted rx_table reset

Chan Shu Tak, Alex <alexchan@task.com.hk>
    llc2: Fix return statement of llc_stat_ev_rx_null_dsap_xid_c (and _test_c)

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: don't return -ENOTSUPP to userspace

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: fix promiscuous mode after reset

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: handle error due to unsupported transport mode

David Jeffery <djeffery@redhat.com>
    sbitmap: only queue kyber's wait callback if not already active

Helge Deller <deller@gmx.de>
    parisc: Fix compiler warnings in debug_core.c

Yang Yingliang <yangyingliang@huawei.com>
    block: fix memleak when __blk_rq_map_user_iov() is failed

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix memleak in path handling error case

Jan Höppner <hoeppner@linux.ibm.com>
    s390/dasd/cio: Interpret ccw_device_get_mdc return value correctly

Bart Van Assche <bvanassche@acm.org>
    block: Fix a lockdep complaint triggered by request queue flushing

Wei Li <liwei391@huawei.com>
    arm64: cpu_errata: Add Hisilicon TSV110 to spectre-v2 safe list

Enrico Weigelt, metux IT consult <info@metux.net>
    platform/x86: pcengines-apuv2: fix simswap GPIO assignment

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/ixgbe: Fix concurrency issues between config flow and XSK

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/i40e: Fix concurrency issues between config flow and XSK

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Fix concurrency issues between config flow and XSK

Maxim Mikityanskiy <maximmi@mellanox.com>
    xsk: Add rcu_read_lock around the XSK wakeup

Pavel Tatashin <pasha.tatashin@soleen.com>
    tpm/tpm_ftpm_tee: add shutdown call back

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

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: Determine earlier the size of RX buffer

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: selftests: Needs to check the number of Multicast regs

Olof Johansson <olof@lixom.net>
    clk: Move clk_core_reparent_orphans() under CONFIG_OF

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: don't wait when under-submitting

Robin Murphy <robin.murphy@arm.com>
    iommu/dma: Relax locking in iommu_dma_prepare_msi()

Hanjun Guo <guohanjun@huawei.com>
    perf/smmuv3: Remove the leftover put_cpu() in error path

Eric Sandeen <sandeen@redhat.com>
    fs: call fsnotify_sb_delete after evict_inodes

Eric Sandeen <sandeen@redhat.com>
    fs: avoid softlockups in s_inodes iterators

Roman Penyaev <rpenyaev@suse.de>
    block: end bio with BLK_STS_AGAIN in case of non-mq devs and REQ_NOWAIT

zhong jiang <zhongjiang@huawei.com>
    usb: typec: fusb302: Fix an undefined reference to 'extcon_get_state'

Johannes Weiner <hannes@cmpxchg.org>
    psi: Fix a division error in psi poll()

Johannes Weiner <hannes@cmpxchg.org>
    sched/psi: Fix sampling error and rare div0 crashes with cgroups and high uptime

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    perf/x86/intel: Fix PT PMI handling

Peter Zijlstra <peterz@infradead.org>
    perf/x86: Fix potential out-of-bounds access

Enrico Weigelt, metux IT consult <info@metux.net>
    scripts: package: mkdebian: add missing rsync dependency

Thomas Hebb <tommyhebb@gmail.com>
    kconfig: don't crash on NULL expressions in expr_eq()

Xiaotao Yin <xiaotao.yin@windriver.com>
    iommu/iova: Init the struct iova to fix the possible memleak

Brendan Higgins <brendanhiggins@google.com>
    staging: axis-fifo: add unspecified HAS_IOMEM dependency

Alexandre Belloni <alexandre.belloni@bootlin.com>
    clk: at91: fix possible deadlock

Michael Walle <michael@walle.cc>
    spi: nxp-fspi: Ensure width is respected in spi-mem operations

Andreas Kemnade <andreas@kemnade.info>
    regulator: rn5t618: fix module aliases

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: wm8962: fix lambda value

Aditya Pakki <pakki001@umn.edu>
    rfkill: Fix incorrect check to avoid NULL pointer dereference

Sven Schnelle <svens@stackframe.org>
    parisc: add missing __init annotation

Sven Schnelle <svens@stackframe.org>
    parisc: fix compilation when KEXEC=n and KEXEC_FILE=y

Cristian Birsan <cristian.birsan@microchip.com>
    net: usb: lan78xx: Fix error message format specifier

Vishal Kulkarni <vishal@chelsio.com>
    cxgb4: Fix kernel panic while accessing sge_info

Manish Chopra <manishc@marvell.com>
    bnx2x: Fix logic to get total no. of PFs per engine

Manish Chopra <manishc@marvell.com>
    bnx2x: Do not handle requests from VFs after parity

Chen Wandun <chenwandun@huawei.com>
    habanalabs: remove variable 'val' set but not used

Oded Gabbay <oded.gabbay@gmail.com>
    habanalabs: rate limit error msg on waiting for CS

Lorenz Bauer <lmb@cloudflare.com>
    bpf: Clear skb->tstamp in bpf_redirect when necessary

Frederic Barrat <fbarrat@linux.ibm.com>
    ocxl: Fix potential memory leak on context creation

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix hole extent items with a zero size after range cloning

Josef Bacik <josef@toxicpanda.com>
    btrfs: handle error in btrfs_cache_block_group

Jason A. Donenfeld <Jason@zx2c4.com>
    powerpc/spinlocks: Include correct header for static key

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    powerpc/vcpu: Assume dedicated processors as non-preempt

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix cloning range with a hole when using the NO_HOLES feature

Nikolay Borisov <nborisov@suse.com>
    btrfs: Fix error messages in qgroup_rescan_init

Mike Rapoport <rppt@linux.ibm.com>
    powerpc: Ensure that swiotlb buffer is allocated from low memory

Alexandre Torgue <alexandre.torgue@st.com>
    pinctrl: pinmux: fix a possible null pointer in pinmux_can_be_used_for_gpio

Stefan Bühler <source@stbuehler.de>
    cfg80211: fix double-free after changing network namespace

Fredrik Olofsson <fredrik.olofsson@anyfinetworks.com>
    mac80211: fix TID field in monitor mode transmit

Jerome Brunet <jbrunet@baylibre.com>
    clk: walk orphan list on clock provider registration

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix missing reset delay handling

Andrew Jeffery <andrew@aj.id.au>
    pinctrl: aspeed-g6: Fix LPC/eSPI mux configuration

Leonard Crestez <leonard.crestez@nxp.com>
    ARM: imx_v6_v7_defconfig: Explicitly restore CONFIG_DEBUG_FS

Michael Walle <michael@walle.cc>
    arm64: dts: ls1028a: fix reboot node

Daniel T. Lee <danieltimlee@gmail.com>
    samples: bpf: fix syscall_tp due to unused syscall

Daniel T. Lee <danieltimlee@gmail.com>
    samples: bpf: Replace symbol compare of trace_event

SeongJae Park <sjpark@amazon.de>
    kselftest: Support old perl versions

SeongJae Park <sjpark@amazon.de>
    kselftest/runner: Print new line in print of timeout log

Tomi Valkeinen <tomi.valkeinen@ti.com>
    ARM: dts: am437x-gp/epos-evm: fix panel compatible

Vignesh Raghavendra <vigneshr@ti.com>
    spi: spi-ti-qspi: Fix a bug when accessing non default CS

Michael Petlan <mpetlan@redhat.com>
    perf header: Fix false warning when there are no duplicate cache entries

Kajol Jain <kjain@linux.ibm.com>
    perf metricgroup: Fix printing event names of metric group with multiple events

Toke Høiland-Jørgensen <toke@redhat.com>
    bpftool: Don't crash on missing jited insns or ksyms

Paul Chaignon <paul.chaignon@orange.com>
    bpf, mips: Limit to 33 tail calls

Paul Chaignon <paul.chaignon@orange.com>
    bpf, riscv: Limit to 33 tail calls

Michael Walle <michael@walle.cc>
    arm64: dts: ls1028a: fix typo in TMU calibration data

Stefan Wahren <wahrenst@gmx.net>
    ARM: dts: bcm283x: Fix critical trip point

Tony Lindgren <tony@atomide.com>
    ARM: omap2plus_defconfig: Add back DEBUG_FS

Mans Rullgard <mans@mansr.com>
    ARM: dts: am335x-sancloud-bbe: fix phy mode

Curtis Malainey <cujomalainey@chromium.org>
    ASoC: SOF: Intel: split cht and byt debug window sizes

Karol Trzcinski <karolx.trzcinski@linux.intel.com>
    ASoC: SOF: loader: snd_sof_fw_parse_ext_data log warning on unknown header

Dragos Tarcatu <dragos_tarcatu@mentor.com>
    ASoC: topology: Check return value for soc_tplg_pcm_create()

Dragos Tarcatu <dragos_tarcatu@mentor.com>
    ASoC: topology: Check return value for snd_soc_add_dai_link()

Geert Uytterhoeven <geert+renesas@glider.be>
    reset: Do not register resource data for missing resets

Chuhong Yuan <hslester96@gmail.com>
    spi: spi-cavium-thunderx: Add missing pci_release_regions()

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: Cygnus: Fix MDIO node address/size cells

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: exynos_defconfig: Restore debugfs support

Masami Hiramatsu <mhiramat@kernel.org>
    selftests: safesetid: Fix Makefile to set correct test program

Masami Hiramatsu <mhiramat@kernel.org>
    selftests: safesetid: Check the return value of setuid/setgid

Masami Hiramatsu <mhiramat@kernel.org>
    selftests: safesetid: Move link library to LDLIBS

Masami Hiramatsu <mhiramat@kernel.org>
    selftests/ftrace: Fix multiple kprobe testcase

Masami Hiramatsu <mhiramat@kernel.org>
    selftests/ftrace: Do not to use absolute debugfs path

Masami Hiramatsu <mhiramat@kernel.org>
    selftests/ftrace: Fix ftrace test cases to check unsupported

Masami Hiramatsu <mhiramat@kernel.org>
    selftests/ftrace: Fix to check the existence of set_ftrace_filter

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: BCM5301X: Fix MDIO node address/size cells

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables_offload: return EOPNOTSUPP if rule specifies no actions

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: skip module reference count bump on object updates

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

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    efi/earlycon: Remap entire framebuffer after page initialization

Arvind Sankar <nivedita@alum.mit.edu>
    efi/gop: Fix memory leak in __gop_query32/64()

Arvind Sankar <nivedita@alum.mit.edu>
    efi/gop: Return EFI_SUCCESS if a usable GOP was found

Arvind Sankar <nivedita@alum.mit.edu>
    efi/gop: Return EFI_NOT_FOUND if there are no usable GOPs

Florian Westphal <fw@strlen.de>
    selftests: netfilter: use randomized netns names

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Update quirk for Teclast X89

Dave Young <dyoung@redhat.com>
    x86/efi: Update e820 with reserved EFI boot services data to fix kexec breakage

Wen Yang <wenyang@linux.alibaba.com>
    regulator: core: fix regulator_register() error paths to properly release rdev

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    libtraceevent: Copy pkg-config file to output folder when using O=

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    libtraceevent: Fix lib installation with O=

qize wang <wangqize888888888@gmail.com>
    mwifiex: Fix heap overflow in mmwifiex_process_tdls_action_frame()

wenxu <wenxu@ucloud.cn>
    netfilter: nf_tables_offload: Check for the NETDEV_UNREGISTER event

Kai-Heng Feng <kai.heng.feng@canonical.com>
    x86/intel: Disable HPET on Intel Ice Lake platforms

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: netns exit must wait for callbacks

Marco Elver <elver@google.com>
    locking/spinlock/debug: Fix various data races

Linus Walleij <linus.walleij@linaro.org>
    spi: fsl: Handle the single hardwired chipselect case

Linus Walleij <linus.walleij@linaro.org>
    gpio: Handle counting of Freescale chipselects

Linus Walleij <linus.walleij@linaro.org>
    spi: fsl: Fix GPIO descriptor support

Tzung-Bi Shih <tzungbi@google.com>
    ASoC: max98090: fix possible race conditions

Wen Yang <wenyang@linux.alibaba.com>
    regulator: fix use after free issue

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    spi: pxa2xx: Add support for Intel Jasper Lake

Shuming Fan <shumingf@realtek.com>
    ASoC: rt5682: fix i2c arbitration lost issue

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix passing modified ctx to ld/abs/ind instruction

Andrey Konovalov <andreyknvl@google.com>
    USB: dummy-hcd: use usb_urb_dir_in instead of usb_pipein


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/am335x-sancloud-bbe.dts          |   2 +-
 arch/arm/boot/dts/am437x-gp-evm.dts                |   2 +-
 arch/arm/boot/dts/am43x-epos-evm.dts               |   2 +-
 arch/arm/boot/dts/bcm-cygnus.dtsi                  |   4 +-
 arch/arm/boot/dts/bcm283x.dtsi                     |   2 +-
 arch/arm/boot/dts/bcm5301x.dtsi                    |   4 +-
 arch/arm/boot/dts/imx6ul-14x14-evk.dtsi            |   2 +-
 arch/arm/configs/exynos_defconfig                  |   1 +
 arch/arm/configs/imx_v6_v7_defconfig               |   1 +
 arch/arm/configs/omap2plus_defconfig               |   1 +
 arch/arm/mach-vexpress/spc.c                       |  12 +-
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi     |  10 +-
 arch/arm64/kernel/cpu_errata.c                     |   1 +
 arch/mips/net/ebpf_jit.c                           |   9 +-
 arch/parisc/include/asm/cmpxchg.h                  |  10 +-
 arch/parisc/include/asm/kexec.h                    |   4 -
 arch/parisc/kernel/Makefile                        |   2 +-
 arch/parisc/kernel/drivers.c                       |   2 +-
 arch/powerpc/include/asm/spinlock.h                |   5 +-
 arch/powerpc/mm/mem.c                              |   8 +
 arch/powerpc/platforms/pseries/setup.c             |   7 +
 arch/riscv/net/bpf_jit_comp.c                      |   4 +-
 arch/s390/purgatory/Makefile                       |   6 +-
 arch/s390/purgatory/string.c                       |   3 +
 arch/x86/events/core.c                             |  19 +-
 arch/x86/kernel/early-quirks.c                     |   2 +
 arch/x86/platform/efi/quirks.c                     |   6 +-
 block/blk-core.c                                   |  11 +-
 block/blk-flush.c                                  |   5 +
 block/blk-map.c                                    |   2 +-
 block/blk.h                                        |   1 +
 drivers/bus/ti-sysc.c                              |   4 +
 drivers/char/tpm/tpm_ftpm_tee.c                    |  22 +-
 drivers/clk/at91/at91sam9260.c                     |   2 +-
 drivers/clk/at91/at91sam9rl.c                      |   2 +-
 drivers/clk/at91/at91sam9x5.c                      |   2 +-
 drivers/clk/at91/pmc.c                             |   2 +-
 drivers/clk/at91/sama5d2.c                         |   2 +-
 drivers/clk/at91/sama5d4.c                         |   2 +-
 drivers/clk/clk.c                                  |  62 ++--
 drivers/firmware/efi/earlycon.c                    |  40 +++
 drivers/firmware/efi/libstub/gop.c                 |  80 ++---
 drivers/gpio/gpiolib-of.c                          |  27 ++
 drivers/gpu/drm/exynos/exynos_drm_gsc.c            |   1 +
 drivers/iommu/dma-iommu.c                          |  17 +-
 drivers/iommu/iova.c                               |   2 +-
 drivers/misc/habanalabs/command_submission.c       |   5 +-
 drivers/misc/habanalabs/context.c                  |   2 +-
 drivers/misc/habanalabs/goya/goya.c                |  15 +-
 drivers/misc/ocxl/context.c                        |   8 +-
 drivers/net/dsa/mv88e6xxx/global1.c                |   5 +
 drivers/net/dsa/mv88e6xxx/global1.h                |   1 +
 drivers/net/dsa/mv88e6xxx/port.c                   |  12 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h    |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  12 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h  |   1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c   |  12 +
 drivers/net/ethernet/cadence/macb_main.c           |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |   4 +
 drivers/net/ethernet/freescale/fec_main.c          |   9 +
 drivers/net/ethernet/intel/i40e/i40e.h             |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  10 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   4 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |  16 +
 .../net/ethernet/mellanox/mlx5/core/en/health.c    |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |  22 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  16 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  16 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |   5 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  10 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |  14 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_qdisc.c   |   7 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   3 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c  |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |   2 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  40 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |   4 +
 drivers/net/gtp.c                                  |   5 +-
 drivers/net/hyperv/hyperv_net.h                    |   3 +-
 drivers/net/hyperv/netvsc_drv.c                    |   4 +-
 drivers/net/hyperv/rndis_filter.c                  |  10 +-
 drivers/net/macvlan.c                              |   2 +-
 drivers/net/usb/lan78xx.c                          |  11 +-
 drivers/net/vxlan.c                                |   4 +-
 drivers/net/wireless/marvell/mwifiex/tdls.c        |  70 ++++-
 drivers/perf/arm_smmuv3_pmu.c                      |   4 +-
 drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c         |  24 +-
 drivers/pinctrl/pinmux.c                           |   2 +-
 drivers/platform/x86/pcengines-apuv2.c             |   2 +-
 drivers/regulator/core.c                           |  12 +-
 drivers/regulator/rn5t618-regulator.c              |   1 +
 drivers/reset/core.c                               |   4 +-
 drivers/s390/block/dasd_eckd.c                     |  28 +-
 drivers/s390/cio/device_ops.c                      |   2 +-
 drivers/s390/net/qeth_core_main.c                  |  14 +-
 drivers/s390/net/qeth_core_mpc.h                   |   5 +
 drivers/s390/net/qeth_core_sys.c                   |   2 +-
 drivers/s390/net/qeth_l2_main.c                    |   1 +
 drivers/s390/net/qeth_l2_sys.c                     |   3 +-
 drivers/s390/net/qeth_l3_main.c                    |   1 +
 drivers/spi/spi-cavium-thunderx.c                  |   2 +
 drivers/spi/spi-fsl-spi.c                          |  15 +-
 drivers/spi/spi-nxp-fspi.c                         |   2 +-
 drivers/spi/spi-pxa2xx.c                           |   4 +
 drivers/spi/spi-ti-qspi.c                          |   6 +-
 drivers/staging/axis-fifo/Kconfig                  |   2 +-
 drivers/usb/core/config.c                          |  70 ++++-
 drivers/usb/core/hub.c                             |   2 +-
 drivers/usb/dwc3/gadget.c                          |   7 +
 drivers/usb/gadget/udc/dummy_hcd.c                 |   8 +-
 drivers/usb/serial/option.c                        |   2 +
 drivers/usb/typec/tcpm/Kconfig                     |   1 +
 fs/btrfs/extent-tree.c                             |  20 +-
 fs/btrfs/file.c                                    |   4 +-
 fs/btrfs/ioctl.c                                   |  16 +-
 fs/btrfs/qgroup.c                                  |   4 +-
 fs/drop_caches.c                                   |   2 +-
 fs/inode.c                                         |   7 +
 fs/io_uring.c                                      |   4 +
 fs/notify/fsnotify.c                               |   4 +
 fs/quota/dquot.c                                   |   1 +
 fs/super.c                                         |   4 +-
 include/linux/if_ether.h                           |   8 +
 include/uapi/linux/netfilter/xt_sctp.h             |   6 +-
 kernel/bpf/verifier.c                              |   9 +-
 kernel/locking/spinlock_debug.c                    |  32 +-
 kernel/sched/psi.c                                 |   5 +-
 kernel/trace/ring_buffer.c                         |   6 +
 kernel/trace/trace.c                               |  17 ++
 lib/sbitmap.c                                      |   2 +-
 net/8021q/vlan.h                                   |   1 +
 net/8021q/vlan_dev.c                               |   3 +-
 net/8021q/vlan_netlink.c                           |  19 +-
 net/core/filter.c                                  |   1 +
 net/ipv4/tcp_input.c                               |   5 +-
 net/llc/llc_station.c                              |   4 +-
 net/mac80211/tx.c                                  |   9 +
 net/netfilter/nf_conntrack_netlink.c               |   3 +
 net/netfilter/nf_tables_api.c                      |  18 +-
 net/netfilter/nf_tables_offload.c                  |   6 +
 net/netfilter/nft_bitwise.c                        |   4 +-
 net/netfilter/nft_cmp.c                            |   6 +
 net/netfilter/nft_range.c                          |  10 +
 net/netfilter/nft_set_rbtree.c                     |  21 +-
 net/rfkill/core.c                                  |   7 +-
 net/sched/sch_cake.c                               |   2 +-
 net/sched/sch_fq.c                                 |   6 +-
 net/sched/sch_prio.c                               |  10 +-
 net/sctp/sm_sideeffect.c                           |  28 +-
 net/wireless/core.c                                |   1 +
 net/xdp/xsk.c                                      |  22 +-
 samples/bpf/syscall_tp_kern.c                      |  18 +-
 samples/bpf/trace_event_user.c                     |   4 +-
 scripts/kconfig/expr.c                             |   7 +
 scripts/package/mkdebian                           |   2 +-
 sound/soc/codecs/max98090.c                        |   8 +-
 sound/soc/codecs/max98090.h                        |   1 -
 sound/soc/codecs/rt5682.c                          |   2 +
 sound/soc/codecs/wm8962.c                          |   4 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |   8 +-
 sound/soc/soc-topology.c                           |  27 +-
 sound/soc/sof/intel/byt.c                          |   7 +-
 sound/soc/sof/loader.c                             |   2 +
 tools/bpf/bpftool/prog.c                           |   2 +-
 tools/bpf/bpftool/xlated_dumper.c                  |   2 +-
 tools/lib/traceevent/Makefile                      |   6 +-
 tools/perf/util/header.c                           |  21 +-
 tools/perf/util/metricgroup.c                      |   7 +-
 .../ftrace/test.d/ftrace/func-filter-stacktrace.tc |   2 +
 .../selftests/ftrace/test.d/ftrace/func_cpumask.tc |   5 +
 tools/testing/selftests/ftrace/test.d/functions    |   5 +-
 .../ftrace/test.d/kprobe/multiple_kprobes.tc       |   6 +-
 .../inter-event/trigger-action-hist-xfail.tc       |   4 +-
 .../inter-event/trigger-onchange-action-hist.tc    |   2 +-
 .../inter-event/trigger-snapshot-action-hist.tc    |   4 +-
 tools/testing/selftests/kselftest/prefix.pl        |   1 +
 tools/testing/selftests/kselftest/runner.sh        |   1 +
 tools/testing/selftests/net/pmtu.sh                |   6 +-
 tools/testing/selftests/netfilter/nft_nat.sh       | 332 +++++++++++----------
 tools/testing/selftests/safesetid/Makefile         |   5 +-
 tools/testing/selftests/safesetid/safesetid-test.c |  15 +-
 191 files changed, 1240 insertions(+), 687 deletions(-)


