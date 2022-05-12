Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27FDB524B3E
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 13:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiELLQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 07:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353167AbiELLQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 07:16:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2A012AB3;
        Thu, 12 May 2022 04:16:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FC10B82799;
        Thu, 12 May 2022 11:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DF9C385B8;
        Thu, 12 May 2022 11:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652354159;
        bh=MWbEkF9JhCm5bS61843/VGkIqBeDWarPhz6L02YoONg=;
        h=From:To:Cc:Subject:Date:From;
        b=Hn3eoVVW8xoiQAs9emCTmf81tomZbUzvhFobEUJoWZYjHZidknPA9JDHhrSTdHw3W
         +jAY4SY8kNUHctQebY7NOoZWG0KXU1dun9snlVcR58AFjW/v4Ne4Rbkt/fWAK+SwhL
         Ep+aL8cFfjsaDggBv8nIkXxB6zf77St7+rnRMnBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.313
Date:   Thu, 12 May 2022 13:15:55 +0200
Message-Id: <165235415537233@kroah.com>
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

I'm announcing the release of the 4.9.313 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/arm/boot/dts/imx6qdl-apalis.dtsi               |   10 +++-
 arch/arm/boot/dts/omap3-gta04.dtsi                  |    2 
 arch/arm/mach-omap2/omap4-common.c                  |    2 
 arch/mips/include/asm/timex.h                       |    8 +--
 arch/mips/kernel/time.c                             |   11 +----
 arch/parisc/kernel/processor.c                      |    3 -
 arch/x86/include/asm/microcode.h                    |    2 
 arch/x86/kernel/cpu/microcode/core.c                |    6 +-
 arch/x86/kvm/cpuid.c                                |    5 ++
 arch/x86/power/cpu.c                                |    8 +++
 drivers/block/Kconfig                               |   16 +++++++
 drivers/block/floppy.c                              |   43 ++++++++++++++------
 drivers/bus/sunxi-rsb.c                             |    2 
 drivers/clk/sunxi/clk-sun9i-mmc.c                   |    2 
 drivers/firewire/core-card.c                        |    3 +
 drivers/firewire/core-cdev.c                        |    4 +
 drivers/firewire/core-topology.c                    |    9 +---
 drivers/firewire/core-transaction.c                 |   30 +++++++------
 drivers/firewire/sbp2.c                             |   13 +++---
 drivers/hwmon/adt7470.c                             |    4 -
 drivers/iio/dac/ad5446.c                            |    2 
 drivers/iio/dac/ad5592r-base.c                      |    2 
 drivers/iio/magnetometer/ak8975.c                   |    1 
 drivers/lightnvm/Kconfig                            |    2 
 drivers/md/dm.c                                     |   19 +++++---
 drivers/mtd/nand/sh_flctl.c                         |   14 +++---
 drivers/net/can/grcan.c                             |    8 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c    |    9 ++--
 drivers/net/ethernet/smsc/smsc911x.c                |    2 
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c  |    8 +++
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h  |    4 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c |   13 +++---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c       |   15 +++++-
 drivers/net/hippi/rrunner.c                         |    2 
 drivers/nfc/nfcmrvl/main.c                          |    2 
 drivers/phy/phy-exynos5250-sata.c                   |   21 ++++++---
 drivers/pinctrl/pinctrl-pistachio.c                 |    6 +-
 drivers/tty/n_gsm.c                                 |   40 +++++++++---------
 drivers/tty/serial/8250/8250_pci.c                  |    8 +--
 drivers/tty/serial/8250/8250_port.c                 |    2 
 drivers/usb/core/quirks.c                           |    6 ++
 drivers/usb/gadget/configfs.c                       |    2 
 drivers/usb/gadget/function/uvc_queue.c             |    2 
 drivers/usb/host/xhci.c                             |   11 +++++
 drivers/usb/misc/uss720.c                           |    3 -
 drivers/usb/serial/cp210x.c                         |    2 
 drivers/usb/serial/option.c                         |   12 +++++
 drivers/usb/serial/whiteheat.c                      |    5 --
 fs/btrfs/tree-log.c                                 |   14 ++++++
 include/linux/kernel.h                              |    2 
 include/net/tcp.h                                   |    1 
 lib/hexdump.c                                       |   41 ++++++++++++++-----
 net/ipv4/igmp.c                                     |    9 ++--
 net/ipv4/ip_gre.c                                   |    8 +--
 net/ipv4/tcp_input.c                                |   12 +++++
 net/ipv4/tcp_output.c                               |    1 
 net/ipv6/addrconf.c                                 |    8 ++-
 net/nfc/core.c                                      |   29 ++++++-------
 net/nfc/netlink.c                                   |    4 -
 net/sched/cls_api.c                                 |    5 +-
 net/sunrpc/xprtsock.c                               |    3 -
 sound/firewire/fireworks/fireworks_hwdep.c          |    1 
 sound/soc/codecs/wm8731.c                           |   19 +++++---
 sound/soc/codecs/wm8958-dsp2.c                      |    8 +--
 sound/soc/soc-generic-dmaengine-pcm.c               |    6 +-
 66 files changed, 386 insertions(+), 193 deletions(-)

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

