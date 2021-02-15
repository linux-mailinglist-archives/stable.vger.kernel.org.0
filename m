Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA9E31BCF6
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhBOPhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:37:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:49202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231246AbhBOPgv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:36:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87E5E64E73;
        Mon, 15 Feb 2021 15:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403142;
        bh=SwrBhXkDYxTNWopB9Si49HmrYpHIySjamZ6XBJocc2U=;
        h=From:To:Cc:Subject:Date:From;
        b=kkgEdDDnU1/AyosJ+yrttdqr1/A+KiJDsZoGlNzVzE0ITgOUAvjSNtmTGHUqdHf+i
         ZYA2FfQBGDcfg/xycxGP3iQMiDNGyPX/GesMROjdPPXPETJk2ILUqAGEM12GNtqRsh
         RI+kbdnXSt5m0zCwvjXGeMs7H/bO6RDGBZTxOJKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 5.10 000/104] 5.10.17-rc1 review
Date:   Mon, 15 Feb 2021 16:26:13 +0100
Message-Id: <20210215152719.459796636@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.10.17-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.17-rc1
X-KernelTest-Deadline: 2021-02-17T15:27+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.17 release.
There are 104 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 17 Feb 2021 15:27:00 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.17-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.17-rc1

Andrey Konovalov <andreyknvl@google.com>
    kcov, usb: only collect coverage from __usb_hcd_giveback_urb in softirq

Miklos Szeredi <mszeredi@redhat.com>
    ovl: expand warning in ovl_d_real()

Sabyrzhan Tasbolatov <snovitoll@gmail.com>
    net/qrtr: restrict user-controlled length in qrtr_tun_write_iter()

Sabyrzhan Tasbolatov <snovitoll@gmail.com>
    net/rds: restrict iovecs length for RDS_CMSG_RDMA_ARGS

Stefano Garzarella <sgarzare@redhat.com>
    vsock: fix locking in vsock_shutdown()

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: update credit only if socket is not closed

Horatiu Vultur <horatiu.vultur@microchip.com>
    switchdev: mrp: Remove SWITCHDEV_ATTR_ID_MRP_PORT_STAT

Horatiu Vultur <horatiu.vultur@microchip.com>
    bridge: mrp: Fix the usage of br_mrp_port_switchdev_set_state

Edwin Peer <edwin.peer@broadcom.com>
    net: watchdog: hold device global xmit lock during tx disable

Norbert Slusarek <nslusarek@gmx.net>
    net/vmw_vsock: improve locking in vsock_connect_timeout()

Norbert Slusarek <nslusarek@gmx.net>
    net/vmw_vsock: fix NULL pointer dereference

NeilBrown <neilb@suse.de>
    net: fix iteration for sctp transport seq_files

Eric Dumazet <edumazet@google.com>
    net: gro: do not keep too many GRO packets in napi->rx_list

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: ACPI: Update arch scale-invariance max perf ratio if CPPC is not there

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: ACPI: Extend frequency tables to cover boost frequencies

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: call teardown method on probe failure

Willem de Bruijn <willemb@google.com>
    udp: fix skb_copy_and_csum_datagram with odd segment sizes

David Howells <dhowells@redhat.com>
    rxrpc: Fix clearance of Tx/Rx ring when releasing a call

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mte: Allow PTRACE_PEEKMTETAGS access to the zero page

Thomas Gleixner <tglx@linutronix.de>
    x86/pci: Create PCI/MSI irqdomain after x86_init.pci.arch_init()

Rolf Eike Beer <eb@emlix.com>
    scripts: set proper OpenSSL include dir also for sign-file

Randy Dunlap <rdunlap@infradead.org>
    h8300: fix PREEMPTION build, TI_PRE_COUNT undefined

Alain Volmat <alain.volmat@foss.st.com>
    i2c: stm32f7: fix configuration of the digital filter

Jernej Skrabec <jernej.skrabec@siol.net>
    clk: sunxi-ng: mp: fix parent rate change flag check

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: dw-hdmi: Fix max. frequency for H6

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: Fix H6 HDMI PHY configuration

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: dw-hdmi: always set clock rate

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: tcon: set sync polarity for tcon1 channel

Fangrui Song <maskray@google.com>
    firmware_loader: align .builtin_fw to 8

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: add a check for index in hclge_get_rss_key()

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: add a check for tqp_index in hclge_get_ring_chain_from_mbx()

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: add a check for queue_id in hclge_reset_vf_queue()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: implement port flushing on .phylink_mac_link_down

Borislav Petkov <bp@suse.de>
    x86/build: Disable CET instrumentation in the kernel for 32-bit too

