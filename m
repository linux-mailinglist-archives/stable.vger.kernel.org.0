Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 866F486A3F
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404681AbfHHTHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:07:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404692AbfHHTHf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:07:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C2A6214C6;
        Thu,  8 Aug 2019 19:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291254;
        bh=JetUqc4eAvJCrAcxO3z71ykn7+EwAqi4idGQa5Qc0BM=;
        h=From:To:Cc:Subject:Date:From;
        b=fHpkcgb6WDLYBdLsP/I4rqALyx7SbaRoMPdwsRl18QM7Bs2gYYjjo80WUCYUC84MD
         eCO8ZlqtfBw1iXLzIcgYQxeAXniNEkJvg6kjt4CPDSOWSEeetpddiXLoxfptWe2atf
         mU2qtkHrYrnh+xe60LfTJQ+OZAUHhuAbkeG1jSEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.2 00/56] 5.2.8-stable review
Date:   Thu,  8 Aug 2019 21:04:26 +0200
Message-Id: <20190808190452.867062037@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.2.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.8-rc1
X-KernelTest-Deadline: 2019-08-10T19:04+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.2.8 release.
There are 56 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 10 Aug 2019 07:03:19 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.2.8-rc1

Lukas Wunner <lukas@wunner.de>
    spi: bcm2835: Fix 3-wire mode if DMA is enabled

Johannes Berg <johannes.berg@intel.com>
    Revert "mac80211: set NETIF_F_LLTX when using intermediate tx queues"

Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
    drm/i915/vbt: Fix VBT parsing for the PSR section

Arnd Bergmann <arnd@arndb.de>
    compat_ioctl: pppoe: fix PPPOEIOCSFWD handling

Aya Levin <ayal@mellanox.com>
    net/mlx5e: Fix matching of speed to PRM link modes

Maor Gottlieb <maorg@mellanox.com>
    net/mlx5: Add missing RDMA_RX capabilities

Petr Machata <petrm@mellanox.com>
    mlxsw: spectrum_buffers: Further reduce pool size on Spectrum-2

Colin Ian King <colin.king@canonical.com>
    rocker: fix memory leaks of fib_work on two error return paths

Ursula Braun <ubraun@linux.ibm.com>
    net/smc: avoid fallback in case of non-blocking connect

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: fix race in genphy_update_link

Dexuan Cui <decui@microsoft.com>
    hv_sock: Fix hang when a connection is closed

Jesper Dangaard Brouer <brouer@redhat.com>
    net: fix bpf_xdp_adjust_head regression for generic-XDP

Jesper Dangaard Brouer <brouer@redhat.com>
    selftests/bpf: reduce time to execute test_xdp_vlan.sh

Jesper Dangaard Brouer <brouer@redhat.com>
    selftests/bpf: add wrapper scripts for test_xdp_vlan.sh

Jesper Dangaard Brouer <brouer@redhat.com>
    bpf: fix XDP vlan selftests test_xdp_vlan.sh

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: don't use MSI before RTL8168d

Ariel Levkovich <lariel@mellanox.com>
    net/mlx5e: Prevent encap flow counter update async to user query

Edward Srouji <edwards@mellanox.com>
    net/mlx5: Fix modify_cq_in alignment

Alexis Bauvin <abauvin@scaleway.com>
    tun: mark small packets as owned by the tap sock

Jon Maloy <jon.maloy@ericsson.com>
    tipc: fix unitilized skb list crash

Taras Kondratiuk <takondra@cisco.com>
    tipc: compat: allow tipc commands without arguments

Claudiu Manoil <claudiu.manoil@nxp.com>
    ocelot: Cancel delayed work before wq destruction

Johan Hovold <johan@kernel.org>
    NFC: nfcmrvl: fix gpio-handling regression

Frode Isaksen <fisaksen@baylibre.com>
    net: stmmac: Use netif_tx_napi_add() for TX polling function

