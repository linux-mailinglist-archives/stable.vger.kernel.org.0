Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB8151A5FF
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353695AbiEDQwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353680AbiEDQwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:52:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0903B46B22;
        Wed,  4 May 2022 09:48:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A4C7B82553;
        Wed,  4 May 2022 16:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044EFC385A5;
        Wed,  4 May 2022 16:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682904;
        bh=t0pqBsukp2dG6Sl9p9t52xKXSWk4PztHCoiM/rYceB4=;
        h=From:To:Cc:Subject:Date:From;
        b=0KiQUbW/xuO827taZ33c0Nt2fUl+S8jIgK02kV1iISs9oaZbYvP01aCeJ/W8UCeou
         KI3BBYJ5v290i70xEJ2Q1X0XJdAUDqkY3BsOrG6RqQNIL9YlfHrx6aQ/pNfLO0wiud
         OgEXp7euRGEI4M0C0ql6y+GARrDkVpFkAef7DBDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/84] 5.4.192-rc1 review
Date:   Wed,  4 May 2022 18:43:41 +0200
Message-Id: <20220504152927.744120418@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.192-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.192-rc1
X-KernelTest-Deadline: 2022-05-06T15:29+00:00
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

This is the start of the stable review cycle for the 5.4.192 release.
There are 84 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.192-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.192-rc1

Christophe Leroy <christophe.leroy@csgroup.eu>
    mm, hugetlb: allow for "high" userspace addresses

Shijie Hu <hushijie3@huawei.com>
    hugetlbfs: get unmapped area below TASK_UNMAPPED_BASE for hugetlbfs

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix incorrect UA handling

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong command frame length field encoding

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong command retry handling

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix missing explicit ldisc flush

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix insufficient txframe size

Florian Westphal <fw@strlen.de>
    netfilter: nft_socket: only do sk lookups when indev is available

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix malformed counter for out of frame data

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong signal octet encoding in convergence layer type 2

Borislav Petkov <bp@suse.de>
    x86/cpu: Load microcode during restore_processor_state()

Dinh Nguyen <dinguyen@kernel.org>
    net: ethernet: stmmac: fix write to sgmii_adapter_base

Duoming Zhou <duoming@zju.edu.cn>
    drivers: net: hippi: Fix deadlock in rr_close()

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: destage any unwritten data to the server before calling copychunk_write

Mikulas Patocka <mpatocka@redhat.com>
    x86: __memcpy_flushcache: fix wrong alignment if size > 2^32

Peilin Ye <peilin.ye@bytedance.com>
    ip6_gre: Avoid updating tunnel->tun_hlen in __gre6_xmit()

Zheyu Ma <zheyuma97@gmail.com>
    ASoC: wm8731: Disable the regulator when probing fails

Pengcheng Yang <yangpc@wangsu.com>
    tcp: fix F-RTO may not work correctly when receiving DSACK

Leon Romanovsky <leonro@nvidia.com>
    ixgbe: ensure IPsec VF<->PF compatibility

Manish Chopra <manishc@marvell.com>
    bnx2x: fix napi API usage sequence

Maxim Mikityanskiy <maximmi@nvidia.com>
    tls: Skip tls_append_frag on zero copy size

Miaoqian Lin <linmq006@gmail.com>
    drm/amd/display: Fix memory leak in dcn21_clock_source_create

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    net: dsa: lantiq_gswip: Don't set GSWIP_MII_CFG_RMII_CLK

Jonathan Lemon <jonathan.lemon@gmail.com>
    net: bcmgenet: hide status block before TX timestamping

Yang Yingliang <yangyingliang@huawei.com>
    clk: sunxi: sun9i-mmc: check return value after calling platform_get_resource()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    bus: sunxi-rsb: Fix the return value of sunxi_rsb_device_create()

Eric Dumazet <edumazet@google.com>
    tcp: fix potential xmit stalls caused by TCP_NOTSENT_LOWAT

Peilin Ye <peilin.ye@bytedance.com>
    ip_gre: Make o_seqno start from 0 in native mode

