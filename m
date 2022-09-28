Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E715EDA6B
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 12:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbiI1Kto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 06:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbiI1Kt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 06:49:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55020B0884;
        Wed, 28 Sep 2022 03:49:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEAED61E1A;
        Wed, 28 Sep 2022 10:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9775C433B5;
        Wed, 28 Sep 2022 10:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664362165;
        bh=2/KljbLUFKid/an+MSdLaL5C48iyENzn//TLktQ78ns=;
        h=From:To:Cc:Subject:Date:From;
        b=xjRhMDzBfmcC3ibTPj9X9lpFtE9wDllAGBDywqmru5HttBQr1Z03k5a7+AI5YrGZv
         d/svYqxASWdk1GlpX2pk3UECXmAcWSgv8R4NJl4VagKCX+Gb3cAwHO0euDZAcUfQDe
         9w/W9V81yzQ7O+eHEZo9l2WjqN3hXXui8+hWh9pc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.260
Date:   Wed, 28 Sep 2022 12:49:12 +0200
Message-Id: <16643621521736@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.260 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi |    8 +++
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi           |    1 
 arch/mips/cavium-octeon/octeon-irq.c                    |   10 ++++
 arch/mips/lantiq/clk.c                                  |    1 
 drivers/firmware/efi/libstub/secureboot.c               |    8 +--
 drivers/gpio/gpio-mpc8xxx.c                             |    1 
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c |    4 +
 drivers/gpu/drm/meson/meson_plane.c                     |    2 
 drivers/gpu/drm/rockchip/cdn-dp-core.c                  |    5 +-
 drivers/hv/vmbus_drv.c                                  |   10 ++++
 drivers/net/can/usb/gs_usb.c                            |    4 -
 drivers/net/ethernet/intel/i40e/i40e_main.c             |   32 ++++++++++++---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c      |   20 +++++++++
 drivers/net/ethernet/intel/i40evf/i40e_txrx.c           |    5 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c      |   19 --------
 drivers/net/ethernet/sun/sunhme.c                       |    4 -
 drivers/net/ipvlan/ipvlan_core.c                        |    6 +-
 drivers/net/team/team.c                                 |   24 ++++++++---
 drivers/net/usb/qmi_wwan.c                              |    1 
 drivers/nvme/target/core.c                              |    5 +-
 drivers/of/fdt.c                                        |    2 
 drivers/of/of_mdio.c                                    |    1 
 drivers/parisc/ccio-dma.c                               |    1 
 drivers/regulator/pfuze100-regulator.c                  |    2 
 drivers/s390/block/dasd_alias.c                         |    9 +++-
 drivers/tty/serial/serial-tegra.c                       |    5 --
 drivers/usb/core/hub.c                                  |    2 
 drivers/usb/dwc3/dwc3-pci.c                             |   23 ++++++++++
 drivers/usb/serial/option.c                             |    6 ++
 drivers/video/fbdev/pxa3xx-gcu.c                        |    2 
 fs/cifs/transport.c                                     |    4 -
 fs/ext4/ialloc.c                                        |    2 
 include/linux/serial_core.h                             |   17 ++++++++
 kernel/workqueue.c                                      |    6 --
 mm/slub.c                                               |    5 +-
 net/bridge/netfilter/ebtables.c                         |    4 +
 net/mac80211/scan.c                                     |   11 +++--
 net/netfilter/nf_conntrack_irc.c                        |   34 +++++++++++++---
 net/netfilter/nf_conntrack_sip.c                        |    4 -
 net/rxrpc/local_object.c                                |    3 +
 scripts/mksysmap                                        |    2 
 sound/pci/hda/hda_intel.c                               |    2 
 sound/pci/hda/patch_hdmi.c                              |    1 
 sound/pci/hda/patch_realtek.c                           |    1 
 sound/pci/hda/patch_sigmatel.c                          |   24 +++++++++++
 sound/soc/codecs/nau8824.c                              |   17 ++++----
 tools/perf/util/genelf.c                                |   14 ++++++
 tools/perf/util/genelf.h                                |    4 +
 tools/perf/util/symbol-elf.c                            |    7 ---
 50 files changed, 294 insertions(+), 93 deletions(-)

Adrian Hunter (1):
      perf kcore_copy: Do not check /proc/modules is unchanged

Alan Stern (1):
      USB: core: Fix RST error in hub.c

Alexander Sverdlin (1):
      MIPS: OCTEON: irq: Fix octeon_irq_force_ciu_mapping()

Ard Biesheuvel (1):
      efi: libstub: check Shim mode using MokSBStateRT

Bart Van Assche (1):
      nvmet: fix a use-after-free

Benjamin Poirier (1):
      net: team: Unsync device addresses on ndo_stop

Brett Creeley (1):
      iavf: Fix cached head and tail value for iavf_get_tx_pending