Ursula Braun <ubraun@linux.ibm.com>
    net/smc: do not schedule tx_work in SMC_CLOSED state

Dmytro Linkin <dmitrolin@mellanox.com>
    net: sched: use temporary variable for actions indexes

Roman Mashak <mrv@mojatatu.com>
    net sched: update vlan action for batched events operations

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: sched: Fix a possible null-pointer dereference in dequeue_func()

Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
    net: qualcomm: rmnet: Fix incorrect UL checksum offload logic

Andreas Schwab <schwab@suse.de>
    net: phy: mscc: initialize stats array

René van Dorst <opensource@vdorst.com>
    net: phylink: Fix flow control for fixed-link

Arseny Solokha <asolokha@kb.kras.ru>
    net: phylink: don't start and stop SGMII PHYs in SFP modules twice

Hubert Feurstein <h.feurstein@gmail.com>
    net: phy: fixed_phy: print gpio error only if gpio node is present

Mark Zhang <markz@mellanox.com>
    net/mlx5: Use reversed order when unregister devices

Qian Cai <cai@lca.pw>
    net/mlx5e: always initialize frag->last_in_page

Jiri Pirko <jiri@mellanox.com>
    net: fix ifindex collision during namespace removal

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: move default pvid init/deinit to NETDEV_REGISTER/UNREGISTER

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: mcast: don't delete permanent entries when fast leave is enabled

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: delete local fdb on device init failure

Matteo Croce <mcroce@redhat.com>
    mvpp2: refactor MTU change code

Matteo Croce <mcroce@redhat.com>
    mvpp2: fix panic on module removal

Jiri Pirko <jiri@mellanox.com>
    mlxsw: spectrum: Fix error path in mlxsw_sp_module_init()

Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
    ipip: validate header length in ipip_tunnel_xmit

Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
    ip6_tunnel: fix possible use-after-free on xmit

Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
    ip6_gre: reload ipv6h in prepare_ip6gre_xmit_ipv6

Cong Wang <xiyou.wangcong@gmail.com>
    ife: error out when nla attributes are empty

Arnaud Patard <arnaud.patard@rtp-net.org>
    drivers/net/ethernet/marvell/mvmdio.c: Fix non OF case

Sudarsana Reddy Kalluru <skalluru@marvell.com>
    bnx2x: Disable multi-cos feature.

Gustavo A. R. Silva <gustavo@embeddedor.com>
    atm: iphase: Fix Spectre v1 vulnerability

Sebastian Parschauer <s.parschauer@gmx.de>
    HID: Add quirk for HP X1200 PIXART OEM mouse

Aaron Armstrong Skomra <skomra@gmail.com>
    HID: wacom: fix bit shift for Cintiq Companion 2

Hillf Danton <hdanton@sina.com>
    ALSA: usb-audio: Fix gpf in snd_usb_pipe_sanity_check

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Sanity checks for each pipe and EP types

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/bus: Fix wait_nvdimm_bus_probe_idle() ABBA deadlock

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/bus: Prepare the nd_ioctl() path to be re-entrant

Hannes Reinecke <hare@suse.de>
    scsi: fcoe: Embed fc_rport_priv in fcoe_rport structure


-------------

