Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2FF1A51B0
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgDKMOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:14:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbgDKMO3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:14:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BF152084D;
        Sat, 11 Apr 2020 12:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607269;
        bh=CyCF5gFd5usJueJcVKS9Uf9QWcC06vODoq2oFLK42gw=;
        h=From:To:Cc:Subject:Date:From;
        b=GteRhLXvI/QMUIsbT5d3ByrdqVfmHbiYhKAuyPwsMq7P0aWP+IZG8iOazPTBNYoT2
         RBP0/2jK1qT0yFQtDMuPauS+PZhj0XBFtz38ryu3bbYN93r5p6ZG48+1x9iP7L/6Hf
         3Bu+OWHD7lvnfmIEGc/aAVTp26Cig5+3MlrmHxqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/38] 4.14.176-rc1 review
Date:   Sat, 11 Apr 2020 14:08:44 +0200
Message-Id: <20200411115437.795556138@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.176-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.176-rc1
X-KernelTest-Deadline: 2020-04-13T11:54+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.176 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.176-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.176-rc1

Hans Verkuil <hans.verkuil@cisco.com>
    drm_dp_mst_topology: fix broken drm_dp_sideband_parse_remote_dpcd_read()

Roger Quadros <rogerq@ti.com>
    usb: dwc3: don't set gadget->is_otg flag

Chris Lew <clew@codeaurora.org>
    rpmsg: glink: Remove chunk size word align warning

Arun KS <arunks@codeaurora.org>
    arm64: Fix size of __early_cpu_boot_status

Rob Clark <robdclark@chromium.org>
    drm/msm: stop abusing dma_map/unmap for cache

Taniya Das <tdas@codeaurora.org>
    clk: qcom: rcg: Return failure for RCG update

Dan Williams <dan.j.williams@intel.com>
    acpi/nfit: Fix bus command validation

Qiujun Huang <hqjagain@gmail.com>
    fbcon: fix null-ptr-deref in fbcon_switch

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

Martin Kaiser <martin@kaiser.cx>
    hwrng: imx-rngc - fix an error path

David Ahern <dsahern@kernel.org>
    tools/accounting/getdelays.c: fix netlink attribute length

Jason A. Donenfeld <Jason@zx2c4.com>
    random: always use batched entropy for get_random_u{32,64}

Petr Machata <petrm@mellanox.com>
    mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_VLAN_MANGLE

Richard Palethorpe <rpalethorpe@suse.com>
    slcan: Don't transmit uninitialized stack data in padding

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    net: stmmac: dwmac1000: fix out-of-bounds mac address reg setting

Oleksij Rempel <o.rempel@pengutronix.de>
    net: phy: micrel: kszphy_resume(): add delay after genphy_resume() before accessing PHY registers

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Ensure correct sub-node is parsed

Jarod Wilson <jarod@redhat.com>
    ipv6: don't auto-add link-local address to lag ports

Randy Dunlap <rdunlap@infradead.org>
    mm: mempolicy: require at least one nodeid for MPOL_PREFERRED

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: always acquire cpu_hotplug_lock before pinst->lock

Eugene Syromiatnikov <esyr@redhat.com>
    coresight: do not use the BIT() macro in the UAPI header

Kishon Vijay Abraham I <kishon@ti.com>
    misc: pci_endpoint_test: Fix to support > 10 pci-endpoint-test devices

Keith Busch <keith.busch@intel.com>
    blk-mq: Allow blocking queue tag iter callbacks

Jianchao Wang <jianchao.w.wang@oracle.com>
    blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: replace MMU flush marker with flush sequence

Len Brown <len.brown@intel.com>
    tools/power turbostat: Fix gcc build warnings

Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
    initramfs: restore default compression behavior

Gerd Hoffmann <kraxel@redhat.com>
    drm/bochs: downgrade pci_request_region failure from error to warning

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: fix possibly using a bad saddr with a given dst

Qiujun Huang <hqjagain@gmail.com>
    sctp: fix refcount bug in sctp_wfree

William Dauchy <w.dauchy@criteo.com>
    net, ip_tunnel: fix interface lookup with no key

Qian Cai <cai@lca.pw>
    ipv4: fix a RCU-list lock in fib_triestat_seq_show


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm64/kernel/head.S                           |  2 +-
 block/blk-mq-tag.c                                 |  9 +++-
 block/blk-mq.c                                     |  4 ++
 drivers/acpi/nfit/core.c                           | 24 +++++-----
 drivers/char/hw_random/imx-rngc.c                  |  4 +-
 drivers/char/random.c                              | 20 ++------
 drivers/clk/qcom/clk-rcg2.c                        |  2 +-
 drivers/gpu/drm/bochs/bochs_hw.c                   |  6 +--
 drivers/gpu/drm/drm_dp_mst_topology.c              |  1 +
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c           | 10 ++--
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |  2 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h              |  1 +
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c              |  8 ++--
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h              |  2 +-
 drivers/gpu/drm/msm/msm_gem.c                      |  4 +-
 drivers/infiniband/core/cma.c                      |  1 +
 drivers/infiniband/hw/hfi1/sysfs.c                 | 26 +++++++---
 drivers/misc/pci_endpoint_test.c                   |  2 +-
 drivers/net/can/slcan.c                            |  4 +-
 drivers/net/dsa/bcm_sf2.c                          |  7 ++-
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |  8 ++--
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |  2 +-
 drivers/net/phy/micrel.c                           |  7 +++
 drivers/rpmsg/qcom_glink_native.c                  |  3 --
 drivers/usb/dwc3/gadget.c                          |  1 -
 drivers/video/fbdev/core/fbcon.c                   |  3 ++
 fs/ceph/super.c                                    | 56 ++++++++++++++--------
 fs/ceph/super.h                                    |  2 +-
 include/uapi/linux/coresight-stm.h                 |  6 ++-
 kernel/padata.c                                    |  4 +-
 mm/mempolicy.c                                     |  6 ++-
 net/bluetooth/rfcomm/tty.c                         |  4 +-
 net/ipv4/fib_trie.c                                |  3 ++
 net/ipv4/ip_tunnel.c                               |  6 +--
 net/ipv6/addrconf.c                                |  4 ++
 net/sctp/ipv6.c                                    | 20 +++++---
 net/sctp/protocol.c                                | 28 +++++++----
 net/sctp/socket.c                                  | 31 ++++++++----
 sound/soc/jz4740/jz4740-i2s.c                      |  2 +-
 tools/accounting/getdelays.c                       |  2 +-
 tools/power/x86/turbostat/turbostat.c              |  4 +-
 usr/Kconfig                                        | 22 ++++-----
 43 files changed, 227 insertions(+), 140 deletions(-)


