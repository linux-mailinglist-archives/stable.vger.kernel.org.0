Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7E731D755
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 11:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhBQKMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 05:12:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhBQKMg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 05:12:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D574664E28;
        Wed, 17 Feb 2021 10:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613556715;
        bh=zLZ5Le94qZEV3ZFJVTNws7/pfFQfMlZkQcgYfjrAcqs=;
        h=From:To:Cc:Subject:Date:From;
        b=rVD+Y2w6ginuy0R9YwBtb9zPFV9Xgwv3u1vXC1biBpqFr74GsbBYvtR49bxVa2EcQ
         20jck+dNhwGDGLAYhGoMVvNCrMw9qMJqw2ynf+7W8p9uXrkFN+c17gcHNPkCtQYWS7
         uUicQYhB9uF26NU4PWXhWEZV+bS1dLp1iZYEObsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.99
Date:   Wed, 17 Feb 2021 11:11:51 +0100
Message-Id: <161355671152170@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.99 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                      |    2 
 arch/arm/boot/dts/lpc32xx.dtsi                                |    3 
 arch/arm/include/asm/kexec-internal.h                         |   12 
 arch/arm/kernel/asm-offsets.c                                 |    5 
 arch/arm/kernel/machine_kexec.c                               |   20 
 arch/arm/kernel/relocate_kernel.S                             |   38 -
 arch/arm/kernel/signal.c                                      |   14 
 arch/arm/mach-omap2/cpuidle44xx.c                             |   16 
 arch/arm/xen/enlighten.c                                      |    2 
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts                    |    4 
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts          |    4 
 arch/arm64/boot/dts/rockchip/rk3399.dtsi                      |    2 
 arch/h8300/kernel/asm-offsets.c                               |    3 
 arch/powerpc/kernel/vmlinux.lds.S                             |    1 
 arch/riscv/include/asm/page.h                                 |    5 
 arch/x86/Makefile                                             |    6 
 block/bfq-iosched.c                                           |    8 
 drivers/clk/sunxi-ng/ccu_mp.c                                 |    2 
 drivers/gpio/gpio-ep93xx.c                                    |  216 +++++-----
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c             |   22 -
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c         |   10 
 drivers/gpu/drm/sun4i/sun4i_tcon.c                            |   25 +
 drivers/gpu/drm/sun4i/sun4i_tcon.h                            |    6 
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c                         |    6 
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c                        |   26 -
 drivers/gpu/drm/vc4/vc4_plane.c                               |   18 
 drivers/i2c/busses/i2c-stm32f7.c                              |   11 
 drivers/misc/lkdtm/Makefile                                   |    2 
 drivers/misc/lkdtm/rodata.c                                   |    2 
 drivers/net/ethernet/freescale/enetc/enetc_hw.h               |    2 
 drivers/net/ethernet/freescale/enetc/enetc_pf.c               |   59 ++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c       |    7 
 drivers/net/ethernet/ibm/ibmvnic.c                            |   17 
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c               |    7 
 drivers/net/wireless/mediatek/mt76/dma.c                      |    8 
 drivers/net/xen-netback/rx.c                                  |    9 
 drivers/nvme/host/pci.c                                       |    2 
 drivers/platform/x86/hp-wmi.c                                 |   14 
 drivers/usb/dwc3/ulpi.c                                       |   20 
 drivers/xen/xenbus/xenbus.h                                   |    1 
 drivers/xen/xenbus/xenbus_probe.c                             |    2 
 fs/overlayfs/copy_up.c                                        |   15 
 fs/overlayfs/inode.c                                          |    2 
 fs/overlayfs/super.c                                          |   13 
 include/asm-generic/sections.h                                |    3 
 include/asm-generic/vmlinux.lds.h                             |   12 
 include/linux/compiler.h                                      |   53 ++
 include/linux/compiler_types.h                                |    4 
 include/linux/netdevice.h                                     |    2 
 include/linux/uio.h                                           |    8 
 include/xen/xenbus.h                                          |    2 
 kernel/bpf/stackmap.c                                         |    2 
 kernel/cgroup/cgroup.c                                        |    4 
 kernel/trace/trace.c                                          |    2 
 kernel/trace/trace_events.c                                   |    3 
 lib/iov_iter.c                                                |   24 -
 net/core/datagram.c                                           |   12 
 net/core/dev.c                                                |   11 
 net/dsa/dsa2.c                                                |    7 
 net/netfilter/nf_conntrack_core.c                             |    3 
 net/netfilter/nf_flow_table_core.c                            |    4 
 net/netfilter/nf_tables_api.c                                 |   25 -
 net/netfilter/xt_recent.c                                     |   12 
 net/qrtr/tun.c                                                |    6 
 net/rds/rdma.c                                                |    3 
 net/rxrpc/call_object.c                                       |    2 
 net/sctp/proc.c                                               |   16 
 net/vmw_vsock/af_vsock.c                                      |   13 
 net/vmw_vsock/hyperv_transport.c                              |    4 
 net/vmw_vsock/virtio_transport_common.c                       |    4 
 scripts/mod/modpost.c                                         |    2 
 security/commoncap.c                                          |   67 +--
 tools/testing/selftests/networking/timestamping/txtimestamp.c |    6 
 73 files changed, 665 insertions(+), 320 deletions(-)

Alain Volmat (1):
      i2c: stm32f7: fix configuration of the digital filter

