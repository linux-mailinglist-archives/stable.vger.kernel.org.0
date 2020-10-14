Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4385A28DB7E
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 10:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgJNI3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 04:29:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727658AbgJNI3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 04:29:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C716520BED;
        Wed, 14 Oct 2020 08:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602664174;
        bh=dwVYD2T+FEN0G+Tdvhi/xH24SUHIfq2bj9NfEEP2Wrw=;
        h=From:To:Cc:Subject:Date:From;
        b=xVSvoQSYCSzO1aMyI523xaK9IxAc5RDGap9cmPCLP3s+z9YPXJ70jOwsmIif77pny
         pQ8KSXueK3NECwaJh7OYt5ZZZACqOFp7F/p+gigJHjsLQ4U++WM4lgk6Ycewskgbwy
         pKswPU51aKbYWQEAnLwdhcr5RcSX1awu/wJ1q3Ng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.239
Date:   Wed, 14 Oct 2020 10:30:06 +0200
Message-Id: <160266420614166@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.239 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    2 
 drivers/base/dd.c                                    |    5 
 drivers/clk/samsung/clk-exynos4.c                    |    4 
 drivers/gpio/gpio-tc3589x.c                          |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c          |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c              |    1 
 drivers/i2c/busses/i2c-cpm.c                         |    3 
 drivers/input/serio/i8042-x86ia64io.h                |    7 +
 drivers/iommu/exynos-iommu.c                         |    8 +
 drivers/mtd/nand/sunxi_nand.c                        |    2 
 drivers/net/bonding/bond_main.c                      |    1 
 drivers/net/ethernet/dec/tulip/de2104x.c             |    2 
 drivers/net/ethernet/renesas/ravb_main.c             |  110 +++++++++----------
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c |   15 --
 drivers/net/macsec.c                                 |    4 
 drivers/net/phy/Kconfig                              |    1 
 drivers/net/team/team.c                              |    3 
 drivers/net/usb/rndis_host.c                         |    2 
 drivers/net/usb/rtl8150.c                            |   16 ++
 drivers/net/wan/hdlc_cisco.c                         |    1 
 drivers/net/wan/hdlc_fr.c                            |    3 
 drivers/net/wan/hdlc_ppp.c                           |    1 
 drivers/net/wan/lapbether.c                          |    4 
 drivers/platform/x86/thinkpad_acpi.c                 |    6 -
 drivers/usb/gadget/function/f_ncm.c                  |   30 -----
 drivers/video/console/fbcon.c                        |   12 ++
 drivers/video/console/fbcon.h                        |    7 -
 drivers/video/console/fbcon_rotate.c                 |    1 
 drivers/video/console/newport_con.c                  |    7 -
 drivers/video/console/tileblit.c                     |    1 
 fs/eventpoll.c                                       |   71 +++++-------
 fs/nfs/dir.c                                         |    3 
 include/linux/font.h                                 |   13 ++
 include/linux/khugepaged.h                           |    5 
 include/net/xfrm.h                                   |   16 +-
 kernel/events/core.c                                 |    5 
 kernel/kmod.c                                        |    9 +
 kernel/trace/ftrace.c                                |    8 -
 lib/fonts/font_10x18.c                               |    9 -
 lib/fonts/font_6x10.c                                |    9 -
 lib/fonts/font_6x11.c                                |    9 -
 lib/fonts/font_7x14.c                                |    9 -
 lib/fonts/font_8x16.c                                |    9 -
 lib/fonts/font_8x8.c                                 |    9 -
 lib/fonts/font_acorn_8x8.c                           |    9 +
 lib/fonts/font_mini_4x6.c                            |    8 -
 lib/fonts/font_pearl_8x8.c                           |    9 -
 lib/fonts/font_sun12x22.c                            |    9 -
 lib/fonts/font_sun8x16.c                             |    7 -
 lib/random32.c                                       |    2 
 mm/khugepaged.c                                      |   25 +++-
 mm/page_alloc.c                                      |    3 
 net/mac80211/vht.c                                   |    8 -
 net/netfilter/nf_conntrack_netlink.c                 |    2 
 net/openvswitch/conntrack.c                          |   22 ++-
 net/packet/af_packet.c                               |    9 +
 net/rxrpc/conn_event.c                               |    6 -
 net/rxrpc/key.c                                      |   16 ++
 net/sctp/auth.c                                      |    1 
 net/vmw_vsock/virtio_transport.c                     |   96 +++++++++++++---
 net/wireless/nl80211.c                               |    3 
 net/xfrm/xfrm_state.c                                |   13 +-
 tools/perf/builtin-top.c                             |    4 
 63 files changed, 414 insertions(+), 285 deletions(-)

