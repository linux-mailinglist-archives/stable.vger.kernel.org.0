Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2B1585253
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 17:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236429AbiG2PVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 11:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237336AbiG2PVD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 11:21:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E0183F21;
        Fri, 29 Jul 2022 08:20:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E428761C1D;
        Fri, 29 Jul 2022 15:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD8FC433D6;
        Fri, 29 Jul 2022 15:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659108050;
        bh=7nfK78goH26HqmvO0NW5KkE6ojbgGgFVAf51Cgqvpds=;
        h=From:To:Cc:Subject:Date:From;
        b=b40/AjPZuDnsCBWHFIHThFKzODrld4hwnGUxh0JYRSf7I8+7KiWYO2OfSj4kqrFn/
         4PQNJAmpm4GX9NoFOqjiOugMpg2FZaV3E9Q3QWTRtgf6SvWiokqDuNy23zD8apqJRV
         Cljjtmzy4+T4sBiAyfhJEIb52Y0VlTURwlb72xfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.254
Date:   Fri, 29 Jul 2022 17:20:31 +0200
Message-Id: <165910803220811@kroah.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.254 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/alpha/kernel/srmcons.c                       |    2 
 arch/riscv/Makefile                               |    1 
 drivers/char/random.c                             |    4 
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c              |   28 ++---
 drivers/gpu/drm/tilcdc/tilcdc_drv.c               |    1 
 drivers/gpu/drm/tilcdc/tilcdc_drv.h               |    2 
 drivers/gpu/drm/tilcdc/tilcdc_external.c          |   96 ++----------------
 drivers/gpu/drm/tilcdc/tilcdc_external.h          |    1 
 drivers/gpu/drm/tilcdc/tilcdc_panel.c             |    9 -
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c            |    9 -
 drivers/hid/hid-ids.h                             |    2 
 drivers/hid/hid-multitouch.c                      |  112 ++++++++++++----------
 drivers/hid/hid-quirks.c                          |    1 
 drivers/i2c/busses/i2c-cadence.c                  |   30 -----
 drivers/net/ethernet/emulex/benet/be_cmds.c       |   10 -
 drivers/net/ethernet/emulex/benet/be_cmds.h       |    2 
 drivers/net/ethernet/emulex/benet/be_ethtool.c    |   31 +++---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |    3 
 drivers/net/usb/ax88179_178a.c                    |   16 +--
 drivers/pci/controller/pci-hyperv.c               |  100 ++++++++++++++++---
 drivers/power/reset/arm-versatile-reboot.c        |    1 
 drivers/s390/char/keyboard.h                      |    4 
 drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c   |    2 
 drivers/staging/speakup/spk_ttyio.c               |    4 
 drivers/tty/cyclades.c                            |    6 -
 drivers/tty/goldfish.c                            |    2 
 drivers/tty/moxa.c                                |    4 
 drivers/tty/pty.c                                 |   14 --
 drivers/tty/serial/lpc32xx_hs.c                   |    2 
 drivers/tty/serial/mvebu-uart.c                   |   25 ++--
 drivers/tty/tty_buffer.c                          |   66 ++++++++----
 drivers/tty/vt/keyboard.c                         |    6 -
 drivers/tty/vt/vt.c                               |    2 
 drivers/xen/gntdev.c                              |    3 
 fs/dlm/lock.c                                     |    3 
 include/linux/tty_flip.h                          |    4 
 include/net/bluetooth/bluetooth.h                 |   65 ++++++++++++
 include/net/inet_sock.h                           |    5 
 include/net/ip.h                                  |    4 
 include/net/tcp.h                                 |    9 -
 kernel/bpf/core.c                                 |    8 -
 kernel/events/core.c                              |   45 ++++++--
 mm/mempolicy.c                                    |    2 
 net/bluetooth/rfcomm/core.c                       |   50 ++++++++-
 net/bluetooth/rfcomm/sock.c                       |   46 +--------
 net/bluetooth/sco.c                               |   30 +----
 net/ipv4/af_inet.c                                |    2 
 net/ipv4/igmp.c                                   |   23 ++--
 net/ipv4/route.c                                  |    2 
 net/ipv4/tcp.c                                    |   10 +
 net/ipv4/tcp_fastopen.c                           |    4 
 net/ipv4/tcp_input.c                              |   19 ++-
 net/ipv4/tcp_ipv4.c                               |    2 
 net/ipv4/tcp_metrics.c                            |    3 
 net/ipv4/tcp_minisocks.c                          |    2 
 net/ipv4/tcp_output.c                             |   14 +-
 net/ipv4/tcp_recovery.c                           |    6 -
 net/ipv4/tcp_timer.c                              |   14 +-
 net/sctp/protocol.c                               |    2 
 net/tls/tls_device.c                              |    8 -
 net/xfrm/xfrm_policy.c                            |    5 
 security/integrity/ima/Kconfig                    |   12 --
 sound/core/memalloc.c                             |    1 
 64 files changed, 554 insertions(+), 449 deletions(-)

Alexander Aring (1):
      dlm: fix pending remove if msg allocation fails

Ben Dooks (1):
      riscv: add as-options for modules with assembly compontents