Maurizio Lombardi <mlombard@redhat.com>
    scsi: scsi_debug: Fix a memory leak

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: skip identical origin tuple in same zone only

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: Clear failover_pending if unable to schedule

Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
    net: stmmac: set TxQ mode back to DCB after disabling CBS

Vadim Fedorenko <vfedorenko@novek.ru>
    selftests: txtimestamp: fix compilation issue

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: initialize the RFS and RSS memories

Andrea Parri (Microsoft) <parri.andrea@gmail.com>
    hv_netvsc: Reset the RSC count if NVSP_STAT_FAIL in netvsc_receive()

Alex Elder <elder@linaro.org>
    net: ipa: set error code in gsi_channel_setup()

Xie He <xie.he.0141@gmail.com>
    net: hdlc_x25: Return meaningful error code in x25_open

Juergen Gross <jgross@suse.com>
    xen/netback: avoid race in xenvif_rx_ring_slots_available()

Sven Auhagen <sven.auhagen@voleatech.de>
    netfilter: flowtable: fix tcp and udp header checksum update

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nftables: fix possible UAF over chains from packet path in netns

Fabian Frederick <fabf@skynet.be>
    selftests: netfilter: fix current year

Jozsef Kadlecsik <kadlec@mail.kfki.hu>
    netfilter: xt_recent: Fix attempt to update deleted entry

Bui Quang Minh <minhquangbui99@gmail.com>
    bpf: Check for integer overflow when using roundup_pow_of_two()

Alexei Starovoitov <ast@kernel.org>
    bpf: Unbreak BPF_PROG_TYPE_KPROBE when kprobe is called via do_int3

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: check device state before issue command

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hvs: Fix buffer overflow with the dlist handling

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: dma: fix a possible memory leak in mt76_add_fragment()

Arnd Bergmann <arnd@arndb.de>
    ath9k: fix build error with LEDS_CLASS=m

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix misc interrupt completion

Chen Zhou <chenzhou10@huawei.com>
    cgroup-v1: add disabled controller check in cgroup1_parse_param()

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: cleanup CR3 reserved bits checks

Mark Rutland <mark.rutland@arm.com>
    lkdtm: don't move ctors to .rodata

Borislav Petkov <bp@suse.de>
    x86/efi: Remove EFI PGD build time checks

Thomas Gleixner <tglx@linutronix.de>
    Revert "lib: Restrict cpumask_local_spread to houskeeping CPUs"

Nathan Chancellor <nathan@kernel.org>
    ubsan: implement __ubsan_handle_alignment_assumption

Vincenzo Frascino <vincenzo.frascino@arm.com>
    kasan: add explicit preconditions to kasan_report()

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: kexec: fix oops after TLB are invalidated

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: ensure the signal page contains defined contents

Arnd Bergmann <arnd@arndb.de>
    kallsyms: fix nonconverging kallsyms table with lld

Alexandre Belloni <alexandre.belloni@bootlin.com>
    ARM: dts: lpc32xx: Revert set default clock rate of HCLK PLL

Lin Feng <linf@wangsu.com>
    bfq-iosched: Revert "bfq: Fix computation of shallow depth"

Alexandre Ghiti <alex@ghiti.fr>
    riscv: virt_addr_valid must check the address belongs to linear mapping

Victor Lu <victorchengchi.lu@amd.com>
    drm/amd/display: Decrement refcount of dc_sink before reassignment

Victor Lu <victorchengchi.lu@amd.com>
    drm/amd/display: Free atomic state after drm_atomic_commit

Victor Lu <victorchengchi.lu@amd.com>
    drm/amd/display: Fix dc_sink kref count in emulated_link_detect

Mikita Lipski <mikita.lipski@amd.com>
    drm/amd/display: Release DSC before acquiring

Sung Lee <sung.lee@amd.com>
    drm/amd/display: Add more Clock Sources to DCN2.1

George Shen <george.shen@amd.com>
    drm/amd/display: Fix DPCD translation for LTTPR AUX_RD_INTERVAL

Claus Stovgaard <claus.stovgaard@gmail.com>
    nvme-pci: ignore the subsysem NQN on Phison E16

Fenghua Yu <fenghua.yu@intel.com>
    x86/split_lock: Enable the split lock feature on another Alder Lake CPU

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix EEH encountering oops with NVMe traffic

Amir Goldstein <amir73il@gmail.com>
    ovl: skip getxattr of security labels

Miklos Szeredi <mszeredi@redhat.com>
    cap: fix conversions on getxattr

Miklos Szeredi <mszeredi@redhat.com>
    ovl: perform vfs_getxattr() with mounter creds

Robin Murphy <robin.murphy@arm.com>
    arm64: dts: rockchip: Disable display for NanoPi R2S

