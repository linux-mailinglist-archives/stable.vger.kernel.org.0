Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49DE9F55E8
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390443AbfKHTFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:05:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:35714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733053AbfKHTFe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:05:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47ED621D7B;
        Fri,  8 Nov 2019 19:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239932;
        bh=pJ2IcMWDRpcwSu/TBkbuGbz2IShJUgRYNKEEe/sbAYs=;
        h=From:To:Cc:Subject:Date:From;
        b=BDaPN9wr5Z0Xjnu1NA6pHuuLbumX6HVvgHujPKdF+UXKt0MMjoZB0R6WNfU07GRlL
         nq8l1vTYRCKOm8mJzsdIKcCXgZsQfwIcu0ZHnDE0EN6omxN5J5rZEiICU/4NoV4wr2
         OKDN6Y0vBWa3umtfkpMlJwUNckRBl0ORBr+X36ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.3 000/140] 5.3.10-stable review
Date:   Fri,  8 Nov 2019 19:48:48 +0100
Message-Id: <20191108174900.189064908@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.3.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.3.10-rc1
X-KernelTest-Deadline: 2019-11-10T17:49+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.3.10 release.
There are 140 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 10 Nov 2019 05:42:11 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.3.10-rc1

Roger Quadros <rogerq@ti.com>
    usb: gadget: udc: core: Fix segfault if udc_bind_to_driver() for pending driver fails

Suman Anna <s-anna@ti.com>
    arm64: dts: ti: k3-am65-main: Fix gic-its node unit-address

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: pcm3168a: The codec does not support S32_LE

Desnes A. Nunes do Rosario <desnesn@linux.ibm.com>
    selftests/powerpc: Fix compile error on tlbie_test due to newer gcc

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    selftests/powerpc: Add test case for tlbie vs mtpidr ordering issue

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Fix retry mid list corruption on reconnects

Jan Kiszka <jan.kiszka@siemens.com>
    platform/x86: pmc_atom: Add Siemens SIMATIC IPC227E to critclk_systems DMI table

Eric Dumazet <edumazet@google.com>
    net/flow_dissector: switch to siphash

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: reset 40nm EPHY on energy detect

Doug Berger <opendmb@gmail.com>
    net: phy: bcm7xxx: define soft_reset for 40nm EPHY

Jakub Kicinski <jakub.kicinski@netronome.com>
    net: netem: correct the parent's backlog when corrupted packet was dropped

Kazutoshi Noguchi <noguchi.kazutosi@gmail.com>
    r8152: add device id for Lenovo ThinkPad USB-C Dock Gen 2

Andrew Lunn <andrew@lunn.ch>
    net: usb: lan78xx: Connect PHY before registering MAC

Eric Dumazet <edumazet@google.com>
    net: reorder 'struct net' fields to avoid false sharing

Jakub Kicinski <jakub.kicinski@netronome.com>
    net: netem: fix error path for corrupted GSO frames

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix mis-counting IRQ vector numbers issue

Eric Dumazet <edumazet@google.com>
    net: ensure correct skb->tstamp in various fragmenters

Vivien Didelot <vivien.didelot@gmail.com>
    net: dsa: fix switch tree list

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Do not clear existing mirrored port mask

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: don't set phydev->link from MAC

Eric Dumazet <edumazet@google.com>
    ipv4: fix IPSKB_FRAG_PMTU handling with fragmentation

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Fix handling of compressed CQEs in case of low NAPI budget

Aya Levin <ayal@mellanox.com>
    net/mlx5e: Fix ethtool self test: link speed

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix wrong PHY ID issue with RTL8168dp

Jiri Pirko <jiri@mellanox.com>
    mlxsw: core: Unpublish devlink parameters during reload

Parav Pandit <parav@mellanox.com>
    net/mlx5: Fix rtable reference leak

Ursula Braun <ubraun@linux.ibm.com>
    net/smc: fix refcounting for non-blocking connect()

Roi Dayan <roid@mellanox.com>
    net/mlx5: Fix flow counter list auto bits struct

Aya Levin <ayal@mellanox.com>
    net/mlx5e: Initialize on stack link modes bitmap

Dmytro Linkin <dmitrolin@mellanox.com>
    net/mlx5e: Remove incorrect match criteria assignment line

Dmytro Linkin <dmitrolin@mellanox.com>
    net/mlx5e: Determine source port properly for vlan push action

David Howells <dhowells@redhat.com>
    rxrpc: Fix handling of last subpacket of jumbo packet

