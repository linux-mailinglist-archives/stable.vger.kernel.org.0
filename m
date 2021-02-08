Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CD23137E3
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbhBHPc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:32:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233661AbhBHPVk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:21:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59F6D64EF9;
        Mon,  8 Feb 2021 15:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797220;
        bh=D916X6R+mycM1+44DCuCRfcJKNjRYFnRQsgI08gc+wM=;
        h=From:To:Cc:Subject:Date:From;
        b=uZorO1roqt3rb6w9B2OWlfkHZhsSi6IkLnTwqpB4TyKeuXFCIZnLN9b0o0/kOu2Hl
         tanFubOHY/8hiqxcVszOYZQStAQCGV0aKnTndQqvPwPj/nOq3kaXl8x8zCtM8/vCPM
         uwoAzVzmvxu+hLVWkvDMQ8C39YGkcoxHDSJtxmVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 5.10 000/120] 5.10.15-rc1 review
Date:   Mon,  8 Feb 2021 15:59:47 +0100
Message-Id: <20210208145818.395353822@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.10.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.15-rc1
X-KernelTest-Deadline: 2021-02-10T14:58+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.15 release.
There are 120 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.15-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.15-rc1

Alexander Ovechkin <ovov@yandex-team.ru>
    net: sched: replaced invalid qdisc tree flush helper in qdisc_replace

DENG Qingfang <dqfext@gmail.com>
    net: dsa: mv88e6xxx: override existent unicast portvec in port_fdb_add

Dongseok Yi <dseok.yi@samsung.com>
    udp: ipv4: manipulate network header of NATed UDP GRO fraglist

Vadim Fedorenko <vfedorenko@novek.ru>
    net: ip_tunnel: fix mtu calculation

Chinmay Agarwal <chinagar@codeaurora.org>
    neighbour: Prevent a dead entry from updating gc_list

Kai-Heng Feng <kai.heng.feng@canonical.com>
    igc: Report speed and duplex as unknown when device is runtime suspended

Xiao Ni <xni@redhat.com>
    md: Set prev_flush_start and flush_bio in an atomic way

Marek Vasut <marex@denx.de>
    Input: ili210x - implement pressure reporting for ILI251x

Benjamin Valentin <benpicco@googlemail.com>
    Input: xpad - sync supported devices with fork on GitHub

AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
    Input: goodix - add support for Goodix GT9286 chip

Dave Hansen <dave.hansen@linux.intel.com>
    x86/apic: Add extra serialization for non-serializing MSRs

Lai Jiangshan <laijs@linux.alibaba.com>
    x86/debug: Prevent data breakpoints on cpu_dr7

Lai Jiangshan <laijs@linux.alibaba.com>
    x86/debug: Prevent data breakpoints on __per_cpu_offset

Peter Zijlstra <peterz@infradead.org>
    x86/debug: Fix DR6 handling

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/build: Disable CET instrumentation in the kernel

Waiman Long <longman@redhat.com>
    mm/filemap: add missing mem_cgroup_uncharge() to __add_to_page_cache_locked()

Hugh Dickins <hughd@google.com>
    mm: thp: fix MADV_REMOVE deadlock on shmem THP

Rick Edgecombe <rick.p.edgecombe@intel.com>
    mm/vmalloc: separate put pages and flush VM flags

Rokudo Yan <wu-yan@tcl.com>
    mm, compaction: move high_pfn to the for loop scope

Muchun Song <songmuchun@bytedance.com>
    mm: hugetlb: remove VM_BUG_ON_PAGE from page_huge_active

Muchun Song <songmuchun@bytedance.com>
    mm: hugetlb: fix a race between isolating and freeing page

Muchun Song <songmuchun@bytedance.com>
    mm: hugetlb: fix a race between freeing and dissolving the page

Muchun Song <songmuchun@bytedance.com>
    mm: hugetlbfs: fix cannot migrate the fallocated HugeTLB page

Dmitry Osipenko <digetx@gmail.com>
    ARM: 9043/1: tegra: Fix misplaced tegra_uart_config in decompressor

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: footbridge: fix dc21285 PCI configuration accessors

H. Nikolaus Schaller <hns@goldelico.com>
    ARM: dts; gta04: SPI panel chip select is active low

H. Nikolaus Schaller <hns@goldelico.com>
    DTS: ARM: gta04: remove legacy spi-cs-high to make display work again

