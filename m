Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6256C524B47
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 13:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353055AbiELLQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 07:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353220AbiELLQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 07:16:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D2ABC3C;
        Thu, 12 May 2022 04:16:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F64FB82714;
        Thu, 12 May 2022 11:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88794C385B8;
        Thu, 12 May 2022 11:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652354179;
        bh=SLpFW94RREjYtkKmVV5ap4BC6uMq/YVKzDTlLV5+Vas=;
        h=From:To:Cc:Subject:Date:From;
        b=rA7Lvq5h1Vv125F7B9sgpcEtaOsItd/FqGCP1f1ac/n+A/dG9R0YcBfdqpygMMgRZ
         dlNKsuXBv34xmyBxv/xfB8jR1Q9ltoh79UVU6hVwv4GVxhkYr+F0Q7LVaJLcVxZ4uO
         vg/1zmxG/LtBB0OaiaWxRSaQ/wRie9kEaXJcCoYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.242
Date:   Thu, 12 May 2022 13:16:04 +0200
Message-Id: <1652354164223242@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

I'm announcing the release of the 4.19.242 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 arch/arm/boot/dts/imx6qdl-apalis.dtsi                          |   10 +
 arch/arm/boot/dts/imx6ull-colibri.dtsi                         |    2 
 arch/arm/boot/dts/logicpd-som-lv-35xx-devkit.dts               |   15 ++
 arch/arm/boot/dts/logicpd-som-lv-37xx-devkit.dts               |   15 ++
 arch/arm/boot/dts/logicpd-som-lv.dtsi                          |   15 --
 arch/arm/boot/dts/omap3-gta04.dtsi                             |    2 
 arch/arm/mach-omap2/omap4-common.c                             |    2 
 arch/mips/include/asm/timex.h                                  |    8 -
 arch/mips/kernel/time.c                                        |   11 --
 arch/parisc/kernel/processor.c                                 |    3 
 arch/x86/include/asm/microcode.h                               |    2 
 arch/x86/kernel/cpu/microcode/core.c                           |    6 -
 arch/x86/kvm/cpuid.c                                           |    5 
 arch/x86/lib/usercopy_64.c                                     |    2 
 arch/x86/power/cpu.c                                           |    8 +
 drivers/bus/sunxi-rsb.c                                        |    2 
 drivers/clk/sunxi/clk-sun9i-mmc.c                              |    2 
 drivers/firewire/core-card.c                                   |    3 
 drivers/firewire/core-cdev.c                                   |    4 
 drivers/firewire/core-topology.c                               |    9 -
 drivers/firewire/core-transaction.c                            |   30 ++---
 drivers/firewire/sbp2.c                                        |   13 +-
 drivers/gpio/gpiolib-of.c                                      |    2 
 drivers/gpu/drm/vgem/vgem_drv.c                                |    9 +
 drivers/hwmon/adt7470.c                                        |    4 
 drivers/iio/dac/ad5446.c                                       |    2 
 drivers/iio/dac/ad5592r-base.c                                 |    2 
 drivers/iio/magnetometer/ak8975.c                              |    1 
 drivers/md/dm.c                                                |   19 ++-
 drivers/mmc/host/rtsx_pci_sdmmc.c                              |   31 +++--
 drivers/mtd/nand/raw/mtk_ecc.c                                 |   12 +-
 drivers/mtd/nand/raw/sh_flctl.c                                |   14 +-
 drivers/net/can/grcan.c                                        |    8 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c               |    9 -
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                 |    7 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c         |    7 +
 drivers/net/ethernet/smsc/smsc911x.c                           |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c              |    1 
 drivers/net/ethernet/xilinx/xilinx_emaclite.c                  |   15 ++
 drivers/net/hippi/rrunner.c                                    |    2 
 drivers/nfc/nfcmrvl/main.c                                     |    2 
 drivers/pci/controller/pci-aardvark.c                          |   16 +-
 drivers/phy/samsung/phy-exynos5250-sata.c                      |   21 ++-
 drivers/pinctrl/pinctrl-pistachio.c                            |    6 -
 drivers/tty/n_gsm.c                                            |   40 +++----
 drivers/tty/serial/8250/8250_pci.c                             |    8 -
 drivers/tty/serial/8250/8250_port.c                            |    2 
 drivers/tty/serial/imx.c                                       |    2 
 drivers/usb/core/quirks.c                                      |    6 +
 drivers/usb/dwc3/core.c                                        |    8 -
 drivers/usb/dwc3/gadget.c                                      |   31 +++++
 drivers/usb/gadget/configfs.c                                  |    2 
 drivers/usb/gadget/function/uvc_queue.c                        |    2 
 drivers/usb/host/xhci-ring.c                                   |    2 
 drivers/usb/host/xhci.c                                        |   11 ++
 drivers/usb/misc/uss720.c                                      |    3 
 drivers/usb/mtu3/mtu3_dr.c                                     |    6 -
 drivers/usb/serial/cp210x.c                                    |    2 
 drivers/usb/serial/option.c                                    |   12 ++
 drivers/usb/serial/whiteheat.c                                 |    5 
 fs/btrfs/tree-log.c                                            |   14 ++
 fs/cifs/smb2ops.c                                              |    8 +
 include/linux/kernel.h                                         |    2 
 include/net/tcp.h                                              |    6 +
 kernel/irq/internals.h                                         |    2 
 kernel/irq/irqdesc.c                                           |    2 
 kernel/irq/manage.c                                            |   39 +++++--
 lib/hexdump.c                                                  |   41 +++++--
 mm/page_io.c                                                   |   55 ----------
 net/ipv4/igmp.c                                                |    9 +
 net/ipv4/ip_gre.c                                              |    8 -
 net/ipv4/syncookies.c                                          |    1 
 net/ipv4/tcp_input.c                                           |   12 ++
 net/ipv4/tcp_ipv4.c                                            |    2 
 net/ipv4/tcp_minisocks.c                                       |    2 
 net/ipv4/tcp_output.c                                          |    1 
 net/ipv6/ip6_gre.c                                             |    5 
 net/ipv6/syncookies.c                                          |    1 
 net/ipv6/tcp_ipv6.c                                            |    2 
 net/netfilter/ipvs/ip_vs_conn.c                                |    2 
 net/netfilter/nft_socket.c                                     |   52 ++++++---
 net/nfc/core.c                                                 |   29 ++---
 net/nfc/netlink.c                                              |    4 
 net/sctp/sm_sideeffect.c                                       |    4 
 net/sunrpc/xprtsock.c                                          |    3 
 sound/firewire/fireworks/fireworks_hwdep.c                     |    1 
 sound/soc/codecs/wm8731.c                                      |   19 ++-
 sound/soc/codecs/wm8958-dsp2.c                                 |    8 -
 sound/soc/soc-generic-dmaengine-pcm.c                          |    6 -
 tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh |    3 
 91 files changed, 540 insertions(+), 308 deletions(-)

