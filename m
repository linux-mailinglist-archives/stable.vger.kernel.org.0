Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F18313727
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbhBHPU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:20:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232618AbhBHPNh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:13:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B7F564EFA;
        Mon,  8 Feb 2021 15:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796986;
        bh=xsEcsEsXMDCSlTvwbOiMHgCyqO8KORYnHkmiVdr3lrA=;
        h=From:To:Cc:Subject:Date:From;
        b=taR+2WPXMs7jdeqQEaWPLnBMW+ENZDh4r2XCuZQlmvZxRLyJD4PcdmIyAT549TE0n
         VGH4xVTx9WT3pgKMOct2yzcifOA0aDwXHBQcGHwZoTUZlmNXRaK3bGjA8gZ1e+ZHl7
         hRBC61lShhIyLZgNuUC44fj4NtVOgiZhctpdSIA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/65] 5.4.97-rc1 review
Date:   Mon,  8 Feb 2021 16:00:32 +0100
Message-Id: <20210208145810.230485165@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.97-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.97-rc1
X-KernelTest-Deadline: 2021-02-10T14:58+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.97 release.
There are 65 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.97-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.97-rc1

Pali Rohár <pali@kernel.org>
    usb: host: xhci: mvebu: make USB 3.0 PHY optional for Armada 3720

Alexander Ovechkin <ovov@yandex-team.ru>
    net: sched: replaced invalid qdisc tree flush helper in qdisc_replace

DENG Qingfang <dqfext@gmail.com>
    net: dsa: mv88e6xxx: override existent unicast portvec in port_fdb_add

Vadim Fedorenko <vfedorenko@novek.ru>
    net: ip_tunnel: fix mtu calculation

Chinmay Agarwal <chinagar@codeaurora.org>
    neighbour: Prevent a dead entry from updating gc_list

Kai-Heng Feng <kai.heng.feng@canonical.com>
    igc: Report speed and duplex as unknown when device is runtime suspended

Xiao Ni <xni@redhat.com>
    md: Set prev_flush_start and flush_bio in an atomic way

Nadav Amit <namit@vmware.com>
    iommu/vt-d: Do not use flush-queue when caching-mode is on

Benjamin Valentin <benpicco@googlemail.com>
    Input: xpad - sync supported devices with fork on GitHub

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: mvm: don't send RFH_QUEUE_CONFIG_CMD with no queues

Dave Hansen <dave.hansen@linux.intel.com>
    x86/apic: Add extra serialization for non-serializing MSRs

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/build: Disable CET instrumentation in the kernel

Hugh Dickins <hughd@google.com>
    mm: thp: fix MADV_REMOVE deadlock on shmem THP

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

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: footbridge: fix dc21285 PCI configuration accessors

Sean Christopherson <seanjc@google.com>
    KVM: x86: Update emulator context mode if SYSENTER xfers to 64-bit mode

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Treat SVM as unsupported when running as an SEV guest

Thorsten Leemhuis <linux@leemhuis.info>
    nvme-pci: avoid the deepest sleep state on Kingston A2000 SSDs

Stylon Wang <stylon.wang@amd.com>
    drm/amd/display: Revert "Fix EDID parsing after resume from suspend"

Fengnan Chang <fengnanchang@gmail.com>
    mmc: core: Limit retries when analyse of SDIO tuples fails

Pavel Shilovsky <pshilov@microsoft.com>
    smb3: fix crediting for compounding when only one request in flight

Gustavo A. R. Silva <gustavoars@kernel.org>
    smb3: Fix out-of-bounds bug in SMB2_negotiate()

Aurelien Aptel <aaptel@suse.com>
    cifs: report error instead of invalid when revalidating a dentry fails

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix bounce buffer usage for non-sg list case

Marc Zyngier <maz@kernel.org>
    genirq/msi: Activate Multi-MSI early when MSI_FLAG_ACTIVATE_EARLY is set

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/dimm: Avoid race between probe and available_slots_show()

