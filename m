Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B588757D3D0
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 21:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbiGUTIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 15:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGUTIl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 15:08:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A9E87F7A;
        Thu, 21 Jul 2022 12:08:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36CA2B8263F;
        Thu, 21 Jul 2022 19:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62797C3411E;
        Thu, 21 Jul 2022 19:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658430515;
        bh=jAABsnsUu936rsygMzUfR1bXnqLT/fnxnueSIeH0GF0=;
        h=From:To:Cc:Subject:Date:From;
        b=i4B+98c9I1krtjXrVyck/f38Bu1BxW96c7UHXVpnoJR/WwwV32Np/xd+0wqasSCQf
         FatMqrd5At7ak32zBSrb8wuo0GmCdvbYQGgQpXO6fLLsHMlXfsY6JWv75b/oVR3dw6
         LYxhi2PjiwPXHX51y4+8E0HOjSyJZoEwshB0/Fl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.324
Date:   Thu, 21 Jul 2022 21:08:07 +0200
Message-Id: <1658430488197171@kroah.com>
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

I'm announcing the release of the 4.9.324 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/ip-sysctl.txt |    4 ++--
 Makefile                               |    2 +-
 arch/arm/mm/proc-v7-bugs.c             |    9 ++++-----
 arch/arm64/kernel/entry.S              |    1 +
 arch/x86/kernel/head64.c               |    2 ++
 drivers/cpufreq/pmac32-cpufreq.c       |    4 ++++
 drivers/net/can/m_can/m_can.c          |    5 +++--
 drivers/net/dsa/bcm_sf2.c              |   19 +++++++++++++++++++
 drivers/net/ethernet/sfc/ef10.c        |    3 +++
 drivers/net/ethernet/sfc/ef10_sriov.c  |   10 +++++++---
 drivers/net/xen-netback/rx.c           |    1 +
 drivers/nfc/nxp-nci/i2c.c              |    8 ++++++--
 drivers/tty/serial/8250/8250_port.c    |    4 +++-
 drivers/tty/serial/samsung.c           |    5 ++---
 drivers/usb/dwc3/gadget.c              |    4 +++-
 drivers/usb/serial/ftdi_sio.c          |    3 +++
 drivers/usb/serial/ftdi_sio_ids.h      |    6 ++++++
 drivers/virtio/virtio_mmio.c           |   26 ++++++++++++++++++++++++++
 fs/nilfs2/nilfs.h                      |    3 +++
 include/trace/events/sock.h            |    6 ++++--
 kernel/signal.c                        |    8 ++++----
 mm/memory.c                            |    9 +++++++--
 net/ipv4/af_inet.c                     |    4 ++--
 net/ipv4/cipso_ipv4.c                  |   12 +++++++-----
 net/ipv4/icmp.c                        |    5 +++--
 net/tipc/socket.c                      |    1 +
 sound/pci/hda/patch_realtek.c          |    1 +
 sound/soc/codecs/wm5110.c              |    8 ++++++--
 sound/soc/soc-ops.c                    |    4 ++--
 29 files changed, 136 insertions(+), 41 deletions(-)

Ard Biesheuvel (1):
      ARM: 9209/1: Spectre-BHB: avoid pr_info() every time a CPU comes out of idle

Chanho Park (1):
      tty: serial: samsung_tty: set dma burst_size to 1

Charles Keepax (1):
      ASoC: wm5110: Fix DRE control

Dmitry Osipenko (1):
      ARM: 9213/1: Print message about disabled Spectre workarounds only once

Doug Berger (1):
      net: dsa: bcm_sf2: force pause link settings

Greg Kroah-Hartman (1):
      Linux 4.9.324

Hangyu Hua (1):
      net: tipc: fix possible refcount leak in tipc_sk_create()

James Morse (1):
      arm64: entry: Restore tramp_map_kernel ISB

Juergen Gross (2):
      xen/netback: avoid entering xenvif_rx_next_skb() with an empty rx queue
      x86: Clear .brk area at early boot

Kuniyuki Iwashima (3):
      cipso: Fix data-races around sysctl.
      icmp: Fix data-races around sysctl.
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

Meng Tang (1):
      ALSA: hda - Add fixup for Dell Latitidue E5430

Michael Walle (1):
      NFC: nxp-nci: don't print header length mismatch on i2c error

Rik van Riel (1):
      mm: invalidate hwpoison page cache page in fault path

Ryusuke Konishi (1):
      nilfs2: fix incorrect masking of permission flags for symlinks

Stephan Gerhold (2):
      virtio_mmio: Add missing PM calls to freeze/restore
      virtio_mmio: Restore guest page size on resume

Steven Rostedt (Google) (1):
      net: sock: tracing: Fix sock_exceed_buf_limit not to dereference stale pointer

Thinh Nguyen (1):
      usb: dwc3: gadget: Fix event pending check

Yi Yang (1):
      serial: 8250: fix return error code in serial8250_request_std_resource()

Íñigo Huguet (2):
      sfc: fix use after free when disabling sriov
      sfc: fix kernel panic when creating VF

