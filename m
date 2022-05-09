Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28EB51F5B6
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 09:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiEIHmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 03:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbiEIHlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 03:41:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FCD17909D;
        Mon,  9 May 2022 00:37:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8937CB80FC0;
        Mon,  9 May 2022 07:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECC2C385AE;
        Mon,  9 May 2022 07:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652081870;
        bh=Bv4eUfOFWbN3CjROlUwmkryAVsj7BzS4T6pqq112ZsA=;
        h=From:To:Cc:Subject:Date:From;
        b=1AWxEbp/RbuMzXKvlFfUF9myLEs83ECNvphXQyXaDXz1naFTvdW2YJosx7Ut1zOBl
         xX4CX7gzYfMo3UaKACHgvz5rIOUgDJ6iURYE2065xYI/svivjh08XleISZJPBo/A30
         HITrGYOTHLqG4+XkvObE82aC1jGsfEhx4EYjuO/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.192
Date:   Mon,  9 May 2022 09:37:46 +0200
Message-Id: <16520818664210@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
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

I'm announcing the release of the 5.4.192 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                               |    2 
 arch/arm/boot/dts/am3517-evm.dts                       |   45 +++++++++-
 arch/arm/boot/dts/am3517-som.dtsi                      |    9 ++
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi            |    6 +
 arch/arm/boot/dts/imx6qdl-apalis.dtsi                  |   10 +-
 arch/arm/boot/dts/imx6ull-colibri.dtsi                 |    2 
 arch/arm/boot/dts/logicpd-som-lv-35xx-devkit.dts       |   15 +++
 arch/arm/boot/dts/logicpd-som-lv-37xx-devkit.dts       |   15 +++
 arch/arm/boot/dts/logicpd-som-lv.dtsi                  |   15 ---
 arch/arm/boot/dts/omap3-gta04.dtsi                     |    2 
 arch/arm/mach-omap2/omap4-common.c                     |    2 
 arch/arm64/boot/dts/amlogic/meson-g12b-a311d.dtsi      |   40 ---------
 arch/arm64/boot/dts/amlogic/meson-g12b-s922x.dtsi      |   40 ---------
 arch/arm64/boot/dts/amlogic/meson-sm1.dtsi             |   20 ----
 arch/arm64/boot/dts/freescale/imx8mn-ddr4-evk.dts      |    4 
 arch/x86/include/asm/microcode.h                       |    2 
 arch/x86/kernel/cpu/microcode/core.c                   |    6 -
 arch/x86/lib/usercopy_64.c                             |    2 
 arch/x86/power/cpu.c                                   |    8 +
 drivers/base/arch_topology.c                           |    2 
 drivers/block/Kconfig                                  |   16 +++
 drivers/block/floppy.c                                 |   43 +++++++---
 drivers/bus/sunxi-rsb.c                                |    2 
 drivers/clk/sunxi/clk-sun9i-mmc.c                      |    2 
 drivers/cpufreq/sun50i-cpufreq-nvmem.c                 |    4 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |    1 
 drivers/iio/dac/ad5446.c                               |    2 
 drivers/iio/dac/ad5592r-base.c                         |    2 
 drivers/iio/magnetometer/ak8975.c                      |    1 
 drivers/lightnvm/Kconfig                               |    2 
 drivers/mtd/nand/raw/mtk_ecc.c                         |   12 +-
 drivers/mtd/nand/raw/sh_flctl.c                        |   14 +--
 drivers/net/dsa/lantiq_gswip.c                         |    3 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c       |    9 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c         |    7 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |    7 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c         |    3 
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |   12 +-
 drivers/net/hamradio/6pack.c                           |    5 -
 drivers/net/hippi/rrunner.c                            |    2 
 drivers/phy/motorola/phy-mapphone-mdm6600.c            |    3 
 drivers/phy/samsung/phy-exynos5250-sata.c              |   21 +++--
 drivers/phy/ti/phy-am654-serdes.c                      |    2 
 drivers/phy/ti/phy-omap-usb2.c                         |    2 
 drivers/pinctrl/pinctrl-pistachio.c                    |    6 -
 drivers/tty/n_gsm.c                                    |   40 +++++----
 drivers/tty/serial/8250/8250_pci.c                     |    8 -
 drivers/tty/serial/8250/8250_port.c                    |    2 
 drivers/tty/serial/imx.c                               |    2 
 drivers/usb/core/quirks.c                              |    6 +
 drivers/usb/dwc3/core.c                                |    8 -
 drivers/usb/dwc3/gadget.c                              |   31 +++++++
 drivers/usb/gadget/configfs.c                          |    2 
 drivers/usb/gadget/function/uvc_queue.c                |    2 
 drivers/usb/host/xhci-hub.c                            |    2 
 drivers/usb/host/xhci-ring.c                           |    2 
 drivers/usb/host/xhci.c                                |   11 ++
 drivers/usb/misc/uss720.c                              |    3 
 drivers/usb/mtu3/mtu3_dr.c                             |    6 -
 drivers/usb/serial/cp210x.c                            |    2 
 drivers/usb/serial/option.c                            |   12 ++
 drivers/usb/serial/whiteheat.c                         |    5 -
 drivers/usb/typec/ucsi/ucsi.c                          |   20 +++-
 drivers/video/fbdev/udlfb.c                            |   14 ++-
 fs/cifs/smb2ops.c                                      |    8 +
 fs/hugetlbfs/inode.c                                   |   70 ++++++++++++++---
 include/linux/kernel.h                                 |    2 
 include/linux/sched/mm.h                               |    8 +
 include/net/tcp.h                                      |    7 +
 lib/hexdump.c                                          |   41 +++++++--
 mm/mmap.c                                              |    8 -
 net/core/lwt_bpf.c                                     |    7 -
 net/ipv4/ip_gre.c                                      |    8 -
 net/ipv4/tcp_input.c                                   |   15 +++
 net/ipv4/tcp_minisocks.c                               |    2 
 net/ipv4/tcp_output.c                                  |    1 
 net/ipv4/tcp_rate.c                                    |   11 +-
 net/ipv6/ip6_gre.c                                     |    5 -
 net/netfilter/ipvs/ip_vs_conn.c                        |    2 
 net/netfilter/nft_socket.c                             |   52 +++++++++---
 net/sctp/sm_sideeffect.c                               |    4 
 net/smc/af_smc.c                                       |    2 
 net/tls/tls_device.c                                   |   12 +-
 sound/soc/codecs/wm8731.c                              |   19 ++--
 84 files changed, 589 insertions(+), 303 deletions(-)

