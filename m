Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702E51A67B9
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 16:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730488AbgDMOQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 10:16:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730487AbgDMOQv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Apr 2020 10:16:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 666802075E;
        Mon, 13 Apr 2020 14:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787410;
        bh=Vw7/lgKzVIySJoptLvxm2L8NXyCaTQDUCMP6KAE8xNc=;
        h=Date:From:To:Cc:Subject:From;
        b=0iZ5XR7PyIUQhu+QNDdy68pIXJ23rBz/0ijQrW8vC+sQ0B0QKH10RQxGZhrgj/Glt
         nx3761t44792hNiYLgV/+7wWtUybKqrD54qdubRXVCARrRftTliagKuKCDxQJsSeX1
         cLp2Q7LKpoESvDRM1HIaGF2meAGkrtZC/2zM/Pbs=
Date:   Mon, 13 Apr 2020 16:16:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.219
Message-ID: <20200413141648.GA3538921@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.219 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/accounting/getdelays.c                 |    2 
 Makefile                                             |    2 
 drivers/char/random.c                                |    6 
 drivers/clk/qcom/clk-rcg2.c                          |    2 
 drivers/gpu/drm/bochs/bochs_hw.c                     |    6 
 drivers/gpu/drm/drm_dp_mst_topology.c                |    1 
 drivers/infiniband/core/cma.c                        |    1 
 drivers/net/can/slcan.c                              |    4 
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c |    2 
 drivers/net/xen-netfront.c                           |   11 -
 drivers/power/axp288_charger.c                       |    4 
 drivers/staging/rdma/hfi1/sysfs.c                    |   13 +
 drivers/usb/gadget/function/f_printer.c              |    8 -
 drivers/usb/gadget/function/f_uac2.c                 |   12 -
 kernel/padata.c                                      |    4 
 mm/mempolicy.c                                       |    6 
 net/bluetooth/rfcomm/tty.c                           |    4 
 net/ipv4/fib_trie.c                                  |    3 
 net/ipv4/ip_tunnel.c                                 |    6 
 net/l2tp/l2tp_core.c                                 |  149 +++++++++++++++----
 net/l2tp/l2tp_core.h                                 |    4 
 net/l2tp/l2tp_eth.c                                  |   10 -
 net/l2tp/l2tp_ip.c                                   |   17 +-
 net/l2tp/l2tp_ip6.c                                  |   28 ++-
 net/l2tp/l2tp_ppp.c                                  |  110 +++++++-------
 net/sctp/ipv6.c                                      |   20 +-
 net/sctp/protocol.c                                  |   28 ++-
 sound/soc/jz4740/jz4740-i2s.c                        |    2 
 28 files changed, 284 insertions(+), 181 deletions(-)

Avihai Horon (1):
      RDMA/cm: Update num_paths in cma_resolve_iboe_route error flow

Daniel Jordan (1):
      padata: always acquire cpu_hotplug_lock before pinst->lock

David Ahern (1):
      tools/accounting/getdelays.c: fix netlink attribute length

Gao Feng (1):
      l2tp: Refactor the codes with existing macros instead of literal number

Gerd Hoffmann (1):
      drm/bochs: downgrade pci_request_region failure from error to warning

Greg Kroah-Hartman (1):
      Linux 4.4.219

Guillaume Nault (5):
      l2tp: fix race in l2tp_recv_common()
      l2tp: ensure session can't get removed during pppol2tp_session_ioctl()
      l2tp: fix duplicate session creation
      l2tp: ensure sessions are freed after their PPPOL2TP socket
      l2tp: fix race between l2tp_session_delete() and l2tp_tunnel_closeall()

Gustavo A. R. Silva (1):
      power: supply: axp288_charger: Fix unchecked return value

Hans Verkuil (1):
      drm_dp_mst_topology: fix broken drm_dp_sideband_parse_remote_dpcd_read()

Jason A. Donenfeld (1):
      random: always use batched entropy for get_random_u{32,64}

Jisheng Zhang (1):
      net: stmmac: dwmac1000: fix out-of-bounds mac address reg setting

Kaike Wan (1):
      IB/hfi1: Call kobject_put() when kobject_init_and_add() fails

Krzysztof Opasiak (2):
      usb: gadget: uac2: Drop unused device qualifier descriptor
      usb: gadget: printer: Drop unused device qualifier descriptor

Marcelo Ricardo Leitner (1):
      sctp: fix possibly using a bad saddr with a given dst

Paul Cercueil (1):
      ASoC: jz4740-i2s: Fix divider written at incorrect offset in register

Qian Cai (1):
      ipv4: fix a RCU-list lock in fib_triestat_seq_show

Qiujun Huang (1):
      Bluetooth: RFCOMM: fix ODEBUG bug in rfcomm_dev_ioctl

Randy Dunlap (1):
      mm: mempolicy: require at least one nodeid for MPOL_PREFERRED

Richard Palethorpe (1):
      slcan: Don't transmit uninitialized stack data in padding

Ross Lagerwall (2):
      xen-netfront: Fix mismatched rtnl_unlock
      xen-netfront: Update features after registering netdev

Shmulik Ladkani (1):
      net: l2tp: Make l2tp_ip6 namespace aware

Taniya Das (1):
      clk: qcom: rcg: Return failure for RCG update

William Dauchy (1):
      net, ip_tunnel: fix interface lookup with no key

phil.turnbull@oracle.com (1):
      l2tp: Correctly return -EBADF from pppol2tp_getname.

