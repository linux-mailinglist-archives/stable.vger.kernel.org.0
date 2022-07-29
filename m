Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A7A58524A
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 17:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237446AbiG2PVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 11:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236861AbiG2PUq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 11:20:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E12B1FCE2;
        Fri, 29 Jul 2022 08:20:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20C4BB8282F;
        Fri, 29 Jul 2022 15:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D781C433C1;
        Fri, 29 Jul 2022 15:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659108041;
        bh=XGaai7hG74Cu2F6G+twaAISaIF6/BHkdiIhZ4xytfZQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Z5G9K/fMFUaJbXMCdkt2gzSHHDfJQfTc+V9IPFa9CLUD7FPqXH4NgJS+ia1HT+/Rj
         5rzGXKS0mPvUG5fk1ZJoH5wGA+pqEYztS68lAKHVZqwnzGeBwWVmBMb9hXZ2QGejSY
         ZH4mfwZdXOr7BnwsU0jmL5PGj/lRUh/MseQdMEis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.290
Date:   Fri, 29 Jul 2022 17:20:27 +0200
Message-Id: <165910802795200@kroah.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.290 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/alpha/kernel/srmcons.c                       |    2 
 drivers/char/random.c                             |    4 
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c              |   28 ++----
 drivers/gpu/drm/tilcdc/tilcdc_drv.c               |    1 
 drivers/gpu/drm/tilcdc/tilcdc_drv.h               |    2 
 drivers/gpu/drm/tilcdc/tilcdc_external.c          |   96 ++------------------
 drivers/gpu/drm/tilcdc/tilcdc_external.h          |    1 
 drivers/gpu/drm/tilcdc/tilcdc_panel.c             |    9 -
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c            |    9 -
 drivers/i2c/busses/i2c-cadence.c                  |   30 +-----
 drivers/net/ethernet/emulex/benet/be_cmds.c       |   10 +-
 drivers/net/ethernet/emulex/benet/be_cmds.h       |    2 
 drivers/net/ethernet/emulex/benet/be_ethtool.c    |   31 ++++--
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |    3 
 drivers/net/usb/ax88179_178a.c                    |   16 +--
 drivers/pci/host/pci-hyperv.c                     |  101 ++++++++++++++++++----
 drivers/power/reset/arm-versatile-reboot.c        |    1 
 drivers/s390/char/keyboard.h                      |    4 
 drivers/staging/speakup/spk_ttyio.c               |    4 
 drivers/tty/cyclades.c                            |    6 -
 drivers/tty/goldfish.c                            |    2 
 drivers/tty/moxa.c                                |    4 
 drivers/tty/pty.c                                 |   14 ---
 drivers/tty/serial/lpc32xx_hs.c                   |    2 
 drivers/tty/tty_buffer.c                          |   66 +++++++++-----
 drivers/tty/vt/keyboard.c                         |    6 -
 drivers/tty/vt/vt.c                               |    2 
 drivers/xen/gntdev.c                              |    3 
 include/linux/tty_flip.h                          |    4 
 include/net/bluetooth/bluetooth.h                 |   65 ++++++++++++++
 include/net/inet_sock.h                           |    3 
 include/net/ip.h                                  |    2 
 include/net/tcp.h                                 |    2 
 kernel/bpf/core.c                                 |    8 +
 kernel/events/core.c                              |   45 ++++++---
 mm/mempolicy.c                                    |    2 
 net/bluetooth/rfcomm/core.c                       |   50 +++++++++-
 net/bluetooth/rfcomm/sock.c                       |   46 ++--------
 net/bluetooth/sco.c                               |   30 ++----
 net/ipv4/igmp.c                                   |   23 +++--
 net/ipv4/tcp_output.c                             |    4 
 net/xfrm/xfrm_policy.c                            |    5 -
 sound/core/memalloc.c                             |    1 
 44 files changed, 409 insertions(+), 342 deletions(-)

Demi Marie Obenour (1):
      xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE

Eric Dumazet (1):
      bpf: Make sure mac_header was set before using it

Greg Kroah-Hartman (1):
      Linux 4.14.290

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

Kuniyuki Iwashima (7):
      ip: Fix a data-race around sysctl_fwmark_reflect.
      tcp/dccp: Fix a data-race around sysctl_tcp_fwmark_accept.
      tcp: Fix a data-race around sysctl_tcp_probe_threshold.
      tcp: Fix a data-race around sysctl_tcp_probe_interval.
      igmp: Fix data-races around sysctl_igmp_llm_reports.
      igmp: Fix a data-race around sysctl_igmp_max_memberships.
      tcp: Fix a data-race around sysctl_tcp_notsent_lowat.

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

Peter Zijlstra (1):
      perf/core: Fix data race between perf_event_set_output() and perf_mmap_close()

Robert Hancock (1):
      i2c: cadence: Change large transfer count reset logic to be unconditional

Takashi Iwai (1):
      ALSA: memalloc: Align buffer allocations in page size

Wang Cheng (1):
      mm/mempolicy: fix uninit-value in mpol_rebind_policy()

Xiaomeng Tong (1):
      tilcdc: tilcdc_external: fix an incorrect NULL check on list iterator