Adam Ford (1):
      ARM: dts: logicpd-som-lv: Fix wrong pinmuxing on OMAP35

Andrei Lalaev (1):
      gpiolib: of: fix bounds check for 'gpio-reserved-ranges'

Armin Wolf (1):
      hwmon: (adt7470) Fix warning on module removal

Borislav Petkov (1):
      x86/cpu: Load microcode during restore_processor_state()

Bruno Thomsen (1):
      USB: serial: cp210x: add PIDs for Kamstrup USB Meter Reader

Chengfeng Ye (1):
      firewire: fix potential uaf in outbound_phy_packet_callback()

Christophe JAILLET (1):
      bus: sunxi-rsb: Fix the return value of sunxi_rsb_device_create()

Chuanhong Guo (1):
      mtd: rawnand: fix ecc parameters for mt7622

Codrin Ciubotariu (1):
      ASoC: dmaengine: Restore NULL prepare_slave_config() callback

Dan Vacura (1):
      usb: gadget: uvc: Fix crash when encoding data for usb request

Daniel Hellstrom (1):
      can: grcan: use ofdev->dev when allocating DMA memory

Daniel Starke (7):
      tty: n_gsm: fix wrong signal octet encoding in convergence layer type 2
      tty: n_gsm: fix malformed counter for out of frame data
      tty: n_gsm: fix insufficient txframe size
      tty: n_gsm: fix missing explicit ldisc flush
      tty: n_gsm: fix wrong command retry handling
      tty: n_gsm: fix wrong command frame length field encoding
      tty: n_gsm: fix incorrect UA handling

Daniel Vetter (1):
      drm/vgem: Close use-after-free race in vgem_gem_create

Daniele Palmas (1):
      USB: serial: option: add Telit 0x1057, 0x1058, 0x1075 compositions

Duoming Zhou (5):
      drivers: net: hippi: Fix deadlock in rr_close()
      can: grcan: grcan_close(): fix deadlock
      nfc: replace improper check device_is_registered() in netlink related functions
      nfc: nfcmrvl: main: reorder destructive operations in nfcmrvl_nci_unregister_dev to avoid bugs
      NFC: netlink: fix sleep in atomic bug when firmware download timeout

Eric Dumazet (3):
      tcp: fix potential xmit stalls caused by TCP_NOTSENT_LOWAT
      net: igmp: respect RCU rules in ip_mc_source() and ip_mc_msfilter()
      tcp: make sure treq->af_specific is initialized

Fabio Estevam (1):
      ARM: dts: imx6qdl-apalis: Fix sgtl5000 detection issue

Filipe Manana (1):
      btrfs: always log symlinks in full mode

Florian Westphal (1):
      netfilter: nft_socket: only do sk lookups when indev is available

Francesco Ruggeri (1):
      tcp: md5: incorrect tcp_header_len for incoming connections

Greg Kroah-Hartman (1):
      Linux 4.19.242

H. Nikolaus Schaller (1):
      ARM: dts: Fix mmc order for omap3-gta04

