Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7051231D757
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 11:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhBQKMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 05:12:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232158AbhBQKMp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 05:12:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56F9C64E45;
        Wed, 17 Feb 2021 10:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613556724;
        bh=Husbeckr9FU6rT29VcZtKW21z2V09nnVCY93N+Bp+fY=;
        h=From:To:Cc:Subject:Date:From;
        b=o1xZhbOvF7XgyKksovb1Pyp+vQzwLoNMpU6Lw/TdL4LNazQBIAHm2ArJRkcKPDUmA
         LFD6ump+Ac/f0dZR6i/w5bSdrnu/LLKAGixn/xCnlDTsvGUfvB7jp6NAQdZ8o+zIBh
         IjY6jkT6HZjhdG0jUd0vnLz9aMPB6We+X5y7OSH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.17
Date:   Wed, 17 Feb 2021 11:11:57 +0100
Message-Id: <161355671775123@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.17 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/arm/boot/dts/lpc32xx.dtsi                              |    3 
 arch/arm/include/asm/kexec-internal.h                       |   12 
 arch/arm/kernel/asm-offsets.c                               |    5 
 arch/arm/kernel/machine_kexec.c                             |   20 -
 arch/arm/kernel/relocate_kernel.S                           |   38 --
 arch/arm/kernel/signal.c                                    |   14 
 arch/arm/mach-omap2/cpuidle44xx.c                           |   16 
 arch/arm/xen/enlighten.c                                    |    2 
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts                  |    4 
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts        |    4 
 arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts          |    4 
 arch/arm64/boot/dts/rockchip/rk3399.dtsi                    |    3 
 arch/arm64/kernel/cpufeature.c                              |    6 
 arch/arm64/kernel/mte.c                                     |    3 
 arch/h8300/kernel/asm-offsets.c                             |    3 
 arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts         |    1 
 arch/riscv/include/asm/page.h                               |    5 
 arch/x86/Makefile                                           |    6 
 arch/x86/kernel/cpu/intel.c                                 |    1 
 arch/x86/kernel/smpboot.c                                   |    1 
 arch/x86/kvm/svm/nested.c                                   |   13 
 arch/x86/kvm/svm/svm.h                                      |    3 
 arch/x86/kvm/x86.c                                          |    2 
 arch/x86/pci/init.c                                         |   15 
 arch/x86/platform/efi/efi_64.c                              |   19 -
 block/bfq-iosched.c                                         |    8 
 drivers/clk/sunxi-ng/ccu_mp.c                               |    2 
 drivers/cpufreq/acpi-cpufreq.c                              |  115 +++++-
 drivers/dma/dmaengine.c                                     |    1 
 drivers/dma/idxd/device.c                                   |   23 +
 drivers/dma/idxd/dma.c                                      |    5 
 drivers/dma/idxd/idxd.h                                     |    2 
 drivers/dma/idxd/init.c                                     |    5 
 drivers/dma/idxd/irq.c                                      |   36 +-
 drivers/gpio/Kconfig                                        |    3 
 drivers/gpio/gpio-ep93xx.c                                  |  216 ++++++------
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |   22 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |    6 
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c            |    6 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c       |    4 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c       |   10 
 drivers/gpu/drm/drm_dp_mst_topology.c                       |    1 
 drivers/gpu/drm/i915/display/intel_overlay.c                |   17 
 drivers/gpu/drm/i915/display/intel_tc.c                     |   67 ++-
 drivers/gpu/drm/sun4i/sun4i_tcon.c                          |   25 +
 drivers/gpu/drm/sun4i/sun4i_tcon.h                          |    6 
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c                       |   10 
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h                       |    1 
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c                      |   26 -
 drivers/gpu/drm/vc4/vc4_plane.c                             |   18 -
 drivers/i2c/busses/i2c-stm32f7.c                            |   11 
 drivers/misc/lkdtm/Makefile                                 |    2 
 drivers/misc/lkdtm/rodata.c                                 |    2 
 drivers/net/dsa/ocelot/felix.c                              |   17 
 drivers/net/ethernet/freescale/enetc/enetc_hw.h             |    2 
 drivers/net/ethernet/freescale/enetc/enetc_pf.c             |   59 +++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c     |    7 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c      |   29 +
 drivers/net/ethernet/ibm/ibmvnic.c                          |   17 
 drivers/net/ethernet/mscc/ocelot.c                          |   54 +++
 drivers/net/ethernet/mscc/ocelot_io.c                       |    8 
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c             |    7 
 drivers/net/hyperv/netvsc.c                                 |    5 
 drivers/net/hyperv/rndis_filter.c                           |    2 
 drivers/net/ipa/gsi.c                                       |    1 
 drivers/net/wan/hdlc_x25.c                                  |    6 
 drivers/net/wireless/ath/ath9k/Kconfig                      |    8 
 drivers/net/wireless/mediatek/mt76/dma.c                    |    8 
 drivers/net/xen-netback/rx.c                                |    9 
 drivers/nvme/host/pci.c                                     |    2 
 drivers/platform/x86/hp-wmi.c                               |   14 
 drivers/scsi/lpfc/lpfc_nvme.c                               |    3 
 drivers/scsi/scsi_debug.c                                   |    1 
 drivers/soc/ti/omap_prm.c                                   |   11 
 drivers/usb/core/hcd.c                                      |   11 
 drivers/xen/xenbus/xenbus.h                                 |    1 
 drivers/xen/xenbus/xenbus_probe.c                           |    2 
 fs/Kconfig                                                  |    2 
 fs/overlayfs/copy_up.c                                      |   15 
 fs/overlayfs/inode.c                                        |    2 
 fs/overlayfs/super.c                                        |   13 
 include/asm-generic/vmlinux.lds.h                           |    2 
 include/linux/netdevice.h                                   |    2 
 include/linux/uio.h                                         |    8 
 include/net/switchdev.h                                     |    2 
 include/soc/mscc/ocelot.h                                   |    2 
 include/xen/xenbus.h                                        |    2 
 kernel/bpf/stackmap.c                                       |    2 
 kernel/cgroup/cgroup-v1.c                                   |    3 
 kernel/cgroup/cgroup.c                                      |    4 
 kernel/trace/bpf_trace.c                                    |    3 
 kernel/trace/trace.c                                        |    2 
 kernel/trace/trace_events.c                                 |    3 
 lib/cpumask.c                                               |   16 
 lib/iov_iter.c                                              |   24 -
 lib/ubsan.c                                                 |   31 +
 lib/ubsan.h                                                 |    6 
 net/bridge/br_mrp.c                                         |    9 
 net/bridge/br_mrp_switchdev.c                               |    7 
 net/bridge/br_private_mrp.h                                 |    3 
 net/core/datagram.c                                         |   12 
 net/core/dev.c                                              |   11 
 net/dsa/dsa2.c                                              |    7 
 net/mac80211/Kconfig                                        |    2 
 net/netfilter/nf_conntrack_core.c                           |    3 
 net/netfilter/nf_flow_table_core.c                          |    4 
 net/netfilter/nf_tables_api.c                               |   25 +
 net/netfilter/xt_recent.c                                   |   12 
 net/qrtr/tun.c                                              |    6 
 net/rds/rdma.c                                              |    3 
 net/rxrpc/call_object.c                                     |    2 
 net/sctp/proc.c                                             |   16 
 net/vmw_vsock/af_vsock.c                                    |   15 
 net/vmw_vsock/hyperv_transport.c                            |    4 
 net/vmw_vsock/virtio_transport_common.c                     |    4 
 scripts/Makefile                                            |    1 
 scripts/kallsyms.c                                          |    6 
 security/commoncap.c                                        |   67 ++-
 tools/objtool/check.c                                       |   11 
 tools/objtool/elf.c                                         |   26 +
 tools/objtool/elf.h                                         |    2 
 tools/objtool/orc_gen.c                                     |   29 -
 tools/testing/selftests/net/txtimestamp.c                   |    6 
 tools/testing/selftests/netfilter/nft_meta.sh               |    2 
 125 files changed, 1069 insertions(+), 509 deletions(-)

