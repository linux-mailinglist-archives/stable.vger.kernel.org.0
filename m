Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98C611A5030
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgDKMPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:15:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727709AbgDKMPQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:15:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB3F020644;
        Sat, 11 Apr 2020 12:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607315;
        bh=j/cy1nKKtIDwc3ocqVeRMV42mH+iKyjdLPHPxG+dviA=;
        h=From:To:Cc:Subject:Date:From;
        b=2gohe8ABI0APvbFXimivvzfqzULxgx/oK2Kr0+i+asK21cbyKXZzcHCJvhXuPWjqn
         nnmoCK2vD75zXpk+xc5f7sTu6nxeMzuRNSwF9J4FFAmTH5ieuwxz3QD5pZy05ZbW99
         69Vq1y9WvMVN+dIcH1wCdGBXHskhfPixDll0sI+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/54] 4.19.115-rc1 review
Date:   Sat, 11 Apr 2020 14:08:42 +0200
Message-Id: <20200411115508.284500414@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.115-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.115-rc1
X-KernelTest-Deadline: 2020-04-13T11:55+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.115 release.
There are 54 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.115-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.115-rc1

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

Qiujun Huang <hqjagain@gmail.com>
    fbcon: fix null-ptr-deref in fbcon_switch

Avihai Horon <avihaih@mellanox.com>
    RDMA/cm: Update num_paths in cma_resolve_iboe_route error flow

Qiujun Huang <hqjagain@gmail.com>
    Bluetooth: RFCOMM: fix ODEBUG bug in rfcomm_dev_ioctl

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/cma: Teach lockdep about the order of rtnl and lock

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/ucma: Put a lock around every call to the rdma_cm layer

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

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Wrap around when skip TRBs

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

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Do not register slave MDIO bus with OF

Jarod Wilson <jarod@redhat.com>
    ipv6: don't auto-add link-local address to lag ports

Randy Dunlap <rdunlap@infradead.org>
    mm: mempolicy: require at least one nodeid for MPOL_PREFERRED

Sam Protsenko <semen.protsenko@linaro.org>
    include/linux/notifier.h: SRCU: fix ctags

Miklos Szeredi <mszeredi@redhat.com>
    bitops: protect variables in set_mask_bits() macro

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: always acquire cpu_hotplug_lock before pinst->lock

Amritha Nambiar <amritha.nambiar@intel.com>
    net: Fix Tx hash bound checking

David Howells <dhowells@redhat.com>
    rxrpc: Fix sendmsg(MSG_WAITALL) handling

Geoffrey Allott <geoffrey@allott.email>
    ALSA: hda/ca0132 - Add Recon3Di quirk to handle integrated sound on EVGA X99 Classified motherboard

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288_charger: Add special handling for HP Pavilion x2 10

Hans de Goede <hdegoede@redhat.com>
    extcon: axp288: Add wakeup support

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add cedar fork device ids

Eugene Syromiatnikov <esyr@redhat.com>
    coresight: do not use the BIT() macro in the UAPI header

Kishon Vijay Abraham I <kishon@ti.com>
    misc: pci_endpoint_test: Avoid using module parameter to determine irqtype

Kishon Vijay Abraham I <kishon@ti.com>
    misc: pci_endpoint_test: Fix to support > 10 pci-endpoint-test devices

YueHaibing <yuehaibing@huawei.com>
    misc: rtsx: set correct pcr_ops for rts522A

Sean Young <sean@mess.org>
    media: rc: IR signal for Panasonic air conditioner too long

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: replace MMU flush marker with flush sequence

Len Brown <len.brown@intel.com>
    tools/power turbostat: Fix missing SYS_LPI counter on some Chromebooks

Len Brown <len.brown@intel.com>
    tools/power turbostat: Fix gcc build warnings

James Zhu <James.Zhu@amd.com>
    drm/amdgpu: fix typo for vcn1 idle check

Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
    initramfs: restore default compression behavior

Gerd Hoffmann <kraxel@redhat.com>
    drm/bochs: downgrade pci_request_region failure from error to warning

Mario Kleiner <mario.kleiner.de@gmail.com>
    drm/amd/display: Add link_rate quirk for Apple 15" MBP 2017

Prabhath Sajeepa <psajeepa@purestorage.com>
    nvme-rdma: Avoid double freeing of async event data

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
 drivers/char/hw_random/imx-rngc.c                  |  4 +-
 drivers/char/random.c                              | 20 ++------
 drivers/clk/qcom/clk-rcg2.c                        |  2 +-
 drivers/extcon/extcon-axp288.c                     | 32 ++++++++++++
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c              |  2 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   | 11 +++++
 drivers/gpu/drm/bochs/bochs_hw.c                   |  6 +--
 drivers/gpu/drm/drm_dp_mst_topology.c              |  1 +
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c           | 10 ++--
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h              |  1 +
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c              |  6 +--
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h              |  2 +-
 drivers/gpu/drm/msm/msm_gem.c                      |  4 +-
 drivers/infiniband/core/cma.c                      | 14 ++++++
 drivers/infiniband/core/ucma.c                     | 49 ++++++++++++++++++-
 drivers/infiniband/hw/hfi1/sysfs.c                 | 26 +++++++---
 drivers/media/rc/lirc_dev.c                        |  2 +-
 drivers/misc/cardreader/rts5227.c                  |  1 +
 drivers/misc/mei/hw-me-regs.h                      |  2 +
 drivers/misc/mei/pci-me.c                          |  2 +
 drivers/misc/pci_endpoint_test.c                   | 14 ++++--
 drivers/net/can/slcan.c                            |  4 +-
 drivers/net/dsa/bcm_sf2.c                          |  9 +++-
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |  8 +--
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |  2 +-
 drivers/net/phy/micrel.c                           |  7 +++
 drivers/nvme/host/rdma.c                           |  8 +--
 drivers/power/supply/axp288_charger.c              | 57 +++++++++++++++++++++-
 drivers/rpmsg/qcom_glink_native.c                  |  3 --
 drivers/usb/dwc3/gadget.c                          |  3 +-
 drivers/video/fbdev/core/fbcon.c                   |  3 ++
 fs/ceph/super.c                                    | 56 +++++++++++++--------
 fs/ceph/super.h                                    |  2 +-
 include/linux/bitops.h                             | 14 +++---
 include/linux/notifier.h                           |  3 +-
 include/uapi/linux/coresight-stm.h                 |  6 ++-
 kernel/padata.c                                    |  4 +-
 mm/mempolicy.c                                     |  6 ++-
 net/bluetooth/rfcomm/tty.c                         |  4 +-
 net/core/dev.c                                     |  2 +
 net/ipv4/fib_trie.c                                |  3 ++
 net/ipv4/ip_tunnel.c                               |  6 +--
 net/ipv6/addrconf.c                                |  4 ++
 net/rxrpc/sendmsg.c                                |  4 +-
 net/sctp/ipv6.c                                    | 20 +++++---
 net/sctp/protocol.c                                | 28 +++++++----
 net/sctp/socket.c                                  | 31 +++++++++---
 sound/pci/hda/patch_ca0132.c                       |  1 +
 sound/soc/jz4740/jz4740-i2s.c                      |  2 +-
 tools/accounting/getdelays.c                       |  2 +-
 tools/power/x86/turbostat/turbostat.c              | 27 +++++-----
 usr/Kconfig                                        | 22 ++++-----
 54 files changed, 409 insertions(+), 159 deletions(-)