Sean Christopherson <seanjc@google.com>
    KVM: x86: Set so called 'reserved CR3 bits in LM mask' at vCPU reset

Sean Christopherson <seanjc@google.com>
    KVM: x86: Update emulator context mode if SYSENTER xfers to 64-bit mode

Michael Roth <michael.roth@amd.com>
    KVM: x86: fix CPUID entries returned by KVM_GET_CPUID2 ioctl

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even if tsx=off

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: Fix TDP MMU zap collapsible SPTEs

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Treat SVM as unsupported when running as an SEV guest

Thorsten Leemhuis <linux@leemhuis.info>
    nvme-pci: avoid the deepest sleep state on Kingston A2000 SSDs

Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
    io_uring: don't modify identity's files uncess identity is cowed

Stylon Wang <stylon.wang@amd.com>
    drm/amd/display: Revert "Fix EDID parsing after resume from suspend"

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Power up combo PHY lanes for for HDMI as well

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Extract intel_ddi_power_up_lanes()

Andres Calderon Jaramillo <andrescj@chromium.org>
    drm/i915/display: Prevent double YUV range correction on HDR planes

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Close race between enable_breadcrumbs and cancel_breadcrumbs

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gem: Drop lru bumping on display unpinning

Imre Deak <imre.deak@intel.com>
    drm/i915: Fix the MST PBN divider calculation

Imre Deak <imre.deak@intel.com>
    drm/dp/mst: Export drm_dp_get_vc_payload_bw()

Peter Gonda <pgonda@google.com>
    Fix unsynchronized access to sev members through svm_register_enc_region

Fengnan Chang <fengnanchang@gmail.com>
    mmc: core: Limit retries when analyse of SDIO tuples fails

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: sdhci-pltfm: Fix linking err for sdhci-brcmstb

Pavel Shilovsky <pshilov@microsoft.com>
    smb3: fix crediting for compounding when only one request in flight

Gustavo A. R. Silva <gustavoars@kernel.org>
    smb3: Fix out-of-bounds bug in SMB2_negotiate()

Joerg Roedel <jroedel@suse.de>
    iommu: Check dev->iommu in dev_iommu_priv_get() before dereferencing it

Aurelien Aptel <aaptel@suse.com>
    cifs: report error instead of invalid when revalidating a dentry fails

Atish Patra <atish.patra@wdc.com>
    RISC-V: Define MAXPHYSMEM_1GB only for RV32

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix bounce buffer usage for non-sg list case

Rolf Eike Beer <eb@emlix.com>
    scripts: use pkg-config to locate libcrypto

Marc Zyngier <maz@kernel.org>
    genirq/msi: Activate Multi-MSI early when MSI_FLAG_ACTIVATE_EARLY is set

Hans de Goede <hdegoede@redhat.com>
    genirq: Prevent [devm_]irq_alloc_desc from returning irq 0

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/dimm: Avoid race between probe and available_slots_show()

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/namespace: Fix visibility of namespace resource attribute

Alexey Kardashevskiy <aik@ozlabs.ru>
    tracepoint: Fix race between tracing and removing tracepoint

Viktor Rosendahl <Viktor.Rosendahl@bmw.de>
    tracing: Use pause-on-trace with the latency tracers

Wang ShaoBo <bobo.shaobowang@huawei.com>
    kretprobe: Avoid re-registration of the same kretprobe earlier

Masami Hiramatsu <mhiramat@kernel.org>
    tracing/kprobe: Fix to support kretprobe events on unloaded modules

Steven Rostedt (VMware) <rostedt@goodmis.org>
    fgraph: Initialize tracing_graph_pause at task creation

Quanyang Wang <quanyang.wang@windriver.com>
    gpiolib: free device name on error path to fix kmemleak

Felix Fietkau <nbd@nbd.name>
    mac80211: fix station rate table updates on assoc

Sargun Dhillon <sargun@sargun.me>
    ovl: implement volatile-specific fsync error behaviour

Miklos Szeredi <mszeredi@redhat.com>
    ovl: avoid deadlock on directory ioctl

Liangyan <liangyan.peng@linux.alibaba.com>
    ovl: fix dentry leak in ovl_get_redirect

Mario Limonciello <mario.limonciello@dell.com>
    thunderbolt: Fix possible NULL pointer dereference in tb_acpi_add_link()

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: fix duplicated flags in DEBUG_CFLAGS

Roman Gushchin <guro@fb.com>
    memblock: do not start bottom-up allocations with kernel_end

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Restore the hardware used index after change map

