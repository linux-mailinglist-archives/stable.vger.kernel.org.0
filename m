Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D36857D3D5
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 21:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbiGUTJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 15:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233282AbiGUTI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 15:08:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1C78CC88;
        Thu, 21 Jul 2022 12:08:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6BFDB82646;
        Thu, 21 Jul 2022 19:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F359C3411E;
        Thu, 21 Jul 2022 19:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658430528;
        bh=lUSoiepDe6yfSAfQk4v3c+lkhGjXMdx6PovesbQF07k=;
        h=From:To:Cc:Subject:Date:From;
        b=WOFo8zbLYMy/j8LALJQAM5HYw/pzOYzDUQjGJAEJBAIr84oI9FSIKo+tbukv/eqez
         NeMe9RkG3nzBIlPEyXA4WSBgu+57OJ4c+rR1YBcOKpFYpVHV/s3mtU+okOinbKgs8F
         Ol9P6G1b7IvgkJNFIyP7em860DEky1hByjvoGuH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.289
Date:   Thu, 21 Jul 2022 21:08:13 +0200
Message-Id: <165843049358168@kroah.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.289 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/ip-sysctl.txt            |    4 +-
 Makefile                                          |    2 -
 arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts |    2 -
 arch/arm/include/asm/ptrace.h                     |   26 +++++++++++++++
 arch/arm/mm/alignment.c                           |    3 +
 arch/arm/mm/proc-v7-bugs.c                        |    9 ++---
 arch/arm/probes/decode.h                          |   26 ---------------
 arch/x86/kernel/head64.c                          |    2 +
 drivers/cpufreq/pmac32-cpufreq.c                  |    4 ++
 drivers/irqchip/irq-or1k-pic.c                    |    1 
 drivers/net/can/m_can/m_can.c                     |    5 +-
 drivers/net/dsa/bcm_sf2.c                         |   19 +++++++++++
 drivers/net/ethernet/sfc/ef10.c                   |    3 +
 drivers/net/ethernet/sfc/ef10_sriov.c             |   10 ++++-
 drivers/net/phy/sfp.c                             |    2 -
 drivers/net/xen-netback/rx.c                      |    1 
 drivers/nfc/nxp-nci/i2c.c                         |    8 +++-
 drivers/platform/x86/hp-wmi.c                     |    3 +
 drivers/tty/serial/8250/8250_port.c               |    4 +-
 drivers/tty/serial/samsung.c                      |    5 +-
 drivers/usb/dwc3/gadget.c                         |    4 +-
 drivers/usb/host/xhci-hub.c                       |    2 -
 drivers/usb/host/xhci-mem.c                       |    2 -
 drivers/usb/host/xhci.c                           |   22 ++++++-------
 drivers/usb/host/xhci.h                           |    7 ++--
 drivers/usb/serial/ftdi_sio.c                     |    3 +
 drivers/usb/serial/ftdi_sio_ids.h                 |    6 +++
 drivers/virtio/virtio_mmio.c                      |   26 +++++++++++++++
 fs/nilfs2/nilfs.h                                 |    3 +
 include/linux/cgroup-defs.h                       |    3 +
 include/net/sock.h                                |    2 -
 include/trace/events/sock.h                       |    6 ++-
 kernel/cgroup/cgroup.c                            |   37 +++++++++++++---------
 kernel/signal.c                                   |    8 ++--
 mm/memory.c                                       |    9 ++++-
 net/bridge/br_netfilter_hooks.c                   |   21 ++++++++++--
 net/ipv4/af_inet.c                                |    4 +-
 net/ipv4/cipso_ipv4.c                             |   12 ++++---
 net/ipv4/icmp.c                                   |   10 +++--
 net/ipv4/inetpeer.c                               |   12 ++++---
 net/ipv6/seg6_iptunnel.c                          |    5 ++
 net/ipv6/seg6_local.c                             |    2 -
 net/tipc/socket.c                                 |    1 
 sound/pci/hda/patch_conexant.c                    |    1 
 sound/pci/hda/patch_realtek.c                     |    1 
 sound/soc/codecs/wm5110.c                         |    8 +++-
 sound/soc/soc-ops.c                               |    4 +-
 47 files changed, 248 insertions(+), 112 deletions(-)