Florian Fainelli <f.fainelli@gmail.com>
    net: phylink: Fix phylink_dbg() macro

Takeshi Misawa <jeliantsurux@gmail.com>
    keys: Fix memory leak in copy_net_ns

Ursula Braun <ubraun@linux.ibm.com>
    net/smc: keep vlan_id for SMC-R in smc_listen_work()

Ursula Braun <ubraun@linux.ibm.com>
    net/smc: fix closing of fallback SMC sockets

Paolo Abeni <pabeni@redhat.com>
    selftests: fib_tests: add more tests for metric update

Paolo Abeni <pabeni@redhat.com>
    ipv4: fix route update on metric change.

Eric Dumazet <edumazet@google.com>
    net: add READ_ONCE() annotation in __skb_wait_for_more_packets()

Eric Dumazet <edumazet@google.com>
    net: use skb_queue_empty_lockless() in busy poll contexts

Eric Dumazet <edumazet@google.com>
    net: use skb_queue_empty_lockless() in poll() handlers

Eric Dumazet <edumazet@google.com>
    udp: use skb_queue_empty_lockless()

Eric Dumazet <edumazet@google.com>
    net: add skb_queue_empty_lockless()

Xin Long <lucien.xin@gmail.com>
    vxlan: check tun_info options_len properly

Eric Dumazet <edumazet@google.com>
    udp: fix data-race in udp_set_dev_scratch()

Wei Wang <weiwan@google.com>
    selftests: net: reuseport_dualstack: fix uninitalized parameter

zhanglin <zhang.lin16@zte.com.cn>
    net: Zeroing the structure ethtool_wolinfo in ethtool_get_wol()

Daniel Wagner <dwagner@suse.de>
    net: usb: lan78xx: Disable interrupts before calling generic_handle_irq()

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: rtnetlink: fix a typo fbd -> fdb

Guillaume Nault <gnault@redhat.com>
    netns: fix GFP flags in rtnl_net_notifyid()

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx4_core: Dynamically set guaranteed amount of counters per VF

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    net: hisilicon: Fix ping latency when deal with high throughput

Tejun Heo <tj@kernel.org>
    net: fix sk_page_frag() recursion from memory reclaim

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    net: ethernet: ftgmac100: Fix DMA coherency issue with SW checksum

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Fix IMP setup for port different than 8

Eric Dumazet <edumazet@google.com>
    net: annotate lockless accesses to sk->sk_napi_id

Eric Dumazet <edumazet@google.com>
    net: annotate accesses to sk->sk_incoming_cpu

Eric Dumazet <edumazet@google.com>
    inet: stop leaking jiffies on the wire

Xin Long <lucien.xin@gmail.com>
    erspan: fix the tun_info options_len check for erspan

Eric Dumazet <edumazet@google.com>
    dccp: do not leak jiffies on the wire

Raju Rangoju <rajur@chelsio.com>
    cxgb4: request the TX CIDX updates to status page

Vishal Kulkarni <vishal@chelsio.com>
    cxgb4: fix panic when attaching to ULD fail

Josef Bacik <josef@toxicpanda.com>
    nbd: handle racing with error'ed out commands

Josef Bacik <josef@toxicpanda.com>
    nbd: protect cmd->status with cmd->lock

Alan Mikhak <alan.mikhak@sifive.com>
    irqchip/sifive-plic: Skip contexts except supervisor in plic_init()

Dave Wysochanski <dwysocha@redhat.com>
    cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs

Alain Volmat <alain.volmat@st.com>
    i2c: stm32f7: remove warning when compiling with W=1

Fabrice Gasnier <fabrice.gasnier@st.com>
    i2c: stm32f7: fix a race in slave mode with arbitration loss irq

Fabrice Gasnier <fabrice.gasnier@st.com>
    i2c: stm32f7: fix first byte to send in slave mode

Fabien Parent <fparent@baylibre.com>
    i2c: mt65xx: fix NULL ptr dereference

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/gic-v3-its: Use the exact ITSList for VMOVP

Jonas Gorski <jonas.gorski@gmail.com>
    MIPS: bmips: mark exception vectors as char arrays

Navid Emamdoost <navid.emamdoost@gmail.com>
    of: unittest: fix memory leak in unittest_data_add

Pan Xiuli <xiuli.pan@linux.intel.com>
    ALSA: hda: Add Tigerlake/Jasperlake PCI ID

Vitaly Kuznetsov <vkuznets@redhat.com>
    selftests: kvm: fix sync_regs_test with newer gccs

