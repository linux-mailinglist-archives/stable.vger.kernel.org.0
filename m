Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7718F51A68D
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354081AbiEDQ4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354527AbiEDQyc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:54:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A09F473BC;
        Wed,  4 May 2022 09:49:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2F85B82552;
        Wed,  4 May 2022 16:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A15C385AA;
        Wed,  4 May 2022 16:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682980;
        bh=s3jweqBnhEqjNyJiyqi75vOnzur55Tp/udMLG09VbCQ=;
        h=From:To:Cc:Subject:Date:From;
        b=n7vEP5U1c2gygUUEenQJwOts7rKBWBxB/2OgBQfGtARgu0COCUkZQ4ZWg4glvlGTj
         IBPyCx9pCHflfQwYsQmkD0WoTWfmmIMtUoH8aZpvkASNT00jcyAsHrLfy7V8xXeh6Y
         GqM2vZCEMiXV10lk13VEWiOibvIwdtPHPVuTFIvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 000/129] 5.10.114-rc1 review
Date:   Wed,  4 May 2022 18:43:12 +0200
Message-Id: <20220504153021.299025455@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.114-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.114-rc1
X-KernelTest-Deadline: 2022-05-06T15:30+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.114 release.
There are 129 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.114-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.114-rc1

Namhyung Kim <namhyung@kernel.org>
    perf symbol: Remove arch__symbols__fixup_end()

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix software flow control handling

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix incorrect UA handling

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix reset fifo race condition

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong command frame length field encoding

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong command retry handling

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix missing explicit ldisc flush

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong DLCI release order

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix insufficient txframe size

Florian Westphal <fw@strlen.de>
    netfilter: nft_socket: only do sk lookups when indev is available

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix malformed counter for out of frame data

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong signal octet encoding in convergence layer type 2

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix mux cleanup after unregister tty device

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix decoupled mux resource

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix restart handling via CLD command

Namhyung Kim <namhyung@kernel.org>
    perf symbol: Update symbols__fixup_end()

Namhyung Kim <namhyung@kernel.org>
    perf symbol: Pass is_kallsyms to symbols__fixup_end()

Borislav Petkov <bp@suse.de>
    x86/cpu: Load microcode during restore_processor_state()

Kees Cook <keescook@chromium.org>
    thermal: int340x: Fix attr.show callback prototype

Dinh Nguyen <dinguyen@kernel.org>
    net: ethernet: stmmac: fix write to sgmii_adapter_base

Imre Deak <imre.deak@intel.com>
    drm/i915: Fix SEL_FETCH_PLANE_*(PIPE_B+) register addresses

Zqiang <qiang1.zhang@intel.com>
    kasan: prevent cpu_quarantine corruption when CPU offline and cache shrink occur at same time

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: Clear inode information flags on inode creation

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: Fix management of open zones

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/perf: Fix 32bit compile

Duoming Zhou <duoming@zju.edu.cn>
    drivers: net: hippi: Fix deadlock in rr_close()

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: destage any unwritten data to the server before calling copychunk_write

Mikulas Patocka <mpatocka@redhat.com>
    x86: __memcpy_flushcache: fix wrong alignment if size > 2^32

Ye Bin <yebin10@huawei.com>
    ext4: fix bug_on in start_this_handle during umount filesystem

Zheyu Ma <zheyuma97@gmail.com>
    ASoC: wm8731: Disable the regulator when probing fails

Chao Song <chao.song@linux.intel.com>
    ASoC: Intel: soc-acpi: correct device endpoints for max98373

Pengcheng Yang <yangpc@wangsu.com>
    tcp: fix F-RTO may not work correctly when receiving DSACK

Dany Madden <drt@linux.ibm.com>
    Revert "ibmvnic: Add ethtool private flag for driver-defined queue limits"

Lijun Pan <lijunp213@gmail.com>
    ibmvnic: fix miscellaneous checks

Leon Romanovsky <leon@kernel.org>
    ixgbe: ensure IPsec VF<->PF compatibility

Yang Yingliang <yangyingliang@huawei.com>
    net: fec: add missing of_node_put() in fec_enet_init_stop_mode()

Manish Chopra <manishc@marvell.com>
    bnx2x: fix napi API usage sequence

Maxim Mikityanskiy <maximmi@nvidia.com>
    tls: Skip tls_append_frag on zero copy size

Miaoqian Lin <linmq006@gmail.com>
    drm/amd/display: Fix memory leak in dcn21_clock_source_create

