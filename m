Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58765EDA64
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 12:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbiI1KtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 06:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbiI1KtU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 06:49:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D37B24A3;
        Wed, 28 Sep 2022 03:49:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 885ACB82027;
        Wed, 28 Sep 2022 10:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D752EC433D6;
        Wed, 28 Sep 2022 10:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664362154;
        bh=lz5UvwmVEyBVk9iIvx4vXgJgToZj2gscHPmFUc6TeVc=;
        h=From:To:Cc:Subject:Date:From;
        b=AuQG/4tXX3v9Z74KtbICtusjM9+gq6cBcTJAC57L7badogFHkpN8vW61M6NMjMjZr
         Po6N05GHHcAZuG198B7YbaB6YDhedc21TAFR+d5bIuY2gqm6YhDhLHNDFYxq5wXjZs
         aSTd4EKqP5iYXlb34tsjsXsvv5KEwHFWMEGpmDig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.295
Date:   Wed, 28 Sep 2022 12:49:07 +0200
Message-Id: <16643621474389@kroah.com>
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

I'm announcing the release of the 4.14.295 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                      |    2 -
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi |    1 
 arch/mips/cavium-octeon/octeon-irq.c          |   10 +++++++
 arch/mips/lantiq/clk.c                        |    1 
 drivers/gpio/gpio-mpc8xxx.c                   |    1 
 drivers/gpu/drm/meson/meson_plane.c           |    2 -
 drivers/hv/vmbus_drv.c                        |   10 ++++++-
 drivers/media/usb/em28xx/em28xx-cards.c       |    4 +--
 drivers/net/can/usb/gs_usb.c                  |    4 +--
 drivers/net/ethernet/intel/i40evf/i40e_txrx.c |    5 +++
 drivers/net/ethernet/sun/sunhme.c             |    4 +--
 drivers/net/ipvlan/ipvlan_core.c              |    6 +++-
 drivers/net/team/team.c                       |   24 +++++++++++++-----
 drivers/net/usb/qmi_wwan.c                    |    1 
 drivers/of/fdt.c                              |    2 -
 drivers/of/of_mdio.c                          |    1 
 drivers/parisc/ccio-dma.c                     |    1 
 drivers/regulator/pfuze100-regulator.c        |    2 -
 drivers/s390/block/dasd_alias.c               |    9 +++++-
 drivers/tty/serial/serial-tegra.c             |    5 +--
 drivers/usb/core/hub.c                        |    2 -
 drivers/usb/serial/option.c                   |    6 ++++
 drivers/video/fbdev/pxa3xx-gcu.c              |    2 -
 fs/cifs/transport.c                           |    4 +--
 fs/ext4/ialloc.c                              |    2 -
 include/linux/serial_core.h                   |   17 +++++++++++++
 mm/slub.c                                     |    5 +++
 net/bridge/netfilter/ebtables.c               |    4 ++-
 net/mac80211/scan.c                           |   11 +++++---
 net/netfilter/nf_conntrack_irc.c              |   34 +++++++++++++++++++++-----
 net/netfilter/nf_conntrack_sip.c              |    4 +--
 scripts/mksysmap                              |    2 -
 sound/pci/hda/hda_intel.c                     |    2 +
 sound/pci/hda/patch_hdmi.c                    |    1 
 sound/pci/hda/patch_sigmatel.c                |   24 ++++++++++++++++++
 sound/soc/codecs/nau8824.c                    |   17 +++++++------
 tools/perf/util/symbol-elf.c                  |    7 +----
 37 files changed, 181 insertions(+), 58 deletions(-)

Adrian Hunter (1):
      perf kcore_copy: Do not check /proc/modules is unchanged

Alan Stern (1):
      USB: core: Fix RST error in hub.c

Alexander Sverdlin (1):
      MIPS: OCTEON: irq: Fix octeon_irq_force_ciu_mapping()

Benjamin Poirier (1):
      net: team: Unsync device addresses on ndo_stop

Brett Creeley (1):
      iavf: Fix cached head and tail value for iavf_get_tx_pending

Carl Yin(殷张成) (1):
      USB: serial: option: add Quectel BG95 0x0203 composition

Chao Yu (1):
      mm/slub: fix to return errno if kmalloc() fails

David Leadbeater (1):
      netfilter: nf_conntrack_irc: Tighten matching on DCC message

Dongliang Mu (1):
      media: em28xx: initialize refcount before kref_get

Fabio Estevam (1):
      arm64: dts: rockchip: Remove 'enable-active-low' from rk3399-puma

Florian Westphal (1):
      netfilter: ebtables: fix memory leak when blob is malformed

Greg Kroah-Hartman (1):
      Linux 4.14.295

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

Lu Wei (1):
      ipvlan: Fix out-of-bound bugs caused by unset skb->mac_header

Marc Kleine-Budde (1):
      can: gs_usb: gs_can_open(): fix race dev->can.state condition

Mohan Kumar (1):
      ALSA: hda/tegra: set depop delay for tegra

Pali Rohár (1):
      gpio: mpc8xxx: Fix support for IRQ_TYPE_LEVEL_LOW flow_type in mpc85xx

Randy Dunlap (1):
      MIPS: lantiq: export clk_get_io() for lantiq_wdt.ko

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

Vitaly Kuznetsov (1):
      Drivers: hv: Never allocate anything besides framebuffer from framebuffer memory region

Xiaolei Wang (1):
      regulator: pfuze100: Fix the global-out-of-bounds access in pfuze100_regulator_probe()

Yang Yingliang (1):
      parisc: ccio-dma: Add missing iounmap in error path in ccio_probe()

Youling Tang (1):
      mksysmap: Fix the mismatch of 'L0' symbols in System.map

jerry meng (1):
      USB: serial: option: add Quectel RM520N

jerry.meng (1):
      net: usb: qmi_wwan: add Quectel RM520N

