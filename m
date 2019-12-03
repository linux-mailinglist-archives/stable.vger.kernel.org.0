Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD77111FFB
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfLCWlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:41:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727772AbfLCWlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:41:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72E5820803;
        Tue,  3 Dec 2019 22:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412865;
        bh=LP+3QDvzHLRA7d8ilPKchxBl+0hqzm0vN6Go3wi6rOM=;
        h=From:To:Cc:Subject:Date:From;
        b=Ml0yyetGNW+C4f5YlyNdHcCeER8Gpnx5D4U0xXDRpHVwr6pJZO4Qo9hE+SRECgEBk
         22PsR7hDgtYgiPGVB/mQ/dX4wWxTGCqVJo73pJwMIscnnLdOIBX072ihxou9ujfLEs
         bOAXylAghLyhand4wLSvzcMrqu3/XUEyHpzPt4Qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.3 000/135] 5.3.15-stable review
Date:   Tue,  3 Dec 2019 23:34:00 +0100
Message-Id: <20191203213005.828543156@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.3.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.3.15-rc1
X-KernelTest-Deadline: 2019-12-05T21:30+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.3.15 release.
There are 135 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 05 Dec 2019 21:20:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.15-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.3.15-rc1

Hans de Goede <hdegoede@redhat.com>
    platform/x86: hp-wmi: Fix ACPI errors caused by passing 0 as input size

Hans de Goede <hdegoede@redhat.com>
    platform/x86: hp-wmi: Fix ACPI errors caused by too small buffer

Candle Sun <candle.sun@unisoc.com>
    HID: core: check whether Usage Page item is after Usage ID items

Theodore Ts'o <tytso@mit.edu>
    ext4: add more paranoia checking in ext4_expand_extra_isize handling

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    selftests: pmtu: use -oneline for ip route list cache

John Rutherford <john.rutherford@dektech.com.au>
    tipc: fix link name length check

Jakub Kicinski <jakub.kicinski@netronome.com>
    selftests: bpf: correct perror strings

Jakub Kicinski <jakub.kicinski@netronome.com>
    selftests: bpf: test_sockmap: handle file creation failures gracefully

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: use sg_next() to walk sg entries

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: remove the dead inplace_crypto code

Jakub Kicinski <jakub.kicinski@netronome.com>
    selftests/tls: add a test for fragmented messages

Jakub Kicinski <jakub.kicinski@netronome.com>
    net: skmsg: fix TLS 1.3 crash with full sk_msg

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: free the record on encryption error

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: take into account that bpf_exec_tx_verdict() may free the record

Paolo Abeni <pabeni@redhat.com>
    openvswitch: remove another BUG_ON()

Paolo Abeni <pabeni@redhat.com>
    openvswitch: drop unneeded BUG_ON() in ovs_flow_cmd_build_info()

Xin Long <lucien.xin@gmail.com>
    sctp: cache netns in sctp_ep_common

Jouni Hogander <jouni.hogander@unikie.com>
    slip: Fix use-after-free Read in slip_open

Navid Emamdoost <navid.emamdoost@gmail.com>
    sctp: Fix memory leak in sctp_sf_do_5_2_4_dupcook

Paolo Abeni <pabeni@redhat.com>
    openvswitch: fix flow command message size

Dust Li <dust.li@linux.alibaba.com>
    net: sched: fix `tc -s class show` no bstats on class with nolock subqueues

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: psample: fix skb_over_panic

Chuhong Yuan <hslester96@gmail.com>
    net: macb: add missed tasklet_kill

Oleksij Rempel <linux@rempel-privat.de>
    net: dsa: sja1105: fix sja1105_parse_rgmii_delays()

David Bauer <mail@david-bauer.net>
    mdio_bus: don't use managed reset-controller

Menglong Dong <dong.menglong@zte.com.cn>
    macvlan: schedule bc_work even if error