Wang ShaoBo <bobo.shaobowang@huawei.com>
    kretprobe: Avoid re-registration of the same kretprobe earlier

Steven Rostedt (VMware) <rostedt@goodmis.org>
    fgraph: Initialize tracing_graph_pause at task creation

Felix Fietkau <nbd@nbd.name>
    mac80211: fix station rate table updates on assoc

Liangyan <liangyan.peng@linux.alibaba.com>
    ovl: fix dentry leak in ovl_get_redirect

Peter Chen <peter.chen@nxp.com>
    usb: host: xhci-plat: add priv quirk for skip PHY initialization

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

Dan Carpenter <dan.carpenter@oracle.com>
    USB: gadget: legacy: fix an error code in eth_bind()

Roman Gushchin <guro@fb.com>
    memblock: do not start bottom-up allocations with kernel_end

Sagi Grimberg <sagi@grimberg.me>
    nvmet-tcp: fix out-of-bounds access when receiving multiple h2cdata PDUs

Hermann Lauer <Hermann.Lauer@uni-heidelberg.de>
    ARM: dts: sun7i: a20: bananapro: Fix ethernet phy-mode

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix WoL on shutdown if CONFIG_DEBUG_SHIRQ is set

Stefan Chulski <stefanc@marvell.com>
    net: mvpp2: TCAM entry enable should be written after SRAM data

Xie He <xie.he.0141@gmail.com>
    net: lapb: Copy the skb before sending a packet

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Fix leak upon failure of rule creation

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    i40e: Revert "i40e: don't report link up for a VF who hasn't enabled queues"

Kevin Lo <kevlo@kevlo.org>
    igc: check return value of ret_val in igc_config_fc_after_link_up

Kevin Lo <kevlo@kevlo.org>
    igc: set the default return value to -IGC_ERR_NVM in igc_write_nvm_srwr

Zyta Szpak <zr@semihalf.com>
    arm64: dts: ls1046a: fix dcfg address range

David Howells <dhowells@redhat.com>
    rxrpc: Fix deadlock around release of dst cached on udp tunnel

Johannes Berg <johannes.berg@intel.com>
    um: virtio: free vu_dev only with the contained struct device

Loris Reiff <loris.reiff@liblor.ch>
    bpf, cgroup: Fix problematic bounds check

Loris Reiff <loris.reiff@liblor.ch>
    bpf, cgroup: Fix optlen WARN_ON_ONCE toctou

Sandy Huang <hjc@rock-chips.com>
    arm64: dts: rockchip: fix vopl iommu irq on px30

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    arm64: dts: amlogic: meson-g12: Set FL-adj property value

Alexey Dobriyan <adobriyan@gmail.com>
    Input: i8042 - unbreak Pegatron C15B

Shawn Guo <shawn.guo@linaro.org>
    arm64: dts: qcom: c630: keep both touchpad devices enabled

Christoph Schemmel <christoph.schemmel@gmail.com>
    USB: serial: option: Adding support for Cinterion MV31

Chenxin Jin <bg4akv@hotmail.com>
    USB: serial: cp210x: add new VID/PID for supporting Teraoka AD2000

Pho Tran <Pho.Tran@silabs.com>
    USB: serial: cp210x: add pid/vid for WSDA-200-USB


-------------