Benjamin Tissoires (2):
      HID: multitouch: simplify the application retrieval
      HID: multitouch: add support for the Smart Tech panel

Demi Marie Obenour (1):
      xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE

Eric Dumazet (1):
      bpf: Make sure mac_header was set before using it

GUO Zihua (1):
      ima: remove the IMA_TEMPLATE Kconfig option

Greg Kroah-Hartman (1):
      Linux 4.19.254

Hangyu Hua (1):
      xfrm: xfrm_policy: fix a possible double xfrm_pols_put() in xfrm_bundle_lookup()

Hristo Venev (1):
      be2net: Fix buffer overflow in be_get_module_eeprom

Jason A. Donenfeld (1):
      Revert "Revert "char/random: silence a lockdep splat with printk()""

Jeffrey Hugo (4):
      PCI: hv: Fix multi-MSI to allow more than one MSI vector
      PCI: hv: Fix hv_arch_irq_unmask() for multi-MSI
      PCI: hv: Reuse existing IRTE allocation in compose_msi_msg()
      PCI: hv: Fix interrupt mapping for multi-MSI

Jiri Slaby (5):
      tty: drivers/tty/, stop using tty_schedule_flip()
      tty: the rest, stop using tty_schedule_flip()
      tty: drop tty_schedule_flip()
      tty: extract tty_flip_buffer_commit() from tty_flip_buffer_push()
      tty: use new tty_insert_flip_string_and_push_buffer() in pty_write()

Jose Alonso (1):
      net: usb: ax88179_178a needs FLAG_SEND_ZLP

Junxiao Chang (1):
      net: stmmac: fix dma queue left shift overflow issue

Jyri Sarha (1):
      drm/tilcdc: Remove obsolete crtc_mode_valid() hack

Kuniyuki Iwashima (22):
      ip: Fix data-races around sysctl_ip_fwd_use_pmtu.
      ip: Fix data-races around sysctl_ip_nonlocal_bind.
      ip: Fix a data-race around sysctl_fwmark_reflect.
      tcp/dccp: Fix a data-race around sysctl_tcp_fwmark_accept.
      tcp: Fix data-races around sysctl_tcp_mtu_probing.
      tcp: Fix a data-race around sysctl_tcp_probe_threshold.
      tcp: Fix a data-race around sysctl_tcp_probe_interval.
      igmp: Fix data-races around sysctl_igmp_llm_reports.
      igmp: Fix a data-race around sysctl_igmp_max_memberships.
      tcp: Fix data-races around sysctl_tcp_reordering.
      tcp: Fix data-races around some timeout sysctl knobs.
      tcp: Fix a data-race around sysctl_tcp_notsent_lowat.
      tcp: Fix a data-race around sysctl_tcp_tw_reuse.
      tcp: Fix data-races around sysctl_tcp_fastopen.
      tcp: Fix a data-race around sysctl_tcp_early_retrans.
      tcp: Fix data-races around sysctl_tcp_recovery.
      tcp: Fix a data-race around sysctl_tcp_thin_linear_timeouts.
      tcp: Fix data-races around sysctl_tcp_slow_start_after_idle.
      tcp: Fix a data-race around sysctl_tcp_retrans_collapse.
      tcp: Fix a data-race around sysctl_tcp_stdurg.
      tcp: Fix a data-race around sysctl_tcp_rfc1337.
      tcp: Fix data-races around sysctl_tcp_max_reordering.

Luiz Augusto von Dentz (7):
      Bluetooth: Add bt_skb_sendmsg helper
      Bluetooth: Add bt_skb_sendmmsg helper
      Bluetooth: SCO: Replace use of memcpy_from_msg with bt_skb_sendmsg
      Bluetooth: RFCOMM: Replace use of memcpy_from_msg with bt_skb_sendmmsg
      Bluetooth: Fix passing NULL to PTR_ERR
      Bluetooth: SCO: Fix sco_send_frame returning skb->len
      Bluetooth: Fix bt_skb_sendmmsg not allocating partial chunks

Miaoqian Lin (1):
      power/reset: arm-versatile: Fix refcount leak in versatile_reboot_probe

Mikael Wikström (1):
      HID: multitouch: Lenovo X1 Tablet Gen3 trackpoint and buttons

Pali Rohár (1):
      serial: mvebu-uart: correctly report configured baudrate value

Peter Zijlstra (1):
      perf/core: Fix data race between perf_event_set_output() and perf_mmap_close()

Robert Hancock (1):
      i2c: cadence: Change large transfer count reset logic to be unconditional

Takashi Iwai (1):
      ALSA: memalloc: Align buffer allocations in page size

Tariq Toukan (1):
      net/tls: Fix race in TLS device down flow

Tony Fischetti (1):
      HID: add ALWAYS_POLL quirk to lenovo pixart mouse

Wang Cheng (1):
      mm/mempolicy: fix uninit-value in mpol_rebind_policy()

William Dean (1):
      pinctrl: ralink: Check for null return of devm_kcalloc

Xiaomeng Tong (1):
      tilcdc: tilcdc_external: fix an incorrect NULL check on list iterator