Adam Ford (2):
      ARM: dts: am3517-evm: Fix misc pinmuxing
      ARM: dts: logicpd-som-lv: Fix wrong pinmuxing on OMAP35

Borislav Petkov (1):
      x86/cpu: Load microcode during restore_processor_state()

Bruno Thomsen (1):
      USB: serial: cp210x: add PIDs for Kamstrup USB Meter Reader

Christian Hewitt (2):
      arm64: dts: meson: remove CPU opps below 1GHz for G12B boards
      arm64: dts: meson: remove CPU opps below 1GHz for SM1 boards

Christophe JAILLET (1):
      bus: sunxi-rsb: Fix the return value of sunxi_rsb_device_create()

Christophe Leroy (1):
      mm, hugetlb: allow for "high" userspace addresses

Chuanhong Guo (1):
      mtd: rawnand: fix ecc parameters for mt7622

Dan Vacura (1):
      usb: gadget: uvc: Fix crash when encoding data for usb request

Daniel Starke (7):
      tty: n_gsm: fix wrong signal octet encoding in convergence layer type 2
      tty: n_gsm: fix malformed counter for out of frame data
      tty: n_gsm: fix insufficient txframe size
      tty: n_gsm: fix missing explicit ldisc flush
      tty: n_gsm: fix wrong command retry handling
      tty: n_gsm: fix wrong command frame length field encoding
      tty: n_gsm: fix incorrect UA handling

Daniele Palmas (1):
      USB: serial: option: add Telit 0x1057, 0x1058, 0x1075 compositions

Dinh Nguyen (1):
      net: ethernet: stmmac: fix write to sgmii_adapter_base

Duoming Zhou (1):
      drivers: net: hippi: Fix deadlock in rr_close()

Eric Dumazet (1):
      tcp: fix potential xmit stalls caused by TCP_NOTSENT_LOWAT

Eyal Birger (1):
      bpf, lwt: Fix crash when using bpf_skb_set_tunnel_key() from bpf_xmit lwt hook

Fabio Estevam (2):
      ARM: dts: imx6qdl-apalis: Fix sgtl5000 detection issue
      arm64: dts: imx8mn-ddr4-evk: Describe the 32.768 kHz PMIC clock

Florian Westphal (1):
      netfilter: nft_socket: only do sk lookups when indev is available

Francesco Ruggeri (1):
      tcp: md5: incorrect tcp_header_len for incoming connections

Greg Kroah-Hartman (2):
      lightnvm: disable the subsystem
      Linux 5.4.192

H. Nikolaus Schaller (1):
      ARM: dts: Fix mmc order for omap3-gta04

Hangyu Hua (1):
      usb: misc: fix improper handling of refcount in uss720_probe()

Heikki Krogerus (1):
      usb: typec: ucsi: Fix role swapping

Henry Lin (1):
      xhci: stop polling roothubs after shutdown

Jian Shen (1):
      net: hns3: add validity check for message data length