Jeroen de Borst <jeroendb@google.com>
    gve: Fix the queue page list allocated pages count

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    x86/fpu: Don't cache access to fpu_fpregs_owner_ctx

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Fix memleak on xfrm state destroy

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Power cycle the router if NVM authentication fails

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add comet point V device id

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: bus: prefix device names on bus with the bus name

Fabio D'Urso <fabiodurso@hotmail.it>
    USB: serial: ftdi_sio: add device IDs for U-Blox C099-F9P

Hans de Goede <hdegoede@redhat.com>
    staging: rtl8723bs: Add 024c:0525 to the list of SDIO device-ids

Hans de Goede <hdegoede@redhat.com>
    staging: rtl8723bs: Drop ACPI device ids

Pan Bian <bianpan2016@163.com>
    staging: rtl8192e: fix potential use after free

Ajay Singh <ajay.kathat@microchip.com>
    staging: wilc1000: fix illegal memory access in wilc_parse_join_bss_param()

Mathias Kresin <dev@kresin.me>
    usb: dwc2: use a longer core rest timeout in dwc2_core_reset()

Eugen Hristev <eugen.hristev@microchip.com>
    clk: at91: fix update bit maps on CFG_MOR write

Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
    i40e: Fix for ethtool -m issue on X722 NIC

Nicholas Nunley <nicholas.d.nunley@intel.com>
    iavf: initialize ITRN registers with correct values

Colin Ian King <colin.king@canonical.com>
    ice: fix potential infinite loop because loop counter being too small

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: bcm-iproc: Prevent unloading the driver module while in use

Dan Carpenter <dan.carpenter@oracle.com>
    block: drbd: remove a stray unlock in __drbd_send_protocol()

Ahmed Zaki <anzaki@gmail.com>
    mac80211: fix station inactive_time shortly after boot

Toke Høiland-Jørgensen <toke@redhat.com>
    net/fq_impl: Switch to kvmalloc() for memory allocation

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix ieee80211_txq_setup_flows() failure path

Jeff Layton <jlayton@kernel.org>
    ceph: return -EINVAL if given fsc mount option on kernel w/o support

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: xgmac: Disable Flow Control when 1 or more queues are in AV

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: xgmac: Fix TSA selection

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: xgmac: bitrev32 returns u32

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: gmac4: bitrev32 returns u32

changzhu <Changfeng.Zhu@amd.com>
    drm/amdgpu: add warning for GRBM 1-cycle delay issue in gfx9

Evan Quan <evan.quan@amd.com>
    drm/amdgpu: register gpu instance before fan boost feature enablment

Kevin Wang <kevin1.wang@amd.com>
    drm/amd/swSMU: fix smu workload bit map error

Vladimir Oltean <olteanv@gmail.com>
    net: mscc: ocelot: fix __ocelot_rmw_ix prototype

Dmytro Linkin <dmitrolin@mellanox.com>
    net/mlx5e: Use correct enum to determine uplink port

Roi Dayan <roid@mellanox.com>
    net/mlx5e: Fix eswitch debug print of max fdb flow

Shirish S <shirish.s@amd.com>
    drm/amdgpu: dont schedule jobs while in reset

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: reapply manual settings to the PHY

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: use RGMII loopback for MAC reset

Ilya Leoshkevich <iii@linux.ibm.com>
    scripts/gdb: fix debugging modules compiled with hot/cold partitioning

John Hubbard <jhubbard@nvidia.com>
    mm/gup_benchmark: fix MAP_HUGETLB case

Dragos Tarcatu <dragos_tarcatu@mentor.com>
    ASoC: SOF: topology: Fix bytes control size checks

Christophe Roullier <christophe.roullier@st.com>
    ARM: dts: stm32: Fix CAN RAM mapping on stm32mp157c

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: hdmi - add Tigerlake support

Olivier Moysan <olivier.moysan@st.com>
    ASoC: stm32: sai: add restriction on mmap support

Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
    watchdog: bd70528: Add MODULE_ALIAS to allow module auto loading