Alain Volmat (1):
      i2c: stm32f7: fix configuration of the digital filter

Alex Deucher (1):
      Revert "drm/amd/display: Update NV1x SR latency values"

Alex Elder (1):
      net: ipa: set error code in gsi_channel_setup()

Alexandre Belloni (1):
      ARM: dts: lpc32xx: Revert set default clock rate of HCLK PLL

Alexandre Ghiti (1):
      riscv: virt_addr_valid must check the address belongs to linear mapping

Alexei Starovoitov (1):
      bpf: Unbreak BPF_PROG_TYPE_KPROBE when kprobe is called via do_int3

Amir Goldstein (1):
      ovl: skip getxattr of security labels

Andrea Parri (Microsoft) (1):
      hv_netvsc: Reset the RSC count if NVSP_STAT_FAIL in netvsc_receive()

Andrey Konovalov (1):
      kcov, usb: only collect coverage from __usb_hcd_giveback_urb in softirq

Arnd Bergmann (2):
      kallsyms: fix nonconverging kallsyms table with lld
      ath9k: fix build error with LEDS_CLASS=m

Bjorn Andersson (1):
      arm64: dts: qcom: sdm845: Reserve LPASS clocks in gcc

Borislav Petkov (2):
      x86/efi: Remove EFI PGD build time checks
      x86/build: Disable CET instrumentation in the kernel for 32-bit too

