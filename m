Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954162DFC0B
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 13:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbgLUMzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 07:55:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:58648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbgLUMzO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Dec 2020 07:55:14 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.85
Date:   Mon, 21 Dec 2020 13:55:47 +0100
Message-Id: <160855534714431@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.85 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt                  |    1 
 Documentation/virt/kvm/mmu.txt                                   |    2 
 Makefile                                                         |    2 
 arch/x86/kernel/cpu/resctrl/internal.h                           |    2 
 arch/x86/kernel/cpu/resctrl/monitor.c                            |    7 
 arch/x86/kvm/mmu.c                                               |   29 ++-
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c             |   10 -
 drivers/net/ethernet/freescale/enetc/enetc_hw.h                  |   10 -
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h       |    4 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                   |   21 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c                       |   40 +++-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h                     |   12 +
 drivers/net/ethernet/microchip/lan743x_ethtool.c                 |    9 
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c              |    6 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                |   27 ++
 drivers/net/ethernet/xilinx/ll_temac_main.c                      |    4 
 drivers/net/vrf.c                                                |   10 -
 drivers/tty/serial/8250/8250_omap.c                              |    5 
 drivers/usb/core/quirks.c                                        |    3 
 drivers/usb/gadget/udc/dummy_hcd.c                               |    2 
 drivers/usb/host/xhci-hub.c                                      |    4 
 drivers/usb/host/xhci-pci.c                                      |    2 
 drivers/usb/misc/sisusbvga/Kconfig                               |    2 
 drivers/usb/storage/uas.c                                        |    3 
 drivers/usb/storage/unusual_uas.h                                |    7 
 drivers/usb/storage/usb.c                                        |    3 
 include/linux/usb_usual.h                                        |    2 
 include/uapi/linux/ptrace.h                                      |    3 
 kernel/sched/membarrier.c                                        |   21 ++
 net/bridge/br_device.c                                           |    6 
 net/bridge/br_multicast.c                                        |   34 ++-
 net/bridge/br_private.h                                          |   10 +
 net/bridge/br_vlan.c                                             |    4 
 net/ipv4/fib_frontend.c                                          |    2 
 net/ipv4/tcp_input.c                                             |    3 
 net/ipv4/tcp_output.c                                            |    9 
 net/ipv4/udp.c                                                   |    2 
 net/mac80211/mesh_pathtbl.c                                      |    4 
 sound/core/oss/pcm_oss.c                                         |    6 
 sound/usb/format.c                                               |    2 
 sound/usb/stream.c                                               |    6 
 tools/testing/ktest/ktest.pl                                     |    7 
 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_user.tc |    4 
 tools/testing/selftests/net/fcnal-test.sh                        |   95 ++++++++++
 44 files changed, 350 insertions(+), 97 deletions(-)

Alexander Sverdlin (1):
      serial: 8250_omap: Avoid FIFO corruption caused by MDR1 access

Andy Lutomirski (1):
      membarrier: Explicitly sync remote cores when SYNC_CORE is requested

Bui Quang Minh (1):
      USB: dummy-hcd: Fix uninitialized array use in init()

Claudiu Manoil (1):
      enetc: Fix reporting of h/w packet counters

Eric Dumazet (2):
      mac80211: mesh: fix mesh_pathtbl_init() error path
      tcp: select sane initial rcvq_space.space for big MSS

Fugang Duan (2):
      net: stmmac: free tx skb buffer in stmmac_resume()
      net: stmmac: delete the eee_ctrl_timer after napi disabled

Greg Kroah-Hartman (1):
      Linux 5.4.85

Hans de Goede (1):
      xhci-pci: Allow host runtime PM as default for Intel Alpine Ridge LP

Huazhong Tan (1):
      net: hns3: remove a misused pragma packed

James Morse (1):
      x86/resctrl: Remove unused struct mbm_state::chunks_bw

Joseph Huang (1):
      bridge: Fix a deadlock when enabling multicast snooping

Kamal Mostafa (1):
      Revert "selftests/ftrace: check for do_sys_openat2 in user-memory test"

Li Jun (1):
      xhci: Give USB2 ports time to enter U3 in bus suspend

Maciej S. Szmigiero (1):
      KVM: mmu: Fix SPTE encoding of MMIO generation upper half

Martin Blumenstingl (1):
      net: stmmac: dwmac-meson8b: fix mask definition of the m250_sel mux

Moshe Shemesh (2):
      net/mlx4_en: Avoid scheduling restart task if it is already running
      net/mlx4_en: Handle TX error CQE

Neal Cardwell (1):
      tcp: fix cwnd-limited bug for TSO deferral where we send nothing

Oliver Neukum (2):
      USB: add RESET_RESUME quirk for Snapscan 1212
      USB: UAS: introduce a quirk to set no_write_same

Peilin Ye (1):
      ptrace: Prevent kernel-infoleak in ptrace_get_syscall_info()

Sergej Bauer (1):
      lan743x: fix for potential NULL pointer dereference with bare card

Stephen Suryaputra (1):
      vrf: packets with lladdr src needs dst at input with orig_iif when needs strict

Steven Rostedt (VMware) (1):
      ktest.pl: If size of log is too big to email, email error message

Takashi Iwai (3):
      ALSA: usb-audio: Fix potential out-of-bounds shift
      ALSA: usb-audio: Fix control 'access overflow' errors from chmap
      ALSA: pcm: oss: Fix potential out-of-bounds shift

Thomas Gleixner (1):
      USB: sisusbvga: Make console support depend on BROKEN

Xiaochen Shen (1):
      x86/resctrl: Fix incorrect local bandwidth when mba_sc is enabled

Xin Long (1):
      udp: fix the proto value passed to ip_protocol_deliver_rcu for the segments

Zhang Changzhong (3):
      ipv4: fix error return code in rtm_to_fib_config()
      net: bridge: vlan: fix error return code in __vlan_add()
      net: ll_temac: Fix potential NULL dereference in temac_probe()