Diffstat:

 Makefile                                           |  4 +-
 drivers/atm/iphase.c                               |  8 ++-
 drivers/gpu/drm/i915/intel_bios.c                  |  2 +-
 drivers/gpu/drm/i915/intel_vbt_defs.h              |  6 +-
 drivers/hid/hid-ids.h                              |  1 +
 drivers/hid/hid-quirks.c                           |  1 +
 drivers/hid/wacom_wac.c                            | 12 ++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  3 +-
 drivers/net/ethernet/marvell/mvmdio.c              | 28 +++++++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    | 46 +++++---------
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  | 27 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h  |  6 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   | 67 +++++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |  5 +-
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |  5 ++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_buffers.c |  4 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  1 +
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |  2 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 13 ++--
 drivers/net/ethernet/realtek/r8169.c               |  9 ++-
 drivers/net/ethernet/rocker/rocker_main.c          |  1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  5 +-
 drivers/net/phy/fixed_phy.c                        |  6 +-
 drivers/net/phy/mscc.c                             | 16 ++---
 drivers/net/phy/phy_device.c                       |  6 ++
 drivers/net/phy/phylink.c                          | 10 +--
 drivers/net/ppp/pppoe.c                            |  3 +
 drivers/net/ppp/pppox.c                            | 13 ++++
 drivers/net/ppp/pptp.c                             |  3 +
 drivers/net/tun.c                                  |  9 ++-
 drivers/nfc/nfcmrvl/main.c                         |  4 +-
 drivers/nfc/nfcmrvl/uart.c                         |  4 +-
 drivers/nfc/nfcmrvl/usb.c                          |  1 +
 drivers/nvdimm/bus.c                               | 73 ++++++++++++++--------
 drivers/nvdimm/region_devs.c                       |  4 ++
 drivers/scsi/fcoe/fcoe_ctlr.c                      | 51 ++++++---------
 drivers/scsi/libfc/fc_rport.c                      |  5 +-
 drivers/spi/spi-bcm2835.c                          |  3 +-
 fs/compat_ioctl.c                                  |  3 -
 include/linux/if_pppox.h                           |  3 +
 include/linux/mlx5/fs.h                            |  1 +
 include/linux/mlx5/mlx5_ifc.h                      |  6 +-
 include/scsi/libfcoe.h                             |  1 +
 net/bridge/br.c                                    |  5 +-
 net/bridge/br_multicast.c                          |  3 +
 net/bridge/br_private.h                            |  9 +--
 net/bridge/br_vlan.c                               | 29 +++++----
 net/core/dev.c                                     | 17 +++--
 net/ipv4/ipip.c                                    |  3 +
 net/ipv6/ip6_gre.c                                 |  3 +-
 net/ipv6/ip6_tunnel.c                              |  6 +-
 net/l2tp/l2tp_ppp.c                                |  3 +
 net/mac80211/iface.c                               |  1 -
 net/sched/act_bpf.c                                |  9 +--
 net/sched/act_connmark.c                           |  9 +--
 net/sched/act_csum.c                               |  9 +--
 net/sched/act_gact.c                               |  8 ++-
 net/sched/act_ife.c                                | 13 +++-
 net/sched/act_mirred.c                             | 13 ++--
 net/sched/act_nat.c                                |  9 +--
 net/sched/act_pedit.c                              | 10 +--
 net/sched/act_police.c                             |  8 ++-
 net/sched/act_sample.c                             | 10 +--
 net/sched/act_simple.c                             | 10 +--
 net/sched/act_skbedit.c                            | 11 ++--
 net/sched/act_skbmod.c                             | 11 ++--
 net/sched/act_tunnel_key.c                         |  8 ++-
 net/sched/act_vlan.c                               | 25 +++++---
 net/sched/sch_codel.c                              |  6 +-
 net/smc/af_smc.c                                   | 15 +++--
 net/tipc/netlink_compat.c                          | 11 ++--
 net/tipc/socket.c                                  |  3 +-
 net/vmw_vsock/hyperv_transport.c                   |  8 +++
 sound/usb/helper.c                                 | 17 +++++
 sound/usb/helper.h                                 |  1 +
 sound/usb/quirks.c                                 | 18 +++++-
 tools/testing/selftests/bpf/Makefile               |  3 +-
 tools/testing/selftests/bpf/test_xdp_vlan.sh       | 57 +++++++++++++----
 .../selftests/bpf/test_xdp_vlan_mode_generic.sh    |  9 +++
 .../selftests/bpf/test_xdp_vlan_mode_native.sh     |  9 +++
 84 files changed, 579 insertions(+), 314 deletions(-)