Daniele Palmas (1):
      USB: serial: option: add Telit 0x1057, 0x1058, 0x1075 compositions

Duoming Zhou (5):
      drivers: net: hippi: Fix deadlock in rr_close()
      can: grcan: grcan_close(): fix deadlock
      nfc: replace improper check device_is_registered() in netlink related functions
      nfc: nfcmrvl: main: reorder destructive operations in nfcmrvl_nci_unregister_dev to avoid bugs
      NFC: netlink: fix sleep in atomic bug when firmware download timeout

Eric Dumazet (2):
      tcp: fix potential xmit stalls caused by TCP_NOTSENT_LOWAT
      net: igmp: respect RCU rules in ip_mc_source() and ip_mc_msfilter()

Fabio Estevam (1):
      ARM: dts: imx6qdl-apalis: Fix sgtl5000 detection issue

Filipe Manana (1):
      btrfs: always log symlinks in full mode

Greg Kroah-Hartman (3):
      Revert "net: ethernet: stmmac: fix altr_tse_pcs function when using a fixed-link"
      lightnvm: disable the subsystem
      Linux 4.9.313

H. Nikolaus Schaller (1):
      ARM: dts: Fix mmc order for omap3-gta04

Hangyu Hua (1):
      usb: misc: fix improper handling of refcount in uss720_probe()

Helge Deller (1):
      parisc: Merge model and model name into one line in /proc/cpuinfo

Henry Lin (1):
      xhci: stop polling roothubs after shutdown

Jakob Koschel (1):
      firewire: remove check of list iterator against head past the loop body

Jiazi Li (1):
      dm: fix mempool NULL pointer race when completing IO

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

Manish Chopra (1):
      bnx2x: fix napi API usage sequence

Mark Brown (1):
      ASoC: wm8958: Fix change notifications for DSP controls

Miaoqian Lin (3):
      phy: samsung: Fix missing of_node_put() in exynos_sata_phy_probe
      ARM: OMAP2+: Fix refcount leak in omap_gic_of_init
      mtd: rawnand: Fix return value check of wait_for_completion_timeout

Michael Hennerich (1):
      iio: dac: ad5446: Fix read_raw not returning set value

Mike Snitzer (1):
      dm: interlock pending dm_io and dm_wait_for_bios_completion

Mikulas Patocka (2):
      hex2bin: make the function hex_to_bin constant-time
      hex2bin: fix access beyond string end

Niels Dossche (1):
      firewire: core: extend card->lock in fw_core_handle_bus_reset

Oliver Neukum (2):
      USB: quirks: add a Realtek card reader
      USB: quirks: add STRING quirk for VCOM device

Peilin Ye (1):
      ip_gre: Make o_seqno start from 0 in native mode

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

Thadeu Lima de Souza Cascardo (1):
      net: sched: prevent UAF on tc_ctl_tfilter when temporarily dropping rtnl_lock

Trond Myklebust (1):
      Revert "SUNRPC: attempt AF_LOCAL connect on setup"

Vijayavardhan Vennapusa (1):
      usb: gadget: configfs: clear deactivation flag in configfs_composite_unbind()

Willy Tarreau (1):
      floppy: disable FDRAWCMD by default

Yang Yingliang (1):
      clk: sunxi: sun9i-mmc: check return value after calling platform_get_resource()

Zheyu Ma (2):
      iio: magnetometer: ak8975: Fix the error handling in ak8975_power_on()
      ASoC: wm8731: Disable the regulator when probing fails

Zizhuang Deng (1):
      iio: dac: ad5592r: Fix the missing return value.

j.nixdorf@avm.de (1):
      net: ipv6: ensure we call ipv6_mc_down() at most once