Anson Huang <Anson.Huang@nxp.com>
    watchdog: imx_sc_wdt: Pretimeout should follow SCU firmware format

Xingyu Chen <xingyu.chen@amlogic.com>
    watchdog: meson: Fix the wrong value of left time

Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
    watchdog: pm8916_wdt: fix pretimeout registration flow

Anton Eidelman <anton@lightbitslabs.com>
    nvme-multipath: fix crash in nvme_mpath_clear_ctrl_paths

Max Gurtovoy <maxg@mellanox.com>
    nvme-rdma: fix a segmentation fault during module unload

Timo Schlüßler <schluessler@krause.de>
    can: mcp251x: mcp251x_restart_work_handler(): Fix potential force_quit race condition

Steven Rostedt (VMware) <rostedt@goodmis.org>
    perf scripting engines: Iterate on tep event arrays directly

Michael Zhivich <mzhivich@akamai.com>
    x86/tsc: Respect tsc command line paraemeter for clocksource_tsc_early

Marc Kleine-Budde <mkl@pengutronix.de>
    can: flexcan: increase error counters if skb enqueueing via can_rx_offload_queue_sorted() fails

Marc Kleine-Budde <mkl@pengutronix.de>
    can: rx-offload: can_rx_offload_irq_offload_fifo(): continue on error

Jeroen Hofstee <jhofstee@victronenergy.com>
    can: rx-offload: can_rx_offload_irq_offload_timestamp(): continue on error

Marc Kleine-Budde <mkl@pengutronix.de>
    can: rx-offload: can_rx_offload_offload_one(): use ERR_PTR() to propagate error value in case of errors

Marc Kleine-Budde <mkl@pengutronix.de>
    can: rx-offload: can_rx_offload_offload_one(): increment rx_fifo_errors on queue overflow or OOM

Marc Kleine-Budde <mkl@pengutronix.de>
    can: rx-offload: can_rx_offload_offload_one(): do not increase the skb_queue beyond skb_queue_len_max

Marc Kleine-Budde <mkl@pengutronix.de>
    can: rx-offload: can_rx_offload_queue_tail(): fix error handling, avoid skb mem leak

Jeroen Hofstee <jhofstee@victronenergy.com>
    can: c_can: D_CAN: c_can_chip_config(): perform a sofware reset on open

Jeroen Hofstee <jhofstee@victronenergy.com>
    can: peak_usb: report bus recovery as well

Jiri Slaby <jslaby@suse.cz>
    stacktrace: Don't skip first entry on noncurrent tasks

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables_offload: skip EBUSY on chain update

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: bogus EOPNOTSUPP on basechain update

Florian Westphal <fw@strlen.de>
    bridge: ebtables: don't crash when using dnat target in output chains

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
    netfilter: ipset: Fix nla_policies to fully support NL_VALIDATE_STRICT

Chuhong Yuan <hslester96@gmail.com>
    net: fec: add missed clk_disable_unprepare in remove

Tony Lindgren <tony@atomide.com>
    clk: ti: clkctrl: Fix failed to enable error with double udelay timeout

Peter Ujfalusi <peter.ujfalusi@ti.com>
    clk: ti: dra7-atl-clock: Remove ti_clk_add_alias call

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: hdac_hda: fix race in device removal

Geert Uytterhoeven <geert@linux-m68k.org>
    fbdev: c2p: Fix link failure on non-inlining

Lucas Stach <l.stach@pengutronix.de>
    arm64: dts: zii-ultra: fix ARM regulator GPIO handle

Xiaochen Shen <xiaochen.shen@intel.com>
    x86/resctrl: Prevent NULL pointer dereference when reading mondata

Matthew Wilcox (Oracle) <willy@infradead.org>
    idr: Fix idr_alloc_u32 on 32-bit systems

Matthew Wilcox (Oracle) <willy@infradead.org>
    idr: Fix integer overflow in idr_for_each_entry