Alexandre Belloni (1):
      ARM: dts: lpc32xx: Revert set default clock rate of HCLK PLL

Alexandre Ghiti (1):
      riscv: virt_addr_valid must check the address belongs to linear mapping

Amir Goldstein (1):
      ovl: skip getxattr of security labels

Bjorn Andersson (1):
      arm64: dts: qcom: sdm845: Reserve LPASS clocks in gcc

Borislav Petkov (1):
      x86/build: Disable CET instrumentation in the kernel for 32-bit too

Bui Quang Minh (1):
      bpf: Check for integer overflow when using roundup_pow_of_two()

Claus Stovgaard (1):
      nvme-pci: ignore the subsysem NQN on Phison E16

David Howells (1):
      rxrpc: Fix clearance of Tx/Rx ring when releasing a call

Edwin Peer (1):
      net: watchdog: hold device global xmit lock during tx disable

Eric Dumazet (1):
      net: gro: do not keep too many GRO packets in napi->rx_list

Fangrui Song (1):
      firmware_loader: align .builtin_fw to 8

Felipe Balbi (1):
      usb: dwc3: ulpi: fix checkpatch warning

Florian Westphal (1):
      netfilter: conntrack: skip identical origin tuple in same zone only

Greg Kroah-Hartman (1):
      Linux 5.4.99

Hans de Goede (1):
      platform/x86: hp-wmi: Disable tablet-mode reporting by default

Jernej Skrabec (4):
      drm/sun4i: tcon: set sync polarity for tcon1 channel
      drm/sun4i: Fix H6 HDMI PHY configuration
      drm/sun4i: dw-hdmi: Fix max. frequency for H6
      clk: sunxi-ng: mp: fix parent rate change flag check

Jozsef Kadlecsik (1):
      netfilter: xt_recent: Fix attempt to update deleted entry

Juergen Gross (1):
      xen/netback: avoid race in xenvif_rx_ring_slots_available()

Julien Grall (1):
      arm/xen: Don't probe xenbus as part of an early initcall

Lin Feng (1):
      bfq-iosched: Revert "bfq: Fix computation of shallow depth"

Lorenzo Bianconi (1):
      mt76: dma: fix a possible memory leak in mt76_add_fragment()

Marc Zyngier (1):
      arm64: dts: rockchip: Fix PCIe DT properties on rk3399

Mark Rutland (1):
      lkdtm: don't move ctors to .rodata

Maxime Ripard (1):
      drm/vc4: hvs: Fix buffer overflow with the dlist handling

Miklos Szeredi (3):
      ovl: perform vfs_getxattr() with mounter creds
      cap: fix conversions on getxattr
      ovl: expand warning in ovl_d_real()

Mohammad Athari Bin Ismail (1):
      net: stmmac: set TxQ mode back to DCB after disabling CBS

NeilBrown (1):
      net: fix iteration for sctp transport seq_files

Nikita Shubin (2):
      gpio: ep93xx: fix BUG_ON port F usage
      gpio: ep93xx: Fix single irqchip with multi gpiochips

Norbert Slusarek (1):
      net/vmw_vsock: improve locking in vsock_connect_timeout()

Odin Ugedal (1):
      cgroup: fix psi monitor for root cgroup

Pablo Neira Ayuso (1):
      netfilter: nftables: fix possible UAF over chains from packet path in netns

Randy Dunlap (1):
      h8300: fix PREEMPTION build, TI_PRE_COUNT undefined

Russell King (2):
      ARM: ensure the signal page contains defined contents
      ARM: kexec: fix oops after TLB are invalidated

Sabyrzhan Tasbolatov (2):
      net/rds: restrict iovecs length for RDS_CMSG_RDMA_ARGS
      net/qrtr: restrict user-controlled length in qrtr_tun_write_iter()

Serge Semin (1):
      usb: dwc3: ulpi: Replace CPU-based busyloop with Protocol-based one

Stefano Garzarella (2):
      vsock/virtio: update credit only if socket is not closed
      vsock: fix locking in vsock_shutdown()

Steven Rostedt (VMware) (2):
      tracing: Do not count ftrace events in top level enable output
      tracing: Check length before giving out the filter buffer

Sukadev Bhattiprolu (1):
      ibmvnic: Clear failover_pending if unable to schedule

Sung Lee (1):
      drm/amd/display: Add more Clock Sources to DCN2.1

Sven Auhagen (1):
      netfilter: flowtable: fix tcp and udp header checksum update

Thomas Gleixner (1):
      vmlinux.lds.h: Create section for protection against instrumentation

Tony Lindgren (1):
      ARM: OMAP2+: Fix suspcious RCU usage splats for omap_enter_idle_coupled

Vadim Fedorenko (1):
      selftests: txtimestamp: fix compilation issue

Victor Lu (3):
      drm/amd/display: Fix dc_sink kref count in emulated_link_detect
      drm/amd/display: Free atomic state after drm_atomic_commit
      drm/amd/display: Decrement refcount of dc_sink before reassignment

Vladimir Oltean (2):
      net: enetc: initialize the RFS and RSS memories
      net: dsa: call teardown method on probe failure

Willem de Bruijn (1):
      udp: fix skb_copy_and_csum_datagram with odd segment sizes

Yufeng Mo (1):
      net: hns3: add a check for queue_id in hclge_reset_vf_queue()