Vitaly Kuznetsov <vkuznets@redhat.com>
    selftests: kvm: vmx_set_nested_state_test: don't check for VMX support twice

afzal mohammed <afzal.mohd.ma@gmail.com>
    ARM: 8926/1: v7m: remove register save to stack before svc

Mihail Atanassov <Mihail.Atanassov@arm.com>
    drm/komeda: Don't flush inactive pipes

Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>
    i2c: aspeed: fix master pending state handling

Stefan Wahren <wahrenst@gmx.net>
    ARM: dts: bcm2837-rpi-cm3: Avoid leds-gpio probing issue

Zhengjun Xing <zhengjun.xing@linux.intel.com>
    tracing: Fix "gfp_t" format for synthetic events

Dragos Tarcatu <dragos_tarcatu@mentor.com>
    ASoC: SOF: control: return true when kcontrol values change

Chuhong Yuan <hslester96@gmail.com>
    ASoC: Intel: sof-rt5682: add a check for devm_clk_get

Don Brace <don.brace@microsemi.com>
    scsi: hpsa: add missing hunks in reset-patch

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: core: Do not overwrite CDB byte 1

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix error handling in amdgpu_bo_list_create

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix potential VM faults

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ARM: davinci: dm365: Fix McBSP dma_slave_map entry

Yunfeng Ye <yeyunfeng@huawei.com>
    perf kmem: Fix memory leak in compact_gfp_flags()

Colin Ian King <colin.king@canonical.com>
    8250-men-mcb: fix error checking when get_num_ports returns -ENODEV

Yunfeng Ye <yeyunfeng@huawei.com>
    perf c2c: Fix memory leak in build_cl_output()

Yunfeng Ye <yeyunfeng@huawei.com>
    perf tools: Fix resource leak of closedir() on the error paths

Anson Huang <Anson.Huang@nxp.com>
    arm64: dts: imx8mm: Use correct clock for usdhc's ipg clk

Anson Huang <Anson.Huang@nxp.com>
    arm64: dts: imx8mq: Use correct clock for usdhc's ipg clk

Anson Huang <Anson.Huang@nxp.com>
    ARM: dts: imx7s: Correct GPT's ipg clock source

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: vf610-zii-scu4-aib: Specify 'i2c-mux-idle-disconnect'

Adam Ford <aford173@gmail.com>
    ARM: dts: imx6q-logicpd: Re-Enable SNVS power key

Ran Wang <ran.wang_1@nxp.com>
    arm64: dts: lx2160a: Correct CPU core idle state name

Vivek Unune <npcomplete13@gmail.com>
    arm64: dts: rockchip: Fix usb-c on Hugsun X99 TV Box

Soeren Moch <smoch@web.de>
    arm64: dts: rockchip: fix RockPro64 sdmmc settings

Vladimir Murzin <vladimir.murzin@arm.com>
    ARM: 8914/1: NOMMU: Fix exc_ret for XIP

Masahiro Yamada <yamada.masahiro@socionext.com>
    ARM: 8908/1: add __always_inline to functions called from __get_user_check()

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    scsi: fix kconfig dependency warning related to 53C700_LE_ON_BE

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    scsi: sni_53c710: fix compilation error

Hannes Reinecke <hare@suse.com>
    scsi: scsi_dh_alua: handle RTPG sense code correctly during state transitions

Allen Pais <allen.pais@oracle.com>
    scsi: qla2xxx: fix a potential NULL pointer dereference

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: mm: fix alignment handler faults under memory pressure

Tony Lindgren <tony@atomide.com>
    ARM: dts: Use level interrupt for omap4 & 5 wlcore

Daniel Baluta <daniel.baluta@nxp.com>
    ASoC: simple_card_utils.h: Fix potential multiple redefinition error

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: msm8916-wcd-digital: add missing MIX2 path for RX1/2

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: am3874-iceboard: Fix 'i2c-mux-idle-disconnect' usage

Lucas Stach <l.stach@pengutronix.de>
    arm64: dts: zii-ultra: fix ARM regulator states

Amelie Delaunay <amelie.delaunay@st.com>
    pinctrl: stmfx: fix null pointer on remove

Dan Carpenter <dan.carpenter@oracle.com>
    pinctrl: ns2: Fix off by one bugs in ns2_pinmux_enable()

Soeren Moch <smoch@web.de>
    arm64: dts: rockchip: fix RockPro64 sdhci settings