Matthew Wilcox (Oracle) <willy@infradead.org>
    idr: Fix idr_get_next_ul race with idr_remove

Eric Dumazet <edumazet@google.com>
    powerpc/bpf: Fix tail call implementation

Björn Töpel <bjorn.topel@intel.com>
    bpf: Change size to u64 for bpf_map_{area_alloc, charge_init}()

Björn Töpel <bjorn.topel@intel.com>
    samples/bpf: fix build by setting HAVE_ATTR_TEST to zero

Ilya Leoshkevich <iii@linux.ibm.com>
    bpf: Allow narrow loads of bpf_sysctl fields with offset > 0

Ondrej Jirman <megous@megous.com>
    ARM: dts: sun8i-a83t-tbs-a711: Fix WiFi resume from suspend

Colin Ian King <colin.king@canonical.com>
    clk: sunxi-ng: a80: fix the zero'ing of bits 16 and 18

Nathan Chancellor <natechancellor@gmail.com>
    clk: sunxi: Fix operator precedence in sunxi_divs_clk_setup

Alexandre Belloni <alexandre.belloni@bootlin.com>
    clk: at91: avoid sleeping early

Cheng-Yi Chiang <cychiang@chromium.org>
    ASoC: rockchip: rockchip_max98090: Enable SHDN to fix headset detection

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: ti: sdma-pcm: Add back the flags parameter for non standard dma names

Navid Emamdoost <navid.emamdoost@gmail.com>
    ASoC: SOF: ipc: Fix memory leak in sof_set_get_large_ctrl_data

Shengjiu Wang <shengjiu.wang@nxp.com>
    arm64: dts: imx8mm: fix compatible string for sdma

Randy Dunlap <rdunlap@infradead.org>
    reset: fix reset_control_ops kerneldoc comment

Ben Dooks <ben.dooks@codethink.co.uk>
    soc: imx: gpc: fix initialiser format

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx6qdl-sabreauto: Fix storm of accelerometer interrupts

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: cherryview: Allocate IRQ chip dynamic

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: exynos5420: Preserve PLL configuration during suspend/resume

Yuantian Tang <andy.tang@nxp.com>
    arm64: dts: ls1028a: fix a compatible issue

Russell King <rmk+kernel@armlinux.org.uk>
    ASoC: kirkwood: fix device remove ordering

Russell King <rmk+kernel@armlinux.org.uk>
    ASoC: kirkwood: fix external clock probe defer

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: exynos542x: Move G3D subsystem clocks to its sub-CMU

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: exynos5433: Fix error paths

Kishon Vijay Abraham I <kishon@ti.com>
    reset: Fix memory leak in reset_control_array_put()

Xiaojun Sang <xsang@codeaurora.org>
    ASoC: compress: fix unsigned integer overflow check

Stephan Gerhold <stephan@gerhold.net>
    ASoC: msm8916-wcd-analog: Fix RX1 selection in RDAC2 MUX

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: intel: fix intel_register_dai PDI offsets and numbers

Fabien Parent <fparent@baylibre.com>
    clocksource/drivers/mediatek: Fix error handling

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Fix lockdep circular locking depedency warning

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Read DP IN adapter first two dwords in one go

Eugen Hristev <eugen.hristev@microchip.com>
    clk: at91: sam9x60: fix programmable clock

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: gxbb: let sar_adc_clk_div set the parent clock rate

Matthew Wilcox (Oracle) <willy@infradead.org>
    XArray: Fix xas_next() with a single entry at 0

Jens Axboe <axboe@kernel.dk>
    net: disallow ancillary data for __sys_{send,recv}msg_file()

Jens Axboe <axboe@kernel.dk>
    net: separate out the msghdr copy from ___sys_{send,recv}msg()

