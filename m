Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B545D2DEF0C
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 13:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgLSM6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:58:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbgLSM6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:58:17 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.9 00/49] 5.9.16-rc1 review
Date:   Sat, 19 Dec 2020 13:58:04 +0100
Message-Id: <20201219125344.671832095@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.9.16-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.9.16-rc1
X-KernelTest-Deadline: 2020-12-21T12:53+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

------------------
Note, I would like to make this the past, or next-to-last 5.9.y kernel
to be released.  If anyone knows of any reason they can not move to the
5.10.y kernel now, please let me know!
------------------

This is the start of the stable review cycle for the 5.9.16 release.
There are 49 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 21 Dec 2020 12:53:29 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.16-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.9.16-rc1

Xiaochen Shen <xiaochen.shen@intel.com>
    x86/resctrl: Fix incorrect local bandwidth when mba_sc is enabled

James Morse <james.morse@arm.com>
    x86/resctrl: Remove unused struct mbm_state::chunks_bw

Andy Lutomirski <luto@kernel.org>
    membarrier: Explicitly sync remote cores when SYNC_CORE is requested

Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
    KVM: mmu: Fix SPTE encoding of MMIO generation upper half

Alexander Sverdlin <alexander.sverdlin@gmail.com>
    serial: 8250_omap: Avoid FIFO corruption caused by MDR1 access

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Fix potential out-of-bounds shift

Thomas Gleixner <tglx@linutronix.de>
    USB: sisusbvga: Make console support depend on BROKEN

Oliver Neukum <oneukum@suse.com>
    USB: UAS: introduce a quirk to set no_write_same

Mika Westerberg <mika.westerberg@linux.intel.com>
    xhci-pci: Allow host runtime PM as default for Intel Maple Ridge xHCI

Hans de Goede <hdegoede@redhat.com>
    xhci-pci: Allow host runtime PM as default for Intel Alpine Ridge LP

Li Jun <jun.li@nxp.com>
    xhci: Give USB2 ports time to enter U3 in bus suspend

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix control 'access overflow' errors from chmap

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix potential out-of-bounds shift

Oliver Neukum <oneukum@suse.com>
    USB: add RESET_RESUME quirk for Snapscan 1212

Bui Quang Minh <minhquangbui99@gmail.com>
    USB: dummy-hcd: Fix uninitialized array use in init()

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ktest.pl: Fix the logic for truncating the size of the log file for email

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ktest.pl: If size of log is too big to email, email error message

Cengiz Can <cengiz@kernel.wtf>
    net: tipc: prevent possible null deref of link

Fugang Duan <fugang.duan@nxp.com>
    net: stmmac: increase the timeout for dma reset

Sergej Bauer <sbauer@blackbox.su>
    lan743x: fix for potential NULL pointer dereference with bare card

Arnd Bergmann <arnd@arndb.de>
    ch_ktls: fix build warning for ipv4-only config

Jarod Wilson <jarod@redhat.com>
    bonding: fix feature flag setting at init time

Guillaume Nault <gnault@redhat.com>
    net: sched: Fix dump of MPLS_OPT_LSE_LABEL attribute in cls_flower

Moshe Shemesh <moshe@mellanox.com>
    net/mlx4_en: Handle TX error CQE

Moshe Shemesh <moshe@mellanox.com>
    net/mlx4_en: Avoid scheduling restart task if it is already running

Chris Mi <cmi@nvidia.com>
    net: flow_offload: Fix memory leak for indirect flow block

Neal Cardwell <ncardwell@google.com>
    tcp: fix cwnd-limited bug for TSO deferral where we send nothing

Michal Kubecek <mkubecek@suse.cz>
    ethtool: fix stack overflow in ethnl_parse_bitset()

Vitaly Lifshits <vitaly.lifshits@intel.com>
    e1000e: fix S0ix flow to allow S0i3.2 subset entry

Eric Dumazet <edumazet@google.com>
    tcp: select sane initial rcvq_space.space for big MSS

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: ll_temac: Fix potential NULL dereference in temac_probe()

Fugang Duan <fugang.duan@nxp.com>
    net: stmmac: overwrite the dma_cap.addr64 according to HW design

Fugang Duan <fugang.duan@nxp.com>
    net: stmmac: delete the eee_ctrl_timer after napi disabled

Fugang Duan <fugang.duan@nxp.com>
    net: stmmac: free tx skb buffer in stmmac_resume()

Fugang Duan <fugang.duan@nxp.com>
    net: stmmac: start phylink instance before stmmac_hw_setup()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    net: stmmac: dwmac-meson8b: fix mask definition of the m250_sel mux

Jianguo Wu <wujianguo@chinatelecom.cn>
    mptcp: print new line in mptcp_seq_show() if mptcp isn't in use