Sagi Grimberg <sagi@grimberg.me>
    nvmet-tcp: fix out-of-bounds access when receiving multiple h2cdata PDUs

Hermann Lauer <Hermann.Lauer@uni-heidelberg.de>
    ARM: dts: sun7i: a20: bananapro: Fix ethernet phy-mode

Dan Carpenter <dan.carpenter@oracle.com>
    net: ipa: pass correct dma_handle to dma_free_coherent()

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix WoL on shutdown if CONFIG_DEBUG_SHIRQ is set

Stefan Chulski <stefanc@marvell.com>
    net: mvpp2: TCAM entry enable should be written after SRAM data

Xie He <xie.he.0141@gmail.com>
    net: lapb: Copy the skb before sending a packet

Maor Dickman <maord@nvidia.com>
    net/mlx5e: Release skb in case of failure in tc update skb

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Update max_opened_tc also when channels are closed

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Fix leak upon failure of rule creation

Daniel Jurgens <danielj@nvidia.com>
    net/mlx5: Fix function calculation for page trees

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: device remove has higher precedence over reset

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    i40e: Revert "i40e: don't report link up for a VF who hasn't enabled queues"

Kevin Lo <kevlo@kevlo.org>
    igc: check return value of ret_val in igc_config_fc_after_link_up

Kevin Lo <kevlo@kevlo.org>
    igc: set the default return value to -IGC_ERR_NVM in igc_write_nvm_srwr

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix NFS READs that start at non-page-aligned offsets

Zyta Szpak <zr@semihalf.com>
    arm64: dts: ls1046a: fix dcfg address range

David Howells <dhowells@redhat.com>
    rxrpc: Fix deadlock around release of dst cached on udp tunnel

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: work around RTL8125 UDP hw bug

Marek Szyprowski <m.szyprowski@samsung.com>
    arm64: dts: meson: switch TFLASH_VDD_EN pin to open drain on Odroid-C4

Quentin Monnet <quentin@isovalent.com>
    bpf, preload: Fix build when $(O) points to a relative path

Johannes Berg <johannes.berg@intel.com>
    um: virtio: free vu_dev only with the contained struct device

Pan Bian <bianpan2016@163.com>
    bpf, inode_storage: Put file handler if no storage was found

Loris Reiff <loris.reiff@liblor.ch>
    bpf, cgroup: Fix problematic bounds check

Loris Reiff <loris.reiff@liblor.ch>
    bpf, cgroup: Fix optlen WARN_ON_ONCE toctou

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Fix memory key MTT population

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Fix GPIO hog flags on DHCOM DRC02

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Disable optional TSC2004 on DRC02 board

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Disable WP on DHCOM uSD slot

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Connect card-detect signal on DHCOM

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Fix polarity of the DH DRC02 uSD card detect

Simon South <simon@simonsouth.net>
    arm64: dts: rockchip: Use only supported PCIe link speed on Pinebook Pro

Sandy Huang <hjc@rock-chips.com>
    arm64: dts: rockchip: fix vopl iommu irq on px30

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    arm64: dts: amlogic: meson-g12: Set FL-adj property value

Alexey Dobriyan <adobriyan@gmail.com>
    Input: i8042 - unbreak Pegatron C15B

Shawn Guo <shawn.guo@linaro.org>
    arm64: dts: qcom: c630: keep both touchpad devices enabled

Linus Walleij <linus.walleij@linaro.org>
    ARM: OMAP1: OSK: fix ohci-omap breakage

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: break loop when find the endpoint to drop

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: skip dropping bandwidth of unchecked endpoints

Ikjoon Jang <ikjn@chromium.org>
    usb: xhci-mtk: fix unreleased bandwidth data

Gary Bisson <gary.bisson@boundarydevices.com>
    usb: dwc3: fix clock issue during resume in OTG mode

Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
    usb: dwc2: Fix endpoint direction check in ep_from_windex

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: renesas_usbhs: Clear pipe running flag in usbhs_pkt_pop()

Jeremy Figgins <kernel@jeremyfiggins.com>
    USB: usblp: don't call usb_set_interface if there's a single alt

kernel test robot <lkp@intel.com>
    usb: gadget: aspeed: add missing of_node_put

Dan Carpenter <dan.carpenter@oracle.com>
    USB: gadget: legacy: fix an error code in eth_bind()