Andrea Mayer (2):
      seg6: fix skb checksum evaluation in SRH encapsulation/insertion
      seg6: fix skb checksum in SRv6 End.B6 and End.B6.Encaps behaviors

Ard Biesheuvel (2):
      ARM: 9214/1: alignment: advance IT state after emulating Thumb instruction
      ARM: 9209/1: Spectre-BHB: avoid pr_info() every time a CPU comes out of idle

Chanho Park (1):
      tty: serial: samsung_tty: set dma burst_size to 1

Charles Keepax (1):
      ASoC: wm5110: Fix DRE control

Dmitry Osipenko (1):
      ARM: 9213/1: Print message about disabled Spectre workarounds only once

Doug Berger (1):
      net: dsa: bcm_sf2: force pause link settings

Florian Westphal (1):
      netfilter: br_netfilter: do not skip all hooks with 0 priority

Greg Kroah-Hartman (1):
      Linux 4.14.289

Hangyu Hua (1):
      net: tipc: fix possible refcount leak in tipc_sk_create()

Jianglei Nie (1):
      net: sfp: fix memory leak in sfp_probe()

Juergen Gross (2):
      xen/netback: avoid entering xenvif_rx_next_skb() with an empty rx queue
      x86: Clear .brk area at early boot

Kai-Heng Feng (1):
      platform/x86: hp-wmi: Ignore Sanitization Mode event

Kuniyuki Iwashima (7):
      inetpeer: Fix data-races around sysctl.
      net: Fix data-races around sysctl_mem.
      cipso: Fix data-races around sysctl.
      icmp: Fix data-races around sysctl.
      icmp: Fix a data-race around sysctl_icmp_ratelimit.
      icmp: Fix a data-race around sysctl_icmp_ratemask.
      ipv4: Fix data-races around sysctl_ip_dynaddr.

Liang He (1):
      cpufreq: pmac32-cpufreq: Fix refcount leak bug

Linus Torvalds (1):
      signal handling: don't use BUG_ON() for debugging

Lucien Buchmann (1):
      USB: serial: ftdi_sio: add Belimo device ids

Marc Kleine-Budde (1):
      can: m_can: m_can_tx_handler(): fix use after free of skb

Mark Brown (1):
      ASoC: ops: Fix off by one in range control validation

Mathias Nyman (2):
      xhci: bail out early if driver can't accress host in resume
      xhci: make xhci_handshake timeout for xhci_reset() adjustable

Meng Tang (2):
      ALSA: hda - Add fixup for Dell Latitidue E5430
      ALSA: hda/conexant: Apply quirk for another HP ProDesk 600 G3 model

Michael Walle (1):
      NFC: nxp-nci: don't print header length mismatch on i2c error

Michal Suchanek (1):
      ARM: dts: sunxi: Fix SPI NOR campatible on Orange Pi Zero

Rik van Riel (1):
      mm: invalidate hwpoison page cache page in fault path

Ryusuke Konishi (1):
      nilfs2: fix incorrect masking of permission flags for symlinks

Stafford Horne (1):
      irqchip: or1k-pic: Undefine mask_ack for level triggered hardware

Stephan Gerhold (2):
      virtio_mmio: Add missing PM calls to freeze/restore
      virtio_mmio: Restore guest page size on resume

Steven Rostedt (Google) (1):
      net: sock: tracing: Fix sock_exceed_buf_limit not to dereference stale pointer

Tejun Heo (1):
      cgroup: Use separate src/dst nodes when preloading css_sets for migration

Thinh Nguyen (1):
      usb: dwc3: gadget: Fix event pending check

Yi Yang (1):
      serial: 8250: fix return error code in serial8250_request_std_resource()

Íñigo Huguet (2):
      sfc: fix use after free when disabling sriov
      sfc: fix kernel panic when creating VF