liuyacan <liuyacan@corp.netease.com>
    net/smc: sync err code when tcp connection was refused

Jian Shen <shenjian15@huawei.com>
    net: hns3: add validity check for message data length

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

Pengcheng Yang <yangpc@wangsu.com>
    tcp: ensure to use the most recently sent skb when filling the rate sample

Francesco Ruggeri <fruggeri@arista.com>
    tcp: md5: incorrect tcp_header_len for incoming connections

Eyal Birger <eyal.birger@gmail.com>
    bpf, lwt: Fix crash when using bpf_skb_set_tunnel_key() from bpf_xmit lwt hook

Miaoqian Lin <linmq006@gmail.com>
    mtd: rawnand: Fix return value check of wait_for_completion_timeout

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

Mark Brown <broonie@kernel.org>
    ARM: dts: at91: Map MCLK for wm8731 on at91sam9g20ek

Miaoqian Lin <linmq006@gmail.com>
    phy: ti: omap-usb2: Fix error handling in omap_usb2_enable_clocks

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

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson: remove CPU opps below 1GHz for SM1 boards

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson: remove CPU opps below 1GHz for G12B boards

Pavel Skripkin <paskripkin@gmail.com>
    video: fbdev: udlfb: properly check endpoint type

Mikulas Patocka <mpatocka@redhat.com>
    hex2bin: fix access beyond string end

Mikulas Patocka <mpatocka@redhat.com>
    hex2bin: make the function hex_to_bin constant-time

Wang Qing <wangqing@vivo.com>
    arch_topology: Do not set llc_sibling if llc_id is invalid

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Correct the clock for EndRun PTP/1588 PCIe device

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Also set sticky MCR bits in console restoration

Johan Hovold <johan@kernel.org>
    serial: imx: fix overrun interrupts in DMA mode

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Return proper request status

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: core: Fix tx/rx threshold settings

Vijayavardhan Vennapusa <vvreddy@codeaurora.org>
    usb: gadget: configfs: clear deactivation flag in configfs_composite_unbind()

Dan Vacura <w36195@motorola.com>
    usb: gadget: uvc: Fix crash when encoding data for usb request

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: Fix role swapping

Hangyu Hua <hbh25y@gmail.com>
    usb: misc: fix improper handling of refcount in uss720_probe()

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

Lin Ma <linma@zju.edu.cn>
    hamradio: remove needs_free_netdev to avoid UAF

Lin Ma <linma@zju.edu.cn>
    hamradio: defer 6pack kfree after unregister_netdev