Pali Rohár <pali@kernel.org>
    usb: host: xhci: mvebu: make USB 3.0 PHY optional for Armada 3720

Christoph Schemmel <christoph.schemmel@gmail.com>
    USB: serial: option: Adding support for Cinterion MV31

Chenxin Jin <bg4akv@hotmail.com>
    USB: serial: cp210x: add new VID/PID for supporting Teraoka AD2000

Pho Tran <Pho.Tran@silabs.com>
    USB: serial: cp210x: add pid/vid for WSDA-200-USB


-------------

Diffstat:

 Documentation/filesystems/overlayfs.rst            |   8 ++
 Makefile                                           |  14 +--
 arch/arm/boot/dts/omap3-gta04.dtsi                 |   3 +-
 arch/arm/boot/dts/stm32mp15xx-dhcom-drc02.dtsi     |  12 +-
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi       |   3 +-
 arch/arm/boot/dts/sun7i-a20-bananapro.dts          |   2 +-
 arch/arm/include/debug/tegra.S                     |  54 ++++-----
 arch/arm/mach-footbridge/dc21285.c                 |  12 +-
 arch/arm/mach-omap1/board-osk.c                    |   2 +
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |   2 +-
 .../arm64/boot/dts/amlogic/meson-sm1-odroid-c4.dts |   2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi     |   2 +-
 .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      |  10 +-
 arch/arm64/boot/dts/rockchip/px30.dtsi             |   2 +-
 .../boot/dts/rockchip/rk3399-pinebook-pro.dts      |   1 -
 arch/riscv/Kconfig                                 |   2 +
 arch/um/drivers/virtio_uml.c                       |   3 +-
 arch/x86/Makefile                                  |   3 +
 arch/x86/include/asm/apic.h                        |  10 --
 arch/x86/include/asm/barrier.h                     |  18 +++
 arch/x86/kernel/apic/apic.c                        |   4 +
 arch/x86/kernel/apic/x2apic_cluster.c              |   6 +-
 arch/x86/kernel/apic/x2apic_phys.c                 |   9 +-
 arch/x86/kernel/hw_breakpoint.c                    |  61 ++++++----
 arch/x86/kvm/cpuid.c                               |   2 +-
 arch/x86/kvm/emulate.c                             |   2 +
 arch/x86/kvm/mmu/tdp_mmu.c                         |   6 +-
 arch/x86/kvm/svm/sev.c                             |  17 +--
 arch/x86/kvm/svm/svm.c                             |   5 +
 arch/x86/kvm/vmx/vmx.c                             |  17 ++-
 arch/x86/kvm/x86.c                                 |  27 +++--
 arch/x86/mm/mem_encrypt.c                          |   1 +
 drivers/gpio/gpiolib.c                             |  10 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   2 -
 drivers/gpu/drm/drm_dp_mst_topology.c              |  24 +++-
 drivers/gpu/drm/i915/display/intel_ddi.c           |  37 +++---
 drivers/gpu/drm/i915/display/intel_display.c       |   9 +-
 drivers/gpu/drm/i915/display/intel_dp_mst.c        |   4 +-
 drivers/gpu/drm/i915/display/intel_overlay.c       |   4 +-
 drivers/gpu/drm/i915/display/intel_sprite.c        |  65 ++---------
 drivers/gpu/drm/i915/gem/i915_gem_domain.c         |  45 -------
 drivers/gpu/drm/i915/gem/i915_gem_object.h         |   1 -
 drivers/gpu/drm/i915/gt/intel_breadcrumbs.c        |   6 +-
 drivers/input/joystick/xpad.c                      |  17 ++-
 drivers/input/serio/i8042-x86ia64io.h              |   2 +
 drivers/input/touchscreen/goodix.c                 |   2 +
 drivers/input/touchscreen/ili210x.c                |  26 +++--
 drivers/md/md.c                                    |   2 +
 drivers/mmc/core/sdio_cis.c                        |   6 +
 drivers/mmc/host/sdhci-pltfm.h                     |   7 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   6 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   5 -
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  13 +--
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   1 -
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |   3 +-
 drivers/net/ethernet/intel/igc/igc_i225.c          |   3 +-
 drivers/net/ethernet/intel/igc/igc_mac.c           |   2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c     |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  16 ++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   5 +
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   2 +-
 drivers/net/ethernet/realtek/r8169_main.c          |  75 ++++++++++--
 drivers/net/ipa/gsi.c                              |   2 +-
 drivers/nvdimm/dimm_devs.c                         |  18 ++-
 drivers/nvdimm/namespace_devs.c                    |  10 +-
 drivers/nvme/host/pci.c                            |   2 +
 drivers/nvme/target/tcp.c                          |   3 +-
 drivers/thunderbolt/acpi.c                         |   2 +-
 drivers/usb/class/usblp.c                          |  19 +--
 drivers/usb/dwc2/gadget.c                          |   8 +-
 drivers/usb/dwc3/core.c                            |   2 +-
 drivers/usb/gadget/legacy/ether.c                  |   4 +-
 drivers/usb/gadget/udc/aspeed-vhub/hub.c           |   4 +-
 drivers/usb/host/xhci-mtk-sch.c                    | 130 +++++++++++++++------
 drivers/usb/host/xhci-mtk.c                        |   2 +
 drivers/usb/host/xhci-mtk.h                        |  15 +++
 drivers/usb/host/xhci-mvebu.c                      |  42 +++++++
 drivers/usb/host/xhci-mvebu.h                      |   6 +
 drivers/usb/host/xhci-plat.c                       |  20 +++-
 drivers/usb/host/xhci-plat.h                       |   1 +
 drivers/usb/host/xhci-ring.c                       |  31 +++--
 drivers/usb/host/xhci.c                            |   8 +-
 drivers/usb/host/xhci.h                            |   4 +
 drivers/usb/renesas_usbhs/fifo.c                   |   1 +
 drivers/usb/serial/cp210x.c                        |   2 +
 drivers/usb/serial/option.c                        |   6 +
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                 |   1 +
 drivers/vdpa/mlx5/core/mr.c                        |  28 ++---
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  18 +++
 fs/afs/main.c                                      |   6 +-
 fs/cifs/dir.c                                      |  22 +++-
 fs/cifs/smb2pdu.h                                  |   2 +-
 fs/cifs/transport.c                                |  18 ++-
 fs/hugetlbfs/inode.c                               |   3 +-
 fs/io_uring.c                                      |   6 -
 fs/overlayfs/dir.c                                 |   2 +-
 fs/overlayfs/file.c                                |   5 +-
 fs/overlayfs/overlayfs.h                           |   1 +
 fs/overlayfs/ovl_entry.h                           |   2 +
 fs/overlayfs/readdir.c                             |  28 ++---
 fs/overlayfs/super.c                               |  34 ++++--
 fs/overlayfs/util.c                                |  27 +++++
 include/drm/drm_dp_mst_helper.h                    |   1 +
 include/linux/hugetlb.h                            |   2 +
 include/linux/iommu.h                              |   5 +-
 include/linux/irq.h                                |   4 +-
 include/linux/kprobes.h                            |   2 +-
 include/linux/msi.h                                |   6 +
 include/linux/tracepoint.h                         |  12 +-
 include/linux/vmalloc.h                            |   9 +-
 include/net/sch_generic.h                          |   2 +-
 include/net/udp.h                                  |   2 +-
 init/init_task.c                                   |   3 +-
 kernel/bpf/bpf_inode_storage.c                     |   6 +-
 kernel/bpf/cgroup.c                                |   7 +-
 kernel/bpf/preload/Makefile                        |   5 +-
 kernel/irq/msi.c                                   |  44 ++++---
 kernel/kprobes.c                                   |  36 ++++--
 kernel/trace/fgraph.c                              |   2 -
 kernel/trace/trace_irqsoff.c                       |   4 +
 kernel/trace/trace_kprobe.c                        |  10 +-
 mm/compaction.c                                    |   3 +-
 mm/filemap.c                                       |   4 +
 mm/huge_memory.c                                   |  37 +++---
 mm/hugetlb.c                                       |  48 +++++++-
 mm/memblock.c                                      |  49 +-------
 net/core/neighbour.c                               |   7 +-
 net/ipv4/ip_tunnel.c                               |  16 ++-
 net/ipv4/udp_offload.c                             |  69 ++++++++++-
 net/ipv6/udp_offload.c                             |   2 +-
 net/lapb/lapb_out.c                                |   3 +-
 net/mac80211/driver-ops.c                          |   5 +-
 net/mac80211/rate.c                                |   3 +-
 net/rxrpc/af_rxrpc.c                               |   6 +-
 net/sunrpc/svcsock.c                               |   7 +-
 scripts/Makefile                                   |   8 +-
 137 files changed, 1106 insertions(+), 606 deletions(-)