David Yat Sin <david.yatsin@amd.com>
    drm/amdkfd: Fix GWS queue count

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    net: dsa: lantiq_gswip: Don't set GSWIP_MII_CFG_RMII_CLK

Baruch Siach <baruch.siach@siklu.com>
    net: phy: marvell10g: fix return value on error

Jonathan Lemon <jonathan.lemon@gmail.com>
    net: bcmgenet: hide status block before TX timestamping

Yang Yingliang <yangyingliang@huawei.com>
    clk: sunxi: sun9i-mmc: check return value after calling platform_get_resource()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    bus: sunxi-rsb: Fix the return value of sunxi_rsb_device_create()

Eric Dumazet <edumazet@google.com>
    tcp: make sure treq->af_specific is initialized

Eric Dumazet <edumazet@google.com>
    tcp: fix potential xmit stalls caused by TCP_NOTSENT_LOWAT

Peilin Ye <peilin.ye@bytedance.com>
    ip_gre, ip6_gre: Fix race condition on o_seqno in collect_md mode

Peilin Ye <peilin.ye@bytedance.com>
    ip6_gre: Make o_seqno start from 0 in native mode

Peilin Ye <peilin.ye@bytedance.com>
    ip_gre: Make o_seqno start from 0 in native mode

liuyacan <liuyacan@corp.netease.com>
    net/smc: sync err code when tcp connection was refused

Jian Shen <shenjian15@huawei.com>
    net: hns3: add return value for mailbox handling in PF

Jian Shen <shenjian15@huawei.com>
    net: hns3: add validity check for message data length

Jie Wang <wangjie125@huawei.com>
    net: hns3: modify the return code of hclge_get_ring_chain_from_mbx

Xiaobing Luo <luoxiaobing0926@gmail.com>
    cpufreq: fix memory leak in sun50i_cpufreq_nvmem_probe

Lv Ruyi <lv.ruyi@zte.com.cn>
    pinctrl: pistachio: fix use of irq_of_parse_and_map()

Fabio Estevam <festevam@denx.de>
    arm64: dts: imx8mn-ddr4-evk: Describe the 32.768 kHz PMIC clock

Max Krummenacher <max.krummenacher@toradex.com>
    ARM: dts: imx6ull-colibri: fix vqmmc regulator

Xin Long <lucien.xin@gmail.com>
    sctp: check asoc strreset_chunk in sctp_generate_reconf_event

Nikolay Aleksandrov <razor@blackwall.org>
    wireguard: device: check for metadata_dst with skb_valid_dst()

Pengcheng Yang <yangpc@wangsu.com>
    tcp: ensure to use the most recently sent skb when filling the rate sample

Marek Vasut <marex@denx.de>
    pinctrl: stm32: Keep pinctrl block clock enabled when LEVEL IRQ requested

Francesco Ruggeri <fruggeri@arista.com>
    tcp: md5: incorrect tcp_header_len for incoming connections

Luca Ceresoli <luca.ceresoli@bootlin.com>
    pinctrl: rockchip: fix RK3308 pinmux bits

Eyal Birger <eyal.birger@gmail.com>
    bpf, lwt: Fix crash when using bpf_skb_set_tunnel_key() from bpf_xmit lwt hook

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: overlap detection with element re-addition after deletion

Miaoqian Lin <linmq006@gmail.com>
    net: dsa: Add missing of_node_put() in dsa_port_link_register_of

Geert Uytterhoeven <geert+renesas@glider.be>
    memory: renesas-rpc-if: Fix HF/OSPI data transfer in Manual Mode

Marek Vasut <marex@denx.de>
    pinctrl: stm32: Do not call stm32_gpio_get() for edge triggered IRQs in EOI

Oleksandr Ocheretnyi <oocheret@cisco.com>
    mtd: fix 'part' field data corruption in mtd_info

Miaoqian Lin <linmq006@gmail.com>
    mtd: rawnand: Fix return value check of wait_for_completion_timeout

YueHaibing <yuehaibing@huawei.com>
    pinctrl: mediatek: moore: Fix build error

Pengcheng Yang <yangpc@wangsu.com>
    ipvs: correctly print the memory size of ip_vs_conn_tab

Adam Ford <aford173@gmail.com>
    ARM: dts: logicpd-som-lv: Fix wrong pinmuxing on OMAP35

Adam Ford <aford173@gmail.com>
    ARM: dts: am3517-evm: Fix misc pinmuxing