Jens Axboe <axboe@kernel.dk>
    io_uring: async workers should inherit the user creds


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi           |   8 +
 arch/arm/boot/dts/stm32mp157c.dtsi                 |   4 +-
 arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts          |   1 +
 arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts  |   2 +-
 arch/arm64/boot/dts/freescale/imx8mm.dtsi          |   6 +-
 .../arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi |   2 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |  13 ++
 arch/x86/include/asm/fpu/internal.h                |   2 +-
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c          |   4 +
 arch/x86/kernel/tsc.c                              |   3 +
 drivers/block/drbd/drbd_main.c                     |   1 -
 drivers/clk/at91/clk-main.c                        |   7 +-
 drivers/clk/at91/sam9x60.c                         |   1 +
 drivers/clk/at91/sckc.c                            |  20 ++-
 drivers/clk/meson/gxbb.c                           |   1 +
 drivers/clk/samsung/clk-exynos5420.c               |  27 ++-
 drivers/clk/samsung/clk-exynos5433.c               |  14 +-
 drivers/clk/sunxi-ng/ccu-sun9i-a80.c               |   2 +-
 drivers/clk/sunxi/clk-sunxi.c                      |   4 +-
 drivers/clk/ti/clk-dra7-atl.c                      |   6 -
 drivers/clk/ti/clkctrl.c                           |   5 +-
 drivers/clocksource/timer-mediatek.c               |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c            |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   7 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   1 -
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   7 +
 drivers/gpu/drm/amd/powerplay/navi10_ppt.c         |   2 +-
 drivers/gpu/drm/amd/powerplay/vega20_ppt.c         |   2 +-
 drivers/hid/hid-core.c                             |  51 +++++-
 drivers/misc/mei/bus.c                             |   9 +-
 drivers/misc/mei/hw-me-regs.h                      |   1 +
 drivers/misc/mei/pci-me.c                          |   1 +
 drivers/net/can/c_can/c_can.c                      |  26 +++
 drivers/net/can/flexcan.c                          |  10 +-
 drivers/net/can/rx-offload.c                       |  96 +++++++++--
 drivers/net/can/spi/mcp251x.c                      |   2 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  15 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |  10 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   7 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |  33 ++++
 drivers/net/ethernet/cadence/macb_main.c           |   1 +
 drivers/net/ethernet/freescale/fec_main.c          |   2 +
 drivers/net/ethernet/google/gve/gve_main.c         |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c      |   3 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   4 +-
 drivers/net/ethernet/intel/ice/ice_sched.c         |   2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   2 +-
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |   3 +-
 drivers/net/ethernet/mscc/ocelot.h                 |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   2 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |   3 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   2 +
 drivers/net/macvlan.c                              |   3 +-
 drivers/net/phy/mdio_bus.c                         |   6 +-
 drivers/net/slip/slip.c                            |   1 +
 drivers/nvme/host/multipath.c                      |   2 +
 drivers/nvme/host/rdma.c                           |   8 +
 drivers/pinctrl/intel/pinctrl-cherryview.c         |  24 +--
 drivers/platform/x86/hp-wmi.c                      |  10 +-
 drivers/pwm/pwm-bcm-iproc.c                        |   1 +
 drivers/reset/core.c                               |   1 +
 drivers/soc/imx/gpc.c                              |   8 +-
 drivers/soundwire/intel.c                          |   4 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |   5 +-
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c       |   7 +-
 drivers/staging/wilc1000/wilc_hif.c                |  25 +--
 drivers/thunderbolt/switch.c                       |  82 +++++----
 drivers/usb/dwc2/core.c                            |   2 +-
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   7 +
 drivers/video/fbdev/c2p_core.h                     |   8 +-
 drivers/watchdog/bd70528_wdt.c                     |   1 +
 drivers/watchdog/imx_sc_wdt.c                      |   8 +-
 drivers/watchdog/meson_gxbb_wdt.c                  |   4 +-
 drivers/watchdog/pm8916_wdt.c                      |  15 +-
 fs/ceph/super.c                                    |  11 +-
 fs/ext4/inode.c                                    |  15 ++
 fs/ext4/super.c                                    |  21 ++-
 fs/io_uring.c                                      |  23 ++-
 include/linux/bpf.h                                |   4 +-
 include/linux/idr.h                                |   2 +-
 include/linux/reset-controller.h                   |   2 +-
 include/linux/skmsg.h                              |  26 +--
 include/net/fq_impl.h                              |   4 +-
 include/net/sctp/structs.h                         |   3 +
 include/net/tls.h                                  |   3 +-
 kernel/bpf/cgroup.c                                |   4 +-
 kernel/bpf/syscall.c                               |   7 +-
 kernel/stacktrace.c                                |   6 +-
 lib/idr.c                                          |  31 ++--
 lib/radix-tree.c                                   |   2 +-
 lib/test_xarray.c                                  |  24 +++
 lib/xarray.c                                       |   4 +
 net/bridge/netfilter/ebt_dnat.c                    |  19 ++-
 net/core/filter.c                                  |   8 +-
 net/core/skmsg.c                                   |   2 +-
 net/ipv4/tcp_bpf.c                                 |   2 +-
 net/mac80211/main.c                                |   2 +-
 net/mac80211/sta_info.c                            |   3 +-
 net/netfilter/ipset/ip_set_core.c                  |  41 +++--
 net/netfilter/ipset/ip_set_hash_net.c              |   1 +
 net/netfilter/ipset/ip_set_hash_netnet.c           |   1 +
 net/netfilter/nf_tables_api.c                      |   1 +
 net/netfilter/nf_tables_offload.c                  |   3 +-
 net/openvswitch/datapath.c                         |  17 +-
 net/psample/psample.c                              |   2 +-
 net/sched/sch_mq.c                                 |   3 +-
 net/sched/sch_mqprio.c                             |   4 +-
 net/sched/sch_multiq.c                             |   2 +-
 net/sched/sch_prio.c                               |   2 +-
 net/sctp/associola.c                               |   1 +
 net/sctp/endpointola.c                             |   1 +
 net/sctp/input.c                                   |   4 +-
 net/sctp/sm_statefuns.c                            |   4 +-
 net/socket.c                                       | 184 +++++++++++++++------
 net/tipc/netlink_compat.c                          |   4 +-
 net/tls/tls_main.c                                 |  13 +-
 net/tls/tls_sw.c                                   |  32 ++--
 net/xfrm/xfrm_state.c                              |   2 +
 samples/bpf/Makefile                               |   1 +
 scripts/gdb/linux/symbols.py                       |   3 +-
 sound/core/compress_offload.c                      |   2 +-
 sound/pci/hda/patch_hdmi.c                         |  13 ++
 sound/soc/codecs/hdac_hda.c                        |   2 +-
 sound/soc/codecs/msm8916-wcd-analog.c              |   4 +-
 sound/soc/kirkwood/kirkwood-i2s.c                  |  11 +-
 sound/soc/rockchip/rockchip_max98090.c             |   7 +-
 sound/soc/sof/ipc.c                                |   4 +-
 sound/soc/sof/topology.c                           |  11 +-
 sound/soc/stm/stm32_sai_sub.c                      |  12 +-
 sound/soc/ti/sdma-pcm.c                            |   2 +-
 .../perf/util/scripting-engines/trace-event-perl.c |   8 +-
 .../util/scripting-engines/trace-event-python.c    |   9 +-
 tools/testing/selftests/bpf/test_sockmap.c         |  47 +++---
 tools/testing/selftests/bpf/test_sysctl.c          |   8 +-
 tools/testing/selftests/bpf/xdping.c               |   2 +-
 tools/testing/selftests/net/pmtu.sh                |   5 +-
 tools/testing/selftests/net/tls.c                  |  60 +++++++
 tools/testing/selftests/vm/gup_benchmark.c         |   2 +-
 140 files changed, 1055 insertions(+), 404 deletions(-)