Aaron Ma (1):
      platform/x86: thinkpad_acpi: re-initialize ACPI buffer size when reuse

Al Viro (4):
      epoll: do not insert into poll queues until all sanity checks are done
      epoll: replace ->visited/visited_list with generation count
      epoll: EPOLL_CTL_ADD: close the race in decision to take fast path
      ep_create_wakeup_source(): dentry name can change under you...

Anant Thazhemadam (3):
      net: wireless: nl80211: fix out-of-bounds access in nl80211_del_key()
      net: team: fix memory leak in __team_options_register
      net: usb: rtl8150: set random MAC address when set_ethernet_addr() fails

Antony Antony (2):
      xfrm: clone XFRMA_REPLAY_ESN_VAL in xfrm_do_migrate
      xfrm: clone whole liftime_cur structure in xfrm_do_migrate

Bryan O'Donoghue (1):
      USB: gadget: f_ncm: Fix NDP16 datagram validation

David Howells (3):
      rxrpc: Downgrade the BUG() for unsupported token type in rxrpc_read()
      rxrpc: Fix some missing _bh annotations on locking conn->state_lock
      rxrpc: Fix server keyring leak

Dumitru Ceara (1):
      openvswitch: handle DNAT tuple collision

Eric Dumazet (4):
      macsec: avoid use-after-free in macsec_handle_frame()
      sctp: fix sctp_auth_init_hmacs() error path
      team: set dev->needed_headroom in team_setup_by_port()
      bonding: set dev->needed_headroom in bond_setup_by_slave()

Felix Fietkau (1):
      mac80211: do not allow bigger VHT MPDUs than the hardware supports

Geert Uytterhoeven (1):
      Revert "ravb: Fixed to be able to unload modules"

Greg Kroah-Hartman (1):
      Linux 4.9.239

Herbert Xu (1):
      xfrm: Use correct address family in xfrm_state_find

Hugh Dickins (1):
      mm/khugepaged: fix filemap page_to_pgoff(page) != offset

Jean Delvare (1):
      drm/amdgpu: restore proper ref count in amdgpu_display_crtc_set_config

Jeffrey Mitchell (1):
      nfs: Fix security label length not being reset

Jiri Kosina (1):
      Input: i8042 - add nopnp quirk for Acer Aspire 5 A515

Kajol Jain (1):
      perf: Fix task_function_call() error handling

Linus Torvalds (1):
      usermodehelper: reset umask to default before executing user process

Lucy Yan (1):
      net: dec: de2104x: Increase receive ring size for Tulip

Marc Dionne (1):
      rxrpc: Fix rxkad token xdr encoding

Marek Szyprowski (1):
      clk: samsung: exynos4: mark 'chipid' clock as CLK_IGNORE_UNUSED

Miquel Raynal (1):
      mtd: rawnand: sunxi: Fix the probe error path

Nicolas VINCENT (1):
      i2c: cpm: Fix i2c_ram structure

Olympia Giannou (1):
      rndis_host: increase sleep time in the query-response loop

Or Cohen (1):
      net/packet: fix overflow in tpacket_rcv

Peilin Ye (3):
      fbdev, newport_con: Move FONT_EXTRA_WORDS macros into linux/font.h
      Fonts: Support FONT_EXTRA_WORDS macros for built-in fonts
      fbcon: Fix global-out-of-bounds read in fbcon_get_font()

Philip Yang (1):
      drm/amdgpu: prevent double kfree ttm->sg

Randy Dunlap (1):
      mdio: fix mdio-thunder.c dependency & build error

Stefano Garzarella (2):
      vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock
      vsock/virtio: stop workers during the .remove()

Steven Rostedt (VMware) (1):
      ftrace: Move RCU is watching check after recursion check

Tetsuo Handa (1):
      driver core: Fix probe_count imbalance in really_probe()

Thibaut Sautereau (1):
      random32: Restore __latent_entropy attribute on net_rand_state

Tom Rix (1):
      platform/x86: thinkpad_acpi: initialize tp_nvram_state variable

Tommi Rantala (1):
      perf top: Fix stdio interface input handling with glibc 2.28+

Vijay Balakrishna (1):
      mm: khugepaged: recalculate min_free_kbytes after memory hotplug as expected by khugepaged

Voon Weifeng (1):
      net: stmmac: removed enabling eee in EEE set callback

Will McVicker (1):
      netfilter: ctnetlink: add a range check for l3/l4 protonum

Xie He (2):
      drivers/net/wan/lapbether: Make skb->protocol consistent with the header
      drivers/net/wan/hdlc: Set skb->protocol before transmitting

Yu Kuai (1):
      iommu/exynos: add missing put_device() call in exynos_iommu_of_xlate()

dillon min (1):
      gpio: tc35894: fix up tc35894 interrupt configuration