H. Nikolaus Schaller <hns@goldelico.com>
    ARM: dts: Fix mmc order for omap3-gta04

Miaoqian Lin <linmq006@gmail.com>
    phy: ti: Add missing pm_runtime_disable() in serdes_am654_probe

Miaoqian Lin <linmq006@gmail.com>
    phy: mapphone-mdm6600: Fix PM error handling in phy_mdm6600_probe

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91: sama5d4_xplained: fix pinctrl phandle name

Mark Brown <broonie@kernel.org>
    ARM: dts: at91: Map MCLK for wm8731 on at91sam9g20ek

Miaoqian Lin <linmq006@gmail.com>
    phy: ti: omap-usb2: Fix error handling in omap_usb2_enable_clocks

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Make omap3 gpt12 quirk handling SoC specific

Miaoqian Lin <linmq006@gmail.com>
    ARM: OMAP2+: Fix refcount leak in omap_gic_of_init

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    phy: samsung: exynos5250-sata: fix missing device put in probe error paths

Miaoqian Lin <linmq006@gmail.com>
    phy: samsung: Fix missing of_node_put() in exynos_sata_phy_probe

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx6qdl-apalis: Fix sgtl5000 detection issue

Weitao Wang <WeitaoWang-oc@zhaoxin.com>
    USB: Fix xhci event ring dequeue pointer ERDP update issue

Chuanhong Guo <gch981213@gmail.com>
    mtd: rawnand: fix ecc parameters for mt7622

Tong Zhang <ztong0001@gmail.com>
    iio:imu:bmi160: disable regulator in error path

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson: remove CPU opps below 1GHz for SM1 boards

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson: remove CPU opps below 1GHz for G12B boards

Pavel Skripkin <paskripkin@gmail.com>
    video: fbdev: udlfb: properly check endpoint type

Tejun Heo <tj@kernel.org>
    iocost: don't reset the inuse weight of under-weighted debtors

Thomas Gleixner <tglx@linutronix.de>
    x86/pci/xen: Disable PCI/MSI[-X] masking for XEN_HVM guests

Guo Ren <guoren@linux.alibaba.com>
    riscv: patch_text: Fixup last cpu should be master

Mikulas Patocka <mpatocka@redhat.com>
    hex2bin: fix access beyond string end

Mikulas Patocka <mpatocka@redhat.com>
    hex2bin: make the function hex_to_bin constant-time

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    pinctrl: samsung: fix missing GPIOLIB on ARM64 Exynos config

Wang Qing <wangqing@vivo.com>
    arch_topology: Do not set llc_sibling if llc_id is invalid

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Correct the clock for EndRun PTP/1588 PCIe device

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Also set sticky MCR bits in console restoration

Johan Hovold <johan@kernel.org>
    serial: imx: fix overrun interrupts in DMA mode

Sean Anderson <sean.anderson@seco.com>
    usb: phy: generic: Get the vbus supply

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: Fix issue for clear halt endpoint

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Return proper request status

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: core: Only handle soft-reset in DCTL

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: core: Fix tx/rx threshold settings

Sven Peter <sven@svenpeter.dev>
    usb: dwc3: Try usb-role-switch first in dwc3_drd_init

Vijayavardhan Vennapusa <vvreddy@codeaurora.org>
    usb: gadget: configfs: clear deactivation flag in configfs_composite_unbind()

Dan Vacura <w36195@motorola.com>
    usb: gadget: uvc: Fix crash when encoding data for usb request

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: Fix role swapping

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: Fix reuse of completion structure

Hangyu Hua <hbh25y@gmail.com>
    usb: misc: fix improper handling of refcount in uss720_probe()

Fawzi Khaber <fawzi.khaber@tdk.com>
    iio: imu: inv_icm42600: Fix I2C init possible nack

Zheyu Ma <zheyuma97@gmail.com>
    iio: magnetometer: ak8975: Fix the error handling in ak8975_power_on()

Michael Hennerich <michael.hennerich@analog.com>
    iio: dac: ad5446: Fix read_raw not returning set value

Zizhuang Deng <sunsetdzz@gmail.com>
    iio: dac: ad5592r: Fix the missing return value.

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: increase usb U3 -> U0 link resume timeout from 100ms to 500ms

Henry Lin <henryl@nvidia.com>
    xhci: stop polling roothubs after shutdown