Hangyu Hua (1):
      usb: misc: fix improper handling of refcount in uss720_probe()

Helge Deller (1):
      parisc: Merge model and model name into one line in /proc/cpuinfo

Henry Lin (1):
      xhci: stop polling roothubs after shutdown

Ido Schimmel (1):
      selftests: mirror_gre_bridge_1q: Avoid changing PVID while interface is operational

Jakob Koschel (1):
      firewire: remove check of list iterator against head past the loop body

Jian Shen (1):
      net: hns3: add validity check for message data length

Jiazi Li (1):
      dm: fix mempool NULL pointer race when completing IO

Johan Hovold (1):
      serial: imx: fix overrun interrupts in DMA mode

Jonathan Lemon (1):
      net: bcmgenet: hide status block before TX timestamping

Kees Cook (1):
      USB: serial: whiteheat: fix heap overflow in WHITEHEAT_GET_DTR_RTS

Krzysztof Kozlowski (1):
      phy: samsung: exynos5250-sata: fix missing device put in probe error paths

Lv Ruyi (1):
      pinctrl: pistachio: fix use of irq_of_parse_and_map()

Maciej W. Rozycki (3):
      serial: 8250: Also set sticky MCR bits in console restoration
      serial: 8250: Correct the clock for EndRun PTP/1588 PCIe device
      MIPS: Fix CP0 counter erratum detection for R4k CPUs

Macpaul Lin (1):
      usb: mtu3: fix USB 3.0 dual-role-switch from device to host

Manish Chopra (1):
      bnx2x: fix napi API usage sequence

Mark Brown (1):
      ASoC: wm8958: Fix change notifications for DSP controls

Max Krummenacher (1):
      ARM: dts: imx6ull-colibri: fix vqmmc regulator

Miaoqian Lin (3):
      phy: samsung: Fix missing of_node_put() in exynos_sata_phy_probe
      ARM: OMAP2+: Fix refcount leak in omap_gic_of_init
      mtd: rawnand: Fix return value check of wait_for_completion_timeout

Michael Hennerich (1):
      iio: dac: ad5446: Fix read_raw not returning set value

Mike Snitzer (1):
      dm: interlock pending dm_io and dm_wait_for_bios_completion

Mikulas Patocka (3):
      hex2bin: make the function hex_to_bin constant-time
      hex2bin: fix access beyond string end
      x86: __memcpy_flushcache: fix wrong alignment if size > 2^32

Minchan Kim (1):
      mm: fix unexpected zeroed page mapping with zram swap

Niels Dossche (1):
      firewire: core: extend card->lock in fw_core_handle_bus_reset

Oliver Neukum (2):
      USB: quirks: add a Realtek card reader
      USB: quirks: add STRING quirk for VCOM device

Pali Rohár (2):
      PCI: aardvark: Clear all MSIs at setup
      PCI: aardvark: Fix reading MSI interrupt number

Peilin Ye (2):
      ip_gre: Make o_seqno start from 0 in native mode
      ip6_gre: Avoid updating tunnel->tun_hlen in __gre6_xmit()

Pengcheng Yang (1):
      ipvs: correctly print the memory size of ip_vs_conn_tab

Ricky WU (1):
      mmc: rtsx: add 74 Clocks in power on flow

Ronnie Sahlberg (1):
      cifs: destage any unwritten data to the server before calling copychunk_write

Sandipan Das (1):
      kvm: x86/cpuid: Only provide CPUID leaf 0xA if host has architectural PMU

Sergey Shtylyov (1):
      smsc911x: allow using IRQ0

Shravya Kumbham (1):
      net: emaclite: Add error handling for of_address_to_resource()

Slark Xiao (1):
      USB: serial: option: add support for Cinterion MV32-WA/MV32-WB

Takashi Sakamoto (1):
      ALSA: fireworks: fix wrong return count shorter than expected by 4 bytes

Thinh Nguyen (2):
      usb: dwc3: core: Fix tx/rx threshold settings
      usb: dwc3: gadget: Return proper request status

Thomas Pfaff (1):
      genirq: Synchronize interrupt thread startup

Trond Myklebust (1):
      Revert "SUNRPC: attempt AF_LOCAL connect on setup"

Vijayavardhan Vennapusa (1):
      usb: gadget: configfs: clear deactivation flag in configfs_composite_unbind()

Weitao Wang (1):
      USB: Fix xhci event ring dequeue pointer ERDP update issue

Xin Long (1):
      sctp: check asoc strreset_chunk in sctp_generate_reconf_event

Yang Yingliang (2):
      clk: sunxi: sun9i-mmc: check return value after calling platform_get_resource()
      net: stmmac: dwmac-sun8i: add missing of_node_put() in sun8i_dwmac_register_mdio_mux()

Zheyu Ma (2):
      iio: magnetometer: ak8975: Fix the error handling in ak8975_power_on()
      ASoC: wm8731: Disable the regulator when probing fails

Zizhuang Deng (1):
      iio: dac: ad5592r: Fix the missing return value.

