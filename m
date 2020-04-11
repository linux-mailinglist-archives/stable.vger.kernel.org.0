Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A34A21A51E4
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgDKMLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgDKMLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:11:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 563E22084D;
        Sat, 11 Apr 2020 12:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607058;
        bh=eedYbopOdGJr/FrvetlpClOMoqPetDCKEkcmRZuGvVQ=;
        h=From:To:Cc:Subject:Date:From;
        b=mK9BJf/0RGFyrkK3LLVN3cZ9/pdwoYU0Hbm0awzgwU5p3CZrNbg6qJVlzUTzelm2A
         Cg7tfJgE+vYVHYUMa6Q1zS7l89wOT4cxn8cNRWgj42ryu0L7LHtfV/fRtRUUNbeGME
         jHp5JFPRIGgtG42XKEUZXOlEOh1/i99K44RQ2rUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/29] 4.4.219-rc1 review
Date:   Sat, 11 Apr 2020 14:08:30 +0200
Message-Id: <20200411115407.651296755@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.219-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.219-rc1
X-KernelTest-Deadline: 2020-04-13T11:54+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.219 release.
There are 29 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.219-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.219-rc1

Hans Verkuil <hans.verkuil@cisco.com>
    drm_dp_mst_topology: fix broken drm_dp_sideband_parse_remote_dpcd_read()

Taniya Das <tdas@codeaurora.org>
    clk: qcom: rcg: Return failure for RCG update

Avihai Horon <avihaih@mellanox.com>
    RDMA/cm: Update num_paths in cma_resolve_iboe_route error flow

Qiujun Huang <hqjagain@gmail.com>
    Bluetooth: RFCOMM: fix ODEBUG bug in rfcomm_dev_ioctl

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Call kobject_put() when kobject_init_and_add() fails

Paul Cercueil <paul@crapouillou.net>
    ASoC: jz4740-i2s: Fix divider written at incorrect offset in register

Ross Lagerwall <ross.lagerwall@citrix.com>
    xen-netfront: Update features after registering netdev

Ross Lagerwall <ross.lagerwall@citrix.com>
    xen-netfront: Fix mismatched rtnl_unlock

Gustavo A. R. Silva <gustavo@embeddedor.com>
    power: supply: axp288_charger: Fix unchecked return value

David Ahern <dsahern@kernel.org>
    tools/accounting/getdelays.c: fix netlink attribute length

Jason A. Donenfeld <Jason@zx2c4.com>
    random: always use batched entropy for get_random_u{32,64}

Richard Palethorpe <rpalethorpe@suse.com>
    slcan: Don't transmit uninitialized stack data in padding

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    net: stmmac: dwmac1000: fix out-of-bounds mac address reg setting

Randy Dunlap <rdunlap@infradead.org>
    mm: mempolicy: require at least one nodeid for MPOL_PREFERRED

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: always acquire cpu_hotplug_lock before pinst->lock

Krzysztof Opasiak <k.opasiak@samsung.com>
    usb: gadget: printer: Drop unused device qualifier descriptor

Krzysztof Opasiak <k.opasiak@samsung.com>
    usb: gadget: uac2: Drop unused device qualifier descriptor

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: fix race between l2tp_session_delete() and l2tp_tunnel_closeall()

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: ensure sessions are freed after their PPPOL2TP socket

Gao Feng <fgao@ikuai8.com>
    l2tp: Refactor the codes with existing macros instead of literal number

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: fix duplicate session creation

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: ensure session can't get removed during pppol2tp_session_ioctl()

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: fix race in l2tp_recv_common()

Shmulik Ladkani <shmulik.ladkani@gmail.com>
    net: l2tp: Make l2tp_ip6 namespace aware

phil.turnbull@oracle.com <phil.turnbull@oracle.com>
    l2tp: Correctly return -EBADF from pppol2tp_getname.

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: fix possibly using a bad saddr with a given dst

William Dauchy <w.dauchy@criteo.com>
    net, ip_tunnel: fix interface lookup with no key

Qian Cai <cai@lca.pw>
    ipv4: fix a RCU-list lock in fib_triestat_seq_show

Gerd Hoffmann <kraxel@redhat.com>
    drm/bochs: downgrade pci_request_region failure from error to warning


-------------

Diffstat:

 Documentation/accounting/getdelays.c               |   2 +-
 Makefile                                           |   4 +-
 drivers/char/random.c                              |   6 -
 drivers/clk/qcom/clk-rcg2.c                        |   2 +-
 drivers/gpu/drm/bochs/bochs_hw.c                   |   6 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |   1 +
 drivers/infiniband/core/cma.c                      |   1 +
 drivers/net/can/slcan.c                            |   4 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |   2 +-
 drivers/net/xen-netfront.c                         |  11 +-
 drivers/power/axp288_charger.c                     |   4 +
 drivers/staging/rdma/hfi1/sysfs.c                  |  13 +-
 drivers/usb/gadget/function/f_printer.c            |   8 --
 drivers/usb/gadget/function/f_uac2.c               |  12 --
 kernel/padata.c                                    |   4 +-
 mm/mempolicy.c                                     |   6 +-
 net/bluetooth/rfcomm/tty.c                         |   4 +-
 net/ipv4/fib_trie.c                                |   3 +
 net/ipv4/ip_tunnel.c                               |   6 +-
 net/l2tp/l2tp_core.c                               | 149 ++++++++++++++++-----
 net/l2tp/l2tp_core.h                               |   4 +
 net/l2tp/l2tp_eth.c                                |  10 +-
 net/l2tp/l2tp_ip.c                                 |  17 ++-
 net/l2tp/l2tp_ip6.c                                |  28 ++--
 net/l2tp/l2tp_ppp.c                                | 110 +++++++--------
 net/sctp/ipv6.c                                    |  20 ++-
 net/sctp/protocol.c                                |  28 ++--
 sound/soc/jz4740/jz4740-i2s.c                      |   2 +-
 28 files changed, 285 insertions(+), 182 deletions(-)