Willy Tarreau <w@1wt.eu>
    floppy: disable FDRAWCMD by default


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/am3517-evm.dts                   | 45 ++++++++++++--
 arch/arm/boot/dts/am3517-som.dtsi                  |  9 +++
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |  6 ++
 arch/arm/boot/dts/imx6qdl-apalis.dtsi              | 10 +++-
 arch/arm/boot/dts/imx6ull-colibri.dtsi             |  2 +-
 arch/arm/boot/dts/logicpd-som-lv-35xx-devkit.dts   | 15 +++++
 arch/arm/boot/dts/logicpd-som-lv-37xx-devkit.dts   | 15 +++++
 arch/arm/boot/dts/logicpd-som-lv.dtsi              | 15 -----
 arch/arm/boot/dts/omap3-gta04.dtsi                 |  2 +
 arch/arm/mach-omap2/omap4-common.c                 |  2 +
 arch/arm64/boot/dts/amlogic/meson-g12b-a311d.dtsi  | 40 -------------
 arch/arm64/boot/dts/amlogic/meson-g12b-s922x.dtsi  | 40 -------------
 arch/arm64/boot/dts/amlogic/meson-sm1.dtsi         | 20 -------
 arch/arm64/boot/dts/freescale/imx8mn-ddr4-evk.dts  |  4 ++
 arch/x86/include/asm/microcode.h                   |  2 +
 arch/x86/kernel/cpu/microcode/core.c               |  6 +-
 arch/x86/lib/usercopy_64.c                         |  2 +-
 arch/x86/power/cpu.c                               |  8 +++
 drivers/base/arch_topology.c                       |  2 +-
 drivers/block/Kconfig                              | 16 +++++
 drivers/block/floppy.c                             | 43 +++++++++----
 drivers/bus/sunxi-rsb.c                            |  2 +
 drivers/clk/sunxi/clk-sun9i-mmc.c                  |  2 +
 drivers/cpufreq/sun50i-cpufreq-nvmem.c             |  4 +-
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |  1 +
 drivers/iio/dac/ad5446.c                           |  2 +-
 drivers/iio/dac/ad5592r-base.c                     |  2 +-
 drivers/iio/magnetometer/ak8975.c                  |  1 +
 drivers/lightnvm/Kconfig                           |  2 +-
 drivers/mtd/nand/raw/mtk_ecc.c                     | 12 ++--
 drivers/mtd/nand/raw/sh_flctl.c                    | 14 +++--
 drivers/net/dsa/lantiq_gswip.c                     |  3 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  9 +--
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  7 +++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  7 +++
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c     |  3 +-
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    | 12 ++--
 drivers/net/hamradio/6pack.c                       |  5 +-
 drivers/net/hippi/rrunner.c                        |  2 +
 drivers/phy/motorola/phy-mapphone-mdm6600.c        |  3 +-
 drivers/phy/samsung/phy-exynos5250-sata.c          | 21 +++++--
 drivers/phy/ti/phy-am654-serdes.c                  |  2 +-
 drivers/phy/ti/phy-omap-usb2.c                     |  2 +-
 drivers/pinctrl/pinctrl-pistachio.c                |  6 +-
 drivers/tty/n_gsm.c                                | 40 +++++++------
 drivers/tty/serial/8250/8250_pci.c                 |  8 +--
 drivers/tty/serial/8250/8250_port.c                |  2 +-
 drivers/tty/serial/imx.c                           |  2 +-
 drivers/usb/core/quirks.c                          |  6 ++
 drivers/usb/dwc3/core.c                            |  8 +--
 drivers/usb/dwc3/gadget.c                          | 31 +++++++++-
 drivers/usb/gadget/configfs.c                      |  2 +
 drivers/usb/gadget/function/uvc_queue.c            |  2 +
 drivers/usb/host/xhci-hub.c                        |  2 +-
 drivers/usb/host/xhci-ring.c                       |  2 +
 drivers/usb/host/xhci.c                            | 11 ++++
 drivers/usb/misc/uss720.c                          |  3 +-
 drivers/usb/mtu3/mtu3_dr.c                         |  6 +-
 drivers/usb/serial/cp210x.c                        |  2 +
 drivers/usb/serial/option.c                        | 12 ++++
 drivers/usb/serial/whiteheat.c                     |  5 +-
 drivers/usb/typec/ucsi/ucsi.c                      | 20 ++++---
 drivers/video/fbdev/udlfb.c                        | 14 ++++-
 fs/cifs/smb2ops.c                                  |  8 +++
 fs/hugetlbfs/inode.c                               | 70 +++++++++++++++++++---
 include/linux/kernel.h                             |  2 +-
 include/linux/sched/mm.h                           |  8 +++
 include/net/tcp.h                                  |  7 +++
 lib/hexdump.c                                      | 41 +++++++++----
 mm/mmap.c                                          |  8 ---
 net/core/lwt_bpf.c                                 |  7 +--
 net/ipv4/ip_gre.c                                  |  8 +--
 net/ipv4/tcp_input.c                               | 15 ++++-
 net/ipv4/tcp_minisocks.c                           |  2 +-
 net/ipv4/tcp_output.c                              |  1 +
 net/ipv4/tcp_rate.c                                | 11 +++-
 net/ipv6/ip6_gre.c                                 |  5 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |  2 +-
 net/netfilter/nft_socket.c                         | 52 +++++++++++-----
 net/sctp/sm_sideeffect.c                           |  4 ++
 net/smc/af_smc.c                                   |  2 +
 net/tls/tls_device.c                               | 12 ++--
 sound/soc/codecs/wm8731.c                          | 19 +++---
 84 files changed, 590 insertions(+), 304 deletions(-)