Bui Quang Minh (1):
      bpf: Check for integer overflow when using roundup_pow_of_two()

Catalin Marinas (1):
      arm64: mte: Allow PTRACE_PEEKMTETAGS access to the zero page

Chen Zhou (1):
      cgroup-v1: add disabled controller check in cgroup1_parse_param()

Claus Stovgaard (1):
      nvme-pci: ignore the subsysem NQN on Phison E16

Dave Jiang (3):
      dmaengine: move channel device_node deletion to driver
      dmaengine: idxd: fix misc interrupt completion
      dmaengine: idxd: check device state before issue command

David Howells (1):
      rxrpc: Fix clearance of Tx/Rx ring when releasing a call

Edwin Peer (1):
      net: watchdog: hold device global xmit lock during tx disable

Eric Dumazet (1):
      net: gro: do not keep too many GRO packets in napi->rx_list

Fabian Frederick (1):
      selftests: netfilter: fix current year

Fangrui Song (1):
      firmware_loader: align .builtin_fw to 8

Fenghua Yu (1):
      x86/split_lock: Enable the split lock feature on another Alder Lake CPU

Florian Westphal (1):
      netfilter: conntrack: skip identical origin tuple in same zone only

Geert Uytterhoeven (1):
      gpio: mxs: GPIO_MXS should not default to y unconditionally

George Shen (1):
      drm/amd/display: Fix DPCD translation for LTTPR AUX_RD_INTERVAL

Greg Kroah-Hartman (1):
      Linux 5.10.17

Hans de Goede (1):
      platform/x86: hp-wmi: Disable tablet-mode reporting by default

Horatiu Vultur (2):
      bridge: mrp: Fix the usage of br_mrp_port_switchdev_set_state
      switchdev: mrp: Remove SWITCHDEV_ATTR_ID_MRP_PORT_STAT

Imre Deak (2):
      drm/i915/tgl+: Make sure TypeC FIA is powered up when initializing it
      drm/dp_mst: Don't report ports connected if nothing is attached to them

James Smart (1):
      scsi: lpfc: Fix EEH encountering oops with NVMe traffic

Jernej Skrabec (5):
      drm/sun4i: tcon: set sync polarity for tcon1 channel
      drm/sun4i: dw-hdmi: always set clock rate
      drm/sun4i: Fix H6 HDMI PHY configuration
      drm/sun4i: dw-hdmi: Fix max. frequency for H6
      clk: sunxi-ng: mp: fix parent rate change flag check

Johan Jonker (1):
      arm64: dts: rockchip: remove interrupt-names property from rk3399 vdec node