Diffstat:

 Makefile                                           |  10 +-
 arch/arm/boot/dts/sun7i-a20-bananapro.dts          |   2 +-
 arch/arm/mach-footbridge/dc21285.c                 |  12 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |   2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi     |   2 +-
 .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      |  10 +-
 arch/arm64/boot/dts/rockchip/px30.dtsi             |   2 +-
 arch/um/drivers/virtio_uml.c                       |   3 +-
 arch/x86/Makefile                                  |   3 +
 arch/x86/include/asm/apic.h                        |  10 --
 arch/x86/include/asm/barrier.h                     |  18 +++
 arch/x86/kernel/apic/apic.c                        |   4 +
 arch/x86/kernel/apic/x2apic_cluster.c              |   6 +-
 arch/x86/kernel/apic/x2apic_phys.c                 |   9 +-
 arch/x86/kvm/emulate.c                             |   2 +
 arch/x86/kvm/svm.c                                 |   5 +
 arch/x86/mm/mem_encrypt.c                          |   1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   2 -
 drivers/input/joystick/xpad.c                      |  17 ++-
 drivers/input/serio/i8042-x86ia64io.h              |   2 +
 drivers/iommu/intel-iommu.c                        |   6 +
 drivers/md/md.c                                    |   2 +
 drivers/mmc/core/sdio_cis.c                        |   6 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  13 +--
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   1 -
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |   3 +-
 drivers/net/ethernet/intel/igc/igc_i225.c          |   3 +-
 drivers/net/ethernet/intel/igc/igc_mac.c           |   2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c     |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   5 +
 drivers/net/ethernet/realtek/r8169_main.c          |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   9 +-
 drivers/nvdimm/dimm_devs.c                         |  18 ++-
 drivers/nvme/host/pci.c                            |   2 +
 drivers/nvme/target/tcp.c                          |   3 +-
 drivers/usb/class/usblp.c                          |  19 +--
 drivers/usb/dwc2/gadget.c                          |   8 +-
 drivers/usb/dwc3/core.c                            |   2 +-
 drivers/usb/gadget/legacy/ether.c                  |   4 +-
 drivers/usb/host/xhci-mtk-sch.c                    | 130 +++++++++++++++------
 drivers/usb/host/xhci-mtk.c                        |   2 +
 drivers/usb/host/xhci-mtk.h                        |  15 +++
 drivers/usb/host/xhci-mvebu.c                      |  42 +++++++
 drivers/usb/host/xhci-mvebu.h                      |   6 +
 drivers/usb/host/xhci-plat.c                       |  26 ++++-
 drivers/usb/host/xhci-plat.h                       |   1 +
 drivers/usb/host/xhci-ring.c                       |  31 +++--
 drivers/usb/host/xhci.c                            |   8 +-
 drivers/usb/host/xhci.h                            |   5 +
 drivers/usb/renesas_usbhs/fifo.c                   |   1 +
 drivers/usb/serial/cp210x.c                        |   2 +
 drivers/usb/serial/option.c                        |   6 +
 fs/afs/main.c                                      |   6 +-
 fs/cifs/dir.c                                      |  22 +++-
 fs/cifs/smb2pdu.h                                  |   2 +-
 fs/cifs/transport.c                                |  18 ++-
 fs/hugetlbfs/inode.c                               |   3 +-
 fs/overlayfs/dir.c                                 |   2 +-
 include/linux/hugetlb.h                            |   2 +
 include/linux/msi.h                                |   6 +
 include/net/sch_generic.h                          |   2 +-
 init/init_task.c                                   |   3 +-
 kernel/bpf/cgroup.c                                |   7 +-
 kernel/irq/msi.c                                   |  44 ++++---
 kernel/kprobes.c                                   |   4 +
 kernel/trace/fgraph.c                              |   2 -
 mm/compaction.c                                    |   3 +-
 mm/huge_memory.c                                   |  37 +++---
 mm/hugetlb.c                                       |  48 +++++++-
 mm/memblock.c                                      |  49 +-------
 net/core/neighbour.c                               |   7 +-
 net/ipv4/ip_tunnel.c                               |  16 ++-
 net/lapb/lapb_out.c                                |   3 +-
 net/mac80211/driver-ops.c                          |   5 +-
 net/mac80211/rate.c                                |   3 +-
 net/rxrpc/af_rxrpc.c                               |   6 +-
 77 files changed, 558 insertions(+), 265 deletions(-)