Hans de Goede <hdegoede@redhat.com>
    platform/x86: hp-wmi: Disable tablet-mode reporting by default

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: simplify GCC_PLUGINS enablement in dummy-tools/gcc

Johan Jonker <jbx6244@gmail.com>
    arm64: dts: rockchip: remove interrupt-names property from rk3399 vdec node

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix suspcious RCU usage splats for omap_enter_idle_coupled

Bjorn Andersson <bjorn.andersson@linaro.org>
    arm64: dts: qcom: sdm845: Reserve LPASS clocks in gcc

Marc Zyngier <maz@kernel.org>
    arm64: dts: rockchip: Fix PCIe DT properties on rk3399

Tony Lindgren <tony@atomide.com>
    soc: ti: omap-prm: Fix boot time errors for rst_map_012 bits 0 and 1

Seth Forshee <seth.forshee@canonical.com>
    tmpfs: disallow CONFIG_TMPFS_INODE64 on alpha

Seth Forshee <seth.forshee@canonical.com>
    tmpfs: disallow CONFIG_TMPFS_INODE64 on s390

Dave Jiang <dave.jiang@intel.com>
    dmaengine: move channel device_node deletion to driver

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Don't report ports connected if nothing is attached to them

Imre Deak <imre.deak@intel.com>
    drm/i915/tgl+: Make sure TypeC FIA is powered up when initializing it

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amd/display: Update NV1x SR latency values"

Odin Ugedal <odin@uged.al>
    cgroup: fix psi monitor for root cgroup

Julien Grall <jgrall@amazon.com>
    arm/xen: Don't probe xenbus as part of an early initcall

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix overlay frontbuffer tracking

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Check length before giving out the filter buffer

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Do not count ftrace events in top level enable output

Nikita Shubin <nikita.shubin@maquefel.me>
    gpio: ep93xx: Fix single irqchip with multi gpiochips

Nikita Shubin <nikita.shubin@maquefel.me>
    gpio: ep93xx: fix BUG_ON port F usage

Geert Uytterhoeven <geert+renesas@glider.be>
    gpio: mxs: GPIO_MXS should not default to y unconditionally