Johan Hovold (1):
      serial: imx: fix overrun interrupts in DMA mode

Jonathan Lemon (1):
      net: bcmgenet: hide status block before TX timestamping

Kees Cook (1):
      USB: serial: whiteheat: fix heap overflow in WHITEHEAT_GET_DTR_RTS

Krzysztof Kozlowski (1):
      phy: samsung: exynos5250-sata: fix missing device put in probe error paths

Leon Romanovsky (1):
      ixgbe: ensure IPsec VF<->PF compatibility

Lin Ma (2):
      hamradio: defer 6pack kfree after unregister_netdev
      hamradio: remove needs_free_netdev to avoid UAF

Lv Ruyi (1):
      pinctrl: pistachio: fix use of irq_of_parse_and_map()

Maciej W. Rozycki (2):
      serial: 8250: Also set sticky MCR bits in console restoration
      serial: 8250: Correct the clock for EndRun PTP/1588 PCIe device

Macpaul Lin (1):
      usb: mtu3: fix USB 3.0 dual-role-switch from device to host

Manish Chopra (1):
      bnx2x: fix napi API usage sequence

Mark Brown (1):
      ARM: dts: at91: Map MCLK for wm8731 on at91sam9g20ek

Martin Blumenstingl (1):
      net: dsa: lantiq_gswip: Don't set GSWIP_MII_CFG_RMII_CLK

Mathias Nyman (1):
      xhci: increase usb U3 -> U0 link resume timeout from 100ms to 500ms

Max Krummenacher (1):
      ARM: dts: imx6ull-colibri: fix vqmmc regulator

Maxim Mikityanskiy (1):
      tls: Skip tls_append_frag on zero copy size

Miaoqian Lin (7):
      phy: samsung: Fix missing of_node_put() in exynos_sata_phy_probe
      ARM: OMAP2+: Fix refcount leak in omap_gic_of_init
      phy: ti: omap-usb2: Fix error handling in omap_usb2_enable_clocks
      phy: mapphone-mdm6600: Fix PM error handling in phy_mdm6600_probe
      phy: ti: Add missing pm_runtime_disable() in serdes_am654_probe
      mtd: rawnand: Fix return value check of wait_for_completion_timeout
      drm/amd/display: Fix memory leak in dcn21_clock_source_create

Michael Hennerich (1):
      iio: dac: ad5446: Fix read_raw not returning set value

Mikulas Patocka (3):
      hex2bin: make the function hex_to_bin constant-time
      hex2bin: fix access beyond string end
      x86: __memcpy_flushcache: fix wrong alignment if size > 2^32

Oliver Neukum (2):
      USB: quirks: add a Realtek card reader
      USB: quirks: add STRING quirk for VCOM device

Pavel Skripkin (1):
      video: fbdev: udlfb: properly check endpoint type

Peilin Ye (2):
      ip_gre: Make o_seqno start from 0 in native mode
      ip6_gre: Avoid updating tunnel->tun_hlen in __gre6_xmit()

Pengcheng Yang (3):
      ipvs: correctly print the memory size of ip_vs_conn_tab
      tcp: ensure to use the most recently sent skb when filling the rate sample
      tcp: fix F-RTO may not work correctly when receiving DSACK

Ronnie Sahlberg (1):
      cifs: destage any unwritten data to the server before calling copychunk_write

Shijie Hu (1):
      hugetlbfs: get unmapped area below TASK_UNMAPPED_BASE for hugetlbfs

Slark Xiao (1):
      USB: serial: option: add support for Cinterion MV32-WA/MV32-WB

Thinh Nguyen (2):
      usb: dwc3: core: Fix tx/rx threshold settings
      usb: dwc3: gadget: Return proper request status

Vijayavardhan Vennapusa (1):
      usb: gadget: configfs: clear deactivation flag in configfs_composite_unbind()

Wang Qing (1):
      arch_topology: Do not set llc_sibling if llc_id is invalid

Weitao Wang (1):
      USB: Fix xhci event ring dequeue pointer ERDP update issue

Willy Tarreau (1):
      floppy: disable FDRAWCMD by default

Xiaobing Luo (1):
      cpufreq: fix memory leak in sun50i_cpufreq_nvmem_probe

Xin Long (1):
      sctp: check asoc strreset_chunk in sctp_generate_reconf_event

Yang Yingliang (1):
      clk: sunxi: sun9i-mmc: check return value after calling platform_get_resource()

Zheyu Ma (2):
      iio: magnetometer: ak8975: Fix the error handling in ak8975_power_on()
      ASoC: wm8731: Disable the regulator when probing fails

Zizhuang Deng (1):
      iio: dac: ad5592r: Fix the missing return value.

liuyacan (1):
      net/smc: sync err code when tcp connection was refused