Evan Green <evgreen@chromium.org>
    xhci: Enable runtime PM on second Alderlake controller

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit 0x1057, 0x1058, 0x1075 compositions

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add support for Cinterion MV32-WA/MV32-WB

Bruno Thomsen <bruno.thomsen@gmail.com>
    USB: serial: cp210x: add PIDs for Kamstrup USB Meter Reader

Kees Cook <keescook@chromium.org>
    USB: serial: whiteheat: fix heap overflow in WHITEHEAT_GET_DTR_RTS

Oliver Neukum <oneukum@suse.com>
    USB: quirks: add STRING quirk for VCOM device

Oliver Neukum <oneukum@suse.com>
    USB: quirks: add a Realtek card reader

Macpaul Lin <macpaul.lin@mediatek.com>
    usb: mtu3: fix USB 3.0 dual-role-switch from device to host

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    lightnvm: disable the subsystem

Willy Tarreau <w@1wt.eu>
    floppy: disable FDRAWCMD by default


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/am3517-evm.dts                   |  45 ++++-
 arch/arm/boot/dts/am3517-som.dtsi                  |   9 +
 arch/arm/boot/dts/at91-sama5d4_xplained.dts        |   4 +-
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |   6 +
 arch/arm/boot/dts/imx6qdl-apalis.dtsi              |  10 +-
 arch/arm/boot/dts/imx6ull-colibri.dtsi             |   2 +-
 arch/arm/boot/dts/logicpd-som-lv-35xx-devkit.dts   |  15 ++
 arch/arm/boot/dts/logicpd-som-lv-37xx-devkit.dts   |  15 ++
 arch/arm/boot/dts/logicpd-som-lv.dtsi              |  15 --
 arch/arm/boot/dts/omap3-gta04.dtsi                 |   2 +
 arch/arm/mach-exynos/Kconfig                       |   1 -
 arch/arm/mach-omap2/omap4-common.c                 |   2 +
 arch/arm64/boot/dts/amlogic/meson-g12b-a311d.dtsi  |  40 -----
 arch/arm64/boot/dts/amlogic/meson-g12b-s922x.dtsi  |  40 -----
 arch/arm64/boot/dts/amlogic/meson-sm1.dtsi         |  20 ---
 arch/arm64/boot/dts/freescale/imx8mn-ddr4-evk.dts  |   4 +
 arch/powerpc/perf/Makefile                         |   4 +-
 arch/riscv/kernel/patch.c                          |   2 +-
 arch/x86/include/asm/microcode.h                   |   2 +
 arch/x86/kernel/cpu/microcode/core.c               |   6 +-
 arch/x86/lib/usercopy_64.c                         |   2 +-
 arch/x86/pci/xen.c                                 |   6 +-
 arch/x86/power/cpu.c                               |  10 +-
 block/blk-iocost.c                                 |  12 +-
 drivers/base/arch_topology.c                       |   2 +-
 drivers/block/Kconfig                              |  16 ++
 drivers/block/floppy.c                             |  43 +++--
 drivers/bus/sunxi-rsb.c                            |   2 +
 drivers/bus/ti-sysc.c                              |  16 +-
 drivers/clk/sunxi/clk-sun9i-mmc.c                  |   2 +
 drivers/cpufreq/sun50i-cpufreq-nvmem.c             |   4 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  83 ++++-----
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |   1 +
 drivers/gpu/drm/i915/i915_reg.h                    |   2 +-
 drivers/iio/dac/ad5446.c                           |   2 +-
 drivers/iio/dac/ad5592r-base.c                     |   2 +-
 drivers/iio/imu/bmi160/bmi160_core.c               |  20 ++-
 drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c    |  15 +-
 drivers/iio/magnetometer/ak8975.c                  |   1 +
 drivers/lightnvm/Kconfig                           |   2 +-
 drivers/memory/renesas-rpc-if.c                    |  60 +++++--
 drivers/mtd/nand/raw/mtk_ecc.c                     |  12 +-
 drivers/mtd/nand/raw/sh_flctl.c                    |  14 +-
 drivers/net/dsa/lantiq_gswip.c                     |   3 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   9 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   7 +
 drivers/net/ethernet/freescale/fec_main.c          |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  31 ++--
 drivers/net/ethernet/ibm/ibmvnic.c                 | 144 +++++----------
 drivers/net/ethernet/ibm/ibmvnic.h                 |   6 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c     |   3 +-
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |  12 +-
 drivers/net/hippi/rrunner.c                        |   2 +
 drivers/net/phy/marvell10g.c                       |   2 +-
 drivers/net/wireguard/device.c                     |   3 +-
 drivers/phy/motorola/phy-mapphone-mdm6600.c        |   3 +-
 drivers/phy/samsung/phy-exynos5250-sata.c          |  21 ++-
 drivers/phy/ti/phy-am654-serdes.c                  |   2 +-
 drivers/phy/ti/phy-omap-usb2.c                     |   2 +-
 drivers/pinctrl/mediatek/Kconfig                   |   1 +
 drivers/pinctrl/pinctrl-pistachio.c                |   6 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  45 +++--
 drivers/pinctrl/samsung/Kconfig                    |  11 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |  23 ++-
 .../intel/int340x_thermal/int3400_thermal.c        |   4 +-
 drivers/tty/n_gsm.c                                | 194 +++++++++++----------
 drivers/tty/serial/8250/8250_pci.c                 |   8 +-
 drivers/tty/serial/8250/8250_port.c                |   2 +-
 drivers/tty/serial/imx.c                           |   2 +-
 drivers/usb/cdns3/gadget.c                         |   7 +-
 drivers/usb/core/quirks.c                          |   6 +
 drivers/usb/dwc3/core.c                            |  11 +-
 drivers/usb/dwc3/drd.c                             |  11 +-
 drivers/usb/dwc3/gadget.c                          |  31 +++-
 drivers/usb/gadget/configfs.c                      |   2 +
 drivers/usb/gadget/function/uvc_queue.c            |   2 +
 drivers/usb/host/xhci-hub.c                        |   2 +-
 drivers/usb/host/xhci-pci.c                        |   4 +-
 drivers/usb/host/xhci-ring.c                       |   2 +
 drivers/usb/host/xhci.c                            |  11 ++
 drivers/usb/misc/uss720.c                          |   3 +-
 drivers/usb/mtu3/mtu3_dr.c                         |   6 +-
 drivers/usb/phy/phy-generic.c                      |   7 +
 drivers/usb/serial/cp210x.c                        |   2 +
 drivers/usb/serial/option.c                        |  12 ++
 drivers/usb/serial/whiteheat.c                     |   5 +-
 drivers/usb/typec/ucsi/ucsi.c                      |  24 ++-
 drivers/video/fbdev/udlfb.c                        |  14 +-
 fs/cifs/smb2ops.c                                  |   8 +
 fs/ext4/super.c                                    |  15 +-
 fs/zonefs/super.c                                  |  46 ++++-
 include/linux/kernel.h                             |   2 +-
 include/linux/mtd/mtd.h                            |   6 +-
 include/memory/renesas-rpc-if.h                    |   1 +
 include/net/ip6_tunnel.h                           |   2 +-
 include/net/ip_tunnels.h                           |   2 +-
 include/net/tcp.h                                  |   8 +
 lib/hexdump.c                                      |  41 +++--
 mm/kasan/quarantine.c                              |   7 +
 net/core/lwt_bpf.c                                 |   7 +-
 net/dsa/port.c                                     |   2 +
 net/ipv4/ip_gre.c                                  |  12 +-
 net/ipv4/syncookies.c                              |   8 +-
 net/ipv4/tcp_input.c                               |  15 +-
 net/ipv4/tcp_minisocks.c                           |   2 +-
 net/ipv4/tcp_output.c                              |   1 +
 net/ipv4/tcp_rate.c                                |  11 +-
 net/ipv6/ip6_gre.c                                 |  16 +-
 net/ipv6/syncookies.c                              |   3 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   2 +-
 net/netfilter/nft_set_rbtree.c                     |   6 +-
 net/netfilter/nft_socket.c                         |  52 ++++--
 net/sctp/sm_sideeffect.c                           |   4 +
 net/smc/af_smc.c                                   |   2 +
 net/tls/tls_device.c                               |  12 +-
 sound/soc/codecs/wm8731.c                          |  19 +-
 sound/soc/intel/common/soc-acpi-intel-tgl-match.c  |   4 +-
 tools/perf/arch/arm64/util/Build                   |   1 -
 tools/perf/arch/arm64/util/machine.c               |  27 ---
 tools/perf/arch/s390/util/machine.c                |  16 --
 tools/perf/util/symbol-elf.c                       |   2 +-
 tools/perf/util/symbol.c                           |  37 ++--
 tools/perf/util/symbol.h                           |   3 +-
 124 files changed, 1008 insertions(+), 681 deletions(-)