Joseph Huang <Joseph.Huang@garmin.com>
    bridge: Fix a deadlock when enabling multicast snooping

Claudiu Manoil <claudiu.manoil@nxp.com>
    enetc: Fix reporting of h/w packet counters

Xin Long <lucien.xin@gmail.com>
    udp: fix the proto value passed to ip_protocol_deliver_rcu for the segments

Huazhong Tan <tanhuazhong@huawei.com>
    net: hns3: remove a misused pragma packed

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix dropping of unknown IPv4 multicast on Seville

Stephen Suryaputra <ssuryaextr@gmail.com>
    vrf: packets with lladdr src needs dst at input with orig_iif when needs strict

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: bridge: vlan: fix error return code in __vlan_add()

Eric Dumazet <edumazet@google.com>
    mac80211: mesh: fix mesh_pathtbl_init() error path

Zhang Changzhong <zhangchangzhong@huawei.com>
    ipv4: fix error return code in rtm_to_fib_config()

Alex Elder <elder@linaro.org>
    net: ipa: pass the correct size when freeing DMA memory

Davide Caratti <dcaratti@redhat.com>
    net/sched: fq_pie: initialize timer earlier in fq_pie_init()

Peilin Ye <yepeilin.cs@gmail.com>
    ptrace: Prevent kernel-infoleak in ptrace_get_syscall_info()


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |  1 +
 Documentation/virt/kvm/mmu.rst                     |  2 +-
 Makefile                                           |  4 +-
 arch/x86/kernel/cpu/resctrl/internal.h             |  2 -
 arch/x86/kernel/cpu/resctrl/monitor.c              |  7 +-
 arch/x86/kvm/mmu/mmu.c                             | 29 +++++--
 drivers/crypto/chelsio/chcr_ktls.c                 |  6 +-
 drivers/net/bonding/bond_options.c                 | 22 +++--
 drivers/net/dsa/ocelot/felix.c                     |  7 --
 drivers/net/dsa/ocelot/felix_vsc9959.c             |  1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c           |  1 +
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   | 10 ++-
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    | 10 ++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h |  4 -
 drivers/net/ethernet/intel/e1000e/netdev.c         |  8 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     | 21 +++--
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         | 40 +++++++--
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       | 12 ++-
 drivers/net/ethernet/microchip/lan743x_ethtool.c   |  9 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  9 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c         |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c    |  9 +-
 .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c    |  6 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c   |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 51 +++++++++---
 drivers/net/ethernet/xilinx/ll_temac_main.c        |  9 +-
 drivers/net/ipa/gsi_trans.c                        |  7 +-
 drivers/net/vrf.c                                  | 10 ++-
 drivers/tty/serial/8250/8250_omap.c                |  5 --
 drivers/usb/core/quirks.c                          |  3 +
 drivers/usb/gadget/udc/dummy_hcd.c                 |  2 +-
 drivers/usb/host/xhci-hub.c                        |  4 +
 drivers/usb/host/xhci-pci.c                        |  6 +-
 drivers/usb/misc/sisusbvga/Kconfig                 |  2 +-
 drivers/usb/storage/uas.c                          |  3 +
 drivers/usb/storage/unusual_uas.h                  |  7 +-
 drivers/usb/storage/usb.c                          |  3 +
 include/linux/stmmac.h                             |  1 +
 include/linux/usb_usual.h                          |  2 +
 include/net/bonding.h                              |  2 -
 include/soc/mscc/ocelot.h                          |  3 +
 include/uapi/linux/ptrace.h                        |  3 +-
 kernel/sched/membarrier.c                          | 21 ++++-
 net/bridge/br_device.c                             |  6 ++
 net/bridge/br_multicast.c                          | 34 ++++++--
 net/bridge/br_private.h                            | 10 +++
 net/bridge/br_vlan.c                               |  4 +-
 net/core/flow_offload.c                            |  4 +-
 net/ethtool/bitset.c                               |  2 +
 net/ipv4/fib_frontend.c                            |  2 +-
 net/ipv4/tcp_input.c                               |  3 +-
 net/ipv4/tcp_output.c                              |  9 +-
 net/ipv4/udp.c                                     |  2 +-
 net/mac80211/mesh_pathtbl.c                        |  4 +-
 net/mptcp/mib.c                                    |  1 +
 net/sched/cls_flower.c                             |  4 +-
 net/sched/sch_fq_pie.c                             |  2 +-
 net/tipc/node.c                                    |  6 +-
 sound/core/oss/pcm_oss.c                           |  6 +-
 sound/usb/format.c                                 |  2 +
 sound/usb/stream.c                                 |  6 +-
 tools/testing/ktest/ktest.pl                       | 20 +++--
 tools/testing/selftests/net/fcnal-test.sh          | 95 ++++++++++++++++++++++
 63 files changed, 429 insertions(+), 160 deletions(-)