Soeren Moch <smoch@web.de>
    arm64: dts: rockchip: fix RockPro64 vdd-log regulator settings

Adam Ford <aford173@gmail.com>
    ARM: dts: logicpd-torpedo-som: Remove twl_keypad

Hugh Cole-Baker <sigmaris@gmail.com>
    arm64: dts: rockchip: fix Rockpro64 RK808 interrupt line

Robin Murphy <robin.murphy@arm.com>
    ASoc: rockchip: i2s: Fix RPM imbalance

Stuart Henderson <stuarth@opensource.cirrus.com>
    ASoC: wm_adsp: Don't generate kcontrols without READ flags

Yizhuo <yzhai003@ucr.edu>
    regulator: pfuze100-regulator: Variable "val" in pfuze100_regulator_probe() could be uninitialized

Jaska Uimonen <jaska.uimonen@intel.com>
    ASoC: intel: bytcr_rt5651: add null check to support_button_press

Jaska Uimonen <jaska.uimonen@intel.com>
    ASoC: intel: sof_rt5682: add remove function to disable jack

Jaska Uimonen <jaska.uimonen@intel.com>
    ASoC: rt5682: add NULL handler to set_jack function

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: Intel: hda: Disable DMI L1 entry during capture

Liam Girdwood <liam.r.girdwood@linux.intel.com>
    ASoC: SOF: Intel: initialise and verify FW crash dump data.

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: Intel: hda: fix warnings during FW load

Keyon Jie <yang.jie@linux.intel.com>
    ASoC: SOF: topology: fix parse fail issue for byte/bool tuple types

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: loader: fix kernel oops on firmware boot failure

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Allocate IRQ chip dynamic

Axel Lin <axel.lin@ingics.com>
    regulator: ti-abb: Fix timeout in ti_abb_wait_txdone/ti_abb_clear_all_txdone

Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
    arm64: dts: Fix gpio to pinmux mapping

Jernej Skrabec <jernej.skrabec@siol.net>
    arm64: dts: allwinner: a64: sopine-baseboard: Add PHY regulator delay

Vasily Khoruzhick <anarsoul@gmail.com>
    arm64: dts: allwinner: a64: Drop PMU node

Jernej Skrabec <jernej.skrabec@siol.net>
    arm64: dts: allwinner: a64: pine64-plus: Add PHY regulator delay

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: topology: Fix a signedness bug in soc_tplg_dapm_widget_create()

Marco Felsch <m.felsch@pengutronix.de>
    regulator: da9062: fix suspend_enable/disable preparation

Sylwester Nawrocki <s.nawrocki@samsung.com>
    ASoC: wm8994: Do not register inapplicable controls for WM1811

Sylwester Nawrocki <s.nawrocki@samsung.com>
    ASoC: samsung: arndale: Add missing OF node dereferencing