Callum Osmotherly (1):
      ALSA: hda/realtek: Enable 4-speaker output Dell Precision 5530 laptop

Carl Yin(殷张成) (1):
      USB: serial: option: add Quectel BG95 0x0203 composition

Chao Yu (1):
      mm/slub: fix to return errno if kmalloc() fails

David Howells (1):
      rxrpc: Fix local destruction being repeated

David Leadbeater (1):
      netfilter: nf_conntrack_irc: Tighten matching on DCC message

Fabio Estevam (1):
      arm64: dts: rockchip: Remove 'enable-active-low' from rk3399-puma

Felipe Balbi (2):
      usb: dwc3: pci: Add Support for Intel Elkhart Lake Devices
      usb: dwc3: pci: add support for TigerLake Devices

Florian Westphal (1):
      netfilter: ebtables: fix memory leak when blob is malformed

Greg Kroah-Hartman (2):
      mvpp2: no need to check return value of debugfs_create functions
      Linux 4.19.260

Heikki Krogerus (3):
      usb: dwc3: pci: add support for the Intel Tiger Lake PCH -H variant
      usb: dwc3: pci: add support for the Intel Jasper Lake
      usb: dwc3: pci: add support for the Intel Alder Lake-S

Hyunwoo Kim (1):
      video: fbdev: pxa3xx-gcu: Fix integer overflow in pxa3xx_gcu_write

Igor Ryzhov (1):
      netfilter: nf_conntrack_sip: fix ct_sip_walk_headers

Ilpo Järvinen (2):
      serial: Create uart_xmit_advance()
      serial: tegra: Use uart_xmit_advance(), fixes icount.tx accounting

Jan Kara (1):
      ext4: make directory inode spreading reflect flexbg size

Kai Vehmanen (1):
      ALSA: hda: add Intel 5 Series / 3400 PCI DID

Liang He (1):
      of: mdio: Add of_node_put() when breaking out of for_each_xx

Lieven Hey (1):
      perf jit: Include program header in ELF files

Lu Wei (1):
      ipvlan: Fix out-of-bound bugs caused by unset skb->mac_header

Marc Kleine-Budde (1):
      can: gs_usb: gs_can_open(): fix race dev->can.state condition

Michal Jaron (2):
      i40e: Fix VF set max MTU size
      i40e: Fix set max_tx_rate when it is lower than 1 Mbps

Mohan Kumar (1):
      ALSA: hda/tegra: set depop delay for tegra

Nathan Huckleberry (1):
      drm/rockchip: Fix return type of cdn_dp_connector_mode_valid

Pali Rohár (1):
      gpio: mpc8xxx: Fix support for IRQ_TYPE_LEVEL_LOW flow_type in mpc85xx

Randy Dunlap (1):
      MIPS: lantiq: export clk_get_io() for lantiq_wdt.ko

Raymond Tan (1):
      usb: dwc3: pci: Allow Elkhart Lake to utilize DSM method for PM functionality

Sean Anderson (1):
      net: sunhme: Fix packet reception for len < RX_COPY_THRESHOLD

Sergey Shtylyov (1):
      of: fdt: fix off-by-one error in unflatten_dt_nodes()

Siddh Raman Pant (1):
      wifi: mac80211: Fix UAF in ieee80211_scan_rx()

Stefan Haberland (1):
      s390/dasd: fix Oops in dasd_alias_get_start_dev due to missing pavgroup

Stefan Metzmacher (1):
      cifs: don't send down the destination address to sendmsg for a SOCK_STREAM

Stuart Menefy (1):
      drm/meson: Correct OSD1 global alpha value

Takashi Iwai (3):
      ASoC: nau8824: Fix semaphore unbalance at error paths
      ALSA: hda/sigmatel: Keep power up while beep is enabled
      ALSA: hda/sigmatel: Fix unused variable warning for beep power change

Tetsuo Handa (1):
      workqueue: don't skip lockdep work dependency in cancel_work_sync()

Vitaly Kuznetsov (1):
      Drivers: hv: Never allocate anything besides framebuffer from framebuffer memory region

Xiaolei Wang (1):
      regulator: pfuze100: Fix the global-out-of-bounds access in pfuze100_regulator_probe()

Yang Yingliang (1):
      parisc: ccio-dma: Add missing iounmap in error path in ccio_probe()

Yao Wang1 (1):
      drm/amd/display: Limit user regamma to a valid value

Youling Tang (1):
      mksysmap: Fix the mismatch of 'L0' symbols in System.map

jerry meng (1):
      USB: serial: option: add Quectel RM520N

jerry.meng (1):
      net: usb: qmi_wwan: add Quectel RM520N

zain wang (1):
      arm64: dts: rockchip: Set RK3399-Gru PCLK_EDP to 24 MHz