Palmer Dabbelt <palmerdabbelt@google.com>
    Revert "dts: phy: add GPIO number and active state used for phy reset"

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix seg fault with Clang non-section symbols


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/lpc32xx.dtsi                     |   3 -
 arch/arm/include/asm/kexec-internal.h              |  12 ++
 arch/arm/kernel/asm-offsets.c                      |   5 +
 arch/arm/kernel/machine_kexec.c                    |  20 +-
 arch/arm/kernel/relocate_kernel.S                  |  38 ++--
 arch/arm/kernel/signal.c                           |  14 +-
 arch/arm/mach-omap2/cpuidle44xx.c                  |  16 +-
 arch/arm/xen/enlighten.c                           |   2 -
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts         |   4 +-
 .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      |   4 +-
 arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts |   4 +
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   3 +-
 arch/arm64/kernel/cpufeature.c                     |   6 +-
 arch/arm64/kernel/mte.c                            |   3 +-
 arch/h8300/kernel/asm-offsets.c                    |   3 +
 .../riscv/boot/dts/sifive/hifive-unleashed-a00.dts |   1 -
 arch/riscv/include/asm/page.h                      |   5 +-
 arch/x86/Makefile                                  |   6 +-
 arch/x86/kernel/cpu/intel.c                        |   1 +
 arch/x86/kernel/smpboot.c                          |   1 +
 arch/x86/kvm/svm/nested.c                          |  13 +-
 arch/x86/kvm/svm/svm.h                             |   3 -
 arch/x86/kvm/x86.c                                 |   2 +
 arch/x86/pci/init.c                                |  15 +-
 arch/x86/platform/efi/efi_64.c                     |  19 --
 block/bfq-iosched.c                                |   8 +-
 drivers/clk/sunxi-ng/ccu_mp.c                      |   2 +-
 drivers/cpufreq/acpi-cpufreq.c                     | 115 +++++++++--
 drivers/dma/dmaengine.c                            |   1 -
 drivers/dma/idxd/device.c                          |  23 ++-
 drivers/dma/idxd/dma.c                             |   5 +-
 drivers/dma/idxd/idxd.h                            |   2 +-
 drivers/dma/idxd/init.c                            |   5 +-
 drivers/dma/idxd/irq.c                             |  36 +++-
 drivers/gpio/Kconfig                               |   3 +-
 drivers/gpio/gpio-ep93xx.c                         | 216 +++++++++++----------
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  22 +--
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   6 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |   6 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   4 +-
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |  10 +
 drivers/gpu/drm/drm_dp_mst_topology.c              |   1 +
 drivers/gpu/drm/i915/display/intel_overlay.c       |  17 +-
 drivers/gpu/drm/i915/display/intel_tc.c            |  67 ++++---
 drivers/gpu/drm/sun4i/sun4i_tcon.c                 |  25 +++
 drivers/gpu/drm/sun4i/sun4i_tcon.h                 |   6 +
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c              |  10 +-
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h              |   1 -
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c             |  26 +--
 drivers/gpu/drm/vc4/vc4_plane.c                    |  18 +-
 drivers/i2c/busses/i2c-stm32f7.c                   |  11 +-
 drivers/misc/lkdtm/Makefile                        |   2 +-
 drivers/misc/lkdtm/rodata.c                        |   2 +-
 drivers/net/dsa/ocelot/felix.c                     |  17 +-
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |   2 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |  59 ++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   7 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  29 ++-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  17 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  54 ++++++
 drivers/net/ethernet/mscc/ocelot_io.c              |   8 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |   7 +-
 drivers/net/hyperv/netvsc.c                        |   5 +-
 drivers/net/hyperv/rndis_filter.c                  |   2 -
 drivers/net/ipa/gsi.c                              |   1 +
 drivers/net/wan/hdlc_x25.c                         |   6 +-
 drivers/net/wireless/ath/ath9k/Kconfig             |   8 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   8 +-
 drivers/net/xen-netback/rx.c                       |   9 +-
 drivers/nvme/host/pci.c                            |   2 +
 drivers/platform/x86/hp-wmi.c                      |  14 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |   3 +
 drivers/scsi/scsi_debug.c                          |   1 +
 drivers/soc/ti/omap_prm.c                          |  11 ++
 drivers/usb/core/hcd.c                             |  11 +-
 drivers/xen/xenbus/xenbus.h                        |   1 -
 drivers/xen/xenbus/xenbus_probe.c                  |   2 +-
 fs/Kconfig                                         |   2 +-
 fs/overlayfs/copy_up.c                             |  15 +-
 fs/overlayfs/inode.c                               |   2 +
 fs/overlayfs/super.c                               |  13 +-
 include/asm-generic/vmlinux.lds.h                  |   2 +-
 include/linux/kasan.h                              |   7 +
 include/linux/netdevice.h                          |   2 +
 include/linux/uio.h                                |   8 +-
 include/net/switchdev.h                            |   2 -
 include/soc/mscc/ocelot.h                          |   2 +
 include/xen/xenbus.h                               |   2 -
 kernel/bpf/stackmap.c                              |   2 +
 kernel/cgroup/cgroup-v1.c                          |   3 +
 kernel/cgroup/cgroup.c                             |   4 +-
 kernel/trace/bpf_trace.c                           |   3 -
 kernel/trace/trace.c                               |   2 +-
 kernel/trace/trace_events.c                        |   3 +-
 lib/cpumask.c                                      |  16 +-
 lib/iov_iter.c                                     |  24 ++-
 lib/ubsan.c                                        |  31 +++
 lib/ubsan.h                                        |   6 +
 net/bridge/br_mrp.c                                |   9 +-
 net/bridge/br_mrp_switchdev.c                      |   7 +-
 net/bridge/br_private_mrp.h                        |   3 +-
 net/core/datagram.c                                |  12 +-
 net/core/dev.c                                     |  11 +-
 net/dsa/dsa2.c                                     |   7 +-
 net/mac80211/Kconfig                               |   2 +-
 net/netfilter/nf_conntrack_core.c                  |   3 +-
 net/netfilter/nf_flow_table_core.c                 |   4 +-
 net/netfilter/nf_tables_api.c                      |  25 ++-
 net/netfilter/xt_recent.c                          |  12 +-
 net/qrtr/tun.c                                     |   6 +
 net/rds/rdma.c                                     |   3 +
 net/rxrpc/call_object.c                            |   2 -
 net/sctp/proc.c                                    |  16 +-
 net/vmw_vsock/af_vsock.c                           |  15 +-
 net/vmw_vsock/hyperv_transport.c                   |   4 -
 net/vmw_vsock/virtio_transport_common.c            |   4 +-
 scripts/Makefile                                   |   1 +
 scripts/dummy-tools/gcc                            |  10 +-
 scripts/kallsyms.c                                 |   6 +
 security/commoncap.c                               |  67 ++++---
 tools/objtool/check.c                              |  11 +-
 tools/objtool/elf.c                                |  26 +++
 tools/objtool/elf.h                                |   2 +
 tools/objtool/orc_gen.c                            |  29 +--
 tools/testing/selftests/net/txtimestamp.c          |   6 +-
 tools/testing/selftests/netfilter/nft_meta.sh      |   2 +-
 127 files changed, 1080 insertions(+), 517 deletions(-)