Marco Felsch <m.felsch@pengutronix.de>
    regulator: of: fix suspend-min/max-voltage parsing


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/am3874-iceboard.dts              |   9 +-
 arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi             |   8 +
 arch/arm/boot/dts/imx6-logicpd-som.dtsi            |   4 +
 arch/arm/boot/dts/imx7s.dtsi                       |   8 +-
 arch/arm/boot/dts/logicpd-torpedo-som.dtsi         |   4 +
 arch/arm/boot/dts/omap4-droid4-xt894.dts           |   2 +-
 arch/arm/boot/dts/omap4-panda-common.dtsi          |   2 +-
 arch/arm/boot/dts/omap4-sdp.dts                    |   2 +-
 arch/arm/boot/dts/omap4-var-som-om44-wlan.dtsi     |   2 +-
 arch/arm/boot/dts/omap5-board-common.dtsi          |   2 +-
 arch/arm/boot/dts/vf610-zii-scu4-aib.dts           |   2 +
 arch/arm/include/asm/domain.h                      |   8 +-
 arch/arm/include/asm/uaccess.h                     |   4 +-
 arch/arm/kernel/head-common.S                      |   5 +-
 arch/arm/kernel/head-nommu.S                       |   2 +
 arch/arm/mach-davinci/dm365.c                      |   4 +-
 arch/arm/mm/alignment.c                            |  44 +-
 arch/arm/mm/proc-v7m.S                             |   6 +-
 .../boot/dts/allwinner/sun50i-a64-pine64-plus.dts  |   9 +
 .../dts/allwinner/sun50i-a64-sopine-baseboard.dts  |   6 +
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi      |   9 -
 .../dts/broadcom/stingray/stingray-pinctrl.dtsi    |   5 +-
 .../arm64/boot/dts/broadcom/stingray/stingray.dtsi |   3 +-
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi     |  36 +-
 arch/arm64/boot/dts/freescale/imx8mm.dtsi          |   6 +-
 .../arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi |   4 +-
 arch/arm64/boot/dts/freescale/imx8mq.dtsi          |   4 +-
 arch/arm64/boot/dts/rockchip/rk3399-hugsun-x99.dts |   4 +-
 arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts  |  12 +-
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi           |   2 +-
 arch/mips/bcm63xx/prom.c                           |   2 +-
 arch/mips/include/asm/bmips.h                      |  10 +-
 arch/mips/kernel/smp-bmips.c                       |   8 +-
 drivers/block/nbd.c                                |  18 +-
 drivers/crypto/chelsio/chtls/chtls_cm.c            |   2 +-
 drivers/crypto/chelsio/chtls/chtls_io.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c        |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   3 +-
 drivers/gpu/drm/arm/display/komeda/komeda_kms.c    |   3 +-
 drivers/i2c/busses/i2c-aspeed.c                    |  54 +-
 drivers/i2c/busses/i2c-mt65xx.c                    |   2 +-
 drivers/i2c/busses/i2c-stm32f7.c                   |  21 +-
 drivers/irqchip/irq-gic-v3-its.c                   |  21 +-
 drivers/irqchip/irq-sifive-plic.c                  |   4 +-
 drivers/isdn/capi/capi.c                           |   2 +-
 drivers/net/dsa/b53/b53_common.c                   |   1 -
 drivers/net/dsa/bcm_sf2.c                          |  36 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  13 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c     |  28 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |   8 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |  25 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c         |  15 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  21 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  11 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  28 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   1 +
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  42 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  12 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  |  15 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   1 -
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |  22 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |   4 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   4 +
 drivers/net/phy/bcm7xxx.c                          |   1 +
 drivers/net/phy/phylink.c                          |  16 +
 drivers/net/usb/cdc_ether.c                        |   7 +
 drivers/net/usb/lan78xx.c                          |  17 +-
 drivers/net/usb/r8152.c                            |   1 +
 drivers/net/vxlan.c                                |   6 +-
 drivers/of/unittest.c                              |   1 +
 drivers/pinctrl/bcm/pinctrl-ns2-mux.c              |   4 +-
 drivers/pinctrl/intel/pinctrl-intel.c              |  27 +-
 drivers/pinctrl/pinctrl-stmfx.c                    |   2 +-
 drivers/platform/x86/pmc_atom.c                    |   7 +
 drivers/regulator/da9062-regulator.c               | 118 ++--
 drivers/regulator/of_regulator.c                   |   8 +-
 drivers/regulator/pfuze100-regulator.c             |   8 +-
 drivers/regulator/ti-abb-regulator.c               |  26 +-
 drivers/scsi/Kconfig                               |   2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |  21 +-
 drivers/scsi/hpsa.c                                |   4 +
 drivers/scsi/qla2xxx/qla_os.c                      |   4 +
 drivers/scsi/sni_53c710.c                          |   4 +-
 drivers/target/target_core_device.c                |  21 -
 drivers/tty/serial/8250/8250_men_mcb.c             |   8 +-
 drivers/usb/gadget/udc/core.c                      |   2 +-
 fs/cifs/cifsglob.h                                 |   5 +
 fs/cifs/cifsproto.h                                |   1 +
 fs/cifs/connect.c                                  |  10 +-
 fs/cifs/file.c                                     |  23 +-
 fs/cifs/smb2file.c                                 |   2 +-
 fs/cifs/transport.c                                |  42 +-
 include/linux/gfp.h                                |  23 +
 include/linux/mlx5/mlx5_ifc.h                      |   3 +-
 include/linux/skbuff.h                             |  36 +-
 include/net/busy_poll.h                            |   6 +-
 include/net/flow_dissector.h                       |   3 +-
 include/net/fq.h                                   |   2 +-
 include/net/fq_impl.h                              |   4 +-
 include/net/ip.h                                   |   4 +-
 include/net/net_namespace.h                        |  27 +-
 include/net/sock.h                                 |  15 +-
 include/sound/simple_card_utils.h                  |   8 +-
 kernel/trace/trace_events_hist.c                   |   2 +
 net/atm/common.c                                   |   2 +-
 net/bluetooth/af_bluetooth.c                       |   4 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |   5 +-
 net/caif/caif_socket.c                             |   2 +-
 net/core/datagram.c                                |   8 +-
 net/core/dev.c                                     |   2 +-
 net/core/ethtool.c                                 |   4 +-
 net/core/flow_dissector.c                          |  38 +-
 net/core/net_namespace.c                           |  18 +-
 net/core/rtnetlink.c                               |  16 +-
 net/core/sock.c                                    |   6 +-
 net/dccp/ipv4.c                                    |   4 +-
 net/decnet/af_decnet.c                             |   2 +-
 net/dsa/dsa2.c                                     |   2 +-
 net/ipv4/datagram.c                                |   2 +-
 net/ipv4/fib_frontend.c                            |   2 +-
 net/ipv4/inet_hashtables.c                         |   2 +-
 net/ipv4/ip_gre.c                                  |   4 +-
 net/ipv4/ip_output.c                               |  14 +-
 net/ipv4/tcp.c                                     |   4 +-
 net/ipv4/tcp_ipv4.c                                |   4 +-
 net/ipv4/udp.c                                     |  29 +-
 net/ipv6/inet6_hashtables.c                        |   2 +-
 net/ipv6/ip6_gre.c                                 |   4 +-
 net/ipv6/ip6_output.c                              |   3 +
 net/ipv6/netfilter.c                               |   3 +
 net/ipv6/udp.c                                     |   2 +-
 net/nfc/llcp_sock.c                                |   4 +-
 net/openvswitch/datapath.c                         |  20 +-
 net/phonet/socket.c                                |   4 +-
 net/rxrpc/ar-internal.h                            |   1 +
 net/rxrpc/recvmsg.c                                |  18 +-
 net/sched/sch_hhf.c                                |   8 +-
 net/sched/sch_netem.c                              |  11 +-
 net/sched/sch_sfb.c                                |  13 +-
 net/sched/sch_sfq.c                                |  14 +-
 net/sctp/socket.c                                  |   8 +-
 net/smc/af_smc.c                                   |  13 +-
 net/tipc/socket.c                                  |   4 +-
 net/unix/af_unix.c                                 |   6 +-
 net/vmw_vsock/af_vsock.c                           |   2 +-
 sound/pci/hda/hda_intel.c                          |   6 +
 sound/soc/codecs/msm8916-wcd-digital.c             |  22 +
 sound/soc/codecs/pcm3168a.c                        |   3 +-
 sound/soc/codecs/rt5651.c                          |   3 +
 sound/soc/codecs/rt5682.c                          |  12 +-
 sound/soc/codecs/wm8994.c                          |  43 +-
 sound/soc/codecs/wm_adsp.c                         |   3 +-
 sound/soc/intel/boards/sof_rt5682.c                |  25 +
 sound/soc/rockchip/rockchip_i2s.c                  |   2 +-
 sound/soc/samsung/arndale_rt5631.c                 |  34 +-
 sound/soc/soc-topology.c                           |   2 +-
 sound/soc/sof/control.c                            |  26 +-
 sound/soc/sof/intel/Kconfig                        |  10 +
 sound/soc/sof/intel/bdw.c                          |   7 +
 sound/soc/sof/intel/byt.c                          |   6 +
 sound/soc/sof/intel/hda-ctrl.c                     |  12 +-
 sound/soc/sof/intel/hda-loader.c                   |   1 +
 sound/soc/sof/intel/hda-stream.c                   |  45 +-
 sound/soc/sof/intel/hda.c                          |   7 +
 sound/soc/sof/intel/hda.h                          |   5 +-
 sound/soc/sof/loader.c                             |   4 +-
 sound/soc/sof/topology.c                           |   4 +-
 tools/perf/builtin-c2c.c                           |  14 +-
 tools/perf/builtin-kmem.c                          |   1 +
 tools/perf/util/header.c                           |   4 +-
 tools/perf/util/util.c                             |   6 +-
 .../testing/selftests/kvm/x86_64/sync_regs_test.c  |  21 +-
 .../kvm/x86_64/vmx_set_nested_state_test.c         |   7 +-
 tools/testing/selftests/net/fib_tests.sh           |  21 +
 tools/testing/selftests/net/reuseport_dualstack.c  |   3 +-
 tools/testing/selftests/powerpc/mm/Makefile        |   2 +
 tools/testing/selftests/powerpc/mm/tlbie_test.c    | 734 +++++++++++++++++++++
 182 files changed, 1933 insertions(+), 685 deletions(-)


