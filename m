Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4A21A4FE9
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgDKMMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:12:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727427AbgDKMMq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:12:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A2DB2173E;
        Sat, 11 Apr 2020 12:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607165;
        bh=FKOMjrMZBpKnFrwZEeKngY5jBJgAIF7bWoV+AGe/hQA=;
        h=From:To:Cc:Subject:Date:From;
        b=rODgJzo8TUyfqVaQjcIugSR4L9ynREUDFRALXRoQxtPsW+78bYlI2JL9rNIQKQuH/
         2C9r5VgGWlXhxFBOa5RBzie/IxYvN1TGSM1yvB6OxF+2tRLY3Uy4B1fWWCAPa0AlKO
         3Ydimph8xLzc2cJ/9WyU79fh40J2SoDVQNb1lxRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/32] 4.9.219-rc1 review
Date:   Sat, 11 Apr 2020 14:08:39 +0200
Message-Id: <20200411115418.455500023@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.219-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.219-rc1
X-KernelTest-Deadline: 2020-04-13T11:54+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.219 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.219-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.219-rc1

Hans Verkuil <hans.verkuil@cisco.com>
    drm_dp_mst_topology: fix broken drm_dp_sideband_parse_remote_dpcd_read()

Roger Quadros <rogerq@ti.com>
    usb: dwc3: don't set gadget->is_otg flag

Arun KS <arunks@codeaurora.org>
    arm64: Fix size of __early_cpu_boot_status

Rob Clark <robdclark@chromium.org>
    drm/msm: stop abusing dma_map/unmap for cache

Taniya Das <tdas@codeaurora.org>
    clk: qcom: rcg: Return failure for RCG update

Avihai Horon <avihaih@mellanox.com>
    RDMA/cm: Update num_paths in cma_resolve_iboe_route error flow

Qiujun Huang <hqjagain@gmail.com>
    Bluetooth: RFCOMM: fix ODEBUG bug in rfcomm_dev_ioctl

Ilya Dryomov <idryomov@gmail.com>
    ceph: canonicalize server path in place

Xiubo Li <xiubli@redhat.com>
    ceph: remove the extra slashes in the server path

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Fix memory leaks in sysfs registration and unregistration

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Call kobject_put() when kobject_init_and_add() fails

Paul Cercueil <paul@crapouillou.net>
    ASoC: jz4740-i2s: Fix divider written at incorrect offset in register

David Ahern <dsahern@kernel.org>
    tools/accounting/getdelays.c: fix netlink attribute length

Jason A. Donenfeld <Jason@zx2c4.com>
    random: always use batched entropy for get_random_u{32,64}

Oleksij Rempel <o.rempel@pengutronix.de>
    net: phy: micrel: kszphy_resume(): add delay after genphy_resume() before accessing PHY registers

Richard Palethorpe <rpalethorpe@suse.com>
    slcan: Don't transmit uninitialized stack data in padding

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    net: stmmac: dwmac1000: fix out-of-bounds mac address reg setting

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Ensure correct sub-node is parsed

Randy Dunlap <rdunlap@infradead.org>
    mm: mempolicy: require at least one nodeid for MPOL_PREFERRED

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: always acquire cpu_hotplug_lock before pinst->lock

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: tag_brcm: Fix skb->fwd_offload_mark location

Eugene Syromiatnikov <esyr@redhat.com>
    coresight: do not use the BIT() macro in the UAPI header

Keith Busch <keith.busch@intel.com>
    blk-mq: Allow blocking queue tag iter callbacks

Jianchao Wang <jianchao.w.wang@oracle.com>
    blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: replace MMU flush marker with flush sequence

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: fix possibly using a bad saddr with a given dst

Qiujun Huang <hqjagain@gmail.com>
    sctp: fix refcount bug in sctp_wfree

William Dauchy <w.dauchy@criteo.com>
    net, ip_tunnel: fix interface lookup with no key

Qian Cai <cai@lca.pw>
    ipv4: fix a RCU-list lock in fib_triestat_seq_show

Gerd Hoffmann <kraxel@redhat.com>
    drm/bochs: downgrade pci_request_region failure from error to warning

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: fix race between l2tp_session_delete() and l2tp_tunnel_closeall()

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: ensure sessions are freed after their PPPOL2TP socket


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm64/kernel/head.S                           |  2 +-
 block/blk-mq-tag.c                                 |  9 +++-
 block/blk-mq.c                                     |  4 ++
 drivers/char/random.c                              | 10 +---
 drivers/clk/qcom/clk-rcg2.c                        |  2 +-
 drivers/gpu/drm/bochs/bochs_hw.c                   |  6 +--
 drivers/gpu/drm/drm_dp_mst_topology.c              |  1 +
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c           | 10 ++--
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |  2 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h              |  1 +
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c              |  6 +--
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h              |  2 +-
 drivers/gpu/drm/msm/msm_gem.c                      |  4 +-
 drivers/infiniband/core/cma.c                      |  1 +
 drivers/infiniband/hw/hfi1/sysfs.c                 | 26 ++++++++---
 drivers/net/can/slcan.c                            |  4 +-
 drivers/net/dsa/bcm_sf2.c                          |  7 ++-
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |  2 +-
 drivers/net/phy/micrel.c                           |  7 +++
 drivers/usb/dwc3/gadget.c                          |  1 -
 fs/ceph/super.c                                    | 54 ++++++++++++++--------
 fs/ceph/super.h                                    |  2 +-
 include/uapi/linux/coresight-stm.h                 |  6 ++-
 kernel/padata.c                                    |  4 +-
 mm/mempolicy.c                                     |  6 ++-
 net/bluetooth/rfcomm/tty.c                         |  4 +-
 net/dsa/tag_brcm.c                                 |  4 +-
 net/ipv4/fib_trie.c                                |  3 ++
 net/ipv4/ip_tunnel.c                               |  6 +--
 net/l2tp/l2tp_core.c                               |  6 +++
 net/l2tp/l2tp_core.h                               |  1 +
 net/l2tp/l2tp_ppp.c                                |  8 ++--
 net/sctp/ipv6.c                                    | 20 +++++---
 net/sctp/protocol.c                                | 28 +++++++----
 net/sctp/socket.c                                  | 31 +++++++++----
 sound/soc/jz4740/jz4740-i2s.c                      |  2 +-
 tools/accounting/getdelays.c                       |  2 +-
 38 files changed, 193 insertions(+), 105 deletions(-)