Josh Poimboeuf (1):
      objtool: Fix seg fault with Clang non-section symbols

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

Maurizio Lombardi (1):
      scsi: scsi_debug: Fix a memory leak

Maxime Ripard (1):
      drm/vc4: hvs: Fix buffer overflow with the dlist handling

Mikita Lipski (1):
      drm/amd/display: Release DSC before acquiring

Miklos Szeredi (3):
      ovl: perform vfs_getxattr() with mounter creds
      cap: fix conversions on getxattr
      ovl: expand warning in ovl_d_real()

Mohammad Athari Bin Ismail (1):
      net: stmmac: set TxQ mode back to DCB after disabling CBS

Nathan Chancellor (1):
      ubsan: implement __ubsan_handle_alignment_assumption

NeilBrown (1):
      net: fix iteration for sctp transport seq_files

Nikita Shubin (2):
      gpio: ep93xx: fix BUG_ON port F usage
      gpio: ep93xx: Fix single irqchip with multi gpiochips

Norbert Slusarek (2):
      net/vmw_vsock: fix NULL pointer dereference
      net/vmw_vsock: improve locking in vsock_connect_timeout()

Odin Ugedal (1):
      cgroup: fix psi monitor for root cgroup

Pablo Neira Ayuso (1):
      netfilter: nftables: fix possible UAF over chains from packet path in netns

Palmer Dabbelt (1):
      Revert "dts: phy: add GPIO number and active state used for phy reset"

Paolo Bonzini (1):
      KVM: x86: cleanup CR3 reserved bits checks

Rafael J. Wysocki (2):
      cpufreq: ACPI: Extend frequency tables to cover boost frequencies
      cpufreq: ACPI: Update arch scale-invariance max perf ratio if CPPC is not there

Randy Dunlap (1):
      h8300: fix PREEMPTION build, TI_PRE_COUNT undefined

Robin Murphy (1):
      arm64: dts: rockchip: Disable display for NanoPi R2S

Rolf Eike Beer (1):
      scripts: set proper OpenSSL include dir also for sign-file

Russell King (2):
      ARM: ensure the signal page contains defined contents
      ARM: kexec: fix oops after TLB are invalidated

Sabyrzhan Tasbolatov (2):
      net/rds: restrict iovecs length for RDS_CMSG_RDMA_ARGS
      net/qrtr: restrict user-controlled length in qrtr_tun_write_iter()

Seth Forshee (2):
      tmpfs: disallow CONFIG_TMPFS_INODE64 on s390
      tmpfs: disallow CONFIG_TMPFS_INODE64 on alpha

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

Thomas Gleixner (2):
      Revert "lib: Restrict cpumask_local_spread to houskeeping CPUs"
      x86/pci: Create PCI/MSI irqdomain after x86_init.pci.arch_init()

Tony Lindgren (2):
      soc: ti: omap-prm: Fix boot time errors for rst_map_012 bits 0 and 1
      ARM: OMAP2+: Fix suspcious RCU usage splats for omap_enter_idle_coupled

Vadim Fedorenko (1):
      selftests: txtimestamp: fix compilation issue

Victor Lu (3):
      drm/amd/display: Fix dc_sink kref count in emulated_link_detect
      drm/amd/display: Free atomic state after drm_atomic_commit
      drm/amd/display: Decrement refcount of dc_sink before reassignment

Ville Syrjälä (1):
      drm/i915: Fix overlay frontbuffer tracking

Vladimir Oltean (3):
      net: enetc: initialize the RFS and RSS memories
      net: dsa: felix: implement port flushing on .phylink_mac_link_down
      net: dsa: call teardown method on probe failure

Willem de Bruijn (1):
      udp: fix skb_copy_and_csum_datagram with odd segment sizes

Xie He (1):
      net: hdlc_x25: Return meaningful error code in x25_open

Yufeng Mo (3):
      net: hns3: add a check for queue_id in hclge_reset_vf_queue()
      net: hns3: add a check for tqp_index in hclge_get_ring_chain_from_mbx()
      net: hns3: add a check for index in hclge_get_rss_key()

